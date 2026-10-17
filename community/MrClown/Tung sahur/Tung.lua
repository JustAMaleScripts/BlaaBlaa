-- UhhhhhhReanim/Modules/biast.lua
local modules = {}

table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "tung sahur"
    m.Description = "🫩 by Mrclown"
    m.Assets = {"tung pre 1.anim", "tung pre 1.mp3", "tung pre.anim", "tung pre.mp3"}
    m.Config = function(parent)
        Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end

    local INTRO_DURATION = 3.53 -- duración de "tung pre 1"

    local animator = nil
    local start    = 0
    local switched = false

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("tung pre 1.mp3"), "PlaceHolder", 0.8, NumberRange.new(0, INTRO_DURATION))
        start    = os.clock()
        switched = false

        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("tung pre 1.anim"))
        animator.looped = false
        animator.speed  = 1
    end

    m.Update = function(dt, figure)
        local elapsed = os.clock() - start

        if not switched and elapsed >= INTRO_DURATION then
            switched = true
            SetOverrideDanceMusic(AssetGetContentId("tung pre.mp3"), "PlaceHolder", 0.8, NumberRange.new(0, 13.9))
            start = os.clock()

            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("tung pre.anim"))
            animator.looped = true
            animator.speed  = 1
        end

        animator:Step(os.clock() - start)
    end

    m.Destroy = function(figure)
        animator = nil
    end

    return m
end)

return modules
