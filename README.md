# <p align="center">STEVETHEREALONE (@steve_internal)'s Universal Hierarchical 6 Reanimator And JustAMaleScript (@JustAMaleYT)'s and E God's Modded Fork</p>
<p align="center">A really cool, optimised animation program and musics with demo scenes! Idea originated from a dream.</p>
<p align="center">
	<img src="./images/Showcase.gif" alt="drawing" width="45%"/>
	<img src="./images/Showcase2.gif" alt="drawing" width="45%"/>
</p>

## IMPORTANT, READ CAREFULLY!!!

This is the official repository for BlaaBlaa.

This is an unofficial fork of Uhhhhhh.

All code is stored in this repository.

Feel free to use these as your reference. (would not suggest though)


Join the [DISCORD](https://discord.gg/NASNUKRBVM) for Uhhhhhh Reanimate :D

**NOTICE:** BlaaBlaa is a fork of Uhhhhhh Reanimate. Expect it to be not up to par.

**NOTICE 2:** BlaaBlaa uses code from AI and also Warehause, Awes Fork, Uhhhhhh pull requests, etc.

## Loadstring
Pick from one of these:

1. raw loadstring (cached by github)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustAMaleScripts/BlaaBlaa/refs/heads/main/source/reanim.lua"))()
```

2. api loadstring (bypasses github cache)
```lua
local a,b,c,g="/JustAMaleScripts/BlaaBlaa/","/source/reanim.lua",".github","https://"local d=request({Url=`{g}api{c}.com/repos{a}contents{b}`,Headers={Accept=`application/vnd{c}.VERSION.raw`}})if d.StatusCode~=200 then d.Body=game:HttpGet(`{g}raw{c}usercontent.com{a}main{b}`)end local e,f=loadstring(d.Body)if not e then warn(f)else e()end
```

## Features:
1. ~Probably the most stable hatdrop~ (roblox patched permadeath which makes this useless 3:) (New ragdoll permadeath though, but hat drop is probably not supported idk)

   Uhhhhhh's hatdrop supports most (if not all) hat rigs!

   <img src="./images/ILDoesKemusan.gif" alt="drawing" width="350"/>

   <img src="./images/WaistRigSupport.gif" alt="drawing" width="350"/>

2. Limb reanimation support (Roblox may or may not patch this soon idk if the screenshots are fake that said this)

   In the case where you are just unable to afford hats, you can use your own limbs instead!

   Unfortunately, this only supports certain games.

   ### Some supported games maybe:
   
   Zombie Game UPD3 (Suggested by JustAMale)
   
   Life in Paradise
   
   Fencing
   
   Moderators are epical (I think that was the name)
   
   Sword Fight on the Heights IV and Original (original is down at the time of putting this)
   
   The Chosen One (Someone in the discord said this)
   
   Adopt and Raise a Baby
   
   Gzarp (I just saw someone in the discord who said it does)
   
   vvv Don't know how true these are because I saw them in the discord server.
   
   Facility of Redemption
   
   Pine Ridge
   
   A Simple Obby Saga
   
   ^^^ Whatever above
   
   Just a Baseplate (it might not work sometimes IDK)
   
   Breaking point
   
   Lucky Blocks Battlegrounds (IDK for sure but it is a pretty old game so I assume so)
   
   The horror mansion (not sure because someone said in the discord it does)
   
   And more.


   <img src="./images/LimbReanimation.gif" alt="drawing" width="350"/>

4. Good looking UI

   definitely better than genesis

   <img src="./images/UserInterface.gif" alt="drawing" width="350"/>

5. Moveset and Dance system

   Have old animations, or become Lightning Cannon. Dance anytime!

   <img src="./images/IllMakeYouSay.gif" alt="drawing" width="350"/>

6. Takes advantage of random replicate properties

   Serversided Physics glue = very accurate (and fast) fling! (Roblox may or may not remove this property but IDK if the screenshot is fake)

   <img src="./images/FastestFling.gif" alt="drawing" width="350"/>

7. Modding support

   Infinite Yield lets you make plugins. So why not add it to Uhhhhhh too?

   <img src="./images/GiantSkipping.gif" alt="drawing" width="350"/>

   The documentation is right below all of whatever these are.

8. Themes

   You hate the colors? Change them! Do you want black? Do you want white? Do you want your own? The choice is yours.

   <img src="./images/Theme1.jpg" alt="drawing" width="40%"/>
   <img src="./images/Theme2.jpg" alt="drawing" width="40%"/>
   <img src="./images/Theme3.jpg" alt="drawing" width="40%"/>
   <img src="./images/Theme4.jpg" alt="drawing" width="40%"/>

```lua
-- example theme
_G.UhhhhhhTheme = {
	Fore = Color3.new(0, 1, 0), -- nil = rainbow
	Back = Color3.new(0, 0, 0), -- nil = pure black
	Text = Color3.new(0, 1, 0),
}
-- the Color3s can also be a hex code string e.g.: "DDBB69"
```

9. Favorite System

   You can now favorite the dances you like!

10. More Music

    Added more UI music that you can choose!

11. Module Folders

    You can now make folders for each module that contain the music, anims, rbxms, images, and module files!
    
	This is for making it easier to add your modules without going into the content folder!

12. Tool Kill and Custom Kill!

    Works just like awes Uhhhhhh fork!
    
    If you don't know for custom kill you just have to go to BlaaBlaaReanim > AdministrativeModules > DamageMethod > main.lua and make whatever code that can be used to attack your foes!

13. Better netless

    Netless has gotten an upgrade!
    
    It should be more smoother now thanks to warehause!
    
    Netless Velocity now has a slider that goes up to 300 too!

14. Extra stuff that help with reanimation

    Like:
    
    workspace gravity is 0
    
    pcalled signal behavior immediate
    
    and more thanks to warehause!

15. Better executor support

    Fixed that old thing warehause tried to make for JJsploit to work, but somehow they failed to make it properly!

16. R15 Reanimation Fix

    Hat Reanimation for R15 is fixed! (Don't know if the method will get patched by Roblox since there has been a screenshot but IDK if it is real)

### And so much more! (Can't remember the rest)

# SHOWCASES
-- :3 user images brought to you by Awes955
<p align="center">
	<img src="./images/3321822271_7041939546_1768574213001.png" alt="drawing" width="45%"/>
	<img src="./images/4181218726_6441847031_1768744206674.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/4181218726_6441847031_1768755394038.png" alt="drawing" width="45%"/>
	<img src="./images/4181218726_6441847031_1768825207608.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/4181218726_6441847031_1768829759425.png" alt="drawing" width="45%"/>
	<img src="./images/IMG_0823.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/IMG_0843.png" alt="drawing" width="45%"/>
	<img src="./images/IMG_0847.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/IMG_20260118_172134_004.png" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260117_205517_Roblox.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/IMG_20260119_163546_348.png" alt="drawing" width="45%"/>
	<img src="./images/IMG_4334.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/IMG_4335.png" alt="drawing" width="45%"/>
	<img src="./images/IMG_4336.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/Screenshot_20260118-165059.png" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260118-192115.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/Screenshot_20260118-222617.png" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260118-222711.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/4181218726_83560691049285_1769158731388.png" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260122-031656.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/Screenshot_20260122-031857.jpg" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260123-223246.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/Screenshot_20260124-174236.png" alt="drawing" width="45%"/>
	<img src="./images/image.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/image.webp" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260124-141230.png" alt="drawing" width="45%"/>
</p>

- Thats all for now, ill add any images that looks good :D
  
## Contributing

"Can I help? Can I/you add support for my hat?""

If you want to help by changing code, fixing bugs, doing further optimisations, my pull requests are open. (you can do this for the fork I guess)

As for me adding support for your hats (since the hat database is very small), create an issue and ill prolly read it. (probably won't happen for this fork since we don't do that)

# Uhhhhhh's probably the most important quotes
**DISCLAIMER**: Some random quotes made here are *simple jokes* (e.g.: "this script mogs genesis") and should **not** be taken seriously. This also includes *all* the self-glazing quotes. **It's your choice to agree with them or not**, and if you do or don't, **don't come harass/mock any individuals from it.** In the end, a *joke quote* is a *joke quote*.

# Uhhhhhh documentation

## Filesystem structure
Uhhhhhh's filesystem is like this
```txt
Executor's workspace/
| BlaaBlaaReanim/
| | Assets/ - Contains UI Music
| | AdminstrativeModules - Extra features
| | | DamageMethod - Custom kill methods folder
| | | | main.lua - Make your kill method in this file
| | Modules/ - YOUR modules
| | Content/ - Contains module assets
| | | Anims/ - .anim (usually in STEVE's KeyframeSequence file format)
| | | Sounds/ - .mp3
| | | Images/ - .png
| | | Models/ - .rbxm
| | | Unknown/ - Ungrouped assets
| | tree.ehehetilde - All save data in JSON
| | .nomedia - Created for android users
```

## Modules
Modules are just luau tables that are created by a function.
It does impose vulnerabilities, but who cares? Executors already
execute functions from user strings.

**NEW:** You can now add folders into your modules folder with the sounds, mudule, and anim files to easily add your modules without going to the content folder.

> [!WARNING]
> Modules execute code with Uhhhhhh's supplied environment and executor capabilities. Review the source and asset URLs before installing a local or marketplace module. The animation API patch disables unsolicited remote extras by default, but it cannot make an intentionally installed third-party module trustworthy.

### Extended animation API

The opt-in `AnimLib` extension adds managed playback, locomotion states, R6/R15 pose retargeting, selectable `RunService` update phases, and automatic connection cleanup. The original `animator:Step(time)` module interface remains compatible. A visible **Animation Options >** page controls music sync, animation speed, optional matching music speed, fade-in, joint presets, marker notices, and stop-time pose reset.

Under **Reanimate Character Settings**, **Can Sit on Seats** now has a saved **↳ Keep Humanoid Sit State** sub-option. When enabled, Uhhhhhh keeps its reanimated humanoid in Roblox's `Sit`/`Seated` state while the custom seat weld is active; jumping still exits the seat normally.

The limb-reanimator config warns that **Use NaN State Fling** can override normal Roblox humanoid states, including sitting. The saved **Show Reanimate Hitboxes** switch continuously outlines the original root part in red, the reanimated root part in cyan, and collidable hat handles in green.

Addon asset URLs containing spaces are escaped before download. This fixes otherwise valid third-party and `MARKET/` paths, but `MARKET/` assets still have to exist under the repository's matching `community/` path.

The repository package now includes the repaired marketplace module sources under `community/`, including Airy's ZIP-file dances, Valtta's port pack, Theo's dances, Noober's pack, and the other reviewed addons. Upload the matching `community/` tree together with `source/reanim.lua`; the in-GUI marketplace reads `community/list.txt`. For a manual local install, copy a module file into `UhhhhhhReanim/Modules/` and press **Reload User Modules**.

**Animation Options > Krystal Head Overlay >** makes Krystal Dance V3's mouse/camera head tracking available over every moveset and dance. Its saved **Override Animated Head** option runs after animation updates so conflicting neck poses cannot replace the tracker; disable override to use it as an additive head layer instead.

The saved **Show Red Reset Placeholder** switch under **Reanimate Character Settings** restores the translucent red fake R6 rig during the reset gap before the new real character, humanoid, root part, and live humanoid state are detected. This preview remains visible even if the general **Placeholders** slider was previously saved at fully transparent. See [`docs/RESET_PLACEHOLDER_AUDIT.md`](./docs/RESET_PLACEHOLDER_AUDIT.md) for the original-source comparison.

See [`docs/ANIMATION_API.md`](./docs/ANIMATION_API.md) for examples, [`docs/MODULE_TIMING_AUDIT.md`](./docs/MODULE_TIMING_AUDIT.md) for the cross-module speed analysis, [`docs/CURRENTANGLE_AUDIT.md`](./docs/CURRENTANGLE_AUDIT.md) for the archived CurrentAngle comparison, [`docs/THEO_DANCE_AUDIT.md`](./docs/THEO_DANCE_AUDIT.md) for the Theo dance-method study, [`docs/FORK_AUDIT.md`](./docs/FORK_AUDIT.md) for the fork diff and merge decisions, and [`docs/RESET_PLACEHOLDER_AUDIT.md`](./docs/RESET_PLACEHOLDER_AUDIT.md) for the reset-preview restoration.

Modules are returned by a function from a luau script.
honestly idk how to document this in an understandable way so
heres an example, with code comments:
```lua
-- UhhhhhhReanim/Modules/lazy.lua

local modules = {} -- table to contain all modules

-- function called to create the module
-- this allows for local variables
table.insert(modules, function() -- put into modules table
	local m = {} -- module object
	
	-- can be "MOVESET" or "DANCE"
	m.ModuleType = "DANCE"
	
	-- name of module
	m.Name = "Lazy"
	
	-- description of module
	m.Description = "too lazy to even animate"
	
	-- internal name, used for movesets and dances to interact with each other
	-- best usage example of this is Immortality Lord + ragdoll
	-- this can be omitted
	m.InternalName = "DANCE_LAZY"
	
	-- table of assets to download, either in "filename" or "filename@url_to_source"
	m.Assets = {"Lazy.mp3@https://raw.githubusercontent.com/user/repo/main/69.mp3"}
	
	-- functions below should NOT yield
	
	-- configuration GUI function, recommended to use these:
	-- Util_CreateText(parent, text, fontsize, alignment)
	-- Util_CreateButton(parent, text, fontsize)
	-- Util_CreateSwitch(parent, text, is_on)
	-- Util_CreateTextbox(parent, text, placeholdertext, fontsize)
	-- Util_CreateSlider(parent, text, value, min, max, step)
	-- Util_CreateDropdown(parent, text, items, itemindex)
	-- Util_CreateCanvas(parent)
	-- Util_CreateScrollCanvas(parent, height)
	-- Util_CreateSeparator(parent)
	m.Config = function(parent: GuiBase2d)
		Util_CreateText(parent, "hi", 67, Enum.TextXAlignment.Center)
	end
	
	-- function called to load from save table
	-- this function can be omitted
	m.LoadConfig = function(save: any)
	end
	
	-- function called to save from load table
	-- this function can be omitted
	m.SaveConfig = function()
		return {} -- AND KEEP YOUR TABLES SERIALIZABLE
	end
	
	-- called upon initialization
	m.Init = function(figure: Model)
		-- access upvalues, initialize animator
	end
	
	-- called upon update loop
	m.Update = function(dt: number, figure: Model)
		local t = tick()
		-- step the animator, emit particles
	end
	
	-- called upon destruction
	-- this is not called when figure is refreshed so reference ur created and modified instances
	m.Destroy = function(figure: Model?)
		-- destroy created instances, dereference animator
	end
	return m -- function returns the module
end)

return modules -- return modules
```


## STEVE's KeyframeSequence file format
It's all pretty simple, really.
The byteorder is in little endian.

string structure: `<2 bytes short n> <n bytes string>`

pose structure: `<string pose_name> <4 bytes float weight> <string pose_easing_style> <string pose_easing_direction> <4 bytes float cframe component, times 12>`

keyframe structure: `<4 bytes float time> <4 bytes int n> <pose poses, times n>`

main file structure: `<string animation_name> <4 bytes int n> <keyframe keyframes, times n>`

This just explains how this format works. If you don't like it, check the `tools` folder in this repo!

## Uhhhhhh's env
Uhhhhhh gives modules whatever it can. Here are all of it!
```lua
RandomString(length) -- Random String function

-- UI Util functions, used for config UI
-- refer to module example code block for usage
Util_CreateText
Util_CreateButton
Util_CreateSwitch
Util_CreateTextbox
Util_CreateSlider
Util_CreateDropdown
Util_CreateCanvas
Util_CreateScrollCanvas
Util_CreateSeparator

-- Reanimators
LimbReanimator
	.Running -- is running
	.SetRootPartMode(mode) -- set rootpart mode
		-- 0 - RootPart in very void
		-- 1 - RootPart in void
		-- 2 - Keep RootPart streamed
		-- 3 - CurrentAngle style
		-- 4 - RootPart is Torso
HatReanimator
	.Running -- is running
	.HasPermadeath -- has permadeath?
	.HasHatCollide -- hat collde enabled?
	.HatCFrameOverride -- array of hat overrides
		-- see IL moveset for use case
	.GetHatMap() -- get current hat map (changes wont apply)
		-- returns table of hat map items
		{
			Name = "hat name",
			MeshId = "mesh id", TextureId = "texture id",
			C0 = "C0 virtual weld",
			C1 = "C1 virtual weld",
			Scale = "the hat's scale set from Roblox accessory refiner",
			Limb = "the limb it is attached to",
			Group = "the name of the hat group, see IL moveset for use case"
		}
		-- also has .Built, os.clock() value when it was built
		-- recommended to use ipairs when looping through table
	.GetHatCFrameMeshAndTexture(mesh, tex) -- pass in mesh id and texture id to get hat cframe
	.GetAttachmentCFrame(name) -- attachment by name
ReanimateShowHitboxes() -- refreshes the persistent reanimate hitboxes when their GUI toggle is enabled
ReanimateFling(target, duration) -- fling target
-- target can be model, part, Vector3 or CFrame
-- duration can be 0 for fling to last a frame

-- music overrides
SetOverrideMovesetMusic(assetid, musicname, volume, loopregion) -- play music, pass no arguments to stop
GetOverrideMovesetMusicTime() -- returns time
SetOverrideMovesetMusicTime(time) -- set time
SetOverrideMovesetMusicSpeed(speed) -- set speed
-- same for dance, dances are high priority
SetOverrideDanceMusic(assetid, musicname, volume, loopregion)
GetOverrideDanceMusicTime()
SetOverrideDanceMusicTime(time)
SetOverrideDanceMusicSpeed(speed)

AnimLib -- Uhhhhhh's animation library
	.Track -- track util
		.new(name) -- creates an empty track
		.validate(track) -- returns valid, reason
		.clone(track) -- deep copy
		.getDuration(track) -- recalculates duration
		.sort(track) -- sort keyframes and update duration
		.addKeyframe(track, time, poses) / .removeKeyframe(track, index)
		.findKeyframes(track, starttime, endtime)
		.addMarker(track, time, name, value?) / .removeMarker(track, index)
		.getMarkers(track, name?) / .getMarkersBetween(track, starttime, endtime, includeStart?)
		.fromfile(path) -- loads animation from file, must be in STEVE's KeyframeSequence file format
		.fromfilecached(path, refresh) -- cached load that returns an independent clone
		.clearfilecache(path?) -- clear one or all cached tracks
		.frominstance(ks) -- loads animation from a KeyframeSequence
		.paste(target, source, timeoffset) -- pastes keyframes from source to target, with a time offset
		.append(target, source, gap) -- paste after target duration
		.scaleTime(track, factor) -- change timing in place
		.reverse(track) -- returns a reversed clone
		.slice(track, starttime, endtime) -- returns a time excerpt
		.getPoses(track, time, looped) -- used by Animator
	.Animator -- animator
		.new() -- creates an animator
		.fromTrack(rig, track, options) -- configured animator
			:ApplyDefaults() -- refresh defaults from the Animation Options page
			.rig -- the character model
			.track -- the animation track
			.map -- map input time to animation time
			.looped -- loop animation by track end time
			.speed -- input time multiplication
			.weight -- use to blend with other animators, or smoothen animation
			:Step(time) -- apply pose
			:Update(dt) -- managed-time playback
			:Play(starttime?) / :Pause() / :Resume() / :Stop(resetpose?)
			:Seek(time) / :AdjustSpeed(speed) / :AdjustWeight(weight)
			:SetTime(time) / :GetTimePosition() / :GetTimeLength() / :GetPlaybackSpeed() / :IsPlaying()
			:Configure({UseGlobalPlaybackSpeed = false}) -- optional per-animator menu-speed opt-out
			:LoadAnimation(trackOrPath) / :LoadSequence(keyframeSequence) / :GetPose(time?)
			:SetJointMask(mask, mode) / :GetJointMask() / :ClearJointMask()
			:SetFilter(filter, type) / :ClearFilter()
			:SyncToSound(sound, offset?) / :ClearSoundSync() / :GetSyncedSound()
			:FadeTo(weight, duration) / :FadeIn(duration, weight?) / :FadeOut(duration, resetpose?)
			:GetMarkerReachedSignal(name) / .MarkerReached / .Finished
			:ResetPose() / :Destroy(resetpose?)
			:Bind(signal?) / :Unbind() / :GetBoundSignal() / :PlayAndBind(signal?, starttime?)
	.DanceQueue -- sequential Theo-style emote playback
		.new(rig)
			:Enqueue(track, options?) / :Insert(index, track, options?) / :Remove(index)
			:Count(includeCurrent?) / :GetCurrent() / :Skip(resetpose?) / :Clear(stopCurrent?)
			:Play() / :Pause() / :Resume() / :Stop(clearQueue?, resetpose?) / :Update(dt)
			:Bind(signal?) / :Unbind() / :PlayAndBind(signal?) / :Destroy(resetpose?)
			.ItemStarted / .ItemFinished / .Finished
	.Motor6D -- world-pose solving and application utilities
		.Validate(motor)
		.SolveWorldTransform(motor, target, reference)
		.GetCurrentWorldTransform(motor) / .GetWorldCFrame(motor, transform?, reference?)
		.RetargetTransform(sourceMotor, targetMotor)
		.ToReplicationVectors(transform) / .TryHiddenReplication(motor, transform)
		.ApplyTransform(motor, transform, options?) / .ApplyWorldPose(motor, target, reference, options?)
		.Reset(motor, hiddenReplication?)
	.RigMapper -- safe local Motor6D pose copying
		.new(sourceRig, targetRig, aliases?)
			:SetRigs(sourceRig, targetRig) / :SetAliases(table) / :SetPreset(name)
			:SetMode("Transform" or "WorldCFrame") / :GetMode()
			:SetHiddenReplication(enabled) / :IsHiddenReplicationAvailable()
			:GetHiddenReplicationStatus()
			:Refresh() / :CopyPose(weight?, scalePositions?) / :ResetTargetPose()
			:GetMappedJointNames() / :Bind(signal?) / :Unbind() / :Destroy(resetpose?)
	.ConnectionGroup -- reusable lifecycle cleanup
		.new()
			:Add(item) / :Remove(item, cleanup?) / :Count()
			:LinkToInstance(instance) / :Cleanup() / :Destroy()
	.StateMachine -- opt-in automatic locomotion controller
		.new(rig)
			:SetAnimation(state, track, options)
			:GetAnimation(state) / :RemoveAnimation(state)
			:SetPlaybackSpeed(state, speed) / :SetWeight(state, weight)
			:SetAnimations(table)
			:SetDirectionalAnimations(forward, backward, left, right, options)
			:SetSprinting(enabled)
			:ForceState(state) / :ClearForcedState()
			:Bind(signal?) / :Unbind() / :StartAndBind(signal?)
			:Update(dt) / :Pause() / :Resume() / :Stop(resetpose?) / :Destroy(resetpose?)

-- utils for grabbing assets from Uhhhhhh/Content/...
AssetGetPathFromFilename(filename) -- used for AnimLib.Track.fromfile
AssetGetContentId(filename) -- loads file with getcustomasset

-- chat
ProtectedChat(message) -- make player say something, errors are supressed
OnPlayerChatted.Event:Connect(function(player, message) end) -- event when a player chats

HiddenGui -- the reference to the ScreenGui Uhhhhhh uses
FallenPartsDestroyHeight -- self explanatory
```

See [`docs/ANIMATION_API.md`](docs/ANIMATION_API.md) for the complete extended animation API, state-machine example, compatibility notes, and patch details.

## "i dont understand all this"
That's why I have made (in v1.0.3) the stuff that gives Empyrean Reanimate (emper chill lowkirkenuinly) the ability to be used in require script convertions!
`_G.Uhhhhhh` which contains `.Character` and `.Fling`, but using this might make you rejoin just to stop everything...

So I also made `goodies/convertion.lua`! For all those smarty-pants out there, you may now make your own "moveset" with a couple of changes to the actual source!
Link your connection disconnections, thread stoppers and instance deconstructions to a singular `OnStopEvent` `BindableEvent`, NOW!
(not doing so will cause havoc in your threads ;P)

# Uhhhhhh's Licenses
My code is covered by the MIT license. I made most of it. BUT...

MOST OF THESE ANIMATIONS AND MUSIC ARE NOT MINE!!!

See THIRD_PARTY for credits, original licenses, and usage notes.
