-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Everyone get in the car we are leaving this town now!"
    m.Description = "AHHHHHHHH WHAT THE , IMPOSSIBLE , THIS ISNT THE CAR NOOOOOOOOOOO NOOOOOOOOOO AHHHHHHHHHH HERMIT PURPLEEEEEE"
    m.Assets = {"EVERYONEGETINTHECARWEARELEAVINGTHISTOWNNOWAHHHHHWHATTHEIMPOSSIBLETHISISNTTHECARNOOOOOOONOOOOOOOOOAHHHHHERMITPURPLE.anim", "CAR.mp3"}
    m.Config = function(parent)
        Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end
    local animator = nil
    local start    = 0
    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("CAR.mp3"), "CAR", 0.8, NumberRange.new(0, 15.7))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("EVERYONEGETINTHECARWEARELEAVINGTHISTOWNNOWAHHHHHWHATTHEIMPOSSIBLETHISISNTTHECARNOOOOOOONOOOOOOOOOAHHHHHERMITPURPLE.anim"))
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