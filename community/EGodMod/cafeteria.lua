-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Cafeteria"
    m.Description = "Why does this actually Sound fire tho"
    m.Assets = {"CA1.anim", "CA1.mp3", "CA2.anim"}

    m.CA2 = false

    m.Config = function(parent)
        Util_CreateSwitch(parent, "CA2", m.CA2).Changed:Connect(function(v) m.CA2 = v end)
    end
    m.SaveConfig = function() return { CA2 = m.CA2 } end
    m.LoadConfig  = function(save)
        if not save then return end
        m.CA2 = not not save.CA2
    end
    local animator = nil
    local start    = 0
    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("CA1.mp3"), "CA1", 0.8, NumberRange.new(0, 45.5))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(m.CA2 and "CA2.anim" or "CA1.anim"))
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