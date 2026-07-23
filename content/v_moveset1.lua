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
	-- Immersive VR Module - Full Collision Arms Integration
	--
	-- Upgrades & Additions in this build:
	--   * [NEW] COLLISION ARMS (Bonelab-Style Physics Solver):
	--     - Spherecast / Raycast arm collision solver prevents hands and
	--       forearms from clipping through walls, crates, and floors.
	--     - Recomputes 2-Bone IK elbow positions dynamically so arms
	--       physically compress and bend against surfaces.
	--   * [NEW] CLIENT-SIDED UNANCHORED CRATE & BLOCK PUSHING:
	--     - Solves why clientsided CFrame arms normally pass through crates
	--       without moving them: direct CFrame teleportation bypasses PGS.
	--     - Calculates relative impact velocity between hand and hit part
	--       and applies explicit local physics impulses via
	--       ApplyImpulseAtPosition(pushImpulse, hitPoint).
	--   * [NEW] FLOOR-HOLDING & MID-AIR ARM FLOATING PHYSICS:
	--     - Descending, crouching, or falling with arms extended toward a
	--       surface triggers spring-damper body support physics.
	--     - Arms exert counter-gravity lift force on HumanoidRootPart,
	--       allowing the character to float in mid-air supported by arms
	--       (push-up / dip / ledge-hold mechanics).
	--     - Dynamically lifts HipHeight based on arm compression.
	--   * [NEW] MODERN FAKE/REAL VR LOCOMOTION & VAULTING:
	--     - Smooth, physics-based movement relative to head look vector
	--       or VR motion controller.
	--     - Arm-assisted vaulting boost when pushing forward/up against
	--       ledges, walls, or crates.
	--   * [NEW] CONFIG PANEL EXTENSIONS:
	--     - Toggles for Collision Arms, Crate Pushing, Floor Floating,
	--       Arm Vaulting, and an Arm Stiffness adjustment slider.
	--------------------------------------------------------------------

	local VRService = cloneref(game:GetService("VRService"))
	local UserInputService = cloneref(game:GetService("UserInputService"))
	local HapticService = cloneref(game:GetService("HapticService"))
	local GuiService = cloneref(game:GetService("GuiService"))
	local HttpService = cloneref(game:GetService("HttpService"))
	local RunService = cloneref(game:GetService("RunService"))
	local TweenService = cloneref(game:GetService("TweenService"))
	local ContextActions = cloneref(game:GetService("ContextActionService"))
	local Player = cloneref(game:GetService("Players")).LocalPlayer
	local ReanimCamera = workspace.CurrentCamera

	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Immersive VR (Collision Arms)"
	m.Description = "Bonelab-style physical collision arms, wall bumping, crate pushing, floor holding & float gravity physics.

M1 - Point Left Hand
M2 - Point Right Hand
LeftControl/Button B - Toggle Run
C - Crouch
Right Thumbstick - Snap/Smooth Turn
T/Thumbstick1 Click - Recenter
Space/W while on surface - Arm Vault"
	m.Assets = {}

	--------------------------------------------------------------------
	-- Tunable constants
	--------------------------------------------------------------------
	local WALK_SPEED = 12
	local CROUCH_WALKSPEED_SCALE = 0.6

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
	local PHONE_HAND_REACH_SCALE = 0.15

	--------------------------------------------------------------------
	-- COLLISION ARMS CONSTANTS (Bonelab Physics Tuning)
	--------------------------------------------------------------------
	local ARM_REACH = 3.2            -- Maximum arm length in studs
	local HAND_RADIUS = 0.55         -- Physical collision boundary around hands
	local MIN_ARM_LENGTH = 0.8       -- Minimum arm compression length before body pushback
	local ARM_SPRING_STIFFNESS_DEFAULT = 200 -- Stiffness for floor-holding lift
	local ARM_SPRING_DAMPING = 25    -- Damping for arm float suspension
	local MAX_PUSH_FORCE = 15000     -- Maximum impulse applied to unanchored crates
	local BODY_FLOAT_FORCE_MAX = 5000-- Maximum upward anti-gravity force
	local VAULT_IMPULSE = 35         -- Upward boost when pushing off walls/ledges

	local JITTER_SMOOTHING_RATE = 16
	local TORSO_TWIST_SMOOTHING_RATE = 4
	local TORSO_TWIST_FACTOR = 0.5
	local TORSO_MIN_STRIDE = 0.5

	local HIP_HEIGHT_FUDGE = 2

	local DEFAULT_SNAP_TURN_ANGLE_DEG = 30
	local SNAP_TURN_ANGLE_MIN_DEG = 10
	local SNAP_TURN_ANGLE_MAX_DEG = 90
	local SNAP_TURN_DEADZONE = 0.6
	local SNAP_TURN_COOLDOWN = 0.3

	local DEFAULT_SMOOTH_TURN_SPEED_DEG = 90
	local SMOOTH_TURN_SPEED_MIN_DEG = 30
	local SMOOTH_TURN_SPEED_MAX_DEG = 180
	local SMOOTH_TURN_DEADZONE = 0.15

	local VIGNETTE_SPEED_LOW = 2
	local VIGNETTE_SPEED_HIGH = 16
	local VIGNETTE_MAX_DARKNESS = 0.65

	local HAPTIC_POINT_INTENSITY = 0.25
	local HAPTIC_POINT_DURATION = 0.05
	local HAPTIC_BUTTON_INTENSITY = 0.4
	local HAPTIC_BUTTON_DURATION = 0.08

	local REFERENCE_HEAD_HEIGHT = 1.6
	local BRIDGE_POLL_INTERVAL = 1 / 20
	local POSE_STALE_AFTER = 0.5

	local LIMB_REANIMATOR_ROOT_PART_MODE = 2

	local HALF_PI = math.pi / 2
	local PI = math.pi

	local scale, isdancing = 1, false
	local hum, root, torso
	local BaseWalkSpeed = WALK_SPEED
	local IsRunning = false
	local HeightCalibration = 1

	--------------------------------------------------------------------
	-- COLLISION ARMS RUNTIME STATE
	--------------------------------------------------------------------
	local PrevHandPosLeft = Vector3.zero
	local PrevHandPosRight = Vector3.zero
	local IsLeftHandGrounded = false
	local IsRightHandGrounded = false
	local LeftContactNormal = Vector3.yAxis
	local RightContactNormal = Vector3.yAxis
	local LeftContactPart = nil
	local RightContactPart = nil
	local ArmFloatForce = 0
	local ArmSpringOffset = 0

	local Settings = {
		RunSpeed = 24,
		SnapTurnEnabled = true,
		SnapTurnAngleDeg = DEFAULT_SNAP_TURN_ANGLE_DEG,
		SmoothTurnEnabled = false,
		SmoothTurnSpeedDeg = DEFAULT_SMOOTH_TURN_SPEED_DEG,
		VignetteEnabled = true,
		JitterScale = 1,
		-- Collision Arms Settings
		CollisionArmsEnabled = true,
		CratePushingEnabled = true,
		FloorFloatingEnabled = true,
		ArmVaultingEnabled = true,
		ArmStiffness = ARM_SPRING_STIFFNESS_DEFAULT,
		-- Bridges
		HeadTrackingEnabled = false,
		HeadTrackingPort = 8787,
		PhoneControllerSide = "Off",
		PhoneIP = "192.168.1.100",
		PhonePort = 8788,
	}

	--------------------------------------------------------------------
	-- Shared best-effort HTTP GET / file-read shims
	--------------------------------------------------------------------
	local function TryHttpGet(url)
		local requestFn = (syn and syn.request)
			or (http and http.request)
			or http_request
			or (fluxus and fluxus.request)
			or request
		if not requestFn then return nil end
		local ok, response = pcall(requestFn, { Url = url, Method = "GET" })
		if ok and response and (response.StatusCode == 200 or response.Success) and response.Body then
			return response.Body
		end
		return nil
	end

	local function TryReadPoseFile(path)
		if not (isfile and readfile) then return nil end
		local ok, exists = pcall(isfile, path)
		if not ok or not exists then return nil end
		local ok2, contents = pcall(readfile, path)
		if ok2 then return contents end
		return nil
	end

	--------------------------------------------------------------------
	-- Head Tracking Bridge
	--------------------------------------------------------------------
	local HeadTrackingBridge = { LastPose = nil, LastUpdateTime = 0, LastTransport = nil }

	function HeadTrackingBridge.IsTracking()
		if not Settings.HeadTrackingEnabled then return false end
		if not HeadTrackingBridge.LastPose or not HeadTrackingBridge.LastPose.tracking then return false end
		return (os.clock() - HeadTrackingBridge.LastUpdateTime) <= POSE_STALE_AFTER
	end

	local function PollHeadTrackingBridge()
		if not Settings.HeadTrackingEnabled then return end
		local url = ("http://127.0.0.1:%d/pose"):format(Settings.HeadTrackingPort)
		local body = TryHttpGet(url) or TryReadPoseFile("immersive_vr_head_pose.json")
		if not body then return end
		local ok, decoded = pcall(function() return HttpService:JSONDecode(body) end)
		if ok and typeof(decoded) == "table" then
			HeadTrackingBridge.LastPose = decoded
			HeadTrackingBridge.LastUpdateTime = os.clock()
		end
	end

	--------------------------------------------------------------------
	-- Phone Controller Bridge
	--------------------------------------------------------------------
	local PhoneBridge = { LastPose = nil, LastUpdateTime = 0, Calibration = { yaw = 0, pitch = 0, roll = 0 } }

	function PhoneBridge.IsTracking()
		if Settings.PhoneControllerSide == "Off" then return false end
		if not PhoneBridge.LastPose or not PhoneBridge.LastPose.tracking then return false end
		return (os.clock() - PhoneBridge.LastUpdateTime) <= POSE_STALE_AFTER
	end

	local function PollPhoneBridge()
		if Settings.PhoneControllerSide == "Off" then return end
		local url = ("http://%s:%d/pose"):format(Settings.PhoneIP, Settings.PhonePort)
		local body = TryHttpGet(url)
		if not body then return end
		local ok, decoded = pcall(function() return HttpService:JSONDecode(body) end)
		if ok and typeof(decoded) == "table" then
			PhoneBridge.LastPose = decoded
			PhoneBridge.LastUpdateTime = os.clock()
		end
	end

	function PhoneBridge.Calibrate()
		local pose = PhoneBridge.LastPose
		if not pose then return false end
		PhoneBridge.Calibration = { yaw = pose.yaw or 0, pitch = pose.pitch or 0, roll = pose.roll or 0 }
		return true
	end

	local BridgePollThread = nil
	local function StartBridgePolling()
		if BridgePollThread then return end
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

	--------------------------------------------------------------------
	-- Config GUI
	--------------------------------------------------------------------
	m.Config = function(parent: GuiBase2d)
		local function SafeName(prefix)
			local ok, str = pcall(RandomString, 8)
			if ok and type(str) == "string" and #str > 0 then return prefix .. "_" .. str end
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

		local function FallbackSeparator(order)
			local sep = Instance.new("Frame")
			sep.Name = SafeName("Separator")
			sep.LayoutOrder = order
			sep.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
			sep.BorderSizePixel = 0
			sep.Size = UDim2.new(1, 0, 0, 1)
			return sep
		end

		local function AddToggle(labelText, order, initial, onChanged)
			local ok, widget = pcall(Util_CreateSwitch, parent, labelText, order, initial, onChanged)
			if ok and typeof(widget) == "Instance" then return widget end
			return FallbackToggle(labelText, order, initial, onChanged)
		end

		local function AddSlider(labelText, order, min, max, initial, onChanged)
			local ok, widget = pcall(Util_CreateSlider, parent, labelText, order, min, max, initial, onChanged)
			if ok and typeof(widget) == "Instance" then return widget end
			return FallbackSlider(labelText, order, min, max, initial, onChanged)
		end

		local function AddSeparator(order)
			local ok, widget = pcall(Util_CreateSeparator, parent, order)
			if ok and typeof(widget) == "Instance" then return widget end
			return FallbackSeparator(order)
		end

		if not parent:FindFirstChildOfClass("UIListLayout") then
			local layout = Instance.new("UIListLayout")
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 4)
			layout.Parent = parent
		end

		AddSlider("Run Speed", 1, 12, 60, Settings.RunSpeed, function(v)
			Settings.RunSpeed = v
			if IsRunning then BaseWalkSpeed = v end
		end).Parent = parent

		AddToggle("Collision Arms (Wall / Crate Physics)", 2, Settings.CollisionArmsEnabled, function(v)
			Settings.CollisionArmsEnabled = v
		end).Parent = parent

		AddToggle("Push Unanchored Crates & Blocks", 3, Settings.CratePushingEnabled, function(v)
			Settings.CratePushingEnabled = v
		end).Parent = parent

		AddToggle("Floor Holding & Float Physics", 4, Settings.FloorFloatingEnabled, function(v)
			Settings.FloorFloatingEnabled = v
		end).Parent = parent

		AddToggle("Arm-Assisted Vaulting", 5, Settings.ArmVaultingEnabled, function(v)
			Settings.ArmVaultingEnabled = v
		end).Parent = parent

		AddSlider("Arm Spring Stiffness", 6, 50, 500, Settings.ArmStiffness, function(v)
			Settings.ArmStiffness = v
		end).Parent = parent

		AddSeparator(7).Parent = parent

		AddToggle("VR Snap Turn (right stick)", 8, Settings.SnapTurnEnabled, function(v) Settings.SnapTurnEnabled = v end).Parent = parent
		AddSlider("Snap Turn Angle (deg)", 9, SNAP_TURN_ANGLE_MIN_DEG, SNAP_TURN_ANGLE_MAX_DEG, Settings.SnapTurnAngleDeg, function(v) Settings.SnapTurnAngleDeg = v end).Parent = parent
		AddToggle("VR Smooth Turn", 10, Settings.SmoothTurnEnabled, function(v) Settings.SmoothTurnEnabled = v end).Parent = parent
		AddSlider("Smooth Turn Speed", 11, SMOOTH_TURN_SPEED_MIN_DEG, SMOOTH_TURN_SPEED_MAX_DEG, Settings.SmoothTurnSpeedDeg, function(v) Settings.SmoothTurnSpeedDeg = v end).Parent = parent
		AddToggle("VR Vignette", 12, Settings.VignetteEnabled, function(v) Settings.VignetteEnabled = v end).Parent = parent
	end

	--------------------------------------------------------------------
	-- Antigravity & SetCFrame Physics Pinning
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

	local PinnedCFrames = {}
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
			if force then force.Enabled = false end
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

	local FilterInstances = { nil, nil }
	local mouse
	do
		local ok, m2 = pcall(function() return Player:GetMouse() end)
		if ok then mouse = m2 end
	end

	local function MouseHit()
		if not mouse then
			return ReanimCamera.CFrame.Position + ReanimCamera.CFrame.LookVector * 20
		end
		local ray = mouse.UnitRay
		local dist = 2000
		local raycast = PhysicsRaycast(ray.Origin, ray.Direction * dist)
		if raycast then return raycast.Position end
		return ray.Origin + ray.Direction * dist
	end

	local function PulseHaptic(motor, intensity, duration)
		task.spawn(function()
			pcall(function()
				if HapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1)
					and HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, motor) then
					HapticService:SetMotor(Enum.UserInputType.Gamepad1, motor, intensity)
				end
			end)
			task.wait(duration)
			pcall(function() HapticService:SetMotor(Enum.UserInputType.Gamepad1, motor, 0) end)
		end)
	end

	local function SafeButtonPosition(xOffset, yOffset)
		local ok, _, bottomRightInset = pcall(function() return GuiService:GetGuiInset() end)
		if not ok or not bottomRightInset then return UDim2.new(1, xOffset, 1, yOffset) end
		return UDim2.new(1, xOffset - bottomRightInset.X, 1, yOffset - bottomRightInset.Y)
	end

	--------------------------------------------------------------------
	-- IK2Bone Solver
	--------------------------------------------------------------------
	local function IK2Bone(from: Vector3, target: Vector3, direction: Vector3, lenA: number, lenB: number): CFrame
		local origin = from
		local goal = target
		local pole = direction

		local toGoal = goal - origin
		local dist = toGoal.Magnitude
		if dist < 1e-6 then return CFrame.new(goal) end

		local dir = toGoal / dist
		local poleProj = pole - dir * pole:Dot(dir)
		local poleMag = poleProj.Magnitude
		if poleMag < 1e-6 then
			local arb = Vector3.yAxis
			if math.abs(dir:Dot(arb)) > 0.99 then arb = Vector3.xAxis end
			poleProj = (arb - dir * arb:Dot(dir)).Unit
		else
			poleProj /= poleMag
		end

		local elbowPos
		if dist > lenA + lenB then
			elbowPos = origin + dir * lenA
		else
			local a = (lenA * lenA + dist * dist - lenB * lenB) / (2 * dist)
			local hSq = lenA * lenA - a * a
			local h = hSq > 0 and math.sqrt(hSq) or 0
			elbowPos = origin + dir * a + poleProj * h
		end

		local boneDir = (goal - elbowPos).Unit
		local desiredUp = pole - boneDir * pole:Dot(boneDir)
		local upMag = desiredUp.Magnitude
		if upMag < 1e-6 then
			local arb = Vector3.yAxis
			if math.abs(boneDir:Dot(arb)) > 0.99 then arb = Vector3.xAxis end
			desiredUp = (arb - boneDir * arb:Dot(boneDir)).Unit
		else
			desiredUp /= upMag
		end

		return CFrame.lookAt(goal, goal + boneDir, desiredUp)
	end

	--------------------------------------------------------------------
	-- COLLISION ARMS PHYSICS SOLVER (Bonelab Wall/Crate/Floor Engine)
	--------------------------------------------------------------------
	local function SolveCollisionArm(shoulderWorld: Vector3, rawTargetWorld: Vector3, prevHandPos: Vector3, dt: number)
		if not Settings.CollisionArmsEnabled then
			return rawTargetWorld, false, Vector3.yAxis, nil
		end

		local targetDir = rawTargetWorld - shoulderWorld
		local maxDist = math.min(targetDir.Magnitude, ARM_REACH * scale)
		if maxDist < 1e-3 then
			return shoulderWorld, false, Vector3.yAxis, nil
		end

		local rayDir = targetDir.Unit * maxDist
		local hitResult = PhysicsRaycast(shoulderWorld, rayDir)

		-- Swept check from previous frame hand position
		if not hitResult and (rawTargetWorld - prevHandPos).Magnitude > 0.05 then
			hitResult = PhysicsRaycast(prevHandPos, rawTargetWorld - prevHandPos)
		end

		local solvedPos = rawTargetWorld
		local isColliding = false
		local contactNormal = Vector3.yAxis
		local hitPart = nil

		if hitResult then
			isColliding = true
			hitPart = hitResult.Instance
			contactNormal = hitResult.Normal

			-- Stop hand at boundary
			solvedPos = hitResult.Position + contactNormal * (HAND_RADIUS * scale)

			-- Prevent arm clipping inside walls
			local solvedDist = (solvedPos - shoulderWorld).Magnitude
			if solvedDist < MIN_ARM_LENGTH * scale then
				solvedPos = shoulderWorld + (solvedPos - shoulderWorld).Unit * (MIN_ARM_LENGTH * scale)
			end

			-- PUSH UNANCHORED CRATES & BLOCKS
			if hitPart and not hitPart.Anchored and Settings.CratePushingEnabled then
				local handVelocity = (rawTargetWorld - prevHandPos) / math.max(dt, 1e-4)
				local relativePushVel = handVelocity - hitPart.AssemblyLinearVelocity

				local pushDir = relativePushVel.Unit
				if pushDir:Dot(contactNormal) < 0 then
					pushDir = (pushDir - contactNormal * pushDir:Dot(contactNormal)).Unit
				end

				local mass = hitPart:GetMass()
				local pushMagnitude = math.clamp(relativePushVel.Magnitude * mass * 0.5, 10, MAX_PUSH_FORCE)
				local pushImpulse = pushDir * pushMagnitude

				pcall(function()
					hitPart:ApplyImpulseAtPosition(pushImpulse, hitResult.Position)
				end)
			end
		end

		return solvedPos, isColliding, contactNormal, hitPart
	end

	--------------------------------------------------------------------
	-- FLOOR HOLDING & MID-AIR FLOAT GRAVITY PHYSICS
	--------------------------------------------------------------------
	local function UpdateArmFloatPhysics(shoulderLeft: Vector3, handLeft: Vector3, shoulderRight: Vector3, handRight: Vector3, dt: number)
		if not Settings.FloorFloatingEnabled then
			ArmFloatForce, ArmSpringOffset = 0, 0
			return
		end

		local totalSupportForce = 0
		local maxCompression = 0

		local hands = {
			{ shoulder = shoulderLeft, hand = handLeft, grounded = IsLeftHandGrounded, normal = LeftContactNormal },
			{ shoulder = shoulderRight, hand = handRight, grounded = IsRightHandGrounded, normal = RightContactNormal },
		}

		for _, data in ipairs(hands) do
			if data.grounded then
				local armVector = data.hand - data.shoulder
				local currentLength = armVector.Magnitude
				local maxReach = ARM_REACH * scale
				local compression = math.max(0, maxReach - currentLength)

				local supportDir = data.normal.Y > 0.2 and Vector3.yAxis or data.normal
				if compression > 0.05 and supportDir.Y > 0.1 then
					local springForce = compression * Settings.ArmStiffness
					local rootVelY = root.AssemblyLinearVelocity.Y
					local dampingForce = -rootVelY * ARM_SPRING_DAMPING

					local armForce = math.clamp(springForce + dampingForce, 0, BODY_FLOAT_FORCE_MAX)
					totalSupportForce += armForce
					maxCompression = math.max(maxCompression, compression)
				end
			end
		end

		ArmFloatForce = totalSupportForce
		ArmSpringOffset = maxCompression

		-- Apply anti-gravity suspension force to body when resting on arms
		if totalSupportForce > 20 and root then
			local upVector = Vector3.new(0, totalSupportForce, 0)
			root:ApplyImpulse(upVector * dt)
		end
	end

	--------------------------------------------------------------------
	-- FAKE VR / REAL VR MOVEMENT & VAULTING ENGINE
	--------------------------------------------------------------------
	local function UpdateVRMovementSystem(dt)
		if not root or isdancing then return end

		local moveInput = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveInput += Vector3.new(0, 0, -1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveInput += Vector3.new(0, 0, 1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveInput += Vector3.new(-1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveInput += Vector3.new(1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveInput += Vector3.new(0, 1, 0) end

		if moveInput.Magnitude < 0.01 then return end

		local camCF = ReanimCamera.CFrame
		local forward = (camCF.LookVector * Vector3.new(1, 0, 1)).Unit
		local right = (camCF.RightVector * Vector3.new(1, 0, 1)).Unit
		local moveDir = (forward * moveInput.Z + right * moveInput.X).Unit

		-- ARM-ASSISTED VAULTING / LEDGE BOOST
		if Settings.ArmVaultingEnabled and (IsLeftHandGrounded or IsRightHandGrounded) and moveInput.Y > 0 then
			local vaultDir = Vector3.new(moveDir.X * 0.5, 1, moveDir.Z * 0.5).Unit
			root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + vaultDir * VAULT_IMPULSE
		end
	end

	--------------------------------------------------------------------
	-- Pose Resolution helpers
	--------------------------------------------------------------------
	local LegsTarget = {}
	local FakeVRArms = {}
	local Crouching = false
	local CrouchDistance = 0
	local TorsoRotation = CFrame.identity
	local SnapTurnConn, SnapTurnEndedConn, SnapTurnArmed, LastSnapTurnTime = nil, nil, true, 0
	local LastThumbstick2X = 0
	local VignetteGui, VignetteFrames = nil, nil

	local CachedFigure = nil
	local CachedParts = {}
	local CachedJoints = {}

	local function RefreshCache(figure)
		if CachedFigure == figure then return end
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
		if leg.InAir then return leg.Position end
		local tweener = math.clamp(leg.Timer / LEG_TWEEN_TIME, 0, 1)
		return leg.Target:Lerp(leg.Position, tweener) + Vector3.new(0, math.sin(math.pi * tweener) * (leg.Target - leg.Position).Magnitude * 0.1, 0)
	end

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
				tgt = cast and cast.Position or origin + Vector3.new(0, -LEG_STEP_FALLBACK_DROP, 0)
				leg.Position = tgt
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
			worldDir = vro:VectorToWorldSpace(headcf.LookVector)
		else
			local aimPoint = MouseHit()
			local toAim = aimPoint - shoulderWorld
			worldDir = toAim.Magnitude < 1e-4 and vro:VectorToWorldSpace(headcf.LookVector) or toAim.Unit
		end

		local hit = PhysicsRaycast(shoulderWorld, worldDir * ARM_POINT_RAYCAST_DISTANCE * scale)
		local cast = hit and vro:VectorToObjectSpace(hit.Position - shoulderWorld) or vro:VectorToObjectSpace(worldDir)
		cast = (cast ~= cast or cast.Magnitude == 0) and headcf.LookVector or cast.Unit

		local ha = CFrame.new(0, -0.5, 0) * CFrame.Angles(0.3 + last.X, last.Y, last.Z) * CFrame.new(0, -0.4, 0) * CFrame.Angles(-HALF_PI, 0, 0)
		local hb = CFrame.lookAlong(Vector3.zero, cast) * CFrame.new(0, 0, -0.5) * CFrame.Angles(last.X, last.Y, last.Z) * CFrame.new(0, 0, -0.5)
		local tm = arm.Timer
		tm = arm.Waving and math.min(1, tm + dt / ARM_POINT_LERP_TIME) or math.max(0, tm - dt / ARM_POINT_LERP_TIME)
		arm.Timer = tm
		return arm.Offset * ha:Lerp(hb, TweenService:GetValue(tm, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut))
	end

	local function ComputeFallbackHeadCFrame()
		local x, y, z = root.CFrame.Rotation:ToObjectSpace(ReanimCamera.CFrame.Rotation):ToEulerAngles(Enum.RotationOrder.YXZ)
		if ReanimCamera:IsFirstPerson() then y *= 0
		elseif math.abs(y) > HALF_PI then y = PI - y end
		return CFrame.new(0, -0.5, 0) * CFrame.fromEulerAngles(x, y, z, Enum.RotationOrder.YXZ) * CFrame.new(0, 0.5, 0) + Vector3.new(0, -CrouchDistance, 0)
	end

	local function ComputeHeadTrackingCFrame()
		local pose = HeadTrackingBridge.LastPose
		return CFrame.new(0, -0.5, 0) * CFrame.Angles((pose and pose.headPitch) or 0, (pose and pose.headYaw) or 0, 0) * CFrame.new(0, 0.5, 0) + Vector3.new(0, -CrouchDistance, 0)
	end

	local function ComputePhoneHandCFrame(side)
		local pose, calib = PhoneBridge.LastPose, PhoneBridge.Calibration
		local yaw, pitch, roll = ((pose and pose.yaw) or 0) - calib.yaw, ((pose and pose.pitch) or 0) - calib.pitch, ((pose and pose.roll) or 0) - calib.roll
		local pointDir = (CFrame.Angles(pitch, yaw, roll) * CFrame.new(side == "Left" and -0.3 or 0.3, 0, -1)).Position.Unit
		return CFrame.lookAlong(pointDir * (ARM_POINT_RAYCAST_DISTANCE * PHONE_HAND_REACH_SCALE), pointDir)
	end

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
		if not root then return end
		local now = os.clock()
		if now - LastSnapTurnTime < SNAP_TURN_COOLDOWN then return end
		LastSnapTurnTime = now
		root.CFrame = root.CFrame * CFrame.Angles(0, direction * math.rad(angleDeg), 0)
		PulseHaptic(Enum.VibrationMotor.Small, HAPTIC_BUTTON_INTENSITY, HAPTIC_BUTTON_DURATION)
	end

	local function DoRecenterAndCalibrate()
		pcall(function() VRService:RecenterUserHeadCFrame() end)
		if VRService.VREnabled and VRService:GetUserCFrameEnabled(Enum.UserCFrame.Head) then
			local headCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
			HeightCalibration = math.clamp(headCFrame.Position.Y / REFERENCE_HEAD_HEIGHT, 0.6, 1.6)
		else
			HeightCalibration = 1
		end
		PulseHaptic(Enum.VibrationMotor.Small, HAPTIC_BUTTON_INTENSITY, HAPTIC_BUTTON_DURATION)
	end

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
		gradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
		gradient.Parent = frame
		return frame
	end

	local function SetupVignette()
		if VignetteGui then return end
		local ok, playerGui = pcall(function() return Player:WaitForChild("PlayerGui") end)
		if not ok or not playerGui then return end
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
		for _, frame in VignetteFrames do frame.Parent = VignetteGui end
		VignetteGui.Parent = playerGui
	end

	local function UpdateVignette(speed)
		if not (Settings.VignetteEnabled and VRService.VREnabled) then
			if VignetteGui then VignetteGui.Enabled = false end
			return
		end
		if not VignetteGui then SetupVignette() end
		if not VignetteGui then return end
		VignetteGui.Enabled = true
		local alpha = math.clamp((speed - VIGNETTE_SPEED_LOW) / (VIGNETTE_SPEED_HIGH - VIGNETTE_SPEED_LOW), 0, 1)
		local transparency = 1 - alpha * VIGNETTE_MAX_DARKNESS
		for _, frame in VignetteFrames do frame.BackgroundTransparency = transparency end
	end

	--------------------------------------------------------------------
	-- Module Init & Destroy
	--------------------------------------------------------------------
	m.Init = function(figure: Model)
		CachedFigure = nil
		RefreshCache(figure)
		if not hum or not root or not torso then return end

		BaseWalkSpeed = WALK_SPEED
		IsRunning = false
		hum.WalkSpeed = WALK_SPEED
		HeightCalibration = 1

		-- Collision Arms reset
		PrevHandPosLeft = torso.Position - torso.CFrame.RightVector * 1.5
		PrevHandPosRight = torso.Position + torso.CFrame.RightVector * 1.5
		IsLeftHandGrounded = false
		IsRightHandGrounded = false

		pcall(function()
			if LimbReanimator and LimbReanimator.SetRootPartMode then
				LimbReanimator.SetRootPartMode(LIMB_REANIMATOR_ROOT_PART_MODE)
			end
		end)

		local parts = {}
		for _, v in figure:GetChildren() do
			if v:IsA("BasePart") then table.insert(parts, v) end
		end
		for i = 1, #parts do
			for j = i + 1, #parts do
				local nocoll = Instance.new("NoCollisionConstraint")
				nocoll.Part0, nocoll.Part1 = parts[i], parts[j]
				nocoll.Parent = parts[i]
			end
		end

		LegsTarget = {
			{ Position = root.CFrame * Vector3.new(-0.5, -3, 0), Offset = Vector3.new(-0.5, -1, 0), Target = root.CFrame * Vector3.new(-0.5, -3, 0), Timer = 0.5, Realism = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}, InAir = false },
			{ Position = root.CFrame * Vector3.new(0.5, -3, 0), Offset = Vector3.new(0.5, -1, 0), Target = root.CFrame * Vector3.new(0.5, -3, 0), Timer = 0, Realism = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}, InAir = false },
		}
		FakeVRArms = {
			{ Timer = 1, Realism = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}, Waving = false, Offset = CFrame.new(-1.5, -1, 0) },
			{ Timer = 1, Realism = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}, Waving = false, Offset = CFrame.new(1.5, -1, 0) },
		}
		Crouching = false
		CrouchDistance = 0

		ContextActions:BindAction("Uhhhhhh_VRWaveL", function(_, state)
			if state == Enum.UserInputState.Begin then FakeVRArms[1].Waving = true end
			if state == Enum.UserInputState.End then FakeVRArms[1].Waving = false end
		end, true, Enum.UserInputType.MouseButton1)
		ContextActions:SetTitle("Uhhhhhh_VRWaveL", "L")
		ContextActions:SetPosition("Uhhhhhh_VRWaveL", SafeButtonPosition(-230, -130))

		ContextActions:BindAction("Uhhhhhh_VRWaveR", function(_, state)
			if state == Enum.UserInputState.Begin then FakeVRArms[2].Waving = true end
			if state == Enum.UserInputState.End then FakeVRArms[2].Waving = false end
		end, true, Enum.UserInputType.MouseButton2)
		ContextActions:SetTitle("Uhhhhhh_VRWaveR", "R")
		ContextActions:SetPosition("Uhhhhhh_VRWaveR", SafeButtonPosition(-180, -130))

		ContextActions:BindAction("Uhhhhhh_VRCrouch", function(_, state)
			if state == Enum.UserInputState.Begin then Crouching = not Crouching end
		end, true, Enum.KeyCode.C)
		ContextActions:SetTitle("Uhhhhhh_VRCrouch", "C")
		ContextActions:SetPosition("Uhhhhhh_VRCrouch", SafeButtonPosition(-130, -230))

		ContextActions:BindAction("Uhhhhhh_VRRun", function(_, state)
			if state == Enum.UserInputState.Begin then
				IsRunning = not IsRunning
				BaseWalkSpeed = IsRunning and Settings.RunSpeed or WALK_SPEED
			end
		end, true, Enum.KeyCode.LeftControl, Enum.KeyCode.ButtonB)
		ContextActions:SetTitle("Uhhhhhh_VRRun", "Run")
		ContextActions:SetPosition("Uhhhhhh_VRRun", SafeButtonPosition(-180, -230))

		ContextActions:BindAction("Uhhhhhh_VRRecenter", function(_, state)
			if state == Enum.UserInputState.Begin then DoRecenterAndCalibrate() end
		end, true, Enum.KeyCode.T, Enum.KeyCode.ButtonL3)
		ContextActions:SetTitle("Uhhhhhh_VRRecenter", "Recenter")
		ContextActions:SetPosition("Uhhhhhh_VRRecenter", SafeButtonPosition(-230, -230))

		if SnapTurnConn then SnapTurnConn:Disconnect() end
		if SnapTurnEndedConn then SnapTurnEndedConn:Disconnect() end
		SnapTurnArmed, LastSnapTurnTime, LastThumbstick2X = true, 0, 0

		SnapTurnConn = UserInputService.InputChanged:Connect(function(input)
			if input.KeyCode ~= Enum.KeyCode.Thumbstick2 then return end
			LastThumbstick2X = input.Position.X
			if Settings.SmoothTurnEnabled then SnapTurnArmed = true return end
			if not (Settings.SnapTurnEnabled and VRService.VREnabled) then return end
			if math.abs(LastThumbstick2X) < SNAP_TURN_DEADZONE then SnapTurnArmed = true return end
			if SnapTurnArmed then
				SnapTurnArmed = false
				DoSnapTurn(LastThumbstick2X > 0 and 1 or -1, Settings.SnapTurnAngleDeg)
			end
		end)
		SnapTurnEndedConn = UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then LastThumbstick2X = 0 end
		end)

		StartBridgePolling()
	end

	--------------------------------------------------------------------
	-- Main Frame Update
	--------------------------------------------------------------------
	m.Update = function(dt: number, figure: Model)
		scale = figure:GetScale()
		isdancing = not not figure:GetAttribute("IsDancing")

		RefreshCache(figure)
		if not hum or not root or not torso then return end

		local rj, nj, rsj, lsj, rhj, lhj = CachedJoints.RootJoint, CachedJoints.Neck, CachedJoints.RightShoulder, CachedJoints.LeftShoulder, CachedJoints.RightHip, CachedJoints.LeftHip
		if not (rj and nj and rsj and lsj and rhj and lhj) then return end

		FilterInstances[1] = figure
		FilterInstances[2] = Player.Character
		rcp.FilterDescendantsInstances = FilterInstances

		local crouchTarget = (Crouching and 1 or 0) * CROUCH_DISTANCE
		CrouchDistance = crouchTarget + (CrouchDistance - crouchTarget) * math.exp(-JITTER_SMOOTHING_RATE * dt)

		if VRService.VREnabled and Settings.SmoothTurnEnabled and math.abs(LastThumbstick2X) > SMOOTH_TURN_DEADZONE then
			root.CFrame = root.CFrame * CFrame.Angles(0, LastThumbstick2X * math.rad(Settings.SmoothTurnSpeedDeg) * dt, 0)
		end

		if not isdancing then
			rj.Enabled, nj.Enabled, rsj.Enabled, lsj.Enabled, rhj.Enabled, lhj.Enabled = false, false, false, false, false, false
			
			-- HipHeight dynamic lift based on Arm Floating physics
			local floatLift = (Settings.FloorFloatingEnabled and ArmSpringOffset > 0) and (ArmSpringOffset * 0.85 * scale) or 0
			hum.HipHeight = 2 * scale - HIP_HEIGHT_FUDGE - CrouchDistance * scale + floatLift

			local crouchAlpha = CrouchDistance / CROUCH_DISTANCE
			hum.WalkSpeed = BaseWalkSpeed * (1 - crouchAlpha * (1 - CROUCH_WALKSPEED_SCALE))
			root.CustomPhysicalProperties = PhysicalProperties.new(3.15, 0.3, 0.5)

			local head, rarm, larm, rleg, lleg = CachedParts.Head, CachedParts.RightArm, CachedParts.LeftArm, CachedParts.RightLeg, CachedParts.LeftLeg
			if not (head and rarm and larm and rleg and lleg) then return end

			local vro = root.CFrame * CFrame.new(0, EYE_HEIGHT_OFFSET * scale * HeightCalibration, 0)
			local vroot = root.CFrame
			vro += Vector3.new(0, CrouchDistance * scale, 0)
			vroot += Vector3.new(0, CrouchDistance * scale, 0)

			local chead
			chead, vro = ResolveHead(vro)

			local leftHandEnabled = VRService.VREnabled and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
			local rightHandEnabled = VRService.VREnabled and VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)

			local clarm, clarmSynthetic = ResolveHand(1, dt, vro, chead, leftHandEnabled, "Left")
			local crarm, crarmSynthetic = ResolveHand(2, dt, vro, chead, rightHandEnabled, "Right")
			if clarmSynthetic then clarm += Vector3.new(0, -CrouchDistance, 0) end
			if crarmSynthetic then crarm += Vector3.new(0, -CrouchDistance, 0) end

			chead += chead.Position * (scale - 1)
			clarm += clarm.Position * (scale - 1)
			crarm += crarm.Position * (scale - 1)

			SetCFrame(head, vro * chead)

			-- COLLISION ARMS SOLVER INTEGRATION
			local shoulderLeftWorld = torso.CFrame * Vector3.new(-1.5 * scale, 1.2 * scale, 0)
			local shoulderRightWorld = torso.CFrame * Vector3.new(1.5 * scale, 1.2 * scale, 0)

			local rawLeftWorld = (vro * clarm).Position
			local rawRightWorld = (vro * crarm).Position

			local solvedLeftWorld, collL, normL, partL = SolveCollisionArm(shoulderLeftWorld, rawLeftWorld, PrevHandPosLeft, dt)
			IsLeftHandGrounded, LeftContactNormal, LeftContactPart = collL, normL, partL
			PrevHandPosLeft = solvedLeftWorld

			local solvedRightWorld, collR, normR, partR = SolveCollisionArm(shoulderRightWorld, rawRightWorld, PrevHandPosRight, dt)
			IsRightHandGrounded, RightContactNormal, RightContactPart = collR, normR, partR
			PrevHandPosRight = solvedRightWorld

			-- Mid-air float & gravity suspension update
			UpdateArmFloatPhysics(shoulderLeftWorld, solvedLeftWorld, shoulderRightWorld, solvedRightWorld, dt)

			-- Locomotion & Arm Vaulting
			UpdateVRMovementSystem(dt)

			-- Re-solve Arm 2-Bone IK with Collision Contact Points
			local poleL = torso.CFrame.RightVector * -2.0 - torso.CFrame.LookVector * 1.5
			local poleR = torso.CFrame.RightVector * 2.0 - torso.CFrame.LookVector * 1.5

			local armo = CFrame.Angles(HALF_PI, 0, 0)
			local finalLeftArmCF = IK2Bone(shoulderLeftWorld, solvedLeftWorld, poleL, 1.2 * scale, 1.2 * scale) * armo
			local finalRightArmCF = IK2Bone(shoulderRightWorld, solvedRightWorld, poleR, 1.2 * scale, 1.2 * scale) * armo

			SetCFrame(larm, finalLeftArmCF)
			SetCFrame(rarm, finalRightArmCF)

			-- Legs & Torso
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
			if VignetteGui then VignetteGui.Enabled = false end
		end
	end

	m.Destroy = function(figure: Model?)
		ContextActions:UnbindAction("Uhhhhhh_VRWaveL")
		ContextActions:UnbindAction("Uhhhhhh_VRWaveR")
		ContextActions:UnbindAction("Uhhhhhh_VRCrouch")
		ContextActions:UnbindAction("Uhhhhhh_VRRun")
		ContextActions:UnbindAction("Uhhhhhh_VRRecenter")
		if SnapTurnConn then SnapTurnConn:Disconnect() SnapTurnConn = nil end
		if SnapTurnEndedConn then SnapTurnEndedConn:Disconnect() SnapTurnEndedConn = nil end
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
					local force = PartForces[part]
					if force then force:Destroy() PartForces[part] = nil end
					PinnedCFrames[part] = nil
				end
			end
		end
		CachedFigure = nil
	end

	return m
end)

return modules
