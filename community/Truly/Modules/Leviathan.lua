-- UhhhhhhReanim/Modules/biast.lua

local modules = {}

table.insert(modules, function()
    local m = {}

    m.ModuleType  = "DANCE"
    m.Name        = "Leviathan"
    m.Description = "Thousand Yard Stare, Uploaded by TrulyAReal"
    m.Assets = {"Leviathan.anim", "Leviathan.mp3"}

    m.Config = function(parent)
        Util_CreateText(parent, "Sabnautic 2 When?", 14, Enum.TextXAlignment.Center)
    end

    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end

    local animator = nil
    local start    = 0

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("Leviathan.mp3"), "Leviathan", 0.8, NumberRange.new(0, 45.5))

        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Leviathan.anim"))
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