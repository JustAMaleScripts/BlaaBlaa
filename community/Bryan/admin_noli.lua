-- admin_noli.lua

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType   = "MOVESET"
m.Name         = "Admin Noli"
m.Description  = "losers are supost to lose"
m.InternalName = "noli"

m.Assets = {
    -- BASE
    "admin noli idle.anim",
    "admin noli walk.anim",
    "admin noli run.anim",

    -- INTRO / OUTRO
    "admin noli intro.anim",
    "admin noli outro.anim",

    -- VOID RUSH
    "admin noli void rush startup.anim",
    "admin noli void rush loop.anim",
    "admin noli void rush first hit.anim",
    "admin noli void rush second hit.anim",

    -- ARM LOOP (hold idle between dashes)
    "noli ab1 - armloop.anim",

    -- NOVA
    "admin noli nova.anim",
    "admin noli nova recast.anim",

    -- OBSERVANT
    "admin noli observant startup.anim",
    "admin noli observant loop.anim",
    "admin noli observant teleport.anim",

    -- M1 / KILL
    "admin noli m1.anim",
    "admin noli kill.anim",

    -- MUSIC
    "admin noli chase theme.mp3",
}

m.KillEnabled = { ["kill"] = true }

-- ── SERVICES ──────────────────────────────────────────────────
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")

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
local bgSound       = nil

-- ── VOID RUSH STATE ───────────────────────────────────────────
local voidRushPhase    = nil
local voidRushHeld     = false
-- Guard: true once the loop anim has been triggered, prevents double-play
local voidLoopPlaying  = false

-- ── COLLISION SYSTEM ──────────────────────────────────────────
local HIT_RADIUS   = 3
local RAYCAST_DIST = 2.5

local function getNearestSurvivor(character)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest, minDist = nil, HIT_RADIUS
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character ~= character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (root.Position - tr.Position).Magnitude
                if d < minDist then minDist = d; nearest = player.Character end
            end
        end
    end
    return nearest
end

local function makeRayParams()
    local p = RaycastParams.new()
    local ignore = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then table.insert(ignore, pl.Character) end
    end
    if _G.Uhhhhhh and _G.Uhhhhhh.Character then
        table.insert(ignore, _G.Uhhhhhh.Character)
    end
    p.FilterDescendantsInstances = ignore
    p.FilterType = Enum.RaycastFilterType.Exclude
    return p
end

local function checkWall(hrp, direction)
    if not hrp then return false end
    local origin = hrp.Position + Vector3.new(0, 1.5, 0)
    return workspace:Raycast(origin, direction * RAYCAST_DIST, makeRayParams()) ~= nil
end

-- ── DASH MOVEMENT ─────────────────────────────────────────────
local DASH_FORCE     = 120
local dashMoveActive = false
local dashMoveConn   = nil
local dashDirection  = nil

local function stopDashMove()
    dashMoveActive = false
    if dashMoveConn then dashMoveConn:Disconnect(); dashMoveConn = nil end
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
    if figureRef then
        local hrp = figureRef:FindFirstChild("HumanoidRootPart")
        if hrp then dashDirection = hrp.CFrame.LookVector end
    end
    dashMoveConn = RunService.Heartbeat:Connect(function()
        if not dashMoveActive or not figureRef then stopDashMove(); return end
        local hrp = figureRef:FindFirstChild("HumanoidRootPart")
        if hrp then
            local fwd = hrp.CFrame.LookVector
            hrp.AssemblyLinearVelocity = Vector3.new(
                fwd.X * DASH_FORCE, hrp.AssemblyLinearVelocity.Y, fwd.Z * DASH_FORCE)
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

local function freezeCharacter()
    if not figureRef then return end
    local hum = figureRef:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 0 end
end

local function unfreezeCharacter()
    setSpeed(isSprinting and SPEED_SPRINT or SPEED_WALK)
end

-- ── SOUND HELPER ──────────────────────────────────────────────
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
    local btnW, gapW = 0.10, 0.01
    local btnH, gapH = 0.08, 0.01
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

-- ── CAMERA HELPERS ────────────────────────────────────────────
local camTweenConn = nil

local function stopCameraTween()
    if camTweenConn then camTweenConn:Cancel(); camTweenConn = nil end
end

-- Returns a CFrame positioned in FRONT of the character, facing toward it.
local function frontCF(hrp, offsetZ, offsetY)
    local pos = hrp.Position + hrp.CFrame.LookVector * offsetZ + Vector3.new(0, offsetY, 0)
    return CFrame.lookAt(pos, hrp.Position + Vector3.new(0, offsetY * 0.5, 0))
end

local function doCameraIntro(figure)
    stopCameraTween()
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable
    local hrp = figure:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Far front → push in → low dramatic angle (always facing character)
    local cf1 = frontCF(hrp, 9,   2)
    local cf2 = frontCF(hrp, 4.5, 1.5)
    local cf3 = frontCF(hrp, 3.5, -0.8)

    camera.CFrame = cf1

    local t1 = TweenService:Create(camera,
        TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        { CFrame = cf2 })
    t1:Play(); t1.Completed:Wait()

    local t2 = TweenService:Create(camera,
        TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        { CFrame = cf3 })
    t2:Play(); t2.Completed:Wait()

    camera.CameraType = Enum.CameraType.Custom
end

local function doCameraOutro(figure)
    stopCameraTween()
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable
    local hrp = figure:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Close front → slide right (still facing) → wide pull-back (still in front)
    local cf1  = frontCF(hrp, 5, 1)
    local right = hrp.CFrame.RightVector
    local cf2  = CFrame.lookAt(
        hrp.Position + hrp.CFrame.LookVector * 4 + right * 4 + Vector3.new(0, 1.5, 0),
        hrp.Position + Vector3.new(0, 1, 0)
    )
    local cf3  = frontCF(hrp, 11, 3)

    camera.CFrame = cf1

    local t1 = TweenService:Create(camera,
        TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        { CFrame = cf2 })
    t1:Play(); t1.Completed:Wait()

    local t2 = TweenService:Create(camera,
        TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
        { CFrame = cf3 })
    t2:Play(); t2.Completed:Wait()

    camera.CameraType = Enum.CameraType.Custom
end

-- ── NOVA STATE ────────────────────────────────────────────────
local novaCastToggle = false

-- ── OBSERVANT STATE ───────────────────────────────────────────
local observantPhase     = nil
local observantInputConn = nil

local function cleanObservantInputConn()
    if observantInputConn then
        observantInputConn:Disconnect()
        observantInputConn = nil
    end
end

-- Teleports the character to a world position (lands on top of the surface).
local function teleportTo(worldPos)
    if not figureRef then return end
    local hrp = figureRef:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(worldPos + Vector3.new(0, 3, 0))
    end
end

-- Fires a screen-space ray and teleports on hit.
local function onObservantClick(screenPos)
    if observantPhase ~= "startup_wait" then return end

    local camera  = workspace.CurrentCamera
    local unitRay = camera:ScreenPointToRay(screenPos.X, screenPos.Y)

    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, makeRayParams())
    if not result then return end   -- clicked the sky → ignore

    cleanObservantInputConn()
    observantPhase = "teleport"
    _playRaw("teleport", false)

    -- Warp mid-animation (40% through)
    local targetPos = result.Position
    coroutine.wrap(function()
        local animDur = (actionAnims["teleport"] and actionAnims["teleport"].track
                         and actionAnims["teleport"].track.Time) or 0.5
        task.wait(animDur * 0.4)
        teleportTo(targetPos)
    end)()
end

-- Arms the click/tap listener while Observant is waiting for target input.
local function armObservantInput()
    cleanObservantInputConn()
    observantInputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if observantPhase ~= "startup_wait" then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            onObservantClick(Vector2.new(input.Position.X, input.Position.Y))
        end
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
        armObservantInput()
        -- FIX: guard against nil before indexing actionStart
        local loopAnim = actionAnims["observantstartup"]
        if loopAnim then
            actionStart[loopAnim] = os.clock()  -- keep loop alive
        end
    elseif observantPhase == "teleport" then
        observantPhase = nil
        cleanObservantInputConn()
        stopAction(); unfreezeCharacter(); currentBase = "none"
    end
end

-- ── VOID RUSH — hit handling ──────────────────────────────────
local function triggerFirstDashHit()
    stopDashMove()
    voidLoopPlaying = false
    voidRushPhase   = "first_hit"
    _playRaw("ab1firstdashsuccesfulhit", false)
end

local function triggerSecondDashHit()
    stopDashMove()
    voidLoopPlaying = false
    voidRushPhase   = "second_hit"
    _playRaw("ab1succesfulhit", false)
end

-- ── VOID RUSH (Hold-to-Charge) ────────────────────────────────
local function onVoidRushPress()
    -- Second dash: skip startup entirely, go straight to loop
    if voidRushPhase == "wait_second" then
        voidRushHeld    = true
        voidLoopPlaying = true
        voidRushPhase   = "second_loop"
        freezeCharacter()
        if actionAnims["ab1armloop"] then actionAnims["ab1armloop"].weight = 0 end
        _playRaw("ab1seconddashloop", true)
        startDashMove()
        return
    end
    if currentAction or (voidRushPhase ~= nil) or observantPhase then return end
    voidRushHeld      = true
    voidLoopPlaying   = false
    voidRushPhase     = "first_startup"
    freezeCharacter()
    _playRaw("ab1firstdashstartup", false)
end

local function onVoidRushRelease()
    voidRushHeld = false
    -- If still in startup when released, the auto-advance will see voidRushHeld=false
    -- and cancel cleanly when the startup anim finishes.
    -- If already dashing, trigger the hit immediately on release.
    if voidRushPhase == "first_loop" then
        triggerFirstDashHit()
    elseif voidRushPhase == "second_loop" then
        triggerSecondDashHit()
    end
end

-- ── NOVA ──────────────────────────────────────────────────────
local function pressNova()
    if currentAction or voidRushPhase or observantPhase then return end
    freezeCharacter()
    if not novaCastToggle then
        novaCastToggle = true
        -- FIX: chave padronizada para minúsculo, igual ao actionAnims
        _playRaw("nova", false)
    else
        novaCastToggle = false
        _playRaw("recast", false)
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
    if not currentAction then currentBase = "none" end
end

-- ── KILL ──────────────────────────────────────────────────────
local function playKill()
    if not m.KillEnabled["kill"] then return end
    if currentAction or voidRushPhase or observantPhase then return end
    freezeCharacter()
    _playRaw("kill", false)
end

-- ── OUTRO ─────────────────────────────────────────────────────
local function playOutro()
    if currentAction or voidRushPhase or observantPhase then return end
    freezeCharacter()
    _playRaw("outro", false)
    coroutine.wrap(function() doCameraOutro(figureRef) end)()
end

-- ── CONFIG / SAVE / LOAD ──────────────────────────────────────
m.Config = function(parent)
    Util_CreateText(parent, "Admin Noli", 18, Enum.TextXAlignment.Center)
    Util_CreateSeparator(parent)
    Util_CreateText(parent, "Kill Animation", 15, Enum.TextXAlignment.Center)
    Util_CreateSwitch(parent, "kill plays", m.KillEnabled["kill"]).Changed:Connect(
        function(v) m.KillEnabled["kill"] = v end)
end
m.SaveConfig = function() return { KillEnabled = m.KillEnabled } end
m.LoadConfig = function(save)
    if type(save.KillEnabled) == "table" then
        for k, v in pairs(save.KillEnabled) do
            if m.KillEnabled[k] ~= nil then m.KillEnabled[k] = v end
        end
    end
end

-- ── INIT ──────────────────────────────────────────────────────
m.Init = function(figure)
    figureRef = figure

    baseAnimator   = AnimLib.Animator.new(); baseAnimator.rig   = figure
    actionAnimator = AnimLib.Animator.new(); actionAnimator.rig = figure

    allJoints = {}
    for _, v in ipairs(figure:GetDescendants()) do
        if v:IsA("Motor6D") then table.insert(allJoints, v) end
    end

    -- BASE ANIMS
    baseAnims = {
        idle   = loadAnim(figure, "admin noli idle.anim", true),
        walk   = loadAnim(figure, "admin noli walk.anim", true),
        sprint = loadAnim(figure, "admin noli run.anim",  true),
    }

    -- ACTION ANIMS
    -- The dash loop animator is ONE shared instance for first and second dash.
    -- This guarantees the loop anim is never started twice on different objects.
    local sharedVoidLoop = loadAnim(figure, "admin noli void rush loop.anim", true)

    actionAnims = {
        -- Intro / Outro
        ["intro"]                    = loadAnim(figure, "admin noli intro.anim",                false),
        ["outro"]                    = loadAnim(figure, "admin noli outro.anim",                false),

        -- Void Rush startup (only first dash uses startup; second goes straight to loop)
        -- FIX: removed unused "ab1seconddashstartup" entry
        ["ab1firstdashstartup"]      = loadAnim(figure, "admin noli void rush startup.anim",    false),

        -- Void Rush loop — SINGLE shared animator, both keys point to same object
        ["ab1firstdashloop"]         = sharedVoidLoop,
        ["ab1seconddashloop"]        = sharedVoidLoop,

        -- Void Rush hits
        ["ab1firstdashsuccesfulhit"] = loadAnim(figure, "admin noli void rush first hit.anim",  false),
        ["ab1succesfulhit"]          = loadAnim(figure, "admin noli void rush second hit.anim", false),

        -- Arm loop (idle hold between dashes)
        -- FIX: "noli ab1 - armloop.anim" is the dedicated arm-loop anim.
        -- If you don't have it yet: duplicate "admin noli idle.anim" and rename the
        -- copy to "noli ab1 - armloop.anim" in the same asset folder.
        -- Until then, this falls back to the idle anim so the moveset still works.
        ["ab1armloop"]               = (function()
            local ok, anim = pcall(loadAnim, figure, "noli ab1 - armloop.anim", true)
            if ok and anim then return anim end
            warn("[Admin Noli] 'noli ab1 - armloop.anim' not found – falling back to idle anim. Duplicate 'admin noli idle.anim' and rename it to fix this.")
            return loadAnim(figure, "admin noli idle.anim", true)
        end)(),

        -- Nova
        -- FIX: chave padronizada para minúsculo para bater com _playRaw("nova")
        ["nova"]                     = loadAnim(figure, "admin noli nova.anim",                 false),
        ["recast"]                   = loadAnim(figure, "admin noli nova recast.anim",          false),

        -- Observant
        ["observant activation"]     = loadAnim(figure, "admin noli observant startup.anim",    false),
        ["observantstartup"]         = loadAnim(figure, "admin noli observant loop.anim",       false),
        ["teleport"]                 = loadAnim(figure, "admin noli observant teleport.anim",   false),

        -- M1 / Kill
        ["M1"]                       = loadAnim(figure, "admin noli m1.anim",                   false),
        ["kill"]                     = loadAnim(figure, "admin noli kill.anim",                 false),
    }

    setSpeed(SPEED_WALK)
    setBase("idle")

    -- Background music
    local hrp = figure:FindFirstChild("HumanoidRootPart") or figure
    bgSound = makeSound("admin noli chase theme.mp3", hrp, 0.5, true)
    bgSound:Play()

    -- Auto intro on equip
    freezeCharacter()
    _playRaw("intro", false)
    coroutine.wrap(function() doCameraIntro(figure) end)()

    -- ── KEYBINDS ────────────────────────────────────────────────
    -- Q = Void Rush (hold)
    ContextActions:BindAction("GM_VoidRush", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            onVoidRushPress()
        elseif inputState == Enum.UserInputState.End then
            onVoidRushRelease()
        end
    end, true, Enum.KeyCode.Q)
    ContextActions:SetTitle("GM_VoidRush", "Void Rush")
    ContextActions:SetPosition("GM_VoidRush", btnPos(17.5, 21))

    -- E = Nova
    ContextActions:BindAction("GM_Nova", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then pressNova() end
    end, true, Enum.KeyCode.E)
    ContextActions:SetTitle("GM_Nova", "Nova")
    ContextActions:SetPosition("GM_Nova", btnPos(14, 21))

    -- R = Observant (teleport)
    ContextActions:BindAction("GM_Observant", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then startObservant() end
    end, true, Enum.KeyCode.R)
    ContextActions:SetTitle("GM_Observant", "Observant")
    ContextActions:SetPosition("GM_Observant", btnPos(10.5, 21))

    -- Mouse Button1 / touch button = M1
    ContextActions:BindAction("GM_M1", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            if currentAction or voidRushPhase or observantPhase then return end
            playAction("M1")
        end
    end, true, Enum.UserInputType.MouseButton1)
    ContextActions:SetTitle("GM_M1", "M1")
    ContextActions:SetPosition("GM_M1", btnPos(7, 21))

    -- Ctrl / Left Shift = Sprint toggle
    ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then toggleSprint() end
    end, true, Enum.KeyCode.LeftControl, Enum.KeyCode.LeftShift)
    ContextActions:SetTitle("GM_Sprint", "Sprint")
    ContextActions:SetPosition("GM_Sprint", btnPos(3.5, 17))

    -- N = Kill
    ContextActions:BindAction("GM_Kill", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playKill() end
    end, true, Enum.KeyCode.N)
    ContextActions:SetTitle("GM_Kill", "Kill")
    ContextActions:SetPosition("GM_Kill", btnPos(3.5, 21))

    -- 1 = Outro
    ContextActions:BindAction("GM_Outro", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then playOutro() end
    end, true, Enum.KeyCode.One)
    ContextActions:SetTitle("GM_Outro", "outro")
    ContextActions:SetPosition("GM_Outro", btnPos(0, 21))
end

-- ── UPDATE ────────────────────────────────────────────────────
m.Update = function(dt, figure)
    local hum = figure:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local inAir = hum.FloorMaterial == Enum.Material.Air

    -- (Void Rush loop is triggered in auto-advance when startup anim finishes)

    -- ── VOID RUSH COLLISION CHECK ──────────────────────────────
    if dashMoveActive and figureRef then
        local hrp = figureRef:FindFirstChild("HumanoidRootPart")
        if hrp then
            local survivor = getNearestSurvivor(figure)
            if survivor then
                if voidRushPhase == "first_loop" then
                    triggerFirstDashHit()
                elseif voidRushPhase == "second_loop" then
                    triggerSecondDashHit()
                end
            end
            if dashMoveActive and dashDirection then
                if checkWall(hrp, dashDirection) then
                    stopDashMove()
                    voidLoopPlaying = false
                    if voidRushPhase == "first_loop" then
                        voidRushPhase = "wait_second"
                        stopAction(); unfreezeCharacter(); currentBase = "none"
                    elseif voidRushPhase == "second_loop" then
                        voidRushPhase = nil
                        stopAction(); unfreezeCharacter(); currentBase = "none"
                    end
                end
            end
        end
    end

    -- ── AUTO-ADVANCE (non-looped anims) ───────────────────────
    if currentAction then
        local a = actionAnims[currentAction]
        if a and actionStart[a] and not a.looped then
            local elapsed  = os.clock() - actionStart[a]
            local duration = a.track and a.track.Time or 0

            if duration > 0 and elapsed >= duration / (a.speed or 1) then

                -- Void Rush startup finished → only begin loop if still holding Q
                if voidRushPhase == "first_startup" then
                    if voidRushHeld then
                        voidLoopPlaying = true
                        voidRushPhase   = "first_loop"
                        _playRaw("ab1firstdashloop", true)
                        startDashMove()
                    else
                        -- Released before startup ended → cancel
                        voidRushPhase   = nil
                        voidLoopPlaying = false
                        stopDashMove(); stopAction(); unfreezeCharacter(); currentBase = "none"
                    end

                elseif voidRushPhase == "first_hit" then
                    voidRushPhase   = "wait_second"
                    voidLoopPlaying = false
                    stopAction(); unfreezeCharacter(); currentBase = "none"
                    -- Arm loop while waiting for second dash input
                    if actionAnims["ab1armloop"] then
                        actionAnims["ab1armloop"].weight = 1
                        actionStart[actionAnims["ab1armloop"]] = os.clock()
                        currentAction = "ab1armloop"
                    end

                elseif voidRushPhase == "second_hit" then
                    voidRushPhase   = nil
                    voidLoopPlaying = false
                    stopAction(); unfreezeCharacter(); currentBase = "none"

                elseif observantPhase == "activation" or
                       observantPhase == "startup"    or
                       observantPhase == "teleport"   then
                    advanceObservant()

                elseif observantPhase == "startup_wait" then
                    -- Keep loop alive until a click arrives
                    actionStart[a] = os.clock()

                else
                    -- Nova, M1, Kill, Intro, Outro, etc.
                    a.weight      = 0
                    currentAction = nil
                    unfreezeCharacter()
                    currentBase   = "none"
                end
            end
        end
    end

    -- ── BASE LOCOMOTION ───────────────────────────────────────
    local blocking = currentAction or (voidRushPhase == "wait_second")
    if not blocking then
        if inAir then
            if not wasInAir then setBase("idle") end
        else
            if wasInAir then currentBase = "none" end
            local moving = hum.MoveDirection.Magnitude > 0.1
            setBase(moving and (isSprinting and "sprint" or "walk") or "idle")
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
    ContextActions:UnbindAction("GM_Outro")

    cleanObservantInputConn()
    stopCameraTween()

    if workspace.CurrentCamera then
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end

    if bgSound then bgSound:Stop(); bgSound:Destroy(); bgSound = nil end
    stopDashMove()

    for _, joint in ipairs(allJoints) do
        if joint and joint.Parent then joint.Transform = CFrame.identity end
    end
    allJoints = {}

    for _, a in pairs(baseAnims)   do a.weight = 0 end
    for _, a in pairs(actionAnims) do a.weight = 0 end

    unfreezeCharacter()

    baseAnimator     = nil
    actionAnimator   = nil
    actionStart      = {}
    currentAction    = nil
    currentBase      = "idle"
    isSprinting      = false
    wasInAir         = false
    figureRef        = nil
    baseAnims        = {}
    actionAnims      = {}
    voidRushPhase    = nil
    voidRushHeld     = false
    voidLoopPlaying  = false
    novaCastToggle   = false
    observantPhase   = nil
    dashDirection    = nil
end

return m
end)

return modules
