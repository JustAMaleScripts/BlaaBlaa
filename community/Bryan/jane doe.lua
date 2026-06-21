-- Jane doe.lua

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType   = "MOVESET"
m.Name         = "Jane doe"
m.Description  = "girl from roblox"
m.InternalName = "jane_doe"

m.Assets = {
    -- BASE
    "jane doe idle.anim",
    "jane doe walk.anim",
    "jane doe run.anim",

    -- ACTIONS
    "jane doe Throw Charge.anim",
    "jane doe Throw.anim",
    "jane doe hatchet.anim",
}

-- ── CONFIG ────────────────────────────────────────────────────
m.InjuredMode = false

m.Config = function(parent)
    Util_CreateText(parent, "Jane doe", 18, Enum.TextXAlignment.Center)
end

m.SaveConfig = function()
    return {}
end
m.LoadConfig = function(save)
end

-- ── SERVICES ──────────────────────────────────────────────────
local Players = game:GetService("Players")

-- ── ANIMS ─────────────────────────────────────────────────────
local baseAnims   = {}
local actionAnims = {}

-- ── STATE ─────────────────────────────────────────────────────
local currentBase   = "idle"
local actionStart   = {}
local currentAction = nil
local isSprinting   = false
local figureRef     = nil
local allJoints     = {}

-- Crystal Pitch state:
-- "none"     -> Begin pressed -> "charging" (throwCharge plays, player slows)
--   End released during charge -> "throwing" (throw starts immediately)
--   throwCharge finishes while still held -> "throwing" (throw starts)
-- "throwing" -> throw finishes -> "none" (speed restored)
local crystalPhase      = "none"
local crystalChargeHeld = false

-- ── SPEEDS ────────────────────────────────────────────────────
local SPEED_WALK   = 16
local SPEED_SPRINT = 26
local SPEED_SLOW   = 8

-- ── HELPERS ───────────────────────────────────────────────────
local function loadAnim(fig, file, looped)
    local a = AnimLib.Animator.new()
    a.rig    = fig
    a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
    a.looped = looped or false
    a.speed  = 1
    a.weight = 0
    return a
end

local function setSpeed(speed)
    if not figureRef then return end
    local hum = figureRef:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = speed end
end

local function clearBase()
    for _, a in pairs(baseAnims) do a.weight = 0 end
end

local function setBase(state)
    if currentBase == state then return end
    currentBase = state
    clearBase()
    if baseAnims[state] then baseAnims[state].weight = 1 end
end

local function stopAction()
    for _, a in pairs(actionAnims) do a.weight = 0 end
    currentAction = nil
end

local function forceAction(name)
    local a = actionAnims[name]
    if not a then return end
    stopAction()
    a.weight       = 1
    actionStart[a] = os.clock()
    currentAction  = name
end

local function toggleSprint()
    isSprinting = not isSprinting
    if isSprinting then
        setSpeed(SPEED_SPRINT)
        ContextActions:SetTitle("GM_Sprint", "Walk")
    else
        setSpeed(SPEED_WALK)
        ContextActions:SetTitle("GM_Sprint", "Sprint")
    end
end

local function btnPos(col, row)
    local btnW  = 0.10
    local gapW  = 0.01
    local btnH  = 0.08
    local gapH  = 0.01
    local baseY = 0.12
    local x = 1 - (col + 1) * (btnW + gapW)
    local y = 1 - baseY - row * (btnH + gapH)
    return UDim2.new(x, 0, y, 0)
end

-- ── CRYSTAL PITCH ─────────────────────────────────────────────
local function startThrow()
    crystalPhase = "throwing"
    local c = actionAnims["throwCharge"]
    if c then c.weight = 0 end
    local t = actionAnims["throw"]
    t.weight       = 1
    actionStart[t] = os.clock()
    currentAction  = "throw"
end

local function onCrystalPitch(_, inputState, _)
    if inputState == Enum.UserInputState.Begin then
        if crystalPhase ~= "none" then return end
        crystalPhase      = "charging"
        crystalChargeHeld = true
        forceAction("throwCharge")
        setSpeed(SPEED_SLOW)

    elseif inputState == Enum.UserInputState.End then
        crystalChargeHeld = false
        if crystalPhase == "charging" then
            -- Button released at any point during charge -> play throw
            startThrow()
        end
    end
end

-- ── HATCHET ───────────────────────────────────────────────────
local function onHatchet(_, inputState, _)
    if inputState ~= Enum.UserInputState.Begin then return end
    if currentAction then return end
    forceAction("hatchet")
end

-- ── INIT ──────────────────────────────────────────────────────
m.Init = function(figure)
    figureRef = figure

    allJoints = {}
    for _, v in ipairs(figure:GetDescendants()) do
        if v:IsA("Motor6D") then table.insert(allJoints, v) end
    end

    -- BASE ANIMS (Jane Doe locomotion)
    baseAnims = {
        idle = loadAnim(figure, "jane doe idle.anim", true),
        walk = loadAnim(figure, "jane doe walk.anim", true),
        run  = loadAnim(figure, "jane doe run.anim",  true),
    }

    -- ACTION ANIMS
    actionAnims = {
        throwCharge = loadAnim(figure, "jane doe Throw Charge.anim", false),
        throw       = loadAnim(figure, "jane doe Throw.anim",        false),
        hatchet     = loadAnim(figure, "jane doe hatchet.anim",      false),
    }

    setSpeed(SPEED_WALK)
    setBase("idle")

    -- SPRINT
    ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then toggleSprint() end
    end, true, Enum.KeyCode.LeftAlt)
    ContextActions:SetTitle("GM_Sprint", "Sprint")
    ContextActions:SetPosition("GM_Sprint", btnPos(3.5, 17))

    -- CRYSTAL PITCH (hold/release logic handled via Begin + End)
    ContextActions:BindAction("GM_CrystalPitch", onCrystalPitch,
        true, Enum.KeyCode.R)
    ContextActions:SetTitle("GM_CrystalPitch", "Crystal Pitch")
    ContextActions:SetPosition("GM_CrystalPitch", btnPos(3.5, 21))

    -- HATCHET
    ContextActions:BindAction("GM_Hatchet", onHatchet,
        true, Enum.KeyCode.T)
    ContextActions:SetTitle("GM_Hatchet", "Hatchet")
    ContextActions:SetPosition("GM_Hatchet", btnPos(7, 21))
end

-- ── UPDATE ────────────────────────────────────────────────────
m.Update = function(dt, figure)
    local hum = figure:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local inAir  = hum.FloorMaterial == Enum.Material.Air
    local moving = hum.MoveDirection.Magnitude > 0.1

    -- ── HELPERS ───────────────────────────────────────────────
    local function elapsed(name)
        local a = actionAnims[name]
        if not a or not actionStart[a] then return math.huge end
        return os.clock() - actionStart[a]
    end
    local function duration(name)
        local a = actionAnims[name]
        if not a or not a.track then return 0 end
        return a.track.Time or 0
    end
    local function animDone(name)
        return elapsed(name) >= duration(name) / ((actionAnims[name] and actionAnims[name].speed) or 1)
    end

    -- ── CRYSTAL PITCH STATE MACHINE ───────────────────────────
    if crystalPhase == "charging" then
        setSpeed(SPEED_SLOW)
        -- Charge finished while still holding -> auto-chain to throw
        if animDone("throwCharge") and crystalChargeHeld then
            startThrow()
        end

    elseif crystalPhase == "throwing" then
        setSpeed(SPEED_SLOW)
        if animDone("throw") then
            local t = actionAnims["throw"]
            if t then t.weight = 0 end
            currentAction = nil
            crystalPhase  = "none"
            setSpeed(isSprinting and SPEED_SPRINT or SPEED_WALK)
        end

    -- ── GENERIC ONE-SHOT AUTO-STOP (hatchet etc.) ─────────────
    elseif currentAction then
        local a = actionAnims[currentAction]
        if a and actionStart[a] then
            local dur = duration(currentAction)
            if dur > 0 and (os.clock() - actionStart[a]) >= dur then
                a.weight      = 0
                currentAction = nil
            end
        end
    end

    -- ── BASE LOCOMOTION ───────────────────────────────────────
    if inAir then
        -- keep last base during air
    elseif moving then
        if isSprinting and crystalPhase == "none" then
            setBase("run")
        else
            setBase("walk")
        end
    else
        setBase("idle")
    end

    -- ── STEP ALL ANIMS ────────────────────────────────────────
    local now = os.clock()

    for _, a in pairs(baseAnims) do
        if a.weight > 0 then a:Step(now) end
    end

    for a, start in pairs(actionStart) do
        if a.weight > 0 then a:Step(now - start) end
    end
end

-- ── DESTROY ───────────────────────────────────────────────────
m.Destroy = function()
    ContextActions:UnbindAction("GM_Sprint")
    ContextActions:UnbindAction("GM_CrystalPitch")
    ContextActions:UnbindAction("GM_Hatchet")

    for _, joint in ipairs(allJoints) do
        if joint and joint.Parent then
            joint.Transform = CFrame.identity
        end
    end
    allJoints = {}

    for _, a in pairs(baseAnims)   do a.weight = 0 end
    for _, a in pairs(actionAnims) do a.weight = 0 end

    setSpeed(16)

    actionStart       = {}
    currentAction     = nil
    currentBase       = "idle"
    isSprinting       = false
    figureRef         = nil
    baseAnims         = {}
    actionAnims       = {}
    crystalPhase      = "none"
    crystalChargeHeld = false
end

return m
end)

return modules
