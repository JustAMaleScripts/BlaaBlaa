-- LocustMoveset.lua
-- Idle / Crounch-Idle / Walk(Run) moveset

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType   = "MOVESET"
m.Name         = "Locust Moveset"
m.Description  = "No attacks, Only base animation and crounch"
m.InternalName = "MOVESET_STILLLIFE"
m.Assets = {
	"LocustIdle.anim",
	"LocustCrounchIdle.anim",
	"LocustWalk.anim",
	"LocustRun.anim",
	"LocustCrounchWalk.anim",
	"LocustTheme.mp3",
	"LocustSayingHi.mp3",
	"LocustSayingPlease.mp3",
	"LocustBreathing.mp3",
}

m.WalkSpeed  = 10 -- exact WalkSpeed while walking
m.RunSpeed   = 24 -- exact WalkSpeed while sprinting
m.CrawlSpeed = 9 -- exact WalkSpeed while crawling

m.Config = function(parent)
	Util_CreateText(parent, "Still Life", 20, Enum.TextXAlignment.Center)
	Util_CreateSeparator(parent)
	Util_CreateText(parent, "Toggle crawl with C / mobile button", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Toggle run with Shift / mobile button", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Screech with G / mobile button", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Sing with H / mobile button", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Walk WalkSpeed: 10", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Run WalkSpeed: 24", 14, Enum.TextXAlignment.Center)
	Util_CreateText(parent, "Crawl WalkSpeed: 8", 14, Enum.TextXAlignment.Center)
end

m.SaveConfig = function() return {} end
m.LoadConfig = function(save) end


-- SERVICES

local CAS = game:GetService("ContextActionService")


-- STATE

local state       = "none"
local crouched     = false
local sprinting    = false

local anims        = {}
local connections  = {}

local VOICE_COOLDOWN  = 3 -- seconds
local lastScreechTime = 0
local lastSingTime    = 0


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
-- idle       = standing still
-- walk       = standing, moving
-- run        = standing, moving, sprinting
-- crawlIdle  = crouched, still
-- crawl      = crouched, moving

local function setState(new)
	if state == new then return end
	state = new

	if new == "idle" then
		playAnim(anims.idle)
	elseif new == "walk" then
		playAnim(anims.walk)
	elseif new == "run" then
		playAnim(anims.run)
	elseif new == "crawlIdle" then
		playAnim(anims.crawlIdle)
	elseif new == "crawl" then
		playAnim(anims.crawl)
	end
end


-- CRAWL TOGGLE

local function setCrouch(fig, on)
	if crouched == on then return end
	crouched = on

	local hum = fig:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	if crouched then
		hum.WalkSpeed = m.CrawlSpeed
	else
		hum.WalkSpeed = m.WalkSpeed
	end
end

local function onCrouchInput(_, inputState, fig)
	if inputState == Enum.UserInputState.Begin then
		setCrouch(fig, not crouched)
	end
end


-- SPRINT (toggle to run)

local function onSprintInput(_, inputState)
	if inputState == Enum.UserInputState.Begin then
		sprinting = not sprinting
	end
end


-- SCREECH (plays one of two clips at random)

local screechClips = { "LocustSayingHi.mp3", "LocustSayingPlease.mp3" }

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

		playVoiceClip(fig, "BiastScream.mp3")
	end
end


-- INIT

m.Init = function(figure)
	_G._StillLifeFigure = figure

	local hum = figure:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = m.WalkSpeed
	end

	anims = {
		idle      = loadAnim(figure, "LocustIdle.anim",       true),
		walk      = loadAnim(figure, "LocustWalk.anim",       true),
		run       = loadAnim(figure, "LocustRun.anim",        true),
		crawlIdle = loadAnim(figure, "LocustCrounchIdle.anim", true),
		crawl     = loadAnim(figure, "LocustCrounchWalk.anim",      true),
	}

	SetOverrideMovesetMusic(
		AssetGetContentId("LocustTheme.mp3"),
		"LocustTheme.mp3",
		0.6,
		NumberRange.new(0, 9999.7)
	)

	CAS:BindAction("StillLifeCrawl", function(action, inputState)
		onCrouchInput(action, inputState, figure)
	end, true, Enum.KeyCode.C)
	CAS:SetPosition("StillLifeCrawl", UDim2.new(1, -140, 1, -140))
	CAS:SetTitle("StillLifeCrawl", "Crawl")

	CAS:BindAction("StillLifeSprint", onSprintInput, true, Enum.KeyCode.LeftShift)
	CAS:SetPosition("StillLifeSprint", UDim2.new(1, -70, 1, -140))
	CAS:SetTitle("StillLifeSprint", "Run")

	CAS:BindAction("StillLifeScreech", function(action, inputState)
		onScreechInput(action, inputState, figure)
	end, true, Enum.KeyCode.G)
	CAS:SetPosition("StillLifeScreech", UDim2.new(1, -140, 1, -210))
	CAS:SetTitle("StillLifeScreech", "Hi Please")

	CAS:BindAction("StillLifeSing", function(action, inputState)
		onSingInput(action, inputState, figure)
	end, true, Enum.KeyCode.H)
	CAS:SetPosition("StillLifeSing", UDim2.new(1, -70, 1, -210))
	CAS:SetTitle("StillLifeSing", "Breathing")

	setState("idle")
end


-- UPDATE LOOP

m.Update = function(dt, figure)
	local hum = figure:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local moving = hum.MoveDirection.Magnitude > 0.1

	if crouched then
		hum.WalkSpeed = m.CrawlSpeed
		setState(moving and "crawl" or "crawlIdle")
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
		if hum then hum.WalkSpeed = m.WalkSpeed end
	end

	state     = "none"
	crouched  = false
	sprinting = false
	lastScreechTime = 0
	lastSingTime    = 0

	_G._StillLifeFigure = nil
end

return m

end)

return modules
