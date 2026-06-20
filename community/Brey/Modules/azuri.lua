-- azuri.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/azuri.lua

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
    m.Name         = "azuri"
    m.Description  = "\"oh dear..\""
    m.InternalName = "azuri"

    m.Assets = {
        "azuriidle.anim",
        "azuriwalk.anim",
        "azuristaffcombo.anim",
        "azuridoublestaff.anim",
        "azurifire.anim",
        "azurispin.anim",
        "azurilightning.anim",
    }

    m.FlingEnabled = {
        ["staff combo"] = true,
        ["double staff"] = true,
        ["fireball"] = true,
        ["spin"] = true,
        ["lightning"] = true,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "azuri", 18, Enum.TextXAlignment.Center)
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
    local SPEED_WALK    = 19
    local SPEED_SPRINT  = 26

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
        idle = loadAnim(figure, "azuriidle.anim", true),
        walk = loadAnim(figure, "azuriwalk.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["staff combo"] = loadAnim(figure, "azuristaffcombo.anim", false),
        ["double staff"] = loadAnim(figure, "azuridoublestaff.anim", false),
        ["fireball"] = loadAnim(figure, "azurifire.anim", false),
        ["spin"] = loadAnim(figure, "azurispin.anim", false),
        ["lightning"] = loadAnim(figure, "azurilightning.anim", false),
        }

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)


        ContextActions:BindAction("GM_staff_combo", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("staff combo") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_staff_combo", "staff combo")
        ContextActions:SetPosition("GM_staff_combo", UDim2.new(1, -190, 1, -130))

        ContextActions:BindAction("GM_double_staff", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("double staff") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_double_staff", "double staff")
        ContextActions:SetPosition("GM_double_staff", UDim2.new(1, -190, 1, -190))

        ContextActions:BindAction("GM_fireball", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("fireball") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_fireball", "fireball")
        ContextActions:SetPosition("GM_fireball", UDim2.new(1, -250, 1, -130))

        ContextActions:BindAction("GM_spin", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("spin") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_spin", "spin")
        ContextActions:SetPosition("GM_spin", UDim2.new(1, -250, 1, -190))

        ContextActions:BindAction("GM_lightning", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("lightning") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_lightning", "lightning")
        ContextActions:SetPosition("GM_lightning", UDim2.new(1, -190, 1, -250))
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
        for a, start in pairs(actionStart) do if a.weight > 0 then a:Step(now - start) end end
    end

    -- DESTROY
    m.Destroy = function(figure)
        ContextActions:UnbindAction("GM_staff_combo")
        ContextActions:UnbindAction("GM_double_staff")
        ContextActions:UnbindAction("GM_fireball")
        ContextActions:UnbindAction("GM_spin")
        ContextActions:UnbindAction("GM_lightning")

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
    end

    return m
end)

return modules