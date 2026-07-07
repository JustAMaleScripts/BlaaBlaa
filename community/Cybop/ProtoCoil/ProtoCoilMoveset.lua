-- ProtoCoilMoveset.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/ProtoCoilMoveset.lua

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
    m.Name         = "ProtoCoil Moveset"
    m.Description  = "collect my coils, THIS HAS NO SPEED, NO REGEN, AND NO FUSION"
    m.InternalName = "ProtoCoilMoveset"

    m.Assets = {
        "ProtoCoilIdle.anim",
        "ProtoCoilWalk.anim",
        "ProtoCoilRun.anim",
        "ProtoCoilSpeed.anim",
        "ProtoCoilRegen.anim",
        "ProtoCoilFusion.anim",
        "ProtoCoilSpeedSound.mp3",
        "ProtoCoilRegenSound.mp3",
        "ProtoCoilFusionSound.mp3",
    }

    m.FlingEnabled = {
        ["Speed"] = false,
        ["Regen"] = false,
        ["Fusion"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "ProtoCoil Moveset", 18, Enum.TextXAlignment.Center)
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
    local SPEED_WALK    = 12
    local SPEED_SPRINT  = 25
    local isSprinting   = false
    -- Per-animation sounds
    local snd_Speed = nil
    local snd_Regen = nil
    local snd_Fusion = nil

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
        if snd_Speed then snd_Speed:Stop() end
        if snd_Regen then snd_Regen:Stop() end
        if snd_Fusion then snd_Fusion:Stop() end
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
        if name == "Speed" and snd_Speed then snd_Speed:Play() end
        if name == "Regen" and snd_Regen then snd_Regen:Play() end
        if name == "Fusion" and snd_Fusion then snd_Fusion:Play() end
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
        idle = loadAnim(figure, "ProtoCoilIdle.anim", true),
        walk = loadAnim(figure, "ProtoCoilWalk.anim", true),
        sprint = loadAnim(figure, "ProtoCoilRun.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["Speed"] = loadAnim(figure, "ProtoCoilSpeed.anim", false),
        ["Regen"] = loadAnim(figure, "ProtoCoilRegen.anim", false),
        ["Fusion"] = loadAnim(figure, "ProtoCoilFusion.anim", false),
        }

        -- init per-anim sounds
    snd_Speed = makeSound("ProtoCoilSpeedSound.mp3", hrp, 0.8, false)
    snd_Regen = makeSound("ProtoCoilRegenSound.mp3", hrp, 0.8, false)
    snd_Fusion = makeSound("ProtoCoilFusionSound.mp3", hrp, 0.9, false)

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then toggleSprint() end
        end, true, Enum.KeyCode.LeftAlt)
        ContextActions:SetTitle("GM_Sprint", "Sprint")
        ContextActions:SetPosition("GM_Sprint", UDim2.new(1, -120, 1, -110))


        ContextActions:BindAction("GM_Speed", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Speed") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Speed", "Speed")
        ContextActions:SetPosition("GM_Speed", UDim2.new(1, -200, 1, -110))

        ContextActions:BindAction("GM_Regen", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Regen") end
        end, true, Enum.KeyCode.X)
        ContextActions:SetTitle("GM_Regen", "Regen")
        ContextActions:SetPosition("GM_Regen", UDim2.new(1, -160, 1, -110))

        ContextActions:BindAction("GM_Fusion", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Fusion") end
        end, true, Enum.KeyCode.C)
        ContextActions:SetTitle("GM_Fusion", "Fusion")
        ContextActions:SetPosition("GM_Fusion", UDim2.new(1, -240, 1, -110))
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
        ContextActions:UnbindAction("GM_Speed")
        ContextActions:UnbindAction("GM_Regen")
        ContextActions:UnbindAction("GM_Fusion")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        stopAllAnimSounds()
    if snd_Speed then snd_Speed:Stop() snd_Speed:Destroy() snd_Speed = nil end
    if snd_Regen then snd_Regen:Stop() snd_Regen:Destroy() snd_Regen = nil end
    if snd_Fusion then snd_Fusion:Stop() snd_Fusion:Destroy() snd_Fusion = nil end

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