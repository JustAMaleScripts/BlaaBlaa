-- StillLifeMoveset.lua
-- Idle / Crawl-Idle / Walk(Run) / Crawl moveset themed around Kane Parsons - Still Life

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType   = "MOVESET"
m.Name         = "Still Life"
m.Description  = "I like it in here"
m.InternalName = "MOVESET_STILLLIFE"
m.Assets = {
	"Still_idle.anim",
	"Still_Idle_Crawl.anim",
	"Still_Walk.anim",
	"Still_Run.anim",
	"Still_Crawl.anim",
	"StillLife_Crouch_Idle.anim",
	"StillLife_Crouch_Walk.anim",
	"Still_Life.mp3",
	"StillLife_Sing1.mp3",
	"StillLife_Screech1.mp3",
	"StillLife_Screech2.mp3",
	"Huss.Walk.anim",
	"Huss_Run.anim",
	"Do You Like Larping.mp3",
	"Desolation_idle.anim",
	"Desolation_Walk.anim",
	"Desolation_Run.anim",
	"Old Objects in Quiet Rooms.mp3",
	"Pitfalls_scream1.mp3",
	"Pitfalls_scream2.mp3",
	"Blox_idle.anim",
	"Blox_Walk.anim",
	"Blox_Run.anim",
}

m.WalkSpeed   = 10 -- exact WalkSpeed while walking (overwritten per style on load)
m.RunSpeed    = 24 -- exact WalkSpeed while sprinting (overwritten per style on load)
m.CrouchSpeed = 6  -- exact WalkSpeed while crouched (shared across all styles)
m.CrawlSpeed  = 8  -- exact WalkSpeed while crawling/prone (shared across all styles)

m.Style = "StillLife" -- "StillLife" | "Huss" | "Desolation" | "Bloxrooms"

-- idle/walk/run reuse Still_idle.anim unless a style provides its own.
-- Crouch/crawl anims are NOT part of this table -- they're shared across every
-- style, since only Still Life has ever had dedicated crouch/crawl anims.
local STYLES = {
	StillLife = {
		label = "Still Life",
		idle = "Still_idle.anim", walk = "Still_Walk.anim", run = "Still_Run.anim",
		walkSpeed = 10, runSpeed = 24,
		music = "Still_Life.mp3", musicTitle = "Still Life - Kane Parsons", musicLen = 279.7,
	},
	Huss = {
		label = "Captain Huss",
		idle = "Still_idle.anim", walk = "Huss.Walk.anim", run = "Huss_Run.anim",
		walkSpeed = 16, runSpeed = 38.4,
		music = "Do You Like Larping.mp3", musicTitle = "Do You Like Larping?", musicLen = 64.9,
	},
	Desolation = {
		label = "Desolation Still Life",
		idle = "Desolation_idle.anim", walk = "Desolation_Walk.anim", run = "Desolation_Run.anim",
		walkSpeed = 3.1, runSpeed = 26.2,
		music = "Old Objects in Quiet Rooms.mp3", musicTitle = "Old Objects in Quiet Rooms", musicLen = 418.8,
		screech = { "Pitfalls_scream1.mp3", "Pitfalls_scream2.mp3" },
	},
	Bloxrooms = {
		label = "Bloxrooms Still Life",
		idle = "Blox_idle.anim", walk = "Blox_Walk.anim", run = "Blox_Run.anim",
		walkSpeed = 11.5, runSpeed = 26,
		music = "Still_Life.mp3", musicTitle = "Still Life - Kane Parsons", musicLen = 279.7,
	},
}

-- Dropdown order/labels. m.Style keeps storing the key (e.g. "Huss") so saved configs stay valid.
local STYLE_ORDER  = { "StillLife", "Huss", "Desolation", "Bloxrooms" }
local STYLE_LABELS = { "Still Life", "Captain Huss", "Desolation Still Life", "Bloxrooms Still Life" }

local function styleIndex(key)
	for i, k in ipairs(STYLE_ORDER) do
		if k == key then return i end
	end
	return 1
end

local applyStyle -- assigned further down (it needs loadAnim and the state machine, declared after Config)

m.Config = function(parent)
	Util_CreateText(parent, "Still Life", 25, Enum.TextXAlignment.Center)
	Util_CreateSeparator(parent)
	Util_CreateText(parent, "v Controls v", 20, Enum.TextXAlignment.Center)
   Util_CreateText(parent, "run: Shift", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "crouch: C", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "stand > crouch > crawl > jump", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Screech: G", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Sing: H", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Walk/Run WalkSpeed: set by style", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Crouch WalkSpeed: 6", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Crawl WalkSpeed: 8", 14, Enum.TextXAlignment.Center)

	Util_CreateSeparator(parent)
	Util_CreateText(parent, "Styles", 14, Enum.TextXAlignment.Center)
	Util_CreateDropdown(parent, "Style", STYLE_LABELS, styleIndex(m.Style)).Changed:Connect(function(val)
		local key = STYLE_ORDER[val]
		if key then applyStyle(key) end
	end)
end

m.SaveConfig = function()
	return { Style = m.Style }
end
m.LoadConfig = function(save)
	if save and save.Style and STYLES[save.Style] then
		m.Style = save.Style
	end
end


-- SERVICES

local CAS = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")


-- STATE

local state       = "none"
local stance       = "stand" -- "stand" | "crouch" | "crawl"
local sprinting    = false

local origJumpPower = 50
local origJumpHeight = 7.2

local anims        = {}
local connections  = {}

local VOICE_COOLDOWN  = 3 -- seconds
local lastScreechTime = 0
local lastSingTime    = 0

local STANCE_UP_COOLDOWN = 0.5 -- seconds, stops holding Jump from cascading through stances
local lastStanceUpTime   = 0


-- ANIMATION LOADER

local function loadAnim(fig, file, looped, speed)
	local a  = AnimLib.Animator.new()
	a.rig    = fig
	a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
	a.looped = looped
	a.speed  = speed or 1
	a.weight = 0
	return a
end


-- PLAY ANIMATION (simple hard-swap, all others silenced)

local function playAnim(a)
	for _, anim in pairs(anims) do
		anim.weight = 0
	end
	if a then
		a.weight = 1
	end
end


-- STATE MACHINE
-- idle        = standing still
-- walk        = standing, moving
-- run         = standing, moving, sprinting
-- crouchIdle  = crouched, still
-- crouchWalk  = crouched, moving
-- crawlIdle   = prone/crawling, still
-- crawl       = prone/crawling, moving

local function setState(new)
	if state == new then return end
	state = new

	if new == "idle" then
		playAnim(anims.idle)
	elseif new == "walk" then
		playAnim(anims.walk)
	elseif new == "run" then
		playAnim(anims.run)
	elseif new == "crouchIdle" then
		playAnim(anims.crouchIdle)
	elseif new == "crouchWalk" then
		playAnim(anims.crouchWalk)
	elseif new == "crawlIdle" then
		playAnim(anims.crawlIdle)
	elseif new == "crawl" then
		playAnim(anims.crawl)
	end
end


-- STANCE (C steps down: stand -> crouch -> crawl)

local function stepStanceDown()
	if stance == "stand" then
		stance = "crouch"
	elseif stance == "crouch" then
		stance = "crawl"
	end
	-- already "crawl": clamped, no further change
end

local function onStanceDownInput(_, inputState)
	if inputState == Enum.UserInputState.Begin then
		stepStanceDown()
	end
end


-- JUMP INTERCEPT (steps stance up: crawl -> crouch -> stand; only jumps when already standing)
-- Jumping is fully disabled at the Humanoid level while crouched/crawling (see Update loop),
-- so the state never actually engages. JumpRequest fires on the raw input regardless of
-- whether jumping is allowed, so we use it to detect the attempt and step the stance instead.

local function onJumpRequest(hum)
	if stance == "stand" then return end -- jumping is enabled, let it happen normally

	local now = os.clock()
	if now - lastStanceUpTime < STANCE_UP_COOLDOWN then return end
	lastStanceUpTime = now

	if stance == "crawl" then
		stance = "crouch"
	elseif stance == "crouch" then
		stance = "stand"
	end
end


-- SPRINT (toggle to run)

local function onSprintInput(_, inputState)
	if inputState == Enum.UserInputState.Begin then
		sprinting = not sprinting
	end
end


-- SCREECH (plays one of two clips at random; Desolation swaps these for its scream clips)

local DEFAULT_SCREECH_CLIPS = { "StillLife_Screech1.mp3", "StillLife_Screech2.mp3" }
local screechClips = DEFAULT_SCREECH_CLIPS

local function playVoiceClip(fig, file)
	local root = fig and fig:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local snd = Instance.new("Sound")
	snd.SoundId = AssetGetContentId(file)
	snd.Volume  = 1
	snd.Parent  = root
	snd:Play()
	snd.Ended:Connect(function()
		snd:Destroy()
	end)
end

local function onScreechInput(_, inputState, fig)
	if inputState == Enum.UserInputState.Begin then
		local now = os.clock()
		if now - lastScreechTime < VOICE_COOLDOWN then return end
		lastScreechTime = now

		local pick = screechClips[math.random(1, #screechClips)]
		playVoiceClip(fig, pick)
	end
end


-- SING

local function onSingInput(_, inputState, fig)
	if inputState == Enum.UserInputState.Begin then
		local now = os.clock()
		if now - lastSingTime < VOICE_COOLDOWN then return end
		lastSingTime = now

		playVoiceClip(fig, "StillLife_Sing1.mp3")
	end
end


-- STYLE SWITCHING
-- Works live: the dropdown calls this while the moveset is running, and Init calls it on load.

local currentFigure = nil

applyStyle = function(key)
	local styleData = STYLES[key]
	if not styleData then return end

	m.Style      = key
	m.WalkSpeed  = styleData.walkSpeed
	m.RunSpeed   = styleData.runSpeed
	screechClips = styleData.screech or DEFAULT_SCREECH_CLIPS

	if not currentFigure then return end -- moveset not running; Init applies the saved style on load

	-- Only idle/walk/run are style-specific; the crouch/crawl animators are shared and stay put.
	for _, slot in ipairs({ "idle", "walk", "run" }) do
		local old = anims[slot]
		if old then old.weight = 0 end
		anims[slot] = loadAnim(currentFigure, styleData[slot], true)
	end
	state = "none" -- forces setState to pick up the new animator on the next Update

	SetOverrideMovesetMusic(
		AssetGetContentId(styleData.music),
		styleData.musicTitle,
		0.6,
		NumberRange.new(0, styleData.musicLen)
	)
	SetOverrideMovesetMusicTime(0)
end


-- INIT

m.Init = function(figure)
	_G._StillLifeFigure = figure
	currentFigure = figure

	local hum = figure:FindFirstChildOfClass("Humanoid")
	if hum then
		origJumpPower  = hum.JumpPower
		origJumpHeight = hum.JumpHeight
	end

	anims = {
		crouchIdle = loadAnim(figure, "StillLife_Crouch_Idle.anim",  true),
		crouchWalk = loadAnim(figure, "StillLife_Crouch_Walk.anim",  true),
		crawlIdle  = loadAnim(figure, "Still_Idle_Crawl.anim",       true),
		crawl      = loadAnim(figure, "Still_Crawl.anim",            true),
	}

	-- fills idle/walk/run, sets speeds + screech clips, and starts the style's music
	applyStyle(STYLES[m.Style] and m.Style or "StillLife")

	if hum then
		hum.WalkSpeed = m.WalkSpeed
		table.insert(connections, UIS.JumpRequest:Connect(function()
			onJumpRequest(hum)
		end))
	end

	CAS:BindAction("StillLifeCrawl", function(action, inputState)
		onStanceDownInput(action, inputState)
	end, true, Enum.KeyCode.C)
	CAS:SetPosition("StillLifeCrawl", UDim2.new(1, -140, 1, -140))
	CAS:SetTitle("StillLifeCrawl", "Crouch")

	CAS:BindAction("StillLifeSprint", onSprintInput, true, Enum.KeyCode.LeftShift)
	CAS:SetPosition("StillLifeSprint", UDim2.new(1, -70, 1, -140))
	CAS:SetTitle("StillLifeSprint", "Run")

	CAS:BindAction("StillLifeScreech", function(action, inputState)
		onScreechInput(action, inputState, figure)
	end, true, Enum.KeyCode.G)
	CAS:SetPosition("StillLifeScreech", UDim2.new(1, -140, 1, -210))
	CAS:SetTitle("StillLifeScreech", "Screech")

	CAS:BindAction("StillLifeSing", function(action, inputState)
		onSingInput(action, inputState, figure)
	end, true, Enum.KeyCode.H)
	CAS:SetPosition("StillLifeSing", UDim2.new(1, -70, 1, -210))
	CAS:SetTitle("StillLifeSing", "Sing")

	setState("idle")
end


-- UPDATE LOOP

m.Update = function(dt, figure)
	local hum = figure:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local moving = hum.MoveDirection.Magnitude > 0.1

	hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, stance == "stand")

	if stance == "crawl" then
		hum.WalkSpeed = m.CrawlSpeed
		setState(moving and "crawl" or "crawlIdle")
	elseif stance == "crouch" then
		hum.WalkSpeed = m.CrouchSpeed
		setState(moving and "crouchWalk" or "crouchIdle")
	elseif moving and sprinting then
		hum.WalkSpeed = m.RunSpeed
		setState("run")
	elseif moving then
		hum.WalkSpeed = m.WalkSpeed
		setState("walk")
	else
		hum.WalkSpeed = m.WalkSpeed
		setState("idle")
	end

	local now = os.clock()
	for _, a in pairs(anims) do
		if a.weight > 0 then
			a:Step(now)
		end
	end
end


-- CLEANUP

m.Destroy = function(figure)
	for _, c in pairs(connections) do c:Disconnect() end
	table.clear(connections)
	table.clear(anims)

	CAS:UnbindAction("StillLifeCrawl")
	CAS:UnbindAction("StillLifeSprint")
	CAS:UnbindAction("StillLifeScreech")
	CAS:UnbindAction("StillLifeSing")
	SetOverrideMovesetMusic()

	if figure then
		local hum = figure:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed  = m.WalkSpeed
			hum.JumpPower  = origJumpPower
			hum.JumpHeight = origJumpHeight
			hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		end
	end

	state     = "none"
	stance    = "stand"
	sprinting = false
	lastScreechTime = 0
	lastSingTime    = 0

	currentFigure = nil
	_G._StillLifeFigure = nil
end

return m

end)

return modules
