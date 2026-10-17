-- CharaDummysakenMoveset.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/CharaDummysakenMoveset.lua

cloneref = cloneref or function(o) return o end

local Debris     = cloneref(game:GetService("Debris"))
local RunService = cloneref(game:GetService("RunService"))
local Players    = cloneref(game:GetService("Players"))

local Player = Players.LocalPlayer

local modules = {}
local function AddModule(m)
    table.insert(modules, m)
end


AddModule(function()
    local m = {}
    m.ModuleType   = "MOVESET"
    m.Name         = "Chara From Dummysaken"
    m.Description  = "Id like to oppose something. dear friend."
    m.InternalName = "CharaDummysakenMoveset"

    m.Assets = {
        "CharaIdleDummysaken.anim",
        "CharaWalk.anim",
        "CharaRunDummysaken.anim",
        "CharaM1.anim",
        "CharaCombo.anim",
        "CharaJudgement.anim",
        "CharaDetermination.anim",
        "CharaKillAnimation.anim",
        "CharaIntro.anim",
        "CharaM1Sound.mp3",
        "CharaComboSound.mp3",
        "CharaJudgementSound.mp3",
        "CharaDeterminationSound.mp3",
        "CharaKillSound.mp3",
        "CharaIntroSound.mp3",
    }

    m.FlingEnabled = {
        ["M1"] = true,
        ["Combo"] = true,
        ["Judgement"] = true,
        ["Determination"] = false,
        ["Kill"] = false,
        ["Intro"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Chara From Dummysaken", 18, Enum.TextXAlignment.Center)
        Util_CreateSeparator(parent)
    end

    m.SaveConfig = function()
        local t = {}
        return t
    end

    m.LoadConfig = function(save)
    end

    -- STATE
    local baseAnims    = {}
    local actionAnims  = {}
    local animJump     = nil
    local actionStart  = {}
    local currentBase   = "idle"
    local currentAction = nil
    local wasInAir      = false
    local flingActive   = false
    local touchConns    = {}
    local allJoints     = {}
    local figureRef     = nil
    local SPEED_WALK    = 7
    local SPEED_SPRINT  = 29
    local isSprinting   = false
    -- Per-animation sounds
    local snd_M1 = nil
    local snd_Combo = nil
    local snd_Judgement = nil
    local snd_Determination = nil
    local snd_Kill = nil
    local snd_Intro = nil

    -- HELPERS
    local function makeSound(filename, parent, volume, looped)
        local s = Instance.new("Sound")
        s.SoundId = AssetGetContentId(filename)
        s.Volume  = volume or 0.8
        s.Looped  = looped or false
        s.Parent  = parent
        return s
    end

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
        -- rage overrides locomotion anims
        if baseAnims[state] then baseAnims[state].weight = 1 end
    end

    local function stopAllAnimSounds()
        if snd_M1 then snd_M1:Stop() end
        if snd_Combo then snd_Combo:Stop() end
        if snd_Judgement then snd_Judgement:Stop() end
        if snd_Determination then snd_Determination:Stop() end
        if snd_Kill then snd_Kill:Stop() end
        if snd_Intro then snd_Intro:Stop() end
    end

    local function stopAction()
        for _, anim in pairs(actionAnims) do anim.weight = 0 end
        stopAllAnimSounds()
        currentAction = nil
        flingActive   = false
    end

    local function playAction(name)
        if currentAction then return end
        local a = actionAnims[name]
        if not a then return end
        stopAction()
        a.weight       = 1
        actionStart[a] = os.clock()
        currentAction  = name
        flingActive    = m.FlingEnabled[name] == true
        -- per-action audio
        if name == "M1" and snd_M1 then snd_M1:Play() end
        if name == "Combo" and snd_Combo then snd_Combo:Play() end
        if name == "Judgement" and snd_Judgement then snd_Judgement:Play() end
        if name == "Determination" and snd_Determination then snd_Determination:Play() end
        if name == "Kill" and snd_Kill then snd_Kill:Play() end
        if name == "Intro" and snd_Intro then snd_Intro:Play() end
    end

    local function toggleSprint()
        isSprinting = not isSprinting
        if isSprinting then
            setSpeed( SPEED_SPRINT)
            ContextActions:SetTitle("GM_Sprint", "Walk")
        else
            setSpeed( SPEED_WALK)
            ContextActions:SetTitle("GM_Sprint", "Sprint")
        end
    end

    local function setupFlingTouched(figure)
        local function hookPart(part)
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
        for _, part in ipairs(figure:GetDescendants()) do
            if part:IsA("BasePart") then hookPart(part) end
        end
        table.insert(touchConns, figure.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") then hookPart(part) end
        end))
    end

    -- INIT
    m.Init = function(figure)
        figureRef = figure
        local hrp = figure:FindFirstChild("HumanoidRootPart") or figure
        local hum = figure:FindFirstChildOfClass("Humanoid")

        allJoints = {}
        for _, v in ipairs(figure:GetDescendants()) do
            if v:IsA("Motor6D") then table.insert(allJoints, v) end
        end

        baseAnims = {
        idle = loadAnim(figure, "CharaIdleDummysaken.anim", true),
        walk = loadAnim(figure, "CharaWalk.anim", true),
        sprint = loadAnim(figure, "CharaRunDummysaken.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["M1"] = loadAnim(figure, "CharaM1.anim", false),
        ["Combo"] = loadAnim(figure, "CharaCombo.anim", false),
        ["Judgement"] = loadAnim(figure, "CharaJudgement.anim", false),
        ["Determination"] = loadAnim(figure, "CharaDetermination.anim", false),
        ["Kill"] = loadAnim(figure, "CharaKillAnimation.anim", false),
        ["Intro"] = loadAnim(figure, "CharaIntro.anim", false),
        }

        -- init per-anim sounds
    snd_M1 = makeSound("CharaM1Sound.mp3", hrp, 0.8, false)
    snd_Combo = makeSound("CharaComboSound.mp3", hrp, 0.8, false)
    snd_Judgement = makeSound("CharaJudgementSound.mp3", hrp, 0.8, false)
    snd_Determination = makeSound("CharaDeterminationSound.mp3", hrp, 0.8, false)
    snd_Kill = makeSound("CharaKillSound.mp3", hrp, 0.8, false)
    snd_Intro = makeSound("CharaIntroSound.mp3", hrp, 0.8, false)

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then toggleSprint() end
        end, true, Enum.KeyCode.LeftAlt)
        ContextActions:SetTitle("GM_Sprint", "Sprint")
        ContextActions:SetPosition("GM_Sprint", UDim2.new(1, -150, 1, -100))


        ContextActions:BindAction("GM_M1", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("M1") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_M1", "M1")
        ContextActions:SetPosition("GM_M1", UDim2.new(1, -190, 1, -100))

        ContextActions:BindAction("GM_Combo", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Combo") end
        end, true, Enum.KeyCode.X)
        ContextActions:SetTitle("GM_Combo", "Combo")
        ContextActions:SetPosition("GM_Combo", UDim2.new(1, -230, 1, -100))

        ContextActions:BindAction("GM_Judgement", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Judgement") end
        end, true, Enum.KeyCode.C)
        ContextActions:SetTitle("GM_Judgement", "Charge Nature")
        ContextActions:SetPosition("GM_Judgement", UDim2.new(1, -270, 1, -100))

        ContextActions:BindAction("GM_Determination", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Determination") end
        end, true, Enum.KeyCode.V)
        ContextActions:SetTitle("GM_Determination", "Determination")
        ContextActions:SetPosition("GM_Determination", UDim2.new(1, -190, 1, -140))

        ContextActions:BindAction("GM_Kill", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Kill") end
        end, true, Enum.KeyCode.B)
        ContextActions:SetTitle("GM_Kill", "Kill")
        ContextActions:SetPosition("GM_Kill", UDim2.new(1, -230, 1, -140))

        ContextActions:BindAction("GM_Intro", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Intro") end
        end, true, Enum.KeyCode.F)
        ContextActions:SetTitle("GM_Intro", "Intro")
        ContextActions:SetPosition("GM_Intro", UDim2.new(1, -270, 1, -140))
    end

    -- UPDATE
    m.Update = function(dt, figure)
        local hum = figure:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local inAir = hum.FloorMaterial == Enum.Material.Air

        -- auto-stop finished actions
        if currentAction then
            local a = actionAnims[currentAction]
            if a and actionStart[a] then
                local elapsed  = os.clock() - actionStart[a]
                local duration = a.track and a.track.Time or 0
                if duration > 0 and elapsed >= duration / (a.speed or 1) then
                    a.weight      = 0
                    stopAllAnimSounds()
                    currentAction = nil
                    flingActive   = false
                    currentBase   = "none"
                end
            end
        end

        -- locomotion state machine
        if not currentAction then
            if inAir then
                if not wasInAir then
                    clearBase()
                    currentBase           = "jump"
                    animJump.weight       = 1
                    actionStart[animJump] = os.clock()
                end
            else
                if wasInAir then animJump.weight = 0 end
                local moving = hum.MoveDirection.Magnitude > 0.1
                if moving then
                    if isSprinting then setBase("sprint") else setBase("walk") end
                else
                    setBase("idle")
                end
            end
        end

        wasInAir = inAir
        local now = os.clock()
        for _, a in pairs(baseAnims) do if a.weight > 0 then a:Step(now) end end
        for a, start in pairs(actionStart) do if a.weight > 0 then a:Step(now - start) end end
    end

    -- DESTROY
    m.Destroy = function(figure)
        ContextActions:UnbindAction("GM_Sprint")
        ContextActions:UnbindAction("GM_M1")
        ContextActions:UnbindAction("GM_Combo")
        ContextActions:UnbindAction("GM_Judgement")
        ContextActions:UnbindAction("GM_Determination")
        ContextActions:UnbindAction("GM_Kill")
        ContextActions:UnbindAction("GM_Intro")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        stopAllAnimSounds()
    if snd_M1 then snd_M1:Stop() snd_M1:Destroy() snd_M1 = nil end
    if snd_Combo then snd_Combo:Stop() snd_Combo:Destroy() snd_Combo = nil end
    if snd_Judgement then snd_Judgement:Stop() snd_Judgement:Destroy() snd_Judgement = nil end
    if snd_Determination then snd_Determination:Stop() snd_Determination:Destroy() snd_Determination = nil end
    if snd_Kill then snd_Kill:Stop() snd_Kill:Destroy() snd_Kill = nil end
    if snd_Intro then snd_Intro:Stop() snd_Intro:Destroy() snd_Intro = nil end

        for _, joint in ipairs(allJoints) do
            if joint and joint.Parent then joint.Transform = CFrame.identity end
        end
        allJoints = {}

        for _, a in pairs(baseAnims)   do a.weight = 0 end
        for _, a in pairs(actionAnims) do a.weight = 0 end

        setSpeed(16)
        actionStart   = {}
        currentAction = nil
        currentBase   = "idle"
        wasInAir      = false
        flingActive   = false
        figureRef     = nil
        animJump      = nil
        baseAnims     = {}
        actionAnims   = {}
        isSprinting = false
    end

    return m
end)

return modules