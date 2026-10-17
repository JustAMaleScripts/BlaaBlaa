-- MrGameAndWatchMoveset.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/MrGameAndWatchMoveset.lua

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
    m.Name         = "Mr. Game & Watch"
    m.Description  = "This guy is Actually Pretty strong"
    m.InternalName = "MrGameAndWatchMoveset"

    m.Assets = {
        "G&W Idle.anim",
        "G&W Walk.anim",
        "G&W Run.anim",
        "G&W Roll Slash.anim",
        "G&W Lunge.anim",
        "G&W Chair.anim",
        "G&W Dodge.anim",
        "RollHitSound.mp3",
        "G&W Dodge Sound.mp3",
    }

    m.FlingEnabled = {
        ["Roll Slash"] = true,
        ["Lunge"] = true,
        ["Chair"] = true,
        ["Dodge"] = false,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Mr. Game & Watch", 18, Enum.TextXAlignment.Center)
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
    local snd_Roll_Slash = nil
    local snd_Dodge = nil

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
        if snd_Roll_Slash then snd_Roll_Slash:Stop() end
        if snd_Dodge then snd_Dodge:Stop() end
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
        if name == "Roll Slash" and snd_Roll_Slash then snd_Roll_Slash:Play() end
        if name == "Dodge" and snd_Dodge then snd_Dodge:Play() end
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
        idle = loadAnim(figure, "G&W Idle.anim", true),
        walk = loadAnim(figure, "G&W Walk.anim", true),
        sprint = loadAnim(figure, "G&W Run.anim", true),
        }
        animJump = baseAnims.jump

        actionAnims = {
        ["Roll Slash"] = loadAnim(figure, "G&W Roll Slash.anim", false),
        ["Lunge"] = loadAnim(figure, "G&W Lunge.anim", false),
        ["Chair"] = loadAnim(figure, "G&W Chair.anim", false),
        ["Dodge"] = loadAnim(figure, "G&W Dodge.anim", false),
        }

        -- init per-anim sounds
    snd_Roll_Slash = makeSound("RollHitSound.mp3", hrp, 0.8, false)
    snd_Dodge = makeSound("G&W Dodge Sound.mp3", hrp, 0.8, false)

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then toggleSprint() end
        end, true, Enum.KeyCode.LeftAlt)
        ContextActions:SetTitle("GM_Sprint", "Sprint")
        ContextActions:SetPosition("GM_Sprint", UDim2.new(1, -120, 1, -110))


        ContextActions:BindAction("GM_Roll_Slash", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Roll Slash") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Roll_Slash", "Roll Slash")
        ContextActions:SetPosition("GM_Roll_Slash", UDim2.new(1, -200, 1, -110))

        ContextActions:BindAction("GM_Lunge", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Lunge") end
        end, true, Enum.KeyCode.X)
        ContextActions:SetTitle("GM_Lunge", "Lunge")
        ContextActions:SetPosition("GM_Lunge", UDim2.new(1, -160, 1, -110))

        ContextActions:BindAction("GM_Chair", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Chair") end
        end, true, Enum.KeyCode.C)
        ContextActions:SetTitle("GM_Chair", "Chair")
        ContextActions:SetPosition("GM_Chair", UDim2.new(1, -240, 1, -110))

        ContextActions:BindAction("GM_Dodge", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Dodge") end
        end, true, Enum.KeyCode.V)
        ContextActions:SetTitle("GM_Dodge", "Dodge")
        ContextActions:SetPosition("GM_Dodge", UDim2.new(1, -280, 1, -110))
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
        ContextActions:UnbindAction("GM_Roll_Slash")
        ContextActions:UnbindAction("GM_Lunge")
        ContextActions:UnbindAction("GM_Chair")
        ContextActions:UnbindAction("GM_Dodge")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        stopAllAnimSounds()
    if snd_Roll_Slash then snd_Roll_Slash:Stop() snd_Roll_Slash:Destroy() snd_Roll_Slash = nil end
    if snd_Dodge then snd_Dodge:Stop() snd_Dodge:Destroy() snd_Dodge = nil end

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