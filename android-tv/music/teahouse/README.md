# Teahouse SNES fragments

Nine explicitly short instrumental quotations, not full songs. CREDITS.txt
records composer, film, reference edition, source window and exact scope.
Only the clipped notes are redistributed here; complete reference MIDI,
commercial recordings and browser score screenshots are excluded.

The original instrument bank is generated procedurally and BRR encoded.
The unmodified blargg snes_spc0.9.0 S-DSP core supplies hardware envelopes,
Gaussian interpolation, eight voice slots and FIR echo at32kHz. No SPC700
CPU is used: the offline scheduler writes DSP registers. .snes-registers
is a local reproducibility format, not an SPC file or a server contract.

To reproduce (Python3+mido+numpy, FFmpeg/libmp3lame, C++17 compiler):

```sh
cd music/teahouse
g++ -std=c++17 -O2 -DNDEBUG dsp_render.cpp dsp_core/SPC_DSP.cpp -o dsp_render
python3 render_snes.py
```

The script uses the short source/*.mid files and creates rendered/*.mp3,
WAV and register traces. The exact original clipping parameters remain in
tracks.json for attribution; they are not applied again to clipped MIDI.
The two manually checked fragments are recorded in make_manual_quotes.py.

Driver/instrument generator: project MIT. DSP core: LGPL2.1-or-later;
full notice in dsp_core/LICENSE. Underlying songs retain their copyright.

For a byte-exact PCM replay of the saved hardware stream, use:

```sh
./dsp_render source/04_path_of_the_wind_snes.snes-registers replay.wav
```

The MIDI path may differ by sub-millisecond quantization when regenerated;
the stored register traces retain the precise original sample timestamps.
