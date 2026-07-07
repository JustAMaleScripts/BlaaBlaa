-- Ch4rgeK1ddMoveset.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/Ch4rgeK1ddMoveset.lua

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
    m.Name         = "Ch4rgeK1dd"
    m.Description  = "A Somewhat more Advanced Version of Coolkid, And he is green. ChargeKidd"
    m.InternalName = "Ch4rgeK1ddMoveset"
    m.Notifications = true

    m.Assets = {
        "Ch4rgeK1dd Idle.anim",
        "Ch4rgeK1dd Walk.anim",
        "Ch4rgeK1dd Run.anim",
        "Ch4rgeK1ddSlash.anim",
        "Ch4rgeK1dd WalkSpeed.anim",
        "Ch4rgeK1dd ChargeNature.anim",
        "Ch4rgeK1ddFingerGun.anim",
        "Ch4rgeK1ddMinion.anim",
    }

    m.FlingEnabled = {
        ["Slash"] = false,
        ["Walkspeed"] = false,
        ["Charge Nature"] = false,
        ["Finger Gun"] = false,
        ["Minion"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Ch4rgeK1dd", 18, Enum.TextXAlignment.Center)
        Util_CreateSeparator(parent)
        Util_CreateSeparator(parent)
        Util_CreateSwitch(parent, "Text Notifications", m.Notifications).Changed:Connect(function(v)
            m.Notifications = v
        end)
    end

    m.SaveConfig = function()
        local t = {}
        t.Notifications = m.Notifications
        return t
    end

    m.LoadConfig = function(save)
        if save.Notifications ~= nil then m.Notifications = save.Notifications end
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
    local SPEED_WALK    = 10
    local SPEED_SPRINT  = 28
    local isSprinting   = false
    local chatConn      = nil

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

    -- Overhead chat text (same pattern as Immortality Lord / Banisher)
    -- onChat shows a typewriter label in HiddenGui
    local function onChat(message)
        if not m.Notifications then return end
        local prefix = "Ch4rgeK1dd"
        local text = Instance.new("TextLabel")
        text.Name = RandomString()
        text.Position = UDim2.new(0, 0, 0.95, 0)
        text.Size = UDim2.new(1, 0, 0.05, 0)
        text.BackgroundTransparency = 1
        text.Font = Enum.Font.GothamBold
        text.TextScaled = true
        text.TextColor3 = Color3.new(0, 255, 0)
        text.TextStrokeTransparency = 1
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Parent = HiddenGui
        task.spawn(function()
            local cps = 30
            local t = os.clock()
            local ll = 0
            repeat
                task.wait()
                local l = math.floor((os.clock() - t) * cps)
                if l > ll then
                    ll = l
                    text.Text = prefix .. string.sub(message, 1, l)
                end
            until ll >= #message
            text.Text = prefix .. message
            task.wait(3)
            if text.Parent then text:Destroy() end
        end)
    end

    local function setupChat()
        -- OnPlayerChatted is a BindableEvent injected by reanim
        -- Connect to .Event which fires (player, message)
        chatConn = OnPlayerChatted.Event:Connect(function(plr, message)
            if plr ~= Player then return end
            onChat(message)
        end)
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
        idle = loadAnim(figure, "Ch4rgeK1dd Idle.anim", true),
        walk = loadAnim(figure, "Ch4rgeK1dd Walk.anim", true),
        sprint = loadAnim(figure, "Ch4rgeK1dd Run.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["Slash"] = loadAnim(figure, "Ch4rgeK1ddSlash.anim", false),
        ["Walkspeed"] = loadAnim(figure, "Ch4rgeK1dd WalkSpeed.anim", false),
        ["Charge Nature"] = loadAnim(figure, "Ch4rgeK1dd ChargeNature.anim", false),
        ["Finger Gun"] = loadAnim(figure, "Ch4rgeK1ddFingerGun.anim", false),
        ["Minion"] = loadAnim(figure, "Ch4rgeK1ddMinion.anim", false),
        }
        setupChat()

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
        ContextActions:SetPosition("GM_Slash", UDim2.new(1, -190, 1, -100))

        ContextActions:BindAction("GM_Walkspeed", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Walkspeed") end
        end, true, Enum.KeyCode.X)
        ContextActions:SetTitle("GM_Walkspeed", "Walkspeed")
        ContextActions:SetPosition("GM_Walkspeed", UDim2.new(1, -230, 1, -100))

        ContextActions:BindAction("GM_Charge_Nature", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Charge Nature") end
        end, true, Enum.KeyCode.C)
        ContextActions:SetTitle("GM_Charge_Nature", "Charge Nature")
        ContextActions:SetPosition("GM_Charge_Nature", UDim2.new(1, -270, 1, -100))

        ContextActions:BindAction("GM_Finger_Gun", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Finger Gun") end
        end, true, Enum.KeyCode.V)
        ContextActions:SetTitle("GM_Finger_Gun", "Finger Gun")
        ContextActions:SetPosition("GM_Finger_Gun", UDim2.new(1, -190, 1, -140))

        ContextActions:BindAction("GM_Minion", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Minion") end
        end, true, Enum.KeyCode.B)
        ContextActions:SetTitle("GM_Minion", "Minion")
        ContextActions:SetPosition("GM_Minion", UDim2.new(1, -230, 1, -140))
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
        ContextActions:UnbindAction("GM_Walkspeed")
        ContextActions:UnbindAction("GM_Charge_Nature")
        ContextActions:UnbindAction("GM_Finger_Gun")
        ContextActions:UnbindAction("GM_Minion")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        stopAllAnimSounds()
        if chatConn then chatConn:Disconnect() chatConn = nil end

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