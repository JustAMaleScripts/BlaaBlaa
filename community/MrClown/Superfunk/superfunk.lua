-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "SuperFunk"
    m.Description = "by Mrclown"
    m.Assets = {"SuperFunk.anim", "SuperFunk.mp3"}
    m.Config = function(parent)
        Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end

    local MUSIC_LENGTH = 14.863673 -- Duración exacta de SuperFunk.mp3

    local animator = nil
    local start    = 0

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("SuperFunk.mp3"), "PlaceHolder", 0.8, NumberRange.new(0, 999))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("SuperFunk.anim"))
        animator.looped = true
        animator.speed  = 1
    end

    m.Update = function(dt, figure)
        if not animator then return end

        local elapsed = os.clock() - start

        -- Reinicia la animación desde cero exactamente cuando la música termina su loop
        if elapsed >= MUSIC_LENGTH then
            start   = os.clock()
            elapsed = 0
        end

        animator:Step(elapsed)
    end

    m.Destroy = function(figure)
        animator = nil
    end
    return m
end)
return modules
