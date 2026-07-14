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

	local baseArmSize, baseLegSize
	-- FIX: cache original joint C0s so we can restore the rig on Destroy
	local baseC0 = {}

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.RespectCanCollide = true
	rayParams.IgnoreWater = true

	local function Raycast(origin, direction, filter)
		rayParams.FilterDescendantsInstances = filter or {}
		return workspace:Raycast(origin, direction, rayParams)
	end

	-- Long-limb helper: R6 limbs are Y-long, so lookAt (-Z) needs a
	-- 90° correction before offsetting along the stretch axis.
	local function StretchCFrame(origin: Vector3, target: Vector3)
		local delta = target - origin
		local dist = delta.Magnitude
		if dist < 1e-3 then
			return CFrame.new(origin), 0
		end
		local dir = delta / dist
		local cf = CFrame.new(origin, origin + dir) * CFrame.Angles(math.pi / 2, 0, 0)
		return cf * CFrame.new(0, dist / 2, 0), dist
	end

	-- FIX: solve a Motor6D's C0 so Part1 lands on a desired WORLD CFrame,
	-- instead of ever writing part.CFrame or part.Velocity directly.
	-- This keeps Root as the only physically-simulated part and lets the
	-- rest of the rig follow through its joints exactly like normal
	-- animation does - no assembly breakup, no root/torso disagreement.
	local function SolveC0(joint: Motor6D, part0WorldCF: CFrame, desiredPart1WorldCF: CFrame)
		return part0WorldCF:Inverse() * desiredPart1WorldCF * joint.C1
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

		hum.WalkSpeed = 0
		hum.JumpPower = 0
		hum.AutoRotate = false
		-- FIX: no negative HipHeight hack; the crouched look now comes
		-- entirely from RootJoint.C0, so leave HipHeight at a sane value.
		hum.HipHeight = math.max(hum.HipHeight, 0)

		rj = root:FindFirstChild("RootJoint")
		nj = torso:FindFirstChild("Neck")
		rsj = torso:FindFirstChild("Right Shoulder")
		lsj = torso:FindFirstChild("Left Shoulder")
		rhj = torso:FindFirstChild("Right Hip")
		lhj = torso:FindFirstChild("Left Hip")

		-- FIX: joints stay enabled the whole time - never disable RootJoint
		-- (or any joint). We only ever write to their .C0.
		for name, j in pairs({rj = rj, nj = nj, rsj = rsj, lsj = lsj, rhj = rhj, lhj = lhj}) do
			if j then
				j.Enabled = true
				baseC0[name] = j.C0
			end
		end

		baseArmSize = larm.Size
		baseLegSize = lleg.Size

		isPlanted = false
		plantCooldown = 0
		launchBoost = Vector3.zero
		climbBoost = Vector3.zero
		pullLeft = false
		pullRight = false

		pcall(function() ContextActions:UnbindAction("GT_PullLeft") end)
		pcall(function() ContextActions:UnbindAction("GT_PullRight") end)

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
		local filter = {figure, Player.Character}

		local camCF = ReanimCamera.CFrame
		local lookDir = camCF.LookVector
		local pitch = math.asin(math.clamp(lookDir.Y, -1, 1))
		local yaw = math.atan2(lookDir.X, lookDir.Z)

		local ARM_REACH = 4.5 * scale
		local LEG_REACH = 3.0 * scale
		local PLANT_PITCH = -0.55
		local LAUNCH_PITCH = -0.25

		plantCooldown = math.max(0, plantCooldown - dt)

		if pitch < PLANT_PITCH and not isPlanted and plantCooldown <= 0 then
			isPlanted = true
		elseif pitch > LAUNCH_PITCH and isPlanted then
			isPlanted = false
			plantCooldown = 0.25
			local push = Vector3.new(lookDir.X, 0, lookDir.Z).Unit
			if push ~= push then push = Vector3.new(0, 0, 1) end
			launchBoost = push * 55 * scale + Vector3.new(0, 42 * scale, 0)
		end

		-- Root is the ONLY part we ever apply velocity/CFrame writes to
		-- directly - that's correct, it's the physically simulated part.
		if launchBoost.Magnitude > 0.1 then
			root.AssemblyLinearVelocity += launchBoost * dt * 6
			launchBoost *= math.exp(-5 * dt)
		end

		if climbBoost.Magnitude > 0.1 then
			root.AssemblyLinearVelocity += climbBoost * dt * 8
			climbBoost *= math.exp(-7 * dt)
		end

		if isPlanted then
			local v = root.AssemblyLinearVelocity
			root.AssemblyLinearVelocity = Vector3.new(v.X, math.max(v.Y, -4), v.Z)
		end

		if pullLeft or pullRight then
			local pullDir = Vector3.new(lookDir.X, 0.3, lookDir.Z).Unit
			root.AssemblyLinearVelocity += pullDir * 35 * scale * dt
		end

		local rootCF = root.CFrame
		local rootPos = rootCF.Position
		local torsoTilt = math.clamp(-pitch * 0.6, -0.9, 0.5)
		local torsoCF = CFrame.new(rootPos + Vector3.new(0, -1.0 * scale, 0)) * CFrame.Angles(torsoTilt, yaw, 0)

		local lShoulder = torsoCF * CFrame.new(-0.9 * scale, -0.8 * scale, 0)
		local rShoulder = torsoCF * CFrame.new(0.9 * scale, -0.8 * scale, 0)

		local lTarget = lShoulder.Position + lookDir * ARM_REACH
		local rTarget = rShoulder.Position + lookDir * ARM_REACH

		local lHit = Raycast(lShoulder.Position, lookDir * ARM_REACH, filter)
		local rHit = Raycast(rShoulder.Position, lookDir * ARM_REACH, filter)

		if lHit then lTarget = lHit.Position - lookDir * 0.15 end
		if rHit then rTarget = rHit.Position - lookDir * 0.15 end

		if isPlanted then
			local groundY = rootPos.Y - 2.2 * scale
			lTarget = Vector3.new(lTarget.X, math.min(lTarget.Y, groundY), lTarget.Z)
			rTarget = Vector3.new(rTarget.X, math.min(rTarget.Y, groundY), rTarget.Z)
		end

		local lArmCF, lArmLen = StretchCFrame(lShoulder.Position, lTarget)
		local rArmCF, rArmLen = StretchCFrame(rShoulder.Position, rTarget)

		larm.Size = Vector3.new(baseArmSize.X, math.max(lArmLen, baseArmSize.Y), baseArmSize.Z)
		rarm.Size = Vector3.new(baseArmSize.X, math.max(rArmLen, baseArmSize.Y), baseArmSize.Z)

		if pitch > 0.35 then
			local upDir = (Vector3.new(0, 1, 0) + lookDir * 0.2).Unit
			local lUp = Raycast(lShoulder.Position, upDir * ARM_REACH, filter)
			local rUp = Raycast(rShoulder.Position, upDir * ARM_REACH, filter)
			local hitUp = (lUp and lUp.Position.Y > torsoCF.Position.Y) or (rUp and rUp.Position.Y > torsoCF.Position.Y)
			if hitUp then
				climbBoost = Vector3.new(0, 70 * scale, 0)
			end
		end

		local lHip = torsoCF * CFrame.new(-0.7 * scale, -0.8 * scale, 0.7 * scale)
		local rHip = torsoCF * CFrame.new(0.7 * scale, -0.8 * scale, 0.7 * scale)

		local legDir = (-torsoCF.LookVector * 0.8 - Vector3.new(0, 0.6, 0)).Unit
		local lLegCF, lLegLen = StretchCFrame(lHip.Position, lHip.Position + legDir * LEG_REACH)
		local rLegCF, rLegLen = StretchCFrame(rHip.Position, rHip.Position + legDir * LEG_REACH)

		lleg.Size = Vector3.new(baseLegSize.X, math.max(lLegLen, baseLegSize.Y), baseLegSize.Z)
		rleg.Size = Vector3.new(baseLegSize.X, math.max(rLegLen, baseLegSize.Y), baseLegSize.Z)

		local headCF = camCF * CFrame.new(0, -0.5 * scale, 0)

		-- FIX: drive everything through joint C0s only. No part.CFrame writes,
		-- no velocity zeroing, no disabling joints, Torso never touched directly.
		if rj then rj.C0 = SolveC0(rj, rootCF, torsoCF) end
		if nj then nj.C0 = SolveC0(nj, torsoCF, headCF) end
		if lsj then lsj.C0 = SolveC0(lsj, torsoCF, lArmCF) end
		if rsj then rsj.C0 = SolveC0(rsj, torsoCF, rArmCF) end
		if lhj then lhj.C0 = SolveC0(lhj, torsoCF, lLegCF) end
		if rhj then rhj.C0 = SolveC0(rhj, torsoCF, rLegCF) end
	end

	m.Destroy = function(figure: Model?)
		if hum then
			hum.WalkSpeed = 16
			hum.JumpPower = 50
			hum.AutoRotate = true
			hum.HipHeight = 2
		end

		-- FIX: restore original joint offsets instead of leaving the rig
		-- frozen in its last primate pose
		if rj and baseC0.rj then rj.C0 = baseC0.rj end
		if nj and baseC0.nj then nj.C0 = baseC0.nj end
		if rsj and baseC0.rsj then rsj.C0 = baseC0.rsj end
		if lsj and baseC0.lsj then lsj.C0 = baseC0.lsj end
		if rhj and baseC0.rhj then rhj.C0 = baseC0.rhj end
		if lhj and baseC0.lhj then lhj.C0 = baseC0.lhj end
		table.clear(baseC0)

		if larm and baseArmSize then larm.Size = baseArmSize end
		if rarm and baseArmSize then rarm.Size = baseArmSize end
		if lleg and baseLegSize then lleg.Size = baseLegSize end
		if rleg and baseLegSize then rleg.Size = baseLegSize end

		pcall(function() ContextActions:UnbindAction("GT_PullLeft") end)
		pcall(function() ContextActions:UnbindAction("GT_PullRight") end)
		pullLeft = false
		pullRight = false
	end

	return m
end)
return modules
