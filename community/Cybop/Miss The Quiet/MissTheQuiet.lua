local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "I Miss The Quiet"
	m.Description = "NO NO NO NO NOOOO!!! "
	m.Assets      = {"Miss The Quiet (Short and Smooth Ver).anim", "I miss The Quiet (Short).mp3"}

	m.Alternative  = false
	m.MusicVariant = 1
	m.Config = function(parent)
		Util_CreateSwitch(parent, "Full Ver", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
		Util_CreateDropdown(parent, "Music Variant", {"Normal", "Full Ver."}, m.MusicVariant).Changed:Connect(function(val)
			m.MusicVariant = val
		end)
	end

	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
		m.MusicVariant = save.MusicVariant or m.MusicVariant
	end

	m.SaveConfig = function()
		return {
			Alternative = m.Alternative,
			MusicVariant = m.MusicVariant
		}
	end

	local animator = nil
	local start = 0

	m.Init = function(figure: Model)
		if m.MusicVariant == 1 then
			SetOverrideDanceMusic(AssetGetContentId("I miss The Quiet (Short).mp3"), "I miss The Quiet (Short)", 1, NumberRange.new(0, 14.43))
		elseif m.MusicVariant == 2 then
			SetOverrideDanceMusic(AssetGetContentId("I miss The Quiet (Full).mp3"), "I miss The Quiet (Full)", 1, NumberRange.new(0, 999.03))
		end

		if not m.Intro then
			SetOverrideDanceMusicTime(0)
		end

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.looped = true
		animator.speed  = 1

		if m.Alternative then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Miss The Quiet (Full ver).anim"))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Miss The Quiet (Short and Smooth Ver).anim"))
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