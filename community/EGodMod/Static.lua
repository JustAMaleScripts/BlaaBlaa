-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Static"
    m.Description = "Panic in s-s-s-tatic!"
    m.Assets = {"Static.anim", "Static.mp3"}
    m.Effects = false

    m.Config = function(parent)
        Util_CreateSwitch(parent, "Effects", m.Effects).Changed:Connect(function(v)
            m.Effects = v
            if not v then
                -- immediately clean up if toggled off
                cleanupStatic()
            end
        end)
    end
    m.SaveConfig = function() return { Effects = m.Effects } end
    m.LoadConfig  = function(save)
        if not save then return end
        m.Effects = not not save.Effects
    end

    local animator       = nil
    local start          = 0
    local effectThread   = nil

    -- ─────────────────────────────────────────────
    --  STATIC EFFECT INTERNALS
    -- ─────────────────────────────────────────────
    local Players        = game:GetService("Players")
    local TweenService   = game:GetService("TweenService")
    local lp             = Players.LocalPlayer
    local pGui           = lp:WaitForChild("PlayerGui")

    local staticGui      = nil
    local noiseFrames    = {}
    local noiseThread    = nil

    local ROWS           = 18
    local COLS           = 32
    local STATIC_DURATION = 5   -- seconds the static is visible
    local STATIC_GAP      = 5   -- seconds between bursts
    local NOISE_RATE      = 0.04 -- how fast the noise updates (seconds)

    local function makeStaticGui()
        if staticGui then return end

        staticGui = Instance.new("ScreenGui")
        staticGui.Name = "StaticEffect"
        staticGui.ResetOnSpawn = false
        staticGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        staticGui.IgnoreGuiInset = true
        staticGui.Parent = pGui

        -- Full-screen dark overlay
        local overlay = Instance.new("Frame")
        overlay.Name = "Overlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.55
        overlay.BorderSizePixel = 0
        overlay.Parent = staticGui

        -- Grid of noise tiles
        noiseFrames = {}
        for row = 0, ROWS - 1 do
            for col = 0, COLS - 1 do
                local tile = Instance.new("Frame")
                tile.Size = UDim2.new(1 / COLS, 0, 1 / ROWS, 0)
                tile.Position = UDim2.new(col / COLS, 0, row / ROWS, 0)
                tile.BorderSizePixel = 0
                tile.BackgroundColor3 = Color3.new(1, 1, 1)
                tile.BackgroundTransparency = math.random(0, 10) / 10
                tile.Parent = staticGui
                table.insert(noiseFrames, tile)
            end
        end

        -- Scanlines
        for i = 0, 30 do
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 2)
            line.Position = UDim2.new(0, 0, i / 30, 0)
            line.BackgroundColor3 = Color3.new(0, 0, 0)
            line.BackgroundTransparency = 0.7
            line.BorderSizePixel = 0
            line.Parent = staticGui
        end

        -- "SIGNAL LOST" text
        local lostLabel = Instance.new("TextLabel")
        lostLabel.Size = UDim2.new(0, 300, 0, 50)
        lostLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        lostLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        lostLabel.BackgroundTransparency = 1
        lostLabel.Text = "SIGNAL LOST"
        lostLabel.Font = Enum.Font.Code
        lostLabel.TextSize = 32
        lostLabel.TextColor3 = Color3.new(1, 1, 1)
        lostLabel.TextStrokeTransparency = 0
        lostLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        lostLabel.ZIndex = 10
        lostLabel.Parent = staticGui

        -- Flicker the label
        task.spawn(function()
            while staticGui and staticGui.Parent do
                lostLabel.Visible = math.random() > 0.15
                task.wait(0.08 + math.random() * 0.12)
            end
        end)
    end

    local function startNoise()
        if noiseThread then return end
        noiseThread = task.spawn(function()
            while staticGui and staticGui.Parent do
                for _, tile in ipairs(noiseFrames) do
                    local r = math.random()
                    if r < 0.08 then
                        -- bright white flash tile
                        tile.BackgroundColor3 = Color3.new(1, 1, 1)
                        tile.BackgroundTransparency = 0
                    elseif r < 0.25 then
                        -- dark tile
                        tile.BackgroundColor3 = Color3.new(0, 0, 0)
                        tile.BackgroundTransparency = math.random(0, 4) / 10
                    else
                        -- grey noise
                        local v = math.random(80, 200) / 255
                        tile.BackgroundColor3 = Color3.new(v, v, v)
                        tile.BackgroundTransparency = math.random(0, 6) / 10
                    end
                end
                task.wait(NOISE_RATE)
            end
        end)
    end

    local function stopNoise()
        if noiseThread then
            task.cancel(noiseThread)
            noiseThread = nil
        end
    end

    local function showStatic()
        makeStaticGui()
        startNoise()
    end

    cleanupStatic = function()
        stopNoise()
        if staticGui then
            staticGui:Destroy()
            staticGui = nil
        end
        noiseFrames = {}
    end

    local function hideStatic()
        stopNoise()
        if staticGui then
            staticGui:Destroy()
            staticGui = nil
        end
        noiseFrames = {}
    end

    -- ─────────────────────────────────────────────
    --  EFFECT LOOP: 5s on, 5s off, repeat
    -- ─────────────────────────────────────────────
    local function startEffectLoop()
        effectThread = task.spawn(function()
            while true do
                if not m.Effects then task.wait(0.5) continue end

                -- Show static for STATIC_DURATION seconds
                showStatic()
                task.wait(STATIC_DURATION)

                -- Hide for STATIC_GAP seconds
                hideStatic()
                task.wait(STATIC_GAP)
            end
        end)
    end

    local function stopEffectLoop()
        if effectThread then
            task.cancel(effectThread)
            effectThread = nil
        end
        cleanupStatic()
    end

    -- ─────────────────────────────────────────────
    --  MODULE HOOKS
    -- ─────────────────────────────────────────────
    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("Static.mp3"), "Static", 0.8, NumberRange.new(0, 45.5))
        start    = os.clock()
        animator = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Static.anim"))
        animator.looped = true
        animator.speed  = 1

        startEffectLoop()
    end

    m.Update = function(dt, figure)
        animator:Step(os.clock() - start)
    end

    m.Destroy = function(figure)
        stopEffectLoop()
        animator = nil
    end

    return m
end)
return modules
