# Dance-module timing audit

This audit covers the bundled `content/v_dance1.lua` plus all nine supplied module files. The review classified every `Animator:Step`, `animator.speed`, `GetOverrideDanceMusicTime`, and dance-music speed call rather than assuming every dance uses the same clock.

## Timing patterns found

| File | Music-time reads | Explicit animator speeds | Clock-driven steps | Main pattern |
| --- | ---: | ---: | ---: | --- |
| `content/v_dance1.lua` | 24 | 10 | 13 | Mixed music-time, clock-time, offsets, maps, and multi-track dances |
| `awesthealter1.dances.lua` | 1 | 1 | 0 | Music-time driven |
| `Memeili.dance.lua` | 0 | 2 | 2 | Clock driven |
| `googlyeyes.allinone.lua` | 0 | 32 | 32 | Clock driven; every dance sets its own speed |
| `nilsbin.allinone.lua` | 7 | 17 | 17 | Mixed and sometimes duplicated update definitions |
| `noobersdances.noobersdance.lua` | 0 | 105 | 105 | Clock driven; every dance assigns `animator.speed = 1` |
| `theosdances.SomeRandomModule.lua.txt` | 28 | 31 | 31 | Mixed clock/music variants and duplicated update definitions |
| `valttaportslop.allinone.lua` | 1 | 17 | 18 | Primarily clock driven |
| `zipfileairysport.v_dance3.lua` | 2 | 1 | 1 | Mixed clock/music timing |
| `GeometryRunC.moveset.lua` | 0 | 0 | 0 | Moveset without AnimLib dance timing |

## Root cause

AnimLib v1.4.1 stored the menu value in a new animator's `speed` field. Many modules then assigned `animator.speed = 1` or another calibration value during `Init`, replacing that menu value. Caramelldansen did not replace it, which explains why the option worked there but not consistently elsewhere.

## v1.4.2 behavior

- The menu speed is a separate live global multiplier.
- A module's own `animator.speed` remains an intrinsic calibration and is multiplied by the global value.
- **Apply Speed To Music** optionally applies the same global value to dance audio.
- A module's own `SetOverrideDanceMusicSpeed` remains the audio calibration underneath the global value.
- Music-clock steps are detected by comparing their input-time delta with both the dance sound's delta and the corresponding real-clock delta, so enabling audio speed does not double-apply the multiplier to animation time. This avoids misclassifying dances that read music time only for effects while animating from `os.clock()`, while retaining non-linear music-time poses.
- Modules can explicitly opt out through `UseGlobalPlaybackSpeed = false`.

No supplied dance module needs to be rewritten for the global multiplier fix.
