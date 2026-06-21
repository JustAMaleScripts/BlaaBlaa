local modules = {}

table.insert(modules, function()
    local m = {}

    m.ModuleType   = "MOVESET"
    m.Name         = "Dead Rails Zombie"
    m.Description  = "Dead Rails Zombie moveset."
    m.InternalName = "MOVESET_DEADRAILSZOMBIE"

    m.Assets = {
        "endless_zombies_1.anim",
        "endless_zombies2.anim",
    }

    m.Config = function(parent)
        Util_CreateText(parent, "Dead Rails Zombie", 18, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function() end

    -- ── SERVICES ──────────────────────────────────────────────────────────────
    local ContextActionService = game:GetService("ContextActionService")

    -- ── ANIMS ─────────────────────────────────────────────────────────────────
    local animIdle = nil
    local animWalk = nil

    -- ── STATE ─────────────────────────────────────────────────────────────────
    local allAnims  = {}
    local animTime  = {}
    local state     = "idle"
    local destroyed = false

    -- ── HELPERS ───────────────────────────────────────────────────────────────
    local function setState(newState)
        if state == newState then return end
        state = newState
        for _, a in ipairs(allAnims) do a.weight = 0 end
        if newState == "idle" then
            animIdle.weight = 1
        elseif newState == "walk" then
            animWalk.weight = 1
        end
    end

    -- ── INIT ──────────────────────────────────────────────────────────────────
    m.Init = function(figure)
        destroyed = false

        local function load(file, looped)
            local a  = AnimLib.Animator.new()
            a.rig    = figure
            a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
            a.looped = looped or false
            a.speed  = 1
            a.weight = 0
            animTime[a] = 0
            return a
        end

        animIdle = load("endless_zombies_1.anim", true)
        animWalk = load("endless_zombies2.anim",  true)

        allAnims = { animIdle, animWalk }

        local h = figure:FindFirstChildOfClass("Humanoid")
        if h then h.AutoRotate = true end

        state = "none"
        setState("idle")
    end

    -- ── UPDATE ────────────────────────────────────────────────────────────────
    m.Update = function(dt, figure)
        if destroyed then return end

        local h = figure:FindFirstChildOfClass("Humanoid")
        if h then
            if h.MoveDirection.Magnitude > 0.1 then
                setState("walk")
            else
                setState("idle")
            end
        end

        -- Step das anims ativas com dt acumulado
        for _, a in ipairs(allAnims) do
            if a and a.weight > 0 then
                local t = (animTime[a] or 0) + dt
                animTime[a] = t
                a:Step(t)
            end
        end
    end

    -- ── DESTROY ───────────────────────────────────────────────────────────────
    m.Destroy = function(figure)
        destroyed = true

        for _, a in ipairs(allAnims) do a.weight = 0 end
        table.clear(allAnims)
        table.clear(animTime)

        animIdle = nil; animWalk = nil
        state = "idle"
    end

    return m
end)

return modules
