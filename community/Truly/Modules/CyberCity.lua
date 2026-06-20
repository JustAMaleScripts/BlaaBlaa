-- UhhhhhhReanim/Modules/biast.lua

local modules = {}

table.insert(modules, function()
    local m = {}

    m.ModuleType  = "DANCE"
    m.Name        = "Cyber City"
    m.Description = "A Tyrannosaurus Rex A Quiet kid and a Fluffy boy, Uploaded by TrulyAReal"
    m.Assets = {"CyberCity.anim", "CyberCity.mp3"}

    m.Config = function(parent)
        Util_CreateText(parent, "Kris don't buy drugs from that shady business man INSTEAD buy them from me Toriel", 14, Enum.TextXAlignment.Center)
    end

    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end

    local animator = nil
    local start    = 0

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("CyberCity.mp3"), "CyberCity", 0.8, NumberRange.new(0, 45.5))

        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("CyberCity.anim"))
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