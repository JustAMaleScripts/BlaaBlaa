-- Narrator Noli.lua

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType   = "MOVESET"
m.Name         = "Narrator Noli"
m.Description  = "The Narrator steps into the world."
m.InternalName = "narrator_noli"

m.Assets = {
    -- BASE
    "Narrator Idle.anim",
    "Narrator Walk.anim",
    "Narrator Run.anim",

    -- VOID RUSH (ab1) — first dash chain
    "ab1firstdashstartup.anim",
    "ab1firstdashloop.anim",
    "ab1firstdashsuccesfulhit.anim",

    -- VOID RUSH (ab1) — second dash chain
    "ab1seconddashstartup.anim",
    "ab1seconddashloop.anim",
    "ab1succesfulhit.anim",

    -- NOVA (ab2) — cast & recast
    "Nova.anim",
    "nova - recast .anim",

    -- OBSERVANT (ab3)
    "observant activation.anim",
    "observantstartup.anim",
    "teleport.anim",

    -- M1
    "Narrator M1.anim",

    -- KILL
    "Narrator Noli Kill.anim",

    -- BACKGROUND SOUND
    "Narrator Noli Chase.mp3",
}

-- Which actions are allowed to play the Kill animation
m.KillEnabled = {
    ["kill"] = true,
}

-- ── SERVICES ──────────────────────────────────────────────────
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

-- ── ANIMATORS ─────────────────────────────────────────────────
local baseAnimator   = nil
local actionAnimator = nil

-- ── ANIM TABLES ───────────────────────────────────────────────
local baseAnims   = {}
local actionAnims = {}

-- ── STATE ─────────────────────────────────────────────────────
local currentBase   = "idle"
local actionStart   = {}
local currentAction = nil
local figureRef     = nil
local allJoints     = {}

-- ── VOID RUSH STATE ───────────────────────────────────────────
local voidRushPhase = nil
local voidRushHeld  = false

-- ── COLLISION SYSTEM (only active during Void Rush) ───────────
-- Ported from ForsakenMovesetC00lkidd.lua
local HIT_RADIUS   = 3      -- radius to detect survivors
local RAYCAST_DIST = 2.5    -- distance for wall raycast

-- Returns the nearest survivor character within HIT_RADIUS, or nil
local function getNearestSurvivor(character)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest = nil
    local minDist = HIT_RADIUS
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character ~= character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (root.Position - targetRoot.Position).Magnitude
                if dist < minDist then
                    minDist  = dist
                    nearest  = player.Character
                end
            end
        end
    end
    return nearest
end

-- Returns true if there is a wall in the given direction
local function checkWall(hrp, direction)
    if not hrp then return false end
    local origin = hrp.Position + Vector3.new(0, 1.5, 0)
    local raycastParams = RaycastParams.new()
    local ignoreList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            table.insert(ignoreList, player.Character)
        end
    end
    -- Also ignore possible reanimate/fake character globals
    if _G.Uhhhhhh and _G.Uhhhhhh.Character then
        table.insert(ignoreList, _G.Uhhhhhh.Character)
    end
    raycastParams.FilterDescendantsInstances = ignoreList
    local result = workspace:Raycast(origin, direction * RAYCAST_DIST, raycastParams)
    return result ~= nil
end

-- ── DASH MOVEMENT ─────────────────────────────────────────────
local DASH_FORCE     = 120
local dashMoveActive = false
local dashMoveConn   = nil
local dashDirection  = nil  -- stored so wall/hit detection can use it

local function stopDashMove()
    dashMoveActive = false
    if dashMoveConn then
        dashMoveConn:Disconnect()
        dashMoveConn = nil
    end
    dashDirection = nil
    if figureRef then
        local hrp = figureRef:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
        end
    end
end

local function startDashMove()
    stopDashMove()
    dashMoveActive = true

    -- Capture dash direction at the moment movement starts
    if figureRef then
        local hrp = figureRef:FindFirstChild("HumanoidRootPart")
        if hrp then
            dashDirection = hrp.CFrame.LookVector
        end
    end

    dashMoveConn = RunService.Heartbeat:Connect(function()
        if not dashMoveActive or not figureRef then
            stopDashMove()
            return
        end
        local hrp = figureRef:FindFirstChild("HumanoidRootPart")
        if hrp then
            local forward = hrp.CFrame.LookVector
            hrp.AssemblyLinearVelocity = Vector3.new(
                forward.X * DASH_FORCE,
                hrp.AssemblyLinearVelocity.Y,
                forward.Z * DASH_FORCE
            )
        end
    end)
end

-- ── SPEED / FREEZE HELPERS ────────────────────────────────────
local SPEED_WALK   = 16
local SPEED_SPRINT = 26
local isSprinting  = false
local wasInAir     = false

local function setSpeed(speed)
    if not figureRef then return end
    local hum = figureRef:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = speed end
end

-- Freezes the character (WalkSpeed = 0) during an ability
local function freezeCharacter()
    if not figureRef then return end
    local hum = figureRef:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 0 end
end

-- Restores the character's speed after an ability ends
local function unfreezeCharacter()
    setSpeed(isSprinting and SPEED_SPRINT or SPEED_WALK)
end

-- ── SOUND HELPER ──────────────────────────────────────────────
local bgSound = nil

local function makeSound(filename, parent, volume, looped)
    local s = Instance.new("Sound")
    s.SoundId = AssetGetContentId(filename)
    s.Volume  = volume or 0.8
    s.Looped  = looped or false
    s.Parent  = parent
    return s
end

-- ── BUTTON POSITION HELPER ────────────────────────────────────
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

-- ── ANIM HELPERS ──────────────────────────────────────────────
local function loadAnim(fig, file, looped)
    local a = AnimLib.Animator.new()
    a.rig    = fig
    a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
    a.looped = looped or false
    a.speed  = 1
    a.weight = 0
    return a
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
end

local function _playRaw(name, loopOverride)
    local a = actionAnims[name]
    if not a then return end
    stopAction()
    if loopOverride ~= nil then a.looped = loopOverride end
    a.weight       = 1
    actionStart[a] = os.clock()
    currentAction  = name
end

local function playAction(name)
    if currentAction then return end
    _playRaw(name, false)
end

-- ── NOVA STATE ────────────────────────────────────────────────
local novaCastToggle = false

-- ── OBSERVANT STATE ───────────────────────────────────────────
local observantPhase     = nil
local observantTouchConn = nil

-- ── VOID RUSH — collision-aware hit handling ──────────────────

-- Called when the first dash successfully hits a survivor
local function triggerFirstDashHit()
    stopDashMove()
    voidRushPhase = "first_hit"
    _playRaw("ab1firstdashsuccesfulhit", false)
    -- Character stays frozen; unfreeze happens when the anim finishes
end

-- Called when the second dash successfully hits a survivor
local function triggerSecondDashHit()
    stopDashMove()
    voidRushPhase = "second_hit"
    _playRaw("ab1succesfulhit", false)
    -- Character stays frozen; unfreeze happens when the anim finishes
end

-- ── VOID RUSH (Hold-to-Charge) ────────────────────────────────

local function onVoidRushPress()
    -- Second dash window: Z pressed again after first hit landed
    if voidRushPhase == "wait_second" then
        voidRushHeld  = true
        voidRushPhase = "second_startup"
        freezeCharacter()
        _playRaw("ab1seconddashstartup", false)
        startDashMove()
        return
    end

    -- Block if anything else is running
    if currentAction or (voidRushPhase ~= nil) or observantPhase then return end

    -- Start first charge
    voidRushHeld  = true
    voidRushPhase = "first_startup"
    freezeCharacter()
    _playRaw("ab1firstdashstartup", false)
    startDashMove()
end

local function onVoidRushRelease()
    voidRushHeld = false

    if voidRushPhase == "first_startup" then
        -- Released before startup finished → cancel
        voidRushPhase = nil
        stopDashMove()
        stopAction()
        unfreezeCharacter()
        currentBase = "none"

    elseif voidRushPhase == "first_loop" then
        -- Released while looping → fire hit animation
        -- Collision check in Update may have already triggered this,
        -- but if the player releases manually before a hit we still fire.
        triggerFirstDashHit()

    elseif voidRushPhase == "second_startup" then
        -- Released before second startup finished → cancel
        voidRushPhase = nil
        stopDashMove()
        stopAction()
        unfreezeCharacter()
        currentBase = "none"

    elseif voidRushPhase == "second_loop" then
        -- Released while looping → fire hit animation
        triggerSecondDashHit()
    end
end

-- ── NOVA ──────────────────────────────────────────────────────
local function pressNova()
    if currentAction or voidRushPhase or observantPhase then return end
    freezeCharacter()
    if not novaCastToggle then
        novaCastToggle = true
        _playRaw("Nova", false)
    else
        novaCastToggle = false
        _playRaw("nova - recast ", false)
    end
end

-- ── OBSERVANT ─────────────────────────────────────────────────
local function cleanObservantTouchConn()
    if observantTouchConn then
        observantTouchConn:Disconnect()
        observantTouchConn = nil
    end
end

local function armTeleportTap()
    cleanObservantTouchConn()
    observantTouchConn = UserInputService.TouchTapInWorld:Connect(function()
        if observantPhase ~= "startup_wait" then return end
        cleanObservantTouchConn()
        observantPhase = "teleport"
        _playRaw("teleport", false)
    end)
end

local function startObservant()
    if currentAction or voidRushPhase or observantPhase then return end
    freezeCharacter()
    observantPhase = "activation"
    _playRaw("observant activation", false)
end

local function advanceObservant()
    if observantPhase == "activation" then
        observantPhase = "startup"
        _playRaw("observantstartup", false)
    elseif observantPhase == "startup" then
        observantPhase = "startup_wait"
        armTeleportTap()
        actionStart[actionAnims["observantstartup"]] = os.clock()
    elseif observantPhase == "teleport" then
        observantPhase = nil
        cleanObservantTouchConn()
        stopAction()
        unfreezeCharacter()
        currentBase = "none"
    end
end

-- ── SPRINT TOGGLE ─────────────────────────────────────────────
local function toggleSprint()
    isSprinting = not isSprinting
    if isSprinting then
        setSpeed(SPEED_SPRINT)
        ContextActions:SetTitle("GM_Sprint", "Walk")
    else
        setSpeed(SPEED_WALK)
        ContextActions:SetTitle("GM_Sprint", "Sprint")
    end
    if not currentAction then
        currentBase = "none"
    end
end

-- ── CONFIG / SAVE / LOAD ──────────────────────────────────────
m.Config = function(parent)
    Util_CreateText(parent, "Narrator Noli", 18, Enum.TextXAlignment.Center)
    Util_CreateSeparator(parent)
    Util_CreateText(parent, "Kill Animation", 15, Enum.TextXAlignment.Center)
    Util_CreateSwitch(parent, "kill plays", m.KillEnabled["kill"]).Changed:Connect(function(v) m.KillEnabled["kill"] = v end)
end

m.SaveConfig = function()
    return { KillEnabled = m.KillEnabled }
end
m.LoadConfig = function(save)
    if type(save.KillEnabled) == "table" then
        for k, v in pairs(save.KillEnabled) do
            if m.KillEnabled[k] ~= nil then
                m.KillEnabled[k] = v
            end
        end
    end
end

-- ── KILL ──────────────────────────────────────────────────────
local function playKill()
    if not m.KillEnabled["kill"] then return end
    if currentAction or voidRushPhase or observantPhase then return end
    freezeCharacter()
    _playRaw("kill", false)
end

-- ── INIT ──────────────────────────────────────────────────────
m.Init = function(figure)
    figureRef = figure

    baseAnimator       = AnimLib.Animator.new()
    baseAnimator.rig   = figure
    actionAnimator     = AnimLib.Animator.new()
    actionAnimator.rig = figure

    allJoints = {}
    for _, v in ipairs(figure:GetDescendants()) do
        if v:IsA("Motor6D") then
            table.insert(allJoints, v)
        end
    end

    -- BASE ANIMS (looped)
    baseAnims = {
        idle   = loadAnim(figure, "Narrator Idle.anim", true),
        walk   = loadAnim(figure, "Narrator Walk.anim", true),
        sprint = loadAnim(figure, "Narrator Run.anim",  true),
    }

    -- ACTION ANIMS
    actionAnims = {
        ["ab1firstdashstartup"]      = loadAnim(figure, "ab1firstdashstartup.anim",      false),
        ["ab1firstdashloop"]         = loadAnim(figure, "ab1firstdashloop.anim",          true),
        ["ab1firstdashsuccesfulhit"] = loadAnim(figure, "ab1firstdashsuccesfulhit.anim",  false),
        ["ab1seconddashstartup"]     = loadAnim(figure, "ab1seconddashstartup.anim",      false),
        ["ab1seconddashloop"]        = loadAnim(figure, "ab1seconddashloop.anim",          true),
        ["ab1succesfulhit"]          = loadAnim(figure, "ab1succesfulhit.anim",            false),
        ["Nova"]                     = loadAnim(figure, "Nova.anim",                       false),
        ["nova - recast "]           = loadAnim(figure, "nova - recast .anim",             false),
        ["observant activation"]     = loadAnim(figure, "observant activation.anim",       false),
        ["observantstartup"]         = loadAnim(figure, "observantstartup.anim",           false),
        ["teleport"]                 = loadAnim(figure, "teleport.anim",                   false),
        ["M1"]                       = loadAnim(figure, "Narrator M1.anim",                false),
        ["kill"]                     = loadAnim(figure, "Narrator Noli Kill.anim",          false),
    }

    setSpeed(SPEED_WALK)
    setBase("idle")

    local hrp = figure:FindFirstChild("HumanoidRootPart") or figure
    bgSound = makeSound("Narrator Noli Chase.mp3", hrp, 0.5, true)
    bgSound:Play()

    -- ── BUTTONS ─────────────────────────────────────────────────

    ContextActions:BindAction("GM_VoidRush", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            onVoidRushPress()
        elseif inputState == Enum.UserInputState.End then
            onVoidRushRelease()
        end
    end, true, Enum.KeyCode.Z)
    ContextActions:SetTitle("GM_VoidRush", "Void Rush")
    ContextActions:SetPosition("GM_VoidRush", btnPos(17.5, 21))

    ContextActions:BindAction("GM_Nova", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then pressNova() end
    end, true, Enum.KeyCode.X)
    ContextActions:SetTitle("GM_Nova", "Nova")
    ContextActions:SetPosition("GM_Nova", btnPos(14, 21))

    ContextActions:BindAction("GM_Observant", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then startObservant() end
    end, true, Enum.KeyCode.C)
    ContextActions:SetTitle("GM_Observant", "Observant")
    ContextActions:SetPosition("GM_Observant", btnPos(10.5, 21))

    ContextActions:BindAction("GM_M1", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            if currentAction or voidRushPhase or observantPhase then return end
            freezeCharacter()
            playAction("M1")
        end
    end, true, Enum.KeyCode.V)
    ContextActions:SetTitle("GM_M1", "M1")
    ContextActions:SetPosition("GM_M1", btnPos(7, 21))

    ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then toggleSprint() end
    end, true, Enum.KeyCode.LeftAlt)
    ContextActions:SetTitle("GM_Sprint", "Sprint")
    ContextActions:SetPosition("GM_Sprint", btnPos(3.5, 17))

    ContextActions:BindAction("GM_Kill", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playKill() end
    end, true, Enum.KeyCode.N)
    ContextActions:SetTitle("GM_Kill", "Kill")
    ContextActions:SetPosition("GM_Kill", btnPos(3.5, 21))
end

-- ── UPDATE ────────────────────────────────────────────────────
m.Update = function(dt, figure)
    local hum = figure:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local inAir = hum.FloorMaterial == Enum.Material.Air

    -- ── VOID RUSH COLLISION CHECK (active during loop phases) ──
    -- Only runs when the dash movement is active (first_loop or second_loop).
    -- Mirrors the Forsaken lunge collision: survivor proximity → hit anim,
    -- wall raycast → stop dash (treated as a miss/wall stop).
    if dashMoveActive and figureRef then
        local hrp = figureRef:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Survivor hit detection
            local survivor = getNearestSurvivor(figure)
            if survivor then
                if voidRushPhase == "first_loop" then
                    triggerFirstDashHit()
                elseif voidRushPhase == "second_loop" then
                    triggerSecondDashHit()
                end
            end

            -- Wall detection (stop dash on collision)
            if dashMoveActive and dashDirection then
                if checkWall(hrp, dashDirection) then
                    stopDashMove()
                    -- Cancel whichever loop we're in without a successful hit
                    if voidRushPhase == "first_loop" then
                        voidRushPhase = "wait_second"
                        stopAction()
                        unfreezeCharacter()
                        currentBase = "none"
                    elseif voidRushPhase == "second_loop" then
                        voidRushPhase = nil
                        stopAction()
                        unfreezeCharacter()
                        currentBase = "none"
                    end
                end
            end
        end
    end

    -- ── AUTO-ADVANCE (only for non-looped anims) ──────────────
    if currentAction then
        local a = actionAnims[currentAction]
        if a and actionStart[a] and not a.looped then
            local elapsed  = os.clock() - actionStart[a]
            local duration = a.track and a.track.Time or 0

            if duration > 0 and elapsed >= duration / (a.speed or 1) then

                if voidRushPhase == "first_startup" then
                    if voidRushHeld then
                        voidRushPhase = "first_loop"
                        _playRaw("ab1firstdashloop", true)
                        startDashMove()
                    else
                        voidRushPhase = nil
                        stopDashMove()
                        stopAction()
                        unfreezeCharacter()
                        currentBase = "none"
                    end

                elseif voidRushPhase == "first_hit" then
                    -- First dash done → open second dash window
                    voidRushPhase = "wait_second"
                    stopAction()
                    unfreezeCharacter()
                    currentBase = "none"

                elseif voidRushPhase == "second_startup" then
                    if voidRushHeld then
                        voidRushPhase = "second_loop"
                        _playRaw("ab1seconddashloop", true)
                        startDashMove()
                    else
                        voidRushPhase = nil
                        stopDashMove()
                        stopAction()
                        unfreezeCharacter()
                        currentBase = "none"
                    end

                elseif voidRushPhase == "second_hit" then
                    -- Full sequence complete
                    voidRushPhase = nil
                    stopAction()
                    unfreezeCharacter()
                    currentBase = "none"

                elseif observantPhase == "activation" or
                       observantPhase == "startup"    or
                       observantPhase == "teleport"   then
                    advanceObservant()

                elseif observantPhase == "startup_wait" then
                    actionStart[a] = os.clock()

                else
                    -- Any other non-looped action (Nova, M1, Kill, etc.) finished
                    a.weight      = 0
                    currentAction = nil
                    unfreezeCharacter()
                    currentBase   = "none"
                end
            end
        end
    end

    -- ── BASE LOCOMOTION ───────────────────────────────────────
    local actionBlocking = currentAction or (voidRushPhase == "wait_second")
    if not actionBlocking then
        if inAir then
            if not wasInAir then setBase("idle") end
        else
            if wasInAir then currentBase = "none" end
            local moving = hum.MoveDirection.Magnitude > 0.1
            if moving then
                setBase(isSprinting and "sprint" or "walk")
            else
                setBase("idle")
            end
        end
    end

    wasInAir = inAir

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
    ContextActions:UnbindAction("GM_VoidRush")
    ContextActions:UnbindAction("GM_Nova")
    ContextActions:UnbindAction("GM_Observant")
    ContextActions:UnbindAction("GM_M1")
    ContextActions:UnbindAction("GM_Kill")
    ContextActions:UnbindAction("GM_Sprint")

    cleanObservantTouchConn()

    if bgSound then bgSound:Stop() bgSound:Destroy() bgSound = nil end
    stopDashMove()

    for _, joint in ipairs(allJoints) do
        if joint and joint.Parent then
            joint.Transform = CFrame.identity
        end
    end
    allJoints = {}

    for _, a in pairs(baseAnims)   do a.weight = 0 end
    for _, a in pairs(actionAnims) do a.weight = 0 end

    unfreezeCharacter()

    baseAnimator   = nil
    actionAnimator = nil
    actionStart    = {}
    currentAction  = nil
    currentBase    = "idle"
    isSprinting    = false
    wasInAir       = false
    figureRef      = nil
    baseAnims      = {}
    actionAnims    = {}
    voidRushPhase  = nil
    voidRushHeld   = false
    novaCastToggle = false
    observantPhase = nil
    dashDirection  = nil
end

return m
end)

return modules
