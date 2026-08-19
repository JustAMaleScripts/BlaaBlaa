-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "So much more"
    m.Description = "Yazuka will always be the Best Japanese Game with singers"
    m.Assets = {"So much more v1.anim", "So much more v1.mp3", "So much more v2.anim", "So much more v2.mp3"}

    m.V2       = false
    m.EpikAudio = false

    local function getAnim()
        return m.V2 and "So much more v2.anim" or "So much more v1.anim"
    end
    local function getMP3()
        return m.EpikAudio and "So much more v2.mp3" or "So much more v1.mp3"
    end
    local function getLabel()
        return m.EpikAudio and "So much more v2" or "So much more v1"
    end

    local animator = nil
    local start    = 0

    m.Config = function(parent)
        Util_CreateSwitch(parent, "V2 version", m.V2).Changed:Connect(function(v)
            m.V2 = v
            if animator then
                animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(getAnim()))
            end
        end)
        Util_CreateSwitch(parent, "Epik dance modded audio", m.EpikAudio).Changed:Connect(function(v)
            m.EpikAudio = v
            SetOverrideDanceMusic(AssetGetContentId(getMP3()), getLabel(), 0.8, NumberRange.new(0, 45.5))
        end)
    end

    m.SaveConfig = function() return { V2 = m.V2, EpikAudio = m.EpikAudio } end
    m.LoadConfig = function(save)
        if not save then return end
        m.V2        = not not save.V2
        m.EpikAudio = not not save.EpikAudio
    end

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId(getMP3()), getLabel(), 0.8, NumberRange.new(0, 45.5))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(getAnim()))
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
