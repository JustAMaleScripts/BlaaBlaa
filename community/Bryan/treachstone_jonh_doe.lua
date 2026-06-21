-- treachstone_jonh_doe.lua

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType   = "MOVESET"
m.Name         = "Treachstone John Doe"
m.Description  = "treachstone john doe moveset"
m.InternalName = "treachstone_jonh_doe"

m.Assets = {
    -- BASE
    "Treachdoe Idle.anim",
    "Treachdoe Walk.anim",
    "Treachdoe Run.anim",

    -- ATTACKS
    "Treachdoe M1_2.anim",
    "Treachdoe CorruptEnergy.anim",
    "Treachdoe DigitalFootprint.anim",
    "Treachdoe KillKiller.anim",

    -- BACKGROUND SOUND
    "treachdoe.mp3",
}

-- Which attacks are allowed to fling (true = flings, false = no fling)
m.FlingEnabled = {
    ["m1"]              = true,
    ["corruptenergy"]   = false,
    ["digitalfootprint"]= false,
    ["killkiller"]      = false,
}

m.Config = function(parent)
    Util_CreateText(parent, "Treachstone John Doe", 18, Enum.TextXAlignment.Center)
    Util_CreateSeparator(parent)
    Util_CreateText(parent, "Fling on Hit", 15, Enum.TextXAlignment.Center)
    Util_CreateSwitch(parent, "m1 flings",               m.FlingEnabled["m1"]).Changed:Connect(function(v)               m.FlingEnabled["m1"]               = v end)
    Util_CreateSwitch(parent, "corrupt energy flings",   m.FlingEnabled["corruptenergy"]).Changed:Connect(function(v)    m.FlingEnabled["corruptenergy"]    = v end)
    Util_CreateSwitch(parent, "digital footprint flings",m.FlingEnabled["digitalfootprint"]).Changed:Connect(function(v) m.FlingEnabled["digitalfootprint"] = v end)
    Util_CreateSwitch(parent, "kill flings",             m.FlingEnabled["killkiller"]).Changed:Connect(function(v)       m.FlingEnabled["killkiller"]       = v end)
end

m.SaveConfig = function()
    return { FlingEnabled = m.FlingEnabled }
end
m.LoadConfig = function(save)
    if type(save.FlingEnabled) == "table" then
        for k, v in pairs(save.FlingEnabled) do
            if m.FlingEnabled[k] ~= nil then
                m.FlingEnabled[k] = v
            end
        end
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
local animJump    = nil

-- SOUNDS
local bgSound = nil

-- SPEEDS
local SPEED_WALK   = 16
local SPEED_SPRINT = 26

-- STATE
local currentBase    = "idle"
local actionStart    = {}
local currentAction  = nil
local isSprinting    = false
local wasInAir       = false

-- Flag: certain actions lock movement until they finish
local actionLocksMovement = {
    ["corruptenergy"]    = true,
    ["digitalfootprint"] = true,
    ["killkiller"]       = true,
    ["m1"]               = false,
}

-- FLING STATE
local flingActive = false
local touchConns  = {}

-- Joint references for cleanup
local figureRef = nil
local allJoints = {}

-- ── sound helper ─────────────────────────────────────────────
local function makeSound(filename, parent, volume, looped)
    local s = Instance.new("Sound")
    s.SoundId = AssetGetContentId(filename)
    s.Volume  = volume or 0.8
    s.Looped  = looped or false
    s.Parent  = parent
    return s
end

-- LOAD ANIM
local function loadAnim(fig, file, looped)
    local a = AnimLib.Animator.new()
    a.rig    = fig
    a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
    a.looped = looped or false
    a.speed  = 1
    a.weight = 0
    return a
end

-- SET SPEED
local function setSpeed(speed)
    if not figureRef then return end
    local hum = figureRef:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = speed end
end

-- CLEAR BASE ANIMS
local function clearBase()
    for _, a in pairs(baseAnims) do a.weight = 0 end
end

-- BASE SWITCH
local function setBase(state)
    if currentBase == state then return end
    currentBase = state
    clearBase()
    if baseAnims[state] then baseAnims[state].weight = 1 end
end

-- STOP ACTION
local function stopAction()
    for _, anim in pairs(actionAnims) do anim.weight = 0 end
    currentAction = nil
    flingActive   = false
    -- restore walk speed when a movement-locking action ends
    setSpeed(isSprinting and SPEED_SPRINT or SPEED_WALK)
end

-- PLAY ACTION (locked while another plays)
local function playAction(name)
    if currentAction then return end
    local a = actionAnims[name]
    if not a then return end

    stopAction()

    a.weight       = 1
    actionStart[a] = os.clock()
    currentAction  = name
    flingActive    = m.FlingEnabled[name] == true

    -- Freeze character for movement-locking actions
    if actionLocksMovement[name] then
        setSpeed(0)
    end
end

-- TOGGLE SPRINT
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

-- SETUP FLING TOUCH CONNECTIONS
local function setupFlingTouched(figure)
    for _, part in ipairs(figure:GetDescendants()) do
        if part:IsA("BasePart") then
            local conn = part.Touched:Connect(function(hit)
                if not flingActive then return end
                if not hit or not hit.Parent then return end
                local target = hit.Parent
                if target:IsA("Accessory") then target = target.Parent end
                if target == figure then return end
                if not target:FindFirstChildOfClass("Humanoid") then return end
                ReanimateFling(target)
            end)
            table.insert(touchConns, conn)
        end
    end

    local descConn = figure.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            local conn = part.Touched:Connect(function(hit)
                if not flingActive then return end
                if not hit or not hit.Parent then return end
                local target = hit.Parent
                if target:IsA("Accessory") then target = target.Parent end
                if target == figure then return end
                if not target:FindFirstChildOfClass("Humanoid") then return end
                ReanimateFling(target)
            end)
            table.insert(touchConns, conn)
        end
    end)
    table.insert(touchConns, descConn)
end

-- INIT
m.Init = function(figure)
    figureRef = figure

    baseAnimator       = AnimLib.Animator.new()
    baseAnimator.rig   = figure
    actionAnimator     = AnimLib.Animator.new()
    actionAnimator.rig = figure

    local hrp = figure:FindFirstChild("HumanoidRootPart") or figure

    -- Collect all Motor6D joints so we can reset them on Destroy
    allJoints = {}
    for _, v in ipairs(figure:GetDescendants()) do
        if v:IsA("Motor6D") then
            table.insert(allJoints, v)
        end
    end

    -- BASE ANIMS
    -- Sprint uses "Treachdoe Run.anim", walk uses "Treachdoe Walk.anim"
    baseAnims = {
        idle   = loadAnim(figure, "Treachdoe Idle.anim", true),
        walk   = loadAnim(figure, "Treachdoe Walk.anim", true),
        sprint = loadAnim(figure, "Treachdoe Run.anim",  true),
    }

    -- ACTION ANIMS
    -- corruptenergy, digitalfootprint and killkiller lock movement (looped=false, one-shot)
    actionAnims = {
        ["m1"]               = loadAnim(figure, "Treachdoe M1_2.anim",              false),
        ["corruptenergy"]    = loadAnim(figure, "Treachdoe CorruptEnergy.anim",     false),
        ["digitalfootprint"] = loadAnim(figure, "Treachdoe DigitalFootprint.anim",  false),
        ["killkiller"]       = loadAnim(figure, "Treachdoe KillKiller.anim",        false),
    }

    -- BACKGROUND SOUND (loops like pursuer.mp3)
    bgSound = makeSound("treachdoe.mp3", hrp, 0.5, true)
    bgSound:Play()

    setSpeed(SPEED_WALK)
    setBase("idle")

    -- FLING TOUCH SETUP
    setupFlingTouched(figure)

    -- ── BUTTONS ──────────────────────────────────────────────
    -- Layout mirrors pursuer.lua button grid positions exactly.
    --
    --   Row 1 (top row):   [M1]  [Corrupt Energy]  [Digital Footprint]  [Sprint]
    --   Row 0 (bot row):                            [Kill]
    --

    -- M1 attack
    ContextActions:BindAction("GM_m1", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playAction("m1") end
    end, true, Enum.KeyCode.Z)
    ContextActions:SetTitle("GM_m1", "m1")
    ContextActions:SetPosition("GM_m1", btnPos(17.5, 21))

    -- Corrupt Energy (locks movement until anim ends)
    ContextActions:BindAction("GM_corruptenergy", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playAction("corruptenergy") end
    end, true, Enum.KeyCode.X)
    ContextActions:SetTitle("GM_corruptenergy", "corrupt energy")
    ContextActions:SetPosition("GM_corruptenergy", btnPos(14, 21))

    -- Digital Footprint (locks movement until anim ends)
    ContextActions:BindAction("GM_digitalfootprint", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playAction("digitalfootprint") end
    end, true, Enum.KeyCode.C)
    ContextActions:SetTitle("GM_digitalfootprint", "digital footsprint")
    ContextActions:SetPosition("GM_digitalfootprint", btnPos(10.5, 21))

    -- Sprint toggle
    ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then toggleSprint() end
    end, true, Enum.KeyCode.LeftAlt)
    ContextActions:SetTitle("GM_Sprint", "Sprint")
    ContextActions:SetPosition("GM_Sprint", btnPos(3.5, 17))

    -- Kill (locks movement until anim ends)
    ContextActions:BindAction("GM_killkiller", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playAction("killkiller") end
    end, true, Enum.KeyCode.V)
    ContextActions:SetTitle("GM_killkiller", "kill")
    ContextActions:SetPosition("GM_killkiller", btnPos(7, 21))

end

-- UPDATE
m.Update = function(dt, figure)

    local hum = figure:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local inAir = hum.FloorMaterial == Enum.Material.Air

    -- AUTO-STOP current action when its animation finishes
    if currentAction then
        local a = actionAnims[currentAction]
        if a and actionStart[a] then
            local elapsed  = os.clock() - actionStart[a]
            local duration = a.track and a.track.Time or 0
            if duration > 0 and elapsed >= duration / (a.speed or 1) then
                a.weight      = 0
                currentAction = nil
                flingActive   = false
                currentBase   = "none"
                -- Restore speed after movement-locking actions finish
                setSpeed(isSprinting and SPEED_SPRINT or SPEED_WALK)
            end
        end
    end

    -- BASE STATE (only runs when no action is active)
    if not currentAction then
        if inAir then
            if not wasInAir then
                clearBase()
                currentBase = "idle"
                if baseAnims["idle"] then baseAnims["idle"].weight = 1 end
            end
        else
            if wasInAir then clearBase() end
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
    -- Unbind all buttons
    ContextActions:UnbindAction("GM_Sprint")
    ContextActions:UnbindAction("GM_m1")
    ContextActions:UnbindAction("GM_corruptenergy")
    ContextActions:UnbindAction("GM_digitalfootprint")
    ContextActions:UnbindAction("GM_killkiller")

    -- Disconnect fling touch events
    for _, conn in ipairs(touchConns) do conn:Disconnect() end
    table.clear(touchConns)

    -- Stop and destroy background sound
    if bgSound then bgSound:Stop() bgSound:Destroy() bgSound = nil end

    -- Reset all Motor6D transforms so the next moveset's animations aren't stuck
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
    flingActive    = false
    figureRef      = nil
    animJump       = nil
    baseAnims      = {}
    actionAnims    = {}
end

return m
end)

return modules
