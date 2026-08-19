-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Brickbattler"
    m.Description = "There goes the twin towers-"
    m.Assets = {"Brickbattler.anim", "Brickbattler with lyrics.mp3", "Brickbattler without lyrics.mp3"}

    m.WithoutLyrics = false

    m.Config = function(parent)
        Util_CreateSwitch(parent, "Without lyrics", m.WithoutLyrics).Changed:Connect(function(v)
            m.WithoutLyrics = v
            local track = v and "Brickbattler without lyrics.mp3" or "Brickbattler with lyrics.mp3"
            local label  = v and "Brickbattler without lyrics"    or "Brickbattler with lyrics"
            SetOverrideDanceMusic(AssetGetContentId(track), label, 0.8, NumberRange.new(0, 45.5))
        end)
    end

    m.SaveConfig = function()
        return { WithoutLyrics = m.WithoutLyrics }
    end

    m.LoadConfig = function(save)
        if not save then return end
        m.WithoutLyrics = not not save.WithoutLyrics
    end

    local animator = nil
    local start    = 0

    m.Init = function(figure)
        local track = m.WithoutLyrics and "Brickbattler without lyrics.mp3" or "Brickbattler with lyrics.mp3"
        local label  = m.WithoutLyrics and "Brickbattler without lyrics"    or "Brickbattler with lyrics"
        SetOverrideDanceMusic(AssetGetContentId(track), label, 0.8, NumberRange.new(0, 45.5))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Brickbattler.anim"))
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
