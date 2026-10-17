-- UhhhhhhReanim/Modules/StreetCatForsakenEmote.lua

local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Street Cat Forsaken Emote"
	m.Description = "Emote Forsaken actually"
	m.Assets      = {"StreetCatForsaken1.anim", "StreetCatForsaken2.anim", "StreetCatForsakenAudio.mp3"}

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
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("StreetCatForsaken2.anim"))
			SetOverrideDanceMusic(AssetGetContentId("StreetCatForsakenAudio.mp3"), "StreetCatForsakenAudio", 1, NumberRange.new(0, 22.54))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("StreetCatForsaken1.anim"))
			SetOverrideDanceMusic(AssetGetContentId("StreetCatForsakenAudio.mp3"), "StreetCatForsakenAudio", 1, NumberRange.new(0, 28.92))
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
