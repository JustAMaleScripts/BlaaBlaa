-- UhhhhhhReanim/Modules/Hei.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Hei forsaken?"
    m.Description = "sl5✌️🫩 by Mrclown"
    m.Assets = {"Hei_forsaken.anim", "Hei_forsaken.mp3"}
    m.Config = function(parent)
        Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end

    local TweenService = game:GetService("TweenService")

    -- config
    local SPAWN_INTERVAL   = 6      -- segundos entre oleadas
    local DUMMIES_PER_WAVE = 3      -- rigs por oleada
    local ROW_SPACING      = 1.1    -- studs entre cada dummy en la fila (y al player)
    local SIDE_OFFSET      = -0.4   -- studs hacia la izquierda (negativo = izquierda)
    local FADE_TIME        = 0.4    -- duración del fundido de entrada
    local DUMMY_COLOR      = Color3.fromRGB(30, 90, 255)
    local DUMMY_TRANSPARENCY = 0.5  -- transparencia final (no queda opaco)

    local animator   = nil
    local start       = 0
    local spawnTimer  = 0
    local dummies     = {}          -- lista de {rig, animator}

    local function clearDummies()
        for _, d in ipairs(dummies) do
            if d.rig and d.rig.Parent then
                d.rig:Destroy()
            end
        end
        dummies = {}
    end

    local function spawnDummy(figure, index)
        local clone = figure:Clone()
        clone.Name = "BiastDummy_" .. index

        -- neutralize the Humanoid instead of destroying it (AnimLib may
        -- expect one to exist on the rig) so it can never drive its own
        -- state (falling, getting up, ragdoll, rotating toward movement)
        local hum = clone:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand      = true
            hum.AutoRotate         = false
            hum.BreakJointsOnDeath = false
            hum.RequiresNeck       = false
            hum.WalkSpeed          = 0
            hum.JumpPower          = 0
            hum:ChangeState(Enum.HumanoidStateType.Physics)
        end

        -- only anchor the root: an anchored root freezes the whole
        -- Motor6D-welded assembly in place, while leaving it able to be
        -- driven by joint animation. Anchoring every part instead freezes
        -- each one at its spawn CFrame and the animation can't move them,
        -- which is what caused the collapsed/scattered look.
        local root = clone:FindFirstChild("HumanoidRootPart") or clone.PrimaryPart
        if root then
            root.Anchored = true
        end

        for _, part in ipairs(clone:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide   = false
                part.CanQuery     = false
                part.CanTouch     = false
                part.Massless     = true
                if part == root then
                    -- HumanoidRootPart is invisible on a real character too;
                    -- leaving it out of the fade is what was showing up as
                    -- a floating red "hitbox" block in front of the dummy
                    part.Transparency = 1
                else
                    part.Color        = DUMMY_COLOR
                    part.Transparency = 1
                end
            end
        end

        clone.Parent = figure.Parent

        for _, part in ipairs(clone:GetDescendants()) do
            if part:IsA("BasePart") and part ~= root then
                TweenService:Create(part, TweenInfo.new(FADE_TIME), {Transparency = DUMMY_TRANSPARENCY}):Play()
            end
        end

        local dAnimator = AnimLib.Animator.new()
        dAnimator.rig    = clone
        dAnimator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Hei_forsaken.anim"))
        dAnimator.looped = true
        dAnimator.speed  = 1

        table.insert(dummies, { rig = clone, animator = dAnimator, offset = index })
    end

    local function trackDummies(figure)
        local mainRoot = figure:FindFirstChild("HumanoidRootPart") or figure.PrimaryPart
        if not mainRoot then return end
        for _, d in ipairs(dummies) do
            local root = d.rig:FindFirstChild("HumanoidRootPart") or d.rig.PrimaryPart
            if root then
                root.CFrame = mainRoot.CFrame * CFrame.new(SIDE_OFFSET * d.offset, 0, ROW_SPACING * d.offset)
            end
        end
    end

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("Hei_forsaken.mp3"), "PlaceHolder", 0.8, NumberRange.new(0, 999))
        start           = os.clock()
        spawnTimer      = 0
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Hei_forsaken.anim"))
        animator.looped = true
        animator.speed  = 1
        clearDummies()
    end

    m.Update = function(dt, figure)
        local elapsed = os.clock() - start
        animator:Step(elapsed)

        trackDummies(figure)
        for _, d in ipairs(dummies) do
            d.animator:Step(elapsed)
        end

        spawnTimer = spawnTimer + dt
        if #dummies < DUMMIES_PER_WAVE and spawnTimer >= SPAWN_INTERVAL then
            spawnTimer = spawnTimer - SPAWN_INTERVAL
            spawnDummy(figure, #dummies + 1)
        end
    end

    m.Destroy = function(figure)
        animator = nil
        clearDummies()
    end

    return m
end)
return modules
