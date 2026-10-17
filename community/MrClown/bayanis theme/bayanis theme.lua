-- UhhhhhhReanim/Modules/bayanis_theme.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "bayanis_theme"
    m.Description = "sl5✌️🫩 by Mrclown"
    m.Assets = {"bayanis_theme.anim", "bayanis_theme.mp3"}
    m.Config = function(parent)
        Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end
    local animator = nil
    local start    = 0
    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("bayanis_theme.mp3"), "PlaceHolder", 0.8, NumberRange.new(0, 999))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("bayanis_theme.anim"))
        animator.looped = true
        animator.speed  = 1
    end
    local DURATION = 18.94
    m.Update = function(dt, figure)
        local elapsed = os.clock() - start
        if elapsed >= DURATION then
            start   = os.clock()
            elapsed = 0
            SetOverrideDanceMusic(AssetGetContentId("bayanis_theme.mp3"), "PlaceHolder", 0.8, NumberRange.new(0, 999))
        end
        animator:Step(elapsed)
    end
    m.Destroy = function(figure)
        animator = nil
    end
    return m
end)
return modules
