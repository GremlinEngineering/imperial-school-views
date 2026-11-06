"""Public-domain Berlioz theme plus two explicitly short musical quotations.
Quotes are not complete works. Source and exact scope are recorded in CREDITS.
"""
from pathlib import Path
import mido
ROOT=Path(__file__).resolve().parent/'source';ROOT.mkdir(exist_ok=True)
N={'C':0,'D':2,'E':4,'F':5,'G':7,'A':9,'B':11}
def pitch(s):
 if isinstance(s,int):return s
 return 12*(int(s[-1])+1)+N[s[0]]+(-1 if 'b' in s else 1 if '#' in s else 0)
def midi(name,tempo,melody,chords,comment):
 events=[];time=0
 for note,duration in melody:
  if note:
   n=pitch(note);events.extend([(round(time*480),mido.Message('note_on',channel=0,note=n,velocity=75)),(round((time+duration*.94)*480),mido.Message('note_off',channel=0,note=n,velocity=0))])
  time+=duration
 for start,dur,notes in chords:
  for i,n in enumerate(notes):
   ch=2 if i==0 else 1;nn=pitch(n);events.extend([(round(start*480),mido.Message('note_on',channel=ch,note=nn,velocity=48)),(round((start+dur*.92)*480),mido.Message('note_off',channel=ch,note=nn,velocity=0))])
 m=mido.MidiFile(ticks_per_beat=480);track=mido.MidiTrack();m.tracks.append(track);track.append(mido.MetaMessage('text',text=comment));track.append(mido.MetaMessage('set_tempo',tempo=mido.bpm2tempo(tempo)));last=0
 for tick,msg in sorted(events,key=lambda row:(row[0],row[1].type=='note_on')):msg.time=tick-last;track.append(msg);last=tick
 track.append(mido.MetaMessage('end_of_track',time=max(0,round(time*480)-last)));m.save(ROOT/name)
 return time
# Berlioz: original 1863 vocal score, pp. 204, first two vocal phrases.
# Tenor treble notation sounds one octave lower. Ties are consolidated.
phrase=[(None,1.5),('F3',.5),('D4',1),('C4',.5),('Bb3',.5),('G4',1.5),('F4',.5),('D4',1.5),('Eb4',.5),('C4',3),('Bb3',2),(None,3.5),('F3',.5),('Eb4',1),('C4',.5),('Bb3',.5),('F4',2),('G4',.5),('F4',.5),('D4',1.5),('Eb4',.5),('C4',3),('Bb3',2),(None,2)]
span=sum(x[1] for x in phrase);melody=phrase*3
chords=[]
for rep in range(3):
 for beat in range(0,int(span),2):
  root=['Bb2','G2','Eb2','F2'][(beat//8)%4];upper={'Bb2':['F3','Bb3'],'G2':['D3','Bb3'],'Eb2':['G3','Bb3'],'F2':['A3','C4']}[root]
  chords.append((rep*span+beat,1.85,[root]+upper))
midi('berlioz_vallon_theme.mid',84,melody,chords,'Berlioz, Vallon sonore: first two vocal phrases, original Choudens vocal score p.204; three FM variations, original accompaniment.')
# Hanson: exactly the first three bars of the string melody in the signed
# Interlochen presentation score. No continuation or complete symphony.
hanson=[('F4',2),('F4',1),('F4',1),('F4',1/3),('Gb4',1/3),('Ab4',1/3),('F4',3),('F4',2),('F4',1),('F4',1)]
midi('hanson_interlochen_quote.mid',64,hanson,[(0,4,['Db2','Ab2','Db3']),(4,4,['Bb1','F2','Db3']),(8,4,['Gb2','Bb2','Db3'])],'Howard Hanson Symphony No.2: opening three bars of Interlochen string melody only, short musical quotation. Underlying work retains its copyright.')
# Khachaturian: opening fourteen notes only, no continuation/repeat.
gayane=[('Bb3',2),('Db4',1),('Eb4',1),('F4',2),('F4',1),('Gb4',.5),('Eb4',1.5),('F4',.5),('Db4',1.5),('Eb4',1),('Eb4',1),('C4',1),('C4',.5),('Db4',2.5)]
midi('gayane_adagio_quote.mid',56,gayane,[(0,4,['Bb1','F2','Db3']),(4,4,['Gb2','Bb2','Db3']),(8,4,['Eb2','Bb2','Gb3']),(12,5,['Bb1','F2','Db3'])],'Aram Khachaturian Gayane Adagio: opening fourteen melody notes only, brief FM quotation. Reference R.M.Buchanan 2025 tab, first three bars. Underlying work retains its copyright.')
print('Created three score fragments; Berlioz phrase beats',span)
