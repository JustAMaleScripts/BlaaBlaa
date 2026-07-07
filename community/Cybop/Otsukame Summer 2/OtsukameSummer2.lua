-- UhhhhhhReanim/Modules/OtsukameSummer2.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Otsukame Summer 2"
	m.Description = "Tarah-"
	m.Assets      = {"OtsukameSummer2.anim", "otsukame Summer 2.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("otsukame Summer 2.mp3"), "otsukame Summer 2", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("OtsukameSummer2.anim"))
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
