-- UhhhhhhReanim/Modules/biast.lua

local modules = {}

table.insert(modules, function()
    local m = {}

    m.ModuleType  = "DANCE"
    m.Name        = "Big Hand Yap"
    m.Description = "Sick Ass Emote. Uploaded by TrulyAReal"
    m.Assets = {"BigHandYap.anim", "BigHandYap.mp3"}

    m.Config = function(parent)
        Util_CreateText(parent, "Big Hand Series", 14, Enum.TextXAlignment.Center)
    end

    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end

    local animator = nil
    local start    = 0

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("BigHandYap.mp3"), "BigHandYap", 0.8, NumberRange.new(0, 45.5))

        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("BigHandYap.anim"))
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