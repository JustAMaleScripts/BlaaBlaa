-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Your out of touch"
    m.Description = "Im out of touch?"
    m.Assets = {"Your out of touch.anim", "Your out of touch.mp3", "Sonne.mp3", "Silly Billy.mp3"}

    m.Sonne      = false
    m.SillyBilly = false

    local function getMP3()
        if m.Sonne      then return "Sonne.mp3",       "Sonne"       end
        if m.SillyBilly then return "Silly Billy.mp3", "Silly Billy" end
        return "Your out of touch.mp3", "Your out of touch"
    end

    local animator = nil
    local start    = 0

    local switches = {}

    local function applyAudio()
        local mp3, label = getMP3()
        SetOverrideDanceMusic(AssetGetContentId(mp3), label, 0.8, NumberRange.new(0, 500.35))
    end

    m.Config = function(parent)
        local s1 = Util_CreateSwitch(parent, "Sonne(fucking fire music)", m.Sonne)
        local s2 = Util_CreateSwitch(parent, "Silly Billy(FNF)", m.SillyBilly)
        switches = { s1, s2 }

        s1.Changed:Connect(function(v)
            m.Sonne = v
            if v then m.SillyBilly = false; s2:SetValue(false) end
            applyAudio()
        end)
        s2.Changed:Connect(function(v)
            m.SillyBilly = v
            if v then m.Sonne = false; s1:SetValue(false) end
            applyAudio()
        end)
    end

    m.SaveConfig = function() return { Sonne = m.Sonne, SillyBilly = m.SillyBilly } end
    m.LoadConfig = function(save)
        if not save then return end
        m.Sonne      = not not save.Sonne
        m.SillyBilly = not not save.SillyBilly
    end

    m.Init = function(figure)
        applyAudio()
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Your out of touch.anim"))
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
