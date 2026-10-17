-- OldUnfairnessExpungedModuleMic.lua (Versão Limpa - Estilo Silly Billy)

local modules = {}

table.insert(modules, function()
    local m = {}

    m.ModuleType   = "MOVESET"
    m.Name         = "Old Unfairness Expunged"
    m.Description  = "arrows fnf"
    m.InternalName = "OldUnfairnessExpungedModuleMic"

    m.Assets = {
        "OldUnfairnessMicIdle.anim",
        "OldUnfairnessMicLeft.anim",
        "OldUnfairnessMicDown.anim",
        "OldUnfairnessMicUp.anim",
        "OldUnfairnessMicRight.anim",
        "OldUnfairnessExpungedSong.mp3",
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Old Unfairness Expunged", 20, Enum.TextXAlignment.Center)
        Util_CreateSeparator(parent)
        Util_CreateText(parent,
            "Teclas:\n"..
            "  Left  = A\n"..
            "  Down  = S\n"..
            "  Up    = W\n"..
            "  Right = D",
            14, Enum.TextXAlignment.Left)
    end

    m.SaveConfig = function() return {} end
    m.LoadConfig  = function() end

    -- Services
    local Players              = game:GetService("Players")
    local ContextActionService = game:GetService("ContextActionService")

    -- Animations
    local animIdle
    local animLeft, animDown, animUp, animRight
    local bgMusic = nil

    -- State
    local allAnims     = {}
    local animStart    = {}
    local currentAction = nil
    local destroyed    = false
    local figureRef    = nil

    local guiRef = nil

    -- Helpers
    local function startFresh(anim)
        animStart[anim] = os.clock()
        anim.weight = 1
    end

    local function setOnly(anim)
        for _, a in ipairs(allAnims) do a.weight = 0 end
        if anim then
            startFresh(anim)
        end
    end

    local function animLen(anim, fallback)
        if anim and anim.track and anim.track.Time then
            return anim.track.Time
        end
        return fallback or 1.0
    end

    local function playAction(anim)
        if not anim then return end
        setOnly(anim)  -- Permite repetir a qualquer momento
    end

    -- Button Creator
    local function makeBtn(parent, label, w, h, posX, posY, onClick)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, w, 0, h)
        btn.Position = UDim2.new(0, posX, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(72, 72, 72)
        btn.BorderSizePixel = 0
        btn.Text = label
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.TextWrapped = true
        btn.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        btn.MouseButton1Down:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            if onClick then onClick() end
        end)
        btn.MouseButton1Up:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(72, 72, 72)
        end)
        return btn
    end

    -- Init
    m.Init = function(figure)
        destroyed = false
        figureRef = figure

        local function loadAnim(file, looped)
            local a = AnimLib.Animator.new()
            a.rig = figure
            a.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
            a.looped = looped or false
            a.speed = 1
            a.weight = 0
            animStart[a] = os.clock()
            return a
        end

        -- Load animations
        animIdle  = loadAnim("OldUnfairnessMicIdle.anim", true)
        animLeft  = loadAnim("OldUnfairnessMicLeft.anim", false)
        animDown  = loadAnim("OldUnfairnessMicDown.anim", false)
        animUp    = loadAnim("OldUnfairnessMicUp.anim", false)
        animRight = loadAnim("OldUnfairnessMicRight.anim", false)

        allAnims = {animIdle, animLeft, animDown, animUp, animRight}

        -- Disable movement
        local hum = figure:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            hum.AutoRotate = false
        end

        -- Background Music
        local hrp = figure:FindFirstChild("HumanoidRootPart") or figure
        bgMusic = Instance.new("Sound")
        bgMusic.SoundId = AssetGetContentId("OldUnfairnessExpungedSong.mp3")
        bgMusic.Volume = 0.5
        bgMusic.Looped = true
        bgMusic.Parent = hrp
        bgMusic:Play()

        -- GUI
        local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "ShunksGui"
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent = playerGui
        guiRef = sg

        -- Container de botões
        local BTN_W = 90
        local BTN_H = 90
        local BTN_GAP = 8
        local TOTAL_W = BTN_W * 4 + BTN_GAP * 3

        local mainContainer = Instance.new("Frame")
        mainContainer.Name = "MainBtns"
        mainContainer.Size = UDim2.new(0, TOTAL_W, 0, BTN_H)
        mainContainer.Position = UDim2.new(0.5, -TOTAL_W/2, 1, -(BTN_H + 10))
        mainContainer.BackgroundTransparency = 1
        mainContainer.Parent = sg

        -- Botões na ordem: Left, Down, Up, Right
        local btnDefs = {
            {label = "Left",  key = Enum.KeyCode.A, anim = animLeft},
            {label = "Down",  key = Enum.KeyCode.S, anim = animDown},
            {label = "Up",    key = Enum.KeyCode.W, anim = animUp},
            {label = "Right", key = Enum.KeyCode.D, anim = animRight},
        }

        for i, d in ipairs(btnDefs) do
            local x = (i - 1) * (BTN_W + BTN_GAP)
            makeBtn(mainContainer, d.label, BTN_W, BTN_H, x, 0, function()
                playAction(d.anim)
            end)

            ContextActionService:BindAction("Shunks_"..d.label, function(_, state)
                if state == Enum.UserInputState.Begin then
                    playAction(d.anim)
                end
            end, false, d.key)
        end

        -- Inicia no idle
        animIdle.weight = 1
    end

    -- Update
    m.Update = function(dt, figure)
        if destroyed then return end

        -- Mantém personagem parado
        local hum = figure:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
        end

        local now = os.clock()
        for _, a in ipairs(allAnims) do
            if a and a.weight > 0 then
                a:Step(now - (animStart[a] or now))
            end
        end
    end

    -- Destroy
    m.Destroy = function(figure)
        destroyed = true

        if guiRef then guiRef:Destroy() guiRef = nil end
        if bgMusic then bgMusic:Stop() bgMusic:Destroy() bgMusic = nil end

        for _, act in ipairs({"Shunks_Left","Shunks_Down","Shunks_Up","Shunks_Right"}) do
            ContextActionService:UnbindAction(act)
        end

        for _, a in ipairs(allAnims) do a.weight = 0 end

        local hum = figure:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.AutoRotate = true
        end

        table.clear(allAnims)
        table.clear(animStart)
        figureRef = nil
    end

    return m
end)

return modules