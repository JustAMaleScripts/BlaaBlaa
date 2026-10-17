-- UhhhhhhReanim/Modules/Conga.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType   = "DANCE"
	m.Name         = "Crazy Walk"
	m.Description  = "Run brochacho Run run RAHHH"
	m.InternalName = "DANCE_CONGA"
	m.Assets       = {}

	m.Config = function(parent)
		Util_CreateText(parent, "Run like Crazy ", 24, Enum.TextXAlignment.Center)
		Util_CreateSeparator(parent)
		Util_CreateText(parent, "Just run", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig = function(save) end

	-- ─── upvalues ────────────────────────────────────────────────────────────
	local animator      = nil
	local sndConga      = nil
	local startTime     = 0
	local savedSpeed    = 16
	local pausedSounds  = {}   -- sounds we muted so we can restore them

	-- ─── Init ────────────────────────────────────────────────────────────────
	m.Init = function(figure)
		local hrp = figure:FindFirstChild("HumanoidRootPart") or figure
		local hum = figure:FindFirstChildOfClass("Humanoid")

		-- animation (looping)
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("broCrazyRun.anim"))
		animator.looped = true
		animator.speed  = 1
		animator.weight = 1
		startTime       = os.clock()

		-- ── override music: pause all looping sounds in HRP ──────────────
		pausedSounds = {}
		for _, obj in hrp:GetChildren() do
			if obj:IsA("Sound") and obj.Looped and obj.Playing then
				obj:Pause()
				table.insert(pausedSounds, obj)
			end
		end

		-- conga music (looping, overrides everything)
		sndConga         = Instance.new("Sound")
		sndConga.SoundId = AssetGetContentId("Crazy.mp3")
		sndConga.Volume  = 0.8
		sndConga.Looped  = true
		sndConga.Parent  = hrp
		sndConga:Play()

		-- ── slow walk forward ────────────────────────────────────────────
		if hum then
			savedSpeed    = hum.WalkSpeed
			hum.WalkSpeed = 25
		end
	end

	-- ─── Update ──────────────────────────────────────────────────────────────
	m.Update = function(dt, figure)
		-- step animation
		if animator and animator.weight > 0 then
			animator:Step(os.clock() - startTime)
		end

		-- keep walking forward in the direction the character faces
		local hum = figure:FindFirstChildOfClass("Humanoid")
		local hrp = figure:FindFirstChild("HumanoidRootPart")
		if hum and hrp then
			hum:Move(hrp.CFrame.LookVector, false)
		end
	end

	-- ─── Destroy ─────────────────────────────────────────────────────────────
	m.Destroy = function(figure)
		-- stop & remove conga music
		if sndConga then
			sndConga:Stop()
			sndConga:Destroy()
			sndConga = nil
		end

		-- restore previously paused sounds (moveset music etc.)
		for _, snd in pausedSounds do
			if snd and snd.Parent then
				snd:Resume()
			end
		end
		table.clear(pausedSounds)

		-- restore walk speed
		if figure then
			local hum = figure:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = savedSpeed
			end
		end

		animator  = nil
		startTime = 0
		savedSpeed = 16
	end

	return m
end)


return modules
