-- ScreamerJohnDoe.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/ScreamerJohnDoe.lua

cloneref = cloneref or function(o) return o end

local Debris     = cloneref(game:GetService("Debris"))
local RunService = cloneref(game:GetService("RunService"))
local Players    = cloneref(game:GetService("Players"))

local Player = Players.LocalPlayer

local modules = {}
local function AddModule(m)
    table.insert(modules, m)
end

-- san_lua: convert any string to a valid Lua identifier (no spaces)
-- used only for table keys that are Lua identifiers (mode actions)
local function san_lua(s)
    return (s or ""):gsub("[^%w_]", "_")
end

AddModule(function()
    local m = {}
    m.ModuleType   = "MOVESET"
    m.Name         = "Screamer John Doe"
    m.Description  = "Back for more."
    m.InternalName = "ScreamerJohnDoe"

    m.Assets = {
        "ScreamerJohnDoeIdle.anim",
        "ScreamerJohnDoeWalk.anim",
        "ScreamerJohnDoeRun.anim",
        "ScreamerJohnDoeSlash.anim",
        "ScreamerJohnDoeCorruptEnergy.anim",
        "ScreamerJohnDoeDigitalFootprint.anim",
        "ScreamerJohnDoeKillAnim.anim",
        "ScreamerJohnDoeIntro.anim",
        "ScreamerJohnDoeStunt.anim",
        "ScreamerJohnDoeTheme.mp3",
        "ScreamerJohnDoeWalkAudio.mp3",
        "ScreamerJohnDoeRunAudio.mp3",
        "ScreamerJohnDoeSlashAudio.mp3",
        "ScreamerJohnDoeCorruptEnergyAudio.mp3",
        "ScreamerJohnDoeDigitalFootprintAudio.mp3",
        "ScreamerJohnDoeKillAudio.mp3",
        "ScreamerJohnDoeIntroAudio.mp3",
    }

    m.FlingEnabled = {
        ["Slash"] = false,
        ["Corrupt Energy"] = false,
        ["Digital Footprint"] = false,
        ["Execution"] = false,
        ["Intro"] = false,
        ["Stunt"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Screamer John Doe", 18, Enum.TextXAlignment.Center)
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
    local SPEED_WALK    = 9
    local SPEED_SPRINT  = 27
    local isSprinting   = false
    local bgSound       = nil
    -- Per-animation sounds
    local snd_ScreamerJohnDoeWalk_anim = nil
    local snd_ScreamerJohnDoeRun_anim = nil
    local snd_Slash = nil
    local snd_Corrupt_Energy = nil
    local snd_Digital_Footprint = nil
    local snd_Execution = nil
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
        -- per-base audio
        if state == "walk" then
            if snd_walk and not snd_walk.IsPlaying then snd_walk:Play() end
        else
            if snd_walk then snd_walk:Stop() end
        end
        if state == "sprint" then
            if snd_sprint and not snd_sprint.IsPlaying then snd_sprint:Play() end
        else
            if snd_sprint then snd_sprint:Stop() end
        end
    end

    local function stopAllAnimSounds()
        if snd_Slash then snd_Slash:Stop() end
        if snd_Corrupt_Energy then snd_Corrupt_Energy:Stop() end
        if snd_Digital_Footprint then snd_Digital_Footprint:Stop() end
        if snd_Execution then snd_Execution:Stop() end
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
        if name == "Slash" and snd_Slash then snd_Slash:Play() end
        if name == "Corrupt Energy" and snd_Corrupt_Energy then snd_Corrupt_Energy:Play() end
        if name == "Digital Footprint" and snd_Digital_Footprint then snd_Digital_Footprint:Play() end
        if name == "Execution" and snd_Execution then snd_Execution:Play() end
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
        idle = loadAnim(figure, "ScreamerJohnDoeIdle.anim", true),
        walk = loadAnim(figure, "ScreamerJohnDoeWalk.anim", true),
        sprint = loadAnim(figure, "ScreamerJohnDoeRun.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["Slash"] = loadAnim(figure, "ScreamerJohnDoeSlash.anim", false),
        ["Corrupt Energy"] = loadAnim(figure, "ScreamerJohnDoeCorruptEnergy.anim", false),
        ["Digital Footprint"] = loadAnim(figure, "ScreamerJohnDoeDigitalFootprint.anim", false),
        ["Execution"] = loadAnim(figure, "ScreamerJohnDoeKillAnim.anim", false),
        ["Intro"] = loadAnim(figure, "ScreamerJohnDoeIntro.anim", false),
        ["Stunt"] = loadAnim(figure, "ScreamerJohnDoeStunt.anim", false),
        }

        bgSound = makeSound("ScreamerJohnDoeTheme.mp3", hrp, 0.5, true)
        bgSound:Play()

        -- init per-anim sounds
    snd_ScreamerJohnDoeWalk_anim = makeSound("ScreamerJohnDoeWalkAudio.mp3", hrp, 0.9, false)
    snd_ScreamerJohnDoeRun_anim = makeSound("ScreamerJohnDoeRunAudio.mp3", hrp, 0.9, false)
    snd_Slash = makeSound("ScreamerJohnDoeSlashAudio.mp3", hrp, 0.9, false)
    snd_Corrupt_Energy = makeSound("ScreamerJohnDoeCorruptEnergyAudio.mp3", hrp, 0.9, false)
    snd_Digital_Footprint = makeSound("ScreamerJohnDoeDigitalFootprintAudio.mp3", hrp, 0.9, false)
    snd_Execution = makeSound("ScreamerJohnDoeKillAudio.mp3", hrp, 0.9, false)
    snd_Intro = makeSound("ScreamerJohnDoeIntroAudio.mp3", hrp, 0.9, false)

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then toggleSprint() end
        end, true, Enum.KeyCode.LeftAlt)
        ContextActions:SetTitle("GM_Sprint", "Sprint")
        ContextActions:SetPosition("GM_Sprint", UDim2.new(1, -150, 1, -100))


        ContextActions:BindAction("GM_Slash", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Slash") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Slash", "Slash")
        ContextActions:SetPosition("GM_Slash", UDim2.new(1, -200, 1, -100))

        ContextActions:BindAction("GM_Corrupt_Energy", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Corrupt Energy") end
        end, true, Enum.KeyCode.X)
        ContextActions:SetTitle("GM_Corrupt_Energy", "Corrupt Energy")
        ContextActions:SetPosition("GM_Corrupt_Energy", UDim2.new(1, -250, 1, -100))

        ContextActions:BindAction("GM_Digital_Footprint", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Digital Footprint") end
        end, true, Enum.KeyCode.C)
        ContextActions:SetTitle("GM_Digital_Footprint", "Digital Footprint")
        ContextActions:SetPosition("GM_Digital_Footprint", UDim2.new(1, -300, 1, -100))

        ContextActions:BindAction("GM_Execution", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Execution") end
        end, true, Enum.KeyCode.V)
        ContextActions:SetTitle("GM_Execution", "Execution")
        ContextActions:SetPosition("GM_Execution", UDim2.new(1, -150, 1, -150))

        ContextActions:BindAction("GM_Intro", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Intro") end
        end, true, Enum.KeyCode.B)
        ContextActions:SetTitle("GM_Intro", "Intro")
        ContextActions:SetPosition("GM_Intro", UDim2.new(1, -200, 1, -150))

        ContextActions:BindAction("GM_Stunt", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Stunt") end
        end, true, Enum.KeyCode.N)
        ContextActions:SetTitle("GM_Stunt", "Stunt")
        ContextActions:SetPosition("GM_Stunt", UDim2.new(1, -250, 1, -150))
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
        ContextActions:UnbindAction("GM_Slash")
        ContextActions:UnbindAction("GM_Corrupt_Energy")
        ContextActions:UnbindAction("GM_Digital_Footprint")
        ContextActions:UnbindAction("GM_Execution")
        ContextActions:UnbindAction("GM_Intro")
        ContextActions:UnbindAction("GM_Stunt")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        if bgSound then bgSound:Stop() bgSound:Destroy() bgSound = nil end
        stopAllAnimSounds()
    if snd_ScreamerJohnDoeWalk_anim then snd_ScreamerJohnDoeWalk_anim:Stop() snd_ScreamerJohnDoeWalk_anim:Destroy() snd_ScreamerJohnDoeWalk_anim = nil end
    if snd_ScreamerJohnDoeRun_anim then snd_ScreamerJohnDoeRun_anim:Stop() snd_ScreamerJohnDoeRun_anim:Destroy() snd_ScreamerJohnDoeRun_anim = nil end
    if snd_Slash then snd_Slash:Stop() snd_Slash:Destroy() snd_Slash = nil end
    if snd_Corrupt_Energy then snd_Corrupt_Energy:Stop() snd_Corrupt_Energy:Destroy() snd_Corrupt_Energy = nil end
    if snd_Digital_Footprint then snd_Digital_Footprint:Stop() snd_Digital_Footprint:Destroy() snd_Digital_Footprint = nil end
    if snd_Execution then snd_Execution:Stop() snd_Execution:Destroy() snd_Execution = nil end
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