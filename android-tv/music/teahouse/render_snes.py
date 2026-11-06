"""Render explicitly short score quotations using the actual SNES S-DSP.
The offline register scheduler and original synthetic instrument bank are MIT.
The unmodified DSP core is LGPL-2.1+. No ripped game samples or film audio.
"""
from pathlib import Path
import struct,math,json,subprocess,collections,itertools
import numpy as np
import mido
ROOT=Path(__file__).resolve().parent;RATE=32000;OUT=ROOT/'rendered';OUT.mkdir(exist_ok=True)

def predict(f,p1,p2):
 p2=p2>>1
 if f==1:return (p1>>1)+((-p1)>>5)
 if f==2:return p1-p2+(p2>>4)+((p1*-3)>>6)
 if f==3:return p1-p2+((p1*-13)>>7)+((p2*3)>>4)
 return 0

def encode_brr(pcm):
 pcm=np.asarray(pcm,dtype=np.int32);p1=p2=0;result=bytearray()
 for start in range(0,len(pcm),16):
  best=None
  for f in ([0] if start==0 else range(4)):
   for shift in range(13):
    a,b=p1,p2;err=0;ns=[];unit=2**(shift-1)
    for target in pcm[start:start+16]:
     pred=predict(f,a,b);q=max(-8,min(7,round((int(target)/2-pred)/unit)));value=((q<<shift)>>1)+pred;value=max(-32768,min(32767,value));value=((value*2+32768)&65535)-32768
     err+=(int(target)-value)**2;ns.append(q&15);b,a=a,value
    candidate=(err,shift,f,ns,a,b)
    if best is None or err<best[0]:best=candidate
  _,shift,f,ns,p1,p2=best;flags=3 if start+16==len(pcm) else 0;result.append(shift<<4|f<<2|flags)
  result.extend((ns[i]<<4)|ns[i+1] for i in range(0,16,2))
 return bytes(result)

def bank():
 t=np.arange(128)/64*2*np.pi
 waves=[np.sin(t)+.3*np.sin(2*t)+.17*np.sin(3*t)+.08*np.sin(5*t),np.sin(t)+.12*np.sin(2*t)+.035*np.sin(3*t),sum(np.sin(k*t)/k**1.5 for k in range(1,10)),np.sin(t)+.18*np.sin(2*t),np.sin(t)+.22*np.sin(5*t)+.10*np.sin(7*t)]
 ram=bytearray(65536);address=0x2000
 for i,w in enumerate(waves):
  encoded=encode_brr(np.round(w/max(abs(w))*18000));struct.pack_into('<HH',ram,0x1000+i*4,address,address);ram[address:address+len(encoded)]=encoded;address+=len(encoded)
 return ram,address-0x2000

def read_notes(path):
 m=mido.MidiFile(path);events=[]
 for track,t in enumerate(m.tracks):
  at=0
  for order,msg in enumerate(t):at+=msg.time;events.append((at,track,order,msg))
 now=0;last=0;tempo=500000;pending=collections.defaultdict(collections.deque);notes=[]
 for tick,track,order,msg in sorted(events,key=lambda x:(x[0],x[1],x[2])):
  now+=mido.tick2second(tick-last,m.ticks_per_beat,tempo);last=tick
  if msg.type=='set_tempo':tempo=msg.tempo
  elif msg.type=='note_on' and msg.velocity:pending[(track,msg.channel,msg.note)].append((now,msg.velocity))
  elif msg.type=='note_off' or msg.type=='note_on' and not msg.velocity:
   key=(track,msg.channel,msg.note)
   if pending[key]:
    a,v=pending[key].popleft();notes.append(dict(a=a,b=now,n=msg.note,v=v,c=msg.channel,track=track))
 return sorted(notes,key=lambda x:(x['a'],x['n']))

def extract(spec):
 clipped=ROOT/'source'/(spec['id']+'.mid')
 if clipped.exists():
  rows=read_notes(clipped)
  for x in rows:x['role']={0:'lead',1:'chord',2:'bass'}[x['c']]
  return rows
 original=read_notes(ROOT/'reference'/spec['source']);start=spec['start'];end=start+spec['seconds'];rows=[]
 for x in original:
  if not start<=x['a']<end:continue
  if spec.get('channels') is not None and x['c'] not in spec['channels']:continue
  if x['c']==9:continue
  y=dict(x,a=(x['a']-start)*spec.get('scale',1)+.15,b=(min(x['b'],end)-start)*spec.get('scale',1)+.15)
  if y['b']-y['a']<.03:continue
  y['n']=max(24,min(90,y['n']));rows.append(y)
 for x in rows:
  if 'lead_channel' in spec:islead=x['c']==spec['lead_channel']
  elif 'lead_track' in spec:islead=x['track']==spec['lead_track'] and x['n']>=58
  else:islead=x['n']>=58 and x['n']==max(n['n'] for n in rows if abs(n['a']-x['a'])<.035)
  x['role']='lead' if islead else 'bass' if x['n']<51 else 'chord'
 return rows

def save_excerpt(name,rows):
 # Save only the quoted notes, never the complete protected reference MIDI.
 m=mido.MidiFile(ticks_per_beat=1000);tr=mido.MidiTrack();m.tracks.append(tr);tr.append(mido.MetaMessage('set_tempo',tempo=1000000));events=[]
 for x in rows:
  ch={'lead':0,'bass':2,'chord':1}[x['role']];events.extend([(round(x['a']*1000),mido.Message('note_on',note=x['n'],velocity=x['v'],channel=ch)),(round(x['b']*1000),mido.Message('note_off',note=x['n'],velocity=0,channel=ch))])
 last=0
 for tick,msg in sorted(events,key=lambda r:(r[0],r[1].type=='note_on')):msg.time=tick-last;tr.append(msg);last=tick
 m.save(ROOT/'source'/(name+'.mid'))

def render(spec):
 rows=extract(spec);assert rows;save_excerpt(spec['id'],rows);ram,brrbytes=bank();events=[]
 def reg(at,addr,value):events.append((round(at*RATE),addr,value&255))
 # No software reverb: the hardware's echo ring and FIR perform the effect.
 for addr,val in [(0x6c,0x20),(0x0c,100),(0x1c,100),(0x2c,18),(0x3c,18),(0x0d,32),(0x2d,0),(0x3d,0),(0x4d,255),(0x5d,0x10),(0x6d,0xd0),(0x7d,4)]:reg(0,addr,val)
 for i,val in enumerate([0x50,0x20,0x08,0,0,0,0,0]):reg(0,0x0f+i*16,val)
 reg(.005,0x6c,0)
 active={};voice=[None]*8;stolen=0;peak=0;koffs=0
 schedule=[]
 for uid,x in enumerate(rows):schedule.extend([(x['a'],1,uid,x),(x['b'],0,uid,x)])
 for at,on,uid,x in sorted(schedule,key=lambda e:(e[0],e[1],e[2])):
  if not on:
   ch=active.pop(uid,None)
   if ch is not None:
    koffs|=1<<ch;reg(at,0x5c,koffs);voice[ch]=None
   continue
  free=[i for i,v in enumerate(voice) if v is None]
  if free:ch=free[0]
  else:
   # Preserve the lead when reducing piano chords to the eight hardware voices.
   ch=min(range(8),key=lambda i:(voice[i][2]=='lead',voice[i][1]));active.pop(voice[ch][0],None);reg(at-.0001,0x5c,koffs|1<<ch);stolen+=1
  koffs&=~(1<<ch);reg(at,0x5c,koffs)
  role=x['role'];sample=spec.get('lead_sample',1) if role=='lead' else 3 if role=='bass' else 0 if spec.get('plucked_chords',True) else 2
  volume=(70 if role=='lead' else 46 if role=='bass' else 29)*max(.45,min(1.15,x['v']/85));pan=0 if role=='bass' else (-.13 if role=='lead' else -.32 if ch%2 else .32)
  for offset,val in [(0,round(volume*(1-pan))),(1,round(volume*(1+pan))),(4,sample),(5,[0xdf,0x8b,0x89,0x8e,0xff][sample]),(6,[0x28,0xe0,0xc8,0xa8,0x08][sample])]:reg(at,ch*16+offset,val)
  pitch=round(4096*440*2**((x['n']-69)/12)/500);pitch=max(1,min(0x3fff,pitch));reg(at,ch*16+2,pitch&255);reg(at,ch*16+3,pitch>>8);reg(at,ch*16+7,0);reg(at,0x4c,1<<ch)
  active[uid]=ch;voice[ch]=(uid,at,role);peak=max(peak,len(active))
 duration=max(x['b'] for x in rows)+2.5;reg(duration-1.0,0x5c,255);total=math.ceil(duration*RATE);events.sort(key=lambda x:x[0]);merged=[]
 for at,group in itertools.groupby(events,key=lambda x:x[0]):
  kon=0
  for event in group:
   if event[1]==0x4c:kon|=event[2]
   else:merged.append(event)
  if kon:merged.append((at,0x4c,kon))
 events=merged;trace=ROOT/'source'/(spec['id']+'.snes-registers');wav=OUT/(spec['id']+'.wav');mp3=OUT/(spec['id']+'.mp3')
 with trace.open('wb') as f:
  f.write(b'ISVSNES1'+struct.pack('<II',len(events),total)+ram)
  for at,addr,val in events:f.write(struct.pack('<IBB',max(0,at),addr,val))
 subprocess.run([str(ROOT/'dsp_render'),str(trace),str(wav)],check=True)
 subprocess.run(['ffmpeg','-v','error','-nostdin','-y','-i',str(wav),'-af',f'afade=t=in:d=0.18,afade=t=out:st={duration-1}:d=1,loudnorm=I=-23:TP=-3:LRA=9','-ar','32000','-c:a','libmp3lame','-q:a','2','-metadata','title='+spec['title']+' — SNES, краткий фрагмент','-metadata','composer='+spec['composer'],'-metadata','artist=Дмитрий Малыхин aka Timon_Crazy — SNES arrangement',str(mp3)],check=True)
 report=dict(spec,output=mp3.name,duration=round(duration,3),bytes=mp3.stat().st_size,note_count=len(rows),peak_hardware_voices=peak,stolen_notes=stolen,brr_bytes=brrbytes,chip='Sony S-DSP',sample_rate=32000,echo='S-DSP FIR, 4 units/64ms',scope='short instrumental quotation only')
 print(json.dumps(report,ensure_ascii=False),flush=True);return report
if __name__=='__main__':
 specs=json.loads((ROOT/'tracks.json').read_text());reports=[render(x) for x in specs];(OUT/'render-report.json').write_text(json.dumps(reports,ensure_ascii=False,indent=2))
