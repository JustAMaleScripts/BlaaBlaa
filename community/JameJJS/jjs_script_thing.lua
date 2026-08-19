local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Dead Wrong"
	m.Description = "Bumta"
	m.Assets      = {
		"dead1.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/dead1.mp3",
		"dead2.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/dead2.mp3",
		"deadwrong.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/deadwrong.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		local song = math.random(1, 2) == 1 and "dead1.mp3" or "dead2.mp3"
		SetOverrideDanceMusic(AssetGetContentId(song), song, 0.8, NumberRange.new(0, 9999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("deadwrong.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "static"
	m.Description = "uhhh"
	m.Assets      = {
		"static2.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/static2.mp3",
		"static.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/static.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("static2.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("static.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "larping the room"
	m.Description = "bug fix vision"
	m.Assets      = {
		"larp.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/larp.mp3",
		"larp.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/larp.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("larp.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("larp.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "bang (JJS)"
	m.Description = "larp larp larp"
	m.Assets      = {
		"bangjjs.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/bangjjs.anim",
		"bangjjs.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/bangjjs.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("bangjjs.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("bangjjs.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "jackpot2"
	m.Description = "how is feel after killing low hp player"
	m.Assets      = {
		"jackpot2.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/jackpot2.mp3",
		"jackpot2.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/jackpot2.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("jackpot2.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("jackpot2.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "yuji"
	m.Description = "go yuji go yuji!"
	m.Assets      = {
		"yuji.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/yuji.anim",
		"yuji.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/yuji.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("yuji.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("yuji.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Warfstache"
	m.Description = "not jjs remix music"
	m.Assets      = {
		"Warfstache.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/Warfstache.anim",
		"Warfstache.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/Warfstache.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Warfstache.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Warfstache.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "mourning"
	m.Description = "hero hero..."
	m.Assets      = {
		"mourning.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/mourning.anim",
		"mourning.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/mourning.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("mourning.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("mourning.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "how was tze moving"
	m.Description = "me: tze update your tze: no me be like:😭😭😭"
	m.Assets      = {
		"tze.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/tze.mp3",
		"tze.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/tze.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("tze.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("tze.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Tomodachi dance"
	m.Description = "no tuff Description"
	m.Assets      = {
		"Tomodachi.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/Tomodachi.mp3",
		"Tomodachi.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/Tomodachi.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Tomodachi.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Tomodachi.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "VESSELL!"
	m.Description = "kindhito get beaten up by evil gojo student"
	m.Assets      = {
		"yujiii.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/yujiii.mp3",
		"yujiii.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/yujiii.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("yujiii.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("yujiii.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Hopping"
	m.Description = "not perfect loop music"
	m.Assets      = {
		"Hopping.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/Hopping.mp3",
		"Hopping.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/Hopping.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Hopping.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Hopping.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "chill"
	m.Description = "i forgor"
	m.Assets      = {
		"chill.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/chill.mp3",
		"chill.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/chill.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("chill.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("chill.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "chill2"
	m.Description = "chill but different"
	m.Assets      = {
		"chill.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/chill.mp3",
		"chill2.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/chill2.anim"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("chill.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("chill2.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "aura monster"
	m.Description = "did i just heard stair?"
	m.Assets      = {
		"aura.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/aura.anim",
		"aura.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/aura.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("aura.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("aura.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "low cortisol"
	m.Description = "idk"
	m.Assets      = {
		"lc.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/lc.anim",
		"lc.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/lc.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("lc.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("lc.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "moneylender"
	m.Description = "with no song"
	m.Assets      = {
		"moneylender.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/moneylender.anim",
		"idk.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/idk.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("idk.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("moneylender.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "that you guy see that"
	m.Description = "idk"
	m.Assets      = {
		"dygst.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/dygst.anim",
		"dygst.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/dygst.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("dygst.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("dygst.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "samply walk around it"
	m.Description = "wall"
	m.Assets      = {
		"walkit.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/walkit.anim",
		"walkit.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/walkit.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("walkit.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("walkit.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "reclassed"
	m.Description = "uuhh idk"
	m.Assets      = {
		"reclass.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/reclass.anim",
		"reclass.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/reclass.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("reclass.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("reclass.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "macarena"
	m.Description = "hmm?"
	m.Assets      = {
		"Macarena.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/Macarena.anim",
		"macarena.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/macarena.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("macarena.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Macarena.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "hei party"
	m.Description = "maki vs naoya ahh dance"
	m.Assets      = {
		"hei.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/hei.anim",
		"hei.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/hei.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("hei.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("hei.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "diamond in the sky"
	m.Description = "cant find jjs music"
	m.Assets      = {
		"diamond.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/diamond.anim",
		"diamond.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/diamond.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("diamond.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("diamond.anim"))
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

table.insert(modules, function()

local m = {}

m.ModuleType   = "DANCE"
m.Name         = "Chest Bump"
m.Description  = "Jane Juliet Bumping his Chest"
m.InternalName = "bump.lua"

m.Assets = {
    "anim1.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/anim1.anim",
    "anin2.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/anin2.anim",
    "bump.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/bump.mp3",
}

m.Config = function(parent)
    Util_CreateText(parent, "Erm Bug Fix", 18, Enum.TextXAlignment.Center)
end

m.SaveConfig = function() return {} end
m.LoadConfig  = function() end

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")

local figureRef  = nil
local anim1      = nil
local anim2      = nil
local anim1Start = 0
local anim2Start = 0
local screenGui  = nil
local keyConn    = nil
local function loadAnim(fig, file)
    local a  = AnimLib.Animator.new()
    a.rig    = fig
    a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
    a.looped = false
    a.speed  = 1
    a.weight = 0
    return a
end

local function playSound(filename)
    local sound = Instance.new("Sound")
    sound.SoundId = AssetGetContentId(filename)
    sound.Volume  = 1
    sound.Parent  = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 10)
end

local function doBump()
    anim1.weight = 0
    playSound("bump.mp3")
    anim2.weight = 1
    anim2Start   = os.clock()
end

local function createGui()
    local player = Players.LocalPlayer
    if not player then return end
    local playerGui = player:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name           = "BumpMovesetGui"
    screenGui.ResetOnSpawn   = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent         = playerGui

    local btn = Instance.new("TextButton")
    btn.Size                   = UDim2.new(0, 90, 0, 90)
    btn.Position               = UDim2.new(1, -110, 1, -230)
    btn.AnchorPoint            = Vector2.new(0, 1)
    btn.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel        = 0
    btn.Text                   = "bump"
    btn.TextColor3             = Color3.fromRGB(0, 0, 0)
    btn.TextSize               = 18
    btn.Font                   = Enum.Font.GothamBold
    btn.AutoButtonColor        = true
    btn.Parent                 = screenGui

    local stroke = Instance.new("UIStroke")
    stroke.Color     = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 3
    stroke.Parent    = btn

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent       = btn

    btn.MouseButton1Click:Connect(doBump)
end

m.Init = function(figure)
    figureRef = figure

    anim1 = loadAnim(figure, "anim1.anim")
    anim2 = loadAnim(figure, "anin2.anim")

    -- play anim1 on start, no loop
    anim1.weight = 1
    anim1Start   = os.clock()

    keyConn = UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.E then
            doBump()
        end
    end)

    createGui()
end

m.Update = function(dt, figure)
    local t = os.clock()
    if anim1.weight > 0 then anim1:Step(t - anim1Start) end
    if anim2.weight > 0 then anim2:Step(t - anim2Start) end
end

m.Destroy = function()
    figureRef = nil

    local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 16 end

    if keyConn then
        keyConn:Disconnect()
        keyConn = nil
    end

    if screenGui then
        screenGui:Destroy()
        screenGui = nil
    end
end

return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType = "DANCE"
	m.Name = "excuse me sir"
	m.Description = "Excuse ME Sir"
	m.InternalName = "MOVESET_MYMOVESET"

	m.Assets = {
		"WALK.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/WALK.anim",
		"STOP.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/STOP.anim",
		"look.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/look.mp3",
	}

	m.Config = function(parent)
		Util_CreateText(parent, "Idk", 20, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function()
		return {}
	end

	m.LoadConfig = function() end

	local figureRef
	local walkAnim
	local stopAnim
	local currentAnim
	local button

	local stopped = false

	local WALK_SPEED = 16
	local STOP_SPEED = 0

	local function loadLoopAnim(file)
		local anim = AnimLib.Animator.new()
		anim.rig    = figureRef
		anim.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
		anim.looped = true
		anim.speed  = 1
		anim.weight = 0
		return anim
	end

	local function play(anim)
		if currentAnim == anim then return end
		if currentAnim then currentAnim.weight = 0 end
		currentAnim        = anim
		currentAnim.weight = 1
		currentAnim._start = os.clock()
	end

	local function toggle()
		local h = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
		if not h then return end

		stopped = not stopped

		if stopped then
			h.WalkSpeed = STOP_SPEED
			play(stopAnim)
		else
			h.WalkSpeed = WALK_SPEED
			play(walkAnim)
		end
	end

	local function createButton()
		local players = game:GetService("Players")
		local lp = players.LocalPlayer
		local gui = Instance.new("ScreenGui")
		gui.Name = "MyMovesetGui"
		gui.ResetOnSpawn = false
		gui.Parent = lp.PlayerGui

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 90, 0, 90)
		btn.Position = UDim2.new(1, -110, 1, -230) -- above jump button
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		btn.BackgroundTransparency = 0.3
		btn.BorderSizePixel = 0
		btn.Text = "look"
		btn.TextColor3 = Color3.fromRGB(0, 0, 0)
		btn.TextSize = 18
		btn.Font = Enum.Font.GothamBold
		btn.Parent = gui

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(0, 0, 0)
		stroke.Thickness = 3
		stroke.Parent = btn

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = btn

		btn.MouseButton1Click:Connect(toggle)

		button = gui
	end

	m.Init = function(figure)
		figureRef = figure

		-- Background music
		SetOverrideDanceMusic(AssetGetContentId("look.mp3"), "look", 0.8, NumberRange.new(0, 9999))

		walkAnim = loadLoopAnim("WALK.anim")
		stopAnim = loadLoopAnim("STOP.anim")

		local hum = figure:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = WALK_SPEED end
		play(walkAnim)

		local uis = game:GetService("UserInputService")
		uis.InputBegan:Connect(function(input, gpe)
			if gpe or not figureRef then return end
			if input.KeyCode == Enum.KeyCode.E then
				toggle()
			end
		end)

		createButton()
	end

	m.Update = function(dt, figure)
		if not figureRef then return end

		local now = os.clock()
		if walkAnim.weight > 0 then walkAnim:Step(now - walkAnim._start) end
		if stopAnim.weight > 0 then stopAnim:Step(now - stopAnim._start) end
	end

	m.Destroy = function(figure)
		stopped = false
		local hum = figure and figure:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 16 end
		if button then button:Destroy() end
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "flow"
	m.Description = "tonigth rin gonna hug you"
	m.Assets      = {
		"flow.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/flow.anim",
		"flow.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/flow.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("flow.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("flow.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "i hate you"
	m.Description = "procecd ehh i forgot again"
	m.Assets      = {
		"ihateyou.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/ihateyou.anim",
		"ihateyou.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/ihateyou.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("ihateyou.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("ihateyou.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "i miss the quiet"
	m.Description = "hmm still dont know"
	m.Assets      = {
		"imissthequiet.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/imissthequiet.anim",
		"imissthequiet.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/imissthequiet.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("imissthequiet.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("imissthequiet.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "seat deprssion"
	m.Description = "cry on chair"
	m.Assets      = {
		"seatcry.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/seatcry.anim",
		"idk.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/idk.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("idk.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("seatcry.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "die of death"
	m.Description = "omg is dod ref"
	m.Assets      = {
		"dod.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/dod.anim",
		"dod.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/dod.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("dod.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("dod.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Baldi dance"
	m.Description = "still basic class"
	m.Assets      = {
		"Baldi.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/Baldi.anim",
		"Baldi.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/Baldi.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Baldi.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Baldi.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Electro shuffle"
	m.Description = "fortnigth say gex"
	m.Assets      = {
		"ElectroShuffle.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/ElectroShuffle.anim",
		"ElectroShuffle.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/ElectroShuffle.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("ElectroShuffle.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("ElectroShuffle.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Clap emote"
	m.Description = "every 500 clap something will happen (make sure your volume is down or you parent beat shi out of you)"
	m.Assets      = {
		"startclap.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/startclap.anim",
		"clap.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/clap.anim",
		"clap1.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/clap1.mp3",
		"clap2.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/clap2.mp3",
		"clap3.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/clap3.mp3",
		"ultclap.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/ultclap.mp3",
		"ultclap2.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/ultclap2.mp3",
	}

	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local Players    = game:GetService("Players")
	local Debris     = game:GetService("Debris")
	local SoundService = game:GetService("SoundService")

	local figureRef    = nil
	local startAnim    = nil
	local clapAnim     = nil
	local animStart    = 0
	local screenGui    = nil
	local countLabel   = nil

	local clapCount    = 0
	local isUlting     = false
	local currentAnim  = nil

	local function playSound(filename)
		local sound = Instance.new("Sound")
		sound.SoundId = AssetGetContentId(filename)
		sound.Volume  = 1
		sound.Parent  = SoundService
		sound:Play()
		Debris:AddItem(sound, 30)
		return sound
	end

	local function setAnim(anim, looped, speed)
		if currentAnim then
			currentAnim.weight = 0
		end
		anim.looped = looped
		anim.speed  = speed or 1
		anim.weight = 1
		animStart   = os.clock()
		currentAnim = anim
	end

	local function doUltClap()
		isUlting = true
		local song = math.random(1, 2) == 1 and "ultclap.mp3" or "ultclap2.mp3"
		local sound = playSound(song)

		-- clap anim 2x speed looped
		setAnim(clapAnim, true, 5)

		-- when sound ends, stop loop
		sound.Ended:Connect(function()
			clapAnim.looped = false
			isUlting = false
		end)
	end

	local function doClap()
		if isUlting then return end

		clapCount = clapCount + 1
		if countLabel then
			countLabel.Text = "👏 " .. clapCount
		end

		-- play random clap sound
		local sounds = {"clap1.mp3", "clap2.mp3", "clap3.mp3"}
		playSound(sounds[math.random(1, 3)])

		-- play clap anim once
		setAnim(clapAnim, false, 1)

		-- check for ult at 500
		if clapCount >= 500 and clapCount % 500 == 0 then
			task.delay(0.1, doUltClap)
		end
	end

	local function createGui()
		local player = Players.LocalPlayer
		if not player then return end
		local playerGui = player:FindFirstChildOfClass("PlayerGui")
		if not playerGui then return end

		screenGui = Instance.new("ScreenGui")
		screenGui.Name           = "ClapEmoteGui"
		screenGui.ResetOnSpawn   = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.Parent         = playerGui

		-- Count label
		local label = Instance.new("TextLabel")
		label.Size                   = UDim2.new(0, 120, 0, 40)
		label.Position               = UDim2.new(1, -140, 1, -280)
		label.AnchorPoint            = Vector2.new(0, 1)
		label.BackgroundTransparency = 1
		label.Text                   = "👏 0"
		label.TextColor3             = Color3.fromRGB(255, 255, 255)
		label.TextSize               = 20
		label.Font                   = Enum.Font.GothamBold
		label.TextStrokeTransparency = 0
		label.Parent                 = screenGui
		countLabel = label

		-- Clap button
		local btn = Instance.new("TextButton")
		btn.Size                   = UDim2.new(0, 90, 0, 90)
		btn.Position               = UDim2.new(1, -110, 1, -230)
		btn.AnchorPoint            = Vector2.new(0, 1)
		btn.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
		btn.BackgroundTransparency = 0.3
		btn.BorderSizePixel        = 0
		btn.Text                   = "clap"
		btn.TextColor3             = Color3.fromRGB(0, 0, 0)
		btn.TextSize               = 18
		btn.Font                   = Enum.Font.GothamBold
		btn.AutoButtonColor        = true
		btn.Parent                 = screenGui

		local stroke = Instance.new("UIStroke")
		stroke.Color     = Color3.fromRGB(0, 0, 0)
		stroke.Thickness = 3
		stroke.Parent    = btn

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent       = btn

		btn.MouseButton1Click:Connect(doClap)
	end

	m.Init = function(figure)
		figureRef = figure

		startAnim        = AnimLib.Animator.new()
		startAnim.rig    = figure
		startAnim.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("startclap.anim"))
		startAnim.looped = false
		startAnim.speed  = 1
		startAnim.weight = 0

		clapAnim        = AnimLib.Animator.new()
		clapAnim.rig    = figure
		clapAnim.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("clap.anim"))
		clapAnim.looped = false
		clapAnim.speed  = 1
		clapAnim.weight = 0

		-- play startclap on init
		setAnim(startAnim, false, 1)

		createGui()
	end

	m.Update = function(dt, figure)
		local t = os.clock()
		if startAnim and startAnim.weight > 0 then startAnim:Step(t - animStart) end
		if clapAnim  and clapAnim.weight  > 0 then clapAnim:Step(t - animStart)  end
	end

	m.Destroy = function(figure)
		figureRef  = nil
		isUlting   = false
		currentAnim = nil
		if screenGui then
			screenGui:Destroy()
			screenGui = nil
		end
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Superstar"
	m.Description = "btw these song are placeholder"
	m.Assets      = {
		"superstar1.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/superstar1.anim",
		"superstar2.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/superstar2.anim",
		"superstar3.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/superstar3.anim",
		"gubby.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/gubby.mp3",
	}

	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("gubby.mp3"), "gubby.mp3", 0.8, NumberRange.new(0, 9999))

		local anims = {"superstar1.anim", "superstar2.anim", "superstar3.anim"}
		local picked = anims[math.random(1, 3)]

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(picked))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "guy"
	m.Description = "hey this are my family, guy"
	m.Assets      = {
		"guy.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/guy.anim",
		"deadass.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/deadass.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("deadass.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("guy.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "sit"
	m.Description = "finally rest but something off...(nothing really off)"
	m.Assets      = {
		"sit.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/sit.anim",
		"structure.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/structure.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("structure.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("sit.anim"))
		animator.looped = false
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "sit2"
	m.Description = "sit ig"
	m.Assets      = {
		"sit2.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/sit2.anim",
		"structure.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/structure.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("structure.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("sit2.anim"))
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

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "onion"
	m.Description = "onion"
	m.Assets      = {
		"onion.anim@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/onion.anim",
		"onion.mp3@https://github.com/isstilljame-blip/Idk/raw/refs/heads/main/onion.mp3"
	}
	m.Config = function(parent)
		Util_CreateText(parent, " ", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("onion.mp3"))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("onion.anim"))
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