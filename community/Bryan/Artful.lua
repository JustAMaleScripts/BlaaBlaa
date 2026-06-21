local modules = {}

table.insert(modules, function()
	local m = {}
	
	m.ModuleType = "MOVESET"
	m.Name = "Artful"
	m.Description = "French Guy"
	m.InternalName = "MOVESET_ARTFUL"
	
	m.Assets = {
		"Artful idle.anim",
		"Artful walk.anim",
		"Artful sprint.anim",
		"Artful swing.anim",
		"Artful implement.anim",
		"Artful repurpose.anim",
		"Artful repurpose2.anim",
		"Artful copywrite.anim",

		-- BACKGROUND SOUND
		"Artful Chase.mp3",
	}
	
	m.Config = function(parent)
		Util_CreateText(parent, "ARTFUL MOVESET", 20, Enum.TextXAlignment.Center)
	end
	
	m.SaveConfig = function()
		return {}
	end
	
	m.LoadConfig = function() end
	
	local figureRef
	local bgSound
	local idleAnim
	local walkAnim
	local sprintAnim
	local swingAnim
	local implementAnim
	local repurposeAnim
	local repurpose2Anim
	local copywriteAnim
	local currentAnim
	
	local action = false
	local actionStart = 0
	local actionDuration = 0
	
	local repurposeCount = 0  -- alterna entre 1ª e 2ª vez
	
	local WALK_SPEED   = 16
	local SPRINT_SPEED = 28
	local isSprinting  = false
	
	-- ── sound helper ─────────────────────────────────────────────
	local function makeSound(filename, parent, volume, looped)
		local s = Instance.new("Sound")
		s.SoundId = AssetGetContentId(filename)
		s.Volume  = volume or 0.8
		s.Looped  = looped or false
		s.Parent  = parent
		return s
	end

	local function loadAnim(file)
		local anim = AnimLib.Animator.new()
		anim.rig = figureRef
		anim.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
		anim.looped = false
		anim.speed = 1
		anim.weight = 0
		return anim
	end
	
	local function loadLoopAnim(file)
		local anim = loadAnim(file)
		anim.looped = true
		return anim
	end
	
	local function play(anim)
		if currentAnim == anim then return end
		if currentAnim then currentAnim.weight = 0 end
		currentAnim = anim
		currentAnim.weight = 1
		currentAnim._start = os.clock()
	end
	
	-- ── Action handlers ───────────────────────────────────────────

	-- Mouse Click → Swing
	local function doSwing()
		if action then return end
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		action = true
		actionStart = os.clock()
		actionDuration = swingAnim.track and swingAnim.track.Time or 0.6
		play(swingAnim)
	end
	
	-- E → Implement
	local function doImplement()
		if action then return end
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		action = true
		actionStart = os.clock()
		actionDuration = implementAnim.track and implementAnim.track.Time or 5.5
		hum.WalkSpeed = 0
		play(implementAnim)
	end
	
	-- R → Repurpose (alterna entre repurpose.anim e repurpose2.anim)
	local function doRepurpose()
		if action then return end
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		action = true
		actionStart = os.clock()
		repurposeCount = repurposeCount + 1
		if repurposeCount % 2 == 1 then
			actionDuration = repurposeAnim.track and repurposeAnim.track.Time or 4.0
			hum.WalkSpeed = 0
			play(repurposeAnim)
		else
			actionDuration = repurpose2Anim.track and repurpose2Anim.track.Time or 4.0
			hum.WalkSpeed = 0
			play(repurpose2Anim)
		end
	end
	
	-- Q → Copywrite
	local function doCopywrite()
		if action then return end
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		action = true
		actionStart = os.clock()
		actionDuration = copywriteAnim.track and copywriteAnim.track.Time or 7.3
		hum.WalkSpeed = 0
		play(copywriteAnim)
	end
	
	-- Ctrl → Sprint | Shift → Walk (toggle entre os dois)
	local function setSprintState(sprinting)
		isSprinting = sprinting
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if sprinting then
			if hum and not action then hum.WalkSpeed = SPRINT_SPEED end
		else
			if hum and not action then hum.WalkSpeed = WALK_SPEED end
		end
	end
	
	m.Init = function(figure)
		figureRef = figure
		
		idleAnim      = loadLoopAnim("Artful idle.anim")
		walkAnim      = loadLoopAnim("Artful walk.anim")
		sprintAnim    = loadLoopAnim("Artful sprint.anim")
		swingAnim     = loadAnim("Artful swing.anim")
		implementAnim = loadAnim("Artful implement.anim")
		repurposeAnim  = loadAnim("Artful repurpose.anim")
		repurpose2Anim = loadAnim("Artful repurpose2.anim")
		copywriteAnim  = loadAnim("Artful copywrite.anim")
		
		play(idleAnim)
		
		local hum = figure:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = WALK_SPEED end

		-- BACKGROUND SOUND
		local hrp = figure:FindFirstChild("HumanoidRootPart") or figure
		bgSound = makeSound("Artful Chase.mp3", hrp, 0.5, true)
		bgSound:Play()
		
		-- ── Keyboard / Mouse input (PC) ──────────────────────────────
		local uis = game:GetService("UserInputService")
		
		uis.InputBegan:Connect(function(input, gpe)
			if gpe or not figureRef then return end
			
			-- Mouse Click → Swing
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				doSwing()
			end

			-- Q → Copywrite
			if input.KeyCode == Enum.KeyCode.Q then
				doCopywrite()
			end

			-- E → Implement
			if input.KeyCode == Enum.KeyCode.E then
				doImplement()
			end

			-- R → Repurpose
			if input.KeyCode == Enum.KeyCode.R then
				doRepurpose()
			end

			-- LeftControl → Sprint
			if input.KeyCode == Enum.KeyCode.LeftControl then
				setSprintState(true)
			end

			-- LeftShift → Walk (cancela sprint)
			if input.KeyCode == Enum.KeyCode.LeftShift then
				setSprintState(false)
			end
		end)

		-- Soltar Ctrl volta para Walk
		uis.InputEnded:Connect(function(input, gpe)
			if gpe or not figureRef then return end
			if input.KeyCode == Enum.KeyCode.LeftControl then
				setSprintState(false)
			end
		end)
		
		-- ── Mobile buttons (ContextActionService) ────────────────────
		local cas = game:GetService("ContextActionService")
		
		-- Botão 1 – Swing (Mouse Click)
		cas:BindActionAtPriority(
			"ARTFUL_SWING",
			function(name, state, obj)
				if state == Enum.UserInputState.Begin then
					doSwing()
				end
				return Enum.ContextActionResult.Sink
			end,
			true,
			2000,
			Enum.UserInputType.MouseButton1
		)
		cas:SetTitle("ARTFUL_SWING", "Swing")
		cas:SetPosition("ARTFUL_SWING", UDim2.new(1, -280, 1, -280))
		
		-- Botão 2 – Copywrite (Q)
		cas:BindActionAtPriority(
			"ARTFUL_COPYWRITE",
			function(name, state, obj)
				if state == Enum.UserInputState.Begin then
					doCopywrite()
				end
				return Enum.ContextActionResult.Sink
			end,
			true,
			2000,
			Enum.KeyCode.Q
		)
		cas:SetTitle("ARTFUL_COPYWRITE", "Copywrite")
		cas:SetPosition("ARTFUL_COPYWRITE", UDim2.new(1, -180, 1, -280))
		
		-- Botão 3 – Implement (E)
		cas:BindActionAtPriority(
			"ARTFUL_IMPLEMENT",
			function(name, state, obj)
				if state == Enum.UserInputState.Begin then
					doImplement()
				end
				return Enum.ContextActionResult.Sink
			end,
			true,
			2000,
			Enum.KeyCode.E
		)
		cas:SetTitle("ARTFUL_IMPLEMENT", "Implement")
		cas:SetPosition("ARTFUL_IMPLEMENT", UDim2.new(1, -80, 1, -280))
		
		-- Botão 4 – Repurpose (R)
		cas:BindActionAtPriority(
			"ARTFUL_REPURPOSE",
			function(name, state, obj)
				if state == Enum.UserInputState.Begin then
					doRepurpose()
				end
				return Enum.ContextActionResult.Sink
			end,
			true,
			2000,
			Enum.KeyCode.R
		)
		cas:SetTitle("ARTFUL_REPURPOSE", "Repurpose")
		cas:SetPosition("ARTFUL_REPURPOSE", UDim2.new(1, -180, 1, -180))
		
		-- Botão 5 – Sprint (Ctrl)
		cas:BindActionAtPriority(
			"ARTFUL_SPRINT",
			function(name, state, obj)
				if state == Enum.UserInputState.Begin then
					setSprintState(true)
				elseif state == Enum.UserInputState.End then
					setSprintState(false)
				end
				return Enum.ContextActionResult.Sink
			end,
			true,
			2000,
			Enum.KeyCode.LeftControl
		)
		cas:SetTitle("ARTFUL_SPRINT", "Sprint")
		cas:SetPosition("ARTFUL_SPRINT", UDim2.new(1, -80, 1, -180))
	end
	
	m.Update = function(dt, figure)
		if not figureRef then return end
		local hum = figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		
		if action then
			if os.clock() - actionStart >= actionDuration then
				action = false
				hum.WalkSpeed = isSprinting and SPRINT_SPEED or WALK_SPEED
			end
		else
			hum.WalkSpeed = isSprinting and SPRINT_SPEED or WALK_SPEED
			
			if hum.MoveDirection.Magnitude > 0 then
				if isSprinting then
					play(sprintAnim)
				else
					play(walkAnim)
				end
			else
				play(idleAnim)
			end
		end
		
		local now = os.clock()
		
		if idleAnim.weight > 0       then idleAnim:Step(now - idleAnim._start) end
		if walkAnim.weight > 0       then walkAnim:Step(now - walkAnim._start) end
		if sprintAnim.weight > 0     then sprintAnim:Step(now - sprintAnim._start) end
		if swingAnim.weight > 0      then swingAnim:Step(now - swingAnim._start) end
		if implementAnim.weight > 0  then implementAnim:Step(now - implementAnim._start) end
		if repurposeAnim.weight > 0  then repurposeAnim:Step(now - repurposeAnim._start) end
		if repurpose2Anim.weight > 0 then repurpose2Anim:Step(now - repurpose2Anim._start) end
		if copywriteAnim.weight > 0  then copywriteAnim:Step(now - copywriteAnim._start) end
	end
	
	m.Destroy = function(figure)
		-- Remove mobile buttons
		local cas = game:GetService("ContextActionService")
		cas:UnbindAction("ARTFUL_SWING")
		cas:UnbindAction("ARTFUL_COPYWRITE")
		cas:UnbindAction("ARTFUL_IMPLEMENT")
		cas:UnbindAction("ARTFUL_REPURPOSE")
		cas:UnbindAction("ARTFUL_SPRINT")
		
		-- Stop and destroy background sound
		if bgSound then bgSound:Stop() bgSound:Destroy() bgSound = nil end
		
		isSprinting = false
		
		local hum = figure and figure:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 10 end
	end
	
	return m
end)

return modules
