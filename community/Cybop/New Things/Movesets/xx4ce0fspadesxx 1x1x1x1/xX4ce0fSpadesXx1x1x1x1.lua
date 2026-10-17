-- xX4ce0fSpadesXx1x1x1x1.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/xX4ce0fSpadesXx1x1x1x1.lua

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
    m.Name         = "xX4ce0fSpadesXx 1x1x1x1"
    m.Description  = "WE DONT HAVE TO REACH YOU"
    m.InternalName = "xX4ce0fSpadesXx1x1x1x1"

    m.Assets = {
        "AceIdle.anim",
        "AceWalk.anim",
        "AceRun.anim",
        "AceSlash.anim",
        "AceMassInfection.anim",
        "AceEntanglement.anim",
        "AceUnstableEye.anim",
        "AceRejuvenateTheRotten.anim",
        "xX4ceOfSpadesXxTheme.mp3",
        "AceWalkAudio.mp3",
        "AceRunAudio.mp3",
        "AceSlashAudio.mp3",
        "AceMassInfectionAudio.mp3",
        "AceEntanglementAudio.mp3",
        "AceUnstableEyeAudio.mp3",
        "AceRejuvenateTheRottenAudio.mp3",
    }

    m.FlingEnabled = {
        ["Slash"] = false,
        ["Mass Infection"] = false,
        ["Entanglement"] = false,
        ["Unstable Eye"] = false,
        ["Rejuvenate The Rotten"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "xX4ce0fSpadesXx 1x1x1x1", 18, Enum.TextXAlignment.Center)
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
    local SPEED_WALK    = 8
    local SPEED_SPRINT  = 27
    local isSprinting   = false
    local bgSound       = nil
    -- Per-animation sounds
    local snd_AceWalk_anim = nil
    local snd_AceRun_anim = nil
    local snd_Slash = nil
    local snd_Mass_Infection = nil
    local snd_Entanglement = nil
    local snd_Unstable_Eye = nil
    local snd_Rejuvenate_The_Rotten = nil

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
        if snd_Mass_Infection then snd_Mass_Infection:Stop() end
        if snd_Entanglement then snd_Entanglement:Stop() end
        if snd_Unstable_Eye then snd_Unstable_Eye:Stop() end
        if snd_Rejuvenate_The_Rotten then snd_Rejuvenate_The_Rotten:Stop() end
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
        if name == "Mass Infection" and snd_Mass_Infection then snd_Mass_Infection:Play() end
        if name == "Entanglement" and snd_Entanglement then snd_Entanglement:Play() end
        if name == "Unstable Eye" and snd_Unstable_Eye then snd_Unstable_Eye:Play() end
        if name == "Rejuvenate The Rotten" and snd_Rejuvenate_The_Rotten then snd_Rejuvenate_The_Rotten:Play() end
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
        idle = loadAnim(figure, "AceIdle.anim", true),
        walk = loadAnim(figure, "AceWalk.anim", true),
        sprint = loadAnim(figure, "AceRun.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["Slash"] = loadAnim(figure, "AceSlash.anim", false),
        ["Mass Infection"] = loadAnim(figure, "AceMassInfection.anim", false),
        ["Entanglement"] = loadAnim(figure, "AceEntanglement.anim", false),
        ["Unstable Eye"] = loadAnim(figure, "AceUnstableEye.anim", false),
        ["Rejuvenate The Rotten"] = loadAnim(figure, "AceRejuvenateTheRotten.anim", false),
        }

        bgSound = makeSound("xX4ceOfSpadesXxTheme.mp3", hrp, 0.5, true)
        bgSound:Play()

        -- init per-anim sounds
    snd_AceWalk_anim = makeSound("AceWalkAudio.mp3", hrp, 0.9, false)
    snd_AceRun_anim = makeSound("AceRunAudio.mp3", hrp, 0.9, false)
    snd_Slash = makeSound("AceSlashAudio.mp3", hrp, 0.9, false)
    snd_Mass_Infection = makeSound("AceMassInfectionAudio.mp3", hrp, 0.9, false)
    snd_Entanglement = makeSound("AceEntanglementAudio.mp3", hrp, 0.9, false)
    snd_Unstable_Eye = makeSound("AceUnstableEyeAudio.mp3", hrp, 0.8, false)
    snd_Rejuvenate_The_Rotten = makeSound("AceRejuvenateTheRottenAudio.mp3", hrp, 0.9, false)

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

        ContextActions:BindAction("GM_Mass_Infection", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Mass Infection") end
        end, true, Enum.KeyCode.X)
        ContextActions:SetTitle("GM_Mass_Infection", "Mass Infection")
        ContextActions:SetPosition("GM_Mass_Infection", UDim2.new(1, -250, 1, -100))

        ContextActions:BindAction("GM_Entanglement", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Entanglement") end
        end, true, Enum.KeyCode.C)
        ContextActions:SetTitle("GM_Entanglement", "Entanglement")
        ContextActions:SetPosition("GM_Entanglement", UDim2.new(1, -300, 1, -100))

        ContextActions:BindAction("GM_Unstable_Eye", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Unstable Eye") end
        end, true, Enum.KeyCode.V)
        ContextActions:SetTitle("GM_Unstable_Eye", "Unstable Eye")
        ContextActions:SetPosition("GM_Unstable_Eye", UDim2.new(1, -150, 1, -150))

        ContextActions:BindAction("GM_Rejuvenate_The_Rotten", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Rejuvenate The Rotten") end
        end, true, Enum.KeyCode.B)
        ContextActions:SetTitle("GM_Rejuvenate_The_Rotten", "Rejuvenate The Rotten")
        ContextActions:SetPosition("GM_Rejuvenate_The_Rotten", UDim2.new(1, -200, 1, -150))
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
        ContextActions:UnbindAction("GM_Mass_Infection")
        ContextActions:UnbindAction("GM_Entanglement")
        ContextActions:UnbindAction("GM_Unstable_Eye")
        ContextActions:UnbindAction("GM_Rejuvenate_The_Rotten")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        if bgSound then bgSound:Stop() bgSound:Destroy() bgSound = nil end
        stopAllAnimSounds()
    if snd_AceWalk_anim then snd_AceWalk_anim:Stop() snd_AceWalk_anim:Destroy() snd_AceWalk_anim = nil end
    if snd_AceRun_anim then snd_AceRun_anim:Stop() snd_AceRun_anim:Destroy() snd_AceRun_anim = nil end
    if snd_Slash then snd_Slash:Stop() snd_Slash:Destroy() snd_Slash = nil end
    if snd_Mass_Infection then snd_Mass_Infection:Stop() snd_Mass_Infection:Destroy() snd_Mass_Infection = nil end
    if snd_Entanglement then snd_Entanglement:Stop() snd_Entanglement:Destroy() snd_Entanglement = nil end
    if snd_Unstable_Eye then snd_Unstable_Eye:Stop() snd_Unstable_Eye:Destroy() snd_Unstable_Eye = nil end
    if snd_Rejuvenate_The_Rotten then snd_Rejuvenate_The_Rotten:Stop() snd_Rejuvenate_The_Rotten:Destroy() snd_Rejuvenate_The_Rotten = nil end

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