local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType = "MOVESET"
	m.Name = "harken"
	m.Description = "tuffolina"
	m.InternalName = "MOVESET_CESUS_HARKEN"

	m.Assets = {
		"harken intro.anim",
		"harken idle.anim",
		"harken walk.anim",
		"harken sprint.anim",
		"harken swing.anim",
		"harken tangle.anim",
		"harken tangle pull.anim",
		"harken immolate.anim",
		"harken enrage.anim",
		"harken calm down.anim",

		-- BACKGROUND SOUND
		"harken chase theme.mp3",
	}

	m.Config = function(parent)
		Util_CreateText(parent, "CESUS HARKEN MOVESET", 20, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function()
		return {}
	end

	m.LoadConfig = function() end

	-- ── References ───────────────────────────────────────────────────
	local figureRef
	local bgSound

	local introAnim
	local idleAnim
	local walkAnim
	local sprintAnim
	local swingAnim
	local tangleAnim
	local tanglePullAnim
	local immolateAnim
	local enrageAnim
	local calmDownAnim

	local currentAnim

	-- ── State ────────────────────────────────────────────────────────
	local action        = false   -- generic action lock (frozen)
	local actionStart   = 0
	local actionDuration = 0

	-- Tangle toggle: false = first press (play tangle), true = second press (play tangle pull)
	local tangleActive  = false

	-- Rage speed buff
	local rageActive    = false
	local rageEndTime   = 0
	local RAGE_DURATION = 10      -- seconds of speed buff

	-- Sprint
	local WALK_SPEED   = 16
	local SPRINT_SPEED = 28
	local RAGE_SPEED   = 36       -- speed during rage buff (faster than sprint)
	local isSprinting  = false

	-- Intro flag – block all input until intro finishes
	local introPlaying  = true
	local introStart    = 0
	local introDuration = 0

	-- ── Helpers ──────────────────────────────────────────────────────
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
		anim.rig    = figureRef
		anim.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
		anim.looped = false
		anim.speed  = 1
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

	local function freeze()
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 0 end
	end

	local function unfreeze()
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		if rageActive then
			hum.WalkSpeed = RAGE_SPEED
		elseif isSprinting then
			hum.WalkSpeed = SPRINT_SPEED
		else
			hum.WalkSpeed = WALK_SPEED
		end
	end

	-- ── Action handlers ──────────────────────────────────────────────

	-- Left Mouse Click → Swing (no freeze)
	local function doSwing()
		if action or introPlaying then return end
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		action       = true
		actionStart  = os.clock()
		actionDuration = swingAnim.track and swingAnim.track.Time or 0.6
		-- Swing does NOT freeze
		play(swingAnim)
	end

	-- Q → Tangle (toggle between tangle and tangle pull)
	local function doTangle()
		if action or introPlaying then return end
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		action = true
		actionStart = os.clock()
		if not tangleActive then
			-- First press: play tangle, freeze
			tangleActive   = true
			actionDuration = tangleAnim.track and tangleAnim.track.Time or 2.0
			freeze()
			play(tangleAnim)
		else
			-- Second press: play tangle pull, freeze, reset toggle
			tangleActive   = false
			actionDuration = tanglePullAnim.track and tanglePullAnim.track.Time or 2.0
			freeze()
			play(tanglePullAnim)
		end
	end

	-- E → Immolate (freeze for full duration)
	local function doImmolate()
		if action or introPlaying then return end
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		action       = true
		actionStart  = os.clock()
		actionDuration = immolateAnim.track and immolateAnim.track.Time or 3.0
		freeze()
		play(immolateAnim)
	end

	-- R → Rage (freeze during anim, then speed buff for 10 s, then calm down anim + freeze)
	local function doRage()
		if action or introPlaying or rageActive then return end
		local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		action       = true
		actionStart  = os.clock()
		actionDuration = enrageAnim.track and enrageAnim.track.Time or 4.0
		freeze()
		play(enrageAnim)
	end

	-- Ctrl (hold) / Shift (toggle off) → Sprint
	local function setSprintState(sprinting)
		isSprinting = sprinting
		if not action and not introPlaying then
			unfreeze()
		end
	end

	-- ── Init ─────────────────────────────────────────────────────────
	m.Init = function(figure)
		figureRef = figure

		introAnim     = loadAnim("harken intro.anim")
		idleAnim      = loadLoopAnim("harken idle.anim")
		walkAnim      = loadLoopAnim("harken walk.anim")
		sprintAnim    = loadLoopAnim("harken sprint.anim")
		swingAnim     = loadAnim("harken swing.anim")
		tangleAnim    = loadAnim("harken tangle.anim")
		tanglePullAnim= loadAnim("harken tangle pull.anim")
		immolateAnim  = loadAnim("harken immolate.anim")
		enrageAnim    = loadAnim("harken enrage.anim")
		calmDownAnim  = loadAnim("harken calm down.anim")

		-- Play intro, freeze character
		introPlaying  = true
		introStart    = os.clock()
		introDuration = introAnim.track and introAnim.track.Time or 3.0
		freeze()
		play(introAnim)

		-- Background sound
		local hrp = figure:FindFirstChild("HumanoidRootPart") or figure
		bgSound = makeSound("harken chase theme.mp3", hrp, 0.5, true)
		bgSound:Play()

		-- ── Keyboard / Mouse input ───────────────────────────────────
		local uis = game:GetService("UserInputService")

		uis.InputBegan:Connect(function(input, gpe)
			if gpe or not figureRef then return end

			-- Left Click → Swing
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				doSwing()
			end

			-- Q → Tangle
			if input.KeyCode == Enum.KeyCode.Q then
				doTangle()
			end

			-- E → Immolate
			if input.KeyCode == Enum.KeyCode.E then
				doImmolate()
			end

			-- R → Rage
			if input.KeyCode == Enum.KeyCode.R then
				doRage()
			end

			-- LeftControl → Sprint
			if input.KeyCode == Enum.KeyCode.LeftControl then
				setSprintState(true)
			end

			-- LeftShift → Walk (cancel sprint)
			if input.KeyCode == Enum.KeyCode.LeftShift then
				setSprintState(false)
			end
		end)

		uis.InputEnded:Connect(function(input, gpe)
			if gpe or not figureRef then return end
			-- Release Ctrl → back to walk
			if input.KeyCode == Enum.KeyCode.LeftControl then
				setSprintState(false)
			end
		end)

		-- ── Mobile buttons (ContextActionService) ────────────────────
		local cas = game:GetService("ContextActionService")

		-- Button 1 – Swing
		cas:BindActionAtPriority(
			"CESUS_SWING",
			function(name, state, obj)
				if state == Enum.UserInputState.Begin then doSwing() end
				return Enum.ContextActionResult.Sink
			end,
			true,
			2000,
			Enum.UserInputType.MouseButton1
		)
		cas:SetTitle("CESUS_SWING", "Swing")
		cas:SetPosition("CESUS_SWING", UDim2.new(1, -280, 1, -280))

		-- Button 2 – Tangle (Q)
		cas:BindActionAtPriority(
			"CESUS_TANGLE",
			function(name, state, obj)
				if state == Enum.UserInputState.Begin then doTangle() end
				return Enum.ContextActionResult.Sink
			end,
			true,
			2000,
			Enum.KeyCode.Q
		)
		cas:SetTitle("CESUS_TANGLE", "Tangle")
		cas:SetPosition("CESUS_TANGLE", UDim2.new(1, -180, 1, -280))

		-- Button 3 – Immolate (E)
		cas:BindActionAtPriority(
			"CESUS_IMMOLATE",
			function(name, state, obj)
				if state == Enum.UserInputState.Begin then doImmolate() end
				return Enum.ContextActionResult.Sink
			end,
			true,
			2000,
			Enum.KeyCode.E
		)
		cas:SetTitle("CESUS_IMMOLATE", "Immolate")
		cas:SetPosition("CESUS_IMMOLATE", UDim2.new(1, -80, 1, -280))

		-- Button 4 – Rage (R)
		cas:BindActionAtPriority(
			"CESUS_RAGE",
			function(name, state, obj)
				if state == Enum.UserInputState.Begin then doRage() end
				return Enum.ContextActionResult.Sink
			end,
			true,
			2000,
			Enum.KeyCode.R
		)
		cas:SetTitle("CESUS_RAGE", "Rage")
		cas:SetPosition("CESUS_RAGE", UDim2.new(1, -180, 1, -180))

		-- Button 5 – Sprint (Ctrl hold / Shift cancel)
		cas:BindActionAtPriority(
			"CESUS_SPRINT",
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
		cas:SetTitle("CESUS_SPRINT", "Sprint")
		cas:SetPosition("CESUS_SPRINT", UDim2.new(1, -80, 1, -180))
	end

	-- ── Update ───────────────────────────────────────────────────────
	m.Update = function(dt, figure)
		if not figureRef then return end
		local hum = figureRef:FindFirstChildOfClass("Humanoid")
		if not hum then return end

		local now = os.clock()

		-- ── 1. Intro phase ──────────────────────────────────────────
		if introPlaying then
			if now - introStart >= introDuration then
				introPlaying = false
				action       = false
				unfreeze()
				play(idleAnim)
			end

		-- ── 2. Generic action lock ───────────────────────────────────
		elseif action then
			if now - actionStart >= actionDuration then
				action = false

				-- If the enrage animation just finished, start rage buff
				if currentAnim == enrageAnim then
					rageActive  = true
					rageEndTime = now + RAGE_DURATION
					unfreeze()   -- apply rage speed
					play(idleAnim)
				else
					-- All other frozen actions: just unfreeze
					unfreeze()
					play(idleAnim)
				end
			end

		-- ── 3. Rage buff countdown ───────────────────────────────────
		elseif rageActive then
			if now >= rageEndTime then
				rageActive = false
				-- Play calm down anim, freeze during it
				action       = true
				actionStart  = now
				actionDuration = calmDownAnim.track and calmDownAnim.track.Time or 2.5
				freeze()
				play(calmDownAnim)
			else
				-- Normal locomotion logic while raged
				if hum.MoveDirection.Magnitude > 0 then
					play(sprintAnim)   -- use sprint anim while raging
				else
					play(idleAnim)
				end
			end

		-- ── 4. Normal locomotion ─────────────────────────────────────
		else
			unfreeze()
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

		-- ── Step all active anims ────────────────────────────────────
		if introAnim.weight > 0       then introAnim:Step(now - introAnim._start) end
		if idleAnim.weight > 0        then idleAnim:Step(now - idleAnim._start) end
		if walkAnim.weight > 0        then walkAnim:Step(now - walkAnim._start) end
		if sprintAnim.weight > 0      then sprintAnim:Step(now - sprintAnim._start) end
		if swingAnim.weight > 0       then swingAnim:Step(now - swingAnim._start) end
		if tangleAnim.weight > 0      then tangleAnim:Step(now - tangleAnim._start) end
		if tanglePullAnim.weight > 0  then tanglePullAnim:Step(now - tanglePullAnim._start) end
		if immolateAnim.weight > 0    then immolateAnim:Step(now - immolateAnim._start) end
		if enrageAnim.weight > 0      then enrageAnim:Step(now - enrageAnim._start) end
		if calmDownAnim.weight > 0    then calmDownAnim:Step(now - calmDownAnim._start) end
	end

	-- ── Destroy ──────────────────────────────────────────────────────
	m.Destroy = function(figure)
		local cas = game:GetService("ContextActionService")
		cas:UnbindAction("CESUS_SWING")
		cas:UnbindAction("CESUS_TANGLE")
		cas:UnbindAction("CESUS_IMMOLATE")
		cas:UnbindAction("CESUS_RAGE")
		cas:UnbindAction("CESUS_SPRINT")

		if bgSound then bgSound:Stop() bgSound:Destroy() bgSound = nil end

		isSprinting  = false
		rageActive   = false
		introPlaying = false
		tangleActive = false

		local hum = figure and figure:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 10 end
	end

	return m
end)

return modules
