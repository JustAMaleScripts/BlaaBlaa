-- UhhhhhhReanim/Modules/CharlieBrownDanceModule.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Charlie Brown Dance"
	m.Description = "Charlie Brown Dance With Alt"
	m.Assets      = {"CharlieBrownDanceAnimation.anim", "CharlieBrownDanceAltAnimation.anim", "CharlieBrownAudio.mp3"}

	m.Alternative = false
	m.Config = function(parent)
		Util_CreateSwitch(parent, "Alt. Version", m.Alternative).Changed:Connect(function(val)
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
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("CharlieBrownDanceAltAnimation.anim"))
			SetOverrideDanceMusic(AssetGetContentId("CharlieBrownAudio.mp3"), "CharlieBrownAudio", 1, NumberRange.new(0, 22.54))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("CharlieBrownDanceAnimation.anim"))
			SetOverrideDanceMusic(AssetGetContentId("CharlieBrownAudio.mp3"), "CharlieBrownAudio", 1, NumberRange.new(0, 28.92))
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
