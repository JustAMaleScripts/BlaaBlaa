-- IMSTILLMEMOVESET.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/IMSTILLMEMOVESET.lua

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
    m.Name         = "IMSTILLME"
    m.Description  = "hi im evil"
    m.InternalName = "IMSTILLMEMOVESET"

    m.Assets = {
        "IMSTILLMEIdle.anim",
        "IMSTILLMEWalk.anim",
        "IMSTILLMERun.anim",
        "IMSTILLMESwing.anim",
        "IMSTILLMECorruptSlash.anim",
        "IMSTILLMESpawnlocation.anim",
        "IMSTILLMEREBIRTH.anim",
        "IMSTILLMETheme.mp3",
        "IMSTILLMECorruptSlashSound.mp3",
        "IMSTILLMESpawnLocationSound.mp3",
        "IMSTILLMERebirthSound.mp3",
    }

    m.FlingEnabled = {
        ["Swing"] = true,
        ["Corrupt Slash"] = true,
        ["Spawn Location"] = false,
        ["Rebirth"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "IMSTILLME", 18, Enum.TextXAlignment.Center)
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
    local SPEED_SPRINT  = 29
    local isSprinting   = false
    local bgSound       = nil
    -- Per-animation sounds
    local snd_Corrupt_Slash = nil
    local snd_Spawn_Location = nil
    local snd_Rebirth = nil

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
        if snd_Corrupt_Slash then snd_Corrupt_Slash:Stop() end
        if snd_Spawn_Location then snd_Spawn_Location:Stop() end
        if snd_Rebirth then snd_Rebirth:Stop() end
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
        if name == "Corrupt Slash" and snd_Corrupt_Slash then snd_Corrupt_Slash:Play() end
        if name == "Spawn Location" and snd_Spawn_Location then snd_Spawn_Location:Play() end
        if name == "Rebirth" and snd_Rebirth then snd_Rebirth:Play() end
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
        idle = loadAnim(figure, "IMSTILLMEIdle.anim", true),
        walk = loadAnim(figure, "IMSTILLMEWalk.anim", true),
        sprint = loadAnim(figure, "IMSTILLMERun.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["Swing"] = loadAnim(figure, "IMSTILLMESwing.anim", false),
        ["Corrupt Slash"] = loadAnim(figure, "IMSTILLMECorruptSlash.anim", false),
        ["Spawn Location"] = loadAnim(figure, "IMSTILLMESpawnlocation.anim", false),
        ["Rebirth"] = loadAnim(figure, "IMSTILLMEREBIRTH.anim", false),
        }

        bgSound = makeSound("IMSTILLMETheme.mp3", hrp, 0.5, true)
        bgSound:Play()

        -- init per-anim sounds
    snd_Corrupt_Slash = makeSound("IMSTILLMECorruptSlashSound.mp3", hrp, 0.8, false)
    snd_Spawn_Location = makeSound("IMSTILLMESpawnLocationSound.mp3", hrp, 0.8, false)
    snd_Rebirth = makeSound("IMSTILLMERebirthSound.mp3", hrp, 0.8, false)

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then toggleSprint() end
        end, true, Enum.KeyCode.LeftAlt)
        ContextActions:SetTitle("GM_Sprint", "Sprint")
        ContextActions:SetPosition("GM_Sprint", UDim2.new(1, -100, 1, -120))


        ContextActions:BindAction("GM_Swing", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Swing") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Swing", "Swing")
        ContextActions:SetPosition("GM_Swing", UDim2.new(1, -150, 1, -120))

        ContextActions:BindAction("GM_Corrupt_Slash", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Corrupt Slash") end
        end, true, Enum.KeyCode.X)
        ContextActions:SetTitle("GM_Corrupt_Slash", "M2")
        ContextActions:SetPosition("GM_Corrupt_Slash", UDim2.new(1, -200, 1, -120))

        ContextActions:BindAction("GM_Spawn_Location", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Spawn Location") end
        end, true, Enum.KeyCode.C)
        ContextActions:SetTitle("GM_Spawn_Location", "Spawn Location")
        ContextActions:SetPosition("GM_Spawn_Location", UDim2.new(1, -250, 1, -120))

        ContextActions:BindAction("GM_Rebirth", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Rebirth") end
        end, true, Enum.KeyCode.V)
        ContextActions:SetTitle("GM_Rebirth", "Rebirth")
        ContextActions:SetPosition("GM_Rebirth", UDim2.new(1, -100, 1, -160))
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
        ContextActions:UnbindAction("GM_Swing")
        ContextActions:UnbindAction("GM_Corrupt_Slash")
        ContextActions:UnbindAction("GM_Spawn_Location")
        ContextActions:UnbindAction("GM_Rebirth")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        if bgSound then bgSound:Stop() bgSound:Destroy() bgSound = nil end
        stopAllAnimSounds()
    if snd_Corrupt_Slash then snd_Corrupt_Slash:Stop() snd_Corrupt_Slash:Destroy() snd_Corrupt_Slash = nil end
    if snd_Spawn_Location then snd_Spawn_Location:Stop() snd_Spawn_Location:Destroy() snd_Spawn_Location = nil end
    if snd_Rebirth then snd_Rebirth:Stop() snd_Rebirth:Destroy() snd_Rebirth = nil end

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
