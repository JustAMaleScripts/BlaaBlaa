-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Skeleton Orchestra And Lilia"
    m.Description = "Who is Lilia?"
    m.Assets = {"SkellyAndLilia.anim", "SkellyAndLilia.mp3"}
    m.Config = function(parent)
        Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end
    local animator = nil
    local start    = 0
    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("SkellyAndLilia.mp3"), "SkellyAndLilia", 0.8, NumberRange.new(0, 29.5))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("SkellyAndLilia.anim"))
        animator.looped = true
        animator.speed  = 1
    end
    m.Update = function(dt, figure)
        animator:Step(os.clock() - start)
    end
    m.Destroy = function(figure)
        animator = nil
    end
    return m
end)
return modules