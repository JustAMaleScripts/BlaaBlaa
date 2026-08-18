# Extended animation API

This patch expands Uhhhhhh's existing `AnimLib` without changing the old module contract. Existing modules that create an animator and call `animator:Step(time)` continue to work.

The extended library reports `AnimLib.Version == "1.5.3"`.

## Patches included

- Fixed `Track.paste`, which previously referenced undefined `DeepcopyTable` and `anim`, sorted the source instead of the target, and did not return the result.
- Prevented modulo-by-zero on zero-duration looped tracks.
- Prevented division-by-zero from a zero-length animator time map.
- Added fallbacks for unknown easing style or direction names.
- Clamped animator weight and rejected invalid speed/time arguments.
- Added safe parsing errors to `Track.fromfile`.
- Added cached track loading that returns independent clones.
- Added reusable connection/task cleanup tied to an Instance lifecycle.
- Added automatic `RunService` binding for animators and state machines.
- Added safe local pose copying and R6/R15 major-joint retargeting.
- Added the exact `C0`/`C1` world-pose solver used by CurrentAngle-style joint mapping.
- Added selectable `Transform` and `WorldCFrame` rig-mapping modes.
- Added Theo-inspired named markers, completion signals, joint filters, fades, sound synchronization, and sequential dance queues.
- Added a visible **Animation Options** page and persistent defaults for existing manual-step dances.
- Added a persistent **Keep Humanoid Sit State** child option for Uhhhhhh's custom seat weld.
- Added a warning that NaN state fling can override normal humanoid states such as sitting.
- Replaced the temporary hitbox button with a saved persistent toggle for original/reanimated roots and collidable hats.
- Escaped spaces in addon asset download URLs and repaired the supplied GeometryRunC/nilsbin module issues documented in the companion addon bundle.
- Merged the repaired community-module sources into the repository package and audited five active Uhhhhhh forks; see [`FORK_AUDIT.md`](./FORK_AUDIT.md).
- Forked Krystal Dance V3's mouse/camera head tracking into an optional final-render overlay with R6/R15 neck discovery and an override mode for conflicting head animation.
- Restored the red reset placeholder during the original pre-detection window where `ReanimOkay` is false.
- Disabled broad filesystem scanning and unsolicited WebSocket extras by default.
- Removed the WebSocket path that compiled and executed remote message content.

The optional legacy extras can only be enabled explicitly with `_G.UhhhhhhEnableUntrustedExtras = true`. Even when enabled, remote message content is no longer executed and the scanner is restricted to `UhhhhhhReanim/`.

## Animation Options page

The main Uhhhhhh page now has an **Animation Options >** button. Its controls are saved and applied to newly created AnimLib animators:

- **Sync Dance To Music** uses the active Uhhhhhh dance sound as the animation clock.
- **Playback Speed** applies a live `0.25` to `2` global multiplier on top of each module's own calibrated `animator.speed`.
- **Apply Speed To Music** (off by default) also multiplies the dance sound's `PlaybackSpeed`; leave it off to change only the animation.
- **Fade In Time** blends a newly loaded track in over `0` to `1` second, including modules that call `Animator:Step` directly.
- **Animated Joints** selects Full Body, Upper Body, Lower Body, or Arms Only.
- **Show Marker Notifications** displays named track markers through Uhhhhhh notifications.
- **Reset Pose When Dance Stops** clears remaining `Motor6D.Transform` values after a dance is destroyed.
- **Krystal Head Overlay >** opens the saved head-tracking controls described below.

Use **Apply + Restart Current Dance** after changing defaults when a dance is already running. The page also provides **Stop Current Dance** and **Reset Character Pose** buttons.

The same defaults are available to modules through `AnimLib.Settings`, and an individual animator can refresh them with `animator:ApplyDefaults()`. Set `UseGlobalPlaybackSpeed = false` in `Animator:Configure` only when a module must opt out of the menu multiplier.

When **Apply Speed To Music** is enabled, AnimLib detects modules driven by `GetOverrideDanceMusicTime()` and avoids multiplying their animation time twice. A module's own `SetOverrideDanceMusicSpeed` value is retained as its base calibration and multiplied by the menu value.

See [`MODULE_TIMING_AUDIT.md`](./MODULE_TIMING_AUDIT.md) for the timing-pattern review of the bundled and supplied module files.

## Krystal head overlay

The **Animation Options > Krystal Head Overlay >** page exposes the head movement from the bundled Krystal Dance V3 moveset as an independent layer:

- **Krystal Head Tracking** enables the layer. It follows the mouse hit position on desktop and the camera's forward direction on touch devices.
- **Override Animated Head** is enabled by default. The overlay runs at Uhhhhhh's final render stage, restores the rig's original neck `C0`, and replaces the current `Neck.Transform`, so a dance cannot immediately overwrite it.
- Turning override off preserves the current animated neck transform and composes the Krystal look offset after it.
- **Tracking Strength** scales the pitch/yaw response from `0` to `1.5`.
- **Tracking Smoothing** controls exponential interpolation from `1` to `30`; higher values respond faster.

The overlay locates either `Torso.Neck` or `UpperTorso.Neck`, so it supports the normal R6 and R15 joint layouts. It also remembers the transform underneath the overlay and restores it when tracking is disabled.

## Track methods

### Creation and validation

```lua
local track = AnimLib.Track.new("My animation")

local valid, reason = AnimLib.Track.validate(track)
local copy = AnimLib.Track.clone(track)
local duration = AnimLib.Track.getDuration(track)
AnimLib.Track.sort(track)

local keyframe = AnimLib.Track.addKeyframe(track, 1.25, poses)
local removed = AnimLib.Track.removeKeyframe(track, 2)
local matches = AnimLib.Track.findKeyframes(track, 1, 4)
```

### Markers

```lua
AnimLib.Track.addMarker(track, 0.5, "Beat", "kick")
AnimLib.Track.addMarker(track, 1.0, "Beat", "snare")

local beatMarkers = AnimLib.Track.getMarkers(track, "Beat")
local sectionMarkers = AnimLib.Track.getMarkersBetween(track, 0, 2)

AnimLib.Track.removeMarker(track, 1)
```

`Track.frominstance` imports both named keyframes and `KeyframeMarker` instances. Marker values survive track cloning, pasting, appending, time scaling, reversing, and slicing. The binary `.anim` format has no marker field, so markers added after binary loading remain in memory unless a separate serialization layer stores them.

### Loading and cache control

```lua
local track, reason = AnimLib.Track.fromfile(path)
local cachedCopy, reason = AnimLib.Track.fromfilecached(path)

-- Force a fresh disk read.
local refreshed = AnimLib.Track.fromfilecached(path, true)

AnimLib.Track.clearfilecache(path)
AnimLib.Track.clearfilecache() -- clear everything
```

`fromfilecached` stores one internal copy and returns an independent clone. A module can edit its copy without changing the version used by another module.

### Editing

```lua
AnimLib.Track.paste(target, source, 1.5)
AnimLib.Track.append(target, source, 0.25)
AnimLib.Track.scaleTime(target, 0.8)

local reversed = AnimLib.Track.reverse(target)
local excerpt = AnimLib.Track.slice(target, 2, 6)
```

- `paste` inserts source keyframes at an absolute time offset.
- `append` inserts after the target duration plus an optional gap.
- `scaleTime` modifies a track in place.
- `reverse` and `slice` return new tracks.

The original methods remain available:

```lua
AnimLib.Track.frombuffer(buffer)
AnimLib.Track.frominstance(keyframeSequence)
AnimLib.Track.getPoses(track, time, looped)
```

## Animator methods

The old field-based style is still supported:

```lua
local animator = AnimLib.Animator.new()
animator.rig = figure
animator.track = track
animator.looped = true
animator:Step(os.clock() - started)
```

The extended lifecycle style manages time internally:

```lua
local animator = AnimLib.Animator.fromTrack(figure, track, {
    Speed = 1,
    Weight = 1,
    Looped = true,
})

animator:Play()

m.Update = function(dt, figure)
    animator:Update(dt)
end

m.Destroy = function(figure)
    animator:Destroy(true)
end
```

### Playback control

```lua
animator:SetRig(figure)
animator:SetTrack(track)
animator:Configure({Speed = 1.2, Weight = 0.75, Looped = true})

-- Keep this animator's intrinsic speed but ignore the menu multiplier.
animator:Configure({UseGlobalPlaybackSpeed = false})

animator:LoadAnimation(trackOrLocalPath)
animator:LoadSequence(keyframeSequence)

animator:Play(0)
animator:Pause()
animator:Resume()
animator:Stop(true)
animator:Seek(3.5)

animator:AdjustSpeed(0.8)
animator:AdjustWeight(0.5)

local time = animator:GetTimePosition()
local duration = animator:GetTimeLength()
local effectiveSpeed = animator:GetPlaybackSpeed()
local playing = animator:IsPlaying()
local poses = animator:GetPose(time)
```

`SetTime(time)` is a Theo-compatible alias for `Seek(time)`.
`GetPoses` aliases `GetPose`; both return the sampled pose map without writing it to a rig. `LoadAnimation` accepts an AnimLib track, a local `.anim` path, or a `KeyframeSequence`. It deliberately does not download or execute code and does not resolve a Roblox `AnimationId`.

### Completion and marker signals

```lua
animator.Finished:Connect(function(finishedTrack)
    print("finished", finishedTrack.Name)
end)

animator.MarkerReached:Connect(function(name, value, marker)
    print(name, value, marker.Time)
end)

animator:GetMarkerReachedSignal("Beat"):Connect(function(value, marker)
    print("beat", value)
end)
```

`OnFinished` aliases `Finished`, and `TimeReached` aliases `MarkerReached` for easier adaptation of Theo-style dance modules. Natural non-looped completion fires `Finished`; manually calling `Stop` does not.

### Joint filters

```lua
animator:SetJointMask({"Left Arm", "Right Arm"}, "Whitelist")
animator:SetJointMask({["Head"] = true}, "Blacklist")
animator:SetFilter({leftShoulder, rightShoulder}, "Whitelist")

local mask, mode = animator:GetJointMask()
animator:ClearJointMask()
```

Masks use a motor's `Part1.Name`. Arrays of names, name dictionaries, and `Motor6D` entries are accepted. Whitelists animate only listed joints; blacklists animate every joint except those listed.
`SetFilter` and `ClearFilter` are Theo-style aliases for `SetJointMask` and `ClearJointMask`. `Configure` also accepts `Filter` and `FilterType` as aliases for `JointMask` and `MaskMode`.

### Fades and sound synchronization

```lua
animator:FadeIn(0.2, 1)
animator:FadeTo(0.5, 0.15)
animator:FadeOut(0.25, true)

animator:SyncToSound(musicSound, 0.1)
local sound, offset = animator:GetSyncedSound()
animator:ClearSoundSync()
```

Sound synchronization samples `Sound.TimePosition + offset` on every update. Animator speed and time mapping still apply; use speed `1` and the default map for direct music-time matching. Fades change AnimLib's blend weight and can optionally stop and reset the pose after reaching zero.

`Update(dt)` returns `false` when there is nothing to play or when a non-looping animation reaches its end.

### Automatic frame updates

An animator can own its update connection instead of relying on a module's `Update` callback:

```lua
animator:PlayAndBind("PreAnimation", 0)

print(animator:GetBoundSignal()) -- PreAnimation
animator:Unbind()
```

Supported names are `PreAnimation`, `PreSimulation`, `PostSimulation`, `Heartbeat`, and `RenderStepped`. A custom `RBXScriptSignal` is also accepted. `Animator:Destroy()` always unbinds first.

Use `PreAnimation` for normal track playback. Use `PostSimulation` when copying the final pose of one rig to another after animation and physics work for the frame.

## Sequential dance queue

`AnimLib.DanceQueue` is a reusable form of Theo's non-looped emote queue. Each item has an independent animator setup and advances automatically when a non-looped track finishes.

```lua
local queue = AnimLib.DanceQueue.new(figure)

queue.ItemStarted:Connect(function(item)
    print("starting", item.Name)
end)

queue.ItemFinished:Connect(function(item, reason)
    print("ended", item.Name, reason)
end)

queue.Finished:Connect(function()
    print("queue empty")
end)

queue:Enqueue(introTrack, {
    Name = "Intro",
    Looped = false,
    FadeIn = 0.15,
    FadeOut = 0.2,
    Sound = musicSound,
    SoundOffset = 0,
})

queue:Enqueue(mainDanceTrack, {
    Name = "Main loop",
    Looped = true,
    JointMask = {"Torso", "Left Arm", "Right Arm"},
    MaskMode = "Whitelist",
})

queue:PlayAndBind("PreAnimation")
```

Queue controls:

```lua
local count = queue:Count(true)
local current = queue:GetCurrent()

queue:Pause()
queue:Resume()
queue:Skip(true)
queue:Clear(false)
queue:Stop(true, true)
queue:Destroy(true)
```

Looped entries stay active until skipped or stopped. Item completion reasons are `Finished`, `Stopped`, `Skipped`, or `Cleared`.
Queue item filters accept either `JointMask` / `MaskMode` or the Theo-style `Filter` / `FilterType` names. Fade durations are measured in real seconds, including when playback speed is changed.

## Motor6D world-pose utilities

`AnimLib.Motor6D` exposes the pose math independently of `RigMapper`. `target` and `reference` parameters accept either a `BasePart` or a `CFrame`.

```lua
local valid, reason = AnimLib.Motor6D.Validate(motor)

local transform = AnimLib.Motor6D.SolveWorldTransform(
    motor,
    targetPart,
    referencePart
)

AnimLib.Motor6D.ApplyTransform(motor, transform)
AnimLib.Motor6D.ApplyWorldPose(motor, targetPart, referencePart)
```

The exact solved delta is:

```text
motor.C0^-1 * reference.CFrame^-1 * target.CFrame * motor.C1
```

This is the archived CurrentAngle `C0`/`C1` conversion, separated from its character, collision, ownership, and fling systems.

### Reading, reconstructing, and retargeting

```lua
local current = AnimLib.Motor6D.GetCurrentWorldTransform(motor)
local part1World = AnimLib.Motor6D.GetWorldCFrame(motor, current)

local retargeted = AnimLib.Motor6D.RetargetTransform(
    sourceMotor,
    targetMotor
)
```

`GetWorldCFrame` reconstructs the connected Part1 pose from a transform. `RetargetTransform` reads the source motor's Part0-to-Part1 world relationship and converts it through the target motor's `C0` and `C1`.

### Weighted application

```lua
local applied, replication = AnimLib.Motor6D.ApplyTransform(motor, transform, {
    Weight = 0.75,
    PositionScale = 1.2,
    HiddenReplication = false,
})

AnimLib.Motor6D.Reset(motor)
```

The ordinary script-side [`Motor6D.Transform`](https://create.roblox.com/docs/reference/engine/classes/Motor6D#Transform) assignment always occurs. Roblox currently marks `Transform` as hidden and not replicated in the engine reference, but it remains directly used by the existing animation code. `Weight` is clamped from zero to one, and `PositionScale` affects translation without changing rotation.

## Pose retargeting and mirroring

`AnimLib.RigMapper` always copies ordinary script-side `Motor6D.Transform` values locally. An optional, disabled-by-default compatibility mode can additionally attempt the two CurrentAngle joint replication properties. It never changes ownership, applies velocity, or performs fling behavior.

### Exact-name rigs

```lua
local mapper = AnimLib.RigMapper.new(sourceRig, targetRig)
local copiedJointCount = mapper:CopyPose()

mapper.weight = 0.8
mapper.scalePositions = true
mapper:Bind() -- defaults to PostSimulation
```

`Transform` is the default mode. It copies each mapped source motor's existing `Transform` value:

```lua
mapper:SetMode("Transform")
print(mapper:GetMode())
```

Use `WorldCFrame` for the exact CurrentAngle-style part relationship conversion:

```lua
mapper:SetMode("WorldCFrame")
mapper:Bind("PostSimulation")
```

In `WorldCFrame` mode, every mapped source motor supplies its Part0 and Part1 world poses. The result is solved through the corresponding target motor's `C0` and `C1`. This is useful when source and target joint offsets differ; it may also preserve positional differences you do not want, so both modes remain available.

### R15 and R6 major joints

```lua
local r15ToR6 = AnimLib.RigMapper.new(r15Rig, r6Rig)
r15ToR6:SetPreset("R15ToR6"):Bind("PostSimulation")

local r6ToR15 = AnimLib.RigMapper.new(r6Rig, r15Rig)
r6ToR15:SetPreset("R6ToR15"):Bind("PostSimulation")
```

The presets map the root, head, upper arms, and upper legs. They deliberately leave R15 waist, elbows, wrists, knees, and ankles alone because R6 has no equivalent joints. For a custom rig, aliases are keyed by target `Part1` name and point to the source `Part1` name:

```lua
mapper:SetAliases({
    ["TargetArm"] = "SourceArm",
    ["TargetLeg"] = "SourceLeg",
})

local names = mapper:GetMappedJointNames()
mapper:Refresh() -- rebuild after joints change
mapper:ResetTargetPose()
mapper:Unbind()
mapper:Destroy(true)
```

### Optional hidden-property compatibility

This executor-dependent mode is off by default. Normal `Motor6D.Transform` copying remains active whether the hidden writes work or fail.

```lua
mapper:SetHiddenReplication(true)

print(mapper:IsHiddenReplicationAvailable())

local copied, replication = mapper:CopyPose()
print(copied)
print(replication.Attempted, replication.Succeeded, replication.Failed)
print(replication.LastError)

-- The same option is used on every bound update.
mapper:Bind("PostSimulation")
```

When enabled, each mapped target joint is attempted with `ReplicateCurrentOffset6D` and `ReplicateCurrentAngle6D` through `AnimLib.Motor6D.TryHiddenReplication`. Both writes are protected with `pcall`. If `sethiddenproperty` is missing or either property is unsupported, failure is recorded in `GetHiddenReplicationStatus()` and pose copying continues through the ordinary `Transform` path.

The lower-level methods are also available directly:

```lua
local offset, angle = AnimLib.Motor6D.ToReplicationVectors(transform)
local success, reason = AnimLib.Motor6D.TryHiddenReplication(motor, transform)
```

`ResetTargetPose()` also attempts to clear both hidden values back to the identity pose when this mode is enabled.

These are undocumented engine fields rather than stable Roblox APIs. Treat successful writes as executor- and client-version-specific behavior.

## Connection and task cleanup

`AnimLib.ConnectionGroup` cleans connections, Instances, threads, callbacks, and table objects with `Disconnect` or `Destroy` methods. Cleanup continues even if one item errors.

```lua
local cleanup = AnimLib.ConnectionGroup.new()

cleanup:Add(RunService.Heartbeat:Connect(function(dt)
    -- module work
end))
cleanup:Add(task.spawn(function()
    -- module task
end))
cleanup:Add(function()
    -- final callback
end)

cleanup:LinkToInstance(figure) -- cleanup when the rig is destroyed
print(cleanup:Count())

cleanup:Cleanup() -- reusable
cleanup:Destroy() -- permanent
```

## Automatic locomotion state machine

`AnimLib.StateMachine` supplies reusable idle, walking, sprinting, directional, airborne, seated, climbing, and swimming selection. It is deliberately opt-in so existing movesets retain their current behavior.

Supported names and aliases:

| Runtime state | Accepted aliases |
| --- | --- |
| `Idle` | `idle` |
| `Walk` | `walk`, `run`, `running` |
| `Sprint` | `sprint`, `sprinting` |
| `WalkForward` | `forward`, `walk forward` |
| `WalkBackward` | `backward`, `walk backward` |
| `WalkLeft` | `left`, `walk left` |
| `WalkRight` | `right`, `walk right` |
| `Jump` | `jump`, `jumping` |
| `Fall` | `fall`, `freefall` |
| `Land` | `land`, `landed` |
| `Sit` | `sit`, `seated` |
| `Climb` | `climb`, `climbing` |
| `Swim` | `swim`, `swimming` |
| `SwimIdle` | `swim idle` |

### Complete module example

```lua
local modules = {}

table.insert(modules, function()
    local m = {
        ModuleType = "MOVESET",
        Name = "State machine example",
        Description = "Extended locomotion example",
        Assets = {
            "Idle.anim",
            "Walk.anim",
            "Jump.anim",
            "Fall.anim",
            "Land.anim",
        },
    }

    local controller

    m.Config = function(parent) end
    m.SaveConfig = function() return {} end
    m.LoadConfig = function(save) end

    m.Init = function(figure)
        controller = AnimLib.StateMachine.new(figure)
        controller:SetAnimations({
            Idle = {
                Track = AssetGetPathFromFilename("Idle.anim"),
                Looped = true,
            },
            Walk = AssetGetPathFromFilename("Walk.anim"),
            Jump = {
                Track = AssetGetPathFromFilename("Jump.anim"),
                Looped = false,
            },
            Fall = AssetGetPathFromFilename("Fall.anim"),
            Land = {
                Track = AssetGetPathFromFilename("Land.anim"),
                Looped = false,
            },
        })
        controller:SetLandHoldTime(0.2)
    end

    m.Update = function(dt, figure)
        controller:Update(dt)
    end

    m.Destroy = function(figure)
        if controller then controller:Destroy(true) end
        controller = nil
    end

    return m
end)

return modules
```

### Directional movement

```lua
controller:SetDirectionalAnimations(
    AssetGetPathFromFilename("Forward.anim"),
    AssetGetPathFromFilename("Backward.anim"),
    AssetGetPathFromFilename("Left.anim"),
    AssetGetPathFromFilename("Right.anim"),
    {Looped = true}
)

controller:SetDirectionalEnabled(false)
controller:SetDirectionalEnabled(true)
```

Missing directional tracks automatically fall back to `Walk`. `SwimIdle` falls back to `Idle`.

### State and lifecycle control

```lua
controller:SetSprinting(true)
controller:SetSprinting(false)

local walkSettings = controller:GetAnimation("Walk")
controller:SetPlaybackSpeed("Walk", 1.2)
controller:SetWeight("Walk", 0.8)
controller:RemoveAnimation("Swim")

controller:ForceState("Sit")
controller:ClearForcedState()

local state = controller:GetState()
local resolved = controller:ResolveState()

controller:Pause()
controller:Resume()
controller:Stop(true)
controller:Start()
controller:Restart()
controller:Destroy(true)
```

The state machine can also update itself:

```lua
controller:StartAndBind("PreAnimation")
print(controller:GetBoundSignal())
controller:Unbind()
```

## CurrentAngle archive comparison

The supplied CurrentAngle V2 archive is a reanimation implementation rather than a keyframe animation library. Its useful animation concepts were isolated into the safe `RigMapper`, frame-signal binding, and `ConnectionGroup` APIs above. See [`CURRENTANGLE_AUDIT.md`](./CURRENTANGLE_AUDIT.md) for the full comparison.

MrY7zz's required MIT notice is retained immediately above the adapted `RigMapper` section in `source/reanim.lua`. Hidden-property replication is available only through the explicit best-effort option documented above. No simulation-radius manipulation, click-fling, remote code execution, or default-animation download was adapted.

## Theo dance-method comparison

The supplied chooser delegates to Theo's `Legacy.lua` or current `ToolDance.lua`; it contains no animation engine itself. The current branch's reusable concepts were implemented as the marker, completion, filter, fade, sound-sync, and `DanceQueue` APIs above. See [`THEO_DANCE_AUDIT.md`](./THEO_DANCE_AUDIT.md) for provenance and exclusions.

## Compatibility notes

- `Animator:Step(time)` remains the low-level API and still accepts external absolute time.
- `Animator:Update(dt)` is the new managed-time API. Do not call both in the same frame.
- `StateMachine:Update(dt)` calls its internal animator automatically.
- Bound animators and state machines must not also be updated manually in the same frame.
- `RigMapper` always applies local target pose deltas rather than directly moving parts; custom rigs may need aliases or authored conversion tracks.
- `RigMapper` defaults to `Transform`; `WorldCFrame` explicitly solves source part relationships through target `C0`/`C1` offsets.
- Hidden replication defaults to off, is protected with `pcall`, and never replaces the ordinary script-side `Motor6D.Transform` path.
- Marker signals are generated by AnimLib sampling; a time jump spanning more than one complete loop may coalesce repeated markers.
- `DanceQueue` owns one animator. A looped queue entry requires `Skip` or `Stop` before later entries can play.
- The state machine reads `Humanoid:GetState()` and `MoveDirection`; it does not modify reanimation, root-part, collision, or fling behavior.
- Tracks are still applied through R6/R15 Motor6D part-name mapping already used by Uhhhhhh.
