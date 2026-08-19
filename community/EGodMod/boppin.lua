-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Boppin"
    m.Description = "Hitting this while playing Nico's nextbots"
    m.Assets = {"Boppin.anim", "Boppin.mp3", "Boppin v2.mp3"}

    m.BoppinBetter = false

    local animator = nil
    local start    = 0

    m.Config = function(parent)
        Util_CreateSwitch(parent, "Boppin but better", m.BoppinBetter).Changed:Connect(function(v)
            m.BoppinBetter = v
            local mp3   = m.BoppinBetter and "Boppin v2.mp3" or "Boppin.mp3"
            local label = m.BoppinBetter and "Boppin v2"     or "Boppin"
            SetOverrideDanceMusic(AssetGetContentId(mp3), label, 0.8, NumberRange.new(0, 5005.5))
        end)
    end

    m.SaveConfig = function() return { BoppinBetter = m.BoppinBetter } end
    m.LoadConfig = function(save)
        if not save then return end
        m.BoppinBetter = not not save.BoppinBetter
    end

    m.Init = function(figure)
        local mp3   = m.BoppinBetter and "Boppin v2.mp3" or "Boppin.mp3"
        local label = m.BoppinBetter and "Boppin v2"     or "Boppin"
        SetOverrideDanceMusic(AssetGetContentId(mp3), label, 0.8, NumberRange.new(0, 5005.5))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Boppin.anim"))
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
