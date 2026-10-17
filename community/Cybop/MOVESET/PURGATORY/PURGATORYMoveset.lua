-- PURGATORYMoveset.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/PURGATORYMoveset.lua

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
    m.Name         = "PURGATORY"
    m.Description  = "This Moveset is based in the animations of the game called PURGATORY, Really is a good game."
    m.InternalName = "PURGATORYMoveset"

    m.Assets = {
        "PURGATORYIdle.anim",
        "PURGATORYWalk.anim",
        "PURGATORYDash.anim",
        "PURGATORYSwordSlam.anim",
        "PURGATORYLungeSword.anim",
        "PURGATORYSwordM3.anim",
        "PURGATORYSwordM2.anim",
        "PURGATORYSwordM1.anim",
    }

    m.FlingEnabled = {
        ["Dash"] = false,
        ["Sword Slam"] = false,
        ["Lunge Sword"] = false,
        ["M3"] = false,
        ["M2"] = false,
        ["M1"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "PURGATORY", 18, Enum.TextXAlignment.Center)
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
    local SPEED_WALK    = 17
    local SPEED_SPRINT  = 26
    local isSprinting   = false

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
        idle = loadAnim(figure, "PURGATORYIdle.anim", true),
        walk = loadAnim(figure, "PURGATORYWalk.anim", true),
        sprint = loadAnim(figure, "PURGATORYWalk.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["Dash"] = loadAnim(figure, "PURGATORYDash.anim", false),
        ["Sword Slam"] = loadAnim(figure, "PURGATORYSwordSlam.anim", false),
        ["Lunge Sword"] = loadAnim(figure, "PURGATORYLungeSword.anim", false),
        ["M3"] = loadAnim(figure, "PURGATORYSwordM3.anim", false),
        ["M2"] = loadAnim(figure, "PURGATORYSwordM2.anim", false),
        ["M1"] = loadAnim(figure, "PURGATORYSwordM1.anim", false),
        }

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then toggleSprint() end
        end, true, Enum.KeyCode.LeftAlt)
        ContextActions:SetTitle("GM_Sprint", "Sprint")
        ContextActions:SetPosition("GM_Sprint", UDim2.new(1, -75, 1, -100))


        ContextActions:BindAction("GM_Dash", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Dash") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Dash", "Dash")
        ContextActions:SetPosition("GM_Dash", UDim2.new(1, -120, 1, -60))

        ContextActions:BindAction("GM_Sword_Slam", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Sword Slam") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Sword_Slam", "Sword Slam")
        ContextActions:SetPosition("GM_Sword_Slam", UDim2.new(1, -165, 1, -60))

        ContextActions:BindAction("GM_Lunge_Sword", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Lunge Sword") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Lunge_Sword", "Lunge Sword")
        ContextActions:SetPosition("GM_Lunge_Sword", UDim2.new(1, -210, 1, -60))

        ContextActions:BindAction("GM_M3", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("M3") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_M3", "M3")
        ContextActions:SetPosition("GM_M3", UDim2.new(1, -210, 1, -100))

        ContextActions:BindAction("GM_M2", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("M2") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_M2", "M2")
        ContextActions:SetPosition("GM_M2", UDim2.new(1, -165, 1, -100))

        ContextActions:BindAction("GM_M1", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("M1") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_M1", "M1")
        ContextActions:SetPosition("GM_M1", UDim2.new(1, -120, 1, -100))
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
        ContextActions:UnbindAction("GM_Dash")
        ContextActions:UnbindAction("GM_Sword_Slam")
        ContextActions:UnbindAction("GM_Lunge_Sword")
        ContextActions:UnbindAction("GM_M3")
        ContextActions:UnbindAction("GM_M2")
        ContextActions:UnbindAction("GM_M1")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        stopAllAnimSounds()

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