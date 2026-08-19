-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Prince of Egypt"
    m.Description = "Dancing On the Gold Like its the floor be like:"
    m.Assets = {"Egypt R6.anim", "Egypt R6.mp3", "Egypt R6 v2.anim", "Egypt R6 v2.mp3"}

    m.V2          = false
    m.DieOfDeath  = false

    local function getTrack()
        return m.DieOfDeath and "Egypt R6 v2.mp3" or "Egypt R6.mp3"
    end
    local function getTrackLabel()
        return m.DieOfDeath and "Egypt R6 v2" or "Egypt R6"
    end
    local function getAnim()
        return m.V2 and "Egypt R6 v2.anim" or "Egypt R6.anim"
    end

    m.Config = function(parent)
        Util_CreateSwitch(parent, "V2", m.V2).Changed:Connect(function(v)
            m.V2 = v
            -- swap animation by reloading the track
            if animator then
                animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(getAnim()))
            end
        end)
        Util_CreateSwitch(parent, "Die of Death version", m.DieOfDeath).Changed:Connect(function(v)
            m.DieOfDeath = v
            SetOverrideDanceMusic(AssetGetContentId(getTrack()), getTrackLabel(), 0.8, NumberRange.new(0, 45.5))
        end)
    end

    m.SaveConfig = function()
        return { V2 = m.V2, DieOfDeath = m.DieOfDeath }
    end

    m.LoadConfig = function(save)
        if not save then return end
        m.V2         = not not save.V2
        m.DieOfDeath = not not save.DieOfDeath
    end

    animator = nil
    local start = 0

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId(getTrack()), getTrackLabel(), 0.8, NumberRange.new(0, 45.5))
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
