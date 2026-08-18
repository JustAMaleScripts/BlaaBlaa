# Uhhhhhh fork audit and merge

This review compares the requested forks with the current `STEVE-916-create/Uhhhhhh` `main` branch and with AnimLib v1.4.5 before the merge. That fork merge introduced AnimLib v1.5.0; later feature patches may report a newer version.

## Result

The merge keeps the current Uhhhhhh interface, Sakura default, animation/music speed controls, sitting controls, hitbox toggle, and existing branding. It imports compatible community modules and asset fixes. It does not replace the current source with an old or broken fork.

| Fork | Git diff against upstream | What it added | Merge decision |
| --- | ---: | --- | --- |
| [`airy-one-1/Uhhhhhh-but-more-anims`](https://github.com/airy-one-1/Uhhhhhh-but-more-anims) | 17 commits ahead, 434 behind; `source/reanim.lua` +1583/-1065 | Genesis-style UI/source rewrite, `i miss the quiet`, and a large SM64 moveset appended after an existing `return` | Merged the usable short dance asset URLs into Airy's marketplace module. Rejected the source rewrite and SM64 block. |
| [`BananaMan19t/Uhhhhhh-more-emotes`](https://github.com/BananaMan19t/Uhhhhhh-more-emotes) | 2 ahead, 349 behind | Six standalone dances: Bouncin, Dare, Doomer, Eyes Closed, Low Cortisol, Spoken For | These dances already exist in the newer Valtta marketplace pack included here. The malformed Doomer asset list is repaired there, avoiding duplicate dance names. |
| [`Spazmatizm6/Uhhhhhh`](https://github.com/Spazmatizm6/Uhhhhhh) | 9 ahead, 357 behind | Five of BananaMan19t's modules plus copied binary assets | No duplicate module merge. The current package uses the maintained direct-download assets in Valtta's pack. |
| [`xunq-dev/reanimation-v5`](https://github.com/xunq-dev/reanimation-v5) | 7 ahead, 0 behind | UI/song changes and a reduced `DEEPSEEK.LUA` source variant | Rejected. Both edited source variants contain invalid Luau replacements such as `math.floor(/` and remove current features. |
| [`TheEGodOfficial/Uhhhhhh-but-with-CurrentAngleV4`](https://github.com/TheEGodOfficial/Uhhhhhh-but-with-CurrentAngleV4) | 2 ahead, 33 behind; `source/reanim.lua` +167/-14 | CurrentAngle-style hidden-property helpers and Animator removal | Not copied verbatim. The current AnimLib already has guarded `SetMotor6DTransform`, hidden-replication fallback, and rig-mapping methods; the fork's conversion helper is never called and its Animator watcher disconnects after one insertion. |

## Airy source findings

The useful `v_dance2.lua` change is the short **i miss the quiet** dance. The same commit also changes the existing Lux dance to load `imissthequiet.anim`; that looks accidental and was not merged.

The appended SM64 module was excluded because it:

- appears after an earlier `return modules`, making the placement unreliable;
- downloads and executes multiple remote scripts with `loadstring`;
- references unresolved names including `player`, `limits`, `Core`, and `isDebug`;
- would replace a large amount of current behavior instead of adding an isolated animation method.

## Community-module merge

The repaired addon sources are now under `community/` at the paths used by `community/list.txt`. They include the previously reviewed GeometryRunC, nilsbin, Theo, Airy, Valtta, Noober, Memeili, GooglyEyes, Awes, and Bhop modules.

Airy's short **i miss the quiet** animation and sound use the fork's direct raw GitHub URLs. Its full-version assets still use `MARKET/zipfileairysport/...` and therefore must exist in the repository's matching community asset directory.

## Validation boundary

The merged Lua files were syntax-checked and scanned for obvious remote-code execution hooks. Roblox/executor-only behavior, binary `.rbxm` content, asset availability, and hidden-property support still require an in-game executor test.
