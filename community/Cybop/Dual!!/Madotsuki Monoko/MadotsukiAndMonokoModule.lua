-- UhhhhhhReanim/Modules/DoomerDance.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Madotsuki and Monoko Dance"
	m.Description = "Boing Boing Boing Boing"
	m.Assets      = {"MadotsukiP1.anim", "MonokoP2.anim", "MadotsukiBounce.mp3"}

	m.Alternative = false
	m.Config = function(parent)
		Util_CreateSwitch(parent, "Player 2 Version", m.Alternative).Changed:Connect(function(val)
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
		start = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.looped = true
		animator.speed  = 1
		if m.Alternative then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("MonokoP2.anim"))
			SetOverrideDanceMusic(AssetGetContentId("MadotsukiBounce.mp3"), "MadotsukiBounce", 1, NumberRange.new(0, 22.54))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("MadotsukiP1.anim"))
			SetOverrideDanceMusic(AssetGetContentId("MadotsukiBounce.mp3"), "MadotsukiBounce", 1, NumberRange.new(0, 28.92))
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
