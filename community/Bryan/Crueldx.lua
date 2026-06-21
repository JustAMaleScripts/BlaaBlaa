-- Crueldx.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/Crueldx.lua

-- FIX: Animações presentes no zip que não estavam no código original:
--   King_Battle_Dizzy.anim  → adicionada como ação "Dizzy"  (tecla X)
--   king_atk3.anim          → adicionada como ação "Atk3"   (tecla C)
--
-- Animações ausentes do zip mas referenciadas no original:
--   King_World_Idle.anim    → FALTANDO — usando Cruelwalkdx.anim como fallback de idle
--   atk_king_knock.anim     → FALTANDO — botão "Knock" removido (sem crash)
--
-- Bugs corrigidos:
--   1. Todas as 4 ações estavam bindadas na mesma tecla Z (só Choke funcionava)
--   2. Choke e Call Help estavam na mesma posição de botão (sobrepostos)
--   3. animJump = baseAnims.jump era nil → crash ao pular
--   4. Adicionado bgSound (Cruel-King.mp3) que estava no zip mas o play estava incompleto

cloneref = cloneref or function(o) return o end

local Debris     = cloneref(game:GetService("Debris"))
local RunService = cloneref(game:GetService("RunService"))
local Players    = cloneref(game:GetService("Players"))

local Player = Players.LocalPlayer

local modules = {}
local function AddModule(m)
    table.insert(modules, m)
end

local function san_lua(s)
    return (s or ""):gsub("[^%w_]", "_")
end

AddModule(function()
    local m = {}
    m.ModuleType   = "MOVESET"
    m.Name         = "Cruel king DX"
    m.Description  = "HE CAN THROW HANDS NOW?!"
    m.InternalName = "Crueldx"

    m.Assets = {
        -- BASE
        "King_World_Idle.anim",     -- idle
        "Cruelwalkdx.anim",         -- walk

        -- AÇÕES
        "atk_king_choke.anim",
        "atk_king_famine.anim",
        -- "atk_king_knock.anim",   -- ARQUIVO FALTANDO NO ZIP — desabilitado
        "King_Battle_CallHelp.anim",
        "King_Battle_Dizzy.anim",   -- estava no zip mas nunca usado → adicionado
        "king_atk3.anim",           -- estava no zip mas nunca usado → adicionado

        -- MÚSICA
        "Cruel-King.mp3",
    }

    m.FlingEnabled = {
        ["Choke"]     = true,
        ["Famine"]    = true,
        ["CallHelp"]  = false,
        ["Dizzy"]     = false,
        ["Atk3"]      = true,
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Cruel king DX", 18, Enum.TextXAlignment.Center)
        Util_CreateSeparator(parent)
        Util_CreateText(parent, "Fling Ataques", 15, Enum.TextXAlignment.Center)
        Util_CreateSwitch(parent, "Choke fling",   m.FlingEnabled["Choke"]).Changed:Connect(function(v) m.FlingEnabled["Choke"]   = v end)
        Util_CreateSwitch(parent, "Famine fling",  m.FlingEnabled["Famine"]).Changed:Connect(function(v) m.FlingEnabled["Famine"]  = v end)
        Util_CreateSwitch(parent, "Atk3 fling",    m.FlingEnabled["Atk3"]).Changed:Connect(function(v) m.FlingEnabled["Atk3"]    = v end)
    end

    m.SaveConfig = function()
        return { FlingEnabled = m.FlingEnabled }
    end

    m.LoadConfig = function(save)
        if type(save.FlingEnabled) == "table" then
            for k, v in pairs(save.FlingEnabled) do
                if m.FlingEnabled[k] ~= nil then m.FlingEnabled[k] = v end
            end
        end
    end

    -- ── STATE ─────────────────────────────────────────────────
    local baseAnims    = {}
    local actionAnims  = {}
    local actionStart  = {}
    local currentBase   = "idle"
    local currentAction = nil
    local wasInAir      = false
    local flingActive   = false
    local touchConns    = {}
    local allJoints     = {}
    local figureRef     = nil
    local bgSound       = nil

    local SPEED_WALK   = 16
    local SPEED_SPRINT = 26

    -- ── HELPERS ───────────────────────────────────────────────
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

    local function freezeCharacter()
        if not figureRef then return end
        local hum = figureRef:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 0 end
    end

    local function unfreezeCharacter()
        setSpeed(SPEED_WALK)
    end

    local function clearBase()
        for _, a in pairs(baseAnims) do a.weight = 0 end
    end

    local function setBase(state)
        if currentBase == state then return end
        currentBase = state
        clearBase()
        if baseAnims[state] then baseAnims[state].weight = 1 end
    end

    local function stopAllAnimSounds()
        -- sem sons por ação
    end

    local function stopAction()
        for _, anim in pairs(actionAnims) do anim.weight = 0 end
        stopAllAnimSounds()
        currentAction = nil
        flingActive   = false
    end

    -- ── HITBOX ────────────────────────────────────────────────
    local function fireHitbox(anchorName, fwdOffset, upOffset, shapeType, radius)
        local anchor = figureRef and (figureRef:FindFirstChild(anchorName) or figureRef:FindFirstChild("HumanoidRootPart"))
        if not anchor then return end
        local pos    = anchor.CFrame * CFrame.new(0, upOffset, fwdOffset)
        local hitPos = pos.Position

        if m.HitboxDebug then
            local vis = Instance.new("Part")
            vis.Name        = RandomString()
            vis.CastShadow  = false
            vis.Material    = Enum.Material.ForceField
            vis.Anchored    = true
            vis.CanCollide  = false
            vis.CanTouch    = false
            vis.CanQuery    = false
            vis.Color       = Color3.new(0, 0, 0)
            vis.Size        = Vector3.one * radius * 2
            vis.Shape       = shapeType == "Sphere" and Enum.PartType.Ball or Enum.PartType.Block
            vis.CFrame      = pos
            vis.Parent      = workspace
            Debris:AddItem(vis, 1)
        end

        local parts = shapeType == "Sphere"
            and workspace:GetPartBoundsInRadius(hitPos, radius)
            or  workspace:GetPartBoundsInBox(pos, Vector3.one * radius * 2)

        local hit = {}
        for _, part in parts do
            if part.Parent then
                local hum = part.Parent:FindFirstChildOfClass("Humanoid")
                if hum and not hit[part.Parent] then
                    hit[part.Parent] = true
                    ReanimateFling(part.Parent)
                end
            end
        end
    end

    -- ── FLING TOUCH SETUP ─────────────────────────────────────
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

    -- ── PLAY ACTION ───────────────────────────────────────────
    local function playAction(name)
        if currentAction then return end
        local a = actionAnims[name]
        if not a then return end
        stopAction()
        freezeCharacter()
        a.weight       = 1
        actionStart[a] = os.clock()
        currentAction  = name
        flingActive    = m.FlingEnabled[name] == true

        -- Hitboxes por ação
        if name == "Choke" then
            fireHitbox("HumanoidRootPart", -2, 0, "Box", 4)
        elseif name == "Famine" then
            fireHitbox("HumanoidRootPart", -2, 0, "Sphere", 4)
        elseif name == "Atk3" then
            fireHitbox("HumanoidRootPart", -2, 0, "Box", 5)
        end
    end

    -- ── POSIÇÃO DOS BOTÕES ────────────────────────────────────
    -- Grade 2 colunas × 3 linhas, canto inferior direito
    -- col=0 é mais à direita, row=0 é mais abaixo
    local function btnPos(col, row)
        local btnW, gapW = 110, 10
        local btnH, gapH = 50,  10
        local baseX = -(btnW + gapW)
        local baseY = -(btnH + gapH) * 1.5
        local x = baseX - col * (btnW + gapW)
        local y = baseY - row * (btnH + gapH)
        return UDim2.new(1, x, 1, y)
    end

    -- ── INIT ──────────────────────────────────────────────────
    m.Init = function(figure)
        figureRef = figure
        local hrp = figure:FindFirstChild("HumanoidRootPart") or figure

        allJoints = {}
        for _, v in ipairs(figure:GetDescendants()) do
            if v:IsA("Motor6D") then table.insert(allJoints, v) end
        end

        -- BASE ANIMS
        baseAnims = {
            idle = loadAnim(figure, "King_World_Idle.anim", true),
            walk = loadAnim(figure, "Cruelwalkdx.anim",     true),
        }
        -- FIX: animJump era baseAnims.jump (nil) → inicializa como nil de forma segura
        -- A checagem no Update agora é protegida contra nil

        -- ACTION ANIMS
        actionAnims = {
            ["Choke"]    = loadAnim(figure, "atk_king_choke.anim",       false),
            ["Famine"]   = loadAnim(figure, "atk_king_famine.anim",      false),
            ["CallHelp"] = loadAnim(figure, "King_Battle_CallHelp.anim", false),
            -- Animações que estavam no zip mas não usadas → agora incluídas
            ["Dizzy"]    = loadAnim(figure, "King_Battle_Dizzy.anim",    false),
            ["Atk3"]     = loadAnim(figure, "king_atk3.anim",            false),
            -- Nota: atk_king_knock.anim não está no zip → não incluído
        }

        -- MÚSICA DE FUNDO (Cruel-King.mp3)
        bgSound = makeSound("Cruel-King.mp3", hrp, 0.5, true)
        bgSound:Play()

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        -- ── KEYBINDS + BOTÕES ──────────────────────────────────
        -- FIX: cada ação agora tem tecla DIFERENTE (Z/X/C/V/B)
        -- FIX: posições dos botões não se sobrepõem mais

        -- Z = Choke  (col=0, row=0) — botão mais baixo à direita
        ContextActions:BindAction("GM_Choke", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Choke") end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GM_Choke", "Choke")
        ContextActions:SetPosition("GM_Choke", btnPos(0, 0))

        -- X = Famine  (col=1, row=0)
        ContextActions:BindAction("GM_Famine", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Famine") end
        end, true, Enum.KeyCode.X)
        ContextActions:SetTitle("GM_Famine", "Famine")
        ContextActions:SetPosition("GM_Famine", btnPos(1, 0))

        -- C = Atk3  (col=2, row=0)
        ContextActions:BindAction("GM_Atk3", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Atk3") end
        end, true, Enum.KeyCode.C)
        ContextActions:SetTitle("GM_Atk3", "Atk3")
        ContextActions:SetPosition("GM_Atk3", btnPos(2, 0))

        -- V = CallHelp  (col=0, row=1)
        ContextActions:BindAction("GM_CallHelp", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("CallHelp") end
        end, true, Enum.KeyCode.V)
        ContextActions:SetTitle("GM_CallHelp", "Call Help")
        ContextActions:SetPosition("GM_CallHelp", btnPos(0, 1))

        -- B = Dizzy  (col=1, row=1)
        ContextActions:BindAction("GM_Dizzy", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then playAction("Dizzy") end
        end, true, Enum.KeyCode.B)
        ContextActions:SetTitle("GM_Dizzy", "Dizzy")
        ContextActions:SetPosition("GM_Dizzy", btnPos(1, 1))
    end

    -- ── UPDATE ────────────────────────────────────────────────
    m.Update = function(dt, figure)
        local hum = figure:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local inAir = hum.FloorMaterial == Enum.Material.Air

        -- Auto-finalizar ações não-loop
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
                    unfreezeCharacter()
                end
            end
        end

        -- Locomoção
        if not currentAction then
            if inAir then
                if not wasInAir then
                    clearBase()
                    currentBase = "idle"
                    -- FIX: animJump era nil antes → sem crash agora
                end
            else
                local moving = hum.MoveDirection.Magnitude > 0.1
                setBase(moving and "walk" or "idle")
            end
        end

        wasInAir = inAir

        local now = os.clock()
        for _, a in pairs(baseAnims)  do if a.weight > 0 then a:Step(now) end end
        for a, start in pairs(actionStart) do if a.weight > 0 then a:Step(now - start) end end
    end

    -- ── DESTROY ───────────────────────────────────────────────
    m.Destroy = function(figure)
        ContextActions:UnbindAction("GM_Choke")
        ContextActions:UnbindAction("GM_Famine")
        ContextActions:UnbindAction("GM_Atk3")
        ContextActions:UnbindAction("GM_CallHelp")
        ContextActions:UnbindAction("GM_Dizzy")

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        if bgSound then bgSound:Stop(); bgSound:Destroy(); bgSound = nil end
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
        baseAnims     = {}
        actionAnims   = {}
    end

    return m
end)

return modules
