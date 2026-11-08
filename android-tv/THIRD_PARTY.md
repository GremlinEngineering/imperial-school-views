# Components and artwork

- `vendor/dec-0.1.2.jar`: org.brotli:dec 0.1.2, MIT, runtime Brotli decoding. License: `app/src/main/assets/brotli-LICENSE.txt`. Primary source: https://github.com/google/brotli
- `vendor/test-json-20240303.jar`: org.json:json 20240303, Public Domain as declared by the embedded Maven POM. Used only by host tests; not bundled in the APK. Android supplies org.json. Primary source: https://github.com/stleary/JSON-java
- Oswald, Literata, PT Mono: SIL Open Font License 1.1. Complete notices in `app/src/main/assets/*-OFL.txt`. The fonts match the website and existing Android application.
- Accepted TV/gamepad icon: generated for this project and approved by the author. Original in `artwork/`; provenance in `artwork/provenance.json`. Icon and derived launcher banner are provided for Imperial School Views; CC BY-NC 4.0, attribution Дмитрий Малыхин aka Timon_Crazy. https://creativecommons.org/licenses/by-nc/4.0/
- `docs/site-style-reference.css`: project website CSS, saved as a design reference. It is not included in the APK. Source: https://games.oopssre.ru/assets/style.css
- Test JSON fixtures are snapshots of the project's published catalogue and weather/dynamic APIs. No wallpaper image archive is bundled.

Android SDK build tools and platform are external build dependencies, subject to the Android SDK licenses. They are not redistributed in this source archive.

## Runtime components in 0.8.7

- AndroidX Media3 1.8.1 (ExoPlayer and HLS), Apache License 2.0. Source: https://github.com/androidx/media
- The APK includes Game Music Emu and the blargg S-DSP core for theme music. Their license notices are included in the APK as `libgme-LICENSE.txt` and `snes_spc-LICENSE.txt`.

## Music added in 0.2.0

Seven bundled FM recordings, not commercial film/game soundtracks. Complete
attribution and scope are in `music/CREDITS.txt` and the APK's music credits.
Strauss/Nikos Kouremenos: CC BY-SA 4.0; Bach/Pierre Pouillon: CC BY-SA 3.0.
Mozart/Mike Blackstock and Beethoven/Peter Samuelson/Chris Sawer source MIDI:
Public Domain; those FM recordings: CC BY 4.0. Berlioz source composition:
Public Domain; FM theme variations: CC BY 4.0. Hanson (14 seconds) and
Khachaturian (21 seconds) are brief musical quotations only; underlying works
retain their copyright and are not relicensed by this project. Full protected
scores and third-party recordings are not redistributed.

The six-channel YM2612 VGM renderer is included under the project's MIT code
license. Audio export uses external FFmpeg with libgme; neither binary is
bundled in the application. Android MediaPlayer plays the resulting MP3.
Python authoring requires `mido`. These are authoring dependencies, not APK
runtime dependencies.

## Teahouse music added in0.3.0

Nine short instrumental quotations of the explicitly selected compositions,
15–21seconds each. Underlying works by Alan Menken, Joe Hisaishi and Robert
Amirkhanyan retain their copyright; no full songs, lyrics, full reference MIDI
or external recordings are redistributed. Source editions, window boundaries
and exact scope: music/teahouse/CREDITS.txt.

The original synthetic instrument bank and offline register scheduler are
project-authored; no SNES game sample bank was ripped. The unmodified
blargg snes_spc0.9.0 S-DSP core is LGPL2.1-or-later, Copyright Shay Green;
complete source and notice: music/teahouse/dsp_core/. This is an authoring
component only; neither the emulator core nor the compiler is in the APK.
The offline scheduler writes DSP registers, without a SPC700 CPU emulator.

## Source-only HEVC test fixtures

The two silent Orbital Port MP4 fixtures in tests/android/assets/video are included only in the source/instrumentation test project, not in the production APK. They use the approved artistic sketch and authored Orbital Port layers, by Дмитрий Малыхин aka Timon_Crazy, CC BY-NC 4.0. FFmpeg/libx265 were authoring tools and are not bundled in the APK. Production video is loaded from the selected theme's published metadata; music keeps its separate credits above.
