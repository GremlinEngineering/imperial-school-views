# Orbital FM soundtrack

Seven bundled MP3s are in `app/src/main/assets/music/`. Credits and each
fragment's precise scope are in `CREDITS.txt`; measured durations and voice
allocation are in `render-report.json`. Five arrangements/theme variations
and two brief musical quotations, not seven complete classical works.

`source/` retains the attributed MIDI, LilyPond where available, VGM output,
and original public-domain Mozart MIDI archive. Full protected Hanson and
Khachaturian scores, modern orchestral recordings and temporary PCM WAVs
are excluded. The two quotes contain no continuation/repeat of those works.

To reproduce VGM and MP3:

```sh
python3 -m pip install mido
# FFmpeg must include the libgme demuxer and libmp3lame encoder.
python3 music/render_ym2612.py
```

Outputs go to `music/rendered/`. The renderer uses six YM2612 hardware FM
voices, 44.1kHz synthesis, -23 LUFS export and MP3 VBR quality2. Its three
patch roles provide melody, harmony/organ and bass. Voice stealing is
reported (Mozart6, Beethoven21); no unlimited software voices are hidden
behind the six-channel claim. A4 register tuning was checked at 440Hz.

`make_short_scores.py` reconstructs the explicitly limited manual score
fragments, including the public-domain Berlioz theme. It does not transcribe
complete protected compositions. The MP3 files play using Android's normal
MediaPlayer; the TV app does not run the Python renderer or download a VGM
player. Site streaming/caching will be a separate later integration.
