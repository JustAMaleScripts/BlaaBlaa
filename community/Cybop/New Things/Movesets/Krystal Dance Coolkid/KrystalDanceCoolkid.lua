-- KrystalDanceCoolkid.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/KrystalDanceCoolkid.lua

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
    m.Name         = "Krystal Dance Coolkid"
    m.Description  = "The one and only!"
    m.InternalName = "KrystalDanceCoolkid"

    m.Assets = {
        "KrystalDanceCoolkidIdle.anim",
        "KrystalDanceCoolkidWalk.anim",
        "KrystalDanceCoolkidRun.anim",
        "KrystalDanceCoolkidM1.anim",
        "KrystalDanceCoolkidPizzaDelivery.anim",
        "KrystalDanceCoolkidWalkspeedOverride.anim",
        "KrystalDanceStunt.anim",
        "KrystalDanceCoolkidKill.anim",
        "KrystalDanceCoolkidExecuteSpecial.anim",
        "KrystalDanceCoolkidTheme.mp3",
    }

    m.FlingEnabled = {
        ["M1"] = false,
        ["Pizza Delivery"] = false,
        ["Walkspeed Override"] = false,
        ["Stun"] = false,
        ["Kill"] = false,
        ["Execute Special"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Krystal Dance Coolkid", 18, Enum.TextXAlignment.Center)
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
    local SPEED_SPRINT  = 28
    local isSprinting   = false
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
        idle = loadAnim(figure, "KrystalDanceCoolkidIdle.anim", true),
        walk = loadAnim(figure, "KrystalDanceCoolkidWalk.anim", true),
        sprint = loadAnim(figure, "KrystalDanceCoolkidRun.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["M1"] = loadAnim(figure, "KrystalDanceCoolkidM1.anim", false),
        ["Pizza Delivery"] = loadAnim(figure, "KrystalDanceCoolkidPizzaDelivery.anim", false),
        ["Walkspeed Override"] = loadAnim(figure, "KrystalDanceCoolkidWalkspeedOverride.anim", false),
        ["Stun"] = loadAnim(figure, "KrystalDanceStunt.anim", false),
        ["Kill"] = loadAnim(figure, "KrystalDanceCoolkidKill.anim", false),
        ["Execute Special"] = loadAnim(figure, "KrystalDanceCoolkidExecuteSpecial.anim", false),
        }

        bgSound = makeSound("KrystalDanceCoolkidTheme.mp3", hrp, 0.5, true)
        bgSound:Play()

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then toggleSprint() end
        end, true, Enum.KeyCode.LeftAlt)
        ContextActions:SetTitle("GM_Sprint", "Sprint")
        ContextActions:SetPosition("GM_Sprint", UDim2.new(1, -120, 1, -110))


        ContextActions:BindAction("GM_M1", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("M1") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_M1", "M1")
        ContextActions:SetPosition("GM_M1", UDim2.new(1, -180, 1, -110))

        ContextActions:BindAction("GM_Pizza_Delivery", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Pizza Delivery") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Pizza_Delivery", "Pizza Delivery")
        ContextActions:SetPosition("GM_Pizza_Delivery", UDim2.new(1, -230, 1, -110))

        ContextActions:BindAction("GM_Walkspeed_Override", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Walkspeed Override") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Walkspeed_Override", "Walkspeed Override")
        ContextActions:SetPosition("GM_Walkspeed_Override", UDim2.new(1, -280, 1, -110))

        ContextActions:BindAction("GM_Stun", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Stun") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Stun", "Stun")
        ContextActions:SetPosition("GM_Stun", UDim2.new(1, -120, 1, -170))

        ContextActions:BindAction("GM_Kill", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Kill") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Kill", "Kill")
        ContextActions:SetPosition("GM_Kill", UDim2.new(1, -180, 1, -170))

        ContextActions:BindAction("GM_Execute_Special", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Execute Special") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Execute_Special", "Execute Special")
        ContextActions:SetPosition("GM_Execute_Special", UDim2.new(1, -230, 1, -170))
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
        ContextActions:UnbindAction("GM_Pizza_Delivery")
        ContextActions:UnbindAction("GM_Walkspeed_Override")
        ContextActions:UnbindAction("GM_Stun")
        ContextActions:UnbindAction("GM_Kill")
        ContextActions:UnbindAction("GM_Execute_Special")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        if bgSound then bgSound:Stop() bgSound:Destroy() bgSound = nil end
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