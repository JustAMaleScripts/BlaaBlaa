-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Firework"
    m.Description = "Come on let your colorsss burst"
    m.Assets = {"Firework.anim", "Firework.mp3"}

    m.Effects = false

    local animator      = nil
    local start         = 0
    local fireworkTimer = 0
    local fireworkInterval = 1.2  -- seconds between each firework launch
    local activeRockets = {}      -- { part, velY, exploded, sparks, lifetime }

    -- Random bright neon color
    local function RandColor()
        local colors = {
            Color3.fromRGB(255, 50,  50),
            Color3.fromRGB(50,  255, 80),
            Color3.fromRGB(50,  150, 255),
            Color3.fromRGB(255, 220, 0),
            Color3.fromRGB(255, 80,  255),
            Color3.fromRGB(0,   255, 220),
            Color3.fromRGB(255, 140, 0),
        }
        return colors[math.random(1, #colors)]
    end

    -- Launch a rocket near the player
    local function LaunchFirework(figure)
        local root = figure:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local col     = RandColor()
        local offsetX = (math.random() - 0.5) * 14
        local offsetZ = (math.random() - 0.5) * 14
        local spawnCF = root.CFrame + Vector3.new(offsetX, 0, offsetZ)

        -- Rocket trail part
        local rocket  = Instance.new("Part")
        rocket.Name   = "FireworkRocket"
        rocket.Size   = Vector3.new(0.3, 0.3, 0.3)
        rocket.Anchored   = true
        rocket.CanCollide = false
        rocket.CastShadow = false
        rocket.Material   = Enum.Material.Neon
        rocket.Color      = col
        rocket.CFrame     = spawnCF
        rocket.Parent     = workspace

        local light       = Instance.new("PointLight")
        light.Brightness  = 3
        light.Range       = 8
        light.Color       = col
        light.Parent      = rocket

        table.insert(activeRockets, {
            part      = rocket,
            color     = col,
            velY      = 28 + math.random() * 10,  -- upward speed
            exploded  = false,
            lifetime  = 0,
            peakY     = spawnCF.Y + 18 + math.random() * 8,  -- explode height
        })
    end

    -- Spawn explosion sparks at a position
    local function Explode(pos, col)
        local numSparks = 18
        for i = 1, numSparks do
            local spark    = Instance.new("Part")
            spark.Name     = "FireworkSpark"
            spark.Size     = Vector3.new(0.2, 0.2, 0.2)
            spark.Anchored = true
            spark.CanCollide = false
            spark.CastShadow = false
            spark.Material = Enum.Material.Neon
            spark.Color    = math.random() > 0.4 and col or Color3.fromRGB(255, 255, 200)
            spark.CFrame   = CFrame.new(pos)
            spark.Parent   = workspace

            -- Give each spark a random outward velocity direction
            local dx = (math.random() - 0.5) * 2
            local dy = (math.random() - 0.5) * 2
            local dz = (math.random() - 0.5) * 2
            local len = math.sqrt(dx*dx + dy*dy + dz*dz)
            local spd = 12 + math.random() * 8

            table.insert(activeRockets, {
                part      = spark,
                color     = spark.Color,
                velX      = dx / len * spd,
                velY      = dy / len * spd,
                velZ      = dz / len * spd,
                exploded  = true,   -- already exploded, just a spark
                isSpark   = true,
                lifetime  = 0,
                maxLife   = 0.7 + math.random() * 0.5,
            })
        end

        -- Bright flash light
        local flash       = Instance.new("Part")
        flash.Name        = "FireworkFlash"
        flash.Size        = Vector3.new(0.1, 0.1, 0.1)
        flash.Anchored    = true
        flash.CanCollide  = false
        flash.Transparency = 1
        flash.CFrame      = CFrame.new(pos)
        flash.Parent      = workspace
        local fl          = Instance.new("PointLight")
        fl.Brightness     = 10
        fl.Range          = 30
        fl.Color          = col
        fl.Parent         = flash

        task.delay(0.15, function()
            if flash and flash.Parent then flash:Destroy() end
        end)
    end

    -- Clean up all active rockets/sparks
    local function ClearFireworks()
        for _, r in ipairs(activeRockets) do
            if r.part and r.part.Parent then r.part:Destroy() end
        end
        activeRockets = {}
        fireworkTimer = 0
    end

    m.Config = function(parent)
        Util_CreateSwitch(parent, "Effects", m.Effects).Changed:Connect(function(v)
            m.Effects = v
            if not v then ClearFireworks() end
        end)
    end

    m.SaveConfig = function() return { Effects = m.Effects } end
    m.LoadConfig = function(save)
        if not save then return end
        m.Effects = not not save.Effects
    end

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("Firework.mp3"), "Firework", 0.8, NumberRange.new(0, 45.5))
        start         = os.clock()
        fireworkTimer = 0
        activeRockets = {}
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Firework.anim"))
        animator.looped = true
        animator.speed  = 1
    end

    m.Update = function(dt, figure)
        animator:Step(os.clock() - start)

        if not m.Effects then return end

        -- Launch a new firework periodically
        fireworkTimer = fireworkTimer + dt
        if fireworkTimer >= fireworkInterval then
            fireworkTimer = 0
            fireworkInterval = 0.9 + math.random() * 0.8
            LaunchFirework(figure)
        end

        -- Update all active rockets and sparks
        local toRemove = {}
        for i, r in ipairs(activeRockets) do
            if not r.part or not r.part.Parent then
                table.insert(toRemove, i)
            else
                r.lifetime = r.lifetime + dt

                if r.isSpark then
                    -- Move spark outward with gravity
                    r.velY = r.velY - 18 * dt
                    local p = r.part.CFrame.Position
                    r.part.CFrame = CFrame.new(
                        p.X + r.velX * dt,
                        p.Y + r.velY * dt,
                        p.Z + r.velZ * dt
                    )
                    -- Fade out
                    r.part.Transparency = r.lifetime / r.maxLife
                    if r.lifetime >= r.maxLife then
                        r.part:Destroy()
                        table.insert(toRemove, i)
                    end
                else
                    -- Move rocket upward
                    local p = r.part.CFrame.Position
                    r.part.CFrame = CFrame.new(p.X, p.Y + r.velY * dt, p.Z)

                    -- Explode when it reaches peak height
                    if p.Y >= r.peakY then
                        Explode(p, r.color)
                        r.part:Destroy()
                        table.insert(toRemove, i)
                    end
                end
            end
        end

        -- Remove dead entries (reverse order to keep indices valid)
        for i = #toRemove, 1, -1 do
            table.remove(activeRockets, toRemove[i])
        end
    end

    m.Destroy = function(figure)
        ClearFireworks()
        animator = nil
    end

    return m
end)
return modules
