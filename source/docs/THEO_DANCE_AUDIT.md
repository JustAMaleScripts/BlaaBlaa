# Theo dance-method audit

Sources reviewed:

- [Choose Legacy.lua](https://github.com/Solary-3/Scripts/blob/main/Choose%20Legacy.lua), blob `d6e9f80aff5a55cd79d3fd4f0891aa2b8d108591`
- [ToolDance.lua](https://github.com/Solary-3/Scripts/blob/main/ToolDance.lua), blob `a6478cce5a333c42a6469d1c835a50b8fa06c853`
- [Legacy.lua](https://github.com/Solary-3/Scripts/blob/main/Legacy.lua), blob `80af2509997cd9a4cd32d085f13d20200b00200f`

## Provenance boundary

`Choose Legacy.lua` is a UI loader. Its “New” button downloads `ToolDance.lua`, while “Legacy” downloads an obfuscated `Legacy.lua`. The repository has no published `LICENSE` file, and the current UI credits identify the project as made by Theo and state “All Rights Reserved.”

For that reason, the AnimLib additions are clean-room implementations of observable behavior. No Theo source code, dance keyframes, asset IDs, audio, user tags, UI, or downloaded modules are included.

## Reusable concepts implemented

| Theo branch behavior | AnimLib implementation |
| --- | --- |
| Named-keyframe notification | `Track.Markers`, `MarkerReached`, and `GetMarkerReachedSignal` |
| Non-loop completion notification | `Animator.Finished` and `OnFinished` |
| Per-joint blacklist/whitelist | `Animator:SetJointMask` |
| `LoadSequence` / `LoadAnimation` entry points | Safe local `Animator:LoadSequence` and `Animator:LoadAnimation` methods |
| Internal pose sampling | `Animator:GetPose` / `GetPoses` and `Track.getPoses` |
| `Filter` / `FilterType` naming | `SetFilter`, `ClearFilter`, and `Configure` aliases |
| Animation fade behavior | `FadeTo`, `FadeIn`, and `FadeOut` |
| Music-position animation timing | `SyncToSound` and `ClearSoundSync` |
| Sequential non-looped emotes | `AnimLib.DanceQueue` |
| Independent animation timing | One clock per `Animator` and one managed animator per queue |
| Cached animation parsing | Existing `Track.fromfilecached` |
| User-facing playback configuration | Uhhhhhh's `Animation Options` page and `AnimLib.Settings` defaults |

The marker importer also follows Roblox's native structure by reading `Keyframe:GetMarkers()` when converting a `KeyframeSequence`.

## Deliberately excluded

- Remote `loadstring` dance downloads and locally cached executable Lua files.
- The obfuscated legacy branch.
- Reanimation selection, simulation-radius changes, respawn signals, and fling configuration.
- User-specific billboard tags, clipboard writes, notifications, and CoreGui interfaces.
- Tool/backpack replacement and dance keybind pages.
- Camera field-of-view changes driven by audio loudness.
- Bundled dance assets, music files, props, and asset IDs.
- Character collision, transparency, camera, and fake-rig management.

These are application-level or executor-level behaviors rather than reusable animation methods. Uhhhhhh's existing module system can build presentation and asset management around the generic APIs without embedding Theo's loader.

## Behavioral differences

- AnimLib markers are explicit track data and do not rely on a fixed time-tolerance polling window.
- AnimLib fade operations adjust the animator's blend weight instead of recreating Theo's final-frame fade table.
- `DanceQueue` reports structured completion reasons and exposes explicit pause, resume, skip, clear, bind, and destroy methods.
- Sound synchronization is opt-in per animator or queue item and does not alter camera field of view or global music state.
- AnimLib does not implicitly cancel separate animator objects by priority; use a state machine or `DanceQueue` when playback must be mutually exclusive.
