-- golden chance.lua

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType   = "MOVESET"
m.Name         = "Golden Chance"
m.Description  = "feeling lucky? (golden edition)"
m.InternalName = "golden_chance"

m.Mode = 0

m.Assets = {
    -- BASE (shared from chance)
    "chance idle.anim",
    "chance walk.anim",
    "chance run.anim",

    -- DEFAULT ACTIONS
    "chance coin flip.anim",
    "chance point.anim",
    "chance shoot.anim",
    "chance hatfix.anim",

    -- GOLDEN CHANCE SKIN ACTIONS
    "golden chance coin flip.anim",
    "golden chance point.anim",
    "golden chance shoot.anim",
    "golden chance hatfix.anim",
}

-- ─── profiles ─────────────────────────────────────────────────────────────────
local PROFILES = {
    [0] = {
        idle     = "chance idle.anim",
        walk     = "chance walk.anim",
        run      = "chance run.anim",
        coinflip = "chance coin flip.anim",
        point    = "chance point.anim",
        shoot    = "chance shoot.anim",
        hatfix   = "chance hatfix.anim",
    },
    [1] = {
        idle     = "chance idle.anim",
        walk     = "chance walk.anim",
        run      = "chance run.anim",
        coinflip = "golden chance coin flip.anim",
        point    = "golden chance point.anim",
        shoot    = "golden chance shoot.anim",
        hatfix   = "golden chance hatfix.anim",
    },
}

m.Config = function(parent)
    Util_CreateText(parent, "Golden Chance", 18, Enum.TextXAlignment.Center)
    Util_CreateSeparator(parent)
    Util_CreateDropdown(parent, "Skin", {"Chance", "Golden Chance"}, m.Mode + 1).Changed:Connect(function(val)
        m.Mode = val - 1
    end)
    Util_CreateSeparator(parent)
end

m.SaveConfig = function()
    return { Mode = m.Mode }
end
m.LoadConfig = function(save)
    if save and save.Mode then
        m.Mode = save.Mode
    end
end

-- SERVICES
local Players = game:GetService("Players")

-- ANIMATORS
local baseAnimator   = nil
local actionAnimator = nil

-- ANIMS
local baseAnims   = {}
local actionAnims = {}

-- SPEEDS
local SPEED_WALK   = 16
local SPEED_SPRINT = 26

-- STATE
local currentBase   = "idle"
local actionStart   = {}
local currentAction = nil
local isSprinting   = false
local wasInAir      = false

-- shoot sequence: after "point" finishes, auto-play "shoot"
local shootPhase = nil   -- nil | "point" | "shoot"

-- Joint references for cleanup
local figureRef = nil
local allJoints = {}

-- ── helpers ──────────────────────────────────────────────────────────────────
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
    for _, anim in pairs(actionAnims) do anim.weight = 0 end
    currentAction = nil
    shootPhase    = nil
end

local function playAction(name)
    if currentAction then return end
    local a = actionAnims[name]
    if not a then return end

    stopAction()

    a.weight       = 1
    actionStart[a] = os.clock()
    currentAction  = name

    -- track shoot sequence phase
    if name == "shoot_point" then
        shootPhase = "point"
    else
        shootPhase = nil
    end
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

-- BUTTON POSITION HELPER
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

-- INIT
m.Init = function(figure)
    figureRef = figure

    baseAnimator       = AnimLib.Animator.new()
    baseAnimator.rig   = figure
    actionAnimator     = AnimLib.Animator.new()
    actionAnimator.rig = figure

    -- Collect all Motor6D joints for cleanup
    allJoints = {}
    for _, v in ipairs(figure:GetDescendants()) do
        if v:IsA("Motor6D") then
            table.insert(allJoints, v)
        end
    end

    local p = PROFILES[m.Mode] or PROFILES[0]

    -- BASE ANIMS
    baseAnims = {
        idle   = loadAnim(figure, p.idle,  true),
        walk   = loadAnim(figure, p.walk,  true),
        sprint = loadAnim(figure, p.run,   true),
    }

    -- ACTION ANIMS
    actionAnims = {
        ["coinflip"]    = loadAnim(figure, p.coinflip, false),
        ["shoot_point"] = loadAnim(figure, p.point,    false),
        ["shoot_shoot"] = loadAnim(figure, p.shoot,    false),
        ["hatfix"]      = loadAnim(figure, p.hatfix,   false),
    }

    setSpeed(SPEED_WALK)
    setBase("idle")

    -- ── BUTTONS ───────────────────────────────────────────────────────────────
    ContextActions:BindAction("GM_coinflip", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playAction("coinflip") end
    end, true, Enum.KeyCode.Z)
    ContextActions:SetTitle("GM_coinflip", "coinflip")
    ContextActions:SetPosition("GM_coinflip", btnPos(17.5, 21))

    ContextActions:BindAction("GM_shoot", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playAction("shoot_point") end
    end, true, Enum.KeyCode.X)
    ContextActions:SetTitle("GM_shoot", "shoot")
    ContextActions:SetPosition("GM_shoot", btnPos(14, 21))

    ContextActions:BindAction("GM_hatfix", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playAction("hatfix") end
    end, true, Enum.KeyCode.C)
    ContextActions:SetTitle("GM_hatfix", "hatfix")
    ContextActions:SetPosition("GM_hatfix", btnPos(10.5, 21))

    ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then toggleSprint() end
    end, true, Enum.KeyCode.LeftAlt)
    ContextActions:SetTitle("GM_Sprint", "Sprint")
    ContextActions:SetPosition("GM_Sprint", btnPos(3.5, 17))
end

-- UPDATE
m.Update = function(dt, figure)
    local hum = figure:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local inAir = hum.FloorMaterial == Enum.Material.Air

    -- AUTO-STOP / SEQUENCE current action
    if currentAction then
        local a = actionAnims[currentAction]
        if a and actionStart[a] then
            local elapsed  = os.clock() - actionStart[a]
            local duration = a.track and a.track.Time or 0
            if duration > 0 and elapsed >= duration / (a.speed or 1) then
                a.weight = 0

                -- shoot sequence: point → shoot
                if shootPhase == "point" then
                    shootPhase    = "shoot"
                    currentAction = nil
                    local shootAnim = actionAnims["shoot_shoot"]
                    if shootAnim then
                        shootAnim.weight       = 1
                        actionStart[shootAnim] = os.clock()
                        currentAction          = "shoot_shoot"
                    end
                else
                    currentAction = nil
                    shootPhase    = nil
                    currentBase   = "none"
                end
            end
        end
    end

    -- BASE STATE
    if not currentAction then
        if inAir then
            if not wasInAir then
                clearBase()
                currentBase = "idle"
                if baseAnims["idle"] then baseAnims["idle"].weight = 1 end
            end
        else
            if wasInAir then
                clearBase()
                currentBase = "none"
            end
            local moving = hum.MoveDirection.Magnitude > 0.1
            if moving then
                if isSprinting then setBase("sprint") else setBase("walk") end
            else
                setBase("idle")
            end
        end
    end

    wasInAir = inAir

    -- STEP ALL ANIMS
    local now = os.clock()

    for _, a in pairs(baseAnims) do
        if a.weight > 0 then a:Step(now) end
    end

    for a, start in pairs(actionStart) do
        if a.weight > 0 then a:Step(now - start) end
    end
end

-- CLEANUP
m.Destroy = function()
    ContextActions:UnbindAction("GM_Sprint")
    ContextActions:UnbindAction("GM_coinflip")
    ContextActions:UnbindAction("GM_shoot")
    ContextActions:UnbindAction("GM_hatfix")

    -- Reset all Motor6D transforms
    for _, joint in ipairs(allJoints) do
        if joint and joint.Parent then
            joint.Transform = CFrame.identity
        end
    end
    allJoints = {}

    -- Zero out all anim weights
    for _, a in pairs(baseAnims) do a.weight = 0 end
    for _, a in pairs(actionAnims) do a.weight = 0 end

    setSpeed(16)

    baseAnimator   = nil
    actionAnimator = nil
    actionStart    = {}
    currentAction  = nil
    currentBase    = "idle"
    isSprinting    = false
    wasInAir       = false
    shootPhase     = nil
    figureRef      = nil
    baseAnims      = {}
    actionAnims    = {}
end

return m
end)

return modules
