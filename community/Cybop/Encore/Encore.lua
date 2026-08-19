-- UhhhhhhReanim/Modules/DoomerDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Encore"
	m.Description = "Encore Dance Teto"
	m.Assets      = {"Encore Dance.anim", "EncoreEncore.mp3"}

	m.Alternative = false
	m.Config = function(parent)
		Util_CreateSwitch(parent, "Smooth Version", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
	end

	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
	end

	m.SaveConfig = function()
		return {
			Alternative = m.Alternative
		}
	end

	local animator = nil
	local start = 0

	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("EncoreEncore.mp3"), "EncoreEncore", 1, NumberRange.new(0, 999))
		start = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.looped = true
		animator.speed  = 1
		if m.Alternative then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("EncoreSmooth.anim"))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Encore Dance.anim"))
		end
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
