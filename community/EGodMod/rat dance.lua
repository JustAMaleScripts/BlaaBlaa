-- UhhhhhhReanim/Modules/biast.lua
local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Rat Dance"
    m.Description = "Way better then The Uhhh reanimate One."
    m.Assets = {"Rat dance.anim", "Rat dance.mp3", "Rat dance V1.anim", "Rat dance V2.anim", "Rat dance V3.anim"}

    m.Version = 0 -- 0 = default, 1 = V1, 2 = V2, 3 = V3

    local function getAnim()
        if m.Version == 1 then return "Rat dance V1.anim"
        elseif m.Version == 2 then return "Rat dance V2.anim"
        elseif m.Version == 3 then return "Rat dance V3.anim"
        else return "Rat dance.anim" end
    end

    local switches = {}

    local function setVersion(v)
        m.Version = v
        -- untoggle all other switches
        for i, sw in pairs(switches) do
            if i ~= v then sw:SetValue(false) end
        end
        if animator then
            animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(getAnim()))
        end
    end

    m.Config = function(parent)
        local s1 = Util_CreateSwitch(parent, "Rat dance v1", m.Version == 1)
        local s2 = Util_CreateSwitch(parent, "Rat dance v2", m.Version == 2)
        local s3 = Util_CreateSwitch(parent, "Rat dance v3", m.Version == 3)
        switches = { [1] = s1, [2] = s2, [3] = s3 }
        s1.Changed:Connect(function(v) if v then setVersion(1) else if m.Version == 1 then setVersion(0) end end end)
        s2.Changed:Connect(function(v) if v then setVersion(2) else if m.Version == 2 then setVersion(0) end end end)
        s3.Changed:Connect(function(v) if v then setVersion(3) else if m.Version == 3 then setVersion(0) end end end)
    end

    m.SaveConfig = function() return { Version = m.Version } end
    m.LoadConfig = function(save)
        if not save then return end
        m.Version = save.Version or 0
    end

    animator = nil
    local start = 0

    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("Rat dance.mp3"), "Rat dance", 0.8, NumberRange.new(0, 500.6))
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
