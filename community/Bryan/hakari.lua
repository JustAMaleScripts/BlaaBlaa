-- hakari.lua

local modules = {}

table.insert(modules, function()

local m = {}

m.ModuleType  = "MOVESET"
m.Name        = "Hakari"
m.Description = "Domain Expansion: Idle Death Gamble"
m.InternalName = "hakari"

m.Assets = {
    -- BASE
    "hakari idle.anim",
    "hakari sprint.anim",
    "gojo jump.anim",

    -- SWAP ANIMATION (awake)
    "idle death.anim",

    -- MODE A actions (normal)
    "reserve balls.anim",
    "shutter doors.anim",
    "rough energy.anim",
    "fever breaker.anim",

    -- MODE B actions (awake)
    "lucky volley.anim",
    "lucky rushdown.anim",
    "overwhelming luck.anim",
    "energy surge.anim",

    -- LMB combo (hakari)
    "lmb 1.anim",
    "lmb 2.anim",
    "lmb 3.anim",
    "lmb 4.anim",

    -- SPECIAL
    "hakari special.anim",
    "hakari special 2.anim",

    -- SOUNDS
    "hakari domain.mp3",
}

m.Config = function(parent)
    Util_CreateText(parent, "Hakari", 18, Enum.TextXAlignment.Center)
end

m.SaveConfig = function() return {} end
m.LoadConfig = function() end

-- SERVICES
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")

-- ANIMATORS
local baseAnimator   = nil
local actionAnimator = nil

-- ANIMS
local baseAnims   = {}
local actionAnims = {}
local modeAAnims  = {}
local modeBAnims  = {}
local lmbAnims    = {}
local animJump    = nil
local animSwap    = nil
local animSpecial  = nil
local animSpecial2 = nil

-- SOUNDS
local actionSounds       = {}
local modeASounds        = {}
local modeBSounds        = {}
local bgSound            = nil
local domainSound        = nil
local currentActionSound = nil

-- STATE
local currentBase   = "idle"
local actionStart   = {}
local currentAction = nil
local modeB         = false

-- JUMP STATE
local wasInAir    = false
local swapPlaying = false
local swapStart   = 0

-- LMB STATE
local lmbStep        = 1
local lmbResetTimer  = 0
local LMB_RESET_TIME = 3.0

local figureRef = nil

-- ── sound helper ─────────────────────────────────────────────
local function makeSound(filename, parent, volume, looped)
    local s = Instance.new("Sound")
    s.SoundId = AssetGetContentId(filename)
    s.Volume  = volume or 0.8
    s.Looped  = looped or false
    s.Parent  = parent
    return s
end

-- LOAD ANIM
local function loadAnim(fig, file, looped)
    local a = AnimLib.Animator.new()
    a.rig    = fig
    a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
    a.looped = looped or false
    a.speed  = 1
    a.weight = 0
    return a
end

-- stop all base anims
local function clearBase()
    for _, a in pairs(baseAnims) do a.weight = 0 end
end

-- BASE SWITCH
local function setBase(state)
    if currentBase == state then return end
    currentBase = state
    clearBase()
    if baseAnims[state] then baseAnims[state].weight = 1 end
end

-- STOP ACTION SOUND
local function stopActionSound()
    if currentActionSound then
        currentActionSound:Stop()
        currentActionSound = nil
    end
end

-- STOP ACTION
local function stopAction()
    for _, anim in pairs(modeAAnims)  do anim.weight = 0 end
    for _, anim in pairs(modeBAnims)  do anim.weight = 0 end
    for _, anim in pairs(lmbAnims)    do anim.weight = 0 end
    if animSpecial  then animSpecial.weight  = 0 end
    if animSpecial2 then animSpecial2.weight = 0 end
    stopActionSound()
    currentAction = nil
end

-- GET ANIM OBJECT FOR CURRENT ACTION
local function getActionAnim(name)
    if not name then return nil end
    local isLmb = name:sub(1, 3) == "lmb"
    if isLmb then
        local step = tonumber(name:sub(4))
        return lmbAnims[step], isLmb
    elseif name == "special" then
        return animSpecial, false
    elseif name == "special2" then
        return animSpecial2, false
    else
        return actionAnims[name], false
    end
end

-- PLAY ACTION (locks character in place until anim ends)
local function playAction(name)
    local a = actionAnims[name]
    if not a then return end

    stopAction()

    a.weight = 1
    actionStart[a] = os.clock()
    currentAction = name

    local snd = actionSounds[name]
    if snd then
        snd:Play()
        currentActionSound = snd
    end
end

-- PLAY LMB STEP (locks character in place until anim ends)
local function playLmb(step)
    local a = lmbAnims[step]
    if not a then return end

    stopAction()

    a.weight = 1
    actionStart[a] = os.clock()
    currentAction = "lmb" .. step
end

-- PLAY SPECIAL
local function playSpecial()
    local a = modeB and animSpecial2 or animSpecial
    if not a then return end

    stopAction()

    a.weight = 1
    actionStart[a] = os.clock()
    currentAction = modeB and "special2" or "special"
end

-- SWAP MODE (awake toggle)
local function swapMode()
    stopAction()

    if animSwap then
        clearBase()
        currentBase           = "swap"
        animSwap.weight       = 1
        actionStart[animSwap] = os.clock()
        swapPlaying           = true
        swapStart             = os.clock()
    end

    modeB = not modeB

    if modeB then
        actionAnims  = modeBAnims
        actionSounds = modeBSounds
        ContextActionService:SetTitle("Hakari_Atk1",   "Volley")
        ContextActionService:SetTitle("Hakari_Atk2",   "Rush")
        ContextActionService:SetTitle("Hakari_Atk3",   "O.Luck")
        ContextActionService:SetTitle("Hakari_Atk4",   "E.Surge")
        ContextActionService:SetTitle("Hakari_Swap",   "unAwake")
        ContextActionService:SetTitle("Hakari_Special","Especial")
    else
        actionAnims  = modeAAnims
        actionSounds = modeASounds
        ContextActionService:SetTitle("Hakari_Atk1",   "Atk1")
        ContextActionService:SetTitle("Hakari_Atk2",   "Atk2")
        ContextActionService:SetTitle("Hakari_Atk3",   "Atk3")
        ContextActionService:SetTitle("Hakari_Atk4",   "Atk4")
        ContextActionService:SetTitle("Hakari_Swap",   "AWAKE")
        ContextActionService:SetTitle("Hakari_Special","Especial")
    end
end

-- INIT
m.Init = function(figure)
    figureRef = figure

    baseAnimator       = AnimLib.Animator.new()
    baseAnimator.rig   = figure
    actionAnimator     = AnimLib.Animator.new()
    actionAnimator.rig = figure

    local hrp = figure:FindFirstChild("HumanoidRootPart") or figure

    -- BASE ANIMS  (idle/sprint substituídos pelos do hakari)
    baseAnims = {
        idle = loadAnim(figure, "hakari idle.anim",   true),
        walk = loadAnim(figure, "hakari sprint.anim", true),
        jump = loadAnim(figure, "gojo jump.anim",     false),
    }

    animJump = baseAnims.jump

    -- SWAP = "idle death.anim" (animação de awake do hakari)
    animSwap = loadAnim(figure, "idle death.anim", false)

    -- SPECIAL ANIMS
    animSpecial  = loadAnim(figure, "hakari special.anim",   false)
    animSpecial2 = loadAnim(figure, "hakari special 2.anim", false)

    -- MODE A ANIMS (modo normal — ataques do hakari)
    modeAAnims = {
        ["reserve balls"]  = loadAnim(figure, "reserve balls.anim",  false),
        ["shutter doors"]  = loadAnim(figure, "shutter doors.anim",  false),
        ["rough energy"]   = loadAnim(figure, "rough energy.anim",   false),
        ["fever breaker"]  = loadAnim(figure, "fever breaker.anim",  false),
    }

    -- MODE B ANIMS (modo awake — ataques do hakari)
    modeBAnims = {
        ["lucky volley"]      = loadAnim(figure, "lucky volley.anim",      false),
        ["lucky rushdown"]    = loadAnim(figure, "lucky rushdown.anim",     false),
        ["overwhelming luck"] = loadAnim(figure, "overwhelming luck.anim",  false),
        ["energy surge"]      = loadAnim(figure, "energy surge.anim",       false),
    }

    -- LMB ANIMS (hakari lmb 1-4)
    lmbAnims = {
        [1] = loadAnim(figure, "lmb 1.anim", false),
        [2] = loadAnim(figure, "lmb 2.anim", false),
        [3] = loadAnim(figure, "lmb 3.anim", false),
        [4] = loadAnim(figure, "lmb 4.anim", false),
    }

    -- MODE A SOUNDS (sem sons específicos — adicione se necessário)
    modeASounds = {}

    -- MODE B SOUNDS (sem sons específicos por padrão — adicione se necessário)
    modeBSounds = {}

    -- DOMAIN SOUND — toca quando a animação de awake terminar (gerenciado no Update)
    domainSound = makeSound("hakari domain.mp3", hrp, 0.8, true)

    -- começa no modo A
    actionAnims  = modeAAnims
    actionSounds = modeASounds

    setBase("idle")

    -- ── BUTTONS ──────────────────────────────────────────────
    -- Posições espelhando exatamente o layout do gojo.lua

    -- LMB
    ContextActionService:BindAction("Hakari_LMB", function(_, inputState, _)
        if inputState ~= Enum.UserInputState.Begin then return end
        -- bloqueia novo lmb se ainda estiver em ação
        if currentAction then return end
        playLmb(lmbStep)
        if lmbStep < 4 then
            lmbStep = lmbStep + 1
            lmbResetTimer = LMB_RESET_TIME
        else
            lmbStep = 1
            lmbResetTimer = 0
        end
    end, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.T)
    ContextActionService:SetTitle("Hakari_LMB", "LMB")
    ContextActionService:SetPosition("Hakari_LMB", UDim2.new(1, -130, 1, -230))

    -- SWAP (awake)
    ContextActionService:BindAction("Hakari_Swap", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then swapMode() end
    end, true, Enum.KeyCode.G)
    ContextActionService:SetTitle("Hakari_Swap", "AWAKE")
    ContextActionService:SetPosition("Hakari_Swap", UDim2.new(1, -280, 1, -130))

    -- ATK1 (normal: reserve balls | awake: lucky volley)
    ContextActionService:BindAction("Hakari_Atk1", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            if currentAction then return end
            local name = modeB and "lucky volley" or "reserve balls"
            playAction(name)
        end
    end, true, Enum.KeyCode.E)
    ContextActionService:SetTitle("Hakari_Atk1", "Atk1")
    ContextActionService:SetPosition("Hakari_Atk1", UDim2.new(1, -180, 1, -130))

    -- ATK2 (normal: shutter doors | awake: lucky rushdown)
    ContextActionService:BindAction("Hakari_Atk2", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            if currentAction then return end
            local name = modeB and "lucky rushdown" or "shutter doors"
            playAction(name)
        end
    end, true, Enum.KeyCode.Q)
    ContextActionService:SetTitle("Hakari_Atk2", "Atk2")
    ContextActionService:SetPosition("Hakari_Atk2", UDim2.new(1, -230, 1, -130))

    -- ATK3 (normal: rough energy | awake: overwhelming luck)
    ContextActionService:BindAction("Hakari_Atk3", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            if currentAction then return end
            local name = modeB and "overwhelming luck" or "rough energy"
            playAction(name)
        end
    end, true, Enum.KeyCode.R)
    ContextActionService:SetTitle("Hakari_Atk3", "Atk3")
    ContextActionService:SetPosition("Hakari_Atk3", UDim2.new(1, -130, 1, -130))

    -- ATK4 (normal: fever breaker | awake: energy surge)
    ContextActionService:BindAction("Hakari_Atk4", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            if currentAction then return end
            local name = modeB and "energy surge" or "fever breaker"
            playAction(name)
        end
    end, true, Enum.KeyCode.F)
    ContextActionService:SetTitle("Hakari_Atk4", "Atk4")
    ContextActionService:SetPosition("Hakari_Atk4", UDim2.new(1, -130, 1, -180))

    -- ESPECIAL (normal: hakari special.anim | awake: hakari special 2.anim)
    ContextActionService:BindAction("Hakari_Special", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            if currentAction then return end
            playSpecial()
        end
    end, true, Enum.KeyCode.Z)
    ContextActionService:SetTitle("Hakari_Special", "Especial")
    ContextActionService:SetPosition("Hakari_Special", UDim2.new(1, -280, 1, -180))
end

-- UPDATE
m.Update = function(dt, figure)

    local hum = figure:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local inAir = hum.FloorMaterial == Enum.Material.Air

    -- ── SWAP ANIMATION auto-finish + tocar domain music ───────
    if swapPlaying and animSwap then
        local elapsed  = os.clock() - swapStart
        local duration = animSwap.track and animSwap.track.Time or 1.0
        if elapsed >= duration / (animSwap.speed or 1) then
            animSwap.weight = 0
            swapPlaying     = false
            currentBase     = "none"  -- força setBase a reaplicar

            -- toca hakari domain.mp3 ao entrar no awake
            if modeB and domainSound and not domainSound.IsPlaying then
                domainSound:Play()
            end
            -- para a música ao sair do awake
            if not modeB and domainSound and domainSound.IsPlaying then
                domainSound:Stop()
            end
        end
    end

    -- ── LMB COMBO RESET TIMER ────────────────────────────────
    if lmbResetTimer > 0 and currentAction == nil then
        lmbResetTimer = lmbResetTimer - dt
        if lmbResetTimer <= 0 then
            lmbResetTimer = 0
            lmbStep = 1
        end
    end

    -- ── AUTO-STOP current action and return to idle ───────────
    if currentAction then
        local a, isLmb = getActionAnim(currentAction)

        if a and actionStart[a] then
            local elapsed  = os.clock() - actionStart[a]
            local duration = a.track and a.track.Time or 0

            if duration > 0 and elapsed >= duration / (a.speed or 1) then
                -- zera a anim terminada
                a.weight = 0
                stopActionSound()
                currentAction = nil

                if isLmb then
                    lmbResetTimer = LMB_RESET_TIME
                end

                -- força idle imediatamente (sem frame em branco)
                currentBase = "none"
            end
        end
    end

    -- ── BASE STATE (idle / walk / jump) ───────────────────────
    -- Bloqueado durante qualquer ação (personagem fica parado)
    if not currentAction and not swapPlaying then
        if inAir then
            if not wasInAir then
                clearBase()
                currentBase           = "jump"
                animJump.weight       = 1
                actionStart[animJump] = os.clock()
            end
        else
            if wasInAir then
                animJump.weight = 0
            end
            local moving = hum.MoveDirection.Magnitude > 0.1
            if moving then
                setBase("walk")
            else
                setBase("idle")
            end
        end
    end

    wasInAir = inAir

    -- ── STEP ALL ANIMS ────────────────────────────────────────
    local now = os.clock()

    for _, a in pairs(baseAnims) do
        if a.weight > 0 then a:Step(now) end
    end

    if animSwap and animSwap.weight > 0 then
        animSwap:Step(now - swapStart)
    end

    for a, start in pairs(actionStart) do
        if a.weight > 0 then a:Step(now - start) end
    end
end

-- CLEANUP
m.Destroy = function()
    ContextActionService:UnbindAction("Hakari_LMB")
    ContextActionService:UnbindAction("Hakari_Swap")
    ContextActionService:UnbindAction("Hakari_Atk1")
    ContextActionService:UnbindAction("Hakari_Atk2")
    ContextActionService:UnbindAction("Hakari_Atk3")
    ContextActionService:UnbindAction("Hakari_Atk4")
    ContextActionService:UnbindAction("Hakari_Special")

    if domainSound then domainSound:Stop() domainSound:Destroy() domainSound = nil end
    stopActionSound()

    for _, s in pairs(modeASounds) do s:Stop() s:Destroy() end
    for _, s in pairs(modeBSounds) do s:Stop() s:Destroy() end

    baseAnimator   = nil
    actionAnimator = nil
    actionStart    = {}
    currentAction  = nil
    currentBase    = "idle"
    modeB          = false
    lmbStep        = 1
    lmbResetTimer  = 0
    figureRef      = nil
    wasInAir       = false
    swapPlaying    = false
    animJump       = nil
    animSwap       = nil
    animSpecial    = nil
    animSpecial2   = nil
    modeAAnims     = {}
    modeBAnims     = {}
    lmbAnims       = {}
    modeASounds    = {}
    modeBSounds    = {}
    actionAnims    = {}
    actionSounds   = {}
end

return m
end)

return modules
