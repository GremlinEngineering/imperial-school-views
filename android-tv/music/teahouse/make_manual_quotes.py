"""Two short, visually checked score quotations only, with new accompaniment.
Part of Your World: preview of Mona Rejino's educational piano arrangement,
chorus opening, bars5-11. Ostavaysya: tigr1620 preview, opening3 bars.
Underlying compositions retain their copyright. No full song is encoded.
"""
from pathlib import Path
import mido
ROOT=Path(__file__).resolve().parent/'source'
P={'C':0,'D':2,'E':4,'F':5,'G':7,'A':9,'B':11}
def pitch(s):return 12*(int(s[-1])+1)+P[s[0]]+(-1 if 'b' in s else 1 if '#' in s else 0)
def write(name,bpm,melody,chords):
 m=mido.MidiFile(ticks_per_beat=960);track=mido.MidiTrack();m.tracks.append(track);track.append(mido.MetaMessage('set_tempo',tempo=mido.bpm2tempo(bpm)));events=[];at=0
 for note,duration in melody:
  if note:events.extend([(round(at*960),mido.Message('note_on',channel=0,note=pitch(note),velocity=80)),(round((at+duration*.94)*960),mido.Message('note_off',channel=0,note=pitch(note),velocity=0))])
  at+=duration
 for start,duration,ns in chords:
  for n in ns:events.extend([(round(start*960),mido.Message('note_on',channel=1,note=pitch(n),velocity=48)),(round((start+duration*.92)*960),mido.Message('note_off',channel=1,note=pitch(n),velocity=0))])
 last=0
 for tick,msg in sorted(events,key=lambda row:(row[0],row[1].type=='note_on')):msg.time=tick-last;track.append(msg);last=tick
 m.save(ROOT/name)
part=[('F4',1),('F4',.5),('F4',.5),('F4',1),('G4',.5),('A4',.5),('C4',1),('C4',1),('C4',2),('C4',1),('C4',.5),('C4',.5),('C4',1),('D4',.5),('F4',.5),('C4',1),('D4',1),('F4',1),('G4',1),('F4',1/3),('F4',1/3),('F4',1/3),('F4',1),('F4',.5),('G4',.5),('A4',1),('C4',.5),('C4',.5),('C4',1),('C4',.5),('D4',.5),('F4',1),('G4',4)]
write('01_part.mid',96,part,[(0,4,['F2','C3','A3']),(4,4,['A2','E3','C4']),(8,4,['Bb2','F3','D4']),(12,4,['G2','D3','Bb3']),(16,4,['C2','G3','E4']),(20,4,['F2','C3','A3']),(24,4,['C2','G3','E4'])])
stay=[(None,2.5),('C5',.5),('B4',.5),('C5',.5),(None,.5),('C5',.5),('B4',.5),('C5',.5),(None,.5),('C5',.5),('B4',.5),('C5',.5),('Db5',.5),('C5',.5),('B4',.5),('C5',.5),('Bb4',.5),('Ab4',.5),('G4',.5),('Ab4',.5)]
write('06_stay.mid',56,stay,[(0,4,['F2','C3','Ab3']),(4,4,['F2','C3','Ab3']),(8,4,['Db2','Ab2','F3'])])
print('Two limited manual quotations prepared')
