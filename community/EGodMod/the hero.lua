-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "The hero"
    m.Description = "Basically a spanish rap dance"
    m.Assets = {"The hero.anim", "The hero.mp3", "The hero v2.anim", "the hero(sega).mp3"}

    m.V2        = false
    m.SegaMusic = false

    local function getAnim()
        return m.V2 and "The hero v2.anim" or "The hero.anim"
    end
    local function getMP3()
        return m.SegaMusic and "the hero(sega).mp3" or "The hero.mp3"
    end
    local function getLabel()
        return m.SegaMusic and "the hero(sega)" or "The hero"
    end

    local animator = nil
    local start    = 0

    m.Config = function(parent)
        Util_CreateSwitch(parent, "v2", m.V2).Changed:Connect(function(v)
            m.V2 = v
            if animator then
                animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(getAnim()))
            end
        end)
        Util_CreateSwitch(parent, "Sega music(not recommend since its trash)", m.SegaMusic).Changed:Connect(function(v)
            m.SegaMusic = v
            SetOverrideDanceMusic(AssetGetContentId(getMP3()), getLabel(), 0.8, NumberRange.new(0, 45.5))
        end)
    end

    m.SaveConfig = function() return { V2 = m.V2, SegaMusic = m.SegaMusic } end
    m.LoadConfig = function(save)
        if not save then return end
        m.V2        = not not save.V2
        m.SegaMusic = not not save.SegaMusic
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
