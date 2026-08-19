-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Aw shucks R6"
    m.Description = "אתה גנב 🤬🤬🤬"
    m.Assets = {"Aw shucks R6.anim", "Aw shucks R6 v2.anim", "Aw shucks R6.mp3"}

    m.UseV2 = false

    m.Config = function(parent)
        Util_CreateSwitch(parent, "V2", m.UseV2).Changed:Connect(function(v)
            m.UseV2 = v
            if animator then
                animator.track = AnimLib.Track.fromfile(
                    AssetGetPathFromFilename(v and "Aw shucks R6 v2.anim" or "Aw shucks R6.anim")
                )
            end
        end)
    end

    m.SaveConfig = function()
        return { UseV2 = m.UseV2 }
    end

    m.LoadConfig = function(save)
        if not save then return end
        m.UseV2 = not not save.UseV2
    end

    local animator = nil
    local start    = 0

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("Aw shucks R6.mp3"), "Aw shucks R6", 0.8, NumberRange.new(0, 45.5))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(
            AssetGetPathFromFilename(m.UseV2 and "Aw shucks R6 v2.anim" or "Aw shucks R6.anim")
        )
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
