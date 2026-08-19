-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Mannrobics"
    m.Description = "Tf2 reference in uhhh reanimate!?!"
    m.Assets = {"Mannrobics.anim", "Mannrobics.mp3", "Mannrobics v2.anim"}

    m.V2 = false

    local animator = nil
    local start    = 0

    m.Config = function(parent)
        Util_CreateSwitch(parent, "V2", m.V2).Changed:Connect(function(v)
            m.V2 = v
            if animator then
                animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(m.V2 and "Mannrobics v2.anim" or "Mannrobics.anim"))
            end
        end)
    end

    m.SaveConfig = function() return { V2 = m.V2 } end
    m.LoadConfig = function(save)
        if not save then return end
        m.V2 = not not save.V2
    end

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("Mannrobics.mp3"), "Mannrobics", 0.8, NumberRange.new(0, 45.5))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(m.V2 and "Mannrobics v2.anim" or "Mannrobics.anim"))
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
