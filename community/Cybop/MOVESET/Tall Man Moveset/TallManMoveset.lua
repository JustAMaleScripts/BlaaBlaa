-- TallManMoveset.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/TallManMoveset.lua

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
    m.Name         = "Tall Man"
    m.Description  = "This is a Tall Man"
    m.InternalName = "TallManMoveset"

    m.Assets = {
        "Tall idlee.anim",
        "Tall Walk.anim",
        "Tall Stunned.anim",
        "TallManTheme(TAESE).mp3",
        "Tall Crounch.anim",
    }

    m.FlingEnabled = {
        ["Tall Stunned"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Tall Man", 18, Enum.TextXAlignment.Center)
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
    local SPEED_WALK    = 16
    local SPEED_SPRINT  = 18
    local bgSound       = nil

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
        if animCrouchIdle then animCrouchIdle.weight = 0 end
        if animCrouchWalk then animCrouchWalk.weight = 0 end
    end

    local function setBase(state)
        if currentBase == state then return end
        currentBase = state
        clearBase()
        -- rage overrides locomotion anims
        -- crouch overrides walk/idle anims
        if isCrouching then
            if (state == "walk" or state == "sprint") and animCrouchWalk then animCrouchWalk.weight = 1 return end
            if state == "idle" and animCrouchIdle then animCrouchIdle.weight = 1 return end
        end
        if baseAnims[state] then baseAnims[state].weight = 1 end
    end

    local function stopAllAnimSounds()
        -- no per-action sounds
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
        if isCrouching then endCrouch() end
    end

    local isCrouching = false

    local animCrouchIdle = nil
    local animCrouchWalk = nil

    local function endCrouch()
        if not isCrouching then return end
        isCrouching = false
        if figureRef then
            local hum = figureRef:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = SPEED_WALK end
        end
        if animCrouchIdle then animCrouchIdle.weight = 0 end
        if animCrouchWalk then animCrouchWalk.weight = 0 end
        ContextActions:SetTitle("GM_Crouch", "Crouch")
        currentBase = "none"
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
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false) end

        baseAnims = {
        idle = loadAnim(figure, "Tall idlee.anim", true),
        walk = loadAnim(figure, "Tall Walk.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["Tall Stunned"] = loadAnim(figure, "Tall Stunned.anim", false),
        }

        bgSound = makeSound("TallManTheme(TAESE).mp3", hrp, 0.5, true)
        bgSound:Play()

        -- crouch anims
        animCrouchIdle = loadAnim(figure, "Tall Crounch.anim", true)
        animCrouchWalk = loadAnim(figure, "Tall Crounch.anim", true)

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        ContextActions:BindAction("GM_Crouch", function(_, inputState, _)
            if inputState ~= Enum.UserInputState.Begin then return end
            if isCrouching then
                endCrouch()
            else
                isCrouching = true
                setSpeed(8)
                ContextActions:SetTitle("GM_Crouch", "Stand")
                currentBase = "none"
            end
        end, true, Enum.KeyCode.LeftControl)
        ContextActions:SetTitle("GM_Crouch", "Crouch")
        ContextActions:SetPosition("GM_Crouch", UDim2.new(1, -100, 1, -130))


        ContextActions:BindAction("GM_Tall_Stunned", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Tall Stunned") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Tall_Stunned", "Stunned")
        ContextActions:SetPosition("GM_Tall_Stunned", UDim2.new(1, -150, 1, -100))
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
                    setBase("walk")
                else
                    setBase("idle")
                end
            end
        end

        wasInAir = inAir
        local now = os.clock()
        for _, a in pairs(baseAnims) do if a.weight > 0 then a:Step(now) end end
        if animCrouchIdle and animCrouchIdle.weight > 0 then animCrouchIdle:Step(now) end
        if animCrouchWalk and animCrouchWalk.weight > 0 then animCrouchWalk:Step(now) end
        for a, start in pairs(actionStart) do if a.weight > 0 then a:Step(now - start) end end
    end

    -- DESTROY
    m.Destroy = function(figure)
        ContextActions:UnbindAction("GM_Crouch")
        ContextActions:UnbindAction("GM_Tall_Stunned")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        if bgSound then bgSound:Stop() bgSound:Destroy() bgSound = nil end
        stopAllAnimSounds()
        if isCrouching then endCrouch() end
        if animCrouchIdle then animCrouchIdle.weight = 0 end
        if animCrouchWalk then animCrouchWalk.weight = 0 end

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
        isCrouching = false
    end

    return m
end)

return modules
