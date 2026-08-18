# Archived CurrentAngle audit

Sources reviewed:

- [CurrentAngle V2 archive supplied by the user](https://pastebin.com/raw/dvSbWhwj)
- [Archived ScriptBlox entry](https://scriptblox.com/script/Universal-Script-Currentangle-v2-archived-243719)
- [CurrentAngleV4 repository](https://github.com/somethingsimade/CurrentAngleV4)

## License notice

The archive identifies its reanimation implementation as MIT-licensed:

```text
Licensed under the MIT License (see LICENSE file for full details).
Copyright (c) 2025 MrY7zz

LEGAL NOTICE:
You are REQUIRED to retain this license header under the terms of the MIT License.
Removing or modifying this notice may violate copyright law.
```

That notice is retained in `source/reanim.lua` immediately above `AnimLib.RigMapper`, whose safe pose-mapping concept was adapted from the archive. The implementation in this patch was written for AnimLib and uses only ordinary `Motor6D.Transform` operations.

## What the archive actually does

The archived script creates or clones a local character rig, maps real R6 joints to fake-rig parts, and updates that mapping during the simulation cycle. Its central joint path converts a target part's relative `CFrame` through the original `Motor6D.C0` and `C1`, then writes the result through hidden replication properties. It also handles transparency, collision, respawning, camera state, default scripts, and optional R15 visuals.

It is not a track parser, animation editor, blend tree, or locomotion state machine. Those features remain native additions in Uhhhhhh's extended AnimLib.

## Ideas adapted safely

| Archive concept | AnimLib implementation | Boundary |
| --- | --- | --- |
| Explicit simulation update phase | `Animator:Bind`, `StateMachine:Bind`, and `RigMapper:Bind` | Supported public `RunService` signals only |
| `C0`/`C1` world-pose conversion | `AnimLib.Motor6D.SolveWorldTransform` and `RigMapper` `WorldCFrame` mode | Pose calculation and application only |
| Joint/limb mapping | `AnimLib.RigMapper` aliases and R6/R15 major-joint presets | Ordinary script-side `Motor6D.Transform` is always applied |
| Hidden joint replication | `RigMapper:SetHiddenReplication(true)` | Off by default; two properties only; protected with `pcall` |
| Disconnect on character teardown | `AnimLib.ConnectionGroup:LinkToInstance` and automatic unbinding in `Destroy` | No executor or hidden-state dependency |
| Rig-size adjustment | Optional positional scaling in `RigMapper:CopyPose` | Model scale ratio only |

## Deliberately excluded

- Hidden properties beyond the opt-in `ReplicateCurrentAngle6D` and `ReplicateCurrentOffset6D` compatibility writes.
- Simulation-radius or network-ownership manipulation.
- Click-fling, target fling, extreme velocities, and forced targeting.
- Remote `loadstring` fallbacks and downloaded default-animation code.
- Executor-specific metamethod and hidden-property hooks.
- Collision bypass and respawn/permadeath behavior unrelated to animation authoring.

The optional hidden writes do not replace local animation. Unsupported executors continue through ordinary script-side `Motor6D.Transform`, and the remaining exclusions keep the animation library out of targeting and velocity manipulation.

## Archive issues not copied

Static review found several brittle patterns that should not become AnimLib behavior:

- The load check reads `game.IsLoaded` instead of calling `game:IsLoaded()`.
- Several `value or true` defaults make an explicit `false` setting impossible.
- Remote fallback and default-animation scripts are fetched without a pinned revision or integrity check.
- Cleanup is partial and depends on which death/respawn branch runs.
- R15 visual support still relies on a limited R6 joint map rather than full R15 animation retargeting.

The patch addresses the reusable lifecycle need with `ConnectionGroup` and explicit `Destroy`/`Unbind` methods instead of copying those branches.
