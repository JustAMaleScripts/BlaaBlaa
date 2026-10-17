-- Souketsu1x1x1x1.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/Souketsu1x1x1x1.lua

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
    m.Name         = "Souketsu 1x1x1x1"
    m.Description  = "What if where hype moments and ufe aura"
    m.InternalName = "Souketsu1x1x1x1"

    m.Assets = {
        "1xSouketsuIdle.anim",
        "1xSouketsuWalk.anim",
        "1xSouketsuRun.anim",
        "1xSouketsuM1.anim",
        "1xSouketsuMassInfection.anim",
        "1xSouketsuEntanglement.anim",
        "1xSouketsuUnstable.anim",
    }

    m.FlingEnabled = {
        ["Slash"] = false,
        ["Mass Infection"] = false,
        ["Entanglement"] = false,
        ["Unstable Eye"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Souketsu 1x1x1x1", 18, Enum.TextXAlignment.Center)
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
        idle = loadAnim(figure, "1xSouketsuIdle.anim", true),
        walk = loadAnim(figure, "1xSouketsuWalk.anim", true),
        sprint = loadAnim(figure, "1xSouketsuRun.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["Slash"] = loadAnim(figure, "1xSouketsuM1.anim", false),
        ["Mass Infection"] = loadAnim(figure, "1xSouketsuMassInfection.anim", false),
        ["Entanglement"] = loadAnim(figure, "1xSouketsuEntanglement.anim", false),
        ["Unstable Eye"] = loadAnim(figure, "1xSouketsuUnstable.anim", false),
        }

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