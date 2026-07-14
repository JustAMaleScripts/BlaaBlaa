local modules = {}

table.insert(modules, function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Primate"
	m.Description = "Gorilla Tag inspired locomotion\n\nLook down to plant long arms, look forward to hop\nLook up at a wall to climb edges\nLegs trail behind and are cosmetic only\nM1 - Left Arm Pull\nM2 - Right Arm Pull"
	m.Assets = {}

	m.Config = function(parent: GuiBase2d)
	end

	local Player = game:GetService("Players").LocalPlayer
	local RunService = cloneref(game:GetService("RunService"))
	local ContextActions = ContextActions -- from env

	local hum, root, torso, head, rarm, larm, rleg, lleg
	local rj, nj, rsj, lsj, rhj, lhj
	local scale = 1

	local isPlanted = false
	local plantCooldown = 0
	local launchBoost = Vector3.zero
	local climbBoost = Vector3.zero
	local pullLeft = false
	local pullRight = false

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.RespectCanCollide = true
	rayParams.IgnoreWater = true

	local function SetCFrame(part, cf)
		if not part then return end
		part.CFrame = cf
		part.Velocity = Vector3.zero
		part.RotVelocity = Vector3.zero
		part.AssemblyLinearVelocity = Vector3.zero
		part.AssemblyAngularVelocity = Vector3.zero
	end

	local function Raycast(origin, direction, filter)
		rayParams.FilterDescendantsInstances = filter or {}
		return workspace:Raycast(origin, direction, rayParams)
	end

	m.Init = function(figure: Model)
		hum = figure:FindFirstChildOfClass("Humanoid")
		root = figure:FindFirstChild("HumanoidRootPart")
		torso = figure:FindFirstChild("Torso")
		head = figure:FindFirstChild("Head")
		rarm = figure:FindFirstChild("Right Arm")
		larm = figure:FindFirstChild("Left Arm")
		rleg = figure:FindFirstChild("Right Leg")
		lleg = figure:FindFirstChild("Left Leg")

		if not (hum and root and torso and head and rarm and larm and rleg and lleg) then
			return
		end

		-- Disable default walking; we move with arms
		hum.WalkSpeed = 0
		hum.JumpPower = 0
		hum.AutoRotate = false

		rj = root:FindFirstChild("RootJoint")
		nj = torso:FindFirstChild("Neck")
		rsj = torso:FindFirstChild("Right Shoulder")
		lsj = torso:FindFirstChild("Left Shoulder")
		rhj = torso:FindFirstChild("Right Hip")
		lhj = torso:FindFirstChild("Left Hip")

		isPlanted = false
		plantCooldown = 0
		launchBoost = Vector3.zero
		climbBoost = Vector3.zero

		-- Manual arm pulls for fine-tuned climbing
		ContextActions:BindAction("GT_PullLeft", function(_, state)
			pullLeft = (state == Enum.UserInputState.Begin)
		end, true, Enum.UserInputType.MouseButton1)
		ContextActions:SetTitle("GT_PullLeft", "L")
		ContextActions:SetPosition("GT_PullLeft", UDim2.new(1, -230, 1, -130))

		ContextActions:BindAction("GT_PullRight", function(_, state)
			pullRight = (state == Enum.UserInputState.Begin)
		end, true, Enum.UserInputType.MouseButton2)
		ContextActions:SetTitle("GT_PullRight", "R")
		ContextActions:SetPosition("GT_PullRight", UDim2.new(1, -180, 1, -130))
	end

	m.Update = function(dt: number, figure: Model)
		if not (hum and root and torso) then return end

		scale = figure:GetScale() or 1
		local char = figure
		local filter = {char, Player.Character}

		-- Camera data
		local camCF = ReanimCamera.CFrame
		local lookDir = camCF.LookVector
		local pitch = math.asin(math.clamp(lookDir.Y, -1, 1))
		local yaw = math.atan2(lookDir.X, lookDir.Z)

		-- Constants
		local ARM_REACH = 4.5 * scale
		local LEG_REACH = 3.0 * scale
		local PLANT_PITCH = -0.55   -- look down to plant
		local LAUNCH_PITCH = -0.25  -- look back up to hop

		plantCooldown = math.max(0, plantCooldown - dt)

		-- Auto-hop logic: plant when looking down, launch when looking forward
		if pitch < PLANT_PITCH and not isPlanted and plantCooldown <= 0 then
			isPlanted = true
		elseif pitch > LAUNCH_PITCH and isPlanted then
			isPlanted = false
			plantCooldown = 0.25
			local push = Vector3.new(lookDir.X, 0, lookDir.Z).Unit
			if push ~= push then push = Vector3.new(0, 0, 1) end
			launchBoost = push * 55 * scale + Vector3.new(0, 42 * scale, 0)
		end

		-- Apply launch decay
		if launchBoost.Magnitude > 0.1 then
			root.AssemblyLinearVelocity += launchBoost * dt * 6
			launchBoost *= math.exp(-5 * dt)
		end

		-- Apply climb decay
		if climbBoost.Magnitude > 0.1 then
			root.AssemblyLinearVelocity += climbBoost * dt * 8
			climbBoost *= math.exp(-7 * dt)
		end

		-- When planted, resist gravity so we don't slide too much
		if isPlanted then
			local v = root.AssemblyLinearVelocity
			root.AssemblyLinearVelocity = Vector3.new(v.X, math.max(v.Y, -4), v.Z)
		end

		-- Manual pulls from mouse buttons (small directional tugs)
		if pullLeft or pullRight then
			local pullDir = Vector3.new(lookDir.X, 0.3, lookDir.Z).Unit
			root.AssemblyLinearVelocity += pullDir * 35 * scale * dt
		end

		-- Torso: low to ground, yaw follows camera, tilt follows pitch
		local rootPos = root.CFrame.Position
		local torsoTilt = math.clamp(-pitch * 0.6, -0.9, 0.5)
		local torsoCF = CFrame.new(rootPos + Vector3.new(0, -1.0 * scale, 0)) * CFrame.Angles(torsoTilt, yaw, 0)

		-- Arms: attached low on torso ("bottom frame")
		local lShoulder = torsoCF * CFrame.new(-0.9 * scale, -0.8 * scale, 0)
		local rShoulder = torsoCF * CFrame.new(0.9 * scale, -0.8 * scale, 0)

		-- Hand targets by raycasting in look direction
		local lTarget = lShoulder.Position + lookDir * ARM_REACH
		local rTarget = rShoulder.Position + lookDir * ARM_REACH

		local lHit = Raycast(lShoulder.Position, lookDir * ARM_REACH, filter)
		local rHit = Raycast(rShoulder.Position, lookDir * ARM_REACH, filter)

		if lHit then lTarget = lHit.Position - lookDir * 0.15 end
		if rHit then rTarget = rHit.Position - lookDir * 0.15 end

		-- When planted, force hands toward ground in front
		if isPlanted then
			local groundY = rootPos.Y - 2.2 * scale
			lTarget = Vector3.new(lTarget.X, math.min(lTarget.Y, groundY), lTarget.Z)
			rTarget = Vector3.new(rTarget.X, math.min(rTarget.Y, groundY), rTarget.Z)
		end

		-- Long arm CFrames
		local lArmCF = CFrame.lookAt(lShoulder.Position, lTarget) * CFrame.new(0, 0, -ARM_REACH * 0.5)
		local rArmCF = CFrame.lookAt(rShoulder.Position, rTarget) * CFrame.new(0, 0, -ARM_REACH * 0.5)

		-- Climbing: looking up + raycast above shoulders = pull up
		if pitch > 0.35 then
			local upDir = (Vector3.new(0, 1, 0) + lookDir * 0.2).Unit
			local lUp = Raycast(lShoulder.Position, upDir * ARM_REACH, filter)
			local rUp = Raycast(rShoulder.Position, upDir * ARM_REACH, filter)

			local hitUp = (lUp and lUp.Position.Y > torsoCF.Position.Y) or (rUp and rUp.Position.Y > torsoCF.Position.Y)
			if hitUp then
				climbBoost = Vector3.new(0, 70 * scale, 0)
			end
		end

		-- Legs: trail behind from hips, "connected" to the same low torso frame
		local lHip = torsoCF * CFrame.new(-0.7 * scale, -0.8 * scale, 0.7 * scale)
		local rHip = torsoCF * CFrame.new(0.7 * scale, -0.8 * scale, 0.7 * scale)

		local legDir = (-torsoCF.LookVector * 0.8 - Vector3.new(0, 0.6, 0)).Unit
		local lLegCF = CFrame.lookAt(lHip.Position, lHip.Position + legDir) * CFrame.new(0, 0, -LEG_REACH * 0.5)
		local rLegCF = CFrame.lookAt(rHip.Position, rHip.Position + legDir) * CFrame.new(0, 0, -LEG_REACH * 0.5)

		-- Disable joints and write transforms
		if rj then rj.Enabled = false end
		if nj then nj.Enabled = false end
		if rsj then rsj.Enabled = false end
		if lsj then lsj.Enabled = false end
		if rhj then rhj.Enabled = false end
		if lhj then lhj.Enabled = false end

		hum.HipHeight = -2.8 * scale

		SetCFrame(head, camCF * CFrame.new(0, -0.5 * scale, 0))
		SetCFrame(torso, torsoCF)
		SetCFrame(larm, lArmCF)
		SetCFrame(rarm, rArmCF)
		SetCFrame(lleg, lLegCF)
		SetCFrame(rleg, rLegCF)
	end

    m.Destroy = function(figure: Model?)
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.AutoRotate = true
        end
        if rj then rj.Enabled = true end
        if nj then nj.Enabled = true end
        if rsj then rsj.Enabled = true end
        if lsj then lsj.Enabled = true end
        if rhj then rhj.Enabled = true end
        if lhj then lhj.Enabled = true end
    end
    
    return m
end)
return modules
