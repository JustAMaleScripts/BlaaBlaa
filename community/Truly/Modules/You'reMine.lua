-- UhhhhhhReanim/Modules/biast.lua

local modules = {}

table.insert(modules, function()
    local m = {}

    m.ModuleType  = "DANCE"
    m.Name        = "You're Mine"
    m.Description = "Hi I'm baldy nice to meet ya! Fuck me in the ass and call me Patricia!, Uploaded by TrulyAReal"
    m.Assets = {"You'reMine.anim", "You'reMine.mp3"}

    m.Config = function(parent)
        Util_CreateText(parent, "Don't eat ass in the config", 14, Enum.TextXAlignment.Center)
    end

    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end

    local animator = nil
    local start    = 0

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("You'reMine.mp3"), "You'reMine", 0.8, NumberRange.new(0, 45.5))

        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("You'reMine.anim"))
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