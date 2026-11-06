"""Create genuine six-channel YM2612 VGM arrangements from attributed score MIDI.
No recorded orchestral audio is used. Requires mido and FFmpeg with libgme.
"""
from pathlib import Path
import mido,struct,math,subprocess,json
ROOT=Path(__file__).resolve().parent;OUT=ROOT/'rendered';OUT.mkdir(exist_ok=True)
CLOCK=7670454;RATE=44100

def notes(path):
 m=mido.MidiFile(path);tempo=500000;now=0;pending={};rows=[]
 for msg in mido.merge_tracks(m.tracks):
  now+=mido.tick2second(msg.time,m.ticks_per_beat,tempo)
  if msg.type=='set_tempo':tempo=msg.tempo
  if msg.type=='note_on' and msg.velocity:
   pending[(msg.channel,msg.note)]=(now,msg.velocity)
  elif msg.type=='note_off' or msg.type=='note_on' and not msg.velocity:
   key=(msg.channel,msg.note)
   if key in pending:
    start,vel=pending.pop(key);rows.append((start,now,msg.note,vel,msg.channel))
 return sorted(rows),now

class VGM:
 def __init__(self):self.data=bytearray();self.at=0;self.state=[None]*6;self.release=[-1.0]*6;self.stolen=0
 def reg(self,ch,addr,value):self.data.extend([0x52+(ch//3),addr+(ch%3),value])
 def direct(self,addr,value):self.data.extend([0x52,addr,value])
 def wait(self,seconds):
  dest=round(seconds*RATE);left=max(0,dest-self.at)
  while left:
   n=min(left,65535);self.data.extend(b'\x61'+struct.pack('<H',n));left-=n
  self.at=dest
 def off(self,ch):self.direct(0x28,(ch%3)+(4 if ch>=3 else 0))
 def patch(self,ch,role,variation):
  # Algorithm 4: two FM pairs. Carrier slots are indices 2 and 3 in register order.
  self.reg(ch,0xB0,0x0c);self.reg(ch,0xB4,0xc0)
  levels={'lead':[49,53,30,33],'chord':[58,61,42,45],'bass':[55,60,30,34],'organ':[60,64,32,36]}
  tl=levels[role]
  mul=[1,2,1,1] if variation%2==0 else [2,3,1,1]
  for op in range(4):
   off=4*op
   self.reg(ch,0x30+off,mul[op]);self.reg(ch,0x40+off,tl[op])
   self.reg(ch,0x50+off,0x17 if role=='organ' else 0x1b)
   self.reg(ch,0x60+off,0x02 if role=='organ' else 0x07)
   self.reg(ch,0x70+off,0x00 if role=='organ' else 0x02)
   self.reg(ch,0x80+off,0x28);self.reg(ch,0x90+off,0)
 def on(self,ch,note,role,variation):
  self.off(ch);self.patch(ch,role,variation)
  block=max(0,min(7,(note-12)//12));freq=440*2**((note-69)/12)
  fnum=round(freq*144*1048576/(CLOCK*2**(block-1)))
  while fnum>2047 and block<7:block+=1;fnum=round(freq*144*1048576/(CLOCK*2**(block-1)))
  self.reg(ch,0xA4,((block&7)<<3)|((fnum>>8)&7));self.reg(ch,0xA0,fnum&255)
  self.direct(0x28,0xf0|(ch%3)|(4 if ch>=3 else 0))
 def write(self,path,title,composer):
  self.data.append(0x66);header=bytearray(0x100);header[:4]=b'Vgm '
  struct.pack_into('<I',header,8,0x170);struct.pack_into('<I',header,0x18,self.at)
  struct.pack_into('<I',header,0x2c,CLOCK);struct.pack_into('<I',header,0x34,0x100-0x34)
  fields=[title,'','Imperial School Views TV','','YM2612','',''+composer,'','2026','Дмитрий Малыхин aka Timon_Crazy','Six-channel YM2612 arrangement. Score source and fragment scope: music/CREDITS.txt.']
  body=('\0'.join(fields)+'\0').encode('utf-16le');gd3=b'Gd3 '+struct.pack('<II',0x100,len(body))+body
  struct.pack_into('<I',header,0x14,len(header)+len(self.data)-0x14);struct.pack_into('<I',header,4,len(header)+len(self.data)+len(gd3)-4)
  path.write_bytes(header+self.data+gd3)

def render(name,source,title,composer,kind,loops,scale):
 base,span=notes(ROOT/'source'/source);score=[];gap=.5
 for rep in range(loops):
  start=rep*(span*scale+gap)
  for a,b,n,v,c in base:
   role=(('lead' if c==0 else 'bass' if n<48 else 'chord') if kind=='waltz' else ('lead' if c==1 else 'bass' if c==3 else 'organ') if kind=='chorale' else ('bass' if n<48 else 'lead' if c==0 else 'organ'))
   score.append((start+a*scale,start+b*scale,n,role,rep))
 events=[]
 for uid,(a,b,n,role,variation) in enumerate(score):events.extend([(a,1,uid,n,role,variation),(b,0,uid,n,role,variation)])
 v=VGM();v.direct(0x22,0);v.direct(0x27,0);v.direct(0x2b,0)
 allocated={}
 for at,is_on,uid,note,role,variation in sorted(events):
  v.wait(at)
  if not is_on:
   ch=allocated.pop(uid,None)
   if ch is not None:v.off(ch);v.state[ch]=None;v.release[ch]=at
  else:
   free=[i for i in range(6) if v.state[i] is None]
   if not free:
    # Never exceeds six simultaneous hardware voices; steal oldest only if needed.
    ch=min(range(6),key=lambda i:v.state[i][1]);old=v.state[ch][0];allocated.pop(old,None);v.stolen+=1
   else:ch=min(free,key=lambda i:v.release[i])
   v.on(ch,note,role,variation);v.state[ch]=(uid,at);allocated[uid]=ch
 duration=round(max(x[1] for x in score)+3,3);v.wait(duration);vgm=OUT/(name+'.vgm');v.write(vgm,title,composer)
 wav=OUT/(name+'.wav');mp3=OUT/(name+'.mp3')
 subprocess.run(['ffmpeg','-nostdin','-y','-v','error','-f','libgme','-i',str(vgm),'-t',str(duration),'-ar','44100','-c:a','pcm_s16le',str(wav)],check=True)
 subprocess.run(['ffmpeg','-nostdin','-y','-v','error','-i',str(wav),'-af','highpass=f=35,lowpass=f=11500,loudnorm=I=-23:TP=-3:LRA=9','-ar','44100','-c:a','libmp3lame','-q:a','2','-metadata','title='+title,'-metadata','artist=Дмитрий Малыхин aka Timon_Crazy — FM arrangement','-metadata','composer='+composer,str(mp3)],check=True)
 probe=json.loads(subprocess.check_output(['ffprobe','-v','error','-show_entries','format=duration,size,bit_rate','-of','json',str(mp3)]))['format']
 result={'file':mp3.name,'title':title,'composer':composer,'duration':float(probe['duration']),'bytes':int(probe['size']),'voices':6,'stolen_notes':v.stolen,'source':source,'cycles':loops,'time_scale':scale}
 print(json.dumps(result,ensure_ascii=False),flush=True);return result
if __name__ == "__main__":
 rows=[
  render('01_blue_danube_fm','blue_danube.mid','Голубой Дунай — орбитальный вальс, FM-вариации','Johann Strauss II','waltz',4,1.15),
  render('02_bwv639_fm','bwv639.mid','Бах BWV 639 — тихая орбита, FM-аранжировка','Johann Sebastian Bach','chorale',1,1.32),
  render('03_mozart_romanze_fm','MozartWA-KV525-mov-02.mid','Моцарт — Маленькая ночная серенада, II. Romanze, FM','Wolfgang Amadeus Mozart','strings',1,1.05),
  render('04_beethoven_pathetique_i_fm','pathetique-1.mid','Бетховен — Патетическая соната, I, FM','Ludwig van Beethoven','waltz',1,1.05),
  render('05_berlioz_vallon_theme_fm','berlioz_vallon_theme.mid','Берлиоз — Vallon sonore, тема, FM-вариации','Hector Berlioz','strings',1,1),
  render('06_hanson_romantic_quote_fm','hanson_interlochen_quote.mid','Гансон — Романтическая симфония, краткая FM-цитата','Howard Hanson','strings',1,1),
  render('07_gayane_adagio_quote_fm','gayane_adagio_quote.mid','Хачатурян — Гаянэ, краткая FM-цитата','Aram Khachaturian','strings',1,1),
 ]
 (OUT/'render-report.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2))
