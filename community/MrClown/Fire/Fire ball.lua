-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "fire ball"
    m.Description = "sl5✌️🫩"
    m.Assets = {"fire ball.anim", "fire ball.mp3"}
    m.Config = function(parent)
        Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end

    local animator      = nil
    local start          = 0
    local MUSIC_DURATION = 24.045

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("fire ball.mp3"), "PlaceHolder", 0.8, NumberRange.new(0, 999.9))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("fire ball.anim"))
        animator.looped = true
        animator.speed  = 1

        local humanoid = figure:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 4
        end
    end

    m.Update = function(dt, figure)
        local elapsed = os.clock() - start

        if elapsed >= MUSIC_DURATION then
            start = os.clock()
            elapsed = 0
        end

        animator:Step(elapsed)
    end

    m.Destroy = function(figure)
        animator = nil

        local humanoid = figure:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end

    return m
end)
return modules
