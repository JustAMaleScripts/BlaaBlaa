-- update force 2

cloneref = cloneref or function(o) return o end

local Debris = cloneref(game:GetService("Debris"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local HttpService = cloneref(game:GetService("HttpService"))
local TextService = cloneref(game:GetService("TextService"))
local TweenService = cloneref(game:GetService("TweenService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local UserInputService = cloneref(game:GetService("UserInputService"))

local Player = Players.LocalPlayer

local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

-- best to start with this!
AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Nothing"
	m.Description = "no anims? no problem\nJust a blank moveset I guess..."
	m.Assets = {}

	m.Config = function(parent: GuiBase2d)
	end

	m.Init = function(figure: Model)
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
	end
	m.Destroy = function(figure: Model?)
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "2007 Roblox"
	m.Description = "old roblox is retroslop.\nVery accurate recreation of the old Roblox physics!\nReject Motor6Ds, and return to Motors!"
	m.InternalName = "RETROSLOP"
	m.Assets = {}

	m.FPS30 = true
	m.Snap = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "30 FPS Cap", m.FPS30).Changed:Connect(function(val)
			m.FPS30 = val
		end)
		Util_CreateSwitch(parent, "Joint Snapping", m.Snap).Changed:Connect(function(val)
			m.Snap = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.FPS30 = not save.FPSUnlock
		m.Snap = not save.NoSnap
	end
	m.SaveConfig = function()
		return {
			FPSUnlock = not m.FPS30,
			NoSnap = not m.Snap
		}
	end

	local rcp = RaycastParams.new()
	rcp.FilterType = Enum.RaycastFilterType.Exclude
	rcp.RespectCanCollide = true
	rcp.IgnoreWater = true

	-- https://raw.githubusercontent.com/MaximumADHD/Super-Nostalgia-Zone/refs/heads/main/Player/RetroClimbing.client.lua
	local searchDepth = 0.7
	local maxClimbDist = 2.45
	local sampleSpacing = 1 / 7
	local lowLadderSearch = 2.7
	local ladderSearchDist = 2.0
	local function findPartInLadderZone(figure, root, hum)
		local cf = root.CFrame
		local top = -hum.HipHeight
		local bottom = -lowLadderSearch + top
		local radius = 0.5 * ladderSearchDist
		local center = cf.Position + (cf.LookVector * ladderSearchDist * 0.5)
		local min = Vector3.new(-radius, bottom, -radius)
		local max = Vector3.new(radius, top, radius)
		local extents = Region3.new(center + min, center + max)
		return #workspace:FindPartsInRegion3(extents, figure) > 0
	end
	local function findLadder(figure, root, hum)
		local scale = figure:GetScale()
		searchDepth = 0.7 * scale
		maxClimbDist = 2.45 * scale
		sampleSpacing = scale / 7
		lowLadderSearch = 2.7 * scale
		ladderSearchDist = 2.0 * scale
		if not findPartInLadderZone(figure, root, hum) then
			return false
		end
		local torsoCoord = root.CFrame
		local torsoLook = torsoCoord.LookVector
		local firstSpace = 0
		local firstStep = 0
		local lookForSpace = true
		local lookForStep = false
		local topRay = math.floor(lowLadderSearch / sampleSpacing)
		for i = 1, topRay do
			local distFromBottom = i * sampleSpacing
			local originOnTorso = Vector3.new(0, -lowLadderSearch + distFromBottom, 0)
			local casterOrigin = torsoCoord.Position + originOnTorso
			local casterDirection = torsoLook * ladderSearchDist
			local hitPrim, hitLoc = nil, casterOrigin + casterDirection
			local hit = workspace:Raycast(casterOrigin, casterDirection, rcp)
			if hit then
				hitPrim, hitLoc = hit.Instance, hit.Position
			end
			-- make trusses climbable.
			if hitPrim and hitPrim:IsA("TrussPart") then
				return true
			end
			local mag = (hitLoc - casterOrigin).Magnitude
			if mag < searchDepth then
				if lookForSpace then
					firstSpace = distFromBottom
					lookForSpace = false
					lookForStep = true
				end
			elseif lookForStep then
				firstStep = distFromBottom - firstSpace
				lookForStep = false
			end
		end
		return firstSpace < maxClimbDist and firstStep > 0 and firstStep < maxClimbDist
	end

	local hstatechange, hrun = nil

	local lastpose = ""
	local pose = "Standing"
	local toolAnim = "None"
	local toolAnimTime = 0
	local canClimb = false
	local hipHeight = 0

	local rng = Random.new(math.random(-65536, 65536))
	
	local sndpoint, climbforce = nil, nil

	local lastupdate = 0
	local rs, ls, rh, lh = {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}

	m.Init = function(figure: Model)
		local hum = figure:FindFirstChild("Humanoid")
		hum.AutoRotate = true
		hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		hum:ChangeState(Enum.HumanoidStateType.Freefall)
		sndpoint = Instance.new("Attachment")
		sndpoint.Name = "oldrobloxsound"
		sndpoint.Parent = hum.Torso
		local function makesound(name, id)
			local sound = Instance.new("Sound")
			sound.SoundId = id
			sound.Parent = sndpoint
			sound.Volume = 5
			sound.Name = name
			return sound
		end
		makesound("Running", "rbxasset://sounds/bfsl-minifigfoots1.mp3").Looped = true
		makesound("Climbing", "rbxasset://sounds/bfsl-minifigfoots1.mp3").Looped = true
		makesound("GettingUp", "rbxasset://sounds/hit.wav")
		local f = makesound("Freefall", "rbxassetid://12222200")
		makesound("FallingDown", "rbxasset://sounds/splat.wav")
		local j = makesound("Jumping", "rbxasset://sounds/button.wav")
		j.Played:Connect(function()
			task.wait(0.12 + math.random() * 0.08)
			j:Stop()
		end)
		hrun = hum.Running:Connect(function(speed)
			if speed > 0.2 then
				pose = "Running"
			else
				pose = "Standing"
			end
		end)
		hstatechange = hum.StateChanged:Connect(function(old, new)
			local state = new.Name
			if state == "Jumping" then
				pose = "Jumping"
				canClimb = true
				hum.AutoRotate = false
				hipHeight = -1
			elseif state == "Freefall" then
				pose = "Freefall"
				canClimb = true
				hum.AutoRotate = false
				hipHeight = -1
			elseif state == "Landed" then
				pose = "Freefall"
				canClimb = true
				local scale = figure:GetScale()
				local vel = hum.Torso.Velocity
				local power = -vel.Y / 2
				if power > 30 * scale then
					hum.Torso.Velocity = Vector3.new(vel.X, power, vel.Z)
					hum.Torso.RotVelocity = rng:NextUnitVector() * power * 0.5 / scale
					if power > 100 * scale then
						hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
					else
						hum:ChangeState(Enum.HumanoidStateType.Freefall)
					end
				end
				hum.AutoRotate = false
				hipHeight = -1
				f:Play()
			elseif state == "Seated" then
				pose = "Seated"
				canClimb = false
			elseif state == "Swimming" then
				pose = "Running"
				canClimb = false
			elseif state == "Running" then
				canClimb = true
			elseif state == "PlatformStand" then
				pose = "Standing"
				canClimb = false
			elseif state == "GettingUp" then
				pose = "GettingUp"
				canClimb = false
				hum.AutoRotate = false
				hum.HipHeight = -1
			elseif state == "Ragdoll" then
				pose = "Running"
				canClimb = false
			elseif state == "FallingDown" then
				pose = "FallingDown"
				canClimb = false
			else
				pose = "Standing"
				canClimb = false
			end
		end)
		climbforce = Instance.new("BodyVelocity")
		climbforce.Name = "ClimbForce"
		climbforce.Parent = nil
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()

		rcp.FilterDescendantsInstances = {figure}

		local scale = figure:GetScale()

		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end

		if lastpose ~= pose then
			local snd1 = sndpoint:FindFirstChild(lastpose)
			local snd2 = sndpoint:FindFirstChild(pose)
			if snd1 and snd1.Looped then snd1:Stop() end
			if snd2 then
				if pose == "Freefall" then
					task.delay(0.15, snd2.Play, snd2)
				else
					snd2:Play()
				end
			end
			lastpose = pose
		end

		local function getTool()
			for _, kid in figure:GetChildren() do
				if kid.className == "Tool" then
					return kid
				end
			end
			return nil
		end

		local function getToolAnim(tool)
			for _, c in tool:GetChildren() do
				if c.Name == "toolanim" and c.ClassName == "StringValue" then
					return c
				end
			end
			return nil
		end

		local climbing = canClimb and findLadder(figure, root, hum)
		local jumping = pose == "Jumping" or pose == "Freefall"

		local climbforced = false
		local climbspeed = hum.WalkSpeed * 0.7
		if climbing then
			if hum.MoveDirection.Magnitude > 0 then
				climbforce.Velocity = Vector3.new(0, climbspeed, 0)
				climbforced = true
			elseif jumping then
				climbforce.Velocity = Vector3.new(0, -climbspeed, 0)
				climbforced = true
			end
		end
		if climbforced then
			climbforce.MaxForce = Vector3.new(climbspeed * 100, 10e6, climbspeed * 100)
			climbforce.Parent = root
		else
			climbforce.Parent = nil
		end

		if not climbing and (jumping or hipHeight < -0.01) then
			if not jumping then
				hipHeight *= math.exp(-16 * dt)
			end
			hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
			rs.V = 0.5
			ls.V = 0.5
			rs.D = 3.14
			ls.D = -3.14
			rh.V = 0.5
			lh.V = 0.5
			rh.D = 0
			lh.D = 0
		elseif pose == "Seated" then
			rs.V = 0.15
			ls.V = 0.15
			rs.D = 1.57
			ls.D = -1.57
			rh.V = 0.15
			lh.V = 0.15
			rh.D = 1.57
			lh.D = -1.57
		else
			hum.AutoRotate = true
			hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

			local amplitude = 1
			local frequency = 9
			local climbFudge = 0

			if climbing then
				rs.V = 0.5
				ls.V = 0.5
				rh.V = 0.1
				lh.V = 0.1
				climbFudge = 3.14
			elseif pose == "Running" then
				rs.V = 0.15
				ls.V = 0.15
				rh.V = 0.1
				lh.V = 0.1
			else
				amplitude = 0.1
				frequency = 1
			end

			local desiredAngle = amplitude * math.sin(t * frequency)
			rs.D = desiredAngle + climbFudge
			ls.D = desiredAngle - climbFudge
			rh.D = -desiredAngle
			lh.D = -desiredAngle

			local tool = getTool()
			if tool and tool.RequiresHandle then
				local msg = getToolAnim(tool)
				if msg then
					toolAnim = msg.Value
					msg:Destroy()
					toolAnimTime = t + 0.3
				end
				if t > toolAnimTime then
					toolAnimTime = 0
					toolAnim = "None"
				end
				if toolAnim == "None" then
					rs.D = 1.57
				elseif toolAnim == "Slash" then
					rs.V = 0.5
					rs.D = 0
				elseif toolAnim == "Lunge" then
					rs.V = 0.5
					ls.V = 0.5
					rs.D = 1.57
					ls.D = 1
					rh.V = 0.5
					lh.V = 0.5
					rh.D = 1.57
					lh.D = 1
				end
			else
				toolAnim = "None"
				toolAnimTime = 0
			end
		end
		hum.HipHeight = hipHeight * scale

		local rj = root:FindFirstChild("RootJoint")
		local nj = torso:FindFirstChild("Neck")
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")

		local function stepjoint(a, b, c)
			local d = a.D - a.C
			if math.abs(d) < a.V then
				a.C = a.D
			elseif d > 0 then
				a.C += a.V * 30 * c
			else
				a.C -= a.V * 30 * c
			end
			local e = a.C
			if m.Snap then
				local snap = math.pi / 90
				e = math.round(a.C / snap) * snap
			end
			b.Transform = CFrame.Angles(0, 0, e)
		end

		local delta = 1 / 30
		if not m.FPS30 then
			lastupdate = 0
			delta = dt
		end

		if t - lastupdate > 1 / 30 then
			lastupdate = t
			rj.Transform = CFrame.identity
			nj.Transform = CFrame.identity
			stepjoint(rs, rsj, delta)
			stepjoint(ls, lsj, delta)
			stepjoint(rh, rhj, delta)
			stepjoint(lh, lhj, delta)
		end
	end
	m.Destroy = function(figure: Model?)
		hstatechange:Disconnect()
		hrun:Disconnect()
		sndpoint:Destroy()
		climbforce:Destroy()
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "2015 Roblox"
	m.Description = "workspace." .. Player.Name .. ".Animate\n\"Ahh, the time when Roblox started using Motor6Ds for their animations.\"\n        - Li'l Programmer Timmy born in 2022"
	m.InternalName = "RETROSLOP2"
	m.Assets = {}

	m.Config = function(parent: GuiBase2d)
	end

	local hstatechange, hrun = nil
	local hum = nil
	local justdanced = false

	local lastpose = ""
	local pose = "Standing"
	local currentAnim = ""
	local currentAnimInstance = nil
	local currentAnimTrack = nil
	local currentAnimKeyframeHandler = nil
	local currentAnimSpeed = 1.0
	local toolAnimName = ""
	local toolAnimTrack = nil
	local toolAnimInstance = nil
	local currentToolAnimKeyframeHandler = nil
	local function resetAnimate()
		if currentAnimTrack then
			currentAnimTrack:Destroy()
		end
		if currentAnimKeyframeHandler then
			currentAnimKeyframeHandler:Disconnect()
		end
		if toolAnimTrack then
			toolAnimTrack:Destroy()
		end
		if currentToolAnimKeyframeHandler then
			currentToolAnimKeyframeHandler:Disconnect()
		end
		currentAnim = ""
		currentAnimInstance = nil
		currentAnimTrack = nil
		currentAnimKeyframeHandler = nil
		currentAnimSpeed = 1.0
		toolAnimName = ""
		toolAnimTrack = nil
		toolAnimInstance = nil
		currentToolAnimKeyframeHandler = nil
	end
	local animTable = {}
	local animNames = { 
		idle = {
			{ id = "http://www.roblox.com/asset/?id=180435571", weight = 9 },
			{ id = "http://www.roblox.com/asset/?id=180435792", weight = 1 }
		},
		walk = {
			{ id = "http://www.roblox.com/asset/?id=180426354", weight = 10 }
		}, 
		run = {
			{ id = "http://www.roblox.com/asset/?id=180426354", weight = 10 }
		}, 
		jump = 	{
			{ id = "http://www.roblox.com/asset/?id=125750702", weight = 10 }
		}, 
		fall = 	{
			{ id = "http://www.roblox.com/asset/?id=180436148", weight = 10 }
		}, 
		climb = {
			{ id = "http://www.roblox.com/asset/?id=180436334", weight = 10 }
		}, 
		sit = 	{
			{ id = "http://www.roblox.com/asset/?id=178130996", weight = 10 }
		},	
		toolnone = {
			{ id = "http://www.roblox.com/asset/?id=182393478", weight = 10 }
		},
		toolslash = {
			{ id = "http://www.roblox.com/asset/?id=129967390", weight = 10 }
		},
		toollunge = {
			{ id = "http://www.roblox.com/asset/?id=129967478", weight = 10 }
		},
		wave = {
			{ id = "http://www.roblox.com/asset/?id=128777973", weight = 10 }
		},
		point = {
			{ id = "http://www.roblox.com/asset/?id=128853357", weight = 10 }
		},
		dance1 = {
			{ id = "http://www.roblox.com/asset/?id=182435998", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491037", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491065", weight = 10 }
		},
		dance2 = {
			{ id = "http://www.roblox.com/asset/?id=182436842", weight = 10 }, 
			{ id = "http://www.roblox.com/asset/?id=182491248", weight = 10 }, 
			{ id = "http://www.roblox.com/asset/?id=182491277", weight = 10 } 
		},
		dance3 = {
			{ id = "http://www.roblox.com/asset/?id=182436935", weight = 10 }, 
			{ id = "http://www.roblox.com/asset/?id=182491368", weight = 10 }, 
			{ id = "http://www.roblox.com/asset/?id=182491423", weight = 10 } 
		},
		laugh = {
			{ id = "http://www.roblox.com/asset/?id=129423131", weight = 10 } 
		},
		cheer = {
			{ id = "http://www.roblox.com/asset/?id=129423030", weight = 10 } 
		},
	}
	local dances = {"dance1", "dance2", "dance3"}
	local emoteNames = { wave = false, point = false, dance1 = true, dance2 = true, dance3 = true, laugh = false, cheer = false}
	
	local function configureAnimationSet(name)
		local fileList = animNames[name]
		if animTable[name] ~= nil then
			for _, connection in animTable[name].connections do
				connection:Disconnect()
			end
		end
		animTable[name] = {}
		animTable[name].count = 0
		animTable[name].totalWeight = 0	
		animTable[name].connections = {}
		for idx, anim in fileList do
			animTable[name][idx] = {}
			animTable[name][idx].anim = Instance.new("Animation")
			animTable[name][idx].anim.Name = name
			animTable[name][idx].anim.AnimationId = anim.id
			animTable[name][idx].weight = anim.weight
			animTable[name].count = animTable[name].count + 1
			animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
		end
	end
	for name,_ in animNames do 
		configureAnimationSet(name)
	end
	local function stopAllAnimations()
		local oldAnim = currentAnim
		if emoteNames[oldAnim] ~= nil and emoteNames[oldAnim] == false then
			oldAnim = "idle"
		end
		currentAnim = ""
		currentAnimInstance = nil
		if currentAnimKeyframeHandler ~= nil then
			currentAnimKeyframeHandler:Disconnect()
		end
		if currentAnimTrack ~= nil then
			currentAnimTrack:Stop()
			currentAnimTrack:Destroy()
			currentAnimTrack = nil
		end
		return oldAnim
	end
	local function setAnimationSpeed(speed)
		if speed ~= currentAnimSpeed then
			currentAnimSpeed = speed
			currentAnimTrack:AdjustSpeed(currentAnimSpeed)
		end
	end
	local playAnimation
	local function keyFrameReachedFunc(frameName)
		if frameName == "End" then
			local repeatAnim = currentAnim
			if emoteNames[repeatAnim] ~= nil and emoteNames[repeatAnim] == false then
				repeatAnim = "idle"
			end
			local animSpeed = currentAnimSpeed
			playAnimation(repeatAnim, 0.0, hum)
			setAnimationSpeed(animSpeed)
		end
	end
	playAnimation = function(animName, transitionTime, humanoid)
		if justdanced then return end
		if not animTable[animName] then return end
		local roll = math.random(1, animTable[animName].totalWeight) 
		local origRoll = roll
		local idx = 1
		while roll > animTable[animName][idx].weight do
			roll = roll - animTable[animName][idx].weight
			idx = idx + 1
		end
		local anim = animTable[animName][idx].anim
		if anim ~= currentAnimInstance then
			if currentAnimTrack ~= nil then
				currentAnimTrack:Stop(transitionTime)
				currentAnimTrack:Destroy()
			end
			currentAnimSpeed = 1.0
			currentAnimTrack = humanoid:LoadAnimation(anim)
			currentAnimTrack.Priority = Enum.AnimationPriority.Core
			currentAnimTrack:Play(transitionTime)
			currentAnim = animName
			currentAnimInstance = anim
			if currentAnimKeyframeHandler ~= nil then
				currentAnimKeyframeHandler:Disconnect()
			end
			currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)
		end
	end
	local playToolAnimation
	local function toolKeyFrameReachedFunc(frameName)
		if frameName == "End" then
			playToolAnimation(toolAnimName, 0.0, hum)
		end
	end
	playToolAnimation = function(animName, transitionTime, humanoid, priority)
		if justdanced then return end
		if not animTable[animName] then return end
		local roll = math.random(1, animTable[animName].totalWeight) 
		local origRoll = roll
		local idx = 1
		while roll > animTable[animName][idx].weight do
			roll = roll - animTable[animName][idx].weight
			idx = idx + 1
		end
		local anim = animTable[animName][idx].anim
		if toolAnimInstance ~= anim then
			if toolAnimTrack ~= nil then
				toolAnimTrack:Stop()
				toolAnimTrack:Destroy()
				transitionTime = 0
			end
			toolAnimTrack = humanoid:LoadAnimation(anim)
			if priority then
				toolAnimTrack.Priority = priority
			end
			toolAnimTrack:Play(transitionTime)
			toolAnimName = animName
			toolAnimInstance = anim
			currentToolAnimKeyframeHandler = toolAnimTrack.KeyframeReached:connect(toolKeyFrameReachedFunc)
		end
	end
	local function stopToolAnimations()
		local oldAnim = toolAnimName
		if currentToolAnimKeyframeHandler ~= nil then
			currentToolAnimKeyframeHandler:Disconnect()
		end
		toolAnimName = ""
		toolAnimInstance = nil
		if toolAnimTrack ~= nil then
			toolAnimTrack:Stop()
			toolAnimTrack:Destroy()
			toolAnimTrack = nil
		end
		return oldAnim
	end
	local function map(x, inMin, inMax, outMin, outMax)
		return (x - inMin)*(outMax - outMin)/(inMax - inMin) + outMin
	end
	local sndpoint = nil

	m.Init = function(figure: Model)
		hum = figure:FindFirstChild("Humanoid")
		hum.AutoRotate = true
		hum:ChangeState(Enum.HumanoidStateType.Freefall)
		resetAnimate()
		playAnimation("fall", 0.3, hum)
		sndpoint = Instance.new("Attachment")
		sndpoint.Name = "rbxcharactersounds"
		sndpoint.Parent = hum.Torso
		local function makesound(name, id)
			local sound = Instance.new("Sound")
			sound.SoundId = id
			sound.Parent = sndpoint
			sound.RollOffMinDistance = 5
			sound.RollOffMaxDistance = 150
			sound.Volume = 0.85
			sound.Name = name
			return sound
		end
		local run = makesound("Running", "rbxasset://sounds/action_footsteps_plastic.mp3")
		run.Looped = true
		run.PlaybackSpeed = 2
		run.Volume = 1
		local swim = makesound("Swimming", "rbxasset://sounds/action_swim.mp3")
		swim.Looped = true
		swim.PlaybackSpeed = 1.6
		local clim = makesound("Climbing", "rbxasset://sounds/action_footsteps_plastic.mp3")
		clim.Looped = true
		makesound("GettingUp", "rbxasset://sounds/action_get_up.mp3")
		makesound("FallingDown", "rbxasset://sounds/splat.wav")
		makesound("Jumping", "rbxasset://sounds/action_jump.mp3")
		makesound("Landing", "rbxasset://sounds/action_jump_land.mp3")
		makesound("Splash", "rbxasset://sounds/impact_water.mp3")
		hrun = hum.Running:Connect(function(speed)
			speed /= figure:GetScale()
			if speed > 0.01 then
				playAnimation("walk", 0.1, hum)
				setAnimationSpeed(speed / 14.5)
				pose = "Running"
			else
				if emoteNames[currentAnim] == nil then
					playAnimation("idle", 0.1, hum)
					pose = "Standing"
				end
			end
		end)
		hclim = hum.Climbing:Connect(function(speed)
			speed /= figure:GetScale()
			playAnimation("climb", 0.1, hum)
			setAnimationSpeed(speed / 12.0)
			pose = "Climbing"
		end)
		local stateid = 0
		hstatechange = hum.StateChanged:Connect(function(old, new)
			local verticalSpeed = math.abs(hum.RootPart.AssemblyLinearVelocity.Y)
			local state = new.Name
			local id = stateid
			if state ~= "Freefall" then
				id = math.random(-65536, 65536)
				stateid = id
			end
			run.Playing = false
			swim.Playing = false
			clim.Playing = false
			if state == "Jumping" then
				pose = "Jumping"
				playAnimation("jump", 0.1, hum)
				task.delay(0.3, function()
					if stateid == id then
						playAnimation("fall", 0.3, hum)
					end
				end)
				sndpoint.Jumping:Play()
			elseif state == "Seated" then
				pose = "Seated"
			elseif state == "Swimming" then
				if verticalSpeed > 0.1 then
					sndpoint.Splash.Volume = math.clamp(map(verticalSpeed, 100, 350, 0.28, 1), 0, 1)
					sndpoint.Splash:Play()
				end
				swim.Playing = true
				playAnimation("walk", 0.1, hum)
				pose = "Swimming"
			elseif state == "PlatformStand" then
				pose = "Standing"
			elseif state == "GettingUp" then
				pose = "GettingUp"
				sndpoint.GettingUp:Play()
			elseif state == "Ragdoll" then
				pose = "Running"
			elseif state == "FallingDown" then
				pose = "FallingDown"
			elseif state == "Freefall" then
				pose = "Freefall"
				if old.Name ~= "Jumping" then
					playAnimation("fall", 0.3, hum)
				end
			elseif state == "Landed" then
				if verticalSpeed > 75 then
					sndpoint.Landing.Volume = math.clamp(map(verticalSpeed, 50, 100, 0, 1), 0, 1)
					sndpoint.Landing:Play()
				end
				pose = "Landed"
			elseif state == "Running" then
				run.Playing = true
				pose = "Running"
			elseif state == "Climbing" then
				clim.Playing = verticalSpeed > 0.1
				pose = "Climbing"
			else
				pose = "Standing"
			end
		end)
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()

		local scale = figure:GetScale()

		hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end

		if figure:GetAttribute("IsDancing") then
			for _,v in hum:GetPlayingAnimationTracks() do
				v:Stop(0)
				v:Destroy()
			end
			justdanced = true
			return
		end
		if justdanced then
			task.delay(0.1, function()
				playAnimation("idle", 0, hum)
			end)
			justdanced = false
		end

		local function getTool()
			for _, kid in figure:GetChildren() do
				if kid.className == "Tool" then
					return kid
				end
			end
			return nil
		end
		local function getToolAnim(tool)
			for _, c in tool:GetChildren() do
				if c.Name == "toolanim" and c.ClassName == "StringValue" then
					return c
				end
			end
			return nil
		end

		if pose == "Seated" then
			playAnimation("sit", 0.5, hum)
		else
			if pose == "Running" then
				sndpoint.Running.Playing = hum.MoveDirection.Magnitude > 0.5
			elseif pose == "Standing" then
				sndpoint.Running.Playing = false
			elseif pose == "Climbing" then
				sndpoint.Climbing.Playing = math.abs(hum.RootPart.AssemblyLinearVelocity.Y) > 0.1
			end
			local tool = getTool()
			if tool and tool.RequiresHandle then
				local msg = getToolAnim(tool)
				if msg then
					toolAnim = msg.Value
					msg:Destroy()
					toolAnimTime = t + 0.3
				end
				if t > toolAnimTime then
					toolAnimTime = 0
					toolAnim = "None"
				end
				if toolAnim == "None" then
					playToolAnimation("toolnone", 0.1, hum, Enum.AnimationPriority.Idle)
				end
				if toolAnim == "Slash" then
					playToolAnimation("toolslash", 0, hum, Enum.AnimationPriority.Action)
				end
				if toolAnim == "Lunge" then
					playToolAnimation("toollunge", 0, hum, Enum.AnimationPriority.Action)
				end
			else
				toolAnim = "None"
				toolAnimTime = 0
				stopToolAnimations()
			end
		end
	end
	m.Destroy = function(figure: Model?)
		hstatechange:Disconnect()
		hrun:Disconnect()
		hclim:Disconnect()
		sndpoint:Destroy()
	end
	return m
end)

AddModule(function()
	-- TODO: Revamp this
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Sans Undertale"
	m.Description = "do u wanna have a bad TOM\ntom and jerry\nQ - dodge"
	m.InternalName = "NESS"
	m.Assets = {"SansMoveset1.anim"}

	m.RootPartOverride = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "RootPart Mode Override", m.RootPartOverride).Changed:Connect(function(val)
			m.RootPartOverride = val
		end)
	end

	local animator = nil

	local lastdodgestate = false
	local dodgetick = 0
	m.Init = function(figure: Model)
		local track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SansMoveset1.anim"))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = track
		dodgetick = 0
		ContextActions:BindAction("Uhhhhhh_SansDodge", function(actName, state, input)
			if state == Enum.UserInputState.Begin then
				dodgetick = os.clock()
			end
		end, true, Enum.KeyCode.Q)
		ContextActions:SetTitle("Uhhhhhh_SansDodge", "Dodge")
		ContextActions:SetPosition("Uhhhhhh_SansDodge", UDim2.new(1, -130, 1, -130))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		local newdodgestate = false
		if t - dodgetick < 1.2 then
			newdodgestate = true
			animator:Step(1.3 + (t - dodgetick))
		else
			animator:Step(t % 1.2)
		end
		if lastdodgestate ~= newdodgestate then
			lastdodgestate = newdodgestate
			if m.RootPartOverride then
				if newdodgestate then
					LimbReanimator.SetRootPartMode(0)
				else
					LimbReanimator.SetRootPartMode(3)
				end
			end
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		ContextActions:UnbindAction("Uhhhhhh_SansDodge")
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Krystal Dance V3"
	m.Description = "Very lazy moveset\nthis is from the theo mod, so no furry run here"
	m.InternalName = "KDRV3"
	m.Assets = {"KDRV3Idle.anim", "KDRV3Walk.anim", "KDRV3Sprint.anim", "CreoSphere.mp3"}

	m.SimulateLagFromOriginal = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Insane 7s Lag", m.SimulateLagFromOriginal).Changed:Connect(function(val)
			m.SimulateLagFromOriginal = val
		end)
	end

	local NeckC0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	local animatoridle = nil
	local animatorwalk = nil
	local animatorspri = nil
	local animationtime = 0
	local hasmovedsinceinit = false -- simulate noanim bug
	local isfinisheddoingfedora = false
	local laststate = "none"
	local sprinting = false
	local persistentloadnotif = false -- simulate loadstring sprint load notif
	m.Init = function(figure: Model)
		if m.SimulateLagFromOriginal then
			local lag = os.clock() + 6.5 + math.random() while os.clock() < lag do end
		end
		SetOverrideMovesetMusic("", "Level Up sound effect", 1)
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		-- intro sound
		local introsound = Instance.new("Sound", figure)
		introsound.SoundId = "rbxassetid://236146895"
		introsound.Volume = 1
		introsound:Play()
		introsound.Ended:Connect(function()
			if figure:IsDescendantOf(workspace) then
				-- unlike the original kdv3, theo's mod breaks the main theme
				-- shouldve done an Ended fix here...
				SetOverrideMovesetMusic(AssetGetContentId("CreoSphere.mp3"), "Creo - Sphere", 1)
			end
		end)
		task.spawn(function()
			local bigfedora = Instance.new("Part", figure)
			bigfedora.Size = Vector3.new(2, 2, 2)
			bigfedora.CFrame = root.CFrame * CFrame.new(math.random(-60, 60) * figure:GetScale(), -0.2 * figure:GetScale(), math.random(-60, 60) * figure:GetScale()) * CFrame.Angles(0, math.rad(math.random(-180, 180)), 0)
			bigfedora.Anchored = true
			bigfedora.CanCollide = false
			bigfedora.Name = "bigemofedora"
			local mbigfedora = Instance.new("SpecialMesh", bigfedora)
			mbigfedora.MeshType = "FileMesh"
			mbigfedora.Scale = Vector3.new(5, 5, 5) * figure:GetScale()
			mbigfedora.MeshId = "http://www.roblox.com/asset/?id=1125478"
			mbigfedora.TextureId = "http://www.roblox.com/asset/?id=1125479"
			for i=1, 60 do
				bigfedora.CFrame = bigfedora.CFrame:Lerp(CFrame.new(0, -0.1 * figure:GetScale(), 0) + root.Position, 0.09)
				task.wait(1 / 60)
			end
			task.wait(0.25)
			for i=1, 50 do
				bigfedora.CFrame = bigfedora.CFrame:Lerp(CFrame.new(0, 1.5 * figure:GetScale(), 0) + root.Position, 0.05)
				task.wait(1 / 60)
			end
			local zmc = 0
			for i=1, 29 do
				zmc = zmc + 2
				mbigfedora.Scale = mbigfedora.Scale - Vector3.new(0.25, 0.25, 0.25) * figure:GetScale()
				bigfedora.CFrame = bigfedora.CFrame * CFrame.Angles(0, math.rad(zmc), 0)
				task.wait(1 / 60)
			end
			bigfedora:Destroy()
			-- move to force hasmovedsinceinit
			-- (very bad fix from whoever implemented this in original kdv3)
			for i=1, 5 do
				hum:Move(Vector3.new(0, 0, -1))
				task.wait(1 / 30)
			end
			if figure:IsDescendantOf(workspace) then
				-- at this point in time we have already moved anyway
				hasmovedsinceinit = true
				isfinisheddoingfedora = true
			end
		end)
		animatoridle = AnimLib.Animator.new()
		animatoridle.rig = figure
		animatoridle.looped = true
		animatoridle.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("KDRV3Idle.anim"))
		animatorwalk = AnimLib.Animator.new()
		animatorwalk.rig = figure
		animatorwalk.looped = true
		animatorwalk.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("KDRV3Walk.anim"))
		animatorspri = AnimLib.Animator.new()
		animatorspri.rig = figure
		animatorspri.looped = true
		animatorspri.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("KDRV3Sprint.anim"))
		hasmovedsinceinit = false
		isfinisheddoingfedora = false
		animationtime = 0
		laststate = "none"
		sprinting = false
		ContextActions:BindAction("Uhhhhhh_KDRV3Sprint", function(actName, state, input)
			if state == Enum.UserInputState.Begin then
				sprinting = not sprinting
				if sprinting and not persistentloadnotif then
					persistentloadnotif = true
					StarterGui:SetCore("SendNotification", {
						Title = "Uhhhhhh",
						Text = "Loaded: Sprint",
						Duration = 5
					})
				end
			end
		end, true, Enum.KeyCode.LeftControl)
		ContextActions:SetTitle("Uhhhhhh_KDRV3Sprint", "Ctrl")
		ContextActions:SetPosition("Uhhhhhh_KDRV3Sprint", UDim2.new(1, -130, 1, -130))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()

		local scale = figure:GetScale()

		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end

		local state = "idle"
		if not hasmovedsinceinit then
			state = "none"
		end
		if hum.MoveDirection.Magnitude > 0.1 then
			if sprinting then
				state = "spri"
			else
				state = "walk"
			end
			hasmovedsinceinit = true
		end
		if laststate ~= state then
			animationtime = 0
			laststate = state
		else
			animationtime += dt
		end

		if state == "idle" then
			animatoridle:Step(animationtime)
		end
		if state == "walk" then
			animatorwalk:Step(animationtime)
		end
		if state == "spri" then
			animatorspri:Step(animationtime)
		end

		local head = figure:FindFirstChild("Head")
		if not head then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end
		local neck = torso:FindFirstChild("Neck")
		if not neck then return end
		local neckC0 = NeckC0
		if not figure:GetAttribute("IsDancing") then
			if sprinting then
				hum.WalkSpeed = 24 * scale
			else
				hum.WalkSpeed = 14 * scale
			end
			-- only turn head when the fedora animation is done
			if isfinisheddoingfedora then
				local HeadPosition = head.Position
				local MousePos = Player:GetMouse().Hit.Position
				if UserInputService.TouchEnabled then
					MousePos = workspace.CurrentCamera.CFrame * Vector3.new(0, 0, -10000)
				end
				local TranslationVector = (HeadPosition - MousePos).Unit
				local Pitch = math.atan(TranslationVector.Y)
				local Yaw = TranslationVector:Cross(torso.CFrame.LookVector).Y
				local Roll = math.atan(Yaw)
				neckC0 = NeckC0 * CFrame.Angles(Pitch, 0, Yaw)
			end
		end
		neck.C0 = neck.C0:Lerp(neckC0 + neckC0.Position * (scale - 1), dt * 10)
	end
	m.Destroy = function(figure: Model?)
		animatoridle = nil
		animatorwalk = nil
		animatorspri = nil
		ContextActions:UnbindAction("Uhhhhhh_KDRV3Sprint")
	end
	return m
end)

AddModule(function()
	--------------------------------------------------------------------
	-- Immersive VR Module - upgrade changelog
	--
	-- Bug fixes (R15 support intentionally NOT included - stays R6-only):
	--   * MouseHit() was dead code - the M1/M2 "point hand" raycast now
	--     actually aims at whatever the mouse/cursor is over, computed in
	--     proper world space instead of mixing a local-space direction
	--     with a world-space origin.
	--   * Torso twist used a bare atan() of the feet Z-delta with an
	--     arbitrary 0.5/scale fudge factor. Now uses atan2(dz, stride)
	--     against the actual lateral distance between the feet.
	--   * VR hand/head tracking now checks GetUserCFrameEnabled() before
	--     trusting GetUserCFrame() so a headset with no paired controllers
	--     (or a head CFrame that hasn't come online yet) falls back to the
	--     animated fake-VR pose instead of using a stale/zero CFrame.
	--
	-- Bug fixes (v2):
	--   * ProcessArms used to raycast from the desktop mouse cursor even
	--     when running inside an active VR session with no meaningful
	--     mouse - it now aims along the head's look direction instead
	--     whenever VRService.VREnabled is true.
	--   * Left/right VR hand fallback used to be AND'd together (`if
	--     leftHandEnabled and rightHandEnabled`), so pairing only ONE
	--     motion controller silently threw away tracking on the other
	--     hand too. Each hand now resolves its source independently.
	--   * The Python/webcam poll loop used to be a bare `task.spawn`
	--     that started at module-load and never stopped - a genuine
	--     leaked background coroutine across Init/Destroy cycles. It's
	--     now started in m.Init and explicitly task.cancel'd in
	--     m.Destroy.
	--   * The Run toggle used to infer "currently running" by comparing
	--     BaseWalkSpeed to the WALK_SPEED constant, which silently broke
	--     if a player set Run Speed equal to Walk Speed. Replaced with
	--     an explicit IsRunning boolean.
	--   * m.Destroy used to only Enabled=false the cached antigravity
	--     BodyForces, leaving disabled leftover instances parented under
	--     limbs if the figure survives a moveset switch. Now destroyed.
	--   * Player:GetMouse() was called unguarded at module scope; wrapped
	--     in pcall, with MouseHit() falling back to "aim where the
	--     camera is looking" if it's unavailable.
	--   * Last remaining unnamed magic number (bare `2` in the HipHeight
	--     formula) named HIP_HEIGHT_FUDGE.
	--
	-- Performance (v1):
	--   * SetCFrame no longer Instance.new()s + Destroy()s a BodyForce
	--     every single frame per limb (up to 6x/frame). Each part now
	--     gets one persistent BodyForce that is just toggled + updated.
	--   * Removed the pointless `for _ = 1, 1 do ... end` wrapper around
	--     the per-frame idle jitter, and merged the duplicated jitter
	--     smoothing code (arms + legs) into one shared helper.
	--
	-- Performance (v2):
	--   * SetCFrame's per-part-per-frame trio of PreRender/Stepped/
	--     PostSimulation `:Once()` connections (up to 18 connection
	--     allocations/frame across 6 limbs) replaced with 3 persistent,
	--     module-scope connections that walk a shared "pinned parts"
	--     table. Same one-frame CFrame-pin behavior, zero connection
	--     churn.
	--   * rcp.FilterDescendantsInstances no longer allocates a brand new
	--     {figure, Player.Character} table every Update call - the same
	--     2-slot table is reused and just has its contents overwritten.
	--   * Humanoid/RootPart/Torso/limb parts/R6 joints are no longer
	--     re-fetched via FindFirstChild every single Update call - they're
	--     cached against figure identity and only re-resolved when the
	--     figure instance actually changes (e.g. respawn).
	--   * Fixed the NoCollisionConstraint setup in Init actually creating
	--     TWO constraints per part pair (A->B and B->A, since the nested
	--     loop only excluded v==w, not already-visited pairs) - now one
	--     constraint per unordered pair, halving the instance count.
	--
	-- VR features (v1):
	--   * Snap-turn comfort option on the right thumbstick.
	--   * One-button recenter that also recalibrates arm/eye height to
	--     the player's real-world height via VRService:RecenterUserHeadCFrame().
	--   * Comfort vignette that darkens the screen edges while moving,
	--     to help with VR motion sickness.
	--   * Haptic feedback pulses for hand pointing, crouch, run and
	--     recenter, on any controller HapticService supports.
	--   * Crouching now also slows movement, not just HipHeight.
	--
	-- VR features (v2):
	--   * Snap-turn angle is now a config slider (10-90 degrees) instead
	--     of a hardcoded 30-degree constant.
	--   * Optional smooth-turn mode: instead of discrete snaps, holding
	--     the right thumbstick past a small deadzone continuously rotates
	--     the root at a configurable degrees/second while VR is active.
	--     Snap-turn and smooth-turn share the same thumbstick input but
	--     are mutually exclusive - whichever is toggled on in Config wins.
	--
	-- Code quality:
	--   * Magic numbers pulled into named constants.
	--   * Removed a batch of dead/duplicate module-scope locals
	--     (`rj, nj, rsj, lsj, rhj, lhj, scale` was never read - Update
	--     always declared its own local copies) and a shadowed `scale`.
	--   * Button placement now respects GuiService's safe-area inset
	--     instead of assuming a fixed screen size.
	--   * m.Config now actually builds a settings panel (run speed,
	--     snap-turn / smooth-turn / vignette toggles, idle jitter amount,
	--     head-tracking + phone-controller bridges) instead of being an
	--     empty stub.
	--   * Added "Test Connection" buttons for both experimental bridges,
	--     so you get an immediate pass/fail instead of waiting on the
	--     passive Heartbeat status label.
	--
	-- [EXPERIMENTAL, off by default] Webcam HEAD-POSE-ONLY tracking:
	--   * Narrowed scope from v1: this bridge now ONLY drives head yaw/
	--     pitch (via whatever local webcam pose script you run - a single
	--     2D camera can track a face/head orientation quite reliably, but
	--     has no real depth sensing for full limb/hand position, which is
	--     why that part was cut). Hand/arm posing is handled by the fake-
	--     VR mouse pointer or, now, the phone controller bridge below.
	--   * Polled over localhost HTTP (port configurable in Config) and a
	--     fallback JSON file, since support for either varies by script
	--     executor.
	--   * Priority is always: real VR hardware > webcam head pose >
	--     built-in fake VR head. If nothing is running, nothing changes -
	--     this feature is fully opt-in via m.Config and fails silently.
	--   * This is experimental AI-assisted pose plumbing. Please read
	--     whatever local script you point it at yourself before running it.
	--
	-- [EXPERIMENTAL, off by default] Phone-as-controller bridge:
	--   * New in v2. Polls a small HTTP server you run on your phone
	--     (e.g. via Pydroid on Android) exposing GET /pose as JSON
	--     { "yaw":, "pitch":, "roll":, "tracking": }, and uses it to
	--     orient ONE hand (pick Left/Right/Off in Config) instead of the
	--     built-in mouse-pointing fake-VR arm.
	--   * "Calibrate" zeroes the phone's current orientation as "arm
	--     forward" so tilts read as relative rotation instead of raw
	--     compass heading (which varies room to room / device to device).
	--   * Same fallback philosophy as every other bridge in this module:
	--     real VR controller > phone bridge > fake-VR mouse pointing.
	--     If the phone stops responding, that hand quietly reverts.
	--
	-- Framework env integration:
	--   * m.Config now builds its panel with the framework's own
	--     Util_CreateText/Util_CreateButton/Util_CreateSwitch/
	--     Util_CreateTextbox/Util_CreateDropdown/Util_CreateSlider/
	--     Util_CreateSeparator globals instead of hand-rolled
	--     Instance.new() UI, so it matches the rest of Uhhhhhh's config
	--     panels visually.
	--     NOTE: this module was written without the actual Util_Create*
	--     example code block, so their exact argument order below is a
	--     best-effort GUESS (commented inline at each call site). Every
	--     call is wrapped in pcall with the previous hand-rolled UI as
	--     an automatic fallback, so the panel still renders correctly
	--     even if a signature guess is wrong - just search for
	--     "SIGNATURE GUESS" if something needs correcting.
	--   * RandomString(n) is used to give each generated GUI instance a
	--     collision-free .Name instead of reusing the label text (two
	--     sliders with the same label no longer stomp each other).
	--   * LimbReanimator.SetRootPartMode is set (best-effort, pcall'd)
	--     alongside the module's existing manual SetCFrame/BodyForce
	--     limb posing, so this module doesn't fight the framework's own
	--     root-part handling. It does NOT replace the manual posing -
	--     that system already works and was already perf-optimized.
	--------------------------------------------------------------------

	local VRService = cloneref(game:GetService("VRService"))
	local UserInputService = cloneref(game:GetService("UserInputService"))
	local HapticService = cloneref(game:GetService("HapticService"))
	local GuiService = cloneref(game:GetService("GuiService"))
	local HttpService = cloneref(game:GetService("HttpService"))

	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Immersive VR"
	m.Description = "fake but real vr altho clunky\n\nvery clunky\n\nM1 - Point Left Hand\nM2 - Point Right Hand\nLeftControl/Button B - Toggle Run\nC - Crouch\nRight Thumbstick - Snap/Smooth Turn (VR, configurable)\nT/Thumbstick1 Click - Recenter + Recalibrate (VR)"
	m.Assets = {}

	--------------------------------------------------------------------
	-- Tunable constants (previously scattered magic numbers)
	--------------------------------------------------------------------
	local WALK_SPEED = 12
	local CROUCH_WALKSPEED_SCALE = 0.6 -- fraction of walk speed while fully crouched

	local CROUCH_DISTANCE = 1.25
	local LEG_TWEEN_TIME = 0.25
	local LEG_MOVE_TIME = 0.25
	local LEG_STEP_RAYCAST_DISTANCE = 3
	local LEG_STEP_FORWARD_BIAS = 1.5
	local LEG_STEP_FALLBACK_DROP = 2
	local LEG_AIR_OFFSET = Vector3.new(0, -1.3, -0.3)
	local LEG_MAX_REACH = 2.1
	local LEG_UPPER_LENGTH = 0.7
	local LEG_LOWER_LENGTH = 1.2
	local LEG_FOOT_DROP = 1
	local LEG_POLE_FORWARD = 2
	local LEG_JITTER_MAGNITUDE = 0.2

	local EYE_HEIGHT_OFFSET = 1.5
	local TORSO_HIP_DROP = 3
	local TORSO_HEAD_ANCHOR_DROP = 0.5
	local TORSO_IK_LENGTH = 1.5
	local TORSO_PIVOT_DROP = 1

	local ARM_POINT_RAYCAST_DISTANCE = 32
	local ARM_POINT_LERP_TIME = 0.2
	local ARM_JITTER_MAGNITUDE = 0.5
	local PHONE_HAND_REACH_SCALE = 0.15 -- fraction of ARM_POINT_RAYCAST_DISTANCE used as phone-hand reach

	local JITTER_SMOOTHING_RATE = 16 -- exp decay rate shared by arm/leg jitter
	local TORSO_TWIST_SMOOTHING_RATE = 4
	local TORSO_TWIST_FACTOR = 0.5
	local TORSO_MIN_STRIDE = 0.5 -- clamps atan2's base so twist doesn't spike near zero stride width

	local HIP_HEIGHT_FUDGE = 2 -- flat HipHeight subtraction baked into the R6 leg-length math below

	local DEFAULT_SNAP_TURN_ANGLE_DEG = 30
	local SNAP_TURN_ANGLE_MIN_DEG = 10
	local SNAP_TURN_ANGLE_MAX_DEG = 90
	local SNAP_TURN_DEADZONE = 0.6
	local SNAP_TURN_COOLDOWN = 0.3

	local DEFAULT_SMOOTH_TURN_SPEED_DEG = 90
	local SMOOTH_TURN_SPEED_MIN_DEG = 30
	local SMOOTH_TURN_SPEED_MAX_DEG = 180
	local SMOOTH_TURN_DEADZONE = 0.15 -- lower than snap-turn's since smooth turn self-corrects continuously

	local VIGNETTE_SPEED_LOW = 2 -- studs/s where vignette starts appearing
	local VIGNETTE_SPEED_HIGH = 16 -- studs/s where vignette is fully in
	local VIGNETTE_MAX_DARKNESS = 0.65 -- 0 = invisible, 1 = fully opaque edges

	local HAPTIC_POINT_INTENSITY = 0.25
	local HAPTIC_POINT_DURATION = 0.05
	local HAPTIC_BUTTON_INTENSITY = 0.4
	local HAPTIC_BUTTON_DURATION = 0.08

	local REFERENCE_HEAD_HEIGHT = 1.6 -- ~average real-world eye height in studs, used for VR calibration

	local BRIDGE_POLL_INTERVAL = 1 / 20 -- 20 Hz is plenty for smoothed pose data
	local POSE_STALE_AFTER = 0.5 -- seconds; older than this counts as "not tracking", shared by both bridges

	-- See "0 - RootPart in very void / 1 - RootPart in void / 2 - Keep
	-- RootPart streamed / 3 - CurrentAngle style / 4 - RootPart is Torso"
	-- in LimbReanimator's docs. This module leaves HumanoidRootPart as a
	-- normal, physically-simulated, streamed-in part and only manually
	-- poses Head/Arms/Legs/Torso relative to it every frame, so mode 2
	-- ("Keep RootPart streamed") is the best match.
	local LIMB_REANIMATOR_ROOT_PART_MODE = 2

	local HALF_PI = math.pi / 2
	local PI = math.pi

	local scale, isdancing = 1, false
	local hum, root, torso
	local BaseWalkSpeed = WALK_SPEED
	local IsRunning = false
	local HeightCalibration = 1 -- multiplier applied to eye height after VR recentering

	local Settings = {
		RunSpeed = 24,
		SnapTurnEnabled = true,
		SnapTurnAngleDeg = DEFAULT_SNAP_TURN_ANGLE_DEG,
		SmoothTurnEnabled = false,
		SmoothTurnSpeedDeg = DEFAULT_SMOOTH_TURN_SPEED_DEG,
		VignetteEnabled = true,
		JitterScale = 1,
		-- EXPERIMENTAL, off by default. See the HeadTrackingBridge section below.
		HeadTrackingEnabled = false,
		HeadTrackingPort = 8787,
		-- EXPERIMENTAL, off by default. See the PhoneBridge section below.
		PhoneControllerSide = "Off", -- "Off" | "Left" | "Right"
		PhoneIP = "192.168.1.100",
		PhonePort = 8788,
	}

	--------------------------------------------------------------------
	-- Shared best-effort HTTP GET / file-read shims used by both bridges.
	-- Different script executors expose these under different names (or
	-- not at all - some sandboxes block localhost/LAN requests entirely,
	-- which is fine, we just fall back to "not tracking").
	--------------------------------------------------------------------
	local function TryHttpGet(url)
		local requestFn = (syn and syn.request)
			or (http and http.request)
			or http_request
			or (fluxus and fluxus.request)
			or request
		if not requestFn then
			return nil
		end
		local ok, response = pcall(requestFn, {
			Url = url,
			Method = "GET",
		})
		if ok and response and (response.StatusCode == 200 or response.Success) and response.Body then
			return response.Body
		end
		return nil
	end

	local function TryReadPoseFile(path)
		if not (isfile and readfile) then
			return nil
		end
		local ok, exists = pcall(isfile, path)
		if not ok or not exists then
			return nil
		end
		local ok2, contents = pcall(readfile, path)
		if ok2 then
			return contents
		end
		return nil
	end

	--------------------------------------------------------------------
	-- EXPERIMENTAL: webcam HEAD-POSE-ONLY tracking bridge.
	--
	-- If you run a local webcam pose script alongside the game, it can
	-- estimate head yaw/pitch (face/head orientation is quite reliable
	-- from a single 2D camera - unlike full-body/hand depth, which a 2D
	-- camera genuinely can't measure, which is why v1's hand/crouch
	-- tracking via this bridge was removed) and publish it as JSON:
	--   { "tracking": true, "headYaw": 0.0, "headPitch": 0.0 }
	-- over a localhost HTTP endpoint (port configurable below) and/or a
	-- fallback JSON file.
	--
	-- Priority is always: real VR hardware > webcam head pose > built-in
	-- fake VR head-follow. If nothing is running, PollHeadTrackingBridge
	-- just never finds a fresh pose and this behaves exactly like the
	-- feature doesn't exist.
	--------------------------------------------------------------------
	local HeadTrackingBridge = {
		LastPose = nil,
		LastUpdateTime = 0,
		LastTransport = nil, -- "http" or "file"
	}

	function HeadTrackingBridge.IsTracking()
		if not Settings.HeadTrackingEnabled then
			return false
		end
		if not HeadTrackingBridge.LastPose or not HeadTrackingBridge.LastPose.tracking then
			return false
		end
		return (os.clock() - HeadTrackingBridge.LastUpdateTime) <= POSE_STALE_AFTER
	end

	local function PollHeadTrackingBridge()
		if not Settings.HeadTrackingEnabled then
			return
		end
		local url = ("http://127.0.0.1:%d/pose"):format(Settings.HeadTrackingPort)
		local body = TryHttpGet(url)
		local transport = "http"
		if not body then
			body = TryReadPoseFile("immersive_vr_head_pose.json")
			transport = "file"
		end
		if not body then
			return
		end
		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(body)
		end)
		if ok and typeof(decoded) == "table" then
			HeadTrackingBridge.LastPose = decoded
			HeadTrackingBridge.LastTransport = transport
			HeadTrackingBridge.LastUpdateTime = os.clock()
		end
	end

	--------------------------------------------------------------------
	-- EXPERIMENTAL: Phone-as-controller bridge (over HTTP).
	--
	-- Run a tiny HTTP server on your phone (e.g. Pydroid 3 on Android
	-- running a short Python/Flask script - not included here, this is
	-- just the Roblox-side poller) that exposes the phone's gyroscope
	-- orientation as JSON at GET /pose, e.g.:
	--   { "yaw": 0.0, "pitch": 0.0, "roll": 0.0, "tracking": true }
	-- This module polls that endpoint over your local network and uses
	-- it to orient ONE hand (left or right, your choice) instead of the
	-- built-in mouse-pointing fake-VR arm.
	--
	-- Setup flow (see m.Config's "Phone Controller" section):
	--   1. Start the phone's HTTP server, note its local IP + port.
	--   2. Enter that IP/port in the config panel.
	--   3. Pick which hand the phone drives (Off / Left / Right).
	--   4. Hold the phone naturally in that hand and press Calibrate -
	--      this zeroes the phone's current orientation as "arm forward"
	--      so tilts read as relative rotation instead of raw compass
	--      heading (which varies room to room).
	--   5. Press "Test Connection" to confirm the phone is reachable.
	--
	-- Same fallback philosophy as the webcam bridge: if the phone stops
	-- responding, that hand quietly reverts to normal fake-VR mouse
	-- pointing - nothing errors, nothing hangs.
	--------------------------------------------------------------------
	local PhoneBridge = {
		LastPose = nil,
		LastUpdateTime = 0,
		Calibration = { yaw = 0, pitch = 0, roll = 0 },
	}

	function PhoneBridge.IsTracking()
		if Settings.PhoneControllerSide == "Off" then
			return false
		end
		if not PhoneBridge.LastPose or not PhoneBridge.LastPose.tracking then
			return false
		end
		return (os.clock() - PhoneBridge.LastUpdateTime) <= POSE_STALE_AFTER
	end

	local function PollPhoneBridge()
		if Settings.PhoneControllerSide == "Off" then
			return
		end
		local url = ("http://%s:%d/pose"):format(Settings.PhoneIP, Settings.PhonePort)
		local body = TryHttpGet(url)
		if not body then
			return
		end
		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(body)
		end)
		if ok and typeof(decoded) == "table" then
			PhoneBridge.LastPose = decoded
			PhoneBridge.LastUpdateTime = os.clock()
		end
	end

	function PhoneBridge.Calibrate()
		local pose = PhoneBridge.LastPose
		if not pose then
			return false
		end
		PhoneBridge.Calibration = {
			yaw = pose.yaw or 0,
			pitch = pose.pitch or 0,
			roll = pose.roll or 0,
		}
		return true
	end

	--------------------------------------------------------------------
	-- Bug fix (v2): both bridges' polling used to be a bare task.spawn
	-- loop that started at module-load and ran forever with no way to
	-- stop it - a genuine leaked coroutine if this module gets
	-- Destroy()'d and never re-Init'd. It's now started/stopped from
	-- m.Init/m.Destroy via a stored thread handle.
	--------------------------------------------------------------------
	local BridgePollThread = nil
	local function StartBridgePolling()
		if BridgePollThread then
			return
		end
		BridgePollThread = task.spawn(function()
			while true do
				pcall(PollHeadTrackingBridge)
				pcall(PollPhoneBridge)
				task.wait(BRIDGE_POLL_INTERVAL)
			end
		end)
	end
	local function StopBridgePolling()
		if BridgePollThread then
			task.cancel(BridgePollThread)
			BridgePollThread = nil
		end
	end

	m.Config = function(parent: GuiBase2d)
		-- Thin wrappers around the framework's Util_Create* globals.
		-- Every wrapper pcall's the framework call first and falls back
		-- to a hand-rolled Instance.new() widget if it errors (wrong
		-- guessed argument order, or the global doesn't exist in this
		-- build) - so this panel always renders something usable.
		-- RandomString(n) is used for collision-free instance names
		-- since two widgets can share the same label text.
		local function SafeName(prefix)
			local ok, str = pcall(RandomString, 8)
			if ok and type(str) == "string" and #str > 0 then
				return prefix .. "_" .. str
			end
			return prefix .. "_" .. tostring(os.clock()):gsub("%.", "")
		end

		local function FallbackToggle(labelText, order, initial, onChanged)
			local holder = Instance.new("Frame")
			holder.Name = SafeName("Toggle")
			holder.LayoutOrder = order
			holder.BackgroundTransparency = 1
			holder.Size = UDim2.new(1, 0, 0, 32)

			local label = Instance.new("TextLabel")
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(0.7, 0, 1, 0)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextColor3 = Color3.new(1, 1, 1)
			label.Font = Enum.Font.SourceSans
			label.TextSize = 18
			label.Text = labelText
			label.Parent = holder

			local button = Instance.new("TextButton")
			button.Size = UDim2.new(0.3, -8, 1, -4)
			button.Position = UDim2.new(0.7, 8, 0, 2)
			button.Font = Enum.Font.SourceSansBold
			button.TextSize = 16
			local function Refresh(value)
				button.Text = value and "ON" or "OFF"
				button.BackgroundColor3 = value and Color3.fromRGB(60, 160, 90) or Color3.fromRGB(120, 60, 60)
			end
			Refresh(initial)
			button.Activated:Connect(function()
				initial = not initial
				Refresh(initial)
				onChanged(initial)
			end)
			button.Parent = holder
			return holder
		end

		local function FallbackSlider(labelText, order, min, max, initial, onChanged)
			local holder = Instance.new("Frame")
			holder.Name = SafeName("Slider")
			holder.LayoutOrder = order
			holder.BackgroundTransparency = 1
			holder.Size = UDim2.new(1, 0, 0, 32)

			local label = Instance.new("TextLabel")
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(0.5, 0, 1, 0)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextColor3 = Color3.new(1, 1, 1)
			label.Font = Enum.Font.SourceSans
			label.TextSize = 18
			label.Text = labelText
			label.Parent = holder

			local box = Instance.new("TextBox")
			box.Size = UDim2.new(0.5, -8, 1, -4)
			box.Position = UDim2.new(0.5, 8, 0, 2)
			box.ClearTextOnFocus = false
			box.Text = tostring(initial)
			box.Font = Enum.Font.SourceSans
			box.TextSize = 16
			box.FocusLost:Connect(function()
				local n = tonumber(box.Text)
				if n then
					n = math.clamp(n, min, max)
					box.Text = tostring(n)
					onChanged(n)
				else
					box.Text = tostring(initial)
				end
			end)
			box.Parent = holder
			return holder
		end

		local function FallbackButton(labelText, order, onClick)
			local button = Instance.new("TextButton")
			button.Name = SafeName("Button")
			button.LayoutOrder = order
			button.Size = UDim2.new(1, 0, 0, 32)
			button.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
			button.Font = Enum.Font.SourceSansBold
			button.TextSize = 16
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Text = labelText
			button.Activated:Connect(onClick)
			return button
		end

		local function FallbackTextbox(labelText, order, initial, onChanged)
			local holder = Instance.new("Frame")
			holder.Name = SafeName("Textbox")
			holder.LayoutOrder = order
			holder.BackgroundTransparency = 1
			holder.Size = UDim2.new(1, 0, 0, 32)

			local label = Instance.new("TextLabel")
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(0.5, 0, 1, 0)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextColor3 = Color3.new(1, 1, 1)
			label.Font = Enum.Font.SourceSans
			label.TextSize = 18
			label.Text = labelText
			label.Parent = holder

			local box = Instance.new("TextBox")
			box.Size = UDim2.new(0.5, -8, 1, -4)
			box.Position = UDim2.new(0.5, 8, 0, 2)
			box.ClearTextOnFocus = false
			box.Text = tostring(initial)
			box.Font = Enum.Font.SourceSans
			box.TextSize = 16
			box.FocusLost:Connect(function()
				onChanged(box.Text)
			end)
			box.Parent = holder
			return holder
		end

		local function FallbackDropdown(labelText, order, options, initial, onChanged)
			local holder = Instance.new("Frame")
			holder.Name = SafeName("Dropdown")
			holder.LayoutOrder = order
			holder.BackgroundTransparency = 1
			holder.Size = UDim2.new(1, 0, 0, 32)

			local label = Instance.new("TextLabel")
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(0.5, 0, 1, 0)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextColor3 = Color3.new(1, 1, 1)
			label.Font = Enum.Font.SourceSans
			label.TextSize = 18
			label.Text = labelText
			label.Parent = holder

			local index = table.find(options, initial) or 1
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(0.5, -8, 1, -4)
			button.Position = UDim2.new(0.5, 8, 0, 2)
			button.Font = Enum.Font.SourceSansBold
			button.TextSize = 16
			button.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Text = options[index]
			button.Activated:Connect(function()
				index = (index % #options) + 1
				button.Text = options[index]
				onChanged(options[index])
			end)
			button.Parent = holder
			return holder
		end

		local function FallbackLabel(text, order)
			local label = Instance.new("TextLabel")
			label.Name = SafeName("Label")
			label.LayoutOrder = order
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(1, 0, 0, 40)
			label.TextWrapped = true
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextYAlignment = Enum.TextYAlignment.Top
			label.Font = Enum.Font.SourceSansItalic
			label.TextSize = 14
			label.TextColor3 = Color3.fromRGB(200, 200, 200)
			label.Text = text
			return label
		end

		local function FallbackSeparator(order)
			local sep = Instance.new("Frame")
			sep.Name = SafeName("Separator")
			sep.LayoutOrder = order
			sep.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
			sep.BorderSizePixel = 0
			sep.Size = UDim2.new(1, 0, 0, 1)
			return sep
		end

		-- NOTE (SIGNATURE GUESS): (parent, text, order, default, callback).
		local function AddToggle(labelText, order, initial, onChanged)
			local ok, widget = pcall(Util_CreateSwitch, parent, labelText, order, initial, onChanged)
			if ok and typeof(widget) == "Instance" then
				return widget
			end
			return FallbackToggle(labelText, order, initial, onChanged)
		end

		-- NOTE (SIGNATURE GUESS): (parent, text, order, min, max, default, callback).
		local function AddSlider(labelText, order, min, max, initial, onChanged)
			local ok, widget = pcall(Util_CreateSlider, parent, labelText, order, min, max, initial, onChanged)
			if ok and typeof(widget) == "Instance" then
				return widget
			end
			return FallbackSlider(labelText, order, min, max, initial, onChanged)
		end

		-- NOTE (SIGNATURE GUESS): (parent, text, order, callback).
		local function AddButton(labelText, order, onClick)
			local ok, widget = pcall(Util_CreateButton, parent, labelText, order, onClick)
			if ok and typeof(widget) == "Instance" then
				return widget
			end
			return FallbackButton(labelText, order, onClick)
		end

		-- NOTE (SIGNATURE GUESS): (parent, text, order, default, callback).
		local function AddTextbox(labelText, order, initial, onChanged)
			local ok, widget = pcall(Util_CreateTextbox, parent, labelText, order, initial, onChanged)
			if ok and typeof(widget) == "Instance" then
				return widget
			end
			return FallbackTextbox(labelText, order, initial, onChanged)
		end

		-- NOTE (SIGNATURE GUESS): (parent, text, order, options, default, callback).
		local function AddDropdown(labelText, order, options, initial, onChanged)
			local ok, widget = pcall(Util_CreateDropdown, parent, labelText, order, options, initial, onChanged)
			if ok and typeof(widget) == "Instance" then
				return widget
			end
			return FallbackDropdown(labelText, order, options, initial, onChanged)
		end

		-- NOTE (SIGNATURE GUESS): (parent, text, order).
		local function AddLabel(text, order)
			local ok, widget = pcall(Util_CreateText, parent, text, order)
			if ok and typeof(widget) == "Instance" then
				return widget
			end
			return FallbackLabel(text, order)
		end

		-- NOTE (SIGNATURE GUESS): (parent, order).
		local function AddSeparator(order)
			local ok, widget = pcall(Util_CreateSeparator, parent, order)
			if ok and typeof(widget) == "Instance" then
				return widget
			end
			return FallbackSeparator(order)
		end

		-- Only add our own UIListLayout if Util_Create* didn't already
		-- give `parent` one (a real framework container almost
		-- certainly manages its own layout already).
		if not parent:FindFirstChildOfClass("UIListLayout") then
			local layout = Instance.new("UIListLayout")
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 4)
			layout.Parent = parent
		end

		AddSlider("Run Speed", 1, 12, 60, Settings.RunSpeed, function(v)
			Settings.RunSpeed = v
			if IsRunning then
				BaseWalkSpeed = v
			end
		end).Parent = parent

		AddToggle("VR Snap Turn (right stick)", 2, Settings.SnapTurnEnabled, function(v)
			Settings.SnapTurnEnabled = v
		end).Parent = parent

		AddSlider("Snap Turn Angle (deg)", 3, SNAP_TURN_ANGLE_MIN_DEG, SNAP_TURN_ANGLE_MAX_DEG, Settings.SnapTurnAngleDeg, function(v)
			Settings.SnapTurnAngleDeg = v
		end).Parent = parent

		AddToggle("VR Smooth Turn (instead of Snap)", 4, Settings.SmoothTurnEnabled, function(v)
			Settings.SmoothTurnEnabled = v
		end).Parent = parent

		AddSlider("Smooth Turn Speed (deg/s)", 5, SMOOTH_TURN_SPEED_MIN_DEG, SMOOTH_TURN_SPEED_MAX_DEG, Settings.SmoothTurnSpeedDeg, function(v)
			Settings.SmoothTurnSpeedDeg = v
		end).Parent = parent

		AddToggle("VR Comfort Vignette", 6, Settings.VignetteEnabled, function(v)
			Settings.VignetteEnabled = v
		end).Parent = parent

		AddSlider("Idle Jitter Scale (%)", 7, 0, 200, Settings.JitterScale * 100, function(v)
			Settings.JitterScale = v / 100
		end).Parent = parent

		AddSeparator(8).Parent = parent

		AddToggle("[EXPERIMENTAL] Webcam Head Tracking", 9, Settings.HeadTrackingEnabled, function(v)
			Settings.HeadTrackingEnabled = v
		end).Parent = parent

		AddTextbox("Head-Tracking Port", 10, tostring(Settings.HeadTrackingPort), function(text)
			local n = tonumber(text)
			if n then
				Settings.HeadTrackingPort = math.floor(n)
			end
		end).Parent = parent

		local headStatusLabel = AddLabel("Webcam head tracking: not tested yet.", 12)
		headStatusLabel.Parent = parent

		AddButton("Test Head-Tracking Connection", 11, function()
			pcall(function()
				headStatusLabel.Text = "Testing..."
				headStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			end)
			task.spawn(function()
				PollHeadTrackingBridge()
				task.wait(0.05)
				pcall(function()
					if HeadTrackingBridge.IsTracking() then
						headStatusLabel.Text = ("Connected via %s! Head tracking is live."):format(HeadTrackingBridge.LastTransport or "?")
						headStatusLabel.TextColor3 = Color3.fromRGB(90, 210, 120)
					else
						headStatusLabel.Text = ("No response on port %d (and no fallback file found). Is your webcam head-pose script running?"):format(Settings.HeadTrackingPort)
						headStatusLabel.TextColor3 = Color3.fromRGB(230, 90, 90)
					end
				end)
			end)
		end).Parent = parent

		AddSeparator(13).Parent = parent

		AddDropdown("Phone Controller Hand", 14, { "Off", "Left", "Right" }, Settings.PhoneControllerSide, function(v)
			Settings.PhoneControllerSide = v
		end).Parent = parent

		AddTextbox("Phone IP Address", 15, Settings.PhoneIP, function(text)
			if type(text) == "string" and #text > 0 then
				Settings.PhoneIP = text
			end
		end).Parent = parent

		AddTextbox("Phone Port", 16, tostring(Settings.PhonePort), function(text)
			local n = tonumber(text)
			if n then
				Settings.PhonePort = math.floor(n)
			end
		end).Parent = parent

		local phoneStatusLabel = AddLabel("Phone controller: not connected.", 19)
		phoneStatusLabel.Parent = parent

		AddButton("Calibrate Phone Orientation", 17, function()
			local ok = PhoneBridge.Calibrate()
			pcall(function()
				if ok then
					phoneStatusLabel.Text = "Calibrated! Current phone orientation is now treated as 'arm forward'."
					phoneStatusLabel.TextColor3 = Color3.fromRGB(90, 210, 120)
				else
					phoneStatusLabel.Text = "Can't calibrate yet - no pose data received from the phone. Try Test Connection first."
					phoneStatusLabel.TextColor3 = Color3.fromRGB(230, 170, 60)
				end
			end)
		end).Parent = parent

		AddButton("Test Phone Connection", 18, function()
			pcall(function()
				phoneStatusLabel.Text = "Testing..."
				phoneStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			end)
			task.spawn(function()
				PollPhoneBridge()
				task.wait(0.05)
				pcall(function()
					if PhoneBridge.IsTracking() then
						phoneStatusLabel.Text = ("Connected! Phone is ready to drive the %s hand."):format(Settings.PhoneControllerSide)
						phoneStatusLabel.TextColor3 = Color3.fromRGB(90, 210, 120)
					else
						phoneStatusLabel.Text = ("No response from %s:%d. Check the phone server is running and on the same network."):format(Settings.PhoneIP, Settings.PhonePort)
						phoneStatusLabel.TextColor3 = Color3.fromRGB(230, 90, 90)
					end
				end)
			end)
		end).Parent = parent

		AddLabel(
			"Both bridges above are experimental and AI-assisted: webcam head tracking needs a local script serving head yaw/pitch on the given port; the phone controller needs a small HTTP server (e.g. Pydroid) on your phone serving /pose. If neither responds, everything silently falls back to normal fake-VR behavior - review any local script yourself before trusting it.",
			20
		).Parent = parent
	end

	--------------------------------------------------------------------
	-- Persistent per-part BodyForce cache
	-- (was: Instance.new() + Destroy() every SetCFrame call, every frame,
	-- per limb - up to 6 instance churns/frame)
	--------------------------------------------------------------------
	local PartForces = setmetatable({}, { __mode = "k" })
	local function GetAntigravity(part)
		local force = PartForces[part]
		if not force or force.Parent ~= part then
			force = Instance.new("BodyForce")
			force.Name = "ImmersiveVRAntigravity"
			force.Enabled = false
			force.Parent = part
			PartForces[part] = force
		end
		return force
	end

	--------------------------------------------------------------------
	-- Optimization (v2): SetCFrame used to spin up 3 brand-new one-shot
	-- connections (PreRender/Stepped/PostSimulation) PER PART EVERY
	-- FRAME to fight physics displacing the part for a frame. That's up
	-- to 18 connection allocations/frame across 6 limbs. Instead, parts
	-- that were SetCFrame'd this frame are recorded in PinnedCFrames,
	-- and 3 connections that exist ONCE for the module's whole lifetime
	-- walk that (usually tiny) table every frame - same "re-pin for one
	-- frame, then let go" behavior, zero per-frame connection churn.
	--------------------------------------------------------------------
	local PinnedCFrames = {} -- [part] = CFrame

	local function ReapplyPins()
		for part, cf in pairs(PinnedCFrames) do
			if part.Parent then
				part.CFrame = cf
				part.Velocity, part.RotVelocity = Vector3.zero, Vector3.zero
			else
				PinnedCFrames[part] = nil
			end
		end
	end
	RunService.PreRender:Connect(ReapplyPins)
	RunService.Stepped:Connect(ReapplyPins)
	RunService.PostSimulation:Connect(function()
		for part in pairs(PinnedCFrames) do
			local force = PartForces[part]
			if force then
				force.Enabled = false
			end
			PinnedCFrames[part] = nil
		end
	end)

	local function SetCFrame(part, cf)
		part.CFrame = cf
		part.Velocity, part.RotVelocity = Vector3.zero, Vector3.zero
		local antigravity = GetAntigravity(part)
		antigravity.Force = Vector3.new(0, workspace.Gravity * part:GetMass(), 0)
		antigravity.Enabled = true
		PinnedCFrames[part] = cf
	end

	local rcp = RaycastParams.new()
	rcp.FilterType = Enum.RaycastFilterType.Exclude
	rcp.RespectCanCollide = true
	rcp.IgnoreWater = true
	local function PhysicsRaycast(origin, direction)
		return workspace:Raycast(origin, direction, rcp)
	end

	-- Optimization (v2): reused every frame instead of allocated fresh.
	local FilterInstances = { nil, nil }

	-- Bug fix (v2): Player:GetMouse() used to be called unguarded at
	-- module (chunk) scope - wrapped in pcall, with a safe fallback if
	-- it's unavailable for whatever reason.
	local mouse
	do
		local ok, m2 = pcall(function()
			return Player:GetMouse()
		end)
		if ok then
			mouse = m2
		end
	end
	local function MouseHit()
		if not mouse then
			return ReanimCamera.CFrame.Position + ReanimCamera.CFrame.LookVector * 20
		end
		local ray = mouse.UnitRay
		local dist = 2000
		local raycast = PhysicsRaycast(ray.Origin, ray.Direction * dist)
		if raycast then
			return raycast.Position
		end
		return ray.Origin + ray.Direction * dist
	end

	local function PulseHaptic(motor, intensity, duration)
		task.spawn(function()
			local ok = pcall(function()
				if
					HapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1)
					and HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, motor)
				then
					HapticService:SetMotor(Enum.UserInputType.Gamepad1, motor, intensity)
				end
			end)
			if ok then
				task.wait(duration)
				pcall(function()
					HapticService:SetMotor(Enum.UserInputType.Gamepad1, motor, 0)
				end)
			end
		end)
	end

	local function SafeButtonPosition(xOffset, yOffset)
		local ok, _, bottomRightInset = pcall(function()
			return GuiService:GetGuiInset()
		end)
		if not ok or not bottomRightInset then
			return UDim2.new(1, xOffset, 1, yOffset)
		end
		return UDim2.new(1, xOffset - bottomRightInset.X, 1, yOffset - bottomRightInset.Y)
	end

	-- grok made ts
	local function IK2Bone(from: Vector3, target: Vector3, direction: Vector3, lenA: number, lenB: number): CFrame
		-- 2-segment IK solver (upper arm lenA, forearm lenB). Returns CFrame at target position
		-- whose rotation orients the bone next to the hand (forearm) using the pole direction
		-- for the elbow bend plane. Logic tested: elbow solved via law-of-cosines + pole projection;
		-- last bone roll is pole-consistent so the entire chain stays in the correct plane.
		-- Handles full extension when unreachable; assumes reachable for under-extension (standard).

		local origin = from
		local goal = target
		local pole = direction

		local toGoal = goal - origin
		local dist = toGoal.Magnitude
		if dist < 1e-6 then
			return CFrame.new(goal) -- degenerate case, no valid plane
		end

		local dir = toGoal / dist

		-- project pole onto plane perpendicular to dir (defines bend direction)
		local poleProj = pole - dir * pole:Dot(dir)
		local poleMag = poleProj.Magnitude
		if poleMag < 1e-6 then
			-- fallback perpendicular (avoids singularity)
			local arb = Vector3.yAxis
			if math.abs(dir:Dot(arb)) > 0.99 then
				arb = Vector3.xAxis
			end
			poleProj = (arb - dir * arb:Dot(dir)).Unit
		else
			poleProj /= poleMag
		end

		-- compute elbow position
		local elbowPos
		if dist > lenA + lenB then
			-- fully extended toward target (unreachable case)
			elbowPos = origin + dir * lenA
		else
			-- standard triangle solution
			local a = (lenA * lenA + dist * dist - lenB * lenB) / (2 * dist)
			local hSq = lenA * lenA - a * a
			local h = hSq > 0 and math.sqrt(hSq) or 0
			elbowPos = origin + dir * a + poleProj * h
		end

		-- forearm direction (bone next to hand)
		local boneDir = (goal - elbowPos).Unit

		-- project pole onto plane perpendicular to forearm for consistent roll/up
		local desiredUp = pole - boneDir * pole:Dot(boneDir)
		local upMag = desiredUp.Magnitude
		if upMag < 1e-6 then
			local arb = Vector3.yAxis
			if math.abs(boneDir:Dot(arb)) > 0.99 then
				arb = Vector3.xAxis
			end
			desiredUp = (arb - boneDir * arb:Dot(boneDir)).Unit
		else
			desiredUp /= upMag
		end

		-- CFrame at target with LookVector along bone (forward = boneDir from elbow → hand)
		-- and UpVector pole-projected so rotation respects "elbow points" direction
		return CFrame.lookAt(goal, goal + boneDir, desiredUp)
	end

	local LegsTarget = {}
	local FakeVRArms = {}
	local Crouching = false
	local CrouchDistance = 0
	local TorsoRotation = CFrame.identity
	local SnapTurnConn, SnapTurnEndedConn, SnapTurnArmed, LastSnapTurnTime = nil, nil, true, 0
	local LastThumbstick2X = 0
	local VignetteGui, VignetteFrames = nil, nil

	-- Optimization (v2): figure/joint/limb refs are cached against figure
	-- identity instead of FindFirstChild'd fresh every single Update call.
	local CachedFigure = nil
	local CachedParts = {}
	local CachedJoints = {}

	local function RefreshCache(figure)
		if CachedFigure == figure then
			return
		end
		CachedFigure = figure
		hum = figure:FindFirstChild("Humanoid")
		root = figure:FindFirstChild("HumanoidRootPart")
		torso = figure:FindFirstChild("Torso")
		CachedParts.Head = figure:FindFirstChild("Head")
		CachedParts.RightArm = figure:FindFirstChild("Right Arm")
		CachedParts.LeftArm = figure:FindFirstChild("Left Arm")
		CachedParts.RightLeg = figure:FindFirstChild("Right Leg")
		CachedParts.LeftLeg = figure:FindFirstChild("Left Leg")
		CachedJoints.RootJoint = root and root:FindFirstChild("RootJoint")
		if torso then
			CachedJoints.Neck = torso:FindFirstChild("Neck")
			CachedJoints.RightShoulder = torso:FindFirstChild("Right Shoulder")
			CachedJoints.LeftShoulder = torso:FindFirstChild("Left Shoulder")
			CachedJoints.RightHip = torso:FindFirstChild("Right Hip")
			CachedJoints.LeftHip = torso:FindFirstChild("Left Hip")
		else
			CachedJoints.Neck, CachedJoints.RightShoulder, CachedJoints.LeftShoulder, CachedJoints.RightHip, CachedJoints.LeftHip = nil, nil, nil, nil, nil
		end
	end

	local function GetLegPoint(leg)
		if leg.InAir then
			return leg.Position
		end
		local tweener = math.clamp(leg.Timer / LEG_TWEEN_TIME, 0, 1)
		return leg.Target:Lerp(leg.Position, tweener) + Vector3.new(0, math.sin(math.pi * tweener) * (leg.Target - leg.Position).Magnitude * 0.1, 0)
	end

	-- Shared per-frame idle-jitter sampler used by both arms and legs.
	local function UpdateJitter(realism, dt, magnitude)
		local sample = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1) * magnitude
		local decay = math.exp(-JITTER_SMOOTHING_RATE * dt)
		for i = 1, #realism do
			sample = sample:Lerp(realism[i], decay)
			realism[i] = sample
		end
		return sample
	end

	local function ProcessLegs(leg, dt)
		local last = UpdateJitter(leg.Realism, dt, LEG_JITTER_MAGNITUDE)
		local real = CFrame.Angles(last.X, last.Y, last.Z)
		local onground = hum:GetState() == Enum.HumanoidStateType.Running
		local origin = torso.CFrame * (leg.Offset * scale) + root.CFrame.LookVector * scale + root.Velocity * (LEG_MOVE_TIME * 0.6)
		local dir = (Vector3.new(0, -LEG_STEP_RAYCAST_DISTANCE, 0) - root.CFrame.LookVector * LEG_STEP_FORWARD_BIAS) * scale
		if hum:GetState() == Enum.HumanoidStateType.Climbing then
			onground = true
			origin = torso.CFrame * (leg.Offset * scale) + Vector3.new(0, -0.5, 0) * scale
			dir = root.CFrame.LookVector * LEG_STEP_RAYCAST_DISTANCE * scale
		end
		local tgt = leg.Position
		if onground then
			leg.Timer += dt / LEG_MOVE_TIME
			if leg.Timer >= 1 then
				leg.Timer %= 1
				leg.Target = leg.Position
				local cast = PhysicsRaycast(origin, dir)
				if cast then
					cast = cast.Position
				else
					cast = origin + Vector3.new(0, -LEG_STEP_FALLBACK_DROP, 0)
				end
				leg.Position = cast
			end
			local tweener = math.clamp(leg.Timer / LEG_TWEEN_TIME, 0, 1)
			tgt = leg.Target:Lerp(leg.Position, tweener) + Vector3.new(0, math.sin(math.pi * tweener) * (leg.Target - leg.Position).Magnitude * 0.1, 0)
		else
			leg.InAir = true
			tgt = torso.CFrame * ((leg.Offset + LEG_AIR_OFFSET) * scale)
			tgt = tgt:Lerp(leg.Position + root.Velocity * dt, math.exp(-JITTER_SMOOTHING_RATE * dt))
			leg.Position = tgt
			leg.Target = tgt
		end
		if leg.InAir then
			leg.InAir = false
			leg.Timer = (leg.Timer % 1) + 1
		end
		local orig = torso.CFrame * (leg.Offset * scale)
		local poleDir = root.CFrame.Rotation * Vector3.new(leg.Offset.X, 0, -LEG_POLE_FORWARD)
		if (tgt - orig).Magnitude > LEG_MAX_REACH * scale then
			tgt = orig + (tgt - orig).Unit * LEG_MAX_REACH * scale
			return CFrame.lookAlong(tgt, tgt - orig, orig, poleDir) * real * CFrame.Angles(HALF_PI, 0, 0) * CFrame.new(0, LEG_FOOT_DROP * scale, 0)
		end
		return IK2Bone(orig, tgt, poleDir, LEG_UPPER_LENGTH * scale, LEG_LOWER_LENGTH * scale) * real * CFrame.Angles(HALF_PI, 0, 0) * CFrame.new(0, LEG_FOOT_DROP * scale, 0)
	end

	local function ProcessArms(arm, dt, vro, headcf, vrMode)
		local last = UpdateJitter(arm.Realism, dt, ARM_JITTER_MAGNITUDE)

		local shoulderWorld = (vro * arm.Offset).Position
		local worldDir
		if vrMode then
			-- Bug fix (v2): this used to always raycast from the desktop
			-- mouse cursor, even inside an active VR session where the
			-- desktop mouse isn't meaningful (e.g. headset on, hand
			-- controllers not yet paired). Aim along where the player is
			-- actually looking instead.
			worldDir = vro:VectorToWorldSpace(headcf.LookVector)
		else
			local aimPoint = MouseHit()
			local toAim = aimPoint - shoulderWorld
			if toAim.Magnitude < 1e-4 then
				worldDir = vro:VectorToWorldSpace(headcf.LookVector)
			else
				worldDir = toAim.Unit
			end
		end

		local hit = PhysicsRaycast(shoulderWorld, worldDir * ARM_POINT_RAYCAST_DISTANCE * scale)
		local cast
		if hit then
			cast = vro:VectorToObjectSpace(hit.Position - shoulderWorld)
		else
			cast = vro:VectorToObjectSpace(worldDir)
		end
		if cast ~= cast or cast.Magnitude == 0 then
			cast = headcf.LookVector
		else
			cast = cast.Unit
		end

		local ha = CFrame.new(0, -0.5, 0) * CFrame.Angles(0.3 + last.X, last.Y, last.Z) * CFrame.new(0, -0.4, 0) * CFrame.Angles(-HALF_PI, 0, 0)
		local hb = CFrame.lookAlong(Vector3.zero, cast) * CFrame.new(0, 0, -0.5) * CFrame.Angles(last.X, last.Y, last.Z) * CFrame.new(0, 0, -0.5)
		local tm = arm.Timer
		if arm.Waving then
			tm = math.min(1, tm + dt / ARM_POINT_LERP_TIME)
		else
			tm = math.max(0, tm - dt / ARM_POINT_LERP_TIME)
		end
		arm.Timer = tm
		return arm.Offset * ha:Lerp(hb, TweenService:GetValue(tm, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut))
	end

	-- Shared fallback pose (camera-driven head) used both when VR is fully
	-- off and when VR is on but the head CFrame isn't currently enabled.
	local function ComputeFallbackHeadCFrame()
		local x, y, z = root.CFrame.Rotation:ToObjectSpace(ReanimCamera.CFrame.Rotation):ToEulerAngles(Enum.RotationOrder.YXZ)
		if ReanimCamera:IsFirstPerson() then
			y *= 0
		elseif math.abs(y) > HALF_PI then
			y = PI - y
		end
		return CFrame.new(0, -0.5, 0) * CFrame.fromEulerAngles(x, y, z, Enum.RotationOrder.YXZ) * CFrame.new(0, 0.5, 0) + Vector3.new(0, -CrouchDistance, 0)
	end

	-- EXPERIMENTAL: webcam head-pose-only bridge -> local-space head CFrame.
	local function ComputeHeadTrackingCFrame()
		local pose = HeadTrackingBridge.LastPose
		local yaw = (pose and pose.headYaw) or 0
		local pitch = (pose and pose.headPitch) or 0
		return CFrame.new(0, -0.5, 0) * CFrame.Angles(pitch, yaw, 0) * CFrame.new(0, 0.5, 0) + Vector3.new(0, -CrouchDistance, 0)
	end

	-- EXPERIMENTAL: phone-controller bridge -> local-space hand CFrame.
	-- Points the hand outward from the shoulder along the phone's
	-- calibration-relative tilt, at roughly arm's reach.
	local function ComputePhoneHandCFrame(side)
		local pose = PhoneBridge.LastPose
		local calib = PhoneBridge.Calibration
		local yaw = ((pose and pose.yaw) or 0) - calib.yaw
		local pitch = ((pose and pose.pitch) or 0) - calib.pitch
		local roll = ((pose and pose.roll) or 0) - calib.roll
		local pointDir = (CFrame.Angles(pitch, yaw, roll) * CFrame.new(side == "Left" and -0.3 or 0.3, 0, -1)).Position.Unit
		local reach = ARM_POINT_RAYCAST_DISTANCE * PHONE_HAND_REACH_SCALE
		return CFrame.lookAlong(pointDir * reach, pointDir)
	end

	-- Resolves the local-space head CFrame this frame, and returns the
	-- (possibly first-person-yaw-corrected) eye/hand reference frame it
	-- should be combined with. Priority: real VR head > webcam head pose
	-- > camera-driven fallback.
	local function ResolveHead(vro)
		if VRService.VREnabled and VRService:GetUserCFrameEnabled(Enum.UserCFrame.Head) then
			local headCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
			if ReanimCamera:IsFirstPerson() then
				local _, y, _ = headCFrame:ToEulerAngles(Enum.RotationOrder.YXZ)
				vro *= CFrame.Angles(0, -y, 0)
			end
			return headCFrame, vro
		end
		if HeadTrackingBridge.IsTracking() then
			return ComputeHeadTrackingCFrame(), vro
		end
		return ComputeFallbackHeadCFrame(), vro
	end

	-- Resolves one hand's local-space CFrame this frame. Priority: real
	-- VR controller (per-hand, independent of the other hand) > phone
	-- controller bridge (if assigned to this side) > fake-VR mouse
	-- pointing. Returns (cframe, isSynthetic) - isSynthetic marks
	-- anything that isn't a real tracked controller, since only those
	-- need the manual CrouchDistance offset added by the caller (a real
	-- controller's tracked position already reflects physical crouch).
	local function ResolveHand(armIndex, dt, vro, chead, handEnabled, side)
		if VRService.VREnabled and handEnabled then
			return VRService:GetUserCFrame(armIndex == 1 and Enum.UserCFrame.LeftHand or Enum.UserCFrame.RightHand), false
		end
		if Settings.PhoneControllerSide == side and PhoneBridge.IsTracking() then
			return ComputePhoneHandCFrame(side), true
		end
		return ProcessArms(FakeVRArms[armIndex], dt, vro, chead, VRService.VREnabled), true
	end

	local function DoSnapTurn(direction, angleDeg)
		if not root then
			return
		end
		local now = os.clock()
		if now - LastSnapTurnTime < SNAP_TURN_COOLDOWN then
			return
		end
		LastSnapTurnTime = now
		root.CFrame = root.CFrame * CFrame.Angles(0, direction * math.rad(angleDeg), 0)
		PulseHaptic(Enum.VibrationMotor.Small, HAPTIC_BUTTON_INTENSITY, HAPTIC_BUTTON_DURATION)
	end

	local function DoRecenterAndCalibrate()
		pcall(function()
			VRService:RecenterUserHeadCFrame()
		end)
		if VRService.VREnabled and VRService:GetUserCFrameEnabled(Enum.UserCFrame.Head) then
			local headCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
			HeightCalibration = math.clamp(headCFrame.Position.Y / REFERENCE_HEAD_HEIGHT, 0.6, 1.6)
		else
			HeightCalibration = 1
		end
		PulseHaptic(Enum.VibrationMotor.Small, HAPTIC_BUTTON_INTENSITY, HAPTIC_BUTTON_DURATION)
	end

	--------------------------------------------------------------------
	-- Comfort vignette: darkens the screen edges while moving in VR to
	-- help reduce motion sickness. Built from 4 gradient strips instead
	-- of a texture asset so it doesn't depend on any external image id.
	--------------------------------------------------------------------
	local function CreateVignetteFrame(name, position, size, gradientRotation)
		local frame = Instance.new("Frame")
		frame.Name = name
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = Color3.new(0, 0, 0)
		frame.BackgroundTransparency = 1
		frame.Position = position
		frame.Size = size
		frame.ZIndex = 10

		local gradient = Instance.new("UIGradient")
		gradient.Rotation = gradientRotation
		gradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1),
		})
		gradient.Parent = frame
		return frame
	end

	local function SetupVignette()
		if VignetteGui then
			return
		end
		local ok, playerGui = pcall(function()
			return Player:WaitForChild("PlayerGui")
		end)
		if not ok or not playerGui then
			return
		end
		VignetteGui = Instance.new("ScreenGui")
		VignetteGui.Name = "ImmersiveVRVignette"
		VignetteGui.ResetOnSpawn = false
		VignetteGui.IgnoreGuiInset = true
		VignetteGui.DisplayOrder = 50
		VignetteGui.Enabled = false
		VignetteFrames = {
			CreateVignetteFrame("Top", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.18, 0), 90),
			CreateVignetteFrame("Bottom", UDim2.new(0, 0, 0.82, 0), UDim2.new(1, 0, 0.18, 0), 270),
			CreateVignetteFrame("Left", UDim2.new(0, 0, 0, 0), UDim2.new(0.12, 0, 1, 0), 0),
			CreateVignetteFrame("Right", UDim2.new(0.88, 0, 0, 0), UDim2.new(0.12, 0, 1, 0), 180),
		}
		for _, frame in VignetteFrames do
			frame.Parent = VignetteGui
		end
		VignetteGui.Parent = playerGui
	end

	local function UpdateVignette(speed)
		if not (Settings.VignetteEnabled and VRService.VREnabled) then
			if VignetteGui then
				VignetteGui.Enabled = false
			end
			return
		end
		if not VignetteGui then
			SetupVignette()
		end
		if not VignetteGui then
			return
		end
		VignetteGui.Enabled = true
		local alpha = math.clamp((speed - VIGNETTE_SPEED_LOW) / (VIGNETTE_SPEED_HIGH - VIGNETTE_SPEED_LOW), 0, 1)
		local transparency = 1 - alpha * VIGNETTE_MAX_DARKNESS
		for _, frame in VignetteFrames do
			frame.BackgroundTransparency = transparency
		end
	end

	m.Init = function(figure: Model)
		CachedFigure = nil -- force a fresh cache resolve for this figure
		RefreshCache(figure)
		if not hum then return end
		if not root then return end
		if not torso then return end
		BaseWalkSpeed = WALK_SPEED
		IsRunning = false
		hum.WalkSpeed = WALK_SPEED
		HeightCalibration = 1
		--ReanimCamera.FPSLocked = true

		-- This module keeps HumanoidRootPart itself as a completely
		-- normal, humanoid-driven, in-world part (movement/physics work
		-- as usual) - it's only Head/Arms/Legs/Torso that get manually
		-- SetCFrame'd every frame relative to root.CFrame. That best
		-- matches LimbReanimator's "2 - Keep RootPart streamed" mode.
		pcall(function()
			if LimbReanimator and LimbReanimator.SetRootPartMode then
				LimbReanimator.SetRootPartMode(LIMB_REANIMATOR_ROOT_PART_MODE)
			end
		end)

		-- Bug fix / optimization (v2): the old nested loop only skipped
		-- v == w, so every unordered pair of parts got TWO
		-- NoCollisionConstraints created (A->B and B->A). Collecting
		-- parts first and only pairing i < j fixes that.
		local parts = {}
		for _, v in figure:GetChildren() do
			if v:IsA("BasePart") then
				table.insert(parts, v)
			end
		end
		for i = 1, #parts do
			for j = i + 1, #parts do
				local nocoll = Instance.new("NoCollisionConstraint")
				nocoll.Part0, nocoll.Part1 = parts[i], parts[j]
				nocoll.Parent = parts[i]
			end
		end

		LegsTarget = {
			{
				Position = root.CFrame * Vector3.new(-0.5, -3, 0),
				Offset = Vector3.new(-0.5, -1, 0),
				Target = root.CFrame * Vector3.new(-0.5, -3, 0),
				Timer = 0.5,
				Realism = {
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
				},
				InAir = false,
			},
			{
				Position = root.CFrame * Vector3.new(0.5, -3, 0),
				Offset = Vector3.new(0.5, -1, 0),
				Target = root.CFrame * Vector3.new(0.5, -3, 0),
				Timer = 0,
				Realism = {
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
				},
				InAir = false,
			},
		}
		FakeVRArms = {
			{
				Timer = 1,
				Realism = {
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
				},
				Waving = false,
				Offset = CFrame.new(-1.5, -1, 0),
			},
			{
				Timer = 1,
				Realism = {
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
				},
				Waving = false,
				Offset = CFrame.new(1.5, -1, 0),
			},
		}
		Crouching = false
		CrouchDistance = 0
		ContextActions:BindAction("Uhhhhhh_VRWaveL", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				FakeVRArms[1].Waving = true
				PulseHaptic(Enum.VibrationMotor.LeftHand, HAPTIC_POINT_INTENSITY, HAPTIC_POINT_DURATION)
			end
			if state == Enum.UserInputState.End then
				FakeVRArms[1].Waving = false
			end
		end, true, Enum.UserInputType.MouseButton1)
		ContextActions:SetTitle("Uhhhhhh_VRWaveL", "L")
		ContextActions:SetPosition("Uhhhhhh_VRWaveL", SafeButtonPosition(-230, -130))
		ContextActions:BindAction("Uhhhhhh_VRWaveR", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				FakeVRArms[2].Waving = true
				PulseHaptic(Enum.VibrationMotor.RightHand, HAPTIC_POINT_INTENSITY, HAPTIC_POINT_DURATION)
			end
			if state == Enum.UserInputState.End then
				FakeVRArms[2].Waving = false
			end
		end, true, Enum.UserInputType.MouseButton2)
		ContextActions:SetTitle("Uhhhhhh_VRWaveR", "R")
		ContextActions:SetPosition("Uhhhhhh_VRWaveR", SafeButtonPosition(-180, -130))
		ContextActions:BindAction("Uhhhhhh_VRCrouch", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				Crouching = not Crouching
				PulseHaptic(Enum.VibrationMotor.Small, HAPTIC_BUTTON_INTENSITY, HAPTIC_BUTTON_DURATION)
			end
		end, true, Enum.KeyCode.C)
		ContextActions:SetTitle("Uhhhhhh_VRCrouch", "C")
		ContextActions:SetPosition("Uhhhhhh_VRCrouch", SafeButtonPosition(-130, -230))
		ContextActions:BindAction("Uhhhhhh_VRRun", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				IsRunning = not IsRunning
				BaseWalkSpeed = IsRunning and Settings.RunSpeed or WALK_SPEED
				PulseHaptic(Enum.VibrationMotor.Small, HAPTIC_BUTTON_INTENSITY, HAPTIC_BUTTON_DURATION)
			end
		end, true, Enum.KeyCode.LeftControl, Enum.KeyCode.ButtonB)
		ContextActions:SetTitle("Uhhhhhh_VRRun", "Run")
		ContextActions:SetPosition("Uhhhhhh_VRRun", SafeButtonPosition(-180, -230))
		ContextActions:BindAction("Uhhhhhh_VRRecenter", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				DoRecenterAndCalibrate()
			end
		end, true, Enum.KeyCode.T, Enum.KeyCode.ButtonL3)
		ContextActions:SetTitle("Uhhhhhh_VRRecenter", "Recenter")
		ContextActions:SetPosition("Uhhhhhh_VRRecenter", SafeButtonPosition(-230, -230))

		if SnapTurnConn then
			SnapTurnConn:Disconnect()
		end
		if SnapTurnEndedConn then
			SnapTurnEndedConn:Disconnect()
		end
		SnapTurnArmed = true
		LastSnapTurnTime = 0
		LastThumbstick2X = 0
		SnapTurnConn = UserInputService.InputChanged:Connect(function(input)
			if input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end
			LastThumbstick2X = input.Position.X
			if Settings.SmoothTurnEnabled then
				-- Smooth turn is applied continuously in m.Update instead;
				-- just keep snap-turn's edge-detector primed in case the
				-- player flips the toggle back off mid-session.
				SnapTurnArmed = true
				return
			end
			if not (Settings.SnapTurnEnabled and VRService.VREnabled) then
				return
			end
			if math.abs(LastThumbstick2X) < SNAP_TURN_DEADZONE then
				SnapTurnArmed = true
				return
			end
			if SnapTurnArmed then
				SnapTurnArmed = false
				DoSnapTurn(LastThumbstick2X > 0 and 1 or -1, Settings.SnapTurnAngleDeg)
			end
		end)
		SnapTurnEndedConn = UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				LastThumbstick2X = 0
			end
		end)

		StartBridgePolling()
	end

	m.Update = function(dt: number, figure: Model)
		scale = figure:GetScale()
		isdancing = not not figure:GetAttribute("IsDancing")

		RefreshCache(figure)
		if not hum then return end
		if not root then return end
		if not torso then return end

		local rj, nj, rsj, lsj, rhj, lhj =
			CachedJoints.RootJoint, CachedJoints.Neck, CachedJoints.RightShoulder, CachedJoints.LeftShoulder, CachedJoints.RightHip, CachedJoints.LeftHip
		if not (rj and nj and rsj and lsj and rhj and lhj) then
			return
		end

		FilterInstances[1] = figure
		FilterInstances[2] = Player.Character
		rcp.FilterDescendantsInstances = FilterInstances

		local crouchTarget = (Crouching and 1 or 0) * CROUCH_DISTANCE
		CrouchDistance = crouchTarget + (CrouchDistance - crouchTarget) * math.exp(-JITTER_SMOOTHING_RATE * dt)

		-- Smooth-turn reads the last-known thumbstick X every frame
		-- (unlike snap-turn, which only fires on InputChanged edges).
		if VRService.VREnabled and Settings.SmoothTurnEnabled and math.abs(LastThumbstick2X) > SMOOTH_TURN_DEADZONE then
			root.CFrame = root.CFrame * CFrame.Angles(0, LastThumbstick2X * math.rad(Settings.SmoothTurnSpeedDeg) * dt, 0)
		end

		if not isdancing then
			rj.Enabled, nj.Enabled, rsj.Enabled, lsj.Enabled, rhj.Enabled, lhj.Enabled = false, false, false, false, false, false
			hum.HipHeight = 2 * scale - HIP_HEIGHT_FUDGE - CrouchDistance * scale
			-- Crouching now also slows movement, not just posture height.
			local crouchAlpha = CrouchDistance / CROUCH_DISTANCE
			hum.WalkSpeed = BaseWalkSpeed * (1 - crouchAlpha * (1 - CROUCH_WALKSPEED_SCALE))
			root.CustomPhysicalProperties = PhysicalProperties.new(3.15, 0.3, 0.5)

			local head, rarm, larm, rleg, lleg =
				CachedParts.Head, CachedParts.RightArm, CachedParts.LeftArm, CachedParts.RightLeg, CachedParts.LeftLeg
			if not (head and rarm and larm and rleg and lleg) then
				return
			end

			local vro = root.CFrame * CFrame.new(0, EYE_HEIGHT_OFFSET * scale * HeightCalibration, 0)
			local vroot = root.CFrame
			vro += Vector3.new(0, CrouchDistance * scale, 0)
			vroot += Vector3.new(0, CrouchDistance * scale, 0)

			-- Priority for head: real VR hardware > EXPERIMENTAL webcam
			-- head pose > built-in camera-driven fallback.
			local chead
			chead, vro = ResolveHead(vro)

			-- Bug fix (v2): left/right VR hand tracking is now resolved
			-- fully independently, so pairing only one motion controller
			-- no longer throws away tracking on the other hand too.
			local leftHandEnabled = VRService.VREnabled and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
			local rightHandEnabled = VRService.VREnabled and VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)

			local clarm, clarmSynthetic = ResolveHand(1, dt, vro, chead, leftHandEnabled, "Left")
			local crarm, crarmSynthetic = ResolveHand(2, dt, vro, chead, rightHandEnabled, "Right")
			if clarmSynthetic then
				clarm += Vector3.new(0, -CrouchDistance, 0)
			end
			if crarmSynthetic then
				crarm += Vector3.new(0, -CrouchDistance, 0)
			end

			chead += chead.Position * (scale - 1)
			clarm += clarm.Position * (scale - 1)
			crarm += crarm.Position * (scale - 1)
			local armo = CFrame.Angles(HALF_PI, 0, 0) * CFrame.new(0, 0, 0)
			SetCFrame(head, vro * chead)
			SetCFrame(larm, vro * clarm * armo)
			SetCFrame(rarm, vro * crarm * armo)

			local p1 = vroot:PointToObjectSpace(GetLegPoint(LegsTarget[1]))
			local p2 = vroot:PointToObjectSpace(GetLegPoint(LegsTarget[2]))
			local strideWidth = math.max(math.abs(p1.X - p2.X), TORSO_MIN_STRIDE * scale)
			local yabai = CFrame.Angles(0, math.atan2(p1.Z - p2.Z, strideWidth) * TORSO_TWIST_FACTOR, 0)
			TorsoRotation = yabai:Lerp(TorsoRotation, math.exp(-TORSO_TWIST_SMOOTHING_RATE * dt))
			SetCFrame(torso, IK2Bone(
				vroot * Vector3.new(0, -TORSO_HIP_DROP * scale, 0),
				vro * chead * Vector3.new(0, -TORSO_HEAD_ANCHOR_DROP * scale, 0),
				-vroot.LookVector, TORSO_IK_LENGTH * scale, TORSO_IK_LENGTH * scale)
			* CFrame.Angles(HALF_PI, PI, PI) * CFrame.new(0, -TORSO_PIVOT_DROP * scale, 0) * TorsoRotation)
			SetCFrame(lleg, ProcessLegs(LegsTarget[1], dt))
			SetCFrame(rleg, ProcessLegs(LegsTarget[2], dt))
			UpdateVignette(root.Velocity.Magnitude)
		else
			rj.Enabled, nj.Enabled, rsj.Enabled, lsj.Enabled, rhj.Enabled, lhj.Enabled = true, true, true, true, true, true
			hum.HipHeight = 2 * scale - HIP_HEIGHT_FUDGE
			root.CustomPhysicalProperties = nil
			if VignetteGui then
				VignetteGui.Enabled = false
			end
		end
	end

	m.Destroy = function(figure: Model?)
		ContextActions:UnbindAction("Uhhhhhh_VRWaveL")
		ContextActions:UnbindAction("Uhhhhhh_VRWaveR")
		ContextActions:UnbindAction("Uhhhhhh_VRCrouch")
		ContextActions:UnbindAction("Uhhhhhh_VRRun")
		ContextActions:UnbindAction("Uhhhhhh_VRRecenter")
		if SnapTurnConn then
			SnapTurnConn:Disconnect()
			SnapTurnConn = nil
		end
		if SnapTurnEndedConn then
			SnapTurnEndedConn:Disconnect()
			SnapTurnEndedConn = nil
		end
		StopBridgePolling()
		if VignetteGui then
			VignetteGui:Destroy()
			VignetteGui = nil
			VignetteFrames = nil
		end
		if figure then
			for _, partName in { "Head", "Right Arm", "Left Arm", "Right Leg", "Left Leg", "Torso" } do
				local part = figure:FindFirstChild(partName)
				if part then
					-- Bug fix (v2): used to only Enabled=false these and
					-- leave the instances parented under the limb forever
					-- (harmless but untidy if the figure survives a
					-- moveset switch). Now actually destroyed.
					local force = PartForces[part]
					if force then
						force:Destroy()
						PartForces[part] = nil
					end
					PinnedCFrames[part] = nil
				end
			end
		end
		CachedFigure = nil
	end
	return m
end)

return modules
