--[[
██████╗ ██╗      █████╗  █████╗       ██████╗ ██╗      █████╗  █████╗
██╔══██╗██║     ██╔══██╗██╔══██╗      ██╔══██╗██║     ██╔══██╗██╔══██╗
██████╔╝██║     ███████║███████║      ██████╔╝██║     ███████║███████║
██╔══██╗██║     ██╔══██║██╔══██║      ██╔══██╗██║     ██╔══██║██╔══██║
██████╔╝███████╗██║  ██║██║  ██║      ██████╔╝███████╗██║  ██║██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
       "DREAMS WILL NEVER COME TRUE UNTIL YOU ACTUALLY MAKE IT."       

       Code:    STEVETHEREALONE
                BoredGal (mostly patches..)
				JustAMale (The AI Slop User, also Known as Mr AI)
				Claude (Prompt: Added your more a LOT of features and includes animation editor! lol)
				ChatGPT (Prompt: Added your ASCII Art so yeah.)
				dolteddown (Some stuff from warehause) (hes a bad person too)
				Uhhhhhh's pull requests
				Awes (Some stuff from his fork of Uhhhhhh)
				Awes Uhhhhhh fork pull requests (if any come to exist)
				E God/Fred (Funni collaborator who is adding/updating stuff and also adding their own code too)
				MrY7zz (ISC License)
       GFX:     STEVETHEREALONE
                AALib
                some random generators
       Music:   Dubmood
                4mat
                MASTER BOOT RECORD
				some 1990s Musics
				Counter-Strike 2
				BlackEyedPeas
				Mirror's Edge Catalyst
				8 Bit Bunker
				8 Bit Universe
				8 Bit Arcade
				8 Bit Misfits


Thou shalth not steal. Point at this source if you used a snippet here.
]]

local suc,res = pcall(function()
	_G.yes = print
end)

if not suc then
	_G = {}
end

local fenv = getfenv()

local genv = _G.globalEnv
genv = type(genv) == "table" and genv or {}
_G.globalEnv = genv

function funcgenv()
	return setmetatable({}, {
		__index = function(_, k) return genv[k] end,
		__newindex = function(_, key, value)
			genv[key] = value
			fenv[key] = value
		end
	})
end

getgenv = getgenv or funcgenv

if getgenv().UhhhhhhLoaded then return end
getgenv().UhhhhhhLoaded = true

local UhhhhhhVersion = "1.0.4 ALPHA"

function funcref(object)
	local proxy = newproxy(true)
	local metatable = getmetatable(proxy)

	local metamethods = {
		type      = typeof(object),
		newindex  = object,
		metatable = getmetatable(object),
		tostring  = function() return tostring(object) end,
		call      = function() return object() end,
		unm       = function() return -object end,
		len       = function() return #object end,
		index     = function(_, key)
			local value = object[key]

			if type(value) == "function" then
				return function(_, ...)
					return value(object, ...)
				end
			end

			return value
		end,
	}

	local operators = {
		add     = "+",
		sub     = "-",
		mul     = "*",
		div     = "/",
		idiv    = "//",
		mod     = "%",
		pow     = "^", 
		eq      = "==",
		lt      = "<",
		le      = "<=",
		concat  = "..",
	}

	for name, operator in operators do
		metamethods[name] = function(_, object1)
			return loadstring(
				([[local objects = {...}; 
			      
			      return objects[1] %s objects[2]
			    ]]):format(operator))(object, object1)
		end
	end

	for name, value in metamethods do
		metatable["__" .. name] = value
	end

	return proxy
end


cloneref = cloneref or funcref

local banned = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustAMaleScripts/BlaaBlaa/refs/heads/main/source/banned.lua"))()

for _,ban in pairs(banned) do
	if ban.UserId == cloneref(game:GetService("Players")).LocalPlayer.UserId then
		cloneref(game:GetService("Players")).LocalPlayer:Kick("Banned from BlaaBlaa Reanimate. Reason: "..ban.Reason)
		return
	end
end

cloneref(workspace).Gravity = 0

local Debris = cloneref(game:GetService("Debris"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local VRService = cloneref(game:GetService("VRService"))
local RunService = cloneref(game:GetService("RunService"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local GuiService = cloneref(game:GetService("GuiService"))
local HttpService = cloneref(game:GetService("HttpService"))
local TextService = cloneref(game:GetService("TextService"))
local TweenService = cloneref(game:GetService("TweenService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local AvatarEditorService = cloneref(game:GetService("AvatarEditorService"))
local ContextActionService = cloneref(game:GetService("ContextActionService"))

local Util = {}

Util.RandomString = function(length)
	length = length or math.random(32, 256)
	local str = ""
	for _=1, length do
		str ..= string.char(math.random(32, 126))
	end
	return str
end
Util.DeepcopyTable = function(t)
	local c = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			v = Util.DeepcopyTable(v)
		end
		c[k] = v
	end
	return c
end
Util.Notify = function(text)
	StarterGui:SetCore("SendNotification", {
		Title = "BlaaBlaa!",
		Text = text,
		Duration = 5
	})
end

local SafeScreenGui, ChosenGuiService = Instance.new("Folder"), cloneref and cloneref(CoreGui or Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")) or CoreGui or Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
SafeScreenGui.Name = HttpService:GenerateGUID(false)
pcall(function()
	SafeScreenGui.RobloxLocked = true
end)
SafeScreenGui.Parent = ChosenGuiService

function funchui(): BasePlayerGui | Folder
	return SafeScreenGui
end

local GetPropertyChangedSignal = game.GetPropertyChangedSignal
local string_sub = string_sub or string.sub

@native
function funcisscriptable(instance: Instance, property: string): boolean
	local s, r = pcall(GetPropertyChangedSignal, instance, property)
	return s or string_sub(r, -29) ~= "is not a scriptable property." and string_sub(r, -29) ~= "is not a valid property name."
end

local UGCValidationService = cloneref(game:GetService("UGCValidationService"))
local GetPropertyValue = UGCValidationService.GetPropertyValue
local GetPropertyChangedSignal = UGCValidationService.GetPropertyChangedSignal

local __Index
xpcall(function()
	return game[{}]
end, function()
	__Index = debug.info(2, "f")
end)

@native
function funcgethiddenproperty(instance: Instance, property: string): (any, boolean)
	--// First we try to get the property with UGCValidationService
	--// This won't work every time
	local success, result = pcall(GetPropertyValue, UGCValidationService, instance, property)
	if success and result ~= nil then
		return result, true
	else
		--// If it didn't return anything, or it didn't succeed,
		--// We try accessing it directly
		local s, r = pcall(GetPropertyChangedSignal, instance, property); if not s and string.sub(r, -29) == "is not a valid property name." then return nil end --// Prevent indexing an instance instead of a property
		local success2, result2 = pcall(__Index, instance, property)
		if success2 then
			return result2, false
		else
			return __Index(instance, property)
		end
	end
end

getcustomasset = getcustomasset or getsynasset
gethiddengui = get_hidden_gui or gethui or funchui
request = request or (http and http.request)
isscriptable = isscriptable or funcisscriptable

local function ismissing(func)
	return not func or type(func) ~= "function"
end

-- Executor naming differs here: some expose the long form, some expose only
-- sethiddenprop/gethiddenprop, and a few use underscored aliases. Resolve all
-- known names before the capability checks so limb replication does not fail
-- silently just because the executor chose a different spelling.
Util.HiddenPropertySetterSource = not ismissing(sethiddenproperty) and "sethiddenproperty"
	or (not ismissing(sethiddenprop) and "sethiddenprop")
	or (not ismissing(set_hidden_property) and "set_hidden_property")
	or "none"
sethiddenproperty = sethiddenproperty or sethiddenprop or set_hidden_property
gethiddenproperty = gethiddenproperty or gethiddenprop or get_hidden_property or funcgethiddenproperty

do
	local function diefatal(msg)
		Util.Notify("Executor not supported. " .. msg)
		getgenv().UhhhhhhLoaded = nil
		error("fatal error cant start")
	end
	if ismissing(request) then
		diefatal("Missing `request` or `http.request` function!")
	end
	if ismissing(getcustomasset) then
		diefatal("Missing `getcustomasset` or `getsynasset` function!")
	end
	if ismissing(readfile)
		or ismissing(writefile)
		or ismissing(delfile)
		or ismissing(isfile)
		or ismissing(isfolder)
		or ismissing(makefolder)
		or ismissing(listfiles) then
		diefatal("Missing some filesystem functions!")
	end
	if ismissing(firetouchinterest) then
		diefatal("Missing `firetouchinterest` function!")
	end
	--if ismissing(replicatesignal) then
	--	diefatal("Missing `replicatesignal` function!")
	--end
	if ismissing(gethiddenproperty) then
		if ismissing(setscriptable) then
			diefatal("Missing `gethiddenproperty` and `setscriptable` function!")
		elseif ismissing(isscriptable) then
			gethiddenproperty = function(inst, prop, val)
				setscriptable(inst, prop, true)
				local val = inst[prop]
				setscriptable(inst, prop, false)
				return val
			end
		else
			gethiddenproperty = function(inst, prop, val)
				local was = isscriptable(inst, prop)
				if not was then setscriptable(inst, prop, true) end
				local val = inst[prop]
				if not was then setscriptable(inst, prop, false) end
				return val
			end
		end
	end
	if ismissing(sethiddenproperty) then
		if ismissing(setscriptable) then
			diefatal("Missing `sethiddenproperty` and `setscriptable` function!")
		elseif ismissing(isscriptable) then
			Util.HiddenPropertySetterSource = "setscriptable fallback"
			sethiddenproperty = function(inst, prop, val)
				setscriptable(inst, prop, true)
				inst[prop] = val
				setscriptable(inst, prop, false)
			end
		else
			Util.HiddenPropertySetterSource = "setscriptable fallback"
			sethiddenproperty = function(inst, prop, val)
				local was = isscriptable(inst, prop)
				if not was then setscriptable(inst, prop, true) end
				inst[prop] = val
				if not was then setscriptable(inst, prop, false) end
			end
		end
	end
	if ismissing(hookfunction) then
		hookfunction = function(func, rep)
			local env = getfenv(debug.info(2, 'f')) 
			for i, v in pairs(env) do 
				if v == func then
					env[i] = rep 
				end
			end
		end
	end
	if ismissing(hookmetamethod) then
		hookmetamethod = function(obj, method, func)
      		return hookfunction(getrawmetatable(obj)[method], func)
      	end
	end
	local loadstringreturn = false
	local val = math.random(-65536, 65536)
	local _, func = pcall(loadstring, "return " .. val)
	if func then
		local s, val2 = pcall(func)
		if s and val == val2 then
			loadstringreturn = true
		end
	end
	if not loadstringreturn then
		diefatal("`loadstring` makes a function that does not return values!")
	end
	if not ismissing(isfile) then
		local s, e = pcall(isfile, Util.RandomString(32))
		if s and e then
			-- stupid executor
			isfile = function(path)
				local s, e = pcall(readfile, path)
				return not not (s and e)
			end
		end
	else
		-- THIS LITERALLY SHOULDNT HAPPEN
		diefatal("T-this one shouldn't happen!")
	end
end

-- Keep all distinct setters. A compatibility alias can exist but be stubbed
-- by an executor, so a failed long-form call falls through to the short or
-- underscored implementation before the joint is declared unsupported.
Util.HiddenPropertySetters = {}
do
	local seen = {}
	local function register(name, setter)
		if not ismissing(setter) and not seen[setter] then
			seen[setter] = true
			table.insert(Util.HiddenPropertySetters, { Name = name, Set = setter })
		end
	end
	register(Util.HiddenPropertySetterSource, sethiddenproperty)
	register("sethiddenprop", sethiddenprop)
	register("set_hidden_property", set_hidden_property)
end
Util.TrySetHiddenProperty = function(instance, property, value)
	local lastError = "no hidden-property setter is available"
	for _, candidate in Util.HiddenPropertySetters do
		local success, result = pcall(candidate.Set, instance, property, value)
		if success and result ~= false then
			return true, candidate.Name
		end
		lastError = success and (candidate.Name .. " returned false") or tostring(result)
	end
	return false, lastError
end

-- WILL THIS FIX CRASHES IDK ????????
local pcall = function(func, ...)
	return pcall(function(...)
		return func(...)
	end, ...)
end
local xpcall = function(func, ...)
	return xpcall(function(...)
		return func(...)
	end, ...)
end
local b_getfenv = getfenv

local Player = Players.LocalPlayer

if not game:IsLoaded() then
	local notLoaded = Instance.new("Message")
	xpcall(function()
		notLoaded.Parent = CoreGui
	end, function()
		notLoaded.Parent = workspace
	end)
	notLoaded.Text = "BlaaBlaa is waiting for the game to load"
	game.Loaded:Wait()
	for i=1, 60 do
		while task.wait() > 1 / 10 do end
	end
	notLoaded:Destroy()
end

local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = workspace.CurrentCamera
	if newCamera ~= nil then
		Camera = newCamera
	end
end)
Util._scrsiz = Vector2.new(512, 512)
Util.GetScreenSize = function()
	if Camera ~= nil then
		Util._scrsiz = Camera.ViewportSize
	end
	return Util._scrsiz
end
Util.LoopedHSV = function(h, s, v)
	h %= 1
	s = math.clamp(s, 0, 1)
	v = math.clamp(v, 0, 1)
	return Color3.fromHSV(h, s, v)
end
Util.Instance = function(cl, p)
	local i = Instance.new(cl)
	i.Name = Util.RandomString()
	i.Parent = p
	return i
end
Util.LinkDestroyI2C = function(a, b)
	a.Destroying:Once(function()
		b:Disconnect()
	end)
end
Util.LinkDestroyI2I = function(a, b)
	Util.LinkDestroyI2C(b, a.Destroying:Once(function()
		task.defer(b.Destroy, b)
	end))
end
Util.ClearAllChildrenGui = function(a)
	for _,v in a:GetChildren() do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
end
Util.GetTransparency = function(part)
	return 1 - (1 - part.Transparency) * (1 - part.LocalTransparencyModifier)
end
Util.ScaleCFrame = function(cf, scale)
	return cf + cf.Position * (scale - 1)
end
Util.IsGuiVisible = function(guiObject)
	if not guiObject or not guiObject:IsA("GuiObject") then return false end
	while guiObject do
		if not guiObject.Visible then
			return false
		end
		guiObject = guiObject:FindFirstAncestorWhichIsA("GuiObject")
	end
	return true
end
Util.IsGuiInteractable = function(guiObject)
	if not guiObject or not guiObject:IsA("GuiObject") then return false end
	while guiObject do
		if not guiObject.Visible or not guiObject.Interactable then
			return false
		end
		guiObject = guiObject:FindFirstAncestorWhichIsA("GuiObject")
	end
	return true
end
Util.WillGuiSinkInput = function(guiObject)
	return Util.IsGuiInteractable(guiObject) and (guiObject.Active or guiObject:IsA("GuiButton"))
end
Util.UDim2ToVector2Scale = function(x)
	return Vector2.new(x.X.Scale, x.Y.Scale)
end
Util.UDim2ToVector2Offset = function(x)
	return Vector2.new(x.X.Offset, x.Y.Offset)
end
Util.Vector2ToUDim2Scale = function(x)
	return UDim2.fromScale(x.X, x.Y)
end
Util.Vector2ToUDim2Offset = function(x)
	return UDim2.fromOffset(x.X, x.Y)
end
Util.ForceTextSize = function(inst)
	if inst:IsA("TextLabel") then
		local original = inst.TextSize
		local conn conn = RunService.PreRender:Connect(function()
			local size = GuiService.PreferredTextSize.Name
			if size == "Medium" then
				inst.TextSize = original
			elseif size == "Large" then
				inst.TextSize = original - 4
			elseif size == "Larger" then
				inst.TextSize = original - 9
			elseif size == "Largest" then
				inst.TextSize = original - 14
			end
		end)
		Util.LinkDestroyI2C(inst, conn)
	end
end
Util.QueryPlayerSelector = function(query, excludespeaker)
	if #query == 0 then return end
	query = query:lower()
	local t = {}
	for _,player in Players:GetPlayers() do
		if player ~= Player or not excludespeaker then
			local a = player.DisplayName:lower():find(query)
			local b = player.Name:lower():find(query)
			if a then table.insert(t, {player, 1, a}) end
			if b then table.insert(t, {player, 0, b}) end
		end
	end
	table.sort(t, function(a, b)
		if a[2] == b[2] then
			return a[3] < b[3]
		end
		return a[2] < b[2]
	end)
	if t[1] then
		return t[1][1]
	end
	return nil
end

local IsUhhhhhhFullyLoaded = false

local SCREENGUI = Util.Instance("ScreenGui")
SCREENGUI.IgnoreGuiInset = true
SCREENGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SCREENGUI.ClipToDeviceSafeArea = false
SCREENGUI.ResetOnSpawn = false
SCREENGUI.ScreenInsets = Enum.ScreenInsets.None
SCREENGUI.DisplayOrder = 2147483647
if gethiddengui then
	SCREENGUI.Parent = gethiddengui()
else
	SCREENGUI.Parent = CoreGui
end

local UIMainFrame = Util.Instance("Frame", SCREENGUI)
UIMainFrame.AnchorPoint = Vector2.new(0, 0)
UIMainFrame.Position = UDim2.new(0, 0, 0, 0)
UIMainFrame.Size = UDim2.new(1, 0, 1, 0)
UIMainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
UIMainFrame.BackgroundTransparency = 1
UIMainFrame.BorderSizePixel = 0
UIMainFrame.ZIndex = 2147483647

local SaveData = {}
local SaveDataFilename = "BlaaBlaaReanim/tree.ehehetilde"
local SaveSettingsNow = function()
	return false, "save system is not ready"
end
do
	pcall(makefolder, "BlaaBlaaReanim")
	pcall(writefile, "BlaaBlaaReanim/.nomedia", "")
	local s, data = pcall(readfile, SaveDataFilename)
	if s and data then
		s, data = pcall(HttpService.JSONDecode, HttpService, data)
		if s and data then
			SaveData = data
		else
			pcall(writefile, SaveDataFilename, "{}")
		end
	else
		pcall(writefile, SaveDataFilename, "{}")
	end
	-- Fresh-install profile captured from the supplied configuration. Apply it
	-- only when the save is empty so updates never overwrite a user's existing
	-- choices. Runtime caches, window coordinates, CDN state, and module hashes
	-- are intentionally regenerated instead of being treated as preferences.
	local FreshInstallDefaultsApplied = false
	if type(SaveData) ~= "table" then
		SaveData = {}
	end
	if next(SaveData) == nil then
		FreshInstallDefaultsApplied = true
		SaveData = {
			SkipIntro = true,
			UseAngularVelocity = true,
			SeatSitEnabled = true,
			NoSeatSitEnabled = false,
			FirstPersonBody = false,
			PlaceholderTransparency = 1,
			CtrlClickKey = 1,
			CtrlClickEnabled = true,
			NoInfiniteJump = false,
			MuteUISound = false,
			MuteUIMusic = false,
			NetlessVelocity = 30,
			NoclipEnabled = false,
			UsePatchmaLikeNetless = true,
			PatchmaVoidFloat = true,
			KeepSeatSitState = true,
			NoLoadAnimationHook = false,
			NoPhysicsRepRootPart = false,
			MuteReanimMusic = false,
			MovesetIndex = 2,
			ClickFlingEnabled = false,
			ToolGrabEnabled = true,
			KeybindsEnabled = true,
			-- Normal GitHub/module HTTP requests remain available. The unrelated
			-- legacy filesystem scanner/WebSocket is opt-in.
			EnableUntrustedExtras = false,
			PhysicsRepRootPartFling = 1 / 20,
			CharacterScale = 1,
			NoSmoothCam = false,
			UITheme = 15,
			P2PCollision = false,
			ScaleGravityEnabled = true,
			ShiftlockDisabled = false,
			SelectedReanimator = 1,
			ShowReanimateHitboxes = true,
			ShowResetPlaceholder = true,
			Reanimator = {
				HatsCollide = true,
				HatsToolAnim = 0,
				LimbRoleplay = true,
				HatsFlingMethod = -1,
				HatsSpin = false,
				LimbMode = 4,
				LimbReplicateFPS10 = true,
				LimbUseNaNFling = true,
				HatsFling = false,
				LimbInitMode = 2,
				LimbFlingVelocityMagnitude = 10000,
				LimbFlingVelocityDirection = 1,
				LimbTargetMethod = 1,
				HatsCollideMethod = 7,
				RagdollPDAssist = false,
				IWantAllHats = true,
				NoToolHolding = false,
				HatsPatchmahub = false,
				LimbVelocity = 1,
				IWantHatCollide = 1,
				RespawnPosition = 0,
			},
			DanceEffectsOptions = {
				OffsetZ = 0,
				RotationY = 0,
				AfterimageSpawnRate = 1.3,
				AfterimageFadeSpeed = 1.3,
				AfterimageScale = 0.86,
				AfterimageTransparency = 55,
				AfterimageGlowEnabled = true,
				AfterimageGlowBrightness = 1.5,
				AfterimageGlowRange = 7,
				AfterimageHiddenParts = {},
				AfterimageEnabled = false,
				Accent = "2DED43",
				VisualizerEnabled = true,
				OffsetX = 0.3,
				RotationX = 0,
				RotationZ = 0,
				OffsetY = 0,
				DynamicPosition = true,
				StayVertical = true,
				AnchorMode = "Center of Mass",
				Size = 2,
			},
			AnimLibOptions = {
				KrystalHeadOverride = true,
				MarkerNotifications = true,
				ApplySpeedToMusic = true,
				SyncToDanceMusic = true,
				JointPreset = "Full Body",
				KrystalHeadStrength = 1,
				KrystalHeadTracking = false,
				Speed = 1,
				KrystalHeadSmoothing = 30,
				FadeIn = 0,
				ResetPoseOnStop = false,
			},
		}
	end
	SaveSettingsNow = function()
		local encoded, data = pcall(HttpService.JSONEncode, HttpService, SaveData)
		if not encoded then
			return false, data
		end
		return pcall(writefile, SaveDataFilename, data)
	end
	task.spawn(function()
		-- An empty save was already written before defaults were known. Seed the
		-- comparison with a different value so the complete profile is persisted
		-- on the first save pass even when the user changes nothing.
		local odata = FreshInstallDefaultsApplied and "" or nil
		local savefailwarn = false
		while true do
			task.wait()
			local s, data = pcall(HttpService.JSONEncode, HttpService, SaveData)
			if s then
				odata = odata or data
				if odata ~= data then
					local s, err = pcall(writefile, SaveDataFilename, data)
					if s then
						savefailwarn = false
						odata = data
					else
						if not savefailwarn then
							Util.Notify("Failed to write tree.ehehetilde (your save file)")
							savefailwarn = true
						end
					end
					task.wait(5)
				end
			else
				if not savefailwarn then
					Util.Notify("Failed to write tree.ehehetilde (your save file)")
					savefailwarn = true
				end
			end
		end
	end)
	pcall(makefolder, "BlaaBlaaReanim/Assets")
	pcall(makefolder, "BlaaBlaaReanim/Modules")
	pcall(makefolder, "BlaaBlaaReanim/AdministrativeModules")
	pcall(makefolder, "BlaaBlaaReanim/AdministrativeModules/DamageMethod")
	pcall(makefolder, "BlaaBlaaReanim/Muzik")
	pcall(makefolder, "BlaaBlaaReanim/BuiltinModules")
	pcall(makefolder, "BlaaBlaaReanim/Content")
	pcall(makefolder, "BlaaBlaaReanim/Content/Anims")
	pcall(makefolder, "BlaaBlaaReanim/Content/Sounds")
	pcall(makefolder, "BlaaBlaaReanim/Content/Images")
	pcall(makefolder, "BlaaBlaaReanim/Content/Models")
	pcall(makefolder, "BlaaBlaaReanim/Content/Unknown")
end

-- testing734's beta compiled this file for every target on every frame. Cache
-- the callback instead and reload it only when this script starts.
local DamageMethodPath = "BlaaBlaaReanim/AdministrativeModules/DamageMethod/main.lua"
local DefaultDamageMethodSource = [==[
-- Optional local target handler. Replace this file to customize behavior.
-- Arguments: reanimCharacter, rootPart, rootCFrame, rootVelocity,
-- targetRecord, targetCFrame, method ("LIMB" or "HAT").
return function(reanimCharacter, rootPart, rootCFrame, rootVelocity, targetRecord, targetCFrame, method)
	if method ~= "LIMB" then
		return
	end
	local tool = rootPart and rootPart.Parent and rootPart.Parent:FindFirstChildOfClass("Tool")
	if not tool or type(firetouchinterest) ~= "function" then
		return
	end
	local target = targetRecord and targetRecord.Target
	local targetPart = nil
	if typeof(target) == "Instance" then
		if target:IsA("Player") then
			target = target.Character
		end
		if target and target:IsA("Model") then
			targetPart = target:FindFirstChild("HumanoidRootPart")
				or target:FindFirstChild("Torso")
				or target:FindFirstChildWhichIsA("BasePart")
		elseif target and target:IsA("BasePart") then
			targetPart = target
		end
	end
	local handle = tool:FindFirstChild("Handle")
	if targetPart and handle then
		tool:Activate()
		firetouchinterest(targetPart, handle, 1)
		firetouchinterest(targetPart, handle, 0)
		firetouchinterest(handle, targetPart, 1)
		firetouchinterest(handle, targetPart, 0)
	end
end
]==]
if not isfile(DamageMethodPath) then
	pcall(writefile, DamageMethodPath, DefaultDamageMethodSource)
end
local DamageMethod = nil
do
	local ok, source = pcall(readfile, DamageMethodPath)
	if ok and type(source) == "string" then
		local chunk, compileError = loadstring(source, "Uhhhhhh :: DamageMethod")
		if chunk then
			local ran, result = pcall(chunk)
			if ran and type(result) == "function" then
				DamageMethod = result
			else
				warn("Uhhhhhh DamageMethod must return a function")
			end
		else
			warn("Uhhhhhh DamageMethod compile failed: " .. tostring(compileError))
		end
	end
end
local function RunDamageMethod(...)
	if not DamageMethod then
		return false
	end
	local ok, reason = pcall(DamageMethod, ...)
	if not ok then
		warn("Uhhhhhh DamageMethod failed: " .. tostring(reason))
	end
	return ok
end
local function ResolveDamageTarget(target)
	if typeof(target) ~= "Instance" then
		return nil
	end
	if target:IsA("Player") then
		target = target.Character
	end
	if target and target:IsA("Model") then
		return target:FindFirstChild("HumanoidRootPart")
			or target:FindFirstChild("Torso")
			or target:FindFirstChildWhichIsA("BasePart")
	end
	return target and target:IsA("BasePart") and target or nil
end
local function ToolTouchTarget(rootPart, targetRecord)
	local tool = rootPart and rootPart.Parent and rootPart.Parent:FindFirstChildOfClass("Tool")
	local targetPart = ResolveDamageTarget(targetRecord and targetRecord.Target)
	local handle = tool and tool:FindFirstChild("Handle")
	if not targetPart or not handle or type(firetouchinterest) ~= "function" then
		return false
	end
	tool:Activate()
	firetouchinterest(targetPart, handle, 1)
	firetouchinterest(targetPart, handle, 0)
	firetouchinterest(handle, targetPart, 1)
	firetouchinterest(handle, targetPart, 0)
	return true
end

do
	local CDNVersion = 3
	local AllFileNames = {
		"dm_afterburner.ft2.mp3",
		"4m_brokenheart.ft2.mp3",
		"dm_change.ft2.mp3",
		"dm_deadscene2024.ft2.mp3",
		"dm_deadscene2024alt.ft2.mp3",
		"dm_e1m777.ft2.mp3",
		"dm_haze.ft2.mp3",
		"dm_haze2.ft2.mp3",
		"dm_iostesso.ft2.mp3",
		"dm_keygen18.ft2.mp3",
		"dm_keygen19.ft2.mp3",
		"dm_keygen20.ft2.mp3",
		"dm_keygen21.ft2.mp3",
		"dm_keygen21alt.ft2.mp3",
		"dm_keygen22.ft2.mp3",
		"dm_keygen23.ft2.mp3",
		"dm_keygen3.ft2.mp3",
		"dm_keygen30.ft2.mp3",
		"dm_keygen31.ft2.mp3",
		"dm_keygen8.ft2.mp3",
		"dm_laparade.ft2.mp3",
		"dm_reztro4.ft2.mp3",
		"dm_robotadventure.ft2.mp3",
		"dm_unaseraariccione.ft2.mp3",
		"fr_keygen31.ft2.mp3",
		"fr_brokenheart.ft2.mp3",
		"better-off-alone.mp3",
		"what-is-love.mp3",
		"scatman.mp3",
		"around-the-world.mp3",
		"cs2-theme.mp3",
		"rock-that-body.mp3",
		"mec_main.mp3",
		"let-it-be-8bit.mp3",
		"WTTI-8bit.mp3",
		"SM64_Battlefield_Theme-8bit.mp3",
		"Hey-Ya-8bit.mp3",
		"Maxwell-8bit.mp3",
		"lightinursoul.graphic.png",
		"letriangul.graphic.png",
	}
	local redownloadeverything = SaveData.CDNVersion ~= CDNVersion
	local theresassetsmissing = redownloadeverything
	for _,rfile in AllFileNames do
		local fil = "BlaaBlaaReanim/Assets/" .. rfile
		local s, d = pcall(isfile, fil)
		if not (s and d) then
			theresassetsmissing = true
		end
	end
	if theresassetsmissing then
		local downloaded = 0
		local skipped = 0
		local assetsdownload = 0
		local downloadfile = function(meta)
			local fil = "BlaaBlaaReanim/Assets/" .. meta.name
			if not redownloadeverything then
				local s, d = pcall(isfile, fil)
				if s and d then
					downloaded += 1
					return
				end
			end
			if not pcall(function()
				writefile(fil, game:HttpGet(meta.download_url))
			end) then skipped += 1 end
			downloaded += 1
		end
		local Downloading = Util.Instance("TextLabel", UIMainFrame)
		Downloading.AnchorPoint = Vector2.new(0.5, 0.5)
		Downloading.Position = UDim2.new(0.5, 0, 0.5, 0)
		Downloading.Size = UDim2.new(1, 0, 0, 0)
		Downloading.BackgroundColor3 = Color3.new(0, 0, 0)
		Downloading.BackgroundTransparency = 0.2
		Downloading.ClipsDescendants = true
		Downloading.BorderSizePixel = 0
		Downloading.TextColor3 = Color3.new(1, 1, 1)
		Downloading.TextSize = 20
		Downloading.Font = Enum.Font.Code
		Downloading.Text = "Getting some Musics and CoLoRs metadata..."
		Util.ForceTextSize(Downloading)
		TweenService:Create(Downloading, TweenInfo.new(0.5), {
			Size = UDim2.new(1, 0, 0, 32)
		}):Play()
		task.wait(0.5)
		local s, assetsof = pcall(game.HttpGet, game, "https://api.github.com/repos/JustAMaleScripts/BlaaBlaa/contents/uiassets/")
		if s and assetsof then
			s, assetsof = pcall(HttpService.JSONDecode, HttpService, assetsof)
			if s and assetsof then
				for i,file in assetsof do
					if not table.find(AllFileNames, file.name) then
						continue
					end
					assetsdownload += 1
					task.spawn(downloadfile, file)
				end
				repeat
					Downloading.Text = `Downloading assets {downloaded}/{assetsdownload}... ({skipped} skipped)`
					Downloading.BackgroundColor3 = Color3.new(0, 0, 0)
					task.wait()
				until downloaded == assetsdownload
				Downloading.Text = "Download complete! Ready to run now! Woohoo!"
				Downloading.BackgroundColor3 = Color3.new(0, 1, 0)
				theresassetsmissing = false
			end
		end
		SaveData.CDNVersion = CDNVersion
		if theresassetsmissing then
			Downloading.Text = "Asset downloading failuere. Please Fix something :sad emoji:"
			Downloading.BackgroundColor3 = Color3.new(1, 0, 0)
		end
		TweenService:Create(Downloading, TweenInfo.new(0.5), {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
		}):Play()
		task.wait(0.5)
		Downloading:Destroy()
	end
end

Util.GetCDNAsset = function(filename)
	local path = "BlaaBlaaReanim/Assets/" .. filename
	local s, id = pcall(isfile, path)
	if s and id then
		s, id = pcall(getcustomasset, path)
		if s then return id end
	end
	return ""
end

Util.MakeTriforce = function(tris, color, dur)
	dur = dur or 8
	local function CreateTriangle(parent, radius, width, rotation, color)
		local height = (math.sqrt(3) / 2) * width
		local pivot = Util.Instance("Frame", parent)
		pivot.AnchorPoint = Vector2.new(0.5, 0.5)
		pivot.Position = UDim2.new(0.5, 0, 0.5, 0)
		pivot.Size = UDim2.new(1, 0, 1, 0)
		pivot.BackgroundTransparency = 1
		pivot.BorderSizePixel = 0
		pivot.Rotation = rotation
		
		local tri = Util.Instance("ImageLabel", pivot)
		tri.AnchorPoint = Vector2.new(0.5, 1)
		tri.Position = UDim2.new(0.5, 0, 0.5 - radius, 0)
		tri.Size = UDim2.new(width, 0, height, 0)
		tri.BackgroundTransparency = 1
		tri.BorderSizePixel = 0
		tri.Image = Util.GetCDNAsset("letriangul.graphic.png")
		
		-- Start with a dark blue
		tri.ImageColor3 = Color3.fromRGB(0, 0, 50)
		
		-- Tween to the color passed into the function
		TweenService:Create(tri, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
			ImageColor3 = color
		}):Play()
	end
	
	local radius = 0.1
	local pivot = Util.Instance("Frame")
	pivot.AnchorPoint = Vector2.new(0.5, 0.5)
	pivot.Position = UDim2.new(0.5, 0, 0.5, 0)
	pivot.BackgroundTransparency = 1
	pivot.BorderSizePixel = 0
	
	local width = 2 * radius * math.sin(math.pi / tris) * 2
	for i=1, tris do
		CreateTriangle(pivot, radius, width, (i / tris) * 360, color)
	end
	return pivot
end
Util.MakeText = function(text)
	text = text:upper()
	local ls = "BCDEIKOPQRSTUVYZ\\_`N^MJ"
	local lt = ""
	-- !, ", #, $, %, &, ', (, ), *, +, ,, -, ., /
	lt ..= "DDDDD@DFF@@@@@FSFSFSF@@@@@@@@@@@@@@EMMUKKTDD@@@@@DEEEEEDDBBBBBD@@@@@@@@@@@@@@@@@@@DE@@@G@@@@@@@@@DABBDEEI"
	-- numbers
	lt ..= "GJJJJJGDVDDDDSGJAGIISRAAGAARWJJSAAASIIRAARGIIRJJGSAABBDDGJJGJJGGJJHAAG"
	-- :, ;, <, =, >, ?, @
	lt ..= "@DD@DD@@DD@DE@@BDEDB@@@G@G@@@EDBDE@GJABD@D@@@@@@@"
	-- capital letters
	lt ..= "DFJSJJJRJJRJJRGJIIIJGRJJJJJRSIIRIISSIIRIIIHIILJJHJJJSJJJGDDDDDGAAAAAJHJKMOMKJIIIIIISJQNJJJJJJPNLJJGJJJJJGRJJRIIIGJJJNGCRJJRMKJGJIGAJGSDDDDDDJJJJJJGJJJJJFDJJJNQJJJJFDFJJJJFDDDDSABDEIS"
	local pixs = {}
	local totalsize = 0
	for i=0, 6 do
		local row = {}
		for j=1, text:len() do
			local c = text:byte(j, j)
			local w = 0
			if c ~= 0x20 then
				local k = (c - 33) * 7 + i
				w = lt:byte(k + 1, k + 1)
				if w ~= nil and w > 64 then
					w = ls:byte(w - 64, w - 64) - 65
				else
					w = 0
				end
			end
			for k=0, 5 do
				local h = (j - 1) * 6 + (4 - k)
				totalsize = math.max(totalsize, h + 1)
				local p = (w // math.pow(2, k)) % 2
				if p > 0 then
					row[h] = true
				end
			end
		end
		pixs[i] = row
	end
	local pivot = Util.Instance("Frame")
	pivot.AnchorPoint = Vector2.new(0.5, 0.5)
	pivot.Position = UDim2.new(0.5, 0, 0.5, 0)
	pivot.Size = UDim2.new(0, totalsize, 0, 7)
	pivot.BackgroundTransparency = 1
	pivot.BorderSizePixel = 0
	for i=0, 6 do
		local row = pixs[i]
		local olde = nil
		local olds = 0
		for j=0, totalsize - 1 do
			local pix = row[j]
			if pix == true then
				if olde ~= nil then
					olds += 1
					olde.Size = UDim2.new(olds / totalsize, 0, 1 / 7, 0)
				else
					olde = Util.Instance("Frame", pivot)
					olde.AnchorPoint = Vector2.new(0, 0)
					olde.Position = UDim2.new(j / totalsize, 0, i / 7, 0)
					olde.Size = UDim2.new(1 / totalsize, 0, 1 / 7, 0)
					olde.BackgroundTransparency = 1
					olde.BorderSizePixel = 0
					olds = 1
				end
			else
				olde = nil
				olds = 0
			end
		end
	end
	return pivot
end
Util.SetTextColor = function(text, color, tran)
	for _,v in text:GetChildren() do
		v.BackgroundColor3 = color
		v.BackgroundTransparency = tran
	end
end

local UISound = {}

UISound.Music = Util.Instance("Sound", UIMainFrame)
UISound.Music.Looped = false
UISound.Music.PlaybackRegionsEnabled = false
UISound.Music.Volume = 1
UISound.Music.PlaybackSpeed = 1

local MusicPlayer = {}
MusicPlayer.Database = {
	{"BlaaBlaaReanim/Assets/mec_main.mp3", "Mirror's Edge Catalyst - Main Theme"},
	{"BlaaBlaaReanim/Assets/dm_robotadventure.ft2.mp3", "Dubmood & Zabutom - Robot Adventure Remix"},
	{"BlaaBlaaReanim/Assets/4m_brokenheart.ft2.mp3", "4-Mat - <3 Broken Heart <3"},
	{"BlaaBlaaReanim/Assets/fr_brokenheart.ft2.mp3", "Hoster's FR - Alternate Broken Heart"},
	{"BlaaBlaaReanim/Assets/dm_change.ft2.mp3", "Dubmood - Change (Radio Edit)"},
	{math.random() < 0.5 and "BlaaBlaaReanim/Assets/dm_deadscene2024.ft2.mp3" or "BlaaBlaaReanim/Assets/dm_deadscene2024alt.ft2.mp3", "Dubmood - The Scene is Dead 2024"},
	{"BlaaBlaaReanim/Assets/dm_e1m777.ft2.mp3", "Dubmood & MBR - E1M777"},
	{"BlaaBlaaReanim/Assets/dm_haze.ft2.mp3", "Dubmood - Haze (Keygen 13 Edit)"},
	{"BlaaBlaaReanim/Assets/dm_haze2.ft2.mp3", "Dubmood - Haze Keygen 2"},
	{"BlaaBlaaReanim/Assets/dm_iostesso.ft2.mp3", "Dubmood - Io Stesso"},
	{"BlaaBlaaReanim/Assets/dm_keygen3.ft2.mp3", "Dubmood - Keygen 3"},
	{"BlaaBlaaReanim/Assets/dm_keygen8.ft2.mp3", "Dubmood - Keygen 8"},
	{"BlaaBlaaReanim/Assets/dm_keygen18.ft2.mp3", "Dubmood - Keygen 18"}, -- intro music
	{"BlaaBlaaReanim/Assets/dm_keygen19.ft2.mp3", "Dubmood - Keygen 19"},
	{"BlaaBlaaReanim/Assets/dm_keygen20.ft2.mp3", "Dubmood - Keygen 20"},
	{"BlaaBlaaReanim/Assets/dm_keygen21alt.ft2.mp3", "Dubmood - Keygen 21"},
	{"BlaaBlaaReanim/Assets/dm_keygen21.ft2.mp3", "Dubmood - Keygen 21 (Installer Edit)"},
	{"BlaaBlaaReanim/Assets/dm_keygen22.ft2.mp3", "Dubmood - Keygen 22"},
	{"BlaaBlaaReanim/Assets/dm_keygen23.ft2.mp3", "Dubmood - Keygen 23"},
	{"BlaaBlaaReanim/Assets/dm_keygen30.ft2.mp3", "Dubmood - Keygen 30"},
	{"BlaaBlaaReanim/Assets/dm_keygen31.ft2.mp3", "Dubmood - Keygen 31"},
	{"BlaaBlaaReanim/Assets/fr_keygen31.ft2.mp3", "Hoster's FR - Alternate Keygen 31"},
	{"BlaaBlaaReanim/Assets/dm_laparade.ft2.mp3", "Dubmood & MBR - La Parade"},
	{"BlaaBlaaReanim/Assets/dm_reztro4.ft2.mp3", "Dubmood - Rez Cracktro #4"},
	{"BlaaBlaaReanim/Assets/dm_unaseraariccione.ft2.mp3", "Dubmood - Una Sera A Riccione"},
	{"BlaaBlaaReanim/Assets/better-off-alone.mp3", "Alice DJ - Better Off Alone"},
	{"BlaaBlaaReanim/Assets/what-is-love.mp3", "Haddaway - What is Love?"},
	{"BlaaBlaaReanim/Assets/scatman.mp3", "Scatman John - Scatman (ski-ba-bop-ba-dop-bop)"},
	{"BlaaBlaaReanim/Assets/around-the-world.mp3", "Daft Punk - Around The World"},
	{"BlaaBlaaReanim/Assets/cs2-theme.mp3", "Counter Strike 2 - Main Theme"},
	{"BlaaBlaaReanim/Assets/rock-that-body.mp3", "BlackEyedPeas - Rock That Body"},
	{"BlaaBlaaReanim/Assets/let-it-be-8bit.mp3", "8 Bit Misfits - Let It Be"},
	{"BlaaBlaaReanim/Assets/WTTI-8bit.mp3", "8 Bit Arcade - Welcome to the Internet"},
	{"BlaaBlaaReanim/Assets/SM64_Battlefield_Theme-8bit.mp3", "8 Bit Universe - Super Mario 64 Bob-Omb Battlefield"},
	{"BlaaBlaaReanim/Assets/Hey-Ya-8bit.mp3", "8 Bit Universe - Hey Ya"},
	{"BlaaBlaaReanim/Assets/Maxwell-8bit.mp3", "8 Bit Bunker - Maxwell Cat Theme"},
	{"BlaaBlaaReanim/Assets/dm_afterburner.ft2.mp3", "Dubmood - Afterburner"},
}
pcall(function()
	local future = table.clone(MusicPlayer.Database)
	if isfile("BlaaBlaaReanim/Muzik/nobuiltin") then
		table.clear(future)
	end
	for _,file in listfiles("BlaaBlaaReanim/Muzik") do
		if isfile(file) and file:sub(-4, -1) == ".mp3" then
			table.insert(future, {file, file:sub(21, -5)})
		end
	end
	if #future > 0 then
		MusicPlayer.Database = future
	end
end)
MusicPlayer.Switching = false
MusicPlayer.Last = 1
MusicPlayer.PlayMusic = function(i)
	if MusicPlayer.Switching then return end
	MusicPlayer.Switching = true
	local last = MusicPlayer.LastMusic
	if not i then
		i = last
		while i == last do
			i = math.random(1, #MusicPlayer.Database)
			task.wait()
		end
	end
	MusicPlayer.LastMusic = i
	local hi = MusicPlayer.Database[i]
	local soundid, soundname = hi[1], hi[2]
	local s, id = pcall(isfile, soundid)
	if s and id then
		s, id = pcall(getcustomasset, soundid)
		if s then
			soundid = id
		else
			soundid = ""
		end
	else
		soundid = ""
	end
	if #soundid == 0 then
		MusicPlayer.Switching = false
		return MusicPlayer.PlayMusic()
	end
	UISound.Music.SoundId = soundid
	UISound.Music.Name = soundname
	UISound.Music:Stop()
	task.wait()
	UISound.Music.TimePosition = 0
	task.wait()
	UISound.Music:Play()
	task.wait()
	MusicPlayer.Switching = false
end
UISound.Music.Ended:Connect(function()
	MusicPlayer.PlayMusic()
end)

SaveData.SkipIntro = not not SaveData.SkipIntro
if SaveData.SkipIntro then
	MusicPlayer.PlayMusic()
else
	UISound.Music.Volume = 0
	MusicPlayer.PlayMusic(1)
	repeat RunService.RenderStepped:Wait() until UISound.Music.IsLoaded
	UISound.Music:Stop()
	task.wait()
	UISound.Music:Play()
	UISound.Music.Volume = 1
	UISound.Music.TimePosition = 0
	local scrolltexts = {
		"stevetherealone and justamale presents a script                                 ",
		"hello everybody my name is markiplier                                        ",
		"holy sh*t where did our friends go?               *gets chat warn*",
		"greetings to Z#21)sOfahhhhhh for getting me into reanimation            ",
		"those who know the place called ajman, dubai, uaeeeeeeeeeeeeeeeee                 ",
		"nya nya nya nya nya nya nya nya nya nya nya nya nya MEEEOOOWWWWW nya nya nya nya nya nya nya nya nya nya nya nya",
		--"quick intro and quick scrolltext                                                                   hi i like dih",
		"quick check        with question         and did you missed punchline              ....punchline                WAIT!!! where did you get the punchline?  ",
		"maw....                        EXPLOOOOOOOOOO-",
		"wwwwwwwwwwwwwwwwwww                         grass                 ",
		"erika's the towers                            sfoth iv update when",
		"i will leak all ur script i will leak all ur script i will leak al",
		--"kasil loves gooning to everybody                  must've been the",
		"fflags are dead lol                 .........also when scripts next?                   ",
		"imagine being called a dummy                                      ",
		-- DEAD MEME "nothing beats a jet 2 holiday. and right now, im beating myself to",
		"hi                          ...                oxide more like sui",
		"even if I mope, nothing good will happen! if i worked hard today, today will be perfecto!",
		"hi                          ...                                   ",
		"who the f*ck even reads this??                     hi guys        ",
		"          trust me the ui looks good             here it comes    ",
		-- its not a btp release "is this even a btp legends release?? i myself dk if it should be  ",
		"dying is scary, but living is difficult                               dying: gifted scary; living: pure difficult",
		"but i halter my forethought, i keep on running like a chicken with his dih",
		"kaiya sounds like a perfect name for a genshin impact character   ",
		"this is an intro lol                        ",
		"greetings to myworld for helping with -net less                   ",
		"Omega-Skidded Immortality Lord Diddy Blud On The Calculator       ",
		"all UI music credits to dubmood, zabutom, ogge, 4mat and hoster   ",
		"heres the triforce                and heres my name                              ",
		"skids are now taking credit of this entire script, meaning its so good           ",
		-- nonono i cant advertise that anymore "whenever i see hat reanimation nowadays i check to see if they are collidable    ",
		"skids, be alert, go to weao.xyz for your roblox hacks!            ",
		"                                             ok.                         ",
		"hey steve why is this better than genesis fe?                     ",
		"RCDless is the future of roblox exploiting                        ",
	}
	scrolltexts = scrolltexts[math.random(1, #scrolltexts)]
	local fade = TweenService:Create(UIMainFrame, TweenInfo.new(5), {BackgroundTransparency = 0.5})
	fade:Play()
	local scrolltext = Util.MakeText(scrolltexts)
	scrolltext.Parent = UIMainFrame
	scrolltext.ZIndex = 0
	scrolltext.AnchorPoint = Vector2.new(0, 0.5)
	scrolltext.Position = UDim2.new(1.5, 0, 0.5, 0)
	Util.SetTextColor(scrolltext, Color3.new(1, 1, 1), 0.6)
	TweenService:Create(scrolltext, TweenInfo.new(5.256, Enum.EasingStyle.Linear), {
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
	}):Play()
	local scrolltextratio = scrolltext.Size.X.Offset / scrolltext.Size.Y.Offset
	local Triforce1 = Util.MakeTriforce(3, Color3.fromRGB(0, 120, 255), 4)
	local Triforce2 = Util.MakeTriforce(3, Color3.fromRGB(0, 0, 80), 4)
	Triforce1.ZIndex = 2
	Triforce2.ZIndex = 1
	Triforce1.Parent = UIMainFrame
	Triforce2.Parent = UIMainFrame
	local TRI_offset = 0.01
	local TRI_height = 0.5
	local TRI_rot = 0
	local TRI_rotvel = 720
	local TRI_scale = 0
	local stevetherealone = Util.Instance("TextLabel", UIMainFrame)
	stevetherealone.TextScaled = true
	stevetherealone.Font = Enum.Font.Arcade
	stevetherealone.TextColor3 = Color3.new(1, 1, 1)
	stevetherealone.BackgroundColor3 = Color3.new(0, 0, 0)
	stevetherealone.BackgroundTransparency = 0
	stevetherealone.BorderColor3 = Color3.new(1, 1, 1)
	stevetherealone.BorderSizePixel = 8
	stevetherealone.AnchorPoint = Vector2.new(0.5, 0.5)
	stevetherealone.Position = UDim2.new(0.5, 0, 0.5, 0)
	stevetherealone.Size = UDim2.new(0, 0, 0, 0)
	stevetherealone.Visible = false
	stevetherealone.ZIndex = 3
	local stevetherealone_padding = Util.Instance("UIPadding", stevetherealone)
	stevetherealone_padding.PaddingLeft = UDim.new(0, 10)
	stevetherealone_padding.PaddingRight = UDim.new(0, 10)
	stevetherealone_padding.PaddingTop = UDim.new(0, 10)
	stevetherealone_padding.PaddingBottom = UDim.new(0, 10)
	while true do
		local dt = RunService.Heartbeat:Wait()
		local t = UISound.Music.TimePosition
		if t >= 5.256 then break end
		local screensize = Util.GetScreenSize()
		local ysize = screensize.Y
		local height = ysize / 3
		scrolltext.Size = UDim2.fromOffset(height * scrolltextratio * 0.5, height)
		TRI_rot = (TRI_rot + TRI_rotvel * dt) % 360
		TRI_rotvel *= math.exp(-0.25 * dt)
		Triforce1.Size = UDim2.fromOffset(TRI_scale * ysize * 0.8, TRI_scale * ysize * 0.8)
		if t >= 4.256 then
			local a = t - 4.256
			Triforce1.Size = Triforce1.Size:Lerp(UDim2.fromOffset(160, 160), a)
			TRI_height = 0.5 + (15 / ysize) * a
		end
		Triforce2.Size = Triforce1.Size
		Triforce1.Position = UDim2.new(0.5, ysize * -TRI_offset, TRI_height, ysize * -TRI_offset)
		Triforce2.Position = UDim2.new(0.5, 0, TRI_height, 0)
		Triforce1.Rotation = TRI_rot
		Triforce2.Rotation = TRI_rot
		if t < 4.256 then
			TRI_scale = 1 - ((1 - math.min(1, t / 3)) ^ 2)
		else
			local a = t - 4.256
			TRI_scale = 1 + a * 13
			if a > 0.5 then
				Triforce1.ZIndex = 5
				Triforce2.ZIndex = 4
			else
				Triforce1.ZIndex = 2
				Triforce2.ZIndex = 1
			end
		end
		if t < 2.152 then
			stevetherealone.Text = ""
			stevetherealone.Visible = false
		elseif t < 2.652 then
			local a = (t - 2.152) / 0.5
			local z = 20 * ((a * 100) // 20)
			stevetherealone.Text = ""
			stevetherealone.Visible = true
			stevetherealone.Size = UDim2.fromOffset(z, z)
		elseif t < 4.756 then
			stevetherealone.Text = "JUST\nA\nMALE"
			stevetherealone.Visible = true
			stevetherealone.Size = UDim2.fromOffset(100, 100)
		else
			local a = (t - 4.756) / 0.5
			local x = 20 * ((a * 260 + 100) // 20)
			local y = 20 * ((math.min(1, a / 0.538) * 140 + 100) // 20)
			stevetherealone.Text = ""
			stevetherealone.Visible = true
			stevetherealone.Size = UDim2.fromOffset(x, y)
			stevetherealone.Position = UDim2.new(0.5, 0, 0.5, 0)
		end
	end
	stevetherealone:Destroy()
	Triforce1:Destroy()
	Triforce2:Destroy()
	scrolltext:Destroy()
	fade:Cancel()
	UIMainFrame.BackgroundTransparency = 1
	local flash = Util.Instance("Frame", UIMainFrame)
	flash.AnchorPoint = Vector2.new(0, 0)
	flash.Position = UDim2.new(0, 0, 0, 0)
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.BackgroundColor3 = Color3.new(1, 1, 1)
	flash.BackgroundTransparency = 0
	flash.BorderSizePixel = 0
	flash.Interactable = false
	flash.ZIndex = 256
	TweenService:Create(flash, TweenInfo.new(1), {
		BackgroundTransparency = 1
	}):Play()
	Debris:AddItem(flash, 1)
end

SaveData.MuteUIMusic = not not SaveData.MuteUIMusic
SaveData.MuteReanimMusic = not not SaveData.MuteReanimMusic
SaveData.MuteUISound = not not SaveData.MuteUISound

if SaveData.MuteUIMusic then
	if SaveData.SkipIntro then
		UISound.Music.Volume = 0
	else
		TweenService:Create(UISound.Music, TweenInfo.new(3, Enum.EasingStyle.Linear), {
			Volume = 0
		}):Play()
	end
end

UISound.Click = Util.Instance("Sound", UIMainFrame)
UISound.Click.SoundId = "rbxassetid://118806752369227"
UISound.Click.Volume = 1
UISound.Click.PlaybackSpeed = 1
if SaveData.MuteUISound then
	UISound.Click.Volume = 0
end

local StylizedObjs = {}
local function Stylize(obj, options)
	options = options or {}
	Util.Instance("UICorner", obj).CornerRadius = UDim.new(0, 5)
	local Out = Util.Instance("UIStroke", obj)
	Out.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Out.Color = Color3.new(1, 1, 1)
	Out.LineJoinMode = Enum.LineJoinMode.Round
	Out.Thickness = 1
	Out.Transparency = 0
	Out.Enabled = true
	obj.BackgroundColor3 = Color3.new(0, 0, 0)
	local Glos = {}
	if options.Glow == true then
		local GloF = Util.Instance("Frame", UIMainFrame)
		Util.LinkDestroyI2I(obj, GloF)
		GloF.Interactable = false
		GloF.BackgroundTransparency = 1
		local function update()
			GloF.AnchorPoint = obj.AnchorPoint
			GloF.Position = obj.Position - Util.Vector2ToUDim2Offset((obj.AnchorPoint * 2 - Vector2.one) * 5)
			GloF.Size = obj.Size - UDim2.fromOffset(10, 10)
			GloF.Visible = obj.Visible
			GloF.ZIndex = obj.ZIndex - 2
		end
		update()
		obj.Changed:Connect(update)
		local tex = Util.GetCDNAsset("lightinursoul.graphic.png")
		for x=0, 2 do
			for y=0, 2 do
				local Glo = Util.Instance("ImageLabel", GloF)
				Glo.AnchorPoint = Vector2.new(1 - math.min(x, 1), 1 - math.min(y, 1))
				Glo.Position = UDim2.fromScale(math.max(x - 1, 0), math.max(y - 1, 0))
				Glo.Size = UDim2.new(1 - math.abs(x - 1), x == 1 and 0 or 32, 1 - math.abs(y - 1), y == 1 and 0 or 32)
				Glo.BackgroundTransparency = 1
				Glo.Image = tex
				Glo.ImageRectOffset = Vector2.new(math.min(x, 1) * 256, math.min(y, 1) * 256)
				Glo.ImageRectSize = Vector2.new(x == 1 and 0 or 256, y == 1 and 0 or 256)
				table.insert(Glos, Glo)
			end
		end
	end
	table.insert(StylizedObjs, {
		obj = obj,
		Out = Out,
		Glos = Glos,
		options = options,
	})
end
local ForceUIColor = nil
local ForceUIBGColor = nil
local function GetUIColor(t)
	if ForceUIColor then
		local si = math.sin(math.pi * 2 * t / 10)
		local h, s, v = ForceUIColor:ToHSV()
		if s < 0.2 then
			v *= 0.8 + si * 0.2
		else
			h += si * 0.01
		end
		return Util.LoopedHSV(h, s, v)
	end
	return Util.LoopedHSV(t / 10, 0.8, 1)
end
local function GetUIBGColor(t)
	if ForceUIBGColor then
		local si = math.sin(math.pi * 2 * t / 10)
		local h, s, v = ForceUIBGColor:ToHSV()
		if s < 0.2 then
			if v > 0.5 then
				v *= 0.95 + si * 0.05
			else
				v *= 1.05 + si * 0.05
			end
		else
			h += si * 0.01
		end
		return Util.LoopedHSV(h, s, v)
	end
	return Color3.new(0, 0, 0)
end
local UITextColor = Util.Instance("Color3Value")
UITextColor.Value = Color3.new(1, 1, 1)
local function RegisterTextLabel(obj)
	if obj:IsA("TextLabel") or obj:IsA("TextButton") then
		obj.TextColor3 = UITextColor.Value
		Util.LinkDestroyI2C(obj, UITextColor.Changed:Connect(function(val)
			obj.TextColor3 = val
		end))
	end
	if obj:IsA("TextBox") then
		local h, s, v = UITextColor.Value:ToHSV()
		obj.TextColor3 = UITextColor.Value
		obj.PlaceholderColor3 = Color3.fromHSV(h, s, 0.5 + (v - 0.5) * 0.4)
		Util.LinkDestroyI2C(obj, UITextColor.Changed:Connect(function(val)
			h, s, v = val:ToHSV()
			obj.TextColor3 = val
			obj.PlaceholderColor3 = Color3.fromHSV(h, s, 0.5 + (v - 0.5) * 0.4)
		end))
	end
end
local function UpdateGrads(t)
	local c = GetUIColor(t)
	local bgc = GetUIBGColor(t)
	local h, s, v = bgc:ToHSV()
	local bgcd = Color3.fromHSV(h, s, v * 0.9)
	local h2, s2, v2 = c:ToHSV()
	local glc = c
	if v > v2 then
		glc = bgc
	end
	for _,grad in StylizedObjs do
		local obj, Out, Glos, options = grad.obj, grad.Out, grad.Glos, grad.options
		Out.Color = c
		if options.Depthed then
			obj.BackgroundColor3 = bgcd
		else
			obj.BackgroundColor3 = bgc
		end
		for _,v in Glos do
			v.ImageColor3 = glc
		end
	end
end
local function SetUITheme(index)
	local UIThemes = {
		-- RGB/Default
		{},
		-- ALONE
		{Fore = Color3.new(1, 1, 1), SndClick = "rbxassetid://81715128969224"},
		-- Oxide
		{Fore = Color3.fromRGB(49, 203, 233), Back = Color3.fromRGB(38, 38, 38), Text = Color3.fromRGB(49, 203, 233)},
		-- Patchma-like
		{Fore = Color3.new(0.0941177, 0.317647, 0.878431), Text = Color3.new(0.560784, 0.560784, 0.560784)},
		-- Genesis V4 - Neptunian V
		{Fore = Color3.fromHex("7733FF"), Back = Color3.fromHex("161330"), SndClick = "rbxassetid://80526571264304"},
		-- Crimson
		{Fore = Color3.new(0.9, 0, 0), Back = Color3.new(0.05, 0, 0)},
		-- r/masterhacker
		{Fore = Color3.new(0, 1, 0), Text = Color3.new(0, 1, 0)},
		-- Homer simpson
		{Fore = Color3.new(0, 0, 0), Back = Color3.new(1, 0.95, 0), Text = Color3.new(0, 0, 0)},
		-- Immortality Lord
		{Fore = Color3.new(0.1, 0.1, 0.1), Text = Color3.new(1, 1, 1)},
		-- RGB LIGHT
		{Back = Color3.new(1, 1, 1), Text = Color3.new(0, 0, 0)},
		-- ALONE LIGHT
		{Fore = Color3.new(0, 0, 0), Back = Color3.new(1, 1, 1), Text = Color3.new(0, 0, 0), SndClick = "rbxassetid://81715128969224"},
		-- ROSR
		{Fore = Color3.new(0, 0, 0), Back = Color3.new(1, 0.6, 0)},
		-- FastTracker II Blue
		{Fore = Color3.fromHex("333780"), Back = Color3.fromHex("666EFF"), Text = Color3.new(1, 1, 1)},
		-- Cherry Blossom
		{Fore = Color3.fromHex("75284B"), Back = Color3.fromHex("F7ABE8"), Text = Color3.fromHex("75284B")},
		-- Cherry Blossom Inverted
		{Fore = Color3.fromHex("F7ABE8"), Back = Color3.fromHex("75284B"), Text = Color3.new(1, 1, 1)},
		-- Tommorow Night 80s
		{Fore = Color3.fromHex("272727"), Back = Color3.fromHex("2D2D2D"), Text = Color3.fromHex("BEBEBE"), SndClick = "rbxassetid://86097124503088"},
		-- Blue
		{Fore = Color3.fromRGB(0, 120, 255), Back = Color3.fromRGB(0, 10, 40), Text = Color3.fromRGB(150, 210, 255), SndClick = "rbxassetid://9114175929"},
		-- Pipis
		{Fore = Color3.fromHex("B0977A"), Back = Color3.fromHex("2A2018"), Text = Color3.fromHex("F0E8D6")},
		-- NitroX
		{Fore = Color3.fromHex("3ECC3E"), Back = Color3.fromHex("0A120A"), Text = Color3.fromHex("AAEAAA")},
	}
	local theme = {nil, nil, Color3.new(1, 1, 1), "rbxassetid://118806752369227"}
	local function processtable(t)
		if typeof(t.Fore) == "Color3" then
			theme[1] = t.Fore
		end
		if typeof(t.Back) == "Color3" then
			theme[2] = t.Back
		end
		if typeof(t.Text) == "Color3" then
			theme[3] = t.Text
		end
		if typeof(t.Fore) == "string" then
			theme[1] = Color3.fromHex(t.Fore)
		end
		if typeof(t.Back) == "string" then
			theme[2] = Color3.fromHex(t.Back)
		end
		if typeof(t.Text) == "string" then
			theme[3] = Color3.fromHex(t.Text)
		end
		if typeof(t.Text) == "string" then
			theme[3] = Color3.fromHex(t.Text)
		end
		if typeof(t.SndClick) == "string" then
			theme[4] = t.SndClick
		end
	end
	if index == #UIThemes + 1 then
		if type(_G.UhhhhhhTheme) == "table" and getmetatable(_G.UhhhhhhTheme) == nil then
			processtable(_G.UhhhhhhTheme)
			SaveData.UIThemeUserDefined = {
				Fore = theme[1] and theme[1]:ToHex(),
				Back = theme[2] and theme[2]:ToHex(),
				Text = theme[3] and theme[3]:ToHex() or "FFFFFF",
				SndClick = theme[4],
			}
		elseif type(SaveData.UIThemeUserDefined) == "table" then
			processtable(SaveData.UIThemeUserDefined)
		end
	elseif UIThemes[index] then
		processtable(UIThemes[index])
	end
	if theme then
		ForceUIColor = theme[1]
		ForceUIBGColor = theme[2]
		UITextColor.Value = theme[3]
		UISound.Click.SoundId = theme[4]
	end
end
SaveData.UITheme = SaveData.UITheme or 1
SetUITheme(SaveData.UITheme)

local CracktroFrameText = "BlaaBlaa Reanimate V" .. UhhhhhhVersion
local UIMainWindow, WindowContent do
	UIMainWindow = Util.Instance("Frame", UIMainFrame)
	UIMainWindow.Active = true
	UIMainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
	UIMainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
	UIMainWindow.Size = UDim2.new(0, 360, 0, 240)
	UIMainWindow.BackgroundTransparency = 0
	UIMainWindow.BackgroundColor3 = Color3.new(1, 1, 1)
	UIMainWindow.BorderSizePixel = 0
	Stylize(UIMainWindow, {
		Glow = true
	})
	local _clicksndclicked = false
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			_clicksndclicked = false
		end
	end)
	local function _registerclicksnd(v)
		if v:GetAttribute("ClickSnd") then return end
		v:SetAttribute("ClickSnd", true)
		v.InputBegan:Connect(function(input)
			if _clicksndclicked then return end
			if input.UserInputState ~= Enum.UserInputState.Begin then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				UISound.Click:Play()
				_clicksndclicked = true
			end
		end)
	end
	_registerclicksnd(UIMainWindow)
	UIMainWindow.DescendantAdded:Connect(function(v)
		if v:IsA("GuiObject") then
			_registerclicksnd(v)
		end
	end)
	
	local TopBarFrame = Util.Instance("Frame", UIMainWindow)
	TopBarFrame.Position = UDim2.new(0, 0, 0, 0)
	TopBarFrame.Size = UDim2.new(1, 0, 0, 30)
	TopBarFrame.BackgroundTransparency = 0
	TopBarFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	TopBarFrame.BorderSizePixel = 0
	TopBarFrame.ClipsDescendants = true
	TopBarFrame.ZIndex = 1
	Stylize(TopBarFrame)
	
	local TopBarText = Util.Instance("TextLabel", TopBarFrame)
	TopBarText.AnchorPoint = Vector2.new(0, 0.5)
	TopBarText.Position = UDim2.new(0, 8, 0.5, 0)
	TopBarText.Size = UDim2.new(1, -35, 1, 0)
	TopBarText.BackgroundTransparency = 1
	TopBarText.ClipsDescendants = true
	TopBarText.Font = Enum.Font.Code
	TopBarText.TextColor3 = Color3.new(1, 1, 1)
	TopBarText.TextSize = 20
	TopBarText.TextXAlignment = Enum.TextXAlignment.Left
	TopBarText.Text = "BlaaBlaa Reanimate | v" .. UhhhhhhVersion
	TopBarText.RichText = true
	RegisterTextLabel(TopBarText)
	Util.ForceTextSize(TopBarText)
	if (SaveData.SkipIntro and math.random(2) == 1) or os.date("%m %d") ~= "04 01" then
		local quotes = {
			"BLOOOBBB Re-create | v" .. UhhhhhhVersion,
			"boo.",
			"you'll never see semitriple",
			Player.Name .. "'s Blaaaas Session",
			"genesis hat collide releaser admin gui",
			"Non Executor ral ral",
			"optimise the optimised",
			":troll:",
			"never trust xeno, they all Ratatouille",
			"HOLD UP!!! something is wrong...",
			"gta6 is delayed",
			"Adon- Adonis Adminka!",
			"The Remade of Uhhhhhh Reanimate",
			"HI",
			"<font color=\"#00DDFF\">Oxide</font> Version 67",
			"currentangle v5",
			"patchma hub by <font color=\"#0000FF\">MyWorld</font>",
			"Genesis FE with extra steps",
			"Gugu Gaga... Gugu Gaga... guuguu gaagaaaaaa!",
			"Half Life 3 never is coming",
			"hatdrop hub",
			"BlaaBlaa hub",
			"BlaaBlaa Reanimate",
			"<font color=\"#0000FF\">IM BLUE BADA DEE BADA DIE</font>",
			"Delta Reanimate | v" .. UhhhhhhVersion,
		}
		if os.date("%m") == "12" and math.random(4) == 1 then
			quotes = {
				"ho ho ho",
				"dess from deltarune",
				"jesus christmas",
				"Happy Xmas, " .. Player.Name,
				"Razor1911 says... SOCIALIZE!",
				"UHHHHHHHHHHHHHHHHHHHHHHHHHHHH",
				"its cold outside get in here",
				"christmas tree builder",
				"UHHHH]",
			}
		end
		if os.date("%m") == "01" and math.random(4) == 1 then
			quotes = {
				"new year new me",
				"HAVE A HAPPY NEW YEAR",
				"A NEW YEAR??",
				"New Years, " .. Player.Name,
				"did u explode yet?",
				"KEEP YER KIDS SAFE FROM FIREWORK",
				"kaboom? yes rico, kaboom. *2009 ROBLOX EXPLODE SOUND*",
			}
		end
		local aprilfools = os.date("%m") == "04 01"
		if aprilfools then
			local troll = math.random(3)
			if troll == 1 then
				CracktroFrameText = "Oxide Reanimation V67"
				quotes = {"<font color=\"#00DDFF\">Oxide</font>   Reanimation"}
				SetUITheme(3)
			end
			if troll == 2 then
				CracktroFrameText = "patchma hub V67"
				quotes = {"<font color=\"#0000FF\">patchma hub</font> by MyWorld"}
				SetUITheme(4)
			end
			if troll == 3 then
				CracktroFrameText = "Genesis V4 but better"
				quotes = {"<font color=\"#CC11FF\">Genesis V4 - Neptunian V</font>"}
				SetUITheme(5)
			end
		end
		TopBarText.Text = quotes[math.random(1, #quotes)]
		if not aprilfools then
			task.delay(2, function()
				TopBarText.Text = "BlaaBlaa Reanimate | v" .. UhhhhhhVersion
			end)
		end
	end
	
	local TopBarClose = Util.Instance("TextButton", TopBarFrame)
	TopBarClose.AnchorPoint = Vector2.new(1, 0)
	TopBarClose.Position = UDim2.new(1, 0, 0, 0)
	TopBarClose.Size = UDim2.new(0, 30, 1, 0)
	TopBarClose.BackgroundTransparency = 1
	TopBarClose.Text = ""
	do
		local A = Util.Instance("Frame", TopBarClose)
		A.AnchorPoint = Vector2.new(0.5, 0.5)
		A.Position = UDim2.new(0.5, 0, 0.5, 0)
		A.Size = UDim2.new(0, 16, 0, 2)
		A.Rotation = 0
		A.BackgroundTransparency = 0
		A.BackgroundColor3 = UITextColor.Value
		A.BorderSizePixel = 0
		A.Name = "A"
		A = Util.Instance("Frame", A)
		A.AnchorPoint = Vector2.new(0.5, 0.5)
		A.Position = UDim2.new(0.5, 0, 0.5, 0)
		A.Size = UDim2.new(0, 2, 0, 0)
		A.Rotation = 0
		A.BackgroundTransparency = 0
		A.BackgroundColor3 = UITextColor.Value
		A.BorderSizePixel = 0
		A.Name = "B"
		UITextColor.Changed:Connect(function(val)
			TopBarClose.A.BackgroundColor3 = val
			TopBarClose.A.B.BackgroundColor3 = val
		end)
	end
	
	WindowContent = Util.Instance("Frame", UIMainWindow)
	WindowContent.Position = UDim2.new(0, 0, 0, 30)
	WindowContent.Size = UDim2.new(1, 0, 1, -35)
	WindowContent.BackgroundTransparency = 1
	WindowContent.ClipsDescendants = true
	WindowContent.ZIndex = 0
	
	local MainWindowClosed = false
	local MainWindowTweening = false
	local MainWindowPosOpen = nil
	local MainWindowPosClose = nil
	if SaveData.WindowClosedPosition then
		MainWindowPosClose = UDim2.new(unpack(SaveData.WindowClosedPosition))
	end
	if MainWindowPosClose and (MainWindowPosClose.X.Scale < 0 or MainWindowPosClose.X.Scale > 1) then
		MainWindowPosClose = nil
	end
	if MainWindowPosClose and (MainWindowPosClose.Y.Scale < 0 or MainWindowPosClose.Y.Scale > 1) then
		MainWindowPosClose = nil
	end
	TopBarClose.Activated:Connect(function()
		if MainWindowTweening then return end
		MainWindowTweening = true
		MainWindowClosed = not MainWindowClosed
		if MainWindowClosed then
			MainWindowPosOpen = UIMainWindow.Position
			TweenService:Create(UIMainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Position = MainWindowPosClose,
				Size = UDim2.fromOffset(112, 30)
			}):Play()
			TweenService:Create(TopBarClose.A, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Rotation = 180
			}):Play()
			TweenService:Create(TopBarClose.A.B, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 2, 0, 16)
			}):Play()
			task.delay(0.6, function()
				WindowContent.Visible = false
				MainWindowTweening = false
			end)
		else
			WindowContent.Visible = true
			MainWindowPosClose = UIMainWindow.Position
			SaveData.WindowClosedPosition = {MainWindowPosClose.X.Scale, MainWindowPosClose.X.Offset, MainWindowPosClose.Y.Scale, MainWindowPosClose.Y.Offset}
			TweenService:Create(UIMainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Position = MainWindowPosOpen,
				Size = UDim2.fromOffset(360, 240)
			}):Play()
			TweenService:Create(TopBarClose.A, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Rotation = 0
			}):Play()
			TweenService:Create(TopBarClose.A.B, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 2, 0, 0)
			}):Play()
			task.delay(0.6, function()
				MainWindowTweening = false
			end)
		end
		WindowContent.Active = not MainWindowClosed
		WindowContent.Interactable = not MainWindowClosed
	end)
	
	local dragref = nil
	local offset = Vector2.new(0, 0)
	TopBarFrame.InputBegan:Connect(function(input)
		if dragref then return end
		if input.UserInputState ~= Enum.UserInputState.Begin then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			WindowContent.Interactable = false
			local screen = Util.GetScreenSize()
			local ch = (Vector2.new(input.Position.X, input.Position.Y) + SCREENGUI.AbsolutePosition) / screen
			offset = Util.UDim2ToVector2Scale(UIMainWindow.Position) - ch
			dragref = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragref then
			if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and dragref == input) then
				local screen = Util.GetScreenSize()
				local ch = (Vector2.new(input.Position.X, input.Position.Y) + SCREENGUI.AbsolutePosition) / screen
				local pos = ch + offset
				local dowsize = Util.UDim2ToVector2Offset(UIMainWindow.Size)
				local imjollx = (dowsize.X * 0.5 - 100) / screen.X
				local imjolly = dowsize.Y * -0.5 / screen.Y
				local boxy = 31 / screen.Y
				pos = Vector2.new(
					math.clamp(pos.X, -imjollx, 1 + imjollx),
					math.clamp(pos.Y, -imjolly, 1 - imjolly - boxy)
				)
				UIMainWindow.Position = Util.Vector2ToUDim2Scale(pos)
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragref and dragref == input then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				WindowContent.Interactable = true
				dragref = nil
			end
		end
	end)
end

local _funcrefreshes = {}
local function AddToRenderStep(func, linkto)
	table.insert(_funcrefreshes, func)
	if linkto then
		linkto.Destroying:Connect(function()
			local i = table.find(_funcrefreshes, func)
			if i then
				table.remove(_funcrefreshes, i)
			end
		end)
	end
	return func
end
local _totalrendertime = 0
RunService:BindToRenderStep("Uhhhhhh_Render" .. Util.RandomString(), Enum.RenderPriority.Last.Value - 69, function(dt)
	_totalrendertime += dt
	UpdateGrads(_totalrendertime)
	WindowContent.Visible = UIMainWindow.Size.Y.Offset > 35
	for _,func in _funcrefreshes do
		local s, e = pcall(func, _totalrendertime, dt)
		if not s then warn(e) end
	end
end)

do
	local uinotif = {
		Text = "hi",
		Progress = -1,
		LastNotif = -67,
		Animation = 1,
		ProgressSm = 0,
	}
	Util.UINotify = function(text, prog)
		uinotif.Text, uinotif.Progress = text, prog or 1
		uinotif.LastNotif = _totalrendertime
	end
	local UINotifyFrame = Instance.new("Frame", UIMainFrame)
	UINotifyFrame.AnchorPoint = Vector2.new(0.5, 0)
	UINotifyFrame.Position = UDim2.new(0.5, 0, 1, 10)
	UINotifyFrame.Size = UDim2.new(0, 300, 0, 30)
	UINotifyFrame.BackgroundTransparency = 0
	UINotifyFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	UINotifyFrame.BorderSizePixel = 0
	UINotifyFrame.Visible = false
	UINotifyFrame.ZIndex = -1
	Stylize(UINotifyFrame, {
		Glow = true,
	})
	local Progress = Instance.new("Frame", UINotifyFrame)
	Progress.AnchorPoint = Vector2.new(0.5, 0)
	Progress.Position = UDim2.new(0.5, 0, 0, 0)
	Progress.Size = UDim2.new(1, -10, 1, 0)
	Progress.BackgroundTransparency = 1
	Progress.BackgroundColor3 = Color3.new(1, 1, 1)
	Progress.BorderSizePixel = 0
	local ProgressTop = Instance.new("Frame", Progress)
	ProgressTop.AnchorPoint = Vector2.new(0.5, 0)
	ProgressTop.Position = UDim2.new(0.5, 0, 0, 0)
	ProgressTop.Size = UDim2.new(0, 0, 0, 4)
	ProgressTop.BackgroundTransparency = 0
	ProgressTop.BackgroundColor3 = Color3.new(1, 1, 1)
	ProgressTop.BorderSizePixel = 0
	local ProgressBot = Instance.new("Frame", Progress)
	ProgressBot.AnchorPoint = Vector2.new(0.5, 1)
	ProgressBot.Position = UDim2.new(0.5, 0, 1, 0)
	ProgressBot.Size = UDim2.new(0, 0, 0, 4)
	ProgressBot.BackgroundTransparency = 0
	ProgressBot.BackgroundColor3 = Color3.new(1, 1, 1)
	ProgressBot.BorderSizePixel = 0
	local NotifyText = Util.Instance("TextLabel", UINotifyFrame)
	NotifyText.AnchorPoint = Vector2.new(0.5, 0.5)
	NotifyText.Position = UDim2.new(0.5, 0, 0.5, 0)
	NotifyText.Size = UDim2.new(1, 0, 0, 20)
	NotifyText.BackgroundTransparency = 1
	NotifyText.ClipsDescendants = true
	NotifyText.Font = Enum.Font.Code
	NotifyText.TextColor3 = Color3.new(1, 1, 1)
	NotifyText.TextSize = 18
	NotifyText.TextXAlignment = Enum.TextXAlignment.Center
	NotifyText.Text = ""
	RegisterTextLabel(NotifyText)
	AddToRenderStep(function(t, dt)
		if t - uinotif.LastNotif < 4 or uinotif.Progress < 1 then
			uinotif.Animation = math.max(0, uinotif.Animation - dt * 2)
		else
			uinotif.Animation = math.min(1, uinotif.Animation + dt * 2)
		end
		if uinotif.Animation < 1 then
			UINotifyFrame.Visible = true
			UINotifyFrame.Position = UIMainWindow.Position + UDim2.new(0, 0, 0, UIMainWindow.Size.Y.Offset / 2 + 10 + math.pow(uinotif.Animation, 3) * -40)
			if uinotif.Progress >= 1 then
				Progress.BackgroundTransparency = math.min(t - uinotif.LastNotif, 0.5) * 2 * 0.3 + 0.7
			else
				Progress.BackgroundTransparency = 1
			end
			local c = GetUIColor(t)
			local s = math.sin(t * 3) * 0.5 + 0.5
			if uinotif.Progress > 0 then
				uinotif.ProgressSm = uinotif.Progress + (uinotif.ProgressSm - uinotif.Progress) * math.exp(-16 * dt)
				ProgressTop.BackgroundTransparency = 0
				ProgressBot.BackgroundTransparency = 0
				ProgressTop.Size = UDim2.new(uinotif.ProgressSm, 0, 0, 4)
				ProgressBot.Size = UDim2.new(uinotif.ProgressSm, 0, 0, 4)
			else
				uinotif.ProgressSm = 1
				ProgressTop.BackgroundTransparency = s
				ProgressBot.BackgroundTransparency = s
				ProgressTop.Size = UDim2.new(1, 0, 0, 4)
				ProgressBot.Size = UDim2.new(1, 0, 0, 4)
			end
			ProgressTop.BackgroundColor3 = c
			ProgressBot.BackgroundColor3 = c
			NotifyText.Text = uinotif.Text
		else
			UINotifyFrame.Visible = false
		end
	end, UINotifyFrame)
end

local CracktroFrame = Util.Instance("Frame", WindowContent)
CracktroFrame.Active = true
CracktroFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CracktroFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CracktroFrame.Size = UDim2.new(0, 360, 0, 205)
CracktroFrame.BackgroundTransparency = 0
CracktroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
CracktroFrame.BorderSizePixel = 1
CracktroFrame.BorderColor3 = Color3.new(1, 1, 1)
CracktroFrame.ZIndex = 10
CracktroFrame.ClipsDescendants = true
AddToRenderStep(function(t)
	CracktroFrame.BorderColor3 = GetUIColor(t)
	CracktroFrame.BackgroundColor3 = GetUIBGColor(t)
end, CracktroFrame)

do -- homepage
	local TriforceClip = Util.Instance("CanvasGroup", CracktroFrame)
	TriforceClip.Position = UDim2.new(0, 0, 0, 0)
	TriforceClip.Size = UDim2.new(1, 0, 1, 0)
	TriforceClip.BackgroundTransparency = 1
	TriforceClip.ZIndex = 0

	local Glowy = Util.Instance("ImageLabel", CracktroFrame)
	Glowy.AnchorPoint = Vector2.new(0.5, 0.5)
	Glowy.Position = UDim2.new(0.5, 0, 0.5, 0)
	Glowy.Size = UDim2.new(0, 260, 0, 260)
	Glowy.BackgroundTransparency = 1
	Glowy.Image = Util.GetCDNAsset("lightinursoul.graphic.png")
	Glowy.ImageColor3 = UITextColor.Value
	Glowy.ImageTransparency = 0.7
	Glowy.ZIndex = -2

	local Triforce = Util.MakeTriforce(3, Color3.fromRGB(0, 0, 255), 0)
	Triforce.AnchorPoint = Vector2.new(0.5, 0.5)
	Triforce.Position = UDim2.new(0.5, 0, 0.5, 0)
	Triforce.Size = UDim2.new(0, 160, 0, 160)
	Triforce.Parent = TriforceClip

	local particles = {}
	local ps = 128
	local psc = Color3.fromRGB(0, 150, 255)
	for i=1, ps do
		local r = (i / ps) * 2 * math.pi
		local p = Util.Instance("Frame", CracktroFrame)
		p.AnchorPoint = Vector2.new(0.5, 0.5)
		p.Size = UDim2.fromOffset(2, 2)
		p.BackgroundColor3 = psc
		p.BackgroundTransparency = 0
		p.BorderSizePixel = 0
		p.ZIndex = -1
		p.Visible = false
		table.insert(particles, {
			p, Vector2.new(math.sin(r), math.cos(r)) * 8,
			Vector2.new(math.random(-128, 128), math.random(-128, 128)),
			math.random() * 2 - 1, false, -1
		})
	end

	local trivel = 360
	local oldpbl = 0

	local text = Util.MakeText(CracktroFrameText)
	text.AnchorPoint = Vector2.new(0.5, 1)
	text.Position = UDim2.new(0.5, 0, 1, -25)
	text.ZIndex = 3
	text.Parent = CracktroFrame
	local text0 = Util.MakeText("Discord: discord.gg/NASNUKRBVM")
	text0.AnchorPoint = Vector2.new(0.5, 1)
	text0.Position = UDim2.new(0.5, 0, 1, -17)
	text0.ZIndex = 3
	text0.Parent = CracktroFrame
	local text1 = Util.MakeText("Made by STEVETHEREALONE and... JustAMale :" .. (math.random() < 0.333 and "3" or (math.random() < 0.5 and "D" or "P")))
	text1.AnchorPoint = Vector2.new(0.5, 1)
	text1.Position = UDim2.new(0.5, 0, 1, -17)
	text1.ZIndex = 3
	text1.Parent = CracktroFrame
	local text2 = Util.MakeText("Click me plzzzz TO start!! :3")
	text2.AnchorPoint = Vector2.new(0.5, 1)
	text2.Position = UDim2.new(0.5, 0, 1, -17)
	text2.ZIndex = 3
	text2.Parent = CracktroFrame
	Util.SetTextColor(text, UITextColor.Value, 0)
	Util.SetTextColor(text0, UITextColor.Value, 0)
	Util.SetTextColor(text1, UITextColor.Value, 0)
	Util.SetTextColor(text2, UITextColor.Value, 0)
	local quotes = {
		"\"EVERY CLIENT ORBITS A SERVER...\"",
		Player.Name .. ", how is your " .. os.date("%A") .. "?",
		"A great " .. os.date("%A") .. " today, eh?",
		"Hello, " .. Player.Name .. ".",
		"What makes you play at " .. os.date("%I %p") .. "?",
		"You are going to love BlaaBlaa, I just know it.",
		"This script is very \"verbose\".",
		"Written mostly on a mobile phone.",
		"I am pretty new in this community! :D",
		"\"Dreams come true!\"",
		"Idea originated from a dream.",
		"If you love this program, join Uhhhhhh's Discord!",
		"Paramity was here..",
		"*Villager Sounds x2* ultimate",
		"Kleiner me to start!",
		"Spongebob squarepants",
		"I'm a Razor 1911 'fan' btw!",
	}
	local text3 = nil
	local text3mustchange = false
	local function changequote()
		if text3 then text3:Destroy() end
		text3 = Util.MakeText(quotes[math.random(1, #quotes)])
		text3.AnchorPoint = Vector2.new(0.5, 1)
		text3.Position = UDim2.new(0.5, 0, 1, -17)
		text3.ZIndex = 3
		text3.Parent = CracktroFrame
		Util.SetTextColor(text3, UITextColor.Value, 0)
	end
	changequote()
	UITextColor.Changed:Connect(function(val)
		Util.SetTextColor(text, val, 0)
		Util.SetTextColor(text0, val, 0)
		Util.SetTextColor(text1, val, 0)
		Util.SetTextColor(text2, val, 0)
		Util.SetTextColor(text3, val, 0)
	end)

	local PositionProcessor = {
		function(i, v, dt, pbl, spike)
			local inst, pos, vel, zind, lvis, lzind = unpack(v)
			local d = pos.Magnitude
			if d > 0 then
				local r = math.atan2(pos.X / d, pos.Y / d)
				local a = math.pi * 0.375
				local out = Vector2.new(math.sin(r + a), math.cos(r + a))
				local tp = out * (40 + pbl / 12)
				local tv = (tp - pos) * 2
				vel = tv:Lerp(vel, math.exp(-2 * dt))
				if math.random() < 0.01 then
					vel += Vector2.new(math.random(-64, 64), math.random(-64, 64))
				end
				if spike > 64 then
					vel += out * 64 * math.random()
				end
				pos += vel * dt
			else
				pos += Vector2.new(0, 10)
			end
			v[2], v[3] = pos, vel
			return Vector3.new(zind * pos.Magnitude / 6, pos.Y, pos.X)
		end,
		function(i, v, dt, pbl, spike)
			local inst, pos, vel, zind, lvis, lzind = unpack(v)
			local a = i / ps
			local s = (a * 6) % 1
			local r = (a + s / 8) * 2 * math.pi + os.clock() * 2 + zind * math.pi * 0.125 * (pbl / 200) * (1 - s)
			pos = Vector2.new(math.sin(r), math.cos(r)) * s * (100 + pbl / 15)
			v[2], v[3] = pos, Vector2.zero
			return Vector3.new(0, pos.Y, pos.X)
		end,
		function(i, v, dt, pbl, spike)
			local inst, pos, vel, zind, lvis, lzind = unpack(v)
			local a = i / ps
			local b = 1 / 3
			local c = math.sqrt(3) / 2
			local d = {
				{Vector2.new(0, b + c), Vector2.new(-0.5, b)},
				{Vector2.new(-0.5, b), Vector2.new(-1, b - c)},
				{Vector2.new(-1, b - c), Vector2.new(0, b - c)},
				{Vector2.new(0, b - c), Vector2.new(1, b - c)},
				{Vector2.new(1, b - c), Vector2.new(0.5, b)},
				{Vector2.new(0.5, b), Vector2.new(0, b - c)},
				{Vector2.new(0, b - c), Vector2.new(-0.5, b)},
				{Vector2.new(-0.5, b), Vector2.new(0.5, b)},
				{Vector2.new(0.5, b), Vector2.new(0, b + c)},
			}
			local t = a * #d
			local i = math.floor(t) + 1
			local u = t % 1
			if i > #d then
				i = #d
				u = 1
			end
			pos = d[i][1]:Lerp(d[i][2], u) * 150
			local r = os.clock() * 2
			pos = Vector2.new(
				pos.X * math.cos(r) - pos.Y * math.sin(r),
				pos.X * math.sin(r) + pos.Y * math.cos(r)
			)
			v[2], v[3] = pos, Vector2.zero
			return Vector3.new(0, pos.Y, pos.X)
		end,
	}
	local currentprocessor = 1

	AddToRenderStep(function(t, dt)
		if Util.IsGuiVisible(CracktroFrame) then
			local pp = PositionProcessor[currentprocessor]
			local CracktroFrameAbsoluteSize = CracktroFrame.AbsoluteSize
			Glowy.ImageColor3 = UITextColor.Value
			Glowy.ImageTransparency = 0.75 + math.sin(((os.clock() / 10) % 2) * math.pi) * 0.05
			local pbl = UISound.Music.PlaybackLoudness
			local spike = math.max(0, (pbl - oldpbl) - 16)
			oldpbl = pbl
			local trivelt = pbl * 2 * dt
			trivel = trivelt + (trivel - trivelt) * math.exp(-8 * dt)
			Triforce.Rotation = (Triforce.Rotation + trivel) % 360
			local ring = CFrame.Angles(
				0,
				math.cos(((t / 5) % 2) * math.pi) * math.pi * 0.5,
				(1 - math.cos(((t / 7) % 2) * math.pi)) * math.pi * 0.5
			)
			local fov = 220
			for i,v in particles do
				local inst, pos, vel, zind, lvis, lzind = unpack(v)
				local sp = ring:VectorToWorldSpace(pp(i, v, dt, pbl, spike))
				local z = sp.Z
				local sc = fov / (z + fov)
				sp = Vector2.new(sp.X, sp.Y) * sc
				local nvis, nzind = lvis, lzind
				if z > 1 - fov then
					inst.Position = Util.Vector2ToUDim2Offset(sp + CracktroFrameAbsoluteSize / 2)
					inst.Size = UDim2.fromOffset(sc * 2.5, sc * 2.5)
					--inst.BackgroundColor3 = psc:Lerp(Color3.new(0, 0, 0), math.clamp(z / (fov * 2), 0, 1))
					nvis = true
					if z > 0 then
						nzind = -1
					else
						nzind = 1
					end
				else
					nvis = false
				end
				if lvis ~= nvis then
					inst.Visible = nvis
					v[5] = nvis
				end
				if lzind ~= nzind then
					inst.ZIndex = nzind
					v[6] = nzind
				end
			end
			local textsel = t % 9
			if IsUhhhhhhFullyLoaded then
				textsel = t % 12
			end
			textsel //= 3
			if text3mustchange ~= (textsel == 3) then
				text3mustchange = (textsel == 3)
				if text3mustchange then changequote() end
			end
			if textsel == 0 then
				text0.Visible = true
				text1.Visible = false
				text2.Visible = false
				text3.Visible = false
			elseif textsel == 1 then
				text0.Visible = false
				text1.Visible = true
				text2.Visible = false
				text3.Visible = false
			elseif textsel == 2 then
				text0.Visible = false
				text1.Visible = false
				text2.Visible = false
				text3.Visible = true
			else
				text0.Visible = false
				text1.Visible = false
				text2.Visible = true
				text3.Visible = false
			end
		else
			currentprocessor = math.random(1, #PositionProcessor)
		end
	end, CracktroFrame)
end
task.wait()

local UI = {}
function UI.CreatePage()
	local Frame = Util.Instance("ScrollingFrame", WindowContent)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 360, 0, 205)
	Frame.BackgroundTransparency = 0
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame.BorderSizePixel = 1
	Frame.BorderColor3 = Color3.new(1, 1, 1)
	Frame.Visible = true
	Frame.ZIndex = 0
	Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	Frame.ClipsDescendants = true
	AddToRenderStep(function(t)
		Frame.BorderColor3 = GetUIColor(t)
		Frame.BackgroundColor3 = GetUIBGColor(t)
	end, Frame)
	Frame.ScrollingDirection = Enum.ScrollingDirection.Y
	Frame.ScrollBarThickness = 3
	Frame.ElasticBehavior = Enum.ElasticBehavior.Always
	Frame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	Frame.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	Frame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	Frame.ScrollBarImageTransparency = 0.5
	Frame.ScrollBarImageColor3 = UITextColor.Value
	Util.LinkDestroyI2C(Frame, UITextColor.Changed:Connect(function(val)
		Frame.ScrollBarImageColor3 = val
	end))
	local Padding = Util.Instance("UIPadding", Frame)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 0)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", Frame)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	return Frame
end
function UI.CreateText(parent, text, size, alignment)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65536)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Text = Util.Instance("TextLabel", Container)
	Text.Position = UDim2.new(0, margin, 0, 0)
	Text.Size = UDim2.new(1, margin * -2, 1, -margin + 1)
	Text.BackgroundTransparency = 1
	Text.RichText = true
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.TextTransparency = 0
	Text.TextXAlignment = alignment
	Text.TextYAlignment = Enum.TextYAlignment.Top
	Text.TextWrapped = true
	Text.TextSize = size
	RegisterTextLabel(Text)
	local function update()
		local x = parent.AbsoluteSize.X
		local size = TextService:GetTextSize(Text.ContentText, Text.TextSize, Text.Font, Vector2.new(x - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, size.Y + margin)
	end
	Text.Text = text
	update()
	Text.Changed:Connect(update)
	return Text
end
function UI.CreateSeparator(parent)
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 7)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Sep = Util.Instance("Frame", Container)
	Sep.AnchorPoint = Vector2.new(0.5, 0.5)
	Sep.Position = UDim2.new(0.5, 0, 0.5, 0)
	Sep.Size = UDim2.new(1, -8, 0, 1)
	Sep.BackgroundColor3 = UITextColor.Value
	Sep.BackgroundTransparency = 0.8
	Sep.BorderSizePixel = 0
	Util.LinkDestroyI2C(Sep, UITextColor.Changed:Connect(function(val)
		Sep.BackgroundColor3 = val
	end))
end
function UI.CreateButton(parent, text, size)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65536)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Button = Util.Instance("TextButton", Container)
	Button.AnchorPoint = Vector2.new(0, 0)
	Button.Position = UDim2.new(0, margin, 0, margin // 2)
	Button.Size = UDim2.new(1, margin * -2, 1, -margin)
	Button.BackgroundTransparency = 0
	Button.BackgroundColor3 = Color3.new(1, 1, 1)
	Button.BorderSizePixel = 0
	Button.Text = ""
	Button.AutoButtonColor = true
	local ButtonText = Util.Instance("TextLabel", Button)
	ButtonText.AnchorPoint = Vector2.new(0, 0.5)
	ButtonText.Position = UDim2.new(0, 0, 0.5, 0)
	ButtonText.Size = UDim2.new(1, 0, 1, -margin)
	ButtonText.BackgroundTransparency = 1
	ButtonText.RichText = true
	ButtonText.Font = Enum.Font.Code
	ButtonText.TextColor3 = Color3.new(1, 1, 1)
	ButtonText.TextTransparency = 0
	ButtonText.TextXAlignment = Enum.TextXAlignment.Center
	ButtonText.TextYAlignment = Enum.TextYAlignment.Center
	ButtonText.TextWrapped = true
	ButtonText.TextSize = size
	RegisterTextLabel(ButtonText)
	Stylize(Button)
	local function update()
		local x = parent.AbsoluteSize.X
		local size = TextService:GetTextSize(ButtonText.ContentText, ButtonText.TextSize, ButtonText.Font, Vector2.new(x - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, size.Y + margin * 2)
	end
	ButtonText.Text = text
	update()
	ButtonText.Changed:Connect(update)
	return Button, ButtonText
end
function UI.CreateSwitch(parent, text, value)
	local margin = 5
	local switchsize = 50
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 10)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Button = Util.Instance("TextButton", Container)
	Button.AnchorPoint = Vector2.new(0, 0)
	Button.Position = UDim2.new(0, 0, 0, 0)
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	local ButtonText = Util.Instance("TextLabel", Button)
	ButtonText.AnchorPoint = Vector2.new(0, 0)
	ButtonText.Position = UDim2.new(0, margin, 0, 0)
	ButtonText.Size = UDim2.new(1, margin * -3 - switchsize, 1, 0)
	ButtonText.BackgroundTransparency = 1
	ButtonText.RichText = true
	ButtonText.Font = Enum.Font.Code
	ButtonText.TextColor3 = Color3.new(1, 1, 1)
	ButtonText.TextTransparency = 0
	ButtonText.TextXAlignment = Enum.TextXAlignment.Left
	ButtonText.TextYAlignment = Enum.TextYAlignment.Center
	ButtonText.TextWrapped = true
	ButtonText.TextSize = 20
	RegisterTextLabel(ButtonText)
	local function update()
		local x = parent.AbsoluteSize.X
		local size = TextService:GetTextSize(ButtonText.ContentText, ButtonText.TextSize, ButtonText.Font, Vector2.new(x - margin * 3 - switchsize, math.huge))
		Container.Size = UDim2.new(1, 0, 0, math.max(35, size.Y))
	end
	ButtonText.Text = text
	update()
	ButtonText.Changed:Connect(update)
	local Switch = Util.Instance("Frame", Container)
	Switch.AnchorPoint = Vector2.new(1, 0.5)
	Switch.Position = UDim2.new(1, -margin, 0.5, 0)
	Switch.Size = UDim2.new(0, 25, 0, 25)
	Switch.BackgroundTransparency = 0
	Switch.BackgroundColor3 = Color3.new(0, 0, 0)
	Switch.BorderSizePixel = 0
	Util.Instance("UICorner", Switch).CornerRadius = UDim.new(0, 5)
	Stylize(Switch)
	local SwitchDot = Util.Instance("Frame", Switch)
	SwitchDot.AnchorPoint = Vector2.new(0.5, 0.5)
	SwitchDot.Position = UDim2.new(0.5, 0, 0.5, 0)
	SwitchDot.Size = UDim2.new(0, 19, 0, 19)
	SwitchDot.BackgroundTransparency = 0.2
	SwitchDot.BackgroundColor3 = UITextColor.Value
	SwitchDot.BorderSizePixel = 0
	Util.LinkDestroyI2C(SwitchDot, UITextColor.Changed:Connect(function(val)
		SwitchDot.BackgroundColor3 = val
	end))
	Util.Instance("UICorner", SwitchDot).CornerRadius = UDim.new(0, 2)
	local Lever = Util.Instance("BoolValue")
	Lever.Value = value
	local function updatesw()
		SwitchDot.Visible = Lever.Value
	end
	Lever.Changed:Connect(updatesw)
	updatesw()
	Button.Activated:Connect(function()
		Lever.Value = not Lever.Value
	end)
	return Lever, ButtonText
end
function UI.CreateTextbox(parent, text, placeholder, size)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65536)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Box = Util.Instance("Frame", Container)
	Box.AnchorPoint = Vector2.new(0, 0)
	Box.Position = UDim2.new(0, margin, 0, margin // 2)
	Box.Size = UDim2.new(1, margin * -2, 1, -margin)
	Box.BackgroundTransparency = 0
	Box.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	Box.BorderSizePixel = 0
	local BoxText = Util.Instance("TextBox", Box)
	BoxText.AnchorPoint = Vector2.new(0, 0.5)
	BoxText.Position = UDim2.new(0, 0, 0.5, 0)
	BoxText.Size = UDim2.new(1, 0, 1, -margin)
	BoxText.BackgroundTransparency = 1
	BoxText.Font = Enum.Font.Code
	BoxText.TextColor3 = Color3.new(1, 1, 1)
	BoxText.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
	BoxText.TextTransparency = 0
	BoxText.TextXAlignment = Enum.TextXAlignment.Center
	BoxText.TextYAlignment = Enum.TextYAlignment.Center
	BoxText.TextWrapped = true
	BoxText.TextSize = size
	BoxText.ClearTextOnFocus = false
	RegisterTextLabel(BoxText)
	BoxText.Focused:Connect(function()
		UISound.Click:Play()
	end)
	Stylize(Box, {
		Depthed = true,
	})
	local function update()
		local x = parent.AbsoluteSize.X
		if not BoxText.TextWrapped then
			x = math.huge
		end
		local t = BoxText.Text
		if t:len() == 0 then
			t = BoxText.PlaceholderText
		end
		local size = TextService:GetTextSize(t, BoxText.TextSize, BoxText.Font, Vector2.new(x - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, size.Y + margin * 2 + 2)
	end
	BoxText.Text = text
	BoxText.PlaceholderText = placeholder
	update()
	BoxText.Changed:Connect(update)
	return BoxText
end
function UI.CreateSlider(parent, text, value, min, max, step)
	min = min or 1
	max = max or 10
	step = math.abs(step or 0)
	assert(max > min)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Text = Util.Instance("TextLabel", Container)
	Text.AnchorPoint = Vector2.new(0, 0)
	Text.Position = UDim2.new(0, margin, 0, 0)
	Text.Size = UDim2.new(1, margin * -2, 0, 35)
	Text.BackgroundTransparency = 1
	Text.RichText = true
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.TextTransparency = 0
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.TextYAlignment = Enum.TextYAlignment.Center
	Text.TextWrapped = true
	Text.TextSize = 20
	Text.Text = text
	RegisterTextLabel(Text)
	local Box = Util.Instance("Frame", Container)
	Box.AnchorPoint = Vector2.new(1, 0)
	Box.Position = UDim2.new(1, -margin, 0, margin)
	Box.Size = UDim2.new(0, 80, 0, 35 - margin * 2)
	Box.BackgroundTransparency = 0
	Box.BackgroundColor3 = Color3.new(1, 1, 1)
	Box.BorderSizePixel = 0
	local BoxText = Util.Instance("TextBox", Box)
	BoxText.AnchorPoint = Vector2.new(0, 0.5)
	BoxText.Position = UDim2.new(0, 0, 0.5, 0)
	BoxText.Size = UDim2.new(1, 0, 1, -margin)
	BoxText.BackgroundTransparency = 1
	BoxText.Font = Enum.Font.Code
	BoxText.TextColor3 = Color3.new(1, 1, 1)
	BoxText.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
	BoxText.TextTransparency = 0
	BoxText.TextXAlignment = Enum.TextXAlignment.Center
	BoxText.TextYAlignment = Enum.TextYAlignment.Center
	BoxText.TextWrapped = true
	BoxText.TextSize = 15
	BoxText.ClearTextOnFocus = false
	RegisterTextLabel(BoxText)
	BoxText.Focused:Connect(function()
		UISound.Click:Play()
	end)
	Stylize(Box, {
		Depthed = true,
	})
	local SliderC = Util.Instance("TextButton", Container)
	SliderC.AnchorPoint = Vector2.new(0, 0)
	SliderC.Position = UDim2.new(0, 0, 0, 40)
	SliderC.Size = UDim2.new(1, 0, 0, 20)
	SliderC.BackgroundTransparency = 1
	SliderC.Text = ""
	SliderC.AutoButtonColor = true
	local SliderR = Util.Instance("Frame", SliderC)
	SliderR.AnchorPoint = Vector2.new(0.5, 0.5)
	SliderR.Position = UDim2.new(0.5, 0, 0.5, 0)
	SliderR.Size = UDim2.new(1, margin * -2 - 18, 0, 5)
	SliderR.BackgroundTransparency = 0
	SliderR.BackgroundColor3 = Color3.new(1, 1, 1)
	SliderR.BorderSizePixel = 0
	local SliderB = Util.Instance("Frame", SliderR)
	SliderB.AnchorPoint = Vector2.new(0.5, 0.5)
	SliderB.Position = UDim2.new(0, 0, 0.5, 0)
	SliderB.Size = UDim2.new(0, 18, 0, 18)
	SliderB.BackgroundTransparency = 0
	SliderB.BackgroundColor3 = Color3.new(1, 1, 1)
	SliderB.BorderSizePixel = 0
	SliderB.ZIndex = 2
	Stylize(SliderR, {
		Depthed = true,
	})
	Stylize(SliderB)
	local range = max - min
	if step > 0 then
		if range / step < 20 then
			local i = min + step
			while i < max do
				local snaps = Util.Instance("Frame", SliderR)
				snaps.AnchorPoint = Vector2.new(0.5, 0)
				snaps.Position = UDim2.new((i - min) / range, 0, 0, 1)
				snaps.Size = UDim2.new(0, 1, 0, 3)
				snaps.BackgroundTransparency = 0.5
				snaps.BackgroundColor3 = Color3.new(1, 1, 1)
				snaps.BorderSizePixel = 0
				i += step
			end
		end
	end
	local Select = Util.Instance("NumberValue")
	local function update()
		local str = string.format("%.3f", Select.Value)
		if str:find("%.") then
			while str:sub(-1) == "0" do
				str = str:sub(1, -2)
				if str:sub(-1) == "." then
					str = str:sub(1, -2)
					break
				end
			end
		end
		BoxText.Text = str
		SliderB.Position = UDim2.new(math.clamp((Select.Value - min) / (max - min), 0, 1), 0, 0.5, 0)
		if math.random(4) == 1 then
			if str:find("67") or str:find("6.7") then
				Util.UINotify("SIX SEVENNNN 67 67 67 67 OMG")
			end
		end
	end
	Select.Value = value
	Select.Changed:Connect(update)
	update()
	BoxText.FocusLost:Connect(function()
		Select.Value = tonumber(BoxText.Text) or Select.Value
		update()
	end)
	local function ondrag(x)
		local val = range * math.clamp((x - SliderR.AbsolutePosition.X) / SliderR.AbsoluteSize.X, 0, 1)
		if step > 0 then
			val = math.round(val / step) * step
		end
		val += min
		Select.Value = val
	end
	local dragref = nil
	local start = nil
	SliderC.InputBegan:Connect(function(input)
		if input.UserInputState ~= Enum.UserInputState.Begin then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragref = input
			start = input.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragref then
			if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and dragref == input) then
				if start then
					local delta = input.Position - start
					if delta.Magnitude > 10 then
						start = nil
						if math.abs(delta.X) < math.abs(delta.Y) then
							dragref = nil
						end
					end
				else
					ondrag(input.Position.X)
				end
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragref and dragref == input then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				ondrag(input.Position.X)
				dragref = nil
			end
		end
	end)
	return Select
end
function UI.CreateDropdown(parent, text, array, value)
	value = value and math.clamp(value, 1, #array) or 1
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 10)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Text = Util.Instance("TextLabel", Container)
	Text.AnchorPoint = Vector2.new(0, 0)
	Text.Position = UDim2.new(0, margin, 0, 0)
	Text.Size = UDim2.new(1, margin * -2, 1, 0)
	Text.BackgroundTransparency = 1
	Text.RichText = true
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.TextTransparency = 0
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.TextYAlignment = Enum.TextYAlignment.Center
	Text.TextWrapped = true
	Text.TextSize = 20
	RegisterTextLabel(Text)
	local Dropdown = Util.Instance("TextButton", Container)
	Dropdown.AnchorPoint = Vector2.new(1, 0.5)
	Dropdown.Position = UDim2.new(1, -margin, 0.5, 0)
	Dropdown.Size = UDim2.new(0.5, 0, 1, -margin)
	Dropdown.BackgroundTransparency = 0
	Dropdown.BackgroundColor3 = Color3.new(1, 1, 1)
	Dropdown.BorderSizePixel = 0
	Dropdown.Text = ""
	Dropdown.AutoButtonColor = true
	local DropdownText = Util.Instance("TextLabel", Dropdown)
	DropdownText.AnchorPoint = Vector2.new(0.5, 0.5)
	DropdownText.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropdownText.Size = UDim2.new(1, -margin * 2, 1, -margin)
	DropdownText.BackgroundTransparency = 1
	DropdownText.RichText = true
	DropdownText.Font = Enum.Font.Code
	DropdownText.TextColor3 = Color3.new(1, 1, 1)
	DropdownText.TextTransparency = 0
	DropdownText.TextXAlignment = Enum.TextXAlignment.Center
	DropdownText.TextYAlignment = Enum.TextYAlignment.Center
	DropdownText.TextWrapped = true
	DropdownText.TextSize = 15
	RegisterTextLabel(DropdownText)
	Stylize(Dropdown)
	local function update()
		local x = parent.AbsoluteSize.X
		local size1 = TextService:GetTextSize(Text.ContentText, Text.TextSize, Text.Font, Vector2.new(x - margin * 2, math.huge))
		local size2 = TextService:GetTextSize(DropdownText.ContentText, DropdownText.TextSize, DropdownText.Font, Vector2.new(x * 0.8 - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, math.max(35, size1.Y, size2.Y + margin * 2))
		Dropdown.Size = UDim2.new(0, math.max(60, size2.X + margin * 2 + 2), 0, math.max(25, size2.Y + margin * 2))
	end
	Text.Text = text
	DropdownText.Text = array[value]
	update()
	Text.Changed:Connect(update)
	DropdownText.Changed:Connect(update)
	local Select = Util.Instance("IntValue")
	Select.Value = value
	Select.Changed:Connect(function()
		DropdownText.Text = array[Select.Value]
	end)
	local Droplist = Util.Instance("ScrollingFrame", UIMainFrame)
	Droplist.AnchorPoint = Vector2.new(0, 0)
	Droplist.Position = UDim2.new(0, 0, 0, 0)
	Droplist.Size = UDim2.new(0, 0, 0, 0)
	Droplist.BackgroundTransparency = 0
	Droplist.BackgroundColor3 = Color3.new(1, 1, 1)
	Droplist.BorderSizePixel = 0
	Droplist.Visible = false
	Droplist.CanvasSize = UDim2.new(0, 0, 0, 0)
	Droplist.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Droplist.ScrollBarThickness = 0
	Droplist.ScrollingDirection = Enum.ScrollingDirection.Y
	local Padding = Util.Instance("UIPadding", Droplist)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	Padding.PaddingTop = UDim.new(0, 0)
	Padding.PaddingBottom = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", Droplist)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Stylize(Droplist, {
		Glow = true
	})
	local items = {}
	local sizex = 60
	local interact = false
	local opened = false
	Util.LinkDestroyI2I(Dropdown, Droplist)
	for i,itemname in array do
		local Item = Util.Instance("TextButton", Droplist)
		Item.Size = UDim2.new(1, 0, 0, 20)
		Item.BackgroundTransparency = 0
		Item.BackgroundColor3 = Color3.new(0, 0, 0)
		Item.BorderSizePixel = 0
		Item.AutoButtonColor = true
		Item.LayoutOrder = i
		Item.Text = itemname
		Item.TextSize = 15
		Item.Font = Enum.Font.Code
		Item.TextColor3 = Color3.new(1, 1, 1)
		Item.TextXAlignment = Enum.TextXAlignment.Left
		Item.TextYAlignment = Enum.TextYAlignment.Center
		Item.TextWrapped = false
		RegisterTextLabel(Item)
		table.insert(items, Item)
		local size = TextService:GetTextSize(itemname, Item.TextSize, Item.Font, Vector2.new(math.huge, math.huge))
		sizex = math.max(sizex, size.X + 12)
		Item.Activated:Connect(function()
			Select.Value = i
			opened = false
			interact = true
		end)
		Item.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				interact = true
				UISound.Click:Play()
			end
		end)
	end
	Dropdown.Activated:Connect(function()
		opened = not opened
		interact = true
	end)
	local conn = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			task.wait()
			if not interact then
				opened = false
			end
			interact = false
		end
	end)
	Util.LinkDestroyI2C(Dropdown, conn)
	local scrollframe = Container:FindFirstAncestorWhichIsA("ScrollingFrame")
	if scrollframe then
		local conn = scrollframe:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			opened = false
		end)
	end
	local opentween = 0
	AddToRenderStep(function(t, dt)
		if opened then
			opentween = 1 + (opentween - 1) * math.exp(-32 * dt)
			Droplist.ZIndex = 4
			Droplist.Interactable = true
		else
			opentween *= math.exp(-32 * dt)
			Droplist.ZIndex = 3
			Droplist.Interactable = false
		end
		local ysize = math.round(math.min(90, #items * 20) * opentween)
		if ysize >= 1 then
			Droplist.Position = Util.Vector2ToUDim2Offset((Dropdown.AbsolutePosition + Vector2.new(0, Dropdown.AbsoluteSize.Y)) - UIMainFrame.AbsolutePosition)
			Droplist.Size = UDim2.new(0, math.max(Dropdown.Size.X.Offset, sizex), 0, ysize)
			Droplist.Visible = true
		else
			Droplist.Visible = false
		end
		local i1 = GetUIBGColor(t)
		local i2 = i1:Lerp(Color3.new(1, 1, 1), 0.1)
		for i,v in items do
			if i == Select.Value then
				v.BackgroundColor3 = i2
			else
				v.BackgroundColor3 = i1
			end
		end
	end, Droplist)
	Util.LinkDestroyI2I(Dropdown, Select)
	return Select, Text
end
function UI.CreateCanvas(parent)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 30)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	Container.AutomaticSize = Enum.AutomaticSize.Y
	local Padding = Util.Instance("UIPadding", Container)
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	local ListBox = Util.Instance("Frame", Container)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 0)
	ListBox.Size = UDim2.new(1, 0, 0, 26)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticSize = Enum.AutomaticSize.Y
	Stylize(ListBox, {
		Depthed = true,
	})
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Util.LinkDestroyI2I(ListBox, Container)
	return ListBox
end
function UI.CreateScrollCanvas(parent, height)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, height)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Padding = Util.Instance("UIPadding", Container)
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	local ListBox = Util.Instance("ScrollingFrame", Container)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 0)
	ListBox.Size = UDim2.new(1, 0, 0, 26)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ListBox.CanvasSize = UDim2.new(0, 0, 0, 0)
	ListBox.ClipsDescendants = true
	ListBox.ScrollingDirection = Enum.ScrollingDirection.Y
	ListBox.ScrollBarThickness = 3
	ListBox.ElasticBehavior = Enum.ElasticBehavior.Always
	ListBox.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.ScrollBarImageTransparency = 0.5
	ListBox.ScrollBarImageColor3 = UITextColor.Value
	Util.LinkDestroyI2C(ListBox, UITextColor.Changed:Connect(function(val)
		ListBox.ScrollBarImageColor3 = val
	end))
	Stylize(ListBox, {
		Depthed = true,
	})
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Util.LinkDestroyI2I(ListBox, Container)
	return ListBox
end
function UI.CreateItemListPage()
	local margin = 5
	local Frame = Util.Instance("Frame", WindowContent)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 360, 0, 205)
	Frame.BackgroundTransparency = 0
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame.BorderSizePixel = 1
	Frame.BorderColor3 = Color3.new(1, 1, 1)
	Frame.Visible = true
	Frame.ZIndex = 0
	Frame.ClipsDescendants = true
	AddToRenderStep(function(t)
		Frame.BorderColor3 = GetUIColor(t)
		Frame.BackgroundColor3 = GetUIBGColor(t)
	end, Frame)
	local Padding = Util.Instance("UIPadding", Frame)
	Padding.PaddingTop = UDim.new(0, margin)
	Padding.PaddingBottom = UDim.new(0, margin)
	Padding.PaddingLeft = UDim.new(0, margin)
	Padding.PaddingRight = UDim.new(0, margin)
	local BackButton = Util.Instance("TextButton", Frame)
	BackButton.AnchorPoint = Vector2.new(0, 0)
	BackButton.Position = UDim2.new(0, 0, 0, 0)
	BackButton.Size = UDim2.new(0, 30, 0, 25)
	BackButton.BackgroundTransparency = 0
	BackButton.BackgroundColor3 = Color3.new(1, 1, 1)
	BackButton.BorderSizePixel = 0
	BackButton.Text = ""
	BackButton.AutoButtonColor = true
	local BackButtonText = Util.Instance("TextLabel", BackButton)
	BackButtonText.AnchorPoint = Vector2.new(0.5, 0.5)
	BackButtonText.Position = UDim2.new(0.5, 0, 0.5, 0)
	BackButtonText.Size = UDim2.new(1, margin * -2, 1, -margin)
	BackButtonText.BackgroundTransparency = 1
	BackButtonText.Font = Enum.Font.Code
	BackButtonText.TextColor3 = Color3.new(1, 1, 1)
	BackButtonText.TextTransparency = 0
	BackButtonText.TextXAlignment = Enum.TextXAlignment.Center
	BackButtonText.TextYAlignment = Enum.TextYAlignment.Center
	BackButtonText.TextWrapped = true
	BackButtonText.TextSize = 20
	BackButtonText.Text = "<"
	RegisterTextLabel(BackButtonText)
	Stylize(BackButton)
	local SearchBox = Util.Instance("Frame", Frame)
	SearchBox.AnchorPoint = Vector2.new(1, 0)
	SearchBox.Position = UDim2.new(1, 0, 0, 0)
	SearchBox.Size = UDim2.new(1, -margin - 30, 0, 25)
	SearchBox.BackgroundTransparency = 0
	SearchBox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	SearchBox.BorderSizePixel = 0
	local SearchBoxText = Util.Instance("TextBox", SearchBox)
	SearchBoxText.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchBoxText.Position = UDim2.new(0.5, 0, 0.5, 0)
	SearchBoxText.Size = UDim2.new(1, margin * -2, 1, -margin)
	SearchBoxText.BackgroundTransparency = 1
	SearchBoxText.Font = Enum.Font.Code
	SearchBoxText.TextColor3 = Color3.new(1, 1, 1)
	SearchBoxText.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
	SearchBoxText.TextTransparency = 0
	SearchBoxText.TextXAlignment = Enum.TextXAlignment.Left
	SearchBoxText.TextYAlignment = Enum.TextYAlignment.Center
	SearchBoxText.TextWrapped = true
	SearchBoxText.TextSize = 20
	SearchBoxText.ClearTextOnFocus = false
	SearchBoxText.Focused:Connect(function()
		UISound.Click:Play()
	end)
	Stylize(SearchBox, {
		Depthed = true,
	})
	SearchBoxText.Text = ""
	SearchBoxText.PlaceholderText = "Seek..."
	RegisterTextLabel(SearchBoxText)
	local ListBox = Util.Instance("ScrollingFrame", Frame)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 25 + margin)
	ListBox.Size = UDim2.new(1, 0, 1, -margin - 25)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ListBox.CanvasSize = UDim2.new(0, 0, 0, 0)
	ListBox.ClipsDescendants = true
	ListBox.ScrollingDirection = Enum.ScrollingDirection.Y
	ListBox.ScrollBarThickness = 3
	ListBox.ElasticBehavior = Enum.ElasticBehavior.Always
	ListBox.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.ScrollBarImageTransparency = 0.5
	ListBox.ScrollBarImageColor3 = UITextColor.Value
	Util.LinkDestroyI2C(ListBox, UITextColor.Changed:Connect(function(val)
		ListBox.ScrollBarImageColor3 = val
	end))
	Stylize(ListBox, {
		Depthed = true,
	})
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	BackButton.Name = "Back"
	BackButtonText.Name = "Label"
	SearchBox.Name = "Search"
	SearchBoxText.Name = "Box"
	ListBox.Name = "List"
	SearchBoxText:GetPropertyChangedSignal("Text"):Connect(function()
		for _,v in ListBox:GetChildren() do
			if v:IsA("GuiObject") then
				v.Visible = not not v.Name:lower():find(SearchBoxText.Text:lower())
			end
		end
	end)
	return Frame
end
function UI.CreateItemListItem(parent)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 30)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	Container.AutomaticSize = Enum.AutomaticSize.Y
	local Padding = Util.Instance("UIPadding", Container)
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	local ListBox = Util.Instance("TextButton", Container)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 0)
	ListBox.Size = UDim2.new(1, 0, 0, 26)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticSize = Enum.AutomaticSize.Y
	ListBox.Text = ""
	Stylize(ListBox)
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Util.LinkDestroyI2I(ListBox, Container)
	return ListBox
end

local MainPage = UI.CreatePage()
MainPage.Interactable = false
CracktroFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if _totalrendertime < 1 or not IsUhhhhhhFullyLoaded then return end
		CracktroFrame.Interactable = false
		CracktroFrame.Visible = true
		MainPage.Interactable = false
		local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -362, 0.5, 0),
		})
		tween:Play()
		tween.Completed:Connect(function()
			CracktroFrame.Visible = false
			MainPage.Interactable = true
		end)
	end
end)
local AsciiText = UI.CreateText(MainPage, "", 12, Enum.TextXAlignment.Center)
Util.ForceTextSize(AsciiText)
task.spawn(function()
	-- nice ascii art steve
	local AsciiTextarts = {
		{
       	 "██████╗ ██╗      █████╗  █████╗       ██████╗ ██╗      █████╗  █████╗",
      	  "██╔══██╗██║     ██╔══██╗██╔══██╗      ██╔══██╗██║     ██╔══██╗██╔══██╗",
      	  "██████╔╝██║     ███████║███████║      ██████╔╝██║     ███████║███████║",
      	  "██╔══██╗██║     ██╔══██║██╔══██║      ██╔══██╗██║     ██╔══██║██╔══██║",
      	  "██████╔╝███████╗██║  ██║██║  ██║      ██████╔╝███████╗██║  ██║██║  ██║",
       	 "╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝",
		},
		{
      	  "BBBBBB  lllll   aaaa    aaaa      BBBBBB  lllll   aaaa    aaaa",
      	  "BB   BB ll     aa  aa  aa  aa     BB   BB ll     aa  aa  aa  aa",
     	   "BBBBBB  ll     aaaaaa  aaaaaa     BBBBBB  ll     aaaaaa  aaaaaa",
      	  "BB   BB ll     aa  aa  aa  aa     BB   BB ll     aa  aa  aa  aa",
      	  "BB   BB lllll  aa  aa  aa  aa     BB   BB lllll  aa  aa  aa  aa",
      	  "BBBBBB         aa  aa  aa  aa     BBBBBB         aa  aa  aa  aa",
		},
		{
			"     (   ( /(  ( /(  ( /(  ( /(  ( /(  ( /(  ",
			"     )\\  )\\()) )\\()) )\\()) )\\()) )\\()) )\\()) ",
			"  _ ((_)((_)\\ ((_)\\ ((_)\\ ((_)\\ ((_)\\ ((_)\\  ",
			" | | | || |(_)| |(_)| |(_)| |(_)| |(_)| |(_) ",
			" | |_| || ' \\ | ' \\ | ' \\ | ' \\ | ' \\ | ' \\  ",
			"  \\___/ |_||_||_||_||_||_||_||_||_||_||_||_| ",
		},
		{
			" db    db db      db      db      db      db      db      ",
			" 88    88 88      88      88      88      88      88      ",
			" 88    88 888888. 888888. 888888. 888888. 888888. 888888. ",
			" 88    88 88   88 88   88 88   88 88   88 88   88 88   88 ",
			" 88.  .88 88   88 88   88 88   88 88   88 88   88 88   88 ",
			"  Y8888P  YP   YP YP   YP YP   YP YP   YP YP   YP YP   YP ",
		},
		{
			" Un    iv er      sa      lH      ie      ra      rc      ",
			" hi    ca l6      Re      an      im      at      eB      ",
			" yS    TE VETHERE ALONEUn iversal Hierarc hical6R eanimat ",
			" eB    yS TE   VE TH   ER EA   LO NE   Un iv   er sa   lH ",
			" ier  arc ic   al 6R   ea ni   ma te   By ST   EV ET   HE ",
			"  REALON  EU   ni ve   rs al   Hi er   ar ch   ic al   6R ",
		},
		{
			"animatio'   .jQQQ|;;;;;;;;;;;;;|QQWp,   'tionanim",
			"ationan'   .JTTVV|;;;;;;;;;;;;;|VVVVm>   'nimatio",
			"nanima'   _mQc;~~|.............|~~+jQmc   'ionani",
			"matio'   _QQQQg, |             |  jQQQQc.  'imati",
			"onan'   <QQQQQQm;|   BlaBruh   |.wQQQQWQa,  'onan",
			"ima'   jWQQQQQQQQ|             |mQQQQQQQQg,  'mat",
		},
		{
			"fore! It is really great! Good product! Feel alive, NO",
			"st part^ '' '  \"\"*E! (excluding taxes and the bills) N",
			"r seu- . BlaaBla .-|u ihis! It has become something ne",
			"rse! We ,... . ,.-rs of yellow-orange shiny triangles.",
			"ns at a really stable framerate, so optimised it handl",
			"ow, BUY OUR PRODUCT FOR FREE! We know you like it! We ",
		},
		{ -- omg hi steveee-
			"....... gmWWWQQQQQQPg ..............................",
			":;:;:; qm#WWNWQQWQWWmp ;:;:;:.                  .;:;",
			"!!?!!?.WX##: W#W :###W.?!!?:.  hi im steve!      .:!",
			"lilili:ZSXS: XSX :X##Z:ilil!. welcome to BlaaBa! .!i",
			"EEEEEE:YLkk2S2SXSXSXZP:EEEEEi:                  :iEE",
			"%%%%%%%;vnvkkkk2S2vnv;%%%%%%%%%oooooooooooooooo%%%%%",
		},
		{
			"  Get BlaaBlaa today! Feel the difference!       ",
			"           (-_-)         EPIC!    (^~^)   .vv=E ",
			"       ()-(:::::)-()         .()-(:::::)-()'    ",
			"LAME!  || |.....| ||      3=^^'  /...../        ",
			"       YP |     | YP            (     )   COOL! ",
			"      Without BlaaBlaa   vs.   With BlaaBlaa      ",
		},
		{
			"55 68 68 68 68 68 68 55 68 68 68 68 68 68",
			"68 68 68 68 68 68 55 68 68 68 68 68 68 55",
			"68 68 68 68 68 55 68 68 68 68 68 68 55 68",
			"68 68 68 68 Hmmmmmm  68 68 68 68 55 68 68",
			"68 68 68 55 68 68 68 68 68 68 55 68 68 68",
			"68 68 55 68 68 68 68 68 68 55 68 68 68 68",
		},
		{
			"  Blaabla          ",
			"  01010101         ",
			"   01101000        ",
			"    01101000       ",
			"     01101000      ",
			"      01101000     ",
			"       01101000    ",
			"        01101000   ",
			"         Blaabla   ",
		},
		{
			"+-[ BlaaBlaa Reanimate ]-----------------[#]-+",
			"|    ___                                    |",
			"|   / o \\   Hello, world! Programmed to     |",
			"|   \\ l /   work and not to feel.           |",
			"|    \"\"\"                                    |",
			"+-------------------------------------------+",
		},
		{
			"       cIyyyyyyF0\\ `TFyyyyyyq8_                 ",
			"           i+`}0v       V!'xD~                  ",
			"           &x~[.        W|11   --BlaaBla--      ",
			"          ~W,          }D                       ",
			"        <d$-         tg3`                       ",
			"   \".''   ......             '.      \"`   ;     ",
			"   2]~<J  ;!ci2q' rrrr^   <1_q'   -inr   `0;    ",
			"   F` '2    F<;            [&I- _+r%)    `@<}!  ",
			"    ~1}`  `}\\    ;*111*; ^[; .^    +\\    `x     ",
		},
		{
			"  local oldsec = 0          .-+=* BlaaBla *=+-. ",
			"  while i < #keyframes do     (code-ception!)   ",
			"      local k = keyframes[i]                    ",
			"      local sec = k.Time // self._optimiser     ",
			"      while oldsec < sec do                     ",
			"          local j = math.max(1, i - 1)          ",
		},
		{
			"er failed to process http://assetgame.roblox.com/as",
			"er failed to process http://assetgame.roblox.com/as",
			"--------------------------------------------       ",
			"so, Uhhhhhh... BlaaBlaa?                           ",
			"--------------------------------------------       ",
			"er failed to process http://assetgame.roblox.com/as",
			"er failed to process http://assetgame.roblox.com/as",
			"er failed to process http://assetgame.roblox.com/as",
		},
		{
			"usage: clone this repo and change the token and the",
			"(unless you like chaos) also make sure you have all",
			"the dev portal cuz BlaaBla.                        ",
			"                                                   ",
			"\"it's not fast it's shit\"                          ",
			"Believe me friend, its fuckingly fast, you don't ev",
		},
		{
			"Uhhhhhh  https://discord.gg/NASNUKRBVM  Uhhhhhh",
			"Uhhhhhh Uhhhhhh Uhhhhhh Uhhhhhh STEVETHEREALONE",
			"Uhhhhhh Uhhhhhh Uhhhhhh STEVETHEREALONE Uhhhhhh",
			"Uhhhhhh Uhhhhhh STEVETHEREALONE Uhhhhhh Uhhhhhh",
			"Uhhhhhh STEVETHEREALONE Uhhhhhh Uhhhhhh Uhhhhhh",
			"STEVETHEREALONE Uhhhhhh Uhhhhhh Uhhhhhh Uhhhhhh",
		},
	}
	AsciiText.Text = table.concat(AsciiTextarts[math.random(1, #AsciiTextarts)], "\n")
	local AsciiTextartsw = false
	local AsciiTextarttr = {}
	do -- generate transitions
		-- wipe to right
		local a = {}
		for i=0, 59 do
			local t = i / 60
			t *= 5
			t = (t - 1) / 3
			t *= 5
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					local prog = x / 64
					prog *= 5
					table.insert(layer, math.round(math.clamp(t - prog + math.random() * 0.2, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
		table.insert(AsciiTextarttr, a)
		table.insert(AsciiTextarttr, a)
		table.insert(AsciiTextarttr, a)
		-- noisy fade
		a = {}
		for i=0, 59 do
			local t = i / 60
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					table.insert(layer, math.round(math.clamp(t * 2 - 1 + math.random() * 0.8, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
		-- circle outward
		a = {}
		for i=0, 59 do
			local t = i / 60
			t *= 5
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					local dist = math.sqrt(math.pow(x - 32, 2) + math.pow(y - 32, 2)) / 64
					dist *= 5
					table.insert(layer, math.round(math.clamp(t - dist + math.random() * 0.2, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
		-- circle inward
		a = {}
		for i=0, 59 do
			local t = 1 - i / 60
			t *= 5
			t -= 1
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					local dist = math.sqrt(math.pow(x - 32, 2) + math.pow(y - 32, 2)) / 64
					dist *= 5
					table.insert(layer, math.round(math.clamp(dist - t + math.random() * 0.2, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
	end
	local function switchart()
		if AsciiTextartsw then return end
		AsciiTextartsw = true
		local function animation(art, inv)
			local transmap = AsciiTextarttr[math.random(1, #AsciiTextarttr)]
			local rot = math.random(0, 3)
			local st = os.clock()
			repeat
				local t = os.clock() - st
				local i = math.clamp(math.floor(t * 60) + 1, 1, 60)
				local render = {}
				for iy=1, #art do
					local y = (iy - 1) / #art
					local conc = ""
					local txt = art[iy]
					for ix=1, #txt do
						local x = (ix - 1) / #txt
						local ch = string.sub(txt, ix, ix)
						local b = 0
						if rot == 0 then
							b = transmap[i][math.floor(y * 64) + 1][math.floor(x * 64) + 1]
						elseif rot == 1 then
							b = transmap[i][math.floor(x * 64) + 1][64 - math.floor(y * 64)]
						elseif rot == 2 then
							b = transmap[i][64 - math.floor(y * 64)][64 - math.floor(x * 64)]
						elseif rot == 3 then
							b = transmap[i][64 - math.floor(x * 64)][math.floor(y * 64) + 1]
						end
						if inv then b = 3 - b end
						if b == 1 then
							if (ch == ch:upper() and ch ~= ch:lower()) or ch == "8" or ch == "0" then
								ch = "?"
							elseif ch == ":" or ch == ";" or ch == "_" then
								ch = "."
							elseif ch == "." or ch == "," or ch == " " then
								ch = " "
							else
								ch = ":"
							end
						elseif b == 2 then
							if (ch == ch:upper() and ch ~= ch:lower()) or ch == "8" or ch == "0" then
								ch = ":"
							elseif ch == ":" or ch == ";" or ch == "_" or ch == "." or ch == "," or ch == " " then
								ch = " "
							else
								ch = "."
							end
						elseif b == 3 then
							ch = " "
						end
						conc ..= ch
					end
					table.insert(render, conc)
				end
				AsciiText.Text = table.concat(render, "\n")
				task.wait()
			until os.clock() > st + 1
		end
		local source = string.split(AsciiText.Text, "\n")
		local target = source
		while table.concat(source, "\n") == table.concat(target, "\n") do
			task.wait()
			target = AsciiTextarts[math.random(1, #AsciiTextarts)]
		end
		animation(source, false)
		animation(target, true)
		AsciiText.Text = table.concat(target, "\n")
		AsciiTextartsw = false
	end
	local AsciiTextartin = nil
	AsciiText.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			AsciiTextartin = input
		end
	end)
	AsciiText.InputEnded:Connect(function(input)
		if AsciiTextartin == input then
			AsciiTextartin = nil
			switchart()
		end
	end)
	switchart()
end)
UI.CreateText(MainPage, `Reanimate V{UhhhhhhVersion}, By STEVE & JustAMale :D`, 15, Enum.TextXAlignment.Right)
UI.CreateSeparator(MainPage)
UI.CreateButton(MainPage, " &lt; Back to cool scene", 20).Activated:Connect(function()
	CracktroFrame.Interactable = false
	CracktroFrame.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CracktroFrame.Interactable = true
	end)
end)
UI.CreateSwitch(MainPage, "Skip Intro", SaveData.SkipIntro).Changed:Connect(function(value)
	SaveData.SkipIntro = value
end)
UI.CreateDropdown(MainPage, "UI Theme", {
	"RGB/Default",
	"ALONE",
	"Oxide",
	"Patchma Hub",
	"Genesis V4",
	"Crimson",
	"r/masterhacker",
	"Homer Simpson",
	"Immortality Lord",
	"LIGHT RGB",
	"LIGHT ALONE",
	"Roserika",
	"FastTracker II Blue",
	"Cherry Blossom",
	"Sakura",
	"Tommorow Night 80s", -- my personal IDE theme
	"Ocean",
	"Pipis",
	"NitroX",
	"User Defined (see README)",
}, SaveData.UITheme).Changed:Connect(function(val)
	SaveData.UITheme = val
	SetUITheme(SaveData.UITheme)
end)
UI.CreateSeparator(MainPage)

local MusicName = UI.CreateText(MainPage, "", 15, Enum.TextXAlignment.Center)
UI.CreateButton(MainPage, "Random UI Music", 20).Activated:Connect(function()
	MusicPlayer.PlayMusic()
end)
local _musicnames = {"-- Choose --"}
for i=1, #MusicPlayer.Database do
	local hi = MusicPlayer.Database[i]
	table.insert(_musicnames, hi[2])
end
local MusicSelect = UI.CreateDropdown(MainPage, "UI Music", _musicnames, 1)
MusicSelect.Changed:Connect(function(val)
	if val > 1 then
		MusicSelect.Value = 1
		MusicPlayer.PlayMusic(val - 1)
	end
end)
UI.CreateSwitch(MainPage, math.random(8) == 1 and "Mute @Villager 61s" or "Mute UI Music", SaveData.MuteUIMusic).Changed:Connect(function(value)
	SaveData.MuteUIMusic = value
end)
UI.CreateSwitch(MainPage, "Mute Reanim Music", SaveData.MuteReanimMusic).Changed:Connect(function(value)
	SaveData.MuteReanimMusic = value
end)
UI.CreateSwitch(MainPage, "Mute Sounds", SaveData.MuteUISound).Changed:Connect(function(value)
	SaveData.MuteUISound = value
	if value then
		UISound.Click.Volume = 0
	else
		UISound.Click.Volume = 1
	end
end)
UI.CreateSeparator(MainPage)

UISound.MovesetMusic = Util.Instance("Sound", UIMainFrame)
UISound.MovesetMusic.Looped = true
UISound.MovesetMusic.PlaybackRegionsEnabled = false
UISound.MovesetMusic.Volume = 1
UISound.MovesetMusic.Name = "(unknown)"
UISound.MovesetMusic:SetAttribute("Volume", 1)
local function SetOverrideMovesetMusic(soundid, soundname, volume, region)
	if soundid then
		UISound.MovesetMusic.SoundId = soundid
		UISound.MovesetMusic.Name = soundname or "(unknown)"
		if volume ~= nil then
			UISound.MovesetMusic:SetAttribute("Volume", volume)
		else
			UISound.MovesetMusic:SetAttribute("Volume", 1)
		end
		if region ~= nil then
			UISound.MovesetMusic.PlaybackRegionsEnabled = true
			UISound.MovesetMusic.LoopRegion = region
		else
			UISound.MovesetMusic.PlaybackRegionsEnabled = false
		end
		UISound.MovesetMusic.PlaybackSpeed = 1
		UISound.MovesetMusic.TimePosition = 0
		UISound.MovesetMusic:Play()
	else
		UISound.MovesetMusic:Stop()
	end
end
local function GetOverrideMovesetMusicTime()
	return UISound.MovesetMusic.TimePosition
end
local function SetOverrideMovesetMusicTime(t)
	UISound.MovesetMusic.TimePosition = t
end
local function SetOverrideMovesetMusicSpeed(speed)
	UISound.MovesetMusic.PlaybackSpeed = speed
end
UISound.DanceMusic = Util.Instance("Sound", UIMainFrame)
UISound.DanceMusic.Looped = true
UISound.DanceMusic.PlaybackRegionsEnabled = false
UISound.DanceMusic.Volume = 1
UISound.DanceMusic.Name = "(unknown)"
UISound.DanceMusic:SetAttribute("Volume", 1)
UISound.DanceMusic:SetAttribute("ModulePlaybackSpeed", 1)
local LastDanceMusicTimeRead = -math.huge
local LastDanceMusicTimeValue = 0
local function GetAnimationPlaybackSpeed()
	local options = SaveData.AnimLibOptions
	return math.clamp(tonumber(options and options.Speed) or 1, 0.25, 2)
end
local function ShouldApplyAnimationSpeedToMusic()
	local options = SaveData.AnimLibOptions
	return type(options) == "table" and options.ApplySpeedToMusic == true
end
local function ApplyOverrideDanceMusicPlaybackSpeed()
	local moduleSpeed = tonumber(UISound.DanceMusic:GetAttribute("ModulePlaybackSpeed")) or 1
	local globalSpeed = ShouldApplyAnimationSpeedToMusic() and GetAnimationPlaybackSpeed() or 1
	local success, reason = pcall(function()
		UISound.DanceMusic.PlaybackSpeed = moduleSpeed * globalSpeed
	end)
	if not success then
		warn("Could not apply dance music playback speed: " .. tostring(reason))
	end
end
local function IsDanceMusicDrivenStep(animator, stepTime)
	if os.clock() - LastDanceMusicTimeRead >= 0.05 or not UISound.DanceMusic.IsPlaying then
		animator._lastDanceMusicStepInput = nil
		animator._lastObservedDanceMusicTime = nil
		animator._usingDanceMusicClock = false
		return false
	end

	local usingDanceMusicClock = true
	local lastStepTime = animator._lastDanceMusicStepInput
	local lastMusicTime = animator._lastObservedDanceMusicTime
	if type(lastStepTime) == "number" and type(lastMusicTime) == "number" then
		local stepDelta = stepTime - lastStepTime
		local musicDelta = LastDanceMusicTimeValue - lastMusicTime
		local soundSpeed = tonumber(UISound.DanceMusic.PlaybackSpeed) or 1
		if math.abs(soundSpeed) < 0.001 then
			usingDanceMusicClock = math.abs(musicDelta) >= 0.0005 or math.abs(stepDelta) < 0.0005
		else
			local realClockDelta = musicDelta / soundSpeed
			local musicTolerance = math.max(0.0005, math.abs(musicDelta) * 0.03)
			local clockTolerance = math.max(0.0005, math.abs(realClockDelta) * 0.03)
			local followsMusic = math.abs(stepDelta - musicDelta) <= musicTolerance
			local followsRealClock = math.abs(stepDelta - realClockDelta) <= clockTolerance
			usingDanceMusicClock = followsMusic or not followsRealClock
		end
	end

	animator._lastDanceMusicStepInput = stepTime
	animator._lastObservedDanceMusicTime = LastDanceMusicTimeValue
	animator._usingDanceMusicClock = usingDanceMusicClock
	return usingDanceMusicClock
end

local function SetOverrideDanceMusic(soundid, soundname, volume, region)
	if soundid then
		UISound.DanceMusic.SoundId = soundid
		UISound.DanceMusic.Name = soundname or "(unknown)"
		if volume ~= nil then
			UISound.DanceMusic:SetAttribute("Volume", volume)
		else
			UISound.DanceMusic:SetAttribute("Volume", 1)
		end
		if region ~= nil then
			UISound.DanceMusic.PlaybackRegionsEnabled = true
			UISound.DanceMusic.LoopRegion = region
		else
			UISound.DanceMusic.PlaybackRegionsEnabled = false
		end
		UISound.DanceMusic:SetAttribute("ModulePlaybackSpeed", 1)
		ApplyOverrideDanceMusicPlaybackSpeed()
		UISound.DanceMusic.TimePosition = 0
		UISound.DanceMusic:Play()
	else
		UISound.DanceMusic:Stop()
	end
end
local function GetOverrideDanceMusicTime()
	LastDanceMusicTimeRead = os.clock()
	LastDanceMusicTimeValue = UISound.DanceMusic.TimePosition
	return LastDanceMusicTimeValue
end
local function SetOverrideDanceMusicTime(t)
	UISound.DanceMusic.TimePosition = t
end
local function SetOverrideDanceMusicSpeed(speed)
	UISound.DanceMusic:SetAttribute("ModulePlaybackSpeed", speed)
	ApplyOverrideDanceMusicPlaybackSpeed()
end

local _MainMusicIsMuted = SaveData.MuteUIMusic
AddToRenderStep(function()
	local musicname = UISound.Music.Name
	local mustmute = SaveData.MuteUIMusic
	if SaveData.MuteReanimMusic then
		UISound.MovesetMusic.Volume = 0
		UISound.DanceMusic.Volume = 0
	else
		if UISound.DanceMusic.IsPlaying then
			mustmute = true
			UISound.DanceMusic.Volume = UISound.DanceMusic:GetAttribute("Volume")
			UISound.MovesetMusic.Volume = 0
			musicname = UISound.DanceMusic.Name
		elseif UISound.MovesetMusic.IsPlaying then
			mustmute = true
			UISound.MovesetMusic.Volume = UISound.MovesetMusic:GetAttribute("Volume")
			musicname = UISound.MovesetMusic.Name
		end
	end
	if _MainMusicIsMuted ~= mustmute then
		_MainMusicIsMuted = mustmute
		if mustmute then
			UISound.Music.Volume = 0
		else
			UISound.Music.Volume = 1
		end
	end
	MusicName.Text = `Current Music Playing:\n{musicname:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")}`
end)
task.wait()

FallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight
if FallenPartsDestroyHeight ~= FallenPartsDestroyHeight then
	FallenPartsDestroyHeight = -500
end
local RejectCharacterDeletionsDisabled = false
pcall(function()
	local rcd, _ = gethiddenproperty(workspace, "RejectCharacterDeletions")
	if rcd.Name == "Disabled" then
		RejectCharacterDeletionsDisabled = true
	end
end)

local function CreateHumanoidCharacter()
	local char = Util.Instance("Model")
	char.Name = "(C) BlaaBlaa V" .. UhhhhhhVersion

	local god = Util.Instance("ForceField", char)
	god.Name = "heyy!! :33"
	god.Visible = false

	local hum = Util.Instance("Humanoid", char)
	hum.Name = "Humanoid"
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	hum.RequiresNeck = false
	hum.BreakJointsOnDeath = false
	hum.UseJumpPower = true
	hum.WalkSpeed = 16
	hum.JumpPower = 50
	hum.Health = 100
	hum.MaxHealth = 100
	hum.MaxSlopeAngle = 89
	hum.HipHeight = 0
	hum.AutoRotate = true
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	local function makePart(name, size, pos)
		local part = Util.Instance("Part", char)
		part.Name = name
		part.Size = size
		part.Position = pos
		part.Anchored = false
		part.CanCollide = false
		part.Transparency = 1
		part.Reflectance = 0
		part.Color = Color3.new(1, 0, 0)
		part.CastShadow = false
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.LeftSurface = Enum.SurfaceType.Smooth
		part.RightSurface = Enum.SurfaceType.Smooth
		part.FrontSurface = Enum.SurfaceType.Smooth
		part.BackSurface = Enum.SurfaceType.Smooth
		return part
	end

	local root = makePart("HumanoidRootPart", Vector3.new(2, 2, 1), Vector3.new(0, 0, 0))
	local torso = makePart("Torso", Vector3.new(2, 2, 1), Vector3.new(0, 0, 0))
	local head = makePart("Head", Vector3.new(2, 1, 1), Vector3.new(0, 1.5, 0))
	local leftArm = makePart("Left Arm", Vector3.new(1, 2, 1), Vector3.new(-1.5, 0, 0))
	local rightArm = makePart("Right Arm", Vector3.new(1, 2, 1), Vector3.new(1.5, 0, 0))
	local leftLeg = makePart("Left Leg", Vector3.new(1, 2, 1), Vector3.new(-0.5, -2, 0))
	local rightLeg = makePart("Right Leg", Vector3.new(1, 2, 1), Vector3.new(0.5, -2, 0))

	local function makeMotor(name, p0, p1, c0, c1)
		local motor = Instance.new("Motor6D", p0)
		motor.Name = name
		motor.Part0 = p0
		motor.Part1 = p1
		motor.C0 = c0
		motor.C1 = c1
		motor.MaxVelocity = 0
		Util.LinkDestroyI2C(motor, RunService.PreRender:Connect(function()
			local scale = char:GetScale()
			motor:SetAttribute("Transform", Util.ScaleCFrame(motor.Transform, 1 / scale))
			motor.Transform = Util.ScaleCFrame(motor:GetAttribute("Transform") or CFrame.identity, scale)
		end))
	end

	makeMotor(
		"RootJoint", root, torso,
		CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
		CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	)
	makeMotor(
		"Neck", torso, head,
		CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
		CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	)
	makeMotor(
		"Left Shoulder", torso, leftArm,
		CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
		CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	)
	makeMotor(
		"Right Shoulder", torso, rightArm,
		CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
		CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	)
	makeMotor(
		"Left Hip", torso, leftLeg,
		CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
		CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	)
	makeMotor(
		"Right Hip", torso, rightLeg,
		CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
		CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	)

	local headshape = Util.Instance("SpecialMesh", head)
	headshape.Name = "Mesh"
	headshape.MeshType = Enum.MeshType.Head
	headshape.Scale = Vector3.new(1.25, 1.25, 1.25)

	local face = Util.Instance("Decal", head)
	face.Name = "face"
	face.Texture = "rbxassetid://123572006339559"
	face.Color3 = Color3.new(0, 0, 0)

	local tshirt = Util.Instance("Decal", torso)
	tshirt.Name = "triforce"
	tshirt.Texture = "rbxassetid://101055520647223"
	tshirt.Color3 = Color3.new(1, 1, 1)
	
	Util.LinkDestroyI2C(char, RunService.PreRender:Connect(function()
		face.Transparency = Util.GetTransparency(head)
		tshirt.Transparency = Util.GetTransparency(torso)
	end))

	char.PrimaryPart = root

	return char
end

local GameSettings = UserSettings():GetService("UserGameSettings")

SaveData.NoInfiniteJump = not not SaveData.NoInfiniteJump
SaveData.NoclipEnabled = not not SaveData.NoclipEnabled
SaveData.CtrlClickEnabled = not not SaveData.CtrlClickEnabled
SaveData.ClickFlingEnabled = not not SaveData.ClickFlingEnabled
SaveData.NoSmoothCam = not not SaveData.NoSmoothCam
SaveData.FirstPersonBody = not not SaveData.FirstPersonBody
if type(SaveData.SeatSitEnabled) ~= "boolean" then
	SaveData.SeatSitEnabled = SaveData.NoSeatSitEnabled ~= true
end
SaveData.SeatSitEnabled = SaveData.SeatSitEnabled ~= false
-- Keep the original negative field synchronized so older Uhhhhhh builds can
-- still read the same save without silently reversing the user's choice.
SaveData.NoSeatSitEnabled = not SaveData.SeatSitEnabled
SaveData.KeepSeatSitState = not not SaveData.KeepSeatSitState
SaveData.ToolGrabEnabled = not not SaveData.ToolGrabEnabled
SaveData.ScaleGravityEnabled = true
SaveData.CharacterScale = SaveData.CharacterScale or 1
SaveData.P2PCollision = not not SaveData.P2PCollision
SaveData.ShiftlockDisabled = not not SaveData.ShiftlockDisabled
SaveData.NoLoadAnimationHook = not not SaveData.NoLoadAnimationHook
SaveData.NoPhysicsRepRootPart = not not SaveData.NoPhysicsRepRootPart
SaveData.PhysicsRepRootPartFling = math.clamp(tonumber(SaveData.PhysicsRepRootPartFling) or 1 / 20, 0.001, 30)
SaveData.NetlessVelocity = SaveData.NetlessVelocity or 25.01
SaveData.UsePatchmaLikeNetless = not not SaveData.UsePatchmaLikeNetless or true
SaveData.UseAngularVelocity = not not SaveData.UseAngularVelocity or true
SaveData.PatchmaVoidFloat = not not SaveData.PatchmaVoidFloat
SaveData.PlaceholderTransparency = SaveData.PlaceholderTransparency or 0.5
if SaveData.ShowResetPlaceholder == nil then
	SaveData.ShowResetPlaceholder = true
end
SaveData.ShowReanimateHitboxes = not not SaveData.ShowReanimateHitboxes
if SaveData.EnableUntrustedExtras == nil then
	SaveData.EnableUntrustedExtras = _G.UhhhhhhEnableUntrustedExtras == true
end
_G.UhhhhhhEnableUntrustedExtras = SaveData.EnableUntrustedExtras == true

local StartUntrustedExtras = nil
local UntrustedExtrasControl = {
	Enabled = SaveData.EnableUntrustedExtras == true,
	Generation = 0,
	Running = false,
}
local function SetUntrustedExtrasEnabled(value)
	value = value == true
	SaveData.EnableUntrustedExtras = value
	_G.UhhhhhhEnableUntrustedExtras = value
	if UntrustedExtrasControl.Enabled ~= value then
		UntrustedExtrasControl.Enabled = value
		UntrustedExtrasControl.Generation += 1
	end
	if value and StartUntrustedExtras then
		StartUntrustedExtras()
	end
end


-- empyrean-like thing
local _G_Uhhhhhh = {}
-- jjsloit didnt have _G, just making sure if 100% unc execs dont have this even
pcall(function() _G.Uhhhhhh = _G_Uhhhhhh end)
_G_Uhhhhhh.BindableEvent = Util.Instance("BindableEvent") -- not used 3:
ws=cloneref(workspace)
p=cloneref(game:GetService("Players")).LocalPlayer
-- stuff that wasnt added by steve just to make sure things work properly
pcall(function()
	sethiddenproperty(ws, "SignalBehavior", "Immediate")
end)
pcall(function()
	settings().Network.IncomingReplicationLag = -100
end)
local Reanimate = {
	Current = nil,
	Character = nil,
	CharacterLTMs = {},
	Starting = false,
	Stopping = false,
	UseLoadAnimationHook = not SaveData.NoLoadAnimationHook,
	UsePhysicsRepRootPart = not SaveData.NoPhysicsRepRootPart,
	PhysicsRepRootPartFling = SaveData.PhysicsRepRootPartFling,
	NetlessVelocity = SaveData.NetlessVelocity,
	UsePatchmaLikeNetless = SaveData.UsePatchmaLikeNetless,
	UseAngularVelocity = SaveData.UseAngularVelocity,
	InfiniteJump = not SaveData.NoInfiniteJump,
	Noclip = SaveData.NoclipEnabled,
	CtrlClick = SaveData.CtrlClickEnabled,
	ClickFling = SaveData.ClickFlingEnabled,
	SmoothCam = not SaveData.NoSmoothCam,
	FirstPersonBody = SaveData.FirstPersonBody,
	SeatSit = SaveData.SeatSitEnabled,
	KeepSeatSitState = SaveData.KeepSeatSitState,
	ToolGrab = SaveData.ToolGrabEnabled,
	ScaleGravity = SaveData.ScaleGravityEnabled,
	PatchmaVoidFloat = SaveData.PatchmaVoidFloat,
	AntiExplosions = true,
	CharacterScale = SaveData.CharacterScale,
	PlaceholderTransparency = SaveData.PlaceholderTransparency,
	ShowResetPlaceholder = SaveData.ShowResetPlaceholder,
	ShowHitboxes = SaveData.ShowReanimateHitboxes,
	P2PCollision = false,
	ShiftlockEnabled = not SaveData.ShiftlockDisabled,
	Shiftlocked = false,
	ShouldRotationType = function(self)
		if self.Camera:IsMouseLocked() and not self.Camera.Scriptable and self.Character then
			local hum = self.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.AutoRotate and hum.RootPart and not hum.RootPart:IsGrounded() then
				local state = hum:GetState().Name
				if table.find({"Running", "Jumping", "Freefall", "Landed", "Climbing"}, state) then
					return true
				end
			end
		end
		return false
	end,
	Camera = {
		CFrame = CFrame.identity,
		Focus = CFrame.identity,
		Scriptable = false,
		VRMode = false,
		FPSLocked = false,
		Zoom = 16,
		FieldOfView = 70,
		Input = Vector3.zero,
		_Zoom = 16,
		OnReset = function(self)
			self.Zoom = (self.Focus.Position - self.CFrame.Position).Magnitude
			self._Zoom = self.Zoom
			self.Scriptable = false
			self.FPSLocked = false
			self.FieldOfView = 70
			self.Inputs:Reset()
		end,
		OnPanInput = function(self, vec, accum)
			if accum then
				self.Input += Vector3.new(vec.X, vec.Y, 0)
			else
				self.Input = Vector3.new(vec.X, vec.Y, self.Input.Z)
			end
		end,
		OnZoomInput = function(self, zoom)
			self.Input = Vector3.new(self.Input.X, self.Input.Y, zoom)
		end,
		Inputs = {
			KB = {
				Left = false,
				Right = false,
			},
			MS = {
				RMB = false,
			},
			TC = {
				DJ = nil,
				Touch = {},
				LP = nil,
			},
			GP = {
				DJ = Vector2.zero,
			},
			Reset = function(self)
				self.KB.Left = false
				self.KB.Right = false
				self.MS.RMB = false
				self.TC.DJ = nil
				table.clear(self.TC.Touch)
				self.TC.LP = nil
				self.GP.DJ = Vector2.zero
			end,
		},
	},
	LocalTransparencyModifier = 0,
	Control = {
		Move = Vector3.zero,
		Jump = false,
		Inputs = {
			KB = {
				Up = false,
				Down = false,
				Left = false,
				Right = false,
				Space = false,
			},
			TC = {
				DJ = nil,
				LP = nil,
				JB = nil,
			},
			GP = {
				DJ = Vector2.zero,
				JB = false,
			},
			Reset = function(self)
				self.KB.Up = false
				self.KB.Down = false
				self.KB.Left = false
				self.KB.Right = false
				self.KB.Space = false
				self.TC.DJ = nil
				self.TC.LP = nil
				self.TC.JB = nil
				self.GP.DJ = Vector2.zero
				self.GP.JB = false
			end,
		}
	}
}
Reanimate.Camera.IsFirstPerson = function(self)
	return self.Zoom < 0.75
end
Reanimate.Camera.IsMouseLocked = function(self)
	return self:IsFirstPerson() or Reanimate.Shiftlocked
end
Reanimate.Camera.IsMousePanning = function(self)
	return self:IsMouseLocked() or self.Inputs.MS.RMB
end
Reanimate.Camera.GetMovementCFrame = function(self)
	local ccf = Reanimate.Camera.CFrame
	if Reanimate.Camera.VRMode then
		local _,y,_ = VRService:GetUserCFrame(Enum.UserCFrame.Head):ToEulerAngles(Enum.RotationOrder.YXZ)
		ccf *= CFrame.Angles(0, y, 0)
	end
	return ccf
end
do
	local thumbstickAreaTopLeft = nil
	local thumbstickAreaBottomRight = nil
	local jumpButtonTopLeft = nil
	local jumpButtonBottomRight = nil
	local function IsInArea(pos, tl, br)
		return pos.X >= tl.X and pos.Y >= tl.Y and pos.X <= br.X and pos.Y <= br.Y
	end
	local function WillSinkToWorld(pos)
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		local touchGui
		if playerGui then
			touchGui = playerGui:FindFirstChild("TouchGui")
		end
		local corestuff = CoreGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
		for _,v in corestuff do
			if Util.WillGuiSinkInput(v) then
				return false
			end
		end
		local plrstuff = playerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
		for _,v in plrstuff do
			if v:IsDescendantOf(touchGui) then
				return true
			end
			if Util.WillGuiSinkInput(v) then
				return false
			end
		end
		return true
	end
	local function IsInThumbstickArea(pos)
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		if playerGui then
			local touchGui = playerGui:FindFirstChild("TouchGui")
			if touchGui and touchGui.Enabled then
				local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
				local thumbstickFrame = touchFrame and (touchFrame:FindFirstChild("DynamicThumbstickFrame") or touchFrame:FindFirstChild("ThumbstickFrame"))
				if thumbstickFrame then
					thumbstickAreaTopLeft = thumbstickFrame.AbsolutePosition
					thumbstickAreaBottomRight = thumbstickAreaTopLeft + thumbstickFrame.AbsoluteSize
				end
			end
		end
		if thumbstickAreaTopLeft and thumbstickAreaBottomRight then
			return IsInArea(pos, thumbstickAreaTopLeft, thumbstickAreaBottomRight)
		end
		return false
	end
	local function IsInJumpButtonArea(pos)
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		if playerGui then
			local touchGui = playerGui:FindFirstChild("TouchGui")
			if touchGui and touchGui.Enabled then
				local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
				local jumpButton = touchFrame and touchFrame:FindFirstChild("JumpButton")
				if jumpButton then
					jumpButtonTopLeft = jumpButton.AbsolutePosition
					jumpButtonBottomRight = jumpButtonTopLeft + jumpButton.AbsoluteSize
				end
			end
		end
		if jumpButtonTopLeft and jumpButtonBottomRight then
			return IsInArea(pos, jumpButtonTopLeft, jumpButtonBottomRight)
		end
		return false
	end
	do -- Control
		local self = Reanimate.Control
		UserInputService.InputBegan:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.W then
					self.Inputs.KB.Up = true
				end
				if input.KeyCode == Enum.KeyCode.S then
					self.Inputs.KB.Down = true
				end
				if input.KeyCode == Enum.KeyCode.Up then
					self.Inputs.KB.Up = true
				end
				if input.KeyCode == Enum.KeyCode.Down then
					self.Inputs.KB.Down = true
				end
				if input.KeyCode == Enum.KeyCode.A then
					self.Inputs.KB.Left = true
				end
				if input.KeyCode == Enum.KeyCode.D then
					self.Inputs.KB.Right = true
				end
				if input.KeyCode == Enum.KeyCode.Space then
					self.Inputs.KB.Space = true
				end
			end
			if input.KeyCode == Enum.KeyCode.ButtonA then
				self.Inputs.GP.JB = true
			end
			if input.UserInputType == Enum.UserInputType.Touch and WillSinkToWorld(input.Position) then
				if self.Inputs.TC.DJ == nil and IsInThumbstickArea(input.Position) then
					self.Inputs.TC.DJ = input
					self.Inputs.TC.LP = input.Position
					return
				end
				if self.Inputs.TC.JB == nil and IsInJumpButtonArea(input.Position) then
					self.Inputs.TC.JB = input
					return
				end
			end
		end)
		UserInputService.InputChanged:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.KeyCode == Enum.KeyCode.Thumbstick1 then
				self.Inputs.GP.DJ = Vector2.new(input.Position.X, -input.Position.Y)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.W then
					self.Inputs.KB.Up = false
				end
				if input.KeyCode == Enum.KeyCode.S then
					self.Inputs.KB.Down = false
				end
				if input.KeyCode == Enum.KeyCode.Up then
					self.Inputs.KB.Up = false
				end
				if input.KeyCode == Enum.KeyCode.Down then
					self.Inputs.KB.Down = false
				end
				if input.KeyCode == Enum.KeyCode.A then
					self.Inputs.KB.Left = false
				end
				if input.KeyCode == Enum.KeyCode.D then
					self.Inputs.KB.Right = false
				end
				if input.KeyCode == Enum.KeyCode.Space then
					self.Inputs.KB.Space = false
				end
			end
			if input.KeyCode == Enum.KeyCode.ButtonA then
				self.Inputs.GP.JB = false
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == input then
					self.Inputs.TC.DJ = nil
					self.Inputs.TC.LP = nil
				elseif self.Inputs.TC.JB == input then
					self.Inputs.TC.JB = nil
				end
			end
			if input.KeyCode == Enum.KeyCode.Thumbstick1 then
				self.Inputs.GP.DJ = Vector2.zero
			end
		end)
		local function resetInputDevices()
			self.Inputs:Reset()
		end
		UserInputService.WindowFocused:Connect(resetInputDevices)
		UserInputService.WindowFocusReleased:Connect(resetInputDevices)
		UserInputService.TextBoxFocusReleased:Connect(resetInputDevices)
		GuiService.MenuOpened:Connect(resetInputDevices)
		RunService:BindToRenderStep("Uhhhhhh_Control", Enum.RenderPriority.Input.Value + 1, function(dt)
			if UserInputService:GetFocusedTextBox() then
				resetInputDevices()
			end
			local screensize = Util.GetScreenSize()
			self.Move = Vector3.zero
			if self.Inputs.KB.Up then
				self.Move += Vector3.new(0, 0, -1)
			end
			if self.Inputs.KB.Down then
				self.Move += Vector3.new(0, 0, 1)
			end
			if self.Inputs.KB.Left then
				self.Move += Vector3.new(-1, 0, 0)
			end
			if self.Inputs.KB.Right then
				self.Move += Vector3.new(1, 0, 0)
			end
			if self.Inputs.TC.DJ and self.Inputs.TC.LP then
				local stickrad = 40
				if math.min(screensize.X, screensize.Y) < 500 then
					stickrad = 20
				end
				local dir = (self.Inputs.TC.DJ.Position - self.Inputs.TC.LP) / stickrad
				if dir.Magnitude > 0.05 then
					dir = dir.Unit * math.min(1, (dir.Magnitude - 0.05) / (1 - 0.05))
					self.Move += Vector3.new(dir.X, 0, dir.Y)
				end
			end
			if self.Inputs.GP.DJ.Magnitude > 0.2 then
				self.Move += Vector3.new(self.Inputs.GP.DJ.X, 0, self.Inputs.GP.DJ.Y)
			end
			if self.Move.Magnitude > 1 then self.Move = self.Move.Unit end
			self.Jump = false
			if self.Inputs.KB.Space then
				self.Jump = true
			end
			if self.Inputs.TC.JB then
				self.Jump = true
			end
			if self.Inputs.GP.JB then
				self.Jump = true
			end
		end)
	end
	do -- Camera
		local self = Reanimate.Camera
		local function AdjustTouchPitchSensitivity(delta)
			local pitch = Camera.CFrame:ToEulerAnglesYXZ()
			if delta.Y * pitch >= 0 then
				return delta
			end
			local curveY = 1 - (2 * math.abs(pitch) / math.pi) ^ 0.75
			local sensitivity = curveY * 0.75 + 0.25
			return Vector2.new(1, sensitivity) * delta
		end
		local thumbstickCurve do
			local K_CURVATURE = 2 -- amount of upwards curvature (0 is flat)
			local K_DEADZONE = 0.1 -- deadzone
			function thumbstickCurve(x)
				local fDeadzone = (math.abs(x) - K_DEADZONE)/(1 - K_DEADZONE)
				local fCurve = (math.exp(K_CURVATURE*fDeadzone) - 1)/(math.exp(K_CURVATURE) - 1)
				return math.sign(x)*math.clamp(fCurve, 0, 1)
			end
		end
		UserInputService.InputBegan:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
					Reanimate.Shiftlocked = Reanimate.ShiftlockEnabled and not Reanimate.Shiftlocked
				end
				if input.KeyCode == Enum.KeyCode.Left then
					self.Inputs.KB.Left = true
				end
				if input.KeyCode == Enum.KeyCode.Right then
					self.Inputs.KB.Right = true
				end
			end
			if input.KeyCode == Enum.KeyCode.ButtonL3 then
				if self.VRMode then
					if self.Zoom < 7 then
						self.Zoom = 7
					else
						self.Zoom = 0.5
					end
				else
					if self.Zoom <= 0.5 then
						self.Zoom = 20
					elseif self.Zoom <= 10 then
						self.Zoom = 0.5
					elseif self.Zoom <= 20 then
						self.Zoom = 10
					else
						self.Zoom = 20
					end
				end
			end
			if input.KeyCode == Enum.KeyCode.ButtonR3 then
				if self.VRMode then
					-- laziest implementation
					VRService:RecenterUserHeadCFrame()
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				if gpe then return end
				self.Inputs.MS.RMB = true
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if gpe then return end
				if self.Inputs.TC.DJ == nil and IsInThumbstickArea(input.Position) then
					self.Inputs.TC.DJ = input
					return
				end
				self.Inputs.TC.Touch[input] = true
			end
		end)
		UserInputService.InputChanged:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				if self:IsMousePanning() then
					self:OnPanInput(Vector2.new(input.Delta.X, input.Delta.Y) * Vector2.new(1, 0.77) * math.rad(0.5), false)
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseWheel then
				if gpe then return end
				self:OnZoomInput(-input.Position.Z)
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == input then
					return
				end
				local touches = {}
				for touch,exist in self.Inputs.TC.Touch do
					if exist then table.insert(touches, touch) end
				end
				if #touches == 1 then
					if touches[1] == input then
						self:OnPanInput(Vector2.new(input.Delta.X, input.Delta.Y) * Vector2.new(1, 0.66) * math.rad(1), true)
					end
				end
				if #touches == 2 then
					local pinch = (touches[1].Position - touches[2].Position).Magnitude
					if self.Inputs.TC.LP then
						local zoom = (self.Inputs.TC.LP - pinch) * 0.04
						self:OnZoomInput(zoom)
					end
					self.Inputs.TC.LP = pinch
				else
					self.Inputs.TC.LP = nil
				end
			end
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				self.Inputs.GP.DJ = Vector2.new(thumbstickCurve(input.Position.X), -thumbstickCurve(input.Position.Y))
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Left then
					self.Inputs.KB.Left = false
				end
				if input.KeyCode == Enum.KeyCode.Right then
					self.Inputs.KB.Right = false
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				self.Inputs.MS.RMB = false
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == input then
					self.Inputs.TC.DJ = nil
					return
				end
				self.Inputs.TC.LP = nil
				self.Inputs.TC.Touch[input] = false
			end
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				self.Inputs.GP.DJ = Vector2.zero
			end
		end)
		UserInputService.PointerAction:Connect(function(wheel, pan, pinch, gpe)
			if not gpe then
				self:OnPanInput(pan * Vector2.new(1, 0.77) * math.rad(7), false)
				self:OnZoomInput(-wheel - pinch)
			end
		end)
		local function resetInputDevices()
			self.Inputs:Reset()
		end
		UserInputService.WindowFocused:Connect(resetInputDevices)
		UserInputService.WindowFocusReleased:Connect(resetInputDevices)
		UserInputService.TextBoxFocusReleased:Connect(resetInputDevices)
		GuiService.MenuOpened:Connect(resetInputDevices)
		local states = {
			[false] = "rbxasset://textures/ui/mouseLock_off@2x.png",
			[true] = "rbxasset://textures/ui/mouseLock_on@2x.png"
		}
		local MobileShiftlock = Instance.new("ImageButton")
		MobileShiftlock.Parent = SCREENGUI
		MobileShiftlock.BackgroundTransparency = 1
		MobileShiftlock.Position = UDim2.new(1, -190, 1, -60)
		MobileShiftlock.Size = UDim2.new(0, 40, 0, 40)
		MobileShiftlock.Image = states[false]
		local state = false
		AddToRenderStep(function()
			local playerGui = Player:FindFirstChildOfClass("PlayerGui")
			local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
			if not touchGui or not touchGui.Enabled then
				MobileShiftlock.Visible = false
				return
			end
			local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
			local jumpButton = touchFrame and touchFrame:FindFirstChild("JumpButton")
			if not jumpButton then
				MobileShiftlock.Visible = false
				return
			end
			if state ~= Reanimate.Shiftlocked then
				state = Reanimate.Shiftlocked
				MobileShiftlock.Image = states[state]
			end
			MobileShiftlock.Visible = not not Reanimate.Character
			local pos = jumpButton.AbsolutePosition - SCREENGUI.AbsolutePosition
			local size = jumpButton.AbsoluteSize
			local ratio = 4 / 7
			pos += Vector2.new(-size.X * (ratio + 0.2), size.Y * (1 - ratio))
			size *= ratio
			MobileShiftlock.Position = UDim2.fromOffset(pos.X, pos.Y)
			MobileShiftlock.Size = UDim2.fromOffset(size.X, size.Y)
		end)
		MobileShiftlock.Activated:Connect(function()
			Reanimate.Shiftlocked = Reanimate.ShiftlockEnabled and not Reanimate.Shiftlocked
		end)
		RunService:BindToRenderStep("Uhhhhhh_Camera", Enum.RenderPriority.Camera.Value + 1, function(dt)
			self.VRMode = VRService.VREnabled
			if UserInputService:GetFocusedTextBox() then
				resetInputDevices()
			end
			if self.Inputs.KB.Left then
				self:OnPanInput(Vector2.new(math.rad(-120) * dt, 0), true)
			end
			if self.Inputs.KB.Right then
				self:OnPanInput(Vector2.new(math.rad(120) * dt, 0), true)
			end
			self:OnPanInput(self.Inputs.GP.DJ * Vector2.new(1, 0.77) * math.rad(4) * 60 * dt * GameSettings.GamepadCameraSensitivity, true)
			local input = self.Input * Vector3.new(1, GameSettings:GetCameraYInvertValue(), 1)
			self.Input = Vector3.zero
			local zoomDelta = input.Z
			if math.abs(zoomDelta) > 0 then
				if zoomDelta > 0 then
					self.Zoom += zoomDelta * (1 + self.Zoom * 0.5)
				else
					self.Zoom = (self.Zoom + zoomDelta) / (1 - zoomDelta * 0.5)
				end
			end
			self.Zoom = math.clamp(self.Zoom, 0.5, 100000)
			local rzoom = self.Zoom
			if self.FPSLocked then
				self.Zoom = 0.5
				rzoom = 0.5
			end
			if self.VRMode then
				input *= Vector3.new(1, 0, 1)
				rzoom *= Reanimate.CharacterScale
				self._Zoom = rzoom
			end
			self._Zoom = rzoom + (self._Zoom - rzoom) * math.exp(-32 * dt)
			local ltm = Reanimate.LocalTransparencyModifier
			local tltm = 0
			local sltm = dt * 3
			if not self.Scriptable then
				if self:IsFirstPerson() then
					tltm = 1
				elseif rzoom < 1.5 * Reanimate.CharacterScale then
					tltm = 0.5
				end
			end
			if math.abs(ltm - tltm) <= sltm then
				ltm = tltm
			elseif ltm < tltm then
				ltm += sltm
			else
				ltm -= sltm
			end
			Reanimate.LocalTransparencyModifier = ltm
			if not Reanimate.ShiftlockEnabled and Reanimate.Shiftlocked then
				Reanimate.Shiftlocked = false
			end
			if Reanimate.Character then
				local targetMouseBehavior = Enum.MouseBehavior.Default
				if self:IsMousePanning() then
					if self:IsMouseLocked() then
						if UserInputService.TouchEnabled then
							targetMouseBehavior = Enum.MouseBehavior.LockCurrentPosition
						else
							targetMouseBehavior = Enum.MouseBehavior.LockCenter
						end
					else
						targetMouseBehavior = Enum.MouseBehavior.LockCurrentPosition
					end
				end
				if UserInputService.MouseBehavior ~= targetMouseBehavior then
					UserInputService.MouseBehavior = targetMouseBehavior
				end
				local targetMouseIcon = ""
				if Reanimate.Shiftlocked then
					targetMouseIcon = "rbxasset://textures/Cursors/CrossMouseIcon.png"
				end
				if UserInputService.MouseIcon ~= targetMouseIcon then
					UserInputService.MouseIcon = targetMouseIcon
				end
				if GameSettings.RotationType ~= Enum.RotationType.MovementRelative then
					GameSettings.RotationType = Enum.RotationType.MovementRelative
				end
				local Humanoid = Reanimate.Character:FindFirstChildOfClass("Humanoid")
				local RootPart = Reanimate.Character:FindFirstChild("HumanoidRootPart")
				if Humanoid and RootPart and Camera.CameraSubject == Humanoid then
					if self.Scriptable then
						Camera.FieldOfView = self.FieldOfView
						Camera.FieldOfViewMode = "Vertical"
					else
						Camera.FieldOfView = 70
						Camera.FieldOfViewMode = "Vertical"
						local newCameraCFrame, newCameraFocus = self.CFrame, self.Focus
						local subjectPosition = RootPart.Position + RootPart.CFrame.UpVector * 1.5
						if not self.VRMode then subjectPosition += RootPart.CFrame.Rotation * Humanoid.CameraOffset end
						local currLookVector = suppliedLookVector or newCameraCFrame.LookVector
						local currPitchAngle = math.asin(currLookVector.Y)
						local constrainedRotateInput = Vector2.new(input.X, math.clamp(input.Y, math.rad(-80) + currPitchAngle, math.rad(80) + currPitchAngle))
						local startCFrame = CFrame.lookAt(Vector3.zero, currLookVector)
						local newLookCFrame = CFrame.Angles(0, -constrainedRotateInput.X, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.Y, 0, 0)
						local newLookVector = newLookCFrame.LookVector
						if self.VRMode then
							newLookVector = (newLookVector * Vector3.new(1, 0, 1)).Unit
							if newLookVector.Magnitude == 0 or newLookVector ~= newLookVector then
								newLookVector = Vector3.zAxis
							end
						end
						if self:IsMouseLocked() and not self:IsFirstPerson() then
							local cameraRelativeOffset = newLookCFrame * Vector3.new(1.7, 0, 0)
							if cameraRelativeOffset == cameraRelativeOffset then
								subjectPosition += cameraRelativeOffset
							end
						end
						newCameraFocus = CFrame.new(subjectPosition)
						local cameraFocusP = newCameraFocus.Position
						if self.VRMode then
							cameraFocusP += newLookVector * 0.5
						end
						newCameraCFrame = CFrame.lookAt(cameraFocusP - newLookVector * self._Zoom, cameraFocusP)
						self.CFrame, self.Focus = newCameraCFrame, newCameraFocus
					end
					Camera.CFrame, Camera.Focus = self.CFrame, self.Focus
				end
				for _,v in Reanimate.CharacterLTMs do
					v.LocalTransparencyModifier = ltm
				end
			end
			pcall(function() CoreGui.TopBarApp.TopBarApp.FullScreenFrame.HurtOverlay.Visible = false end)
		end)
	end
end
Reanimate.CameraLockCharacter = function()
	local RCRootPart = Reanimate.Character and Reanimate.Character:FindFirstChild("HumanoidRootPart")
	if RCRootPart and RCRootPart:IsA("BasePart") then
		local ccf = Reanimate.Camera:GetMovementCFrame()
		local rcf = RCRootPart.CFrame
		local ax, ay, az = ccf:ToEulerAngles(Enum.RotationOrder.YXZ)
		local bx, by, bz = rcf:ToEulerAngles(Enum.RotationOrder.YXZ)
		RCRootPart.CFrame = CFrame.fromEulerAngles(bx, ay, bz, Enum.RotationOrder.YXZ) + rcf.Position
	end
end
Reanimate.CreateCharacter = function(InitCFrame)
	local RC = Reanimate.Character
	local cf = CFrame.new(Camera.Focus.Position)
	if RC then
		local r = RC:FindFirstChild("HumanoidRootPart")
		if r then
			cf = r.CFrame
		end
		RC:Destroy()
	elseif Player.Character then
		local r = Player.Character:FindFirstChild("HumanoidRootPart")
		if r then
			cf = r.CFrame
		end
	end
	if InitCFrame then
		cf = InitCFrame
	end
	Reanimate.Camera.CFrame, Reanimate.Camera.Focus = Camera.CFrame, Camera.Focus
	Reanimate.Camera:OnReset()
	RC = CreateHumanoidCharacter()
	RC.ModelStreamingMode = "Persistent"
	Player.ReplicationFocus = workspace
	local ltmparts = Reanimate.CharacterLTMs
	table.clear(ltmparts)
	local function OnDescendant(v)
		local exist = pcall(function()
			return v.LocalTransparencyModifier
		end)
		if exist then
			table.insert(ltmparts, v)
			local conn = nil
			conn = v.AncestryChanged:Connect(function()
				if not v:IsDescendantOf(RC) then
					local i = table.find(ltmparts, v)
					if i then
						table.remove(ltmparts, i)
					end
					conn:Disconnect()
				end
			end)
		end
	end
	RC.DescendantAdded:Connect(OnDescendant)
	for _,v in RC:GetDescendants() do
		task.spawn(OnDescendant, v)
	end
	local InitialCharacterScale = Reanimate.CharacterScale
	local PreviousCharacterScale = RC:GetScale()
	RC:ScaleTo(InitialCharacterScale)
	local RCHumanoid, RCRootPart = RC.Humanoid, RC.HumanoidRootPart
	-- Model:ScaleTo changes the R6 geometry but Humanoid.HipHeight needs the
	-- matching ground-clearance delta. Do not assign an absolute value: VR uses
	-- HipHeight for crouching and must keep its own offset.
	RCHumanoid.HipHeight += 2 * (InitialCharacterScale - PreviousCharacterScale)
	local RCHead, RCTorso, RCRootJoint, RCNeck = RC.Head, RC.Torso, RCRootPart.RootJoint, RC.Torso.Neck
	--[[local Anchor = Instance.new("Part", RCRootPart)
	Anchor.Name = "i can take explosions >:3"
	Anchor.Transparency = 1
	Anchor.Anchored = false
	Anchor.CanCollide = false
	Anchor.CanQuery = false
	Anchor.CanTouch = false
	Anchor.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 0, 0)
	Anchor.Size = Vector3.new(2048, 2048, 2048)
	local AnchorWeld = Instance.new("Weld")]]
	local BodyForce = Instance.new("BodyForce")
	BodyForce.Parent = RCRootPart
	BodyForce.Force = Vector3.zero
	RC.Parent = workspace
	RCRootPart.RootPriority = 67
	RCRootPart.CFrame = cf
	local SafeY = cf.Y
	local IsFloat = false
	local SeatWeld = nil
	RC:SetAttribute("_Uhhhhhh_SeatWeldActive", false)
	local LastJumpOffSeat = 0
	local function HasActiveSeatWeld()
		return SeatWeld ~= nil
			and SeatWeld.Parent ~= nil
			and SeatWeld.Part0 ~= nil
			and SeatWeld.Part0:IsDescendantOf(workspace)
	end
	local function DestroySeatWeld()
		if SeatWeld ~= nil then
			SeatWeld:Destroy()
			SeatWeld = nil
		end
		RC:SetAttribute("_Uhhhhhh_SeatWeldActive", false)
	end
	local function PreserveSeatSitState()
		if not Reanimate.SeatSit or not Reanimate.KeepSeatSitState or not HasActiveSeatWeld() or RCHumanoid.Jump then
			return false
		end
		if not RCHumanoid.Sit then
			RCHumanoid.Sit = true
		end
		if RCHumanoid:GetState() ~= Enum.HumanoidStateType.Seated then
			RCHumanoid:ChangeState(Enum.HumanoidStateType.Seated)
		end
		return true
	end
	RCHumanoid.Touched:Connect(function(part, limb)
		if Reanimate.SeatSit and part:IsA("Seat") and not RCHumanoid.Sit and os.clock() - LastJumpOffSeat > 2 then
			RCHumanoid.Sit = true
			DestroySeatWeld()
			SeatWeld = Instance.new("Weld")
			SeatWeld.Name = "hell yeah!! :3"
			SeatWeld.Parent = RCRootPart
			SeatWeld.Part0 = part
			SeatWeld.Part1 = RCRootPart
			SeatWeld.C0 = CFrame.new(0, part.Size.Y / 2, 0)
			SeatWeld.C1 = CFrame.new(0, -1.5 * RC:GetScale(), 0)
			RC:SetAttribute("_Uhhhhhh_SeatWeldActive", true)
			Util.LinkDestroyI2C(SeatWeld,RCHumanoid:GetPropertyChangedSignal("Jump"):Connect(function()
				if RCHumanoid.Jump then
					RCHumanoid.Sit = false
					DestroySeatWeld()
				end
			end))
			PreserveSeatSitState()
		end
		if part.Name == "Handle" and part.Parent:IsA("Tool") and not part.Parent.Parent:FindFirstChildOfClass("Humanoid") then
			if Reanimate.ToolGrab then
				if Player.Character then
					local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
					if Humanoid then
						Humanoid:EquipTool(part.Parent)
					end
				end
			end
		end
	end)
	RCHumanoid.Seated:Connect(function(active)
		if not active then
			if Reanimate.KeepSeatSitState and HasActiveSeatWeld() and not RCHumanoid.Jump then
				task.defer(PreserveSeatSitState)
				return
			end
			DestroySeatWeld()
			LastJumpOffSeat = os.clock()
		end
	end)
	local LastJump = false
	local RCP = RaycastParams.new()
	RCP.RespectCanCollide = true
	RCP.FilterType = Enum.RaycastFilterType.Exclude
	RCP.FilterDescendantsInstances = {RC}
	local noclipStates = {"Running", "Jumping", "Freefall", "Landed", "Climbing", "Swimming"}
	local fallingStates = {"Jumping", "Freefall", "PlatformStanding", "Physics", "Ragdoll", "GettingUp", "Seated", "Flying", "FallingDown"}
	local LastSafest = RCRootPart.CFrame
	local CMove, CJump = Vector3.zero, false
	Util.LinkDestroyI2C(RC, RunService.PreAnimation:Connect(function(dt)
		CMove, CJump = Reanimate.Control.Move, Reanimate.Control.Jump
		local CamCF = Reanimate.Camera:GetMovementCFrame()
		local _,x,_ = CamCF:ToEulerAngles(Enum.RotationOrder.YXZ)
		local MoveCF = CFrame.Angles(0, x, 0)
		pcall(sethiddenproperty, RCRootPart, "PhysicsRepRootPart", nil)
		local scale = Reanimate.CharacterScale
		local previousScale = RC:GetScale()
		if scale ~= previousScale then
			RC:ScaleTo(scale)
			RCHumanoid.HipHeight += 2 * (scale - previousScale)
		end
		local force = Vector3.zero
		local RCHumanoidState = RCHumanoid:GetState().Name
		if RCHumanoidState == "Swimming" then
			force += Vector3.new(0, workspace.Gravity * 0.5, 0) * RCRootPart.AssemblyMass
		end
		local gravaff = not not table.find(fallingStates, RCHumanoidState)
		if gravaff then
			if Reanimate.ScaleGravity and not RCRootPart:IsGrounded() then
				force += Vector3.new(0, -196.84 * (scale), 0) * RCRootPart.AssemblyMass
			end
		end
		if LastJump ~= CJump then
			if CJump then
				if Reanimate.InfiniteJump and RCHumanoid:GetState() == Enum.HumanoidStateType.Freefall and RCHumanoid.JumpPower > 0 then
					RCRootPart.Velocity = Vector3.new(
						RCRootPart.Velocity.X, RCHumanoid.JumpPower, RCRootPart.Velocity.Z
					)
				end
			end
		end
		LastJump = CJump
		local TargetCameraPosition = RCRootPart.CFrame * Vector3.new(0, 1.5 * scale, 0)
		if RCRootJoint.Active then
			TargetCameraPosition = RCTorso.CFrame * Vector3.new(0, 1.5 * scale, 0)
			if RCNeck.Active then
				TargetCameraPosition = RCHead.Position
			end
		end
		local TargetCameraOffset = (RCRootPart.CFrame * CFrame.new(0, 1.5, 0)):PointToObjectSpace(TargetCameraPosition)
		if not Reanimate.SmoothCam then
			TargetCameraOffset = Vector3.new(0, -1.5, 0) + Vector3.new(0, 1.5, 0) * scale
		end
		RCHumanoid.CameraOffset = TargetCameraOffset:Lerp(RCHumanoid.CameraOffset, math.exp(-9.8 * dt))
		local keepingSeatSitState = Reanimate.KeepSeatSitState and HasActiveSeatWeld()
		if keepingSeatSitState then
			RCHumanoid:Move(Vector3.zero)
		elseif RCHumanoidState == "Swimming" then
			RCHumanoid:Move(CamCF:VectorToWorldSpace(CMove))
		else
			RCHumanoid:Move(MoveCF:VectorToWorldSpace(CMove))
		end
		RCHumanoid.Jump = CJump
		if not CJump then
			PreserveSeatSitState()
		end
		BodyForce.Force = force
		if RCRootPart.Position.Y < FallenPartsDestroyHeight + 3 * Reanimate.CharacterScale then
			RCRootPart.CFrame = LastSafest
			RCRootPart.Velocity = Vector3.new(0, 50, 0)
			RCRootPart.RotVelocity = Vector3.zero
		end
	end))
	Util.LinkDestroyI2C(RC, RunService.PreSimulation:Connect(function(dt)
		local RCHumanoidState = RCHumanoid:GetState().Name
		local clip = not table.find(noclipStates, RCHumanoidState)
		for _,v in RC:GetChildren() do
			if v:IsA("BasePart") then
				v.CanCollide = clip or (not Reanimate.Noclip and v == RCRootPart)
			end
		end
	end))
	Util.LinkDestroyI2C(RC, RunService.PostSimulation:Connect(function(dt)
		RCHumanoid.Jump = CJump
		if not CJump then
			PreserveSeatSitState()
		end
		local tcf, pos = RCRootPart.CFrame.Rotation, RCRootPart.CFrame.Position
		local RCHumanoidState = RCHumanoid:GetState().Name
		local safe = true
		local void = true
		for i=1, 8 do
			local off = CFrame.Angles(0, (i / 4) * math.pi, 0):VectorToWorldSpace(Vector3.new(0, 0, -0.5))
			local r = workspace:Raycast(RCRootPart.Position + off, Vector3.new(0, -65536, 0), RCP)
			if r then
				void = false
				if r.Distance > 3 * Reanimate.CharacterScale + 8 + RCHumanoid.HipHeight then
					safe = false
				end
			else
				safe = false
			end
		end
		if safe then
			LastSafest = RCRootPart.CFrame
		end
		if RCHumanoidState == "Climbing" or not void then
			SafeY = pos.Y
			IsFloat = false
		else
			IsFloat = true
		end
		if Reanimate.PatchmaVoidFloat and IsFloat then
			pos = Vector3.new(pos.X, SafeY, pos.Z)
			RCRootPart.Velocity *= Vector3.new(1, 0, 1)
		end
		RCRootPart.CFrame = tcf + pos
		if Reanimate:ShouldRotationType() then
			Reanimate:CameraLockCharacter()
		end
	end))
	Reanimate.Character = RC
	_G_Uhhhhhh.Character = RC
end
Reanimate.DestroyCharacter = function()
	if Reanimate.Character then
		Reanimate.Character = Reanimate.Character:Destroy()
		_G_Uhhhhhh.Character = nil
	end
end

do
	local AntiflingHumanoids = {}
	local AntiflingBaseParts = {}
	local OnStepped = function()
		for i,v in AntiflingBaseParts do
			if v:IsDescendantOf(workspace) then
				if v.CanCollide then v.CanCollide = false end
				v.AssemblyLinearVelocity, v.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
			else
				table.remove(AntiflingBaseParts, i)
			end
		end
		for i,v in AntiflingHumanoids do
			if v:IsDescendantOf(workspace) then
				if v.EvaluateStateMachine then v.EvaluateStateMachine = false end
			else
				table.remove(AntiflingHumanoids, i)
			end
		end
	end
	RunService.PreAnimation:Connect(OnStepped)
	RunService.PreSimulation:Connect(OnStepped)
	RunService.Stepped:Connect(OnStepped)
	local OnBasePart = function(v)
		if v:IsA("BasePart") then
			v.CanCollide = false
			if not table.find(AntiflingBaseParts, v) then
				table.insert(AntiflingBaseParts, v)
			end
		end
		if v:IsA("Humanoid") then
			v.EvaluateStateMachine = false
			if not table.find(AntiflingHumanoids, v) then
				table.insert(AntiflingHumanoids, v)
			end
		end
	end
	local OnCharacter = function(character)
		character.DescendantAdded:Connect(OnBasePart)
		for _,v in character:GetDescendants() do
			OnBasePart(v)
		end
	end
	local OnPlayer = function(player)
		if player == Player then return end
		player.CharacterAdded:Connect(OnCharacter)
		if player.Character then OnCharacter(player.Character) end
	end
	Players.PlayerAdded:Connect(OnPlayer)
	for _,player in Players:GetPlayers() do
		OnPlayer(player)
	end
end

local HumanoidLASetHookState
if ismissing(hookmetamethod) or ismissing(hookfunction) then
	HumanoidLASetHookState = function(hooked) end
else
	local LoadAnimation_old = nil
	local function LoadAnimation_new(animation)
		local char = Instance.new("Model")
		char.Parent = workspace
		local hum = Instance.new("Humanoid")
		hum.Parent = char
		local anim = LoadAnimation_old(hum, animation)
		hum.Parent = nil
		char:Destroy()
		--warn("LoadAnimation prevented!")
		return anim
	end
	local LoadAnimation_nc = nil
	local _HumanoidDummy = Instance.new("Humanoid")
	local _HumanoidLA = _HumanoidDummy.LoadAnimation
	local newloadanimation = newcclosure(function(self, animation)
		if not checkcaller() and typeof(self) == "Instance" and (self:IsA("Humanoid") or self:IsA("Animator")) and typeof(animation) == "Instance" and animation:IsA("Animation") then
			return LoadAnimation_new(animation)
		end
		return LoadAnimation_old(self, animation)
	end)
	local newnamecall = newcclosure(function(...)
		local method = getnamecallmethod()
		if not checkcaller() and method and (method == "LoadAnimation" or method == "loadAnimation") then
			local self, animation = ...
			if typeof(self) == "Instance" and (self:IsA("Humanoid") or self:IsA("Animator")) and typeof(animation) == "Instance" and animation:IsA("Animation") then
				return LoadAnimation_new(animation)
			end
		end
		return LoadAnimation_nc(...)
	end)
	HumanoidLASetHookState = function(hooked)
		if hooked then
			if not LoadAnimation_old then
				LoadAnimation_old = hookfunction(_HumanoidLA, clonefunction(newloadanimation))
			end
			if not LoadAnimation_nc then
				LoadAnimation_nc = hookmetamethod(_HumanoidDummy, "__namecall", clonefunction(newnamecall))
			end
		else
			if LoadAnimation_old then
				hookfunction(_HumanoidLA, LoadAnimation_old)
				LoadAnimation_old = nil
			end
			if LoadAnimation_nc then
				hookmetamethod(_HumanoidDummy, "__namecall", LoadAnimation_nc)
				LoadAnimation_nc = nil
			end
		end
	end
end
Util.IsCharacterJoint = function(joint)
	return typeof(joint) == "Instance"
		and (joint:IsA("Motor6D") or joint.ClassName == "AnimationConstraint")
end
Util.GetCharacterJointParts = function(joint)
	local success, part0, part1 = pcall(function()
		return joint.Part0, joint.Part1
	end)
	if success then
		return part0, part1
	end
	return nil, nil
end
Util.GetCharacterJointFrames = function(joint)
	local success, c0, c1 = pcall(function()
		return joint.C0, joint.C1
	end)
	if success and typeof(c0) == "CFrame" and typeof(c1) == "CFrame" then
		return c0, c1
	end
	return nil, nil
end
Util.CharacterJointReplicationStats = {
	State = "waiting",
	Source = Util.HiddenPropertySetterSource,
	Path = "original R6 writer",
	LastError = nil,
	Attempts = 0,
	Successes = 0,
	Failures = 0,
}
Util.IsR15CharacterJoint = function(joint)
	if typeof(joint) ~= "Instance" then
		return false
	end
	local character = joint:FindFirstAncestorOfClass("Model")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	return humanoid ~= nil and humanoid.RigType == Enum.HumanoidRigType.R15
end
Util.SetCharacterJointTransform = function(joint, transform, _legacyMotorReplication)
	if not Util.IsCharacterJoint(joint) or typeof(transform) ~= "CFrame" then
		return false
	end
	local applied = false
	if joint:IsA("Motor6D") then
		-- R6 is intentionally frozen to STEVE's original writer. R15 support must
		-- never insert a client-only Transform assignment into the R6 path again.
		-- Only a Motor6D proven to belong to an R15 Humanoid receives Transform;
		-- missing/custom rig metadata takes the conservative original R6 path.
		local r15Path = Util.IsR15CharacterJoint(joint)
		if r15Path then
			applied = pcall(function()
				joint.Transform = transform
			end)
		end
		local desiredApplied = pcall(function()
			joint.MaxVelocity = 9e9
			local _, _, desiredAngle = transform:ToEulerAngles(Enum.RotationOrder.ZYX)
			joint:SetDesiredAngle(desiredAngle)
		end)
		applied = applied or desiredApplied
		local axis, angle = transform:ToAxisAngle()
		local offsetSuccess, offsetResult =
			Util.TrySetHiddenProperty(joint, "ReplicateCurrentOffset6D", transform.Position)
		local angleSuccess, angleResult =
			Util.TrySetHiddenProperty(joint, "ReplicateCurrentAngle6D", axis * angle)
		local stats = Util.CharacterJointReplicationStats
		stats.Path = r15Path and "R15 Transform + hidden writes" or "original R6 writer"
		stats.Attempts += 1
		if offsetSuccess and angleSuccess then
			stats.State = "accepted"
			stats.Source = angleResult or offsetResult or stats.Source
			stats.LastError = nil
			stats.Successes += 1
		else
			stats.State = "failed"
			stats.LastError = tostring(not offsetSuccess and offsetResult or angleResult)
			stats.Failures += 1
		end
	else
		applied = pcall(function()
			joint.Transform = transform
			joint.IsKinematic = true
		end)
	end
	return applied
end
Util.SetCharacterJointOffset = function(joint, offset, legacyMotorReplication)
	local c0, c1 = Util.GetCharacterJointFrames(joint)
	if not c0 or not c1 then
		return false
	end
	return Util.SetCharacterJointTransform(joint, c0:Inverse() * offset * c1, legacyMotorReplication)
end
-- Backward-compatible aliases for community modules written before R15's
-- AnimationConstraint-based Avatar Joint Upgrade.
Util.SetMotor6DTransform = Util.SetCharacterJointTransform
Util.SetMotor6DOffset = Util.SetCharacterJointOffset

Util.ShowPartHitbox = function(part, color, lifetime)
	local w = Instance.new("WireframeHandleAdornment")
	w.Name = "TempWireframe"
	w.Adornee = part
	w.Color3 = color or Color3.new(0, 1, 0)
	w.Transparency = 0
	w.ZIndex = 10
	w.AlwaysOnTop = true
	w.Thickness = 1
	w.Parent = SCREENGUI
	local hs = part.Size / 2
	local verts = {
		Vector3.new(-hs.X, -hs.Y, -hs.Z),
		Vector3.new( hs.X, -hs.Y, -hs.Z),
		Vector3.new( hs.X,  hs.Y, -hs.Z),
		Vector3.new(-hs.X,  hs.Y, -hs.Z),
		Vector3.new(-hs.X, -hs.Y,  hs.Z),
		Vector3.new( hs.X, -hs.Y,  hs.Z),
		Vector3.new( hs.X,  hs.Y,  hs.Z),
		Vector3.new(-hs.X,  hs.Y,  hs.Z),
	}
	w:AddLine(verts[1], verts[2])
	w:AddLine(verts[2], verts[3])
	w:AddLine(verts[3], verts[4])
	w:AddLine(verts[4], verts[1])
	w:AddLine(verts[5], verts[6])
	w:AddLine(verts[6], verts[7])
	w:AddLine(verts[7], verts[8])
	w:AddLine(verts[8], verts[5])
	w:AddLine(verts[1], verts[5])
	w:AddLine(verts[2], verts[6])
	w:AddLine(verts[3], verts[7])
	w:AddLine(verts[4], verts[8])
	if lifetime == nil then
		lifetime = 1
	end
	if lifetime > 0 then
		Debris:AddItem(w, lifetime)
	end
	return w
end

local RIGHTGRIP_C0 = CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
Util.PredictionFling = function(target)
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			target = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
		end
		if target and target:IsA("BasePart") then
			if not target:IsDescendantOf(workspace) then
				return CFrame.identity, true
			end
			local t = os.clock()
			local t2 = math.sin(t * 15) + 1
			local cf = target.CFrame * CFrame.Angles(1.57, 0, 0)
			if not Reanimate.UsePhysicsRepRootPart then
				cf += target.AssemblyLinearVelocity * t2 + Vector3.new(0, -workspace.Gravity * 0.5 * t2 * t2 + math.sin(t * 60), 0)
				if cf.Position.Y < target.Position.Y - 1 then
					cf = cf.Rotation + Vector3.new(cf.Position.X, target.Position.Y - 1, cf.Position.Z)
				end
			end
			--cf += Vector3.new(0, -0.5, 0)
			local oldpos = target:GetAttribute("_Uhhhhhh_LastPosition")
			if not oldpos then
				oldpos = target.Position
				target:SetAttribute("_Uhhhhhh_LastPosition", oldpos)
			end
			if (target.Position - oldpos).Magnitude > 200 then
				target:SetAttribute("_Uhhhhhh_LastPosition", nil)
				return cf, true
			end
			return cf, false
		end
	end
	if typeof(target) == "CFrame" then
		return target, false
	end
	if typeof(target) == "Vector3" then
		return CFrame.new(target), false
	end
	return CFrame.identity, true
end
Util.PredictionFlingPart = function(target)
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			target = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
		end
		if target and target:IsA("BasePart") then
			return target
		end
	end
end

SaveData.Reanimator = SaveData.Reanimator or {}
SaveData.Reanimator.LimbDeadRigBridge = nil

local LimbReanimator = {}
LimbReanimator.Name = "Limbs"
SaveData.Reanimator.LimbMode = SaveData.Reanimator.LimbMode or 0
SaveData.Reanimator.LimbVelocity = SaveData.Reanimator.LimbVelocity or 0
SaveData.Reanimator.LimbInitMode = SaveData.Reanimator.LimbInitMode or 2
SaveData.Reanimator.LimbReplicateFPS10 = not not SaveData.Reanimator.LimbReplicateFPS10
-- Remove the retired toggle from existing saves. Older builds treat a missing
-- value as enabled, so rolling back still selects their compatible default.
SaveData.Reanimator.LimbLegacyMotorReplication = nil
SaveData.Reanimator.LimbRoleplay = not not SaveData.Reanimator.LimbRoleplay
SaveData.Reanimator.LimbUseNaNFling = not not SaveData.Reanimator.LimbUseNaNFling
if SaveData.Reanimator.LimbTargetMethod == nil then
	if SaveData.Reanimator.LimbUseCustomKill == true or SaveData.Reanimator.LimbUseCustomKill == 1 then
		SaveData.Reanimator.LimbTargetMethod = 3
	elseif SaveData.Reanimator.LimbUseToolKill == true or SaveData.Reanimator.LimbUseToolKill == 1 then
		SaveData.Reanimator.LimbTargetMethod = 2
	else
		SaveData.Reanimator.LimbTargetMethod = 1
	end
end
SaveData.Reanimator.LimbTargetMethod = math.clamp(math.floor(tonumber(SaveData.Reanimator.LimbTargetMethod) or 1),1,3)
SaveData.Reanimator.LimbFlingVelocityMagnitude = math.clamp(math.floor(tonumber(SaveData.Reanimator.LimbFlingVelocityMagnitude) or 10000),1,1000000000)
SaveData.Reanimator.LimbFlingVelocityDirection = math.clamp(math.floor(tonumber(SaveData.Reanimator.LimbFlingVelocityDirection) or 1),1,4)
LimbReanimator.Mode = SaveData.Reanimator.LimbMode
-- 0 = hide rootpart (defaults to 2 when streaming is enabled)
-- 1 = put rootpart just under void (defaults to 2 when streaming is enabled)
-- 2 = keep rootpart streamed, puts rootpart below character
-- 3 = currentangle styled
-- 4 = rootpart is torso (most interpolated mode)
LimbReanimator.Velocity = SaveData.Reanimator.LimbVelocity
-- 0 = no velocity
-- 1 = copy from fake character
-- 2 = fling-y velocity
LimbReanimator.InitMode = SaveData.Reanimator.LimbInitMode
-- 0 = just reset
-- 1 = time permadeath, and reset
-- 2 = time permadeath, "without reset"
LimbReanimator.ReplicateFPS10 = SaveData.Reanimator.LimbReplicateFPS10
LimbReanimator.FlingEnabled = not SaveData.Reanimator.LimbRoleplay
LimbReanimator.UseNaNFling = SaveData.Reanimator.LimbUseNaNFling
LimbReanimator.TargetMethod = SaveData.Reanimator.LimbTargetMethod
LimbReanimator.FlingVelocityMagnitude = SaveData.Reanimator.LimbFlingVelocityMagnitude
LimbReanimator.FlingVelocityDirection = SaveData.Reanimator.LimbFlingVelocityDirection
LimbReanimator.FlingTargets = {}
LimbReanimator._TempNotFling = {}
LimbReanimator.Status = "Real rig: waiting"
LimbReanimator.JointBackend = "waiting"
-- Public binding state is deliberately separate from Player.Character. Some
-- experiences rebuild a rig in-place or swap Player.Character while the
-- controller character is also being recreated. Consumers such as the
-- persistent hitbox display must follow the rig that this reanimator actually
-- bound, not whichever model happens to be exposed by Player.Character during
-- that frame.
LimbReanimator.ActiveRealCharacter = nil
LimbReanimator.RigGeneration = 0
LimbReanimator.RebindCurrentRig = function() end

function LimbReanimator.ShowHitboxes()
	-- Bound rig centers are rendered by the shared persistent hitbox controller.
end
function LimbReanimator.Fling(target, duration)
	if not LimbReanimator.FlingEnabled then return end
	if not target then return false end
	for _,v in LimbReanimator.FlingTargets do
		if v.Target == target then
			return false
		end
	end
	if target == Reanimate.Character then return false end
	if target == Player.Character then return false end
	if typeof(target) == "Instance" then
		if LimbReanimator._TempNotFling[target] then return end
		LimbReanimator._TempNotFling[target] = true
		task.delay(1, function()
			LimbReanimator._TempNotFling[target] = nil
		end)
	end
	table.insert(LimbReanimator.FlingTargets, {
		Target = target,
		Duration = duration
	})
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			local h = Util.Instance("Highlight")
			h.Adornee = target
			h.FillColor = Color3.new(1, 0, 0)
			h.OutlineColor = Color3.new(1, 0, 0)
			h.FillTransparency = 0.5
			h.OutlineTransparency = 0
			h.Parent = target
			TweenService:Create(h, TweenInfo.new(5), {
				FillTransparency = 1,
				OutlineTransparency = 1
			}):Play()
			game.Debris:AddItem(h, 5)
		end
	end
	return true
end
function LimbReanimator.SetRootPartMode(mode)
	assert(typeof(mode) == "number")
	LimbReanimator.Mode = mode
end
function LimbReanimator.Config(parent)
	UI.CreateText(parent, "as mentioned in the README, this only works for SOME games,\nbecause 'modern' games create the Animator automatically which breaks limb reanimation", 10, Enum.TextXAlignment.Center)
	local dmode = UI.CreateDropdown(parent, "RootPart Mode", {"RootPart in very void", "RootPart in void", "Keep RootPart Streamed", "CurrentAngle Style", "RootPart is Torso"}, LimbReanimator.Mode + 1)
	local dvel = UI.CreateDropdown(parent, "RootPart Velocity", {"No Velocity", "Follow Character", "Fling-like"}, LimbReanimator.Velocity + 1)
	local dinit = UI.CreateDropdown(parent, "Init Mode", {"Reset Character", "CDSB + Reset", "CDSB + SSE + Kill"}, LimbReanimator.InitMode + 1)
	dmode.Changed:Connect(function(val)
		LimbReanimator.Mode = val - 1
		SaveData.Reanimator.LimbMode = val - 1
	end)
	dvel.Changed:Connect(function(val)
		LimbReanimator.Velocity = val - 1
		SaveData.Reanimator.LimbVelocity = val - 1
	end)
	local flingVelocityMagnitude = UI.CreateSlider(parent,"â³ Fling Velocity",LimbReanimator.FlingVelocityMagnitude,1,1000000000,1)
	flingVelocityMagnitude.Changed:Connect(function(val)
		val = math.clamp(math.floor(val), 1, 1000000000)
		flingVelocityMagnitude.Value = val
		LimbReanimator.FlingVelocityMagnitude = val
		SaveData.Reanimator.LimbFlingVelocityMagnitude = val
	end)
	local flingVelocityDirection = UI.CreateDropdown(parent,"â³ Fling Direction",{ "Up", "Down", "Forward", "Backward" },LimbReanimator.FlingVelocityDirection)
	flingVelocityDirection.Changed:Connect(function(val)
		LimbReanimator.FlingVelocityDirection = val
		SaveData.Reanimator.LimbFlingVelocityDirection = val
	end)
	dinit.Changed:Connect(function(val)
		LimbReanimator.InitMode = val - 1
		SaveData.Reanimator.LimbInitMode = val - 1
	end)
	local LimbRigStatusText = UI.CreateText(parent, LimbReanimator.Status, 10, Enum.TextXAlignment.Center)
	Util.LinkDestroyI2C(LimbRigStatusText,RunService.Heartbeat:Connect(function()
		LimbRigStatusText.Text = LimbReanimator.Status
	end))
	UI.CreateButton(parent, "Rebind Current Rig", 16).Activated:Connect(function()
		LimbReanimator.RebindCurrentRig()
	end)
	UI.CreateText(parent,"^^^ use after a server-side R6/R15 switch if the game rebuilt the same Character model in place ^^^",10,Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Show me how I look!", LimbReanimator.ReplicateFPS10).Changed:Connect(function(val)
		LimbReanimator.ReplicateFPS10 = val
		SaveData.Reanimator.LimbReplicateFPS10 = val
	end)
	UI.CreateSwitch(parent, "Target Fling Enabled", LimbReanimator.FlingEnabled).Changed:Connect(function(val)
		LimbReanimator.FlingEnabled = val
		SaveData.Reanimator.LimbRoleplay = not val
	end)
	UI.CreateText(parent, "vvv touch player = they lose ownership vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Use NaN State Fling", LimbReanimator.UseNaNFling).Changed:Connect(function(val)
		LimbReanimator.UseNaNFling = val
		SaveData.Reanimator.LimbUseNaNFling = val
	end)
	UI.CreateDropdown(parent, "Target Method", {"Physics Fling","Tool Touch","Custom Local DamageMethod"}, LimbReanimator.TargetMethod).Changed:Connect(function(val)
		LimbReanimator.TargetMethod = val
		SaveData.Reanimator.LimbTargetMethod = val
	end)
	UI.CreateText(parent,"^^^ NaN can override Roblox states; custom mode executes the reviewed local DamageMethod file ^^^",10,Enum.TextXAlignment.Center)
	Util.LinkDestroyI2C(dmode, RunService.Heartbeat:Connect(function()
		dmode.Value = LimbReanimator.Mode + 1
		dvel.Value = LimbReanimator.Velocity + 1
		dinit.Value = LimbReanimator.InitMode + 1
	end))
end
function LimbReanimator.Start()
	LimbReanimator.ActiveRealCharacter = nil
	LimbReanimator.RigGeneration += 1
	local LimbNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
	local rootposition = Vector3.new(
		math.random(-65536, 65536),
		math.random(-70000, -60000),
		math.random(-65536, 65536)
	)
	local rootposition2 = Vector3.new(
		math.random(-2048, 2048),
		math.random(-500, -100) + FallenPartsDestroyHeight,
		math.random(-2048, 2048)
	)
	local InitCFrame = nil
	if Player.Character then
		local h = Player.Character:FindFirstChildOfClass("Humanoid")
		if h and h.RootPart then
			local r = h.RootPart
			InitCFrame = r.CFrame
			if h:GetState() ~= Enum.HumanoidStateType.Dead then
				h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
				h:ChangeState(Enum.HumanoidStateType.Dead)
			end
		end
	end

	local function GetBundledLimbMapping()
		return {
			-- R6 real rig -> R6 controller rig.
			{ Part0 = "HumanoidRootPart", Part1 = "Torso", Type = 1, RPart0 = "ROOT", RPart1 = "Torso" },
			{ Part0 = "Torso", Part1 = "Head", Type = 1, RPart0 = "Torso", RPart1 = "Head" },
			{ Part0 = "Torso", Part1 = "Left Arm", Type = 1, RPart0 = "Torso", RPart1 = "Left Arm" },
			{ Part0 = "Torso", Part1 = "Right Arm", Type = 1, RPart0 = "Torso", RPart1 = "Right Arm" },
			{ Part0 = "Torso", Part1 = "Left Leg", Type = 1, RPart0 = "Torso", RPart1 = "Left Leg" },
			{ Part0 = "Torso", Part1 = "Right Leg", Type = 1, RPart0 = "Torso", RPart1 = "Right Leg" },
			-- R15 real rig -> R6 controller rig. Unmapped elbow, wrist, waist,
			-- knee, and ankle joints are held at identity by the generic joint path.
			{
				Part0 = "HumanoidRootPart",
				Part1 = "LowerTorso",
				Type = 2,
				RPart0 = "ROOT",
				RPart1 = "Torso",
				C0 = Vector3.zero,
				C1 = Vector3.zero,
			},
			{
				Part0 = "UpperTorso",
				Part1 = "Head",
				Type = 2,
				RPart0 = "Torso",
				RPart1 = "Head",
				C0 = Vector3.new(0, 1, 0),
				C1 = Vector3.new(0, -0.5, 0),
			},
			{
				Part0 = "UpperTorso",
				Part1 = "LeftUpperArm",
				Type = 2,
				RPart0 = "Torso",
				RPart1 = "Left Arm",
				C0 = Vector3.new(-1, 0.5, 0),
				C1 = Vector3.new(0.5, 0.5, 0),
			},
			{
				Part0 = "UpperTorso",
				Part1 = "RightUpperArm",
				Type = 2,
				RPart0 = "Torso",
				RPart1 = "Right Arm",
				C0 = Vector3.new(1, 0.5, 0),
				C1 = Vector3.new(-0.5, 0.5, 0),
			},
			{
				Part0 = "LowerTorso",
				Part1 = "LeftUpperLeg",
				Type = 2,
				RPart0 = "Torso",
				RPart1 = "Left Leg",
				C0 = Vector3.new(-0.5, -1, 0),
				C1 = Vector3.new(0, 1, 0),
			},
			{
				Part0 = "LowerTorso",
				Part1 = "RightUpperLeg",
				Type = 2,
				RPart0 = "Torso",
				RPart1 = "Right Leg",
				C0 = Vector3.new(0.5, -1, 0),
				C1 = Vector3.new(0, 1, 0),
			},
		}
	end
	local LimbMapping = GetBundledLimbMapping()
	local loadedMapping = nil
	local mappingLoaded = pcall(function()
		loadedMapping = loadstring(readfile("BlaaBlaaReanim/BuiltinModules/d_limbmap.lua"))()
	end)
	if mappingLoaded and type(loadedMapping) == "table" then
		LimbMapping = loadedMapping
		for _, fallbackMap in GetBundledLimbMapping() do
			local exists = false
			for _, map in LimbMapping do
				if map.Part0 == fallbackMap.Part0 and map.Part1 == fallbackMap.Part1 then
					exists = true
					break
				end
			end
			if not exists then
				table.insert(LimbMapping, fallbackMap)
			end
		end
	end

	local FakeTools = {}
	local function CreateFakeTool()
		local reanimCharacter = Reanimate.Character
		if not reanimCharacter then
			return nil
		end
		local FakeTool = Instance.new("Tool")
		FakeTool.Name = "faketool"
		local FakeToolHandle = Instance.new("Part")
		FakeToolHandle.Name = "Handle"
		FakeToolHandle.Transparency = 1
		FakeToolHandle.Color = Color3.new(0, 0, 1)
		FakeToolHandle.CanCollide = false
		FakeToolHandle.Massless = true
		FakeToolHandle.Parent = FakeTool
		FakeTool.Parent = reanimCharacter
		local RightGrip = Instance.new("Weld")
		RightGrip.Name = "RightGrip"
		RightGrip.Parent = FakeToolHandle
		RightGrip.Part0 = reanimCharacter:FindFirstChild("Right Arm")
		RightGrip.Part1 = FakeToolHandle
		RightGrip.C0 = RIGHTGRIP_C0
		Util.LinkDestroyI2C(FakeTool, FakeTool:GetPropertyChangedSignal("Grip"):Connect(function()
			RightGrip.C1 = FakeTool.Grip
		end))
		RightGrip.C1 = FakeTool.Grip
		return FakeTool
	end

	local BaseParts = {}
	local UnknownCharacterJoints = {}
	local LimbAccessoryBindings = setmetatable({}, { __mode = "k" })
	local ActiveRealCharacter = nil
	local ActiveDescendantConnection = nil
	local function TrackLimbAccessoryWeld(weld, character)
		if character ~= ActiveRealCharacter or not weld:IsDescendantOf(character) then
			return
		end
		local handle = weld.Parent
		if not handle or not handle:IsA("BasePart") then
			return
		end
		local part0, part1 = weld.Part0, weld.Part1
		local anchor = part0 == handle and part1 or (part1 == handle and part0 or nil)
		if not anchor or not anchor:IsA("BasePart") then
			return
		end
		LimbAccessoryBindings[handle] = {
			Handle = handle,
			Weld = weld,
			AnchorName = anchor.Name,
			C0 = weld.C0,
			C1 = weld.C1,
			HandleIsPart0 = part0 == handle,
			Detached = false,
		}
	end
	local CharOnDesc = function(v, character)
		if character ~= ActiveRealCharacter or not v:IsDescendantOf(character) then
			return
		end

		if v:IsA("BasePart") then
			if not table.find(BaseParts, v) then
				table.insert(BaseParts, v)
				v.CanCollide = false
				v:GetPropertyChangedSignal("CanCollide"):Connect(function()
					if v.CanCollide then v.CanCollide = false end
				end)
			end
		elseif v:IsA("Weld") and v.Name == "AccessoryWeld" then
			TrackLimbAccessoryWeld(v, character)
		elseif Util.IsCharacterJoint(v) then
			local part0, part1 = Util.GetCharacterJointParts(v)
			local deadline = os.clock() + 5
			repeat
				task.wait()
				part0, part1 = Util.GetCharacterJointParts(v)
			until character ~= ActiveRealCharacter
				or not v:IsDescendantOf(character)
				or (part0 and part1)
				or os.clock() >= deadline
			if character ~= ActiveRealCharacter or not v:IsDescendantOf(character) then
				return
			end
			if part0 and part1 then
				local p0, p1 = part0.Name, part1.Name
				for _, map in LimbMapping do
					if map.Part0 == p0 and map.Part1 == p1 then
						if v:IsA("Motor6D") then
							map.MotorReference = v
						else
							map.ConstraintReference = v
						end
						-- Keep the modern constraint for local R15 evaluation, but retain
						-- the matching Motor6D as a second routed replication channel.
						map.Reference = map.ConstraintReference or map.MotorReference
						return
					end
				end
			end
			if not table.find(UnknownCharacterJoints, v) then
				table.insert(UnknownCharacterJoints, v)
			end
		elseif v:IsA("Animator") then
			task.defer(v.Destroy, v)
		elseif v:IsA("LocalScript") and v.Parent == character then
			v.Enabled = false
			v:GetPropertyChangedSignal("Enabled"):Connect(function()
				if v.Enabled then v.Enabled = false end
			end)
			v:GetPropertyChangedSignal("Disabled"):Connect(function()
				if not v.Disabled then v.Disabled = true end
			end)
		elseif v:IsA("Tool") and v.Parent == Player.Character then
			if not FakeTools[v] then
				local fake = CreateFakeTool()
				if not fake then
					return
				end
				FakeTools[v] = true
				fake.Grip = v.Grip
				local h = v:FindFirstChild("Handle")
				if h ~= nil then
					fake.Handle.Size = h.Size
				end
				Util.LinkDestroyI2C(fake, RunService.PreSimulation:Connect(function()
					if character == ActiveRealCharacter and v.Parent == character then
						fake.Grip = v.Grip
						local h = v:FindFirstChild("Handle")
						if h ~= nil then
							fake.Handle.Size = h.Size
						end
					else
						fake:Destroy()
						FakeTools[v] = nil
					end
				end))
				Util.LinkDestroyI2C(fake, v.ChildAdded:Connect(function(v)
					if v.ClassName == "StringValue" and v.Name == "toolanim" then
						local w = Instance.new("StringValue")
						w.Name = "toolanim"
						w.Value = v.Value
						w.Parent = fake
						Debris:AddItem(v, 1)
						Debris:AddItem(w, 1)
					end
				end))
				fake.Handle.Touched:Connect(function(t)
					local h = v:FindFirstChild("Handle")
					if h and t and h:IsDescendantOf(workspace) and t:IsDescendantOf(workspace) then
						h.CanTouch = true
						pcall(firetouchinterest, h, t, 0)
					end
				end)
				fake.Handle.TouchEnded:Connect(function(t)
					local h = v:FindFirstChild("Handle")
					if h and t and h:IsDescendantOf(workspace) and t:IsDescendantOf(workspace) then
						h.CanTouch = true
						pcall(firetouchinterest, h, t, 1)
					end
				end)
			end
		end
	end
	local lastspawn = 0
	local function BindRealCharacter(character)
		if not character or not character:IsA("Model") or character == Reanimate.Character then
			return false
		end
		local camcfr = Camera.CFrame
		RunService.PreRender:Once(function()
			RunService.PreAnimation:Wait()
			if Camera then
				Camera.CFrame = camcfr
			end
		end)
		lastspawn = os.clock()
		ActiveRealCharacter = character
		LimbReanimator.ActiveRealCharacter = character
		LimbReanimator.RigGeneration += 1
		if ActiveDescendantConnection then
			ActiveDescendantConnection:Disconnect()
			ActiveDescendantConnection = nil
		end
		table.clear(BaseParts)
		table.clear(UnknownCharacterJoints)
		table.clear(LimbAccessoryBindings)
		for _, map in LimbMapping do
			map.Reference = nil
			map.MotorReference = nil
			map.ConstraintReference = nil
			map.CFrame = nil
		end
		ActiveDescendantConnection = character.DescendantAdded:Connect(function(v)
			task.spawn(CharOnDesc, v, character)
		end)
		for _, v in character:GetDescendants() do
			task.spawn(CharOnDesc, v, character)
		end
		task.spawn(function()
			local humanoid = character:WaitForChild("Humanoid", 5)
			if character ~= ActiveRealCharacter or not humanoid or not humanoid:IsA("Humanoid") then
				return
			end
			local animator = humanoid:FindFirstChildWhichIsA("Animator")
			if animator then
				animator:Destroy()
			end
			if not Reanimate.UseLoadAnimationHook then
				local animate = character:FindFirstChild("Animate")
				if animate then
					animate:Destroy()
				end
			end
		end)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local rigName = humanoid and humanoid.RigType.Name or "loading"
		LimbReanimator.Status = "Real rig: " .. rigName .. " / binding joints"
		return true
	end
	LimbReanimator.RebindCurrentRig = function()
		local character = Player.Character
		if not character or character == Reanimate.Character then
			character = ActiveRealCharacter
		end
		if BindRealCharacter(character) then
			Util.UINotify("Rebinding " .. (character and character.Name or "real rig") .. "...")
		else
			Util.UINotify("No real character is available to rebind.")
		end
	end
	local InitialRealCharacter = Player.Character
	local CharConn = Player.CharacterAdded:Connect(BindRealCharacter)
	if InitialRealCharacter then
		BindRealCharacter(InitialRealCharacter)
	end
	local deadline = os.clock() + math.max(Players.RespawnTime + 5, 8)
	repeat
		task.wait()
	until Reanimate.Stopping or Player.Character ~= InitialRealCharacter or os.clock() >= deadline
	Reanimate.CreateCharacter(InitCFrame)
	if ActiveRealCharacter then
		-- The first bind can happen before the controller rig exists. Repeat once
		-- so equipped tools and every late-created joint see the finished target.
		BindRealCharacter(ActiveRealCharacter)
	end

	local function ResolveLimbBodyTargetCFrame(partName, normalCFrame, physicalPart, accessory)
		local resolver = Reanimate.ResolveBodyHideTargetCFrame
		if type(resolver) == "function" then
			local success, result = pcall(resolver, physicalPart, normalCFrame, partName, accessory)
			if success and typeof(result) == "CFrame" then
				return result
			end
		end
		return normalCFrame
	end

	local function GetLimbControllerPart(reanimCharacter, partName)
		local canonical = partName
		local canonicalResolver = Reanimate.GetBodyHideCanonicalName
		if type(canonicalResolver) == "function" then
			local success, result = pcall(canonicalResolver, partName)
			if success and type(result) == "string" then
				canonical = result
			end
		end
		return reanimCharacter:FindFirstChild(canonical)
	end

	local function GetLimbAccessoryNormalTarget(binding, reanimCharacter)
		local handle = binding.Handle
		local controllerAnchor = GetLimbControllerPart(reanimCharacter, binding.AnchorName)
		if not handle or not controllerAnchor or not controllerAnchor:IsA("BasePart") then
			return nil, nil
		end
		for _, child in handle:GetChildren() do
			if child:IsA("Attachment") then
				local targetAttachment = controllerAnchor:FindFirstChild(child.Name)
				if targetAttachment and targetAttachment:IsA("Attachment") then
					return targetAttachment.WorldCFrame * child.CFrame:Inverse(), controllerAnchor
				end
			end
		end
		if binding.HandleIsPart0 then
			return controllerAnchor.CFrame * binding.C1 * binding.C0:Inverse(), controllerAnchor
		end
		return controllerAnchor.CFrame * binding.C0 * binding.C1:Inverse(), controllerAnchor
	end

	local function UpdateLimbAccessories(reanimCharacter)
		local hiddenResolver = Reanimate.ShouldBodyHidePart
		for handle, binding in pairs(LimbAccessoryBindings) do
			if not handle.Parent then
				LimbAccessoryBindings[handle] = nil
				continue
			end
			local anchorHidden = false
			if type(hiddenResolver) == "function" then
				local success, result = pcall(hiddenResolver, binding.AnchorName)
				anchorHidden = success and result == true
			end
			local weld = binding.Weld
			if weld and not weld.Parent then
				binding.Weld = nil
				binding.Detached = true
			elseif anchorHidden and weld then
				binding.C0, binding.C1 = weld.C0, weld.C1
				binding.Detached = true
				binding.Weld = nil
				weld:Destroy()
			end
			if binding.Detached then
				local normalCFrame, controllerAnchor = GetLimbAccessoryNormalTarget(binding, reanimCharacter)
				if normalCFrame and controllerAnchor then
					local targetCFrame = ResolveLimbBodyTargetCFrame(
						binding.AnchorName,
						normalCFrame,
						handle,
						true
					)
					handle.CFrame = targetCFrame
					handle.Velocity = controllerAnchor.Velocity
					handle.RotVelocity = controllerAnchor.RotVelocity
				end
			end
		end
	end

	local lastrep = 0
	local function UpdateTransforms(ReanimCharacter, RootPart, rootcf, rootvel, flingtarget, flingcf)
		if not RootPart:IsGrounded() then
			if flingtarget then
				if LimbReanimator.TargetMethod == 3 then
					RunDamageMethod(ReanimCharacter, RootPart, rootcf, rootvel, flingtarget, flingcf, "LIMB")
					pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", nil)
				elseif LimbReanimator.TargetMethod == 2 then
					ToolTouchTarget(RootPart, flingtarget)
					pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", nil)
				else
					if LimbReanimator.UseNaNFling then
						RootPart.CFrame = CFrame.new(flingcf.Position + Vector3.new(0, 0, math.random(0, 1) * 0.005))
							* CFrame.Angles(0, os.clock() * 15, 0)
						RootPart.Velocity, RootPart.RotVelocity = Vector3.zero, Vector3.zero
					else
						RootPart.CFrame = flingcf + Vector3.new(0, 0, math.random(0, 1) * 0.005)
						RootPart.Velocity, RootPart.RotVelocity = Vector3.new(0, -16384, 0), Vector3.one * 16384
					end
					pcall(sethiddenproperty,RootPart,"PhysicsRepRootPart",Reanimate.UsePhysicsRepRootPart and Util.PredictionFlingPart(flingtarget.Target) or nil)
				end
			else
				RootPart.CFrame = rootcf + Vector3.new(0, 0, math.random(0, 1) * 0.005)
				RootPart.Velocity, RootPart.RotVelocity = rootvel, Vector3.zero
				pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", nil)
			end
		end
		local dorep = true
		if LimbReanimator.ReplicateFPS10 then
			dorep = false
			local b = os.clock()
			local a = b - lastrep
			if a >= 1 / 10 then
				dorep = true
				a %= 1 / 10
				lastrep = b - a
			end
		end
		for _, v in UnknownCharacterJoints do
			if v.Parent then
				Util.SetCharacterJointTransform(v, CFrame.identity)
			end
		end
		for _, map in LimbMapping do
			local constraint = map.ConstraintReference
			if constraint and not constraint.Parent then
				constraint = nil
			end
			local motor = map.MotorReference
			if motor and not motor.Parent then
				motor = nil
			end
			local v = constraint or motor or map.Reference
			if v and not v.Parent then
				v = nil
			end
			map.Reference = v
			if v and v.Parent then
				if flingtarget then
					Util.SetCharacterJointTransform(v, CFrame.identity)
					if motor and motor ~= v then
						Util.SetCharacterJointTransform(motor, CFrame.identity)
					end
				else
					local cf = CFrame.identity
					local p0, p1 =
						ReanimCharacter:FindFirstChild(map.RPart0), ReanimCharacter:FindFirstChild(map.RPart1)
					if map.RPart0 == "ROOT" then
						p0 = RootPart
					end
					if p0 and p1 then
						local p0CFrame = p0.CFrame
						local p1CFrame = p1.CFrame
						if map.RPart0 ~= "ROOT" then
							p0CFrame = ResolveLimbBodyTargetCFrame(map.Part0, p0CFrame, nil, false)
						end
						p1CFrame = ResolveLimbBodyTargetCFrame(map.Part1, p1CFrame, nil, false)
						if map.Type == 1 then
							cf = p0CFrame:ToObjectSpace(p1CFrame)
						end
						if map.Type == 2 then
							local offset = map.Offset or CFrame.identity
							local c0, c1 = CFrame.new(map.C0), CFrame.new(map.C1)
							local transform = offset
								* (p0CFrame * c0):ToObjectSpace(p1CFrame * c1)
								* offset:Inverse()
							local jointC0, jointC1 = Util.GetCharacterJointFrames(v)
							if jointC0 and jointC1 then
								cf = jointC0 * transform * jointC1:Inverse()
							end
						end
					end
					if dorep or not map.CFrame then
						map.CFrame = cf
					end
					Util.SetCharacterJointOffset(v, map.CFrame)
					if motor and motor ~= v then
						Util.SetCharacterJointOffset(motor, map.CFrame)
					end
				end
			end
		end
		UpdateLimbAccessories(ReanimCharacter)
	end

	Reanimate.Starting = false
	while not Reanimate.Stopping do
		RunService.PreSimulation:Wait()
		workspace.FallenPartsDestroyHeight = 0/0
		local ReanimOkay = false
		local Character, Humanoid, RootPart = Player.Character, nil, nil
		if Character == Reanimate.Character then
			Character = ActiveRealCharacter
		end
		if Character and Character ~= ActiveRealCharacter then
			BindRealCharacter(Character)
		end
		local IsDeadRealCharacter = false
		local mappedJointCount = 0
		local requiredJointCount = 6
		local motorJointCount = 0
		local constraintJointCount = 0
		if Character then
			Humanoid = Character:FindFirstChildOfClass("Humanoid")
			if Humanoid then
				Humanoid.AutoRotate = false
				if Humanoid.WalkSpeed < 1 then
					Humanoid.WalkSpeed = 16
				end
				if Humanoid.JumpPower < 1 then
					Humanoid.JumpPower = 50
				end
				RootPart = Humanoid.RootPart or Character:FindFirstChild("HumanoidRootPart")
				for _, map in LimbMapping do
					local motor = map.MotorReference
					local constraint = map.ConstraintReference
					local joint = (constraint and constraint.Parent and constraint) or (motor and motor.Parent and motor) or map.Reference
					if joint and joint.Parent and joint:IsDescendantOf(Character) then
						mappedJointCount += 1
						if motor and motor.Parent and motor:IsDescendantOf(Character) then
							motorJointCount += 1
						end
						if constraint and constraint.Parent and constraint:IsDescendantOf(Character) then
							constraintJointCount += 1
						end
						if not motor and not constraint then
							if joint:IsA("Motor6D") then
								motorJointCount += 1
							else
								constraintJointCount += 1
							end
						end
					end
				end
				IsDeadRealCharacter = Humanoid:GetState() == Enum.HumanoidStateType.Dead or Humanoid.Health <= 0
				if RootPart and mappedJointCount >= requiredJointCount and not IsDeadRealCharacter then
					Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
					ReanimOkay = LimbReanimator.FlingTargets[1] == nil
				end
			end
		end
		local rigName = Humanoid and Humanoid.RigType.Name or "none"
		local jointBackend = "no mapped joints"
		if motorJointCount > 0 and constraintJointCount > 0 then
			jointBackend = "mixed joints"
		elseif constraintJointCount > 0 then
			jointBackend = "AnimationConstraint"
		elseif motorJointCount > 0 then
			jointBackend = "Motor6D"
		end
		LimbReanimator.JointBackend = jointBackend
		local lifeState = IsDeadRealCharacter and "dead; unsupported" or "alive"
		LimbReanimator.Status = "Real rig: "
			.. rigName
			.. " / "
			.. jointBackend
			.. " / "
			.. lifeState
			.. " ("
			.. mappedJointCount
			.. "/"
			.. requiredJointCount
			.. " mapped)"

		local rootcf = CFrame.new(rootposition)
		local rootvel = Vector3.zero
		local ltm = Reanimate.LocalTransparencyModifier
		local ReanimCharacter = Reanimate.Character
		if ReanimCharacter then
			local RCHumanoid = ReanimCharacter:FindFirstChildOfClass("Humanoid")
			local RCRootPart = ReanimCharacter:FindFirstChild("HumanoidRootPart")
			local RCTorso = ReanimCharacter:FindFirstChild("Torso") or ReanimCharacter:FindFirstChild("UpperTorso")
			if Camera then
				Camera.CameraSubject = RCHumanoid
			end
			for _,v in BaseParts do
				if not v.Parent then
					continue
				end
				v.CanCollide = false
				v.Velocity = Vector3.zero
				v.RotVelocity = Vector3.zero
				if not v:FindFirstAncestorWhichIsA("Tool") then
					local lltm = ltm
					if Reanimate.FirstPersonBody then
						lltm = 0
						if v.Name == "Head" then
							lltm = ltm
						else
							local lol = v:FindFirstChild("AccessoryWeld")
							if lol and lol:IsA("Weld") and lol.Part1 and lol.Part1.Name == "Head" then
								lltm = ltm
							end
						end
					end
					v.LocalTransparencyModifier = lltm
				end
			end
			for _,v in ReanimCharacter:GetChildren() do
				if v:IsA("BasePart") then
					if table.find(LimbNames, v.Name) then
						-- The original script shows this red fake rig before the new real
						-- character is detected: ReanimOkay remains false while Character,
						-- Humanoid, RootPart, or a live humanoid state is unavailable.
						if ReanimOkay then
							v.Transparency = 1
						else
							local transparency = Reanimate.PlaceholderTransparency
							if Reanimate.ShowResetPlaceholder then
								transparency = math.min(transparency, 0.5)
							end
							v.Transparency = transparency
						end
					end
				end
			end
			local flingtarget = nil
			local flingcf = CFrame.identity
			if Character and Humanoid and RootPart and mappedJointCount > 0 and not IsDeadRealCharacter then
				RunService.Heartbeat:Wait()
				local t = os.clock()
				if RCRootPart and RCTorso then
					if LimbReanimator.Mode == 1 then
						rootcf = CFrame.new(rootposition2)
					end
					if LimbReanimator.Mode == 2 or workspace.StreamingEnabled then
						rootcf = CFrame.new(RCRootPart.Position + Vector3.new(0, -16, 0))
					end
					if LimbReanimator.Mode == 3 then
						rootcf = RCRootPart.CFrame
					end
					if LimbReanimator.Mode == 4 then
						rootcf = RCTorso.CFrame
					end
					if LimbReanimator.Velocity == 1 then
						rootvel = RCRootPart.Velocity
					elseif LimbReanimator.Velocity == 2 then
						local direction = Vector3.yAxis
						if LimbReanimator.FlingVelocityDirection == 2 then
							direction = -Vector3.yAxis
						elseif LimbReanimator.FlingVelocityDirection == 3 then
							direction = RCRootPart.CFrame.LookVector
						elseif LimbReanimator.FlingVelocityDirection == 4 then
							direction = -RCRootPart.CFrame.LookVector
						end
						rootvel = direction * LimbReanimator.FlingVelocityMagnitude
					end
				end
				flingtarget = LimbReanimator.FlingTargets[1]
				if flingtarget then
					if flingtarget.Time then
						if t > flingtarget.Time then
							table.remove(LimbReanimator.FlingTargets, 1)
							flingtarget = nil
						end
					else
						flingtarget.Time = t + (flingtarget.Duration or (Reanimate.UsePhysicsRepRootPart and (LimbReanimator.UseNaNFling and 1 or 0.5) or 2))
					end
				end
				local flinged = true
				if flingtarget then
					flingcf, flinged = Util.PredictionFling(flingtarget.Target)
					if flinged then
						table.remove(LimbReanimator.FlingTargets, 1)
						flingtarget = nil
					end
				end
				UpdateTransforms(ReanimCharacter, RootPart, rootcf, rootvel, flingtarget, flingcf)
				if not IsDeadRealCharacter and LimbReanimator.UseNaNFling then
					if os.clock() - lastspawn > 0.1 then
						pcall(sethiddenproperty, Humanoid, "MoveDirectionInternal", Vector3.new(0/0, 0/0, 0/0))
					else
						pcall(sethiddenproperty, Humanoid, "MoveDirectionInternal", Vector3.zero)
					end
					pcall(sethiddenproperty, Humanoid, "NetworkHumanoidState", Enum.HumanoidStateType.Freefall.Value)
				elseif not IsDeadRealCharacter then
					pcall(sethiddenproperty, Humanoid, "NetworkHumanoidState", Enum.HumanoidStateType.Flying.Value)
				end
			end
			RunService.PreRender:Wait()
			if Reanimate:ShouldRotationType() then
				Reanimate:CameraLockCharacter()
			end
			if Character and Humanoid and RootPart and mappedJointCount > 0 and not IsDeadRealCharacter then
				UpdateTransforms(ReanimCharacter, RootPart, rootcf, rootvel, flingtarget, flingcf)
			end
		end
	end
	CharConn:Disconnect()
	if ActiveDescendantConnection then
		ActiveDescendantConnection:Disconnect()
		ActiveDescendantConnection = nil
	end
	LimbReanimator.ActiveRealCharacter = nil
	LimbReanimator.RigGeneration += 1
	LimbReanimator.RebindCurrentRig = function() end
	LimbReanimator.Status = "Real rig: stopped"
	if Player.Character then
		local h = Player.Character:FindFirstChild("Humanoid")
		if h then
			h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			h:ChangeState(Enum.HumanoidStateType.Dead)
		end
	end
	Reanimate.Stopping = false
	Reanimate.DestroyCharacter()
end

local HatReanimator = {}
HatReanimator.Name = "Hats"
SaveData.Reanimator.HatsCollide = not not SaveData.Reanimator.HatsCollide
SaveData.Reanimator.HatsCollideMethod = SaveData.Reanimator.HatsCollideMethod or 6
SaveData.Reanimator.IWantAllHats = not not SaveData.Reanimator.IWantAllHats
SaveData.Reanimator.IWantHatCollide = SaveData.Reanimator.IWantHatCollide or 3
SaveData.Reanimator.HatsPatchmahub = not not SaveData.Reanimator.HatsPatchmahub
SaveData.Reanimator.RespawnPosition = SaveData.Reanimator.RespawnPosition or 0
SaveData.Reanimator.HatsFling = not not SaveData.Reanimator.HatsFling
SaveData.Reanimator.UseCustomKill = SaveData.Reanimator.HatsFling or 0
SaveData.Reanimator.HatsSpin = not not SaveData.Reanimator.HatsSpin
SaveData.Reanimator.HatsFlingMethod = SaveData.Reanimator.HatsFlingMethod or 1
SaveData.Reanimator.NoToolHolding = not not SaveData.Reanimator.NoToolHolding
SaveData.Reanimator.HatsToolAnim = SaveData.Reanimator.HatsToolAnim or 0
SaveData.Reanimator.RagdollPDAssist = SaveData.Reanimator.RagdollPDAssist or false
HatReanimator.HatCollide = SaveData.Reanimator.HatsCollide
HatReanimator.HatCollideMethod = SaveData.Reanimator.HatsCollideMethod
-- 0 - shownape's method
-- 1 - my method
-- 2 - 1 but for back accessories
-- 3 - 1 but for shoulder accessories
-- 4 - pray that it works for all ur accessories lol
-- 5 - least amount of chance to hat drop
-- 6 - experimental
-- 7 - idk honestly but this is just modified heavily for now
HatReanimator.IWantAllHats = SaveData.Reanimator.IWantAllHats
HatReanimator.IWantHatCollide = SaveData.Reanimator.IWantHatCollide
HatReanimator.Permadeath = false--not SaveData.Reanimator.HatsPatchmahub
HatReanimator.RespawnPosition = SaveData.Reanimator.RespawnPosition
-- 0 - hide body
-- 1 - behind character
-- 2 - randomtp close
-- 3 - stay at spawn
HatReanimator.HatFling = SaveData.Reanimator.HatsFling
HatReanimator.UseCustomKill = SaveData.Reanimator.UseCustomKill
HatReanimator.HatSpin = SaveData.Reanimator.HatsSpin
HatReanimator.FlingMethod = SaveData.Reanimator.HatsFlingMethod
-- -1 - disabled
-- 0 - respawn and fling
-- 1 - use biggest collidable hat
-- 2 - use all hats
-- 3 - tool fling
HatReanimator.ToolHolding = not SaveData.Reanimator.NoToolHolding
HatReanimator.ToolAnimMethod = SaveData.Reanimator.HatsToolAnim
-- 0 - nothing
-- 1 - sword
HatReanimator.RagdollPDAssist = SaveData.Reanimator.RagdollPDAssist or false
-- ragdoll games provide a new method of permadeath
HatReanimator.UseNaNFling = true
HatReanimator.HasPermadeath = false
HatReanimator.HasHatCollide = false
HatReanimator.RebuildRequired = true
HatReanimator.StaticRoot = nil
HatReanimator.ActiveRealCharacter = nil
HatReanimator.RigGeneration = 0
HatReanimator.CollidableHandles = setmetatable({}, { __mode = "k" })
HatReanimator.BodyHideTargets = setmetatable({}, { __mode = "k" })
HatReanimator.HatMapSummary = "(no hat map yet, please * Reanimate * to build)"
HatReanimator.HatCFrameOverride = {}
HatReanimator.Status = {
	Permadeath = "(no status)",
	HatCollide = "(no status)",
	RespawnFling = "(no status)",
}
function HatReanimator.ShowHitboxes()
	local seen = {}
	local function showHandle(handle)
		if
			handle
			and handle:IsA("BasePart")
			and handle:IsDescendantOf(workspace)
			and handle:GetAttribute("_Uhhhhhh_HasCollide")
			and not seen[handle]
		then
			seen[handle] = true
			Util.ShowPartHitbox(handle, Color3.fromRGB(80, 255, 110), 0)
		end
	end
	for handle in HatReanimator.CollidableHandles do
		showHandle(handle)
	end
	local character = HatReanimator.ActiveRealCharacter
	if character and character.Parent then
		for _, v in character:GetChildren() do
			if v:IsA("Accessory") then
				showHandle(v:FindFirstChild("Handle"))
			end
		end
	end
end
HatReanimator.FlingTargets = {}
HatReanimator._TempNotFling = {}
function HatReanimator.Fling(target, duration)
	if HatReanimator.FlingMethod == -1 then return end
	if not target then return false end
	for _,v in HatReanimator.FlingTargets do
		if v.Target == target then
			return false
		end
	end
	if target == Reanimate.Character then return false end
	if target == Player.Character then return false end
	if target == HatReanimator.ActiveRealCharacter then return false end
	if typeof(target) == "Instance" then
		if HatReanimator._TempNotFling[target] then return end
		HatReanimator._TempNotFling[target] = true
		task.delay(1, function()
			HatReanimator._TempNotFling[target] = nil
		end)
	end
	table.insert(HatReanimator.FlingTargets, {
		Target = target,
		Duration = duration
	})
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			local h = Util.Instance("Highlight")
			h.Adornee = target
			h.FillColor = Color3.new(1, 0, 0)
			h.OutlineColor = Color3.new(1, 0, 0)
			h.FillTransparency = 0.5
			h.OutlineTransparency = 0
			h.Parent = target
			TweenService:Create(h, TweenInfo.new(5), {
				FillTransparency = 1,
				OutlineTransparency = 1
			}):Play()
			game.Debris:AddItem(h, 5)
		end
	end
	return true
end
HatReanimator.DontFireCharAddOnThisChar = nil
function HatReanimator.Config(parent)
	UI.CreateText(parent, "permadeath is patched, but you can try ragdoll game permadeath", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Permadeath", HatReanimator.Permadeath).Changed:Connect(function(val)
		HatReanimator.Permadeath = val
		SaveData.Reanimator.HatsPatchmahub = not val
	end)
	UI.CreateSwitch(parent, "Ragdoll Game Permadeath", HatReanimator.RagdollPDAssist).Changed:Connect(function(val)
		HatReanimator.RagdollPDAssist = val
		SaveData.Reanimator.RagdollPDAssist = val
	end)
	UI.CreateText(parent, "^^this fixes permadeath and it only works in ragdoll games because of RequiresNeck being off^^", 10, Enum.TextXAlignment.Center)
	UI.CreateDropdown(parent, "respawntp", {
		"The Void",
		"Behind ReanimCharacter",
		"Randomtp near",
		"At spawn",
	}, HatReanimator.RespawnPosition + 1).Changed:Connect(function(val)
		HatReanimator.RespawnPosition = val - 1
		SaveData.Reanimator.RespawnPosition = val - 1
	end)
	UI.CreateSwitch(parent, "Hat Collide", HatReanimator.HatCollide).Changed:Connect(function(val)
		HatReanimator.HatCollide = val
		SaveData.Reanimator.HatsCollide = val
	end)
	UI.CreateText(parent, "if ur hats get voided when u try to hat collide\nvvv try changing this vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateDropdown(parent, "Torso Offset", {
		"1 - ShownApe's method (???)",
		"2 - STEVE's method V1 (specific)",
		"3 - 2 but for back accessories",
		"4 - 2 but for shoulder accessories",
		"5 - 2 but for waist accessories",
		"6 - STEVE's method V2 (kinda stable)",
		"7 - 6 but further from void (gl getting hatdrop)",
		"8 - STEVE's method V3 (most stable)",
		"9 - experimental (might work so try it)",
	}, HatReanimator.HatCollideMethod + 1).Changed:Connect(function(val)
		HatReanimator.HatCollideMethod = val - 1
		SaveData.Reanimator.HatsCollideMethod = val - 1
	end)
	UI.CreateSwitch(parent, "Ensure All Hats", HatReanimator.IWantAllHats).Changed:Connect(function(val)
		HatReanimator.IWantAllHats = val
		SaveData.Reanimator.IWantAllHats = val
	end)
	UI.CreateDropdown(parent, "Ensure Hat Collide", {
		"Off",
		"Atleast one",
		"Atleast #hats - 2",
		"Atleast #hats - 1",
		"ALL",
	}, HatReanimator.IWantHatCollide + 1).Changed:Connect(function(val)
		HatReanimator.IWantHatCollide = val - 1
		SaveData.Reanimator.IWantHatCollide = val - 1
	end)
	UI.CreateText(parent, "vvv dont use these two options with target fling... vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Hat Fling", HatReanimator.HatFling).Changed:Connect(function(val)
		HatReanimator.HatFling = val
		SaveData.Reanimator.HatsFling = val
	end)
	UI.CreateText(parent, "^^^ ...unless you want to walkfling or... ^^^", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Hat Spin Fling", HatReanimator.HatSpin).Changed:Connect(function(val)
		HatReanimator.HatSpin = val
		SaveData.Reanimator.HatsSpin = val
	end)
	UI.CreateText(parent, "^^^ ...unless you want to look glitchy ^^^", 10, Enum.TextXAlignment.Center)
	UI.CreateText(parent, "vvv dont use tool fling with physics glue btw vvv", 10, Enum.TextXAlignment.Center)
	local HatTargetMethods = { -1, 0, 1, 2, 3, 10 }
	UI.CreateDropdown(parent, "Target Fling Method", {
		"Disabled (RP)",
		"Classic Respawn",
		"Biggest Hat",
		"All Hats",
		"Use Tool Handle",
		"Custom Local DamageMethod",
	}, table.find(HatTargetMethods, HatReanimator.FlingMethod) or 1).Changed:Connect(function(val)
		HatReanimator.FlingMethod = HatTargetMethods[val] or -1
		SaveData.Reanimator.HatsFlingMethod = HatReanimator.FlingMethod
	end)
	UI.CreateSwitch(parent, "Tool Holding", HatReanimator.ToolHolding).Changed:Connect(function(val)
		HatReanimator.ToolHolding = val
		SaveData.Reanimator.NoToolHolding = not val
	end)
	UI.CreateDropdown(parent, "toolanim Method", {
		"Disabled",
		"Sword",
	}, HatReanimator.ToolAnimMethod + 1).Changed:Connect(function(val)
		HatReanimator.ToolAnimMethod = val - 1
		SaveData.Reanimator.HatsToolAnim = val - 1
	end)
	UI.CreateSeparator(parent)
	local HatMapSummaryText = UI.CreateText(parent, HatReanimator.HatMapSummary, 12, Enum.TextXAlignment.Left)
	local HatReanimStatusText = UI.CreateText(parent, "", 12, Enum.TextXAlignment.Left)
	Util.LinkDestroyI2C(HatMapSummaryText, RunService.RenderStepped:Connect(function()
		HatMapSummaryText.Text = HatReanimator.HatMapSummary
		local str = ""
		for name, stat in HatReanimator.Status do
			str ..= name .. ": " .. stat .. "\n"
		end
		HatReanimStatusText.Text = str:sub(1, -2)
	end))
	UI.CreateButton(parent, "Rebuild Hat Map", 20).Activated:Connect(function()
		HatReanimator.RebuildRequired = true
	end)
	UI.CreateText(parent, "^^^ if ur rig built wrong or u switched to a new rig ^^^\nthis button is for you", 10, Enum.TextXAlignment.Center)
	UI.CreateText(parent, "vvv if u switch rigs in games like catalog avatar creator then this fixes hats", 10, Enum.TextXAlignment.Center)
	UI.CreateButton(parent, "BreakJoints", 20).Activated:Connect(function()
		Player.Character:BreakJoints()
		pcall(replicatesignal, Player.Character.Humanoid.ServerBreakJoints)
		HatReanimator.RebuildRequired = true
	end)
	UI.CreateButton(parent, "Respawn", 20).Activated:Connect(function()
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
		pcall(replicatesignal, Player.Kill)
		-- steve is taking too long to add this
	end)
end
HatReanimator.GetHatMap = function() end
HatReanimator.GetHatCFrameMeshAndTexture = function() end
HatReanimator.GetAttachmentCFrame = function() end
function HatReanimator.Start()
	local LimbNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

	local Attachments = {
		RightShoulderAttachment = {"Right Arm", CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RightGripAttachment = {"Right Arm", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftFootAttachment = {"Left Leg", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftShoulderAttachment = {"Left Arm", CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftGripAttachment = {"Left Arm", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RootAttachment = {"HumanoidRootPart", CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RightFootAttachment = {"Right Leg", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		NeckAttachment = {"Torso", CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		BodyFrontAttachment = {"Torso", CFrame.new(0, 0, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		BodyBackAttachment = {"Torso", CFrame.new(0, 0, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftCollarAttachment = {"Torso", CFrame.new(-1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RightCollarAttachment = {"Torso", CFrame.new(1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		WaistFrontAttachment = {"Torso", CFrame.new(0, -1, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		WaistCenterAttachment = {"Torso", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		WaistBackAttachment = {"Torso", CFrame.new(0, -1, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		HairAttachment = {"Head", CFrame.new(0, 0.6, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		HatAttachment = {"Head", CFrame.new(0, 0.6, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		FaceFrontAttachment = {"Head", CFrame.new(0, 0, -0.6, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		FaceCenterAttachment = {"Head", CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	}

	local HatMeshDatabase, HatNameDatabase, HatKnownAccessoriesDatabase = loadstring(readfile("BlaaBlaaReanim/BuiltinModules/d_hatsmap.lua"))()

	local function GetTools()
		if character == Reanimate.Character then
			character = HatReanimator.ActiveRealCharacter
		end
		local tools = {}
		local character, backpack = Player.Character, Player:FindFirstChildOfClass("Backpack")
		if character then
			for _,v in character:GetChildren() do
				if v:IsA("Tool") then
					table.insert(tools, v)
				end
			end
		end
		if backpack then
			for _,v in backpack:GetChildren() do
				if v:IsA("Tool") then
					table.insert(tools, v)
				end
			end
		end
		return tools
	end
	local function GetHatMeshAndTexture(hat)
		local handle = hat:FindFirstChild("Handle")
		if handle then
			local mesh, tex = nil, nil
			if handle:IsA("MeshPart") then
				return handle.MeshId, handle.TextureID
			elseif handle:IsA("BasePart") then
				local sm = handle:FindFirstChildOfClass("SpecialMesh")
				if sm then
					return sm.MeshId, sm.TextureId
				end
			end
		end
		return nil, nil
	end
	local function AssetIdMatch(a, b)
		a = a or ""
		b = b or ""
		if #b == 0 then return true end
		if #a == 0 then return false end
		if a:sub(1, 11) == "rbxasset://" then
			a = a:match("rbxasset://(.+)")
		elseif a:sub(1, 13) == "rbxassetid://" then
			a = a:match("rbxassetid://(%d+)")
		elseif a:sub(1, 4) == "http" then
			a = a:match("id=(%d+)")
		end
		return a == b
	end
	local function ClassifyHat(hat)
		local handle = hat:FindFirstChild("Handle")
		local mesh, tex = GetHatMeshAndTexture(hat)
		if handle and handle:IsA("BasePart") and mesh and tex then
			local mapdata = {
				Name = hat.Name,
				MeshId = mesh, TextureId = tex,
				C0 = CFrame.identity,
				C1 = CFrame.identity,
				Scale = 1,
				Limb = "HumanoidRootPart",
				Group = "RIG",
				Attachments = nil,
			}
			local originalsize = handle:FindFirstChild("OriginalSize")
			if originalsize and originalsize:IsA("Vector3Value") then
				originalsize = originalsize.Value
				local m1 = math.max(handle.Size.X, handle.Size.Y, handle.Size.Z)
				local m2 = math.max(originalsize.X, originalsize.Y, originalsize.Z)
				if m2 > 0 then
					mapdata.Scale = m1 / m2
				end
			else
				originalsize = handle.Size
			end
			-- dont map explicitly overriden hats
			for _,data in HatReanimator.HatCFrameOverride do
				if data.MeshId and data.TextureId then
					if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
						return mapdata, "Unknown", 4
					end
				end
			end
			for _,data in HatKnownAccessoriesDatabase do
				if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
					mapdata.C0 = data.C0
					mapdata.C1 = data.C1
					mapdata.Limb = data.Limb
					mapdata.Group = data.Group
					mapdata.Attachments = data.Attachments
					return mapdata, "Accessories", 0
				end
			end
			for _,data in HatNameDatabase do
				if hat.Name:lower() == data.Match:lower() then
					mapdata.C1 = data.Offset
					mapdata.Attachments = data.Attachments
					return mapdata, data.For, 1
				end
			end
			for _,data in HatMeshDatabase do
				if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
					mapdata.C1 = data.Offset
					mapdata.Attachments = data.Attachments
					return mapdata, data.For, 2
				end
			end
			local assumption = originalsize
			local m = math.min(assumption.X, assumption.Y, assumption.Z)
			if m >= 0.25 then
				assumption = Vector3.new(
					math.round(assumption.X / m),
					math.round(assumption.Y / m),
					math.round(assumption.Z / m)
				)
			else
				assumption = Vector3.zero
			end
			if assumption == Vector3.new(2, 2, 1) then
				mapdata.C1 = CFrame.identity
				return mapdata, "Torso", 3
			elseif assumption == Vector3.new(2, 1, 2) then
				mapdata.C1 = CFrame.Angles(1.57, 0, 0)
				return mapdata, "Torso", 3
			elseif assumption == Vector3.new(1, 2, 2) then
				mapdata.C1 = CFrame.Angles(0, 1.57, 0)
				return mapdata, "Torso", 3
			elseif assumption == Vector3.new(1, 2, 1) then
				mapdata.C1 = CFrame.identity
				return mapdata, "ArmLeg", 3
			elseif assumption == Vector3.new(1, 1, 2) then
				mapdata.C1 = CFrame.Angles(1.57, 0, 0)
				return mapdata, "ArmLeg", 3
			elseif assumption == Vector3.new(2, 1, 1) then
				mapdata.C1 = CFrame.Angles(0, 0, 1.57)
				return mapdata, "ArmLeg", 3
			elseif handle:FindFirstChild("HatAttachment") and assumption == Vector3.new(1, 1, 1) and m < 1.2 then
				mapdata.C1 = CFrame.Angles(1.57, 0, 0)
				return mapdata, "Block", 3
			end
			return mapdata, "Unknown", 4
		end
		return nil
	end

	local BaseParts = {}
	local CharTools = {}
	local CharHats = {}

	local HatRefs = {}
	local Hat2HatRefs = {}
	local function ResetHatRefs()
		table.clear(Hat2HatRefs)
		table.clear(HatReanimator.BodyHideTargets)
		for _,ref in HatRefs do
			ref.Hat = nil
			ref.Han = nil
		end
	end
	local function CreatePlaceholder(hat)
		local h = hat:FindFirstChild("Handle")
		if h and h:IsA("BasePart") then
			local p = h:Clone()
			p:BreakJoints()
			p.Anchored = true
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
			p.Transparency = 0.75
			p.Name = "(C) BlaaBlaa V" .. UhhhhhhVersion .. " :: HAT PLACEHOLDER"
			for _,v in p:GetDescendants() do
				if v:IsA("LuaSourceContainer") then
					v:Destroy()
					continue
				end
				local exist = pcall(function()
					return v.LocalTransparencyModifier
				end)
				if exist then
					p:GetPropertyChangedSignal("Transparency"):Connect(function()
						v.LocalTransparencyModifier = p.Transparency
					end)
				end
			end
			if h:GetAttribute("AttachHead") then
				p:SetAttribute("AttachHead", true)
			end
			p.Parent = workspace
			return p
		end
	end
	local function RefHatToHatRefs(hat)
		local handle = hat:FindFirstChild("Handle")
		local mesh, tex = GetHatMeshAndTexture(hat)
		if handle and mesh and tex then
			for _,ref in HatRefs do
				if not ref.Hat then
					if ref.Name == hat.Name and ref.MeshId == mesh and ref.TextureId == tex then
						ref.Hat = hat
						ref.Han = handle
						if ref.Map.Limb == "Head" then
							handle:SetAttribute("AttachHead", true)
						end
						Hat2HatRefs[hat] = ref
						if not ref.PH then
							ref.PH = CreatePlaceholder(hat)
						end
						return
					end
				end
			end
			HatReanimator.RebuildRequired = true
		end
	end

	local HatMap = {}
	local HatMapCopy = {}
	local function RefreshHatMap(Character)
		local summary = ""
		summary ..= "[Hat Map Summary]\n"
		summary ..= "Total hats found: " .. #CharHats .. "\n"
		local hatfors = {
			Head = {},
			Torso = {},
			LeftArm = {},
			RightArm = {},
			LeftLeg = {},
			RightLeg = {},
			ArmLeg = {},
			Block = {},
			Accessories = {},
			Unknown = {},
		}
		for _,hat in CharHats do
			local mapdata, usefor, level = ClassifyHat(hat)
			if mapdata and hatfors[usefor] then
				table.insert(hatfors[usefor], {hat, mapdata, level})
			end
		end
		summary ..= "Classified "
		for name,arr in hatfors do
			table.sort(arr, function(a, b)
				return a[3] < b[3]
			end)
			summary ..= #arr .. " " .. name .. ", "
		end
		summary = summary:sub(1, -3) .. ".\n"
		summary ..= "Rig Building:\n"
		local hatrig = {
			Head = nil,
			Torso = nil,
			LeftArm = nil,
			RightArm = nil,
			LeftLeg = nil,
			RightLeg = nil,
		}
		if #hatfors.Head > 0 then
			summary ..= "  1 Head as Head (perfect match)\n"
			hatrig.Head = table.remove(hatfors.Head, 1)
		end
		if #hatfors.Torso > 0 then
			summary ..= "  1 Torso as Torso (perfect match)\n"
			hatrig.Torso = table.remove(hatfors.Torso, 1)
		end
		if #hatfors.LeftArm > 0 then
			summary ..= "  1 LeftArm as LeftArm (perfect match)\n"
			hatrig.LeftArm = table.remove(hatfors.LeftArm, 1)
		end
		if #hatfors.RightArm > 0 then
			summary ..= "  1 RightArm as RightArm (perfect match)\n"
			hatrig.RightArm = table.remove(hatfors.RightArm, 1)
		end
		if #hatfors.LeftLeg > 0 then
			summary ..= "  1 LeftLeg as LeftLeg (perfect match)\n"
			hatrig.LeftLeg = table.remove(hatfors.LeftLeg, 1)
		end
		if #hatfors.RightLeg > 0 then
			summary ..= "  1 RightLeg as RightLeg (perfect match)\n"
			hatrig.RightLeg = table.remove(hatfors.RightLeg, 1)
		end
		local limbstobuild = {}
		if not hatrig.LeftArm then
			if #hatfors.RightArm > 0 then
				hatrig.LeftArm = table.remove(hatfors.RightArm, 1)
				summary ..= "  1 RightArm as LeftArm (hat reused)\n"
			elseif #hatfors.LeftLeg > 0 then
				hatrig.LeftArm = table.remove(hatfors.LeftLeg, 1)
				summary ..= "  1 LeftLeg as LeftArm (hat reused)\n"
			elseif #hatfors.RightLeg > 0 then
				hatrig.LeftArm = table.remove(hatfors.RightLeg, 1)
				summary ..= "  1 RightLeg as LeftArm (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.LeftArm = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as LeftArm (purpose match)\n"
			else
				table.insert(limbstobuild, "Left Arm")
			end
		end
		if not hatrig.RightArm then
			if #hatfors.LeftArm > 0 then
				hatrig.RightArm = table.remove(hatfors.LeftArm, 1)
				summary ..= "  1 LeftArm as RightArm (hat reused)\n"
			elseif #hatfors.RightLeg > 0 then
				hatrig.RightArm = table.remove(hatfors.RightLeg, 1)
				summary ..= "  1 RightLeg as RightArm (hat reused)\n"
			elseif #hatfors.LeftLeg > 0 then
				hatrig.RightArm = table.remove(hatfors.LeftLeg, 1)
				summary ..= "  1 LeftLeg as RightArm (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.RightArm = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as RightArm (purpose match)\n"
			else
				table.insert(limbstobuild, "Right Arm")
			end
		end
		if not hatrig.LeftLeg then
			if #hatfors.RightLeg > 0 then
				hatrig.LeftLeg = table.remove(hatfors.RightLeg, 1)
				summary ..= "  1 RightLeg as LeftLeg (hat reused)\n"
			elseif #hatfors.LeftArm > 0 then
				hatrig.LeftLeg = table.remove(hatfors.LeftArm, 1)
				summary ..= "  1 LeftArm as LeftLeg (hat reused)\n"
			elseif #hatfors.RightArm > 0 then
				hatrig.LeftLeg = table.remove(hatfors.RightArm, 1)
				summary ..= "  1 LeftLeg as LeftLeg (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.LeftLeg = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as LeftLeg (purpose match)\n"
			else
				table.insert(limbstobuild, "Left Leg")
			end
		end
		if not hatrig.RightLeg then
			if #hatfors.LeftLeg > 0 then
				hatrig.RightLeg = table.remove(hatfors.LeftLeg, 1)
				summary ..= "  1 LeftLeg as RightLeg (hat reused)\n"
			elseif #hatfors.RightArm > 0 then
				hatrig.RightLeg = table.remove(hatfors.RightArm, 1)
				summary ..= "  1 RightArm as RightLeg (hat reused)\n"
			elseif #hatfors.LeftArm > 0 then
				hatrig.RightLeg = table.remove(hatfors.LeftArm, 1)
				summary ..= "  1 LeftArm as RightLeg (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.RightLeg = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as RightLeg (purpose match)\n"
			else
				table.insert(limbstobuild, "Right Leg")
			end
		end
		for _,v in HatRefs do if v.PH then v.PH:Destroy() end end
		table.clear(Hat2HatRefs)
		table.clear(HatRefs)
		table.clear(HatMap)
		local function addhat(limb, data, bodyProxy)
			if data and data[2] then
				data = data[2]
				if limb then
					data.Limb = limb
				end
				data.BodyProxy = bodyProxy == true
				local index = #HatMap
				data.Index = index
				table.insert(HatMap, data)
				table.insert(HatRefs, {
					Name = data.Name,
					MeshId = data.MeshId, TextureId = data.TextureId,
					Map = data,
					Index = index,
					PH = nil,
					Hat = nil,
				})
			end
		end
		addhat("Head", hatrig.Head, true)
		addhat("Torso", hatrig.Torso, true)
		addhat("Left Arm", hatrig.LeftArm, true)
		addhat("Right Arm", hatrig.RightArm, true)
		addhat("Left Leg", hatrig.LeftLeg, true)
		addhat("Right Leg", hatrig.RightLeg, true)
		if #limbstobuild > 0 and #hatfors.Block > 0 then
			local blocks = {}
			local i = 0
			while i < #limbstobuild * 2 and #hatfors.Block > 0 do
				local name = limbstobuild[(i % #limbstobuild) + 1]
				if not blocks[name] then
					blocks[name] = {}
				end
				table.insert(blocks[name], table.remove(hatfors.Block, 1))
				i += 1
			end
			for name,v in blocks do
				if #v == 2 then
					local a, b = v[1], v[2]
					a[2].C0 = CFrame.new(0, -0.5, 0)
					b[2].C0 = CFrame.new(0, 0.5, 0)
					addhat(name, a, true)
					addhat(name, b, true)
					summary ..= "  2 Block as " .. name:gsub(" ", "") .. " (block build)\n"
				elseif #v == 1 then
					addhat(name, v[1], true)
					summary ..= "  1 Block as " .. name:gsub(" ", "") .. " (block build)\n"
				end
			end
		end
		summary ..= "  " .. #hatfors.Accessories .. " known accessories\n"
		for _,acc in hatfors.Accessories do
			addhat(nil, acc)
		end
		table.clear(hatfors.Accessories)
		local unused = 0
		local function AttmentGet(name)
			for _,data in ipairs(HatMap) do
				if data.Attachments and data.Attachments[name] then
					return {data.Limb, data.C0 * data.C1:Inverse() * data.Attachments[name]}
				end
			end
			return Attachments[name]
		end
		for _,v in hatfors do
			for _,w in v do
				local hat = w[1]
				local map = w[2]
				local limb, c0 = unpack(AttmentGet("HatAttachment"))
				local c1 = hat.AttachmentPoint
				local handle = hat:FindFirstChild("Handle")
				if handle then
					for _,x in handle:GetChildren() do
						if x:IsA("Attachment") then
							local att = AttmentGet(x.Name)
							if att then
								limb, c0, c1 = att[1], att[2], x.CFrame
								break
							end
						end
					end
				end
				map.C0 = c0
				map.C1 = c1
				map.Limb = limb
				addhat(limb, w)
				unused += 1
			end
		end
		summary ..= "...which leaves " .. unused .. " unused."
		HatMap.Built = os.clock()
		HatMapCopy = Util.DeepcopyTable(HatMap)
		for _,v in CharHats do
			RefHatToHatRefs(v)
		end
		HatReanimator.HatMapSummary = summary
		HatReanimator.RebuildRequired = false
	end
	local function GetHatMappedOverride(hatmapped)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local scale = ReanimCharacter:GetScale()
		local hatscale = hatmapped.Scale
		-- cframe override
		for _,data in HatReanimator.HatCFrameOverride do
			if not data.Disable then
				-- accessory group
				if data.Group and hatmapped.Group == data.Group then
					if data.Limb then
						return {
							C0 = data.C0 or data.Offset or CFrame.identity,
							C1 = hatmapped.C1 * (data.C1 or CFrame.identity),
							Limb = data.Limb, RepRootPart = data.RepRootPart,
							Scale = hatscale,
						}
					else
						return {
							C0 = data.C0 or data.CFrame or CFrame.identity,
							C1 = hatmapped.C1 * (data.C1 or CFrame.identity),
							RepRootPart = data.RepRootPart,
							Scale = hatscale,
						}
					end
				end
				-- exact asset id
				if data.MeshId or data.TextureId or data.Name then
					local oke = true
					if data.MeshId then
						oke = oke and AssetIdMatch(hatmapped.MeshId, data.MeshId)
					end
					if data.TextureId then
						oke = oke and AssetIdMatch(hatmapped.TextureId, data.TextureId)
					end
					if data.Name then
						oke = oke and hatmapped.Name == data.Name
					end
					if oke then
						return {
							C0 = data.C0, C1 = data.C1,
							Offset = data.Offset or data.CFrame,
							Limb = data.Limb, RepRootPart = data.RepRootPart,
							Scale = hatscale,
						}
					end
				end
				if data.Index and hatmapped.Index == data.Index then
					return {
						C0 = data.C0 or data.CFrame or CFrame.identity,
						C1 = hatmapped.C1 * (data.C1 or CFrame.identity),
						RepRootPart = data.RepRootPart,
						Scale = hatscale,
					}
				end
			end
		end
		return hatmapped
	end
	local function GetHatMappedMeshAndTexture(mesh, tex, name)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local hatmapped = nil
		-- find hat mapping
		for _,data in ipairs(HatMap) do
			if (name and data.Name == name or not name) and data.MeshId == mesh and data.TextureId == tex then
				hatmapped = data
				break
			end
		end
		if not hatmapped then return end
		return GetHatMappedOverride(hatmapped)
	end
	local function GetHatMappedCFrame(hatmapped)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local scale = ReanimCharacter:GetScale()
		if hatmapped then
			local hatscale = hatmapped.Scale
			-- limb attached
			if hatmapped.Limb then
				local limb = ReanimCharacter:FindFirstChild(hatmapped.Limb)
				if limb and limb:IsA("BasePart") then
					-- weld-like
					if hatmapped.C0 and hatmapped.C1 then
						return limb.CFrame * Util.ScaleCFrame(hatmapped.C0, scale) * Util.ScaleCFrame(hatmapped.C1, hatscale):Inverse(), limb.Velocity
					end
					-- legacy
					if hatmapped.Offset then
						return limb.CFrame * hatmapped.Offset, limb.Velocity
					end
				end
			else
				-- world coords
				if hatmapped.C0 and hatmapped.C1 then
					return hatmapped.C0 * Util.ScaleCFrame(hatmapped.C1, hatscale):Inverse(), Vector3.zero
				end
			end
		end
		return
	end
	local function GetHatCFrameMeshAndTexture(mesh, tex, name)
		return GetHatMappedCFrame(GetHatMappedMeshAndTexture(mesh, tex, name))
	end
	local function GetHatMapped(hat)
		local handle = hat:FindFirstChild("Handle")
		if not handle or not handle:IsA("BasePart") then return end
		local mesh, tex = GetHatMeshAndTexture(hat)
		return GetHatMappedMeshAndTexture(mesh, tex, hat.Name)
	end
	local function GetHatCFrame(hat)
		local handle = hat:FindFirstChild("Handle")
		if not handle or not handle:IsA("BasePart") then return end
		local mesh, tex = GetHatMeshAndTexture(hat)
		return GetHatCFrameMeshAndTexture(mesh, tex, hat.Name)
	end
	local function GetAttachmentCFrame(name)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local scale = ReanimCharacter:GetScale()
		local hatmapped = nil
		-- find hat mapping
		for _,data in ipairs(HatMap) do
			if data.Attachments and data.Attachments[name] then
				hatmapped = data
				break
			end
		end
		if hatmapped then
			local cf = GetHatCFrameMeshAndTexture(hatmapped.MeshId, hatmapped.TextureId)
			local att = hatmapped.Attachments[name]
			return cf * Util.ScaleCFrame(att, hatmapped.Scale)
		end
		if Attachments[name] then
			local limb = ReanimCharacter:FindFirstChild(Attachments[name][1])
			if limb then
				return limb.CFrame * Util.ScaleCFrame(Attachments[name][2], scale)
			end
		end
		return
	end
	HatReanimator.GetHatMap = function() return HatMapCopy end
	HatReanimator.GetHatCFrameMeshAndTexture = GetHatCFrameMeshAndTexture
	HatReanimator.GetAttachmentCFrame = GetAttachmentCFrame

	local InitCFrame = nil
	local CurrentCharacter = nil

	HatReanimator.RebuildRequired = true
	HatReanimator.HatMapSummary = "(no hat map yet...)"
	table.clear(HatReanimator.FlingTargets)
	
	local lastsimradchange = 0
	local function SetSimulationRadius()
		local function setsimrad(plr, radius)
			pcall(function()
				plr.SimulationRadius = radius
			end)
			pcall(sethiddenproperty, plr, "SimulationRadius", radius)
		end
		--[[settings().Physics.AllowSleep = false
		settings().Physics.ThrottleAdjustTime = 0/0
		for _,plr in Players:GetPlayers() do
			local a, b = pcall(compareinstances, plr, Player)
			if a and not b then
				setsimrad(plr, 0)
			end
		end]]
		local r = #Players:GetPlayers() * 1000
		setsimrad(Player, r)
		--if os.clock() > lastsimradchange then
			--lastsimradchange = os.clock() + 1
			--pcall(replicatesignal, Player.SimulationRadiusChanged, r)
		--end
		--[[pcall(setsimulationradius, r, r)
		pcall(function()
			-- faster than findfirstchild + if then end
			sethiddenproperty(Player.Character.Humanoid, "InternalBodyScale", Vector3.new(9e9, 9e9, 9e9))
			sethiddenproperty(Player.Character.Humanoid, "InternalHeadScale", 9e9)
		end)]]
	end
	local function IsNetworkOwner(part)
		return part.ReceiveAge == 0
	end
	
	local BackendAccoutrementState = {
		None = 0,
		HasHandle = 1,
		InWorkspace = 2,
		InCharacter = 3,
		Equipped = 4,
	}
	local function SetAccoutrementState(hat, state)
		sethiddenproperty(hat, "BackendAccoutrementState", state)
	end

	local IsRespawning = false
	local function Respawn()
		if IsRespawning then return end
		IsRespawning = true
	end

	-- Credits to MyWorld for helping with netless
	local function SetUACFrameNetless(handle, dt, newcf, tvel, fling, spin)
		if dt <= 0 then return false end
		if not (handle:IsA("BasePart") and handle:IsDescendantOf(workspace)) then return false end
		local timing = os.clock()
		local idlerv = Vector3.new(
			math.sin(timing * 14), math.sin(timing * 15 + 1.0472), math.sin(timing * 16 + 2.0944)
		)
		local idleoff = idlerv * 0.001
		local ylimit = FallenPartsDestroyHeight + 5
		if newcf.Y < ylimit then
			newcf += Vector3.new(0, ylimit - newcf.Y, 0)
		end
		local speedlimit = 16384
		if fling then
			speedlimit = math.huge
		end
		local netless = Reanimate.NetlessVelocity + (math.sin(timing * 0.5) + 1) / 2
		local aligned = true
		local lastcf = handle:GetAttribute("_Uhhhhhh_LastPosition")
		local claimtime = handle:GetAttribute("_Uhhhhhh_ClaimTime")
		if typeof(lastcf) ~= "CFrame" then lastcf = handle.CFrame end
		if not handle:IsGrounded() and IsNetworkOwner(handle) then
			local newpos = newcf.Position
			local lastpos = lastcf.Position
			local vel = (newpos - lastpos) / dt
			if vel.Magnitude < 0.12 then
				newcf += idleoff
			elseif vel.Magnitude > speedlimit then
				vel = vel.Unit * speedlimit
				newpos = lastpos + vel * dt
				newcf = newcf.Rotation + newpos
				aligned = false
			end
			local rvel = lastcf:ToObjectSpace(newcf)
			local a, b = rvel:ToAxisAngle()
			rvel = (a * b) / dt
			lastcf = newcf
			if claimtime then
				if timing - claimtime < 5.67 then
					handle.Massless = false
					handle.CustomPhysicalProperties = nil
				else
					handle.Massless = true
					handle.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
				end
				if timing - claimtime < 0.51 then
					handle.AssemblyLinearVelocity = Vector3.new(0, netless, 0)
				else
					if fling then
						handle.AssemblyLinearVelocity = Vector3.new(16384, 16384, 16384)
					else
						-- so Patchma's netless doesn't need the velocity of the hat, just where its attached to.
						if Reanimate.UsePatchmaLikeNetless then
							vel = tvel
							vel *= Vector3.new(1, 0, 1)
							if vel.Magnitude > netless then
								vel = vel.Unit * netless
							end
							handle.AssemblyLinearVelocity = Vector3.new(vel.X * 10, netless, vel.Z * 10)
						else
							vel += tvel
							vel *= Vector3.new(1, 0, 1)
							if vel.Magnitude > netless then
								vel = vel.Unit * netless
							end
							handle.AssemblyLinearVelocity = Vector3.new(vel.X, math.max(vel.Y, netless), vel.Z)
							handle:ApplyImpulse(Vector3.new(vel.X, math.max(vel.Y, netless), vel.Z))
						end
					end
				end
			else
				claimtime = timing
				handle.AssemblyLinearVelocity = Vector3.new(0, netless * 2, 0)
			end
			handle.CFrame = newcf
			if spin then
				handle.AssemblyAngularVelocity = Vector3.new(16384, 16384, 16384)
			else
				if Reanimate.UseAngularVelocity then
					handle.AssemblyAngularVelocity = rvel + idleoff
					handle:ApplyAngularImpulse(rvel + idleoff)
				else
					handle.AssemblyAngularVelocity = idleoff
					handle:ApplyAngularImpulse(idleoff)
				end
			end
		else
			claimtime = nil
			lastcf = handle.CFrame
			aligned = false
		end
		handle:SetAttribute("_Uhhhhhh_LastPosition", lastcf)
		handle:SetAttribute("_Uhhhhhh_ClaimTime", claimtime)
		return aligned
	end

	local CharOnDesc = function(v)
		if v:IsA("BasePart") and not (v:FindFirstAncestorWhichIsA("Tool") or v:FindFirstAncestorWhichIsA("Accessory")) then
			if not table.find(BaseParts, v) then
				table.insert(BaseParts, v)
			end
		elseif v:IsA("Animator") then
			task.defer(function()
				v:Destroy()
			end)
		elseif v:IsA("LocalScript") and v.Parent == HatReanimator.ActiveRealCharacter then
			v.Enabled = false
			v:GetPropertyChangedSignal("Enabled"):Connect(function()
				if v.Enabled then v.Enabled = false end
			end)
			v:GetPropertyChangedSignal("Disabled"):Connect(function()
				if not v.Disabled then v.Disabled = true end
			end)
		elseif v:IsA("Accessory") and v.Parent == HatReanimator.ActiveRealCharacter then
			local handle = v:WaitForChild("Handle", 10)
			if handle then
				if not table.find(CharHats, v) then
					table.insert(CharHats, v)
					local conn = nil
					conn = v.AncestryChanged:Connect(function()
						if v.Parent ~= HatReanimator.ActiveRealCharacter then
							local i = table.find(CharHats, v)
							if i then table.remove(CharHats, i) end
						end
					end)
				end
			end
		elseif v:IsA("Tool") and v.Parent == HatReanimator.ActiveRealCharacter then
			if not table.find(CharTools, v) then
				table.insert(CharTools, v)
				local conn = nil
				conn = v.AncestryChanged:Connect(function()
					if v.Parent ~= HatReanimator.ActiveRealCharacter then
						local i = table.find(CharTools, v)
						if i then table.remove(CharTools, i) end
					end
				end)
			end
		end
	end
	local currentping = 0
	local function _counthats(hats)
		local collidable = 0
		local exists = 0
		for _,hat in hats do
			local handle = hat:FindFirstChild("Handle")
			if handle and handle:IsA("BasePart") then
				exists += 1
				if handle.CanCollide then
					collidable += 1
					handle:SetAttribute("_Uhhhhhh_HasCollide", true)
					HatReanimator.CollidableHandles[handle] = true
				end
				handle.CanCollide = false
			end
		end
		HatReanimator.Status.HatCollide = exists .. " hats, " .. collidable .. " has collide."
		return collidable
	end
	local function calculatepartdestroytime(height, velocity, gravity)
		return (velocity + math.sqrt(velocity * velocity + 2 * gravity * height)) / gravity
	end
	local HatCollideMethods = {}
	HatCollideMethods[-2] = {
		NoAnim = true,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, 141, 0))
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
		end,
		State1 = function(character, Humanoid, hats)
			HatReanimator.Status.HatCollide = "RCDless Mode, applying reweld to head method"
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.None)
				local att = v:FindFirstChildOfClass("Attachment")
				if att then
					att:Destroy()
				end
			end
		end,
		State2 = function(character, hats)
			local torso = character:FindFirstChild("Torso")
			if torso then torso:Destroy() end
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then root:Destroy() end
			for _,v in character:GetChildren() do
				if v:IsA("BasePart") and v.Name ~= "Head" then
					v:Destroy()
				end
			end
			local head = character:FindFirstChild("Head")
			if head then head:Destroy() end
			task.wait(0.5)
			return _counthats(hats)
		end,
	}
	HatCollideMethods[-1] = {
		NoAnim = true,
		Wait1 = 0.25,
		Wait2 = 0,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			RootPart.CFrame = CFrame.new(RootPosition) * CFrame.Angles(math.pi / 2, 0, 0)
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
		end,
		State1 = function() end,
		State2 = function() return 0 end,
	}
	local shownapehatdrop_lock = {}
	HatCollideMethods[0] = {
		NoAnim = false,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, -0.25, 0)) * CFrame.Angles(math.rad(20), 0, 0)
			else
				RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, -0.25, 0))
			end
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 25, 0), Vector3.zero
		end,
		State1 = function(character, Humanoid, hats)
			local anim = Instance.new("Animation")
			anim.AnimationId = "rbxassetid://180436148"
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				anim.AnimationId = "rbxassetid://507767968"
			end
			local track = Humanoid:LoadAnimation(anim)
			track.Priority = 5
			track:Play(0)
			track:AdjustSpeed(1)
			track:AdjustWeight(1)
			track.TimePosition = 0.1
			table.clear(shownapehatdrop_lock)
			for _,v in hats do
				table.insert(shownapehatdrop_lock, v.Changed:Connect(function(p)
					if p == "BackendAccoutrementState" then
						SetAccoutrementState(v, BackendAccoutrementState.None)
					end
				end))
				SetAccoutrementState(v, BackendAccoutrementState.InCharacter)
			end
			HatReanimator.Status.HatCollide = #hats .. " hats states ERADICATED!"
		end,
		State2 = function(character, hats)
			local torso = character:FindFirstChild("Torso")
			if torso then
				torso.AncestryChanged:Wait()
			end
			HatReanimator.Status.HatCollide = "Torso removed, state unlocked."
			for _,v in shownapehatdrop_lock do
				v:Disconnect()
			end
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.Equipped)
			end
			torso = character:FindFirstChild("Head")
			if torso then
				torso.AncestryChanged:Wait()
			end
			task.wait(0.5)
			return _counthats(hats)
		end,
	}
	local function hatcol_hrptpstab(torsooffset)
		return function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			local rootcf = CFrame.new(RootPosition + Vector3.new(8, -8, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0)
			if readystate > 0 then
				RootPart.CFrame = rootcf
				RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 26, 0), Vector3.zero
			else
				RootPart.CFrame = rootcf + Vector3.new(0, 141, 0) -- CFrame.new(RootPosition + Vector3.new(8, 141, 0))
				RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 26, 0), Vector3.zero
			end
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "Root" then
							Util.SetMotor6DOffset(v, rootcf:ToObjectSpace(CFrame.new(RootPosition + Vector3.new(0, 0.75, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0) * torsooffset))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(math.random() * 0.05, 1.5, -10))
						elseif v.Name:FindFirstChild("Shoulder") or v.Name:FindFirstChild("Hip") then
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(v.C0.X - v.C1.X, v.C0.Y - v.C1.Y, -0.5 + math.random() * 0.05))
						else
							Util.SetMotor6DTransform(v, CFrame.identity)
						end
					end
				end
			else
				local i = 1
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "RootJoint" then
							Util.SetMotor6DOffset(v, rootcf:ToObjectSpace(CFrame.new(RootPosition + Vector3.new(0, -0.25, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0) * torsooffset))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(math.random() * 0.05, 1.5, -20))
						else
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(i * -3, math.random() * 0.05, -3))
							i += 1
						end
					end
				end
			end
		end
	end
	HatCollideMethods[1] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0)),
		State1 = function(character, Humanoid, hats)
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
				SetAccoutrementState(v, BackendAccoutrementState.None)
			end
			HatReanimator.Status.HatCollide = #hats .. " hats states ERADICATED!"
		end,
		State2 = function(character, hats)
			local torso = character:FindFirstChild("Torso")
			if torso then
				torso.AncestryChanged:Wait()
			end
			HatReanimator.Status.HatCollide = "Torso removed, state unlocked."
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.Equipped)
			end
			torso = character:FindFirstChild("Head")
			if torso then
				torso.AncestryChanged:Wait()
			end
			task.wait(0.5)
			return _counthats(hats)
		end,
	}
	HatCollideMethods[2] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0) * CFrame.Angles(math.pi, 0, 0)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[3] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0) * CFrame.Angles(math.pi * -0.5, 0, 0)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[4] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0) * CFrame.Angles(math.pi * 0.5, 0, 0)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[5] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, -8)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[6] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, -60)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[7] = {
		ColLimb = true,
		NoAnim = true,
		Wait1 = 0.1,
		Wait2 = 0.15,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			local rootcf = CFrame.new(RootPosition + Vector3.new(0, -4, 0))
			RootPart.CFrame = rootcf
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 26, 0), Vector3.zero
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				-- TODO
			else
				-- put the limbs in freefall, make sure they dont touch
				local headheight = 3
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "RootJoint" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 6, 0))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, CFrame.new(0, headheight, -2))
						elseif v.Name == "Right Shoulder" then
							Util.SetMotor6DOffset(v, CFrame.new((v.C0.X - v.C1.X) * 2, headheight + 0.5, -2))
						elseif v.Name == "Left Shoulder" then
							Util.SetMotor6DOffset(v, CFrame.new((v.C0.X - v.C1.X) * 2, 0, -2))
						elseif v.Name:find("Hip") then
							Util.SetMotor6DOffset(v, CFrame.new((v.C0.X - v.C1.X) * 2, -2, -2))
						else
							Util.SetMotor6DTransform(v, CFrame.identity)
						end
					end
				end
			end
		end,
		State1 = function(character, Humanoid, hats)
			HatReanimator.Status.HatCollide = "Hat states set."
			local head = character:FindFirstChild("Head")
			for _,v in hats do
				local handle = v:FindFirstChild("Handle")
				if handle then
					local weld = handle:FindFirstChild("AccessoryWeld")
					if weld then
						if weld.Part0 == handle and weld.Part1 ~= head then
							continue
						end
						if weld.Part1 == handle and weld.Part0 ~= head then
							continue
						end
					end
				end
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
			end
		end,
		State2 = function(character, hats)
			local ping = Player:GetNetworkPing()
			-- 3 of the most important instances (rootpart is destroyed after a frame anyway)
			local torso = character:FindFirstChild("Torso")
			local head = character:FindFirstChild("Head")
			local rightarm = character:FindFirstChild("Right Arm") -- this will also reevaluate collisions upon removal (cuz tool)
			if torso then
				task.wait(calculatepartdestroytime(2, 26, workspace.Gravity) - 0.1)
			end
			HatReanimator.Status.HatCollide = "Torso removed, I speculate."
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
			end
			if torso and torso.Parent then
				torso.AncestryChanged:Wait()
			end
			if head and head.Parent then
				head.AncestryChanged:Wait()
			end
			task.wait(1.5)
			return _counthats(hats)
		end,
	}
	HatCollideMethods[8] = { -- VERY EXPERIMENTAL, do NOT use.
		NoAnim = true,
		Wait1 = 0.1,
		Wait2 = 0.15,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			local rootcf = CFrame.new(RootPosition + Vector3.new(0, -4, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0)
			RootPart.CFrame = rootcf
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 30), Vector3.zero
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "Root" then
							Util.SetMotor6DTransform(v, CFrame.new(0, -30, 0))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 67, 0))
						else
							Util.SetMotor6DTransform(v, CFrame.identity)
						end
					end
				end
			else
				local i = 1
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "RootJoint" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 0, -20))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 0, -1))
						elseif v.Name == "Right Shoulder" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 0, -20))
						else
							Util.SetMotor6DOffset(v, CFrame.new(i * -3, 0, 10))
							i += 1
						end
					end
				end
			end
		end,
		State1 = function(character, Humanoid, hats)
			HatReanimator.Status.HatCollide = "Hat states set."
			local head = character:FindFirstChild("Head")
			for _,v in hats do
				local handle = v:FindFirstChild("Handle")
				if handle then
					local weld = handle:FindFirstChild("AccessoryWeld")
					if weld then
						if weld.Part1 ~= head then
							continue
						end
					end
				end
				SetAccoutrementState(v, BackendAccoutrementState.InCharacter)
			end
		end,
		State2 = function(character, hats)
			local hum = character:FindFirstChild("Humanoid")
			local head = character:FindFirstChild("Right Arm")
			HatReanimator.Status.HatCollide = "We shall remain 1 part."
			task.wait(0.41)
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
				SetAccoutrementState(v, BackendAccoutrementState.InCharacter)
			end
			task.wait(0.19)
			if head and head:IsDescendantOf(workspace) then
				head.AncestryChanged:Wait()
			end
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.Equipped)
			end
			task.wait(1.5)
			return _counthats(hats)
		end,
	}
	local NumHats = 0
	local function OnCharacter(character)
		if HatReanimator.DontFireCharAddOnThisChar == character then return end
		table.clear(HatReanimator.CollidableHandles)
		HatReanimator.ActiveRealCharacter = character
		HatReanimator.RigGeneration += 1
		-- CharacterAdded makes Roblox's camera module prefer the fresh physical
		-- shell. Pin it back before the shell is sent through the void/hat claim
		-- sequence so respawning never yanks the player's view away.
		local controllerHumanoid = Reanimate.Character and Reanimate.Character:FindFirstChildOfClass("Humanoid")
		if Camera and controllerHumanoid then
			Camera.CameraSubject = controllerHumanoid
		end
		currentping = Player:GetNetworkPing()
		local toolnames = {}
		for _,v in CharTools do table.insert(toolnames, v.Name) end
		table.clear(BaseParts)
		table.clear(CharHats)
		table.clear(CharTools)
		ResetHatRefs()
		character.DescendantAdded:Connect(CharOnDesc)
		for _,v in character:GetDescendants() do
			CharOnDesc(v)
		end
		HatReanimator.Status.ReanimState = "Respawned."
		HatReanimator.Status.Permadeath = "Respawn detected."
		HatReanimator.Status.HatCollide = "Respawn detected."
		HatReanimator.Status.RespawnFling = "Respawn detected."
		local hatcols = HatReanimator.HatCollide
		local perma = HatReanimator.Permadeath
		HatReanimator.HasPermadeath, HatReanimator.HasHatCollide = perma, hatcols
		local hatcolmeth = HatReanimator.HatCollideMethod
		if not replicatesignal then perma = false end
		if not hatcols then hatcolmeth = -1 end
		if hatcols and RejectCharacterDeletionsDisabled then
			hatcolmeth = -2
		end
		local selhatcol = HatCollideMethods[hatcolmeth]
		CurrentCharacter = nil
		local Humanoid = character:WaitForChild("Humanoid", 10)
		if not Humanoid then return end
		if not Reanimate.UseLoadAnimationHook then
			local stupid = character:FindFirstChild("Animate")
			if stupid then
				stupid:Destroy()
			end
			character.ChildAdded:Connect(function(v)
				if v:IsA("LocalScript") then
					v.Disabled = true
					task.defer(function()
						v:Destroy()
					end)
				end
			end)
		end
		if selhatcol.NoAnim then
			local stupid = Humanoid:FindFirstChild("Animator")
			if stupid then
				stupid:Destroy()
			end
		end
		if selhatcol.ColLimb then
			Humanoid.EvaluateStateMachine = false
			Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		end
		local RootPart = character:WaitForChild("HumanoidRootPart", 10)
		if not RootPart then return end
		local RootPosition = Vector3.new(RootPart.Position.X, FallenPartsDestroyHeight, RootPart.Position.Z)
		local ReanimCharacter = Reanimate.Character
		if ReanimCharacter then
			local root = ReanimCharacter:FindFirstChild("HumanoidRootPart")
			if root then
				RootPosition = Vector3.new(root.Position.X, FallenPartsDestroyHeight, root.Position.Z)
			end
		end
		if not workspace.StreamingEnabled and false then
			local dir = CFrame.Angles(0, math.pi * 2 * math.random(), 0).LookVector * 300
			while true do
				local nearAPlayer = false
				for _,v in Players:GetPlayers() do
					if v.Character and v.Character.PrimaryPart then
						if (RootPosition - v.Character.PrimaryPart.CFrame.Position).Magnitude < 1000 then
							nearAPlayer = true
						end
					end
				end
				if nearAPlayer then
					RootPosition += dir
				else
					break
				end
			end
		end
		if not perma then
			RootPosition += Vector3.new(0, 12, 0)
			if ReanimCharacter then
				local root = ReanimCharacter:FindFirstChild("HumanoidRootPart")
				if root then
					if HatReanimator.RespawnPosition == 1 then
						RootPosition = root.CFrame * Vector3.new(0, 0, 6)
					end
					if HatReanimator.RespawnPosition == 2 then
						local dir = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1).Unit
						if dir ~= dir or dir.Magnitude == 0 then
							dir = Vector3.yAxis
						end
						RootPosition = root.Position + dir * math.random(8, 12)
					end
				end
			end
			if HatReanimator.RespawnPosition == 3 then
				RootPosition = RootPart.Position
			end
		end
		if hatcols then
			RootPosition = Vector3.new(RootPosition.X, FallenPartsDestroyHeight, RootPosition.Z)
		end
		--pcall(function() Player.ReplicationFocus = character end)
		if hatcols then
			HatReanimator.Status.HatCollide = "Waiting for Permadeath."
		else
			HatReanimator.Status.HatCollide = "Disabled, nothing to do!"
		end
		local cdsbeffect = os.clock()
		local cdsbtime = os.clock()
		if perma then
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
			Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
			pcall(firesignal, Humanoid.StateEChanged, Enum.HumanoidStateType.Swimming, nil)
			pcall(firesignal, Humanoid.StateEnabledChanged, Enum.HumanoidStateType.Dead, false) -- im trine bro im trine
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			Humanoid.EvaluateStateMachine = false
			Humanoid.RequiresNeck = false
			pcall(firesignal, Humanoid.RequiresNeck, false)
			HatReanimator.Status.Permadeath = "Enabled Permadeath Requirements."
			cdsbeffect += Players.RespawnTime
		end
		HatReanimator.Status.RespawnFling = "Flinging targets..."
		if LimbReanimator.UseNaNFling and HatReanimator.FlingTargets[1] then
			task.wait(0.2)
		end
		while character:IsDescendantOf(workspace) do
			local t = os.clock()
			local flingtarget = HatReanimator.FlingTargets[1]
			if HatReanimator.FlingMethod == -1 then
				table.remove(HatReanimator.FlingTargets, 1)
				flingtarget = nil
			end
			if flingtarget then
				if flingtarget.Time then
					if t > flingtarget.Time then
						table.remove(HatReanimator.FlingTargets, 1)
						flingtarget = nil
					end
				else
					flingtarget.Time = t + (flingtarget.Duration or (Reanimate.UsePhysicsRepRootPart and 1 or 2))
				end
			end
			local flingcf, flinged = CFrame.identity, true
			if flingtarget then
				flingcf, flinged = Util.PredictionFling(flingtarget.Target)
				if flinged then
					table.remove(HatReanimator.FlingTargets, 1)
					flingtarget = nil
				end
			end
			if flingtarget then
				if not RootPart:IsGrounded() then
					if LimbReanimator.UseNaNFling then
						RootPart.CFrame = CFrame.new(flingcf.Position + Vector3.new(0, 0, math.random(0, 1) * 0.005)) * CFrame.Angles(0, os.clock() * 15, 0)
						RootPart.Velocity, RootPart.RotVelocity = Vector3.zero, Vector3.zero
					else
						RootPart.CFrame = flingcf + Vector3.new(0, 0, math.random(0, 1) * 0.005)
						RootPart.Velocity, RootPart.RotVelocity = Vector3.new(0, -16384, 0), Vector3.one * 16384
					end
					pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and Util.PredictionFlingPart(flingtarget.Target) or nil)
				end
				Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
				if LimbReanimator.UseNaNFling then
					pcall(sethiddenproperty, Humanoid, "MoveDirectionInternal", Vector3.new(0/0, 0/0, 0/0))
				end
			elseif #HatReanimator.FlingTargets == 0 then
				break
			else
				RootPart.CFrame = CFrame.new(0, 1000, 0)
				RootPart.Velocity, RootPart.RotVelocity = Vector3.zero, Vector3.zero
				Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
			end
			task.wait()
		end
		if not character:IsDescendantOf(workspace) then
			return
		end
		pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", nil)
		HatReanimator.Status.RespawnFling = "Done."
		local lgloop = nil
		local bringconns = {}
		local readystate = 0
		if perma then task.wait(1) end
		local backpack = Player:FindFirstChildOfClass("Backpack")
		local tools = GetTools()
		if backpack then
			for _=1, 3 do
				for _,tool in tools do
					tool.Parent = character
				end
				for _,tool in tools do
					tool.Parent = backpack
				end
			end
		end
		lgloop = RunService.Heartbeat:Connect(function(dt)
			selhatcol.HRPTP(dt, character, Humanoid, RootPosition, RootPart, readystate)
		end)
		if hatcols then task.wait(0.2) end
		HatReanimator.Status.ReanimState = "Loading Permadeath."
		if perma then
			HatReanimator.Status.Permadeath = "no."
		else
			HatReanimator.Status.Permadeath = "Disabled, nothing to do."
		end
		if not character:IsDescendantOf(workspace) then
			lgloop:Disconnect()
			return
		end
		readystate = 1
		HatReanimator.Status.ReanimState = "Reanimate State: 1"
		if not selhatcol.ColLimb then
			Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		end
		NumHats = #CharHats
		selhatcol.State1(character, Humanoid, CharHats)
		local claimarea = RootPart.CFrame.Position + RootPart.CFrame.LookVector * 8
		claimarea = Vector3.new(claimarea.X, math.max(FallenPartsDestroyHeight + 16, claimarea.Y + 4), claimarea.Z)
		task.wait(selhatcol.Wait1 or 0.1)
		if not character:IsDescendantOf(workspace) then
			lgloop:Disconnect()
			return
		end
		readystate = 2
		HatReanimator.Status.ReanimState = "Reanimate State: 2"
		for _,hat in CharHats do
			local handle = hat:FindFirstChild("Handle")
			if handle and handle:IsA("BasePart") then
				table.insert(bringconns, RunService.Heartbeat:Connect(function(dt)
					if handle:IsDescendantOf(workspace) and IsNetworkOwner(handle) then
						handle.CFrame = CFrame.new(claimarea)
						handle.Velocity = Vector3.new(0, 67, 0)
						handle.RotVelocity = Vector3.new(0, 0, 0)
					end
				end))
				for _,v in handle:GetChildren() do
					if v:IsA("JointInstance") then v:Destroy() end
					if v:IsA("Constraint") then v.Enabled = false end
					if v:IsA("Attachment") then
						v.Archivable = true
						local w = v:Clone()
						v:Destroy()
						w.Parent = handle
					end
				end
				handle:SetAttribute("_Uhhhhhh_HasCollide", false)
			end
		end
		Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
		task.wait(selhatcol.Wait2 or 0.15)
		if not character:IsDescendantOf(workspace) then
			lgloop:Disconnect()
			for _,c in bringconns do
				c:Disconnect()
			end
			return
		end
		AvatarEditorService:BustAvatarFetchCache()
		pcall(replicatesignal, Humanoid.ServerBreakJoints)
		Humanoid.EvaluateStateMachine = true
		Humanoid.BreakJointsOnDeath = true
		if HatReanimator.RagdollPDAssist == false then
			Humanoid.Health = -math.huge
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
			replicatesignal(Player.Kill)
		end
		if HatReanimator.RagdollPDAssist == true then
			pcall(replicatesignal, Humanoid.ServerBreakJoints)
			Player.Character:BreakJoints()
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
		end
		readystate = 3
		HatReanimator.Status.ReanimState = "Reanimate State: 3"
		IsRespawning = false
		if hatcols then
			local stateunlocked = false
			task.spawn(function()
				local collidable = selhatcol.State2(character, CharHats)
				stateunlocked = true
				local atleast = 0
				if SaveData.Reanimator.IWantHatCollide == 1 then
					atleast = 1
				end
				if SaveData.Reanimator.IWantHatCollide == 2 then
					atleast = #CharHats - 3
				end
				if SaveData.Reanimator.IWantHatCollide == 3 then
					atleast = #CharHats - 2
				end
				if SaveData.Reanimator.IWantHatCollide == 4 then
					atleast = #CharHats - 1
				end
				if hatcols and collidable <= atleast then
					if perma then
						HatReanimator.Status.Permadeath = "No hat collide. Respawning!"
						Respawn()
					end
				end
			end)
			repeat task.wait() until stateunlocked or not character:IsDescendantOf(workspace)
			--task.wait(0.25)
		end
		if backpack then
			for _,tool in tools do
				tool.Parent = Humanoid
				tool.Parent = character
				tool.Parent = backpack
			end
		end
		lgloop:Disconnect()
		if perma then task.wait(1) end
		for _,c in bringconns do
			c:Disconnect()
		end
		if not character:IsDescendantOf(workspace) then
			return
		end
		HatReanimator.Status.ReanimState = "Done."
		if #CharHats == 0 then
			if perma then
				HatReanimator.Status.Permadeath = "All hats died. Respawning!"
				Respawn()
			end
		end
		if perma and hatcols then
			if HatReanimator.IWantAllHats and NumHats > #CharHats then
				if perma then
					HatReanimator.Status.Permadeath = "Some hats died. Respawning!"
					Respawn()
				end
			else
				NumHats = #CharHats
			end
		end
		--pcall(function() Player.ReplicationFocus = nil end)
		CurrentCharacter = character
		task.wait()
		if backpack then
			for _,tool in tools do
				local i = table.find(toolnames, tool.Name)
				if i then
					table.remove(toolnames, i)
					tool.Parent = character
				end
			end
		end
	end

	local CharConn = Player.CharacterAdded:Connect(OnCharacter)

	if Player.Character then
		local h = Player.Character:FindFirstChildOfClass("Humanoid")
		if h and h.RootPart then
			HatReanimator.ActiveRealCharacter = Player.Character
			HatReanimator.RigGeneration += 1
			InitCFrame = h.RootPart.CFrame
			pcall(replicatesignal, Player.Character.Humanoid.ServerBreakJoints)
			--pcall(replicatesignal, Player.ConnectDiedSignalBackend)
			Player.Character.DescendantAdded:Connect(CharOnDesc)
			for _,v in Player.Character:GetDescendants() do
				CharOnDesc(v)
			end
			CurrentCharacter = Player.Character
		end
	end

	Reanimate.CreateCharacter(InitCFrame)

	HatReanimator.StaticRoot = Reanimate.Character and Reanimate.Character:FindFirstChild("HumanoidRootPart")

	Reanimate.Starting = false
	local letitgo = 0
	while not Reanimate.Stopping do
		RunService.PreSimulation:Wait()
		workspace.FallenPartsDestroyHeight = 0/0
		SetSimulationRadius()
		debug.profilebegin("Uhhhhhh > CharacterCheck")
		local ReanimOkay = false
		local Character = Player.Character
		local ReanimCharacter = Reanimate.Character
		if Character == ReanimCharacter then
			Character = HatReanimator.ActiveRealCharacter
		end
		if Character and Character:IsDescendantOf(workspace) then
			if CurrentCharacter == Character then
				if #CharHats > 0 then
					ReanimOkay = true
				end
				if HatReanimator.HasPermadeath and not IsRespawning and HatReanimator.IWantAllHats then
					if NumHats > #CharHats then
						HatReanimator.Status.Permadeath = "Some hats died. Respawning!"
						Respawn()
					else
						local midpoint = Vector3.zero
						local hatsowned = 0
						local hatsnotowned = {}
						for _,v in CharHats do
							local h = v:FindFirstChild("Handle")
							if h and h:IsA("BasePart") then
								if IsNetworkOwner(h) then
									midpoint += h.Position
									hatsowned += 1
								else
									table.insert(hatsnotowned, h)
								end
							end
						end
						midpoint /= hatsowned
						for _,v in hatsnotowned do
							if (v.Position - midpoint).Magnitude > 2000 then
								HatReanimator.Status.Permadeath = "Some hats unclaimable. Respawning!"
								Respawn()
								break
							end
						end
						hatsnotowned = nil
					end
				end
			end
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			if Humanoid then
				if Humanoid.WalkSpeed < 1 then
					Humanoid.WalkSpeed = 16
				end
				if Humanoid.JumpPower < 1 then
					Humanoid.JumpPower = 50
				end
				if Camera then
					local controllerHumanoid = ReanimCharacter and ReanimCharacter:FindFirstChildOfClass("Humanoid")
					Camera.CameraSubject = controllerHumanoid or HatReanimator.StaticRoot or Humanoid
				end
			end
		end
		debug.profileend()
		debug.profilebegin("Uhhhhhh > BaseParts")
		local RCRootPart = ReanimCharacter and ReanimCharacter:FindFirstChild("HumanoidRootPart")
		HatReanimator.StaticRoot = RCRootPart
		local ltm = Reanimate.LocalTransparencyModifier
		for _,v in BaseParts do
			v.CanCollide = false
			v.LocalTransparencyModifier = ltm
		end
		debug.profileend()
		debug.profilebegin("Uhhhhhh > ReanimOkay")
		local t = os.clock()
		local slocked = {}
		if ReanimOkay then
			local dt = RunService.Heartbeat:Wait()
			if HatReanimator.RebuildRequired then
				RefreshHatMap(Character)
			end
			if RCRootPart then
				local rightarm = ReanimCharacter:FindFirstChild("Right Arm") or RCRootPart
				local rightgrip = Util.ScaleCFrame(RIGHTGRIP_C0, Reanimate.CharacterScale)
				local claimoverride = nil
				local toolequipped = false
				local toolactivate = false
				local toolactivated = nil
				local handlethese = {}
				debug.profilebegin("Uhhhhhh > CharTools")
				for _,v in CharTools do
					local handle = v:FindFirstChild("Handle")
					if handle and handle:IsA("BasePart") then
						handle.CanCollide = false
						handle.LocalTransparencyModifier = ltm
						if HatReanimator.ToolHolding then
							handlethese[handle] = rightarm.CFrame * rightgrip * v.Grip:Inverse()
						else
							handlethese[handle] = RCRootPart.CFrame + Vector3.new(0, -12, 0)
						end
						if not IsNetworkOwner(handle) then
							local a = Player:GetNetworkPing() + 0.2 + math.sin(t * 30) * 0.2
							claimoverride = handle.CFrame
							claimoverride += handle.Velocity * a
							claimoverride += Vector3.new(0, -workspace.Gravity, 0) * 0.5 * a * a
						end
					end
					if not v:GetAttribute("_Uhhhhhh_ActivateConn") then
						v:SetAttribute("_Uhhhhhh_ActivateConn", true)
						v.Activated:Connect(function()
							v:SetAttribute("_Uhhhhhh_Activate", true)
						end)
					end
					if v:GetAttribute("_Uhhhhhh_Activate") then
						v:SetAttribute("_Uhhhhhh_Activate", nil)
						toolactivate = true
						toolactivated = v
					end
					v.Enabled = true
					v.RequiresHandle = false
					v.ManualActivationOnly = false
				end
				if #CharTools > 0 and HatReanimator.ToolHolding then
					local FakeTool = ReanimCharacter:FindFirstChildOfClass("Tool")
					if not FakeTool then
						toolequipped = true
						FakeTool = Instance.new("Tool")
						FakeTool.Name = "faketool"
						local FakeToolHandle = Instance.new("Part")
						FakeToolHandle.Name = "Handle"
						FakeToolHandle.Transparency = 1
						FakeToolHandle.Color = Color3.new(0, 0, 1)
						FakeToolHandle.CanCollide = false
						FakeToolHandle.Massless = true
						FakeToolHandle.Parent = FakeTool
						FakeTool.Parent = ReanimCharacter
						local RightGrip = Instance.new("Weld")
						RightGrip.Name = "RightGrip"
						RightGrip.Parent = FakeToolHandle
						RightGrip.Part0 = rightarm
						RightGrip.Part1 = FakeToolHandle
						RightGrip.C0 = RIGHTGRIP_C0
						Util.LinkDestroyI2C(FakeTool, FakeTool:GetPropertyChangedSignal("Grip"):Connect(function()
							RightGrip.C1 = FakeTool.Grip
						end))
						RightGrip.C1 = FakeTool.Grip
					end
					if HatReanimator.ToolAnimMethod == 1 then
						if toolequipped then
							local sound = Instance.new("Sound")
							sound.Name = "snd"
							sound.SoundId = "rbxasset://sounds/unsheath.wav"
							sound.Volume = 1
							sound.Parent = FakeTool:FindFirstChild("Handle")
							sound:Play()
							Debris:AddItem(sound, 1)
						end
						if toolactivate then
							local newuse = FakeTool:GetAttribute("_Uhhhhhh_Sword_CD") or 0
							local lastuse = FakeTool:GetAttribute("_Uhhhhhh_Sword_LU") or 0
							if t > newuse then
								if t - lastuse < 0.2 then
									newuse = t + 1
									local toolanim = Instance.new("StringValue")
									toolanim.Name = "toolanim"
									toolanim.Value = "Lunge"
									toolanim.Parent = FakeTool
									local sound = Instance.new("Sound")
									sound.Name = "snd"
									sound.SoundId = "rbxasset://sounds/swordlunge.wav"
									sound.Volume = 1
									sound.Parent = FakeTool:FindFirstChild("Handle")
									sound:Play()
									Debris:AddItem(toolanim, 1)
									Debris:AddItem(sound, 1)
									task.spawn(function(v)
										v.GripForward = Vector3.new(0, 0, 1)
										v.GripRight = Vector3.new(0, -1, 0)
										v.GripUp = Vector3.new(-1, 0, 0)
										task.wait(1)
										v.GripForward = Vector3.new(-1, 0, 0)
										v.GripRight = Vector3.new(0, 1, 0)
										v.GripUp = Vector3.new(0, 0, 1)
									end, toolactivated)
								else
									newuse = t + 0.05
									local toolanim = Instance.new("StringValue")
									toolanim.Name = "toolanim"
									toolanim.Value = "Slash"
									toolanim.Parent = FakeTool
									local sound = Instance.new("Sound")
									sound.Name = "snd"
									sound.SoundId = "rbxasset://sounds/swordslash.wav"
									sound.Volume = 1
									sound.Parent = FakeTool:FindFirstChild("Handle")
									sound:Play()
									Debris:AddItem(toolanim, 1)
									Debris:AddItem(sound, 1)
								end
								lastuse = t
							end
							FakeTool:SetAttribute("_Uhhhhhh_Sword_CD", newuse)
							FakeTool:SetAttribute("_Uhhhhhh_Sword_LU", lastuse)
						end
					end
				else
					local FakeTool = ReanimCharacter:FindFirstChildOfClass("Tool")
					if FakeTool then FakeTool:Destroy() end
				end
				debug.profileend()
				debug.profilebegin("Uhhhhhh > FlingLogic")
				local flingtarget = nil
				local flingcf, flinged = CFrame.identity, true
				if t > letitgo then
					flingtarget = HatReanimator.FlingTargets[1]
					if flingtarget then
						if - HatReanimator.FlingMethod == 0 then
							Respawn()
							flingtarget.Time = nil
							flingtarget = nil
						else
							if flingtarget.Time then
								if t > flingtarget.Time then
									table.remove(HatReanimator.FlingTargets, 1)
									flingtarget = nil
								end
							else
								flingtarget.Time = t + (flingtarget.Duration or (Reanimate.UsePhysicsRepRootPart and Reanimate.PhysicsRepRootPartFling or 2))
							end
						end
					end
					if flingtarget then
						flingcf, flinged = Util.PredictionFling(flingtarget.Target)
						if flinged then
							table.remove(HatReanimator.FlingTargets, 1)
							flingtarget = nil
							letitgo = t + 0.1
						end
					end
				end
				local blacklist = {}
				if flingtarget then
					local flingpart = Reanimate.UsePhysicsRepRootPart and Util.PredictionFlingPart(flingtarget.Target) or nil
					if HatReanimator.FlingMethod == 1 then
						local biggest = nil
						local biggesthat = nil
						local biggestarea = 0
						for _,hat in CharHats do
							local handle = hat:FindFirstChild("Handle")
							if handle and handle:IsA("BasePart") and handle:GetAttribute("_Uhhhhhh_HasCollide") and IsNetworkOwner(handle) then
								local area = handle.Size.X * handle.Size.Y * handle.Size.Z
								if biggestarea < area then
									biggest = handle
									biggesthat = hat
									biggestarea = area
								end
							end
						end
						if biggesthat then
							blacklist[biggesthat] = true
							SetUACFrameNetless(biggest, dt, flingcf, Vector3.zero, false, true)
							pcall(sethiddenproperty, biggest, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and flingpart or nil)
						end
					end
					if HatReanimator.FlingMethod == 2 then
						local collide = false
						for _,hat in CharHats do
							local handle = hat:FindFirstChild("Handle")
							if handle and handle:IsA("BasePart") then
								if handle:GetAttribute("_Uhhhhhh_HasCollide") then
									collide = true
								end
							end
						end
						if collide then
							for _,hat in CharHats do
								local handle = hat:FindFirstChild("Handle")
								if handle and handle:IsA("BasePart") then
									blacklist[hat] = true
									SetUACFrameNetless(handle, dt, flingcf, Vector3.zero, false, true)
									pcall(sethiddenproperty, handle, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and flingpart or nil)
								end
							end
						end
					end
					if HatReanimator.FlingMethod == 3 then
						for handle, cf in handlethese do
							blacklist[handle] = true
							SetUACFrameNetless(handle, dt, flingcf, Vector3.zero, false, true)
							pcall(sethiddenproperty, handle, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and flingpart or nil)
						end
					end
					if HatReanimator.FlingMethod == 10 then
						RunDamageMethod(ReanimCharacter,RootPart,RootPart.CFrame,RootPart.AssemblyLinearVelocity,flingtarget,flingcf,"HAT")
					end
				end
				debug.profileend()
				debug.profilebegin("Uhhhhhh > Alignments")
				for _,hat in CharHats do
					local handle = hat:FindFirstChild("Handle")
					if handle and handle:IsA("BasePart") then
						handle.CanCollide = false
						local lltm = ltm
						if Reanimate.FirstPersonBody then
							if not handle:GetAttribute("AttachHead") then
								lltm = 0
							end
						end
						handle.LocalTransparencyModifier = lltm
						local ref = Hat2HatRefs[hat]
						if blacklist[hat] then
							if ref then ref.Aligned = false end
						else
							if claimoverride then
								SetUACFrameNetless(handle, dt, claimoverride, Vector3.zero, false, false)
								pcall(sethiddenproperty, handle, "PhysicsRepRootPart", nil)
								if ref then ref.Aligned = false end
							else
								local mapped = nil
								if ref then
									mapped = GetHatMappedOverride(ref.Map)
								else
									RefHatToHatRefs(hat)
								end
								local bodyHideTarget = HatReanimator.BodyHideTargets[handle] or {}
								bodyHideTarget.PartName = mapped and mapped.Limb or nil
								bodyHideTarget.Accessory = not (ref and ref.Map and ref.Map.BodyProxy)
								bodyHideTarget.Physical = true
								HatReanimator.BodyHideTargets[handle] = bodyHideTarget
								local tcf, tvel = GetHatMappedCFrame(mapped)
								tcf = tcf or RCRootPart.CFrame * CFrame.new(0, 5, 0)
								tvel = tvel or Vector3.zero
								if mapped and type(Reanimate.ResolveBodyHideTargetCFrame) == "function" then
									local resolved, redirected = pcall(Reanimate.ResolveBodyHideTargetCFrame,handle,tcf,mapped.Limb,bodyHideTarget.Accessory)
									if resolved and typeof(redirected) == "CFrame" then
										tcf = redirected
									end
								end
								local aligned = SetUACFrameNetless(handle, dt, tcf, tvel, HatReanimator.HatFling, HatReanimator.HatSpin)
								if aligned then
									table.insert(slocked, handle)
								end
								if ref then ref.Aligned = aligned end
								pcall(sethiddenproperty, handle, "PhysicsRepRootPart", mapped and mapped.RepRootPart)
							end
						end
					end
				end
				for handle, cf in handlethese do
					if not blacklist[handle] then
						if SetUACFrameNetless(handle, dt, cf, rightarm.Velocity, HatReanimator.HatFling, HatReanimator.HatSpin) then
							table.insert(slocked, handle)
						end
					end
				end
				debug.profileend()
			end
		else
			if CurrentCharacter then
				CurrentCharacter = nil
				--replicatesignal(Player.ConnectDiedSignalBackend)
			end
		end
		debug.profilebegin("Uhhhhhh > Placeholders")
		for _,ref in HatRefs do
			local ph = ref.PH
			if ph then
				local mapped = GetHatMappedOverride(ref.Map)
				local bodyHideTarget = HatReanimator.BodyHideTargets[ph] or {}
				bodyHideTarget.PartName = mapped and mapped.Limb or nil
				bodyHideTarget.Accessory = not (ref.Map and ref.Map.BodyProxy)
				bodyHideTarget.Physical = false
				HatReanimator.BodyHideTargets[ph] = bodyHideTarget
				if ReanimOkay and ref.Hat and ref.Aligned then
					ph.Transparency = 1
				else
					local tcf, _ = GetHatMappedCFrame(mapped)
					if tcf then
						local lltm = ltm
						if Reanimate.FirstPersonBody then
							if not ph:GetAttribute("AttachHead") then
								lltm = 0
							end
						end
						ph.CFrame = tcf
						ph.Transparency = 1 - (1 - Reanimate.PlaceholderTransparency) * (1 - lltm)
						table.insert(slocked, ph)
					end
				end
			end
		end
		debug.profileend()
		RunService.PreRender:Wait()
		debug.profilebegin("Uhhhhhh > PreRender")
		if RCRootPart and Reanimate:ShouldRotationType() then
			Reanimate:CameraLockCharacter()
		end
		for _,ref in HatRefs do
			local ph = ref.PH
			if ph then
				if ReanimOkay and ref.Hat and ref.Aligned then else
					local tcf, _ = GetHatMappedCFrame(GetHatMappedOverride(ref.Map))
					if tcf then
						ph.CFrame = tcf
					end
				end
			end
		end
		if HatReanimator.HatSpin then
			for _,handle in slocked do
				if math.random() < 0.5 then
					handle.CFrame = handle.CFrame * CFrame.Angles(math.random() * 2 * math.pi, math.random() * 2 * math.pi, math.random() * 2 * math.pi)
				end
			end
		end
		debug.profileend()
	end
	ResetHatRefs()
	for _,v in HatRefs do if v.PH then v.PH:Destroy() end end
	CharConn:Disconnect()
	local activeRealCharacter = HatReanimator.ActiveRealCharacter
	local controllerCharacter = Reanimate.Character
	if activeRealCharacter and activeRealCharacter.Parent then
		if controllerCharacter and activeRealCharacter:IsDescendantOf(controllerCharacter) then
			pcall(function()
				activeRealCharacter.Parent = workspace
			end)
		end
		if Player.Character == controllerCharacter then
			pcall(function()
				Player.Character = activeRealCharacter
			end)
			local activeHumanoid = activeRealCharacter:FindFirstChildOfClass("Humanoid")
			if Camera and activeHumanoid then
				pcall(function()
					Camera.CameraType = Enum.CameraType.Custom
					Camera.CameraSubject = activeHumanoid
				end)
			end
		end
	end
	HatReanimator.DontFireCharAddOnThisChar = nil
	local global = (getgenv and getgenv()) or shared or _G
	if global.RealChar == activeRealCharacter then
		global.RealChar = nil
	end
	HatReanimator.StaticRoot = nil
	HatReanimator.ActiveRealCharacter = nil
	HatReanimator.RigGeneration += 1
	table.clear(HatReanimator.CollidableHandles)
	--replicatesignal(Player.ConnectDiedSignalBackend)
	Reanimate.Stopping = false
	Reanimate.DestroyCharacter()
end

task.wait()
Util.ResolveCharacterHitboxPart = function(character, preferTorso)
	if typeof(character) ~= "Instance" or not character:IsA("Model") or not character.Parent then
		return nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = humanoid and humanoid.RootPart or character:FindFirstChild("HumanoidRootPart")
	if root and (not root:IsA("BasePart") or not root:IsDescendantOf(character)) then
		root = nil
	end
	local torso = nil
	if preferTorso then
		-- RootJoint.Part1 identifies the torso currently connected to this rig even
		-- while an experience is replacing parts in-place and briefly leaves two
		-- children with the same name in the model.
		local rootJoint = root and root:FindFirstChild("RootJoint")
		if rootJoint and Util.IsCharacterJoint(rootJoint) then
			local _, jointTorso = Util.GetCharacterJointParts(rootJoint)
			if jointTorso and jointTorso:IsA("BasePart") and jointTorso:IsDescendantOf(character) then
				torso = jointTorso
			end
		end
		if not torso then
			if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
				torso = character:FindFirstChild("LowerTorso") or character:FindFirstChild("UpperTorso")
			else
				torso = character:FindFirstChild("Torso")
			end
		end
		if not torso then
			torso = character:FindFirstChild("Torso")
				or character:FindFirstChild("LowerTorso")
				or character:FindFirstChild("UpperTorso")
		end
		if torso and torso:IsA("BasePart") and torso:IsDescendantOf(character) then
			return torso
		end
	end
	return root
end
Reanimate.ResolveHitboxTargets = function()
	local reanimator = Reanimate.Current
	local preferTorso = reanimator == LimbReanimator
	local originalCharacter = Player.Character
	if reanimator then
		local boundCharacter = reanimator.ActiveRealCharacter or reanimator.RealCharacter
		if boundCharacter and boundCharacter:IsA("Model") and boundCharacter.Parent then
			originalCharacter = boundCharacter
		end
	end
	if originalCharacter == Reanimate.Character then
		originalCharacter = nil
	end
	local staticRoot = reanimator and reanimator.StaticRoot
	local reanimatedPart = staticRoot
	if typeof(reanimatedPart) ~= "Instance"
		or not reanimatedPart:IsA("BasePart")
		or not reanimatedPart:IsDescendantOf(workspace)
	then
		reanimatedPart = Util.ResolveCharacterHitboxPart(Reanimate.Character, false)
	end
	return Util.ResolveCharacterHitboxPart(originalCharacter, preferTorso),
		-- External backends may retain an anchored static tracker while Roblox is
		-- replacing the physical shell. Cyan follows that tracker across the gap.
		reanimatedPart
end
local function ClearReanimateHitboxes()
	for _, child in SCREENGUI:GetChildren() do
		if child.Name == "TempWireframe" then
			child:Destroy()
		end
	end
end
local function ReanimateShowHitboxes()
	ClearReanimateHitboxes()
	if not Reanimate.ShowHitboxes then
		Reanimate._HitboxOriginalPart = nil
		Reanimate._HitboxReanimatedPart = nil
		Reanimate._HitboxReanimator = nil
		Reanimate._HitboxRigGeneration = -1
		return false
	end
	local Reanimator = Reanimate.Current
	if Reanimator and Reanimator.ShowHitboxes then
		Reanimator.ShowHitboxes()
	end
	local originalPart, reanimatedPart = Reanimate.ResolveHitboxTargets()
	Reanimate._HitboxOriginalPart = originalPart
	Reanimate._HitboxReanimatedPart = reanimatedPart
	Reanimate._HitboxReanimator = Reanimator
	Reanimate._HitboxRigGeneration = tonumber(Reanimator and Reanimator.RigGeneration) or 0
	if originalPart then
		Util.ShowPartHitbox(originalPart, Color3.fromRGB(255, 70, 70), 0)
	end
	if reanimatedPart and reanimatedPart ~= originalPart then
		Util.ShowPartHitbox(reanimatedPart, Color3.fromRGB(40, 190, 255), 0)
	end
	return true
end
local LastReanimateHitboxRefresh = -math.huge
RunService.Heartbeat:Connect(function()
	if Reanimate.ShowHitboxes then
		local now = os.clock()
		local originalPart, reanimatedPart = Reanimate.ResolveHitboxTargets()
		local rigGeneration = tonumber(Reanimate.Current and Reanimate.Current.RigGeneration) or 0
		if originalPart ~= Reanimate._HitboxOriginalPart or reanimatedPart ~= Reanimate._HitboxReanimatedPart or Reanimate.Current ~= Reanimate._HitboxReanimator or rigGeneration ~= Reanimate._HitboxRigGeneration or now - LastReanimateHitboxRefresh >= 0.5 then
			LastReanimateHitboxRefresh = now
			ReanimateShowHitboxes()
		end
	elseif LastReanimateHitboxRefresh ~= -math.huge then
		ClearReanimateHitboxes()
		LastReanimateHitboxRefresh = -math.huge
		Reanimate._HitboxOriginalPart = nil
		Reanimate._HitboxReanimatedPart = nil
		Reanimate._HitboxReanimator = nil
		Reanimate._HitboxRigGeneration = -1
	end
end)
local function ReanimateFling(target, duration)
	local Reanimator = Reanimate.Current
	if Reanimator and Reanimator.Fling then
		return Reanimator.Fling(target, duration)
	end
	return false
end
-- SetCharacter thing, very empyrean-like system
_G_Uhhhhhh.Fling = function(part)
	if part and part.Parent then
		if part:IsA("BasePart") then
			part = part.Parent
			if part:IsA("Accessory") or part:IsA("Tool") then
				part = part.Parent
			end
		end
		local hum = part:FindFirstChildOfClass("Humanoid")
		if hum and hum.RootPart and not hum.RootPart:IsGrounded() then
			return ReanimateFling(part)
		end
	end
end

do
	SaveData.SelectedReanimator = SaveData.SelectedReanimator or 1
	local ReanimateMethodSelect = UI.CreateDropdown(MainPage, "Reanimator", {"Limb Reanimator", "Hats Reanimator"}, SaveData.SelectedReanimator)
	local ReanimatorConfigTitle = UI.CreateText(MainPage, "-=+ Limb Reanimator Config +=-", 15, Enum.TextXAlignment.Center)
	local SelectedReanimator = LimbReanimator
	if SaveData.SelectedReanimator == 2 then
		SelectedReanimator = HatReanimator
		ReanimatorConfigTitle.Text = "-=+ Hats Reanimator Config +=-"
	end
	local ReanimatorConfigCanvas = UI.CreateCanvas(MainPage)
	ReanimateMethodSelect.Changed:Connect(function(value)
		SaveData.SelectedReanimator = value
		if value == 1 then
			SelectedReanimator = LimbReanimator
			ReanimatorConfigTitle.Text = "-=+ Limb Reanimator Config +=-"
		end
		if value == 2 then
			SelectedReanimator = HatReanimator
			ReanimatorConfigTitle.Text = "-=+ Hats Reanimator Config +=-"
		end
		Util.ClearAllChildrenGui(ReanimatorConfigCanvas)
		SelectedReanimator.Config(ReanimatorConfigCanvas)
	end)
	SelectedReanimator.Config(ReanimatorConfigCanvas)
	UI.CreateText(MainPage, " ", 5, Enum.TextXAlignment.Center)
	local ReanimateText = UI.CreateText(MainPage, "Running: NONE", 15, Enum.TextXAlignment.Center)
	local ReanimateStartButton, ReanimateStartButtonText = UI.CreateButton(MainPage, "* Reanimate *", 20)
	ReanimateStartButton.Activated:Connect(function()
		ReanimateStartButton.Interactable = false
		if Reanimate.Current then
			ReanimateStartButtonText.Text = "Stopping..."
			Reanimate.Stopping = true
			repeat task.wait() until not Reanimate.Stopping
			Reanimate.Current.Running = nil
			Reanimate.Current = nil
			HumanoidLASetHookState(false)
			ReanimateText.Text = "Running: NONE"
			task.wait(1)
			ReanimateStartButtonText.Text = "* Reanimate *"
		else
			ReanimateStartButtonText.Text = "Starting..."
			Reanimate.Starting = true
			Reanimate.Current = SelectedReanimator
			HumanoidLASetHookState(Reanimate.UseLoadAnimationHook)
			ReanimateText.Text = "Running: " .. Reanimate.Current.Name
			task.spawn(Reanimate.Current.Start)
			repeat task.wait() until not Reanimate.Starting
			Reanimate.Current.Running = true
			task.wait(1)
			ReanimateStartButtonText.Text = "* Deanimate *"
		end
		ReanimateStartButton.Interactable = true
	end)
	UI.CreateSwitch(MainPage, "Show Reanimate Hitboxes", Reanimate.ShowHitboxes).Changed:Connect(function(value)
		Reanimate.ShowHitboxes = value
		SaveData.ShowReanimateHitboxes = value
		ReanimateShowHitboxes()
	end)
	UI.CreateText(MainPage,"red = bound real torso/root | cyan = controller rootpart | green = collidable hats",10,Enum.TextXAlignment.Center)
	UI.CreateButton(MainPage, "Refresh Reanimate Character", 10).Activated:Connect(function()
		if not Reanimate.Character then return end
		Reanimate.CreateCharacter()
	end)
end
UI.CreateSeparator(MainPage)

if type(SaveData.AnimLibOptions) ~= "table" then
	SaveData.AnimLibOptions = {}
end
local SavedAnimLibOptions = SaveData.AnimLibOptions
SavedAnimLibOptions.Speed = math.clamp(tonumber(SavedAnimLibOptions.Speed) or 1, 0.25, 2)
SavedAnimLibOptions.FadeIn = math.clamp(tonumber(SavedAnimLibOptions.FadeIn) or 0, 0, 1)
SavedAnimLibOptions.JointPreset = type(SavedAnimLibOptions.JointPreset) == "string" and SavedAnimLibOptions.JointPreset or "Full Body"
SavedAnimLibOptions.SyncToDanceMusic = SavedAnimLibOptions.SyncToDanceMusic == true
SavedAnimLibOptions.ApplySpeedToMusic = SavedAnimLibOptions.ApplySpeedToMusic == true
SavedAnimLibOptions.MarkerNotifications = SavedAnimLibOptions.MarkerNotifications == true
SavedAnimLibOptions.ResetPoseOnStop = SavedAnimLibOptions.ResetPoseOnStop == true
SavedAnimLibOptions.KrystalHeadTracking = SavedAnimLibOptions.KrystalHeadTracking == true
SavedAnimLibOptions.KrystalHeadOverride = SavedAnimLibOptions.KrystalHeadOverride ~= false
SavedAnimLibOptions.KrystalHeadStrength = math.clamp(tonumber(SavedAnimLibOptions.KrystalHeadStrength) or 1, 0, 1.5)
SavedAnimLibOptions.KrystalHeadSmoothing = math.clamp(tonumber(SavedAnimLibOptions.KrystalHeadSmoothing) or 10, 1, 30)
SavedAnimLibOptions.KeepAccessoriesWhenHiding = SavedAnimLibOptions.KeepAccessoriesWhenHiding ~= false
if type(SavedAnimLibOptions.HiddenBodyParts) ~= "table" then
	SavedAnimLibOptions.HiddenBodyParts = {}
end
for partName, hidden in SavedAnimLibOptions.HiddenBodyParts do
	if type(partName) ~= "string" or hidden ~= true then
		SavedAnimLibOptions.HiddenBodyParts[partName] = nil
	end
end

local function ParseDanceEffectColor(value)
	if type(value) ~= "string" then
		return nil
	end
	local text = value:match("^%s*(.-)%s*$") or ""
	local hex = text:gsub("^#", ""):gsub("^0[xX]", "")
	if hex:match("^%x%x%x%x%x%x$") then
		local success, color = pcall(Color3.fromHex, hex)
		if success then
			return color, color:ToHex():upper()
		end
	end
	local rgb = text:gsub("^%s*[rR][gG][bB]%s*%(", ""):gsub("%)%s*$", "")
	local red, green, blue = rgb:match("^%s*([%+%-]?[%d%.]+)%s*,%s*([%+%-]?[%d%.]+)%s*,%s*([%+%-]?[%d%.]+)%s*$")
	red, green, blue = tonumber(red), tonumber(green), tonumber(blue)
	if
		red
		and green
		and blue
		and red >= 0
		and red <= 255
		and green >= 0
		and green <= 255
		and blue >= 0
		and blue <= 255
	then
		local color = Color3.fromRGB(math.round(red), math.round(green), math.round(blue))
		return color, color:ToHex():upper()
	end
	return nil
end

if type(SaveData.DanceEffectsOptions) ~= "table" then
	SaveData.DanceEffectsOptions = {}
end
local DanceEffectAnchorModes = { "Center of Mass", "Torso", "Blue Root Part", "Head", "Middle (Original)" }
local SavedDanceEffectsOptions = SaveData.DanceEffectsOptions
SavedDanceEffectsOptions.VisualizerEnabled = SavedDanceEffectsOptions.VisualizerEnabled == true
SavedDanceEffectsOptions.AfterimageEnabled = SavedDanceEffectsOptions.AfterimageEnabled == true
SavedDanceEffectsOptions.DynamicPosition = SavedDanceEffectsOptions.DynamicPosition == true
SavedDanceEffectsOptions.StayVertical = SavedDanceEffectsOptions.StayVertical ~= false
local _, SavedDanceEffectsAccent = ParseDanceEffectColor(SavedDanceEffectsOptions.Accent or "00FFFF")
SavedDanceEffectsOptions.Accent = SavedDanceEffectsAccent or "00FFFF"
SavedDanceEffectsOptions.OffsetX = math.clamp(tonumber(SavedDanceEffectsOptions.OffsetX) or 0, -10, 10)
SavedDanceEffectsOptions.OffsetY = math.clamp(tonumber(SavedDanceEffectsOptions.OffsetY) or 3.2, -5, 10)
SavedDanceEffectsOptions.OffsetZ = math.clamp(tonumber(SavedDanceEffectsOptions.OffsetZ) or 0, -10, 10)
SavedDanceEffectsOptions.Size = math.clamp(tonumber(SavedDanceEffectsOptions.Size) or 1, 0.25, 3)
SavedDanceEffectsOptions.RotationX = math.clamp(tonumber(SavedDanceEffectsOptions.RotationX) or 0, -180, 180)
SavedDanceEffectsOptions.RotationY = math.clamp(tonumber(SavedDanceEffectsOptions.RotationY) or 0, -180, 180)
SavedDanceEffectsOptions.RotationZ = math.clamp(tonumber(SavedDanceEffectsOptions.RotationZ) or 0, -180, 180)
local LegacyAfterimageSpeed = math.clamp(tonumber(SavedDanceEffectsOptions.AfterimageSpeed) or 1, 0.25, 4)
SavedDanceEffectsOptions.AfterimageSpawnRate = math.clamp(
	tonumber(SavedDanceEffectsOptions.AfterimageSpawnRate) or LegacyAfterimageSpeed,
	0.25,
	4
)
SavedDanceEffectsOptions.AfterimageFadeSpeed = math.clamp(
	tonumber(SavedDanceEffectsOptions.AfterimageFadeSpeed) or LegacyAfterimageSpeed,
	0.25,
	4
)
SavedDanceEffectsOptions.AfterimageScale = math.clamp(
	tonumber(SavedDanceEffectsOptions.AfterimageScale) or 0.86,
	0.25,
	1.5
)
SavedDanceEffectsOptions.AfterimageTransparency = math.clamp(
	tonumber(SavedDanceEffectsOptions.AfterimageTransparency) or 55,
	0,
	100
)
SavedDanceEffectsOptions.AfterimageGlowEnabled = SavedDanceEffectsOptions.AfterimageGlowEnabled ~= false
SavedDanceEffectsOptions.AfterimageGlowBrightness = math.clamp(
	tonumber(SavedDanceEffectsOptions.AfterimageGlowBrightness) or 1.5,
	0,
	10
)
SavedDanceEffectsOptions.AfterimageGlowRange = math.clamp(
	tonumber(SavedDanceEffectsOptions.AfterimageGlowRange) or 7,
	0,
	30
)
if type(SavedDanceEffectsOptions.AfterimageHiddenParts) ~= "table" then
	SavedDanceEffectsOptions.AfterimageHiddenParts = {}
end
for partName, hidden in SavedDanceEffectsOptions.AfterimageHiddenParts do
	if type(partName) ~= "string" or hidden ~= true then
		SavedDanceEffectsOptions.AfterimageHiddenParts[partName] = nil
	end
end
SavedDanceEffectsOptions.AnchorMode = table.find(DanceEffectAnchorModes, SavedDanceEffectsOptions.AnchorMode)
		and SavedDanceEffectsOptions.AnchorMode
	or "Center of Mass"

local AnimLib = {
	Version = "1.8.6",
	Settings = {
		Speed = SavedAnimLibOptions.Speed,
		FadeIn = SavedAnimLibOptions.FadeIn,
		JointPreset = SavedAnimLibOptions.JointPreset,
		SyncToDanceMusic = SavedAnimLibOptions.SyncToDanceMusic,
		ApplySpeedToMusic = SavedAnimLibOptions.ApplySpeedToMusic,
		MarkerNotifications = SavedAnimLibOptions.MarkerNotifications,
		ResetPoseOnStop = SavedAnimLibOptions.ResetPoseOnStop,
		KrystalHeadTracking = SavedAnimLibOptions.KrystalHeadTracking,
		KrystalHeadOverride = SavedAnimLibOptions.KrystalHeadOverride,
		KrystalHeadStrength = SavedAnimLibOptions.KrystalHeadStrength,
		KrystalHeadSmoothing = SavedAnimLibOptions.KrystalHeadSmoothing,
		KeepAccessoriesWhenHiding = SavedAnimLibOptions.KeepAccessoriesWhenHiding,
		HiddenBodyParts = SavedAnimLibOptions.HiddenBodyParts,
		DanceEffects = SavedDanceEffectsOptions,
		DanceSoundProvider = function()
			return UISound.DanceMusic
		end,
	},
}

do
	local function CleanupItem(item)
		local success, reason = pcall(function()
			local itemType = typeof(item)
			if itemType == "RBXScriptConnection" then
				if item.Connected then
					item:Disconnect()
				end
			elseif itemType == "Instance" then
				item:Destroy()
			elseif type(item) == "thread" then
				task.cancel(item)
			elseif type(item) == "function" then
				item()
			elseif type(item) == "table" then
				if type(item.Disconnect) == "function" then
					item:Disconnect()
				elseif type(item.Destroy) == "function" then
					item:Destroy()
				end
			end
		end)
		if not success then
			warn("AnimLib cleanup failed: " .. tostring(reason))
		end
	end

	local ConnectionGroup = {}
	ConnectionGroup.__index = ConnectionGroup
	function ConnectionGroup.new()
		local self = setmetatable({}, ConnectionGroup)
		self._items = {}
		self._destroyed = false
		return self
	end
	function ConnectionGroup:Add(item)
		assert(not self._destroyed, "cannot add to a destroyed ConnectionGroup")
		if item ~= nil then
			table.insert(self._items, item)
		end
		return item
	end
	function ConnectionGroup:Remove(item, cleanup)
		local index = table.find(self._items, item)
		if not index then
			return nil
		end
		local removed = table.remove(self._items, index)
		if cleanup then
			CleanupItem(removed)
		end
		return removed
	end
	function ConnectionGroup:Count()
		return #self._items
	end
	function ConnectionGroup:Cleanup()
		local items = self._items
		self._items = {}
		for index = #items, 1, -1 do
			CleanupItem(items[index])
		end
		return self
	end
	function ConnectionGroup:LinkToInstance(instance)
		assert(typeof(instance) == "Instance", "instance must be an Instance")
		self:Add(instance.Destroying:Connect(function()
			self:Cleanup()
		end))
		return self
	end
	function ConnectionGroup:Destroy()
		if self._destroyed then
			return
		end
		self:Cleanup()
		self._destroyed = true
	end
	AnimLib.ConnectionGroup = ConnectionGroup

	local SupportedRunSignals = {
		PreAnimation = true,
		PreSimulation = true,
		PostSimulation = true,
		Heartbeat = true,
		RenderStepped = true,
	}
	local function ResolveRunSignal(signal, defaultName)
		if typeof(signal) == "RBXScriptSignal" then
			return signal, "Custom"
		end
		signal = signal or defaultName or "PreAnimation"
		assert(
			type(signal) == "string" and SupportedRunSignals[signal],
			"unsupported RunService signal: " .. tostring(signal)
		)
		local success, resolved = pcall(function()
			return RunService[signal]
		end)
		assert(success and typeof(resolved) == "RBXScriptSignal", "RunService signal is unavailable: " .. signal)
		return resolved, signal
	end
	local Track = {}
	local TrackFileCache = {}
	local function SortAndUpdateTrackTime(track)
		track.Time = 0
		table.sort(track.Keyframes, function(a, b)
			return a.Time < b.Time
		end)
		for _, keyframe in track.Keyframes do
			track.Time = math.max(track.Time, keyframe.Time)
		end
		if track.Markers then
			table.sort(track.Markers, function(a, b)
				return a.Time < b.Time
			end)
			for _, marker in track.Markers do
				track.Time = math.max(track.Time, marker.Time)
			end
		end
		return track
	end
	function Track.new(name)
		return {
			Name = name or "<unknown>",
			Time = 0,
			Keyframes = {},
			Markers = {},
		}
	end
	function Track.validate(track)
		if type(track) ~= "table" then
			return false, "track must be a table"
		end
		if type(track.Keyframes) ~= "table" then
			return false, "track.Keyframes must be a table"
		end
		for keyframeindex, keyframe in track.Keyframes do
			if type(keyframe) ~= "table" then
				return false, "keyframe " .. keyframeindex .. " must be a table"
			end
			if type(keyframe.Time) ~= "number" or keyframe.Time < 0 then
				return false, "keyframe " .. keyframeindex .. " has an invalid time"
			end
			if type(keyframe.Poses) ~= "table" then
				return false, "keyframe " .. keyframeindex .. " poses must be a table"
			end
			for poseindex, pose in keyframe.Poses do
				if type(pose) ~= "table" then
					return false, "pose " .. poseindex .. " in keyframe " .. keyframeindex .. " must be a table"
				end
				if type(pose.Name) ~= "string" then
					return false, "pose " .. poseindex .. " has no name"
				end
				if typeof(pose.CFrame) ~= "CFrame" then
					return false, "pose " .. poseindex .. " has no CFrame"
				end
			end
		end
		if track.Markers ~= nil then
			if type(track.Markers) ~= "table" then
				return false, "track.Markers must be a table"
			end
			for markerindex, marker in track.Markers do
				if type(marker) ~= "table" then
					return false, "marker " .. markerindex .. " must be a table"
				end
				if type(marker.Name) ~= "string" or marker.Name == "" then
					return false, "marker " .. markerindex .. " has no name"
				end
				if type(marker.Time) ~= "number" or marker.Time < 0 then
					return false, "marker " .. markerindex .. " has an invalid time"
				end
			end
		end
		return true
	end
	function Track.clone(track)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		return Util.DeepcopyTable(track)
	end
	function Track.getDuration(track)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		local duration = 0
		for _, keyframe in track.Keyframes do
			duration = math.max(duration, keyframe.Time)
		end
		for _, marker in track.Markers or {} do
			duration = math.max(duration, marker.Time)
		end
		track.Time = duration
		return duration
	end
	function Track.sort(track)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		return SortAndUpdateTrackTime(track)
	end
	function Track.addKeyframe(track, time, poses)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		assert(type(time) == "number" and time >= 0, "time must be zero or greater")
		assert(poses == nil or type(poses) == "table", "poses must be a table or nil")
		local keyframe = {
			Time = time,
			Poses = poses and Util.DeepcopyTable(poses) or {},
		}
		table.insert(track.Keyframes, keyframe)
		SortAndUpdateTrackTime(track)
		return keyframe
	end
	function Track.removeKeyframe(track, index)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		assert(type(index) == "number", "index must be a number")
		local removed = table.remove(track.Keyframes, index)
		SortAndUpdateTrackTime(track)
		return removed
	end
	function Track.findKeyframes(track, starttime, endtime)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		starttime = starttime or 0
		endtime = endtime or Track.getDuration(track)
		local found = {}
		for index, keyframe in track.Keyframes do
			if keyframe.Time >= starttime and keyframe.Time <= endtime then
				table.insert(found, { Index = index, Keyframe = keyframe })
			end
		end
		return found
	end
	function Track.addMarker(track, time, name, value)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		assert(type(time) == "number" and time >= 0, "time must be zero or greater")
		assert(type(name) == "string" and name ~= "", "name must be a non-empty string")
		track.Markers = track.Markers or {}
		local marker = {
			Time = time,
			Name = name,
			Value = value,
		}
		table.insert(track.Markers, marker)
		SortAndUpdateTrackTime(track)
		return marker
	end
	function Track.removeMarker(track, index)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		assert(type(index) == "number", "index must be a number")
		track.Markers = track.Markers or {}
		local removed = table.remove(track.Markers, index)
		SortAndUpdateTrackTime(track)
		return removed
	end
	function Track.getMarkers(track, name)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		assert(name == nil or type(name) == "string", "name must be a string or nil")
		local markers = {}
		for _, marker in track.Markers or {} do
			if name == nil or marker.Name == name then
				table.insert(markers, marker)
			end
		end
		return markers
	end
	function Track.getMarkersBetween(track, starttime, endtime, includeStart)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		assert(type(starttime) == "number" and type(endtime) == "number", "starttime and endtime must be numbers")
		local markers = {}
		for _, marker in track.Markers or {} do
			local afterStart = includeStart and marker.Time >= starttime or marker.Time > starttime
			if afterStart and marker.Time <= endtime then
				table.insert(markers, marker)
			end
		end
		return markers
	end
	function Track.frombuffer(buf)
		local needle = 0
		local buflen = buffer.len(buf)
		local function getleft()
			return buflen - needle
		end
		local function readstring()
			assert(getleft() >= 2)
			local len = buffer.readu16(buf, needle)
			needle += 2
			assert(getleft() >= len)
			local val = buffer.readstring(buf, needle, len)
			needle += len
			return val
		end
		local function readsizet()
			assert(getleft() >= 4)
			local val = buffer.readu32(buf, needle)
			needle += 4
			return val
		end
		local function readfloat()
			assert(getleft() >= 4)
			local val = buffer.readf32(buf, needle)
			needle += 4
			return val
		end
		local anim = {
			Name = "<unknown>",
			Time = 0,
			Keyframes = {},
			Markers = {},
		}
		anim.Name = readstring() -- name
		local nkeyframes = readsizet() -- # of keyframes
		for _=1, nkeyframes do
			local t = readfloat() -- time
			anim.Time = math.max(anim.Time, t)
			local nposes = readsizet() -- # of poses
			local keyframe = {
				Time = t,
				Poses = {}
			}
			for _=1, nposes do
				local pose = {}
				pose.Name = readstring() -- "bone" name
				pose.Weight = readfloat() -- weight (usually 1 or 0)
				pose.EasingStyle = readstring() -- EasingStyle
				pose.EasingDirection = readstring() -- EasingDirection
				pose.CFrame = CFrame.new(
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat()
				) -- cframe
				table.insert(keyframe.Poses, pose)
			end
			table.insert(anim.Keyframes, keyframe)
		end
		return SortAndUpdateTrackTime(anim)
	end
	function Track.fromfile(path)
		local s, data = pcall(readfile, path)
		if s and data then
			local buf = buffer.fromstring(data)
			local parsed, track = pcall(Track.frombuffer, buf)
			if parsed then
				return track
			end
			return nil, track
		end
		return nil, data
	end
	function Track.fromfilecached(path, refresh)
		if not refresh and TrackFileCache[path] then
			return Track.clone(TrackFileCache[path])
		end
		local track, reason = Track.fromfile(path)
		if not track then
			return nil, reason
		end
		TrackFileCache[path] = Track.clone(track)
		return track
	end
	function Track.clearfilecache(path)
		if path then
			TrackFileCache[path] = nil
		else
			table.clear(TrackFileCache)
		end
	end
	function Track.frominstance(ks)
		assert(ks and ks:IsA("KeyframeSequence"))
		local anim = {
			Name = "<unknown>",
			Time = 0,
			Keyframes = {},
			Markers = {},
		}
		anim.Name = ks.Name
		for _,k in ks:GetKeyframes() do
			local t = k.Time
			anim.Time = math.max(anim.Time, t)
			local keyframe = {
				Name = k.Name,
				Time = t,
				Poses = {}
			}
			if k.Name ~= "" and k.Name ~= "Keyframe" then
				table.insert(anim.Markers, {
					Name = k.Name,
					Time = t,
					Source = "Keyframe",
				})
			end
			for _, marker in k:GetMarkers() do
				table.insert(anim.Markers, {
					Name = marker.Name,
					Time = t,
					Value = marker.Value,
					Source = "KeyframeMarker",
				})
			end
			for _,p in k:GetDescendants() do
				if not p:IsA("Pose") then continue end
				table.insert(keyframe.Poses, {
					Name = p.Name,
					Weight = p.Weight,
					EasingStyle = p.EasingStyle.Name,
					EasingDirection = p.EasingDirection.Name,
					CFrame = p.CFrame
				})
			end
			table.insert(anim.Keyframes, keyframe)
		end
		return SortAndUpdateTrackTime(anim)
	end
	function Track.paste(target, source, timeoffset)
		local targetvalid, targetreason = Track.validate(target)
		local sourcevalid, sourcereason = Track.validate(source)
		assert(targetvalid, targetreason)
		assert(sourcevalid, sourcereason)
		timeoffset = timeoffset or 0
		assert(type(timeoffset) == "number", "timeoffset must be a number")
		for _,keyframe in source.Keyframes do
			local newkeyframe = Util.DeepcopyTable(keyframe)
			newkeyframe.Time += timeoffset
			assert(newkeyframe.Time >= 0, "timeoffset creates a negative keyframe time")
			table.insert(target.Keyframes, newkeyframe)
		end
		target.Markers = target.Markers or {}
		for _, marker in source.Markers or {} do
			local newmarker = Util.DeepcopyTable(marker)
			newmarker.Time += timeoffset
			assert(newmarker.Time >= 0, "timeoffset creates a negative marker time")
			table.insert(target.Markers, newmarker)
		end
		return SortAndUpdateTrackTime(target)
	end
	function Track.append(target, source, gap)
		gap = gap or 0
		return Track.paste(target, source, Track.getDuration(target) + gap)
	end
	function Track.scaleTime(track, factor)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		assert(type(factor) == "number" and factor > 0, "factor must be greater than zero")
		for _, keyframe in track.Keyframes do
			keyframe.Time *= factor
		end
		for _, marker in track.Markers or {} do
			marker.Time *= factor
		end
		return SortAndUpdateTrackTime(track)
	end
	function Track.reverse(track)
		local reversed = Track.clone(track)
		local duration = Track.getDuration(reversed)
		for _, keyframe in reversed.Keyframes do
			keyframe.Time = duration - keyframe.Time
			for _, pose in keyframe.Poses do
				if pose.EasingDirection == "In" then
					pose.EasingDirection = "Out"
				elseif pose.EasingDirection == "Out" then
					pose.EasingDirection = "In"
				end
			end
		end
		for _, marker in reversed.Markers or {} do
			marker.Time = duration - marker.Time
		end
		return SortAndUpdateTrackTime(reversed)
	end
	function Track.slice(track, starttime, endtime)
		local valid, reason = Track.validate(track)
		assert(valid, reason)
		starttime = math.max(starttime or 0, 0)
		endtime = math.min(endtime or Track.getDuration(track), Track.getDuration(track))
		assert(endtime >= starttime, "endtime must not be before starttime")

		local sliced = Track.new((track.Name or "<unknown>") .. " (slice)")
		local hasStartKeyframe = false
		for _, keyframe in track.Keyframes do
			if keyframe.Time >= starttime and keyframe.Time <= endtime then
				local copy = Util.DeepcopyTable(keyframe)
				copy.Time -= starttime
				if copy.Time == 0 then
					hasStartKeyframe = true
				end
				table.insert(sliced.Keyframes, copy)
			end
		end
		if not hasStartKeyframe and starttime < Track.getDuration(track) then
			local poses = {}
			for name, cframe in Track.getPoses(track, starttime, false) do
				table.insert(poses, {
					Name = name,
					Weight = 1,
					EasingStyle = "Linear",
					EasingDirection = "InOut",
					CFrame = cframe,
				})
			end
			table.insert(sliced.Keyframes, { Time = 0, Poses = poses })
		end
		for _, marker in track.Markers or {} do
			if marker.Time >= starttime and marker.Time <= endtime then
				local copy = Util.DeepcopyTable(marker)
				copy.Time -= starttime
				table.insert(sliced.Markers, copy)
			end
		end
		return SortAndUpdateTrackTime(sliced)
	end
	local function GetEasedAlpha(alpha, easingstyle, easingdirection)
		alpha = math.clamp(alpha, 0, 1)
		if easingstyle == "Constant" then
			if easingdirection == "In" then
				return 1
			end
			if easingdirection == "Out" then
				return 0
			end
			return alpha < 0.5 and 0 or 1
		end
		if easingstyle == "CubicV2" then
			easingstyle = "Cubic"
		end
		local style = Enum.EasingStyle[easingstyle] or Enum.EasingStyle.Linear
		local direction = Enum.EasingDirection[easingdirection] or Enum.EasingDirection.InOut
		return TweenService:GetValue(alpha, style, direction)
	end
	function Track.getPoses(track, t, looped)
		assert(type(t) == "number", "time must be a number")
		-- not recommended for use on big anims
		local poses = {}
		local keyframes = track.Keyframes
		for _,keyframe in keyframes do
			for _,pose in keyframe.Poses do
				poses[pose.Name] = CFrame.identity
			end
		end
		if looped and track.Time > 0 then
			t = t % track.Time
		end
		for name,_ in poses do
			local k1, k2, t1, t2 = nil, nil, -math.huge, math.huge
			for _,k in keyframes do
				local po = nil
				for _,p in k.Poses do
					if p.Name == name and p.Weight > 0 then
						po = p
					end
				end
				if po ~= nil then
					if t1 < k.Time and k.Time <= t then
						k1 = po
						t1 = k.Time
					end
					if t2 > k.Time and k.Time > t then
						k2 = po
						t2 = k.Time
					end
				end
			end
			local cf = CFrame.identity
			if k1 ~= nil then
				if k2 ~= nil then
					local a = GetEasedAlpha((t - t1) / (t2 - t1), k1.EasingStyle, k1.EasingDirection)
					cf = k1.CFrame:Lerp(k2.CFrame, a)
				else
					cf = k1.CFrame
				end
			else
				if k2 ~= nil then
					cf = k2.CFrame
				end
			end
			poses[name] = cf
		end
		return poses
	end
	AnimLib.Track = Track
		local JointPresets = {
		["Full Body"] = nil,
		["Upper Body"] = {
			Mode = "Blacklist",
			Names = {
				"Left Leg",
				"Right Leg",
				"LeftUpperLeg",
				"LeftLowerLeg",
				"LeftFoot",
				"RightUpperLeg",
				"RightLowerLeg",
				"RightFoot",
			},
		},
		["Lower Body"] = {
			Mode = "Blacklist",
			Names = {
				"Head",
				"Left Arm",
				"Right Arm",
				"LeftUpperArm",
				"LeftLowerArm",
				"LeftHand",
				"RightUpperArm",
				"RightLowerArm",
				"RightHand",
			},
		},
		["Arms Only"] = {
			Mode = "Whitelist",
			Names = {
				"Left Arm",
				"Right Arm",
				"LeftUpperArm",
				"LeftLowerArm",
				"LeftHand",
				"RightUpperArm",
				"RightLowerArm",
				"RightHand",
			},
		},
	}
	function AnimLib.GetJointPreset(name)
		local preset = JointPresets[name]
		if not preset then
			return nil, "Blacklist"
		end
		return table.clone(preset.Names), preset.Mode
	end
	local Animator = {}
	Animator.__index = Animator
	function Animator.new()
		local self = setmetatable({}, Animator)
		self.rig = nil
		self.track = nil
		self.map = {{0, 1}, {0, 1}}
		self.looped = false
		self.speed = 1
		self.weight = 1
		self.jointMask = nil
		self.jointMaskMode = "Blacklist"
		self.timePosition = 0
		self.playing = false
		self.paused = false
		self._optimiser = 1
		self._jointmap = nil
		self._skipsec = nil
		self._rig = nil
		self._track = nil
		self._updateConnection = nil
		self._boundSignal = nil
		self._syncSound = nil
		self._soundOffset = 0
		self._fade = nil
		self._lastTrackTime = nil
		self._finishedFired = false
		self._manualFadeStart = nil
		self._lastDanceMusicStepInput = nil
		self._lastObservedDanceMusicTime = nil
		self._usingDanceMusicClock = false
		self.autoFadeIn = 0
		self.useDanceMusicSync = false
		self.useGlobalPlaybackSpeed = true
		self.showMarkerNotifications = false
		self._destroyed = false
		self._finishedEvent = Instance.new("BindableEvent")
		self._markerEvent = Instance.new("BindableEvent")
		self._markerEvents = {}
		self.Finished = self._finishedEvent.Event
		self.MarkerReached = self._markerEvent.Event
		self.OnFinished = self.Finished
		self.TimeReached = self.MarkerReached
		self:ApplyDefaults()
		return self
	end
	function Animator:ApplyDefaults()
		local settings = AnimLib.Settings
		if type(settings) ~= "table" then
			return self
		end
		self.autoFadeIn = math.clamp(tonumber(settings.FadeIn) or 0, 0, 1)
		self.useDanceMusicSync = settings.SyncToDanceMusic == true
		self.useGlobalPlaybackSpeed = true
		self.showMarkerNotifications = settings.MarkerNotifications == true
		local mask, mode = AnimLib.GetJointPreset(settings.JointPreset)
		if mask then
			self:SetJointMask(mask, mode)
		else
			self:ClearJointMask()
		end
		return self
	end
	function Animator.fromTrack(rig, track, options)
		local self = Animator.new()
		self:SetRig(rig)
		self:SetTrack(track)
		self:Configure(options)
		return self
	end
	function Animator:SetRig(rig)
		assert(rig == nil or typeof(rig) == "Instance", "rig must be an Instance or nil")
		self.rig = rig
		self._rig = nil
		self._jointmap = nil
		return self
	end
	function Animator:SetTrack(track, keepTime)
		if track ~= nil then
			local valid, reason = Track.validate(track)
			assert(valid, reason)
		end
		self.track = track
		self._track = nil
		self._skipsec = nil
		self._lastTrackTime = nil
		self._finishedFired = false
		if not keepTime then
			self.timePosition = 0
		end
		return self
	end
	function Animator:Configure(options)
		if type(options) ~= "table" then
			return self
		end
		if options.Speed ~= nil then
			self:AdjustSpeed(options.Speed)
		end
		if options.Weight ~= nil then
			self:AdjustWeight(options.Weight)
		end
		if options.Looped ~= nil then
			self.looped = options.Looped == true
		end
		if options.Map ~= nil then
			self.map = options.Map
		end
		local jointMask = options.JointMask ~= nil and options.JointMask or options.Filter
		local maskMode = options.MaskMode or options.FilterType
		if jointMask ~= nil then
			self:SetJointMask(jointMask, maskMode)
		end
		if options.Sound ~= nil then
			self:SyncToSound(options.Sound, options.SoundOffset)
		end
		if options.AutoFadeIn ~= nil then
			assert(
				type(options.AutoFadeIn) == "number" and options.AutoFadeIn >= 0,
				"AutoFadeIn must be zero or greater"
			)
			self.autoFadeIn = options.AutoFadeIn
		end
		if options.UseDanceMusicSync ~= nil then
			self.useDanceMusicSync = options.UseDanceMusicSync == true
		end
		if options.UseGlobalPlaybackSpeed ~= nil then
			self.useGlobalPlaybackSpeed = options.UseGlobalPlaybackSpeed == true
		end
		if options.MarkerNotifications ~= nil then
			self.showMarkerNotifications = options.MarkerNotifications == true
		end
		return self
	end
	function Animator:LoadSequence(sequence, keepTime)
		assert(
			typeof(sequence) == "Instance" and sequence:IsA("KeyframeSequence"),
			"sequence must be a KeyframeSequence"
		)
		return self:SetTrack(Track.frominstance(sequence), keepTime)
	end
	function Animator:LoadAnimation(source, keepTime)
		if typeof(source) == "Instance" and source:IsA("KeyframeSequence") then
			return self:LoadSequence(source, keepTime)
		end
		if type(source) == "string" then
			local track, reason = Track.fromfilecached(source)
			assert(track, reason)
			return self:SetTrack(track, keepTime)
		end
		local valid, reason = Track.validate(source)
		assert(valid, reason or "source must be an AnimLib track, KeyframeSequence, or local .anim path")
		return self:SetTrack(source, keepTime)
	end
	function Animator:Play(startTime)
		if startTime ~= nil then
			self:Seek(startTime)
		elseif not self.playing then
			self._lastTrackTime = nil
		end
		self.playing = true
		self.paused = false
		self._finishedFired = false
		if self.autoFadeIn > 0 then
			self._manualFadeStart = os.clock()
		end
		return self
	end
	function Animator:Pause()
		self.paused = true
		return self
	end
	function Animator:Resume()
		if self.track then
			self.playing = true
		end
		self.paused = false
		return self
	end
	function Animator:Stop(resetPose)
		self.playing = false
		self.paused = false
		self.timePosition = 0
		self._fade = nil
		self._lastTrackTime = nil
		if resetPose then
			self:ResetPose()
		end
		return self
	end
	function Animator:Seek(timePosition)
		assert(type(timePosition) == "number", "timePosition must be a number")
		self.timePosition = math.max(timePosition, 0)
		self._lastTrackTime = nil
		return self
	end
	function Animator:SetTime(timePosition)
		return self:Seek(timePosition)
	end
	function Animator:AdjustSpeed(speed)
		assert(type(speed) == "number" and speed >= 0, "speed must be zero or greater")
		self.speed = speed
		return self
	end
	function Animator:AdjustWeight(weight)
		assert(type(weight) == "number", "weight must be a number")
		self.weight = math.clamp(weight, 0, 1)
		return self
	end
	function Animator:GetTimePosition()
		return self.timePosition
	end
	function Animator:GetTimeLength()
		return self.track and Track.getDuration(self.track) or 0
	end
	function Animator:GetPlaybackSpeed(usingDanceMusicClock)
		local speed = type(self.speed) == "number" and math.max(self.speed, 0) or 1
		if not self.useGlobalPlaybackSpeed then
			return speed
		end
		local settings = AnimLib.Settings
		local globalSpeed = math.clamp(tonumber(settings and settings.Speed) or 1, 0.25, 2)
		if usingDanceMusicClock and settings and settings.ApplySpeedToMusic then
			return speed
		end
		return speed * globalSpeed
	end
	function Animator:GetPose(timePosition, looped)
		assert(self.track, "animator has no track")
		timePosition = timePosition == nil and self.timePosition or timePosition
		assert(type(timePosition) == "number", "timePosition must be a number")
		local _, usingDanceMusicClock = self:_GetSyncSound()
		local t = math.max(timePosition, 0) * self:GetPlaybackSpeed(usingDanceMusicClock)
		local map = self.map
		if map and map[1] and map[2] then
			local inputduration = map[1][2] - map[1][1]
			if inputduration ~= 0 then
				t = map[2][1] + (t - map[1][1]) * (map[2][2] - map[2][1]) / inputduration
			end
		end
		if looped == nil then
			looped = self.looped
		end
		return Track.getPoses(self.track, t, looped == true)
	end
	Animator.GetPoses = Animator.GetPose
	function Animator:IsPlaying()
		return self.playing and not self.paused
	end
	function Animator:SetJointMask(mask, mode)
		if mask == nil then
			return self:ClearJointMask()
		end
		assert(type(mask) == "table", "mask must be a table")
		mode = mode or self.jointMaskMode or "Blacklist"
		if type(mode) == "string" then
			local normalized = string.lower(mode)
			if normalized == "blacklist" then
				mode = "Blacklist"
			end
			if normalized == "whitelist" then
				mode = "Whitelist"
			end
		end
		assert(mode == "Blacklist" or mode == "Whitelist", "mode must be Blacklist or Whitelist")
		local normalizedMask = {}
		for key, value in mask do
			local joint = type(key) == "number" and value or key
			local enabled = type(key) == "number" or value == true
			if typeof(joint) == "Instance" and joint:IsA("Motor6D") then
				joint = joint.Part1 and joint.Part1.Name or joint.Name
			end
			assert(type(joint) == "string", "joint mask entries must be names or Motor6Ds")
			if enabled then
				normalizedMask[joint] = true
			end
		end
		self.jointMask = normalizedMask
		self.jointMaskMode = mode
		return self
	end
	function Animator:GetJointMask()
		return self.jointMask and table.clone(self.jointMask) or nil, self.jointMaskMode
	end
	function Animator:ClearJointMask()
		self.jointMask = nil
		return self
	end
	function Animator:SetFilter(filter, filterType)
		return self:SetJointMask(filter, filterType)
	end
	function Animator:ClearFilter()
		return self:ClearJointMask()
	end
	function Animator:_ShouldAnimateJoint(name)
		if not self.jointMask then
			return true
		end
		local listed = self.jointMask[name] == true
		return self.jointMaskMode == "Whitelist" and listed or not listed
	end
	function Animator:SyncToSound(sound, offset)
		assert(typeof(sound) == "Instance" and sound:IsA("Sound"), "sound must be a Sound")
		assert(offset == nil or type(offset) == "number", "offset must be a number or nil")
		self._syncSound = sound
		self._soundOffset = offset or 0
		self._lastTrackTime = nil
		return self
	end
	function Animator:ClearSoundSync()
		self._syncSound = nil
		self._soundOffset = 0
		self._lastTrackTime = nil
		return self
	end
	function Animator:GetSyncedSound()
		return self._syncSound, self._soundOffset
	end
	function Animator:_GetSyncSound()
		if self._syncSound and self._syncSound.Parent then
			return self._syncSound, false
		end
		if not self.useDanceMusicSync then
			return nil
		end
		local provider = AnimLib.Settings and AnimLib.Settings.DanceSoundProvider
		if type(provider) ~= "function" then
			return nil
		end
		local success, sound = pcall(provider)
		if success and typeof(sound) == "Instance" and sound:IsA("Sound") and sound.Parent and sound.IsPlaying then
			return sound, true
		end
		return nil
	end
	function Animator:FadeTo(weight, duration, stopOnComplete, resetPose)
		assert(type(weight) == "number", "weight must be a number")
		assert(type(duration) == "number" and duration >= 0, "duration must be zero or greater")
		weight = math.clamp(weight, 0, 1)
		if duration == 0 then
			self:AdjustWeight(weight)
			self._fade = nil
			if stopOnComplete then
				self:Stop(resetPose)
			end
			return self
		end
		self._fade = {
			From = self.weight,
			To = weight,
			Duration = duration,
			Elapsed = 0,
			StopOnComplete = stopOnComplete == true,
			ResetPose = resetPose == true,
		}
		return self
	end
	function Animator:FadeIn(duration, targetWeight)
		targetWeight = targetWeight == nil and 1 or targetWeight
		self.autoFadeIn = 0
		self._manualFadeStart = nil
		self:AdjustWeight(0)
		if not self.playing then
			self:Play()
		end
		return self:FadeTo(targetWeight, duration, false, false)
	end
	function Animator:FadeOut(duration, resetPose)
		return self:FadeTo(0, duration, true, resetPose)
	end
	function Animator:_UpdateFade(dt)
		local fade = self._fade
		if not fade then
			return
		end
		fade.Elapsed = math.min(fade.Elapsed + dt, fade.Duration)
		local alpha = fade.Duration > 0 and fade.Elapsed / fade.Duration or 1
		self.weight = fade.From + (fade.To - fade.From) * alpha
		if alpha >= 1 then
			self._fade = nil
			if fade.StopOnComplete then
				self:Stop(fade.ResetPose)
			end
		end
	end
	function Animator:GetMarkerReachedSignal(name)
		assert(type(name) == "string" and name ~= "", "name must be a non-empty string")
		local markerEvent = self._markerEvents[name]
		if not markerEvent then
			markerEvent = Instance.new("BindableEvent")
			self._markerEvents[name] = markerEvent
		end
		return markerEvent.Event
	end
	function Animator:_FireMarker(marker)
		self._markerEvent:Fire(marker.Name, marker.Value, marker)
		local markerEvent = self._markerEvents[marker.Name]
		if markerEvent then
			markerEvent:Fire(marker.Value, marker)
		end
		if self.showMarkerNotifications then
			Util.UINotify("Animation marker: " .. marker.Name)
		end
	end
	function Animator:_ProcessMarkers(previousTime, currentTime, duration)
		local function fireRange(startTime, endTime, includeStart)
			for _, marker in Track.getMarkersBetween(self.track, startTime, endTime, includeStart) do
				self:_FireMarker(marker)
			end
		end
		if not self.track then
			return
		end
		if previousTime == nil then
			fireRange(currentTime, currentTime, true)
			self._lastTrackTime = currentTime
			return
		end
		if currentTime >= previousTime then
			fireRange(previousTime, currentTime, false)
		elseif self.looped and duration > 0 then
			fireRange(previousTime, duration, false)
			fireRange(0, currentTime, true)
		end
		self._lastTrackTime = currentTime
	end
	function Animator:_FireFinished()
		if self._finishedFired then
			return
		end
		self._finishedFired = true
		self._finishedEvent:Fire(self.track)
	end
	function Animator:Bind(signal)
		self:Unbind()
		local resolved, name = ResolveRunSignal(signal, "PreAnimation")
		self._boundSignal = name
		self._updateConnection = resolved:Connect(function(dt)
			self:Update(dt)
		end)
		return self
	end
	function Animator:Unbind()
		if self._updateConnection then
			self._updateConnection:Disconnect()
			self._updateConnection = nil
		end
		self._boundSignal = nil
		return self
	end
	function Animator:GetBoundSignal()
		return self._boundSignal
	end
	function Animator:PlayAndBind(signal, startTime)
		self:Play(startTime)
		return self:Bind(signal)
	end
	function Animator:ResetPose()
		if not self.rig then
			return self
		end
		for _, descendant in self.rig:GetDescendants() do
			if descendant:IsA("Motor6D") then
				descendant.Transform = CFrame.identity
			end
		end
		return self
	end
	function Animator:Update(dt)
		if not self:IsPlaying() or not self.track then
			return false
		end
		assert(type(dt) == "number" and dt >= 0, "dt must be zero or greater")
		self:_UpdateFade(dt)
		if not self:IsPlaying() then
			return false
		end
		local syncSound, usingDanceMusicClock = self:_GetSyncSound()
		if syncSound then
			self.timePosition = math.max(syncSound.TimePosition + self._soundOffset, 0)
		else
			self.timePosition += dt
		end

		local duration = Track.getDuration(self.track)
		if not self.looped and duration <= 0 then
			self:Step(0)
			self.playing = false
			self:_FireFinished()
			return false
		end
		local playbackSpeed = self:GetPlaybackSpeed(usingDanceMusicClock)
		if not self.looped and self.timePosition * playbackSpeed >= duration then
			self.timePosition = playbackSpeed > 0 and duration / playbackSpeed or self.timePosition
			self:Step(self.timePosition)
			self.playing = false
			self:_FireFinished()
			return false
		end

		self:Step(self.timePosition)
		return true
	end
	function Animator:Destroy(resetPose)
		if self._destroyed then
			return
		end
		self._destroyed = true
		self:Unbind()
		if resetPose then
			self:ResetPose()
		end
		self.playing = false
		self.rig = nil
		self.track = nil
		self._jointmap = nil
		self._skipsec = nil
		self._rig = nil
		self._track = nil
		self._syncSound = nil
		self._fade = nil
		self._lastTrackTime = nil
		for _, markerEvent in self._markerEvents do
			markerEvent:Destroy()
		end
		self._markerEvents = {}
		self._finishedEvent:Destroy()
		self._markerEvent:Destroy()
	end
	function Animator:Step(t)
		assert(type(t) == "number", "time must be a number")
		local syncSound, usingDanceMusicClock = self:_GetSyncSound()
		if syncSound then
			t = math.max(syncSound.TimePosition + self._soundOffset, 0)
		end
		if not usingDanceMusicClock then
			usingDanceMusicClock = IsDanceMusicDrivenStep(self, t)
		end
		self.timePosition = math.max(t, 0)
		local rig, track, map, weight, looped = self.rig, self.track, self.map, self.weight, self.looped
		local speed = self:GetPlaybackSpeed(usingDanceMusicClock)
		weight = type(weight) == "number" and math.clamp(weight, 0, 1) or 1
		if track and self._track ~= track then
			self._manualFadeStart = os.clock()
		end
		if self.autoFadeIn > 0 and self._manualFadeStart then
			weight *= math.clamp((os.clock() - self._manualFadeStart) / self.autoFadeIn, 0, 1)
		end
		local jointmap, skipsec = self._jointmap, self._skipsec
		if rig and track then
			local scale = rig:GetScale()
			t *= speed
			if map and map[1] and map[2] then
				local inputduration = map[1][2] - map[1][1]
				if inputduration ~= 0 then
					t = map[2][1] + (t - map[1][1]) * (map[2][2] - map[2][1]) / inputduration
				end
			end
			if self._rig ~= rig then
				jointmap = nil
				self._rig = rig
			end
			if self._track ~= track then
				skipsec = nil
				self._track = track
			end
			if not jointmap then
				jointmap = {}
				for _,v in rig:GetDescendants() do
					if v:IsA("Motor6D") and v.Part0 and v.Part1 then
						jointmap[v.Part1.Name] = v
					end
				end
				self._jointmap = jointmap
			end
			local keyframes = track.Keyframes
			if not skipsec then
				skipsec = {}
				local i = 1
				local oldsec = 0
				while i < #keyframes do
					local k = keyframes[i]
					local sec = k.Time // self._optimiser
					while oldsec < sec do
						local j = math.max(1, i - 1)
						local poses = {}
						local scan = j
						while scan > 0 do
							local k2 = keyframes[scan]
							local ok = true
							for name,_ in jointmap do
								if not poses[name] then
									for _,p in k2.Poses do
										if p.Name == name and p.Weight > 0 then
											poses[name] = true
											j = scan
											break
										end
									end
								end
								ok = poses[name] and ok
							end
							if ok then break end
							scan -= 1
						end
						table.insert(skipsec, {j, j})
						oldsec += 1
					end
					i += 1
				end
				for i,v in skipsec do
					while v[2] < #keyframes and keyframes[v[2]].Time <= (i + 1) * self._optimiser do
						v[2] += 1
					end
				end
				self._skipsec = skipsec
			end
			local poses = {}
			for name,_ in jointmap do
				poses[name] = CFrame.identity
			end
			if looped and track.Time > 0 then
				t = t % track.Time
			end
			self:_ProcessMarkers(self._lastTrackTime, t, track.Time)
			local skip1, skip2 = 1, #keyframes
			if #skipsec >= 2 then
				local i = t // self._optimiser
				if i < 1 then
					skip1, skip2 = 1, skipsec[1][2]
				elseif i < #skipsec then
					skip1, skip2 = skipsec[i][1], skipsec[i][2]
				else
					skip1, skip2 = skipsec[#skipsec][1], #keyframes
				end
			end
			for name,_ in poses do
				local k1, k2, t1, t2 = nil, nil, -math.huge, math.huge
				for i=skip1, skip2 do
					local k = keyframes[i]
					local po = nil
					for _,p in k.Poses do
						if p.Name == name and p.Weight > 0 then
							po = p
						end
					end
					if po ~= nil then
						if t1 < k.Time and k.Time <= t then
							k1 = po
							t1 = k.Time
						end
						if t2 > k.Time and k.Time > t then
							k2 = po
							t2 = k.Time
						end
					end
				end
				local cf = CFrame.identity
				if k1 ~= nil then
					if k2 ~= nil then
						local a = GetEasedAlpha((t - t1) / (t2 - t1), k1.EasingStyle, k1.EasingDirection)
						cf = k1.CFrame:Lerp(k2.CFrame, a)
					else
						cf = k1.CFrame
					end
				else
					if k2 ~= nil then
						cf = k2.CFrame
					end
				end
				poses[name] = cf
			end
			for name,joint in jointmap do
				if not self:_ShouldAnimateJoint(name) then
					continue
				end
				local cf = poses[name] or CFrame.identity
				cf = cf.Rotation + (cf.Position * scale)
				if weight == 1 then
					joint.Transform = cf
				elseif weight ~= 0 then
					joint.Transform = joint.Transform:Lerp(cf, weight)
				end
			end
		end
	end
	AnimLib.Animator = Animator
	-- Clean-room behavior study: Theo's ToolDance.lua (Solary-3/Scripts).
	-- The source repository does not publish a license, so no implementation code is copied here.
	local DanceQueue = {}
	DanceQueue.__index = DanceQueue
	local function ResolveDanceTrack(value)
		if type(value) == "string" then
			return Track.fromfilecached(value)
		end
		local valid, reason = Track.validate(value)
		if not valid then
			return nil, reason
		end
		return value
	end
	function DanceQueue.new(rig)
		local self = setmetatable({}, DanceQueue)
		self.rig = rig
		self.animator = Animator.new():SetRig(rig)
		self.items = {}
		self.current = nil
		self.playing = false
		self.paused = false
		self._updateConnection = nil
		self._boundSignal = nil
		self._finishedFired = false
		self._destroyed = false
		self._itemStartedEvent = Instance.new("BindableEvent")
		self._itemFinishedEvent = Instance.new("BindableEvent")
		self._finishedEvent = Instance.new("BindableEvent")
		self.ItemStarted = self._itemStartedEvent.Event
		self.ItemFinished = self._itemFinishedEvent.Event
		self.Finished = self._finishedEvent.Event
		return self
	end
	function DanceQueue:SetRig(rig)
		assert(rig == nil or typeof(rig) == "Instance", "rig must be an Instance or nil")
		self.rig = rig
		self.animator:SetRig(rig)
		return self
	end
	function DanceQueue:Insert(index, track, options)
		local resolved, reason = ResolveDanceTrack(track)
		assert(resolved, reason)
		assert(type(index) == "number", "index must be a number")
		local item = {
			Track = resolved,
			Options = type(options) == "table" and table.clone(options) or {},
		}
		item.Name = item.Options.Name or resolved.Name or "<unknown>"
		table.insert(self.items, math.clamp(index, 1, #self.items + 1), item)
		self._finishedFired = false
		return item
	end
	function DanceQueue:Enqueue(track, options)
		return self:Insert(#self.items + 1, track, options)
	end
	function DanceQueue:Remove(index)
		assert(type(index) == "number", "index must be a number")
		return table.remove(self.items, index)
	end
	function DanceQueue:Count(includeCurrent)
		return #self.items + (includeCurrent and self.current and 1 or 0)
	end
	function DanceQueue:GetCurrent()
		return self.current
	end
	function DanceQueue:_StartNext()
		local item = table.remove(self.items, 1)
		if not item then
			return false
		end
		self.current = item
		local options = item.Options
		local targetWeight = options.Weight == nil and 1 or options.Weight
		self.animator:ApplyDefaults()
		self.animator:SetRig(self.rig)
		self.animator:SetTrack(item.Track)
		if options.Speed ~= nil then
			self.animator:AdjustSpeed(options.Speed)
		end
		self.animator:AdjustWeight(targetWeight)
		self.animator.looped = options.Looped == true
		self.animator.map = options.Map
		if options.FadeIn ~= nil then
			self.animator.autoFadeIn = 0
		end
		local jointMask = options.JointMask ~= nil and options.JointMask or options.Filter
		if jointMask then
			self.animator:SetJointMask(jointMask, options.MaskMode or options.FilterType)
		end
		if options.Sound then
			self.animator:SyncToSound(options.Sound, options.SoundOffset)
		else
			self.animator:ClearSoundSync()
		end
		self.animator:Play(options.StartTime or 0)
		if type(options.FadeIn) == "number" and options.FadeIn > 0 then
			self.animator:FadeIn(options.FadeIn, targetWeight)
		end
		self._itemStartedEvent:Fire(item)
		return true
	end
	function DanceQueue:_FinishCurrent(reason)
		local item = self.current
		if not item then
			return
		end
		self.current = nil
		self._itemFinishedEvent:Fire(item, reason)
	end
	function DanceQueue:_FinishQueue()
		self.playing = false
		if self._finishedFired then
			return
		end
		self._finishedFired = true
		self._finishedEvent:Fire()
	end
	function DanceQueue:Play()
		self.playing = true
		self.paused = false
		self._finishedFired = false
		if not self.current and not self:_StartNext() then
			self:_FinishQueue()
		end
		return self
	end
	function DanceQueue:Pause()
		self.paused = true
		self.animator:Pause()
		return self
	end
	function DanceQueue:Resume()
		self.paused = false
		if self.current then
			self.animator:Resume()
		end
		return self
	end
	function DanceQueue:Skip(resetPose)
		if self.current then
			self.animator:Stop(resetPose)
			self:_FinishCurrent("Skipped")
		end
		if self.playing and not self:_StartNext() then
			self:_FinishQueue()
		end
		return self
	end
	function DanceQueue:Clear(stopCurrent, resetPose)
		table.clear(self.items)
		if stopCurrent and self.current then
			self.animator:Stop(resetPose)
			self:_FinishCurrent("Cleared")
		end
		return self
	end
	function DanceQueue:Stop(clearQueue, resetPose)
		self.playing = false
		self.paused = false
		self.animator:Stop(resetPose)
		self:_FinishCurrent("Stopped")
		if clearQueue then
			table.clear(self.items)
		end
		return self
	end
	function DanceQueue:Update(dt)
		if not self.playing or self.paused then
			return false
		end
		assert(type(dt) == "number" and dt >= 0, "dt must be zero or greater")
		if not self.current and not self:_StartNext() then
			self:_FinishQueue()
			return false
		end
		local item = self.current
		local options = item.Options
		local fadeOut = options.FadeOut
		if type(fadeOut) == "number" and fadeOut > 0 and not self.animator.looped and not self.animator._fade then
			local duration = Track.getDuration(item.Track)
			local _, usingDanceMusicClock = self.animator:_GetSyncSound()
			local playbackSpeed = self.animator:GetPlaybackSpeed(usingDanceMusicClock)
			local trackRemaining = duration - self.animator.timePosition * playbackSpeed
			local remaining = playbackSpeed > 0 and trackRemaining / playbackSpeed or math.huge
			if remaining <= fadeOut then
				self.animator:FadeTo(0, fadeOut, false, false)
			end
		end
		if self.animator:Update(dt) then
			return true
		end
		local reason = self.animator._finishedFired and "Finished" or "Stopped"
		if options.ResetPoseOnFinish and reason == "Finished" then
			self.animator:ResetPose()
		end
		self:_FinishCurrent(reason)
		if self:_StartNext() then
			return true
		end
		self:_FinishQueue()
		return false
	end
	function DanceQueue:Bind(signal)
		self:Unbind()
		local resolved, name = ResolveRunSignal(signal, "PreAnimation")
		self._boundSignal = name
		self._updateConnection = resolved:Connect(function(dt)
			self:Update(dt)
		end)
		return self
	end
	function DanceQueue:Unbind()
		if self._updateConnection then
			self._updateConnection:Disconnect()
			self._updateConnection = nil
		end
		self._boundSignal = nil
		return self
	end
	function DanceQueue:GetBoundSignal()
		return self._boundSignal
	end
	function DanceQueue:PlayAndBind(signal)
		self:Play()
		return self:Bind(signal)
	end
	function DanceQueue:Destroy(resetPose)
		if self._destroyed then
			return
		end
		self._destroyed = true
		self:Unbind()
		self:Stop(true, resetPose)
		self.animator:Destroy(false)
		self._itemStartedEvent:Destroy()
		self._itemFinishedEvent:Destroy()
		self._finishedEvent:Destroy()
		self.rig = nil
	end
	AnimLib.DanceQueue = DanceQueue

	--[[
	  Licensed under the MIT License (see LICENSE file for full details).
	  Copyright (c) 2025 MrY7zz

	  LEGAL NOTICE:
	  You are REQUIRED to retain this license header under the terms of the MIT License.
	  Removing or modifying this notice may violate copyright law.

	  The pose-mapping concept below was adapted from CurrentAngle V2. Its optional
	  hidden-property compatibility mode is disabled by default and never adds fling behavior.
	]]
	local Motor6DUtil = {}
	local function ValidateMotor(motor)
		if typeof(motor) ~= "Instance" or not motor:IsA("Motor6D") then
			return false, "motor must be a Motor6D"
		end
		if not motor.Part0 or not motor.Part1 then
			return false, "motor must have Part0 and Part1"
		end
		return true
	end
	local function ResolveWorldCFrame(value, fallback, name)
		value = value or fallback
		if typeof(value) == "CFrame" then
			return value
		end
		if typeof(value) == "Instance" and value:IsA("BasePart") then
			return value.CFrame
		end
		error((name or "value") .. " must be a BasePart or CFrame", 3)
	end
	function Motor6DUtil.Validate(motor)
		return ValidateMotor(motor)
	end
	function Motor6DUtil.SolveWorldTransform(motor, target, reference)
		local valid, reason = ValidateMotor(motor)
		assert(valid, reason)
		local targetCFrame = ResolveWorldCFrame(target, motor.Part1, "target")
		local referenceCFrame = ResolveWorldCFrame(reference, motor.Part0, "reference")
		local relative = referenceCFrame:Inverse() * targetCFrame
		return motor.C0:Inverse() * relative * motor.C1
	end
	function Motor6DUtil.GetCurrentWorldTransform(motor)
		return Motor6DUtil.SolveWorldTransform(motor, motor.Part1, motor.Part0)
	end
	function Motor6DUtil.GetWorldCFrame(motor, transform, reference)
		local valid, reason = ValidateMotor(motor)
		assert(valid, reason)
		transform = transform or motor.Transform
		assert(typeof(transform) == "CFrame", "transform must be a CFrame")
		local referenceCFrame = ResolveWorldCFrame(reference, motor.Part0, "reference")
		return referenceCFrame * motor.C0 * transform * motor.C1:Inverse()
	end
	function Motor6DUtil.RetargetTransform(sourceMotor, targetMotor)
		local sourceValid, sourceReason = ValidateMotor(sourceMotor)
		local targetValid, targetReason = ValidateMotor(targetMotor)
		assert(sourceValid, sourceReason)
		assert(targetValid, targetReason)
		return Motor6DUtil.SolveWorldTransform(targetMotor, sourceMotor.Part1, sourceMotor.Part0)
	end
	function Motor6DUtil.ToReplicationVectors(transform)
		assert(typeof(transform) == "CFrame", "transform must be a CFrame")
		local axis, angle = transform:ToAxisAngle()
		return transform.Position, axis * angle
	end
	function Motor6DUtil.TryHiddenReplication(motor, transform)
		local valid, reason = ValidateMotor(motor)
		if not valid then
			return false, reason
		end
		if typeof(transform) ~= "CFrame" then
			return false, "transform must be a CFrame"
		end
		if #Util.HiddenPropertySetters == 0 then
			return false, "hidden-property setter is unavailable"
		end
		local offset, angle = Motor6DUtil.ToReplicationVectors(transform)
		local offsetSuccess, offsetReason =
			Util.TrySetHiddenProperty(motor, "ReplicateCurrentOffset6D", offset)
		local angleSuccess, angleReason = Util.TrySetHiddenProperty(motor, "ReplicateCurrentAngle6D", angle)
		if offsetSuccess and angleSuccess then
			return true, angleReason or offsetReason
		end
		return false, tostring(not offsetSuccess and offsetReason or angleReason)
	end
	function Motor6DUtil.ApplyTransform(motor, transform, options)
		local valid, reason = ValidateMotor(motor)
		assert(valid, reason)
		assert(typeof(transform) == "CFrame", "transform must be a CFrame")
		options = type(options) == "table" and options or {}
		local weight = options.Weight == nil and 1 or options.Weight
		local positionScale = options.PositionScale == nil and 1 or options.PositionScale
		assert(type(weight) == "number", "Weight must be a number")
		assert(type(positionScale) == "number" and positionScale >= 0, "PositionScale must be zero or greater")
		weight = math.clamp(weight, 0, 1)
		if positionScale ~= 1 then
			transform = transform.Rotation + transform.Position * positionScale
		end
		local appliedTransform = motor.Transform:Lerp(transform, weight)
		motor.Transform = appliedTransform
		local replication = {
			Attempted = options.HiddenReplication == true and 1 or 0,
			Succeeded = 0,
			Failed = 0,
			LastError = nil,
		}
		if replication.Attempted == 1 then
			local success, replicationReason = Motor6DUtil.TryHiddenReplication(motor, appliedTransform)
			if success then
				replication.Succeeded = 1
			else
				replication.Failed = 1
				replication.LastError = replicationReason
			end
		end
		return appliedTransform, replication
	end
	function Motor6DUtil.ApplyWorldPose(motor, target, reference, options)
		local transform = Motor6DUtil.SolveWorldTransform(motor, target, reference)
		local appliedTransform, replication = Motor6DUtil.ApplyTransform(motor, transform, options)
		return appliedTransform, replication, transform
	end
	function Motor6DUtil.Reset(motor, hiddenReplication)
		return Motor6DUtil.ApplyTransform(motor, CFrame.identity, {
			HiddenReplication = hiddenReplication == true,
		})
	end
	AnimLib.Motor6D = Motor6DUtil

	local RigMapper = {}
	RigMapper.__index = RigMapper
	RigMapper.Modes = {
		Transform = true,
		WorldCFrame = true,
	}
	RigMapper.Presets = {
		Exact = {},
		R15ToR6 = {
			Torso = "LowerTorso",
			Head = "Head",
			["Left Arm"] = "LeftUpperArm",
			["Right Arm"] = "RightUpperArm",
			["Left Leg"] = "LeftUpperLeg",
			["Right Leg"] = "RightUpperLeg",
		},
		R6ToR15 = {
			LowerTorso = "Torso",
			Head = "Head",
			LeftUpperArm = "Left Arm",
			RightUpperArm = "Right Arm",
			LeftUpperLeg = "Left Leg",
			RightUpperLeg = "Right Leg",
		},
	}
	local function BuildMotorMap(rig)
		local motors = {}
		if not rig then
			return motors
		end
		for _, descendant in rig:GetDescendants() do
			if descendant:IsA("Motor6D") and descendant.Part0 and descendant.Part1 then
				motors[descendant.Part1.Name] = descendant
			end
		end
		return motors
	end
	function RigMapper.new(sourceRig, targetRig, aliases)
		local self = setmetatable({}, RigMapper)
		self.sourceRig = nil
		self.targetRig = nil
		self.aliases = {}
		self.scalePositions = true
		self.weight = 1
		self.mode = "Transform"
		self.hiddenReplication = false
		self._sourceMotors = {}
		self._targetMotors = {}
		self._mappedMotors = {}
		self._updateConnection = nil
		self._boundSignal = nil
		self._lastHiddenReplication = {
			Attempted = 0,
			Succeeded = 0,
			Failed = 0,
			LastError = nil,
		}
		self:SetRigs(sourceRig, targetRig)
		self:SetAliases(aliases or RigMapper.Presets.Exact)
		return self
	end
	function RigMapper:SetRigs(sourceRig, targetRig)
		assert(sourceRig == nil or typeof(sourceRig) == "Instance", "sourceRig must be an Instance or nil")
		assert(targetRig == nil or typeof(targetRig) == "Instance", "targetRig must be an Instance or nil")
		self.sourceRig = sourceRig
		self.targetRig = targetRig
		return self:Refresh()
	end
	function RigMapper:SetAliases(aliases)
		assert(type(aliases) == "table", "aliases must be a table")
		self.aliases = table.clone(aliases)
		return self:Refresh()
	end
	function RigMapper:SetPreset(name)
		assert(type(name) == "string" and RigMapper.Presets[name], "unknown RigMapper preset: " .. tostring(name))
		return self:SetAliases(RigMapper.Presets[name])
	end
	function RigMapper:SetMode(mode)
		if type(mode) == "string" then
			local normalized = string.lower(mode):gsub("[%s_%-]", "")
			if normalized == "transform" then
				mode = "Transform"
			end
			if normalized == "world" or normalized == "worldcframe" then
				mode = "WorldCFrame"
			end
		end
		assert(RigMapper.Modes[mode], "unknown RigMapper mode: " .. tostring(mode))
		self.mode = mode
		return self
	end
	function RigMapper:GetMode()
		return self.mode
	end
	function RigMapper:SetHiddenReplication(enabled)
		self.hiddenReplication = enabled == true
		return self
	end
	function RigMapper:IsHiddenReplicationAvailable()
		return not ismissing(sethiddenproperty)
	end
	function RigMapper:GetHiddenReplicationStatus()
		return table.clone(self._lastHiddenReplication)
	end
	function RigMapper:Refresh()
		self._sourceMotors = BuildMotorMap(self.sourceRig)
		self._targetMotors = BuildMotorMap(self.targetRig)
		self._mappedMotors = {}
		for targetName, targetMotor in self._targetMotors do
			local sourceName = self.aliases[targetName] or targetName
			local sourceMotor = self._sourceMotors[sourceName]
			if sourceMotor then
				self._mappedMotors[targetName] = {
					Source = sourceMotor,
					Target = targetMotor,
				}
			end
		end
		return self
	end
	function RigMapper:GetMappedJointNames()
		local names = {}
		for name, _ in self._mappedMotors do
			table.insert(names, name)
		end
		table.sort(names)
		return names
	end
	function RigMapper:CopyPose(weight, scalePositions)
		weight = weight == nil and self.weight or weight
		scalePositions = scalePositions == nil and self.scalePositions or scalePositions
		assert(type(weight) == "number", "weight must be a number")
		weight = math.clamp(weight, 0, 1)
		local replicationStatus = {
			Attempted = 0,
			Succeeded = 0,
			Failed = 0,
			LastError = nil,
		}
		self._lastHiddenReplication = replicationStatus
		if weight == 0 then
			return 0, table.clone(replicationStatus)
		end

		local positionScale = 1
		if
			scalePositions
			and self.sourceRig
			and self.targetRig
			and self.sourceRig:IsA("Model")
			and self.targetRig:IsA("Model")
		then
			local sourceScale = self.sourceRig:GetScale()
			if sourceScale ~= 0 then
				positionScale = self.targetRig:GetScale() / sourceScale
			end
		end

		local copied = 0
		for _, mapping in self._mappedMotors do
			local transform = self.mode == "WorldCFrame"
					and Motor6DUtil.RetargetTransform(mapping.Source, mapping.Target)
				or mapping.Source.Transform
			local _, replication = Motor6DUtil.ApplyTransform(mapping.Target, transform, {
				Weight = weight,
				PositionScale = positionScale,
				HiddenReplication = self.hiddenReplication,
			})
			replicationStatus.Attempted += replication.Attempted
			replicationStatus.Succeeded += replication.Succeeded
			replicationStatus.Failed += replication.Failed
			if replication.LastError then
				replicationStatus.LastError = replication.LastError
			end
			copied += 1
		end
		return copied, table.clone(replicationStatus)
	end
	function RigMapper:ResetTargetPose()
		local replicationStatus = {
			Attempted = 0,
			Succeeded = 0,
			Failed = 0,
			LastError = nil,
		}
		for _, motor in self._targetMotors do
			local _, replication = Motor6DUtil.Reset(motor, self.hiddenReplication)
			replicationStatus.Attempted += replication.Attempted
			replicationStatus.Succeeded += replication.Succeeded
			replicationStatus.Failed += replication.Failed
			if replication.LastError then
				replicationStatus.LastError = replication.LastError
			end
		end
		self._lastHiddenReplication = replicationStatus
		return self, table.clone(replicationStatus)
	end
	function RigMapper:Bind(signal)
		self:Unbind()
		local resolved, name = ResolveRunSignal(signal, "PostSimulation")
		self._boundSignal = name
		self._updateConnection = resolved:Connect(function()
			self:CopyPose()
		end)
		return self
	end
	function RigMapper:Unbind()
		if self._updateConnection then
			self._updateConnection:Disconnect()
			self._updateConnection = nil
		end
		self._boundSignal = nil
		return self
	end
	function RigMapper:GetBoundSignal()
		return self._boundSignal
	end
	function RigMapper:Destroy(resetPose)
		self:Unbind()
		if resetPose then
			self:ResetTargetPose()
		end
		self.sourceRig = nil
		self.targetRig = nil
		self._sourceMotors = {}
		self._targetMotors = {}
		self._mappedMotors = {}
	end
	AnimLib.RigMapper = RigMapper

	local StateMachine = {}
	StateMachine.__index = StateMachine
	local StateAliases = {
		idle = "Idle",
		walk = "Walk",
		run = "Walk",
		running = "Walk",
		sprint = "Sprint",
		sprinting = "Sprint",
		forward = "WalkForward",
		walkforward = "WalkForward",
		backward = "WalkBackward",
		walkbackward = "WalkBackward",
		left = "WalkLeft",
		walkleft = "WalkLeft",
		right = "WalkRight",
		walkright = "WalkRight",
		jump = "Jump",
		jumping = "Jump",
		fall = "Fall",
		freefall = "Fall",
		land = "Land",
		landed = "Land",
		sit = "Sit",
		seated = "Sit",
		climb = "Climb",
		climbing = "Climb",
		swim = "Swim",
		swimming = "Swim",
		swimidle = "SwimIdle",
	}
	local function NormalizeStateName(name)
		if type(name) ~= "string" then
			return nil
		end
		return StateAliases[string.lower(name):gsub("[%s_%-]", "")]
	end
	local function ResolveTrackValue(value)
		if type(value) == "string" then
			return Track.fromfilecached(value)
		end
		local valid, reason = Track.validate(value)
		if not valid then
			return nil, reason
		end
		return value
	end
	function StateMachine.new(rig)
		local self = setmetatable({}, StateMachine)
		self.rig = nil
		self.humanoid = nil
		self.animator = Animator.new()
		self.animations = {}
		self.state = "Idle"
		self.forcedState = nil
		self.enabled = true
		self.paused = false
		self.sprinting = false
		self.directional = false
		self.landHoldTime = 0.2
		self._landedUntil = 0
		self._stateConnection = nil
		self._updateConnection = nil
		self._boundSignal = nil
		self:SetRig(rig)
		return self
	end
	function StateMachine:SetRig(rig)
		if self._stateConnection then
			self._stateConnection:Disconnect()
			self._stateConnection = nil
		end
		self.rig = rig
		self.humanoid = rig and rig:FindFirstChildOfClass("Humanoid") or nil
		self.animator:SetRig(rig)
		if self.humanoid then
			self._stateConnection = self.humanoid.StateChanged:Connect(function(_, newstate)
				if newstate == Enum.HumanoidStateType.Landed then
					self._landedUntil = os.clock() + self.landHoldTime
				end
			end)
		end
		return self
	end
	function StateMachine:SetAnimation(stateName, track, options)
		local state = NormalizeStateName(stateName)
		assert(state, "unknown animation state: " .. tostring(stateName))
		local resolved, reason = ResolveTrackValue(track)
		assert(resolved, reason)
		options = type(options) == "table" and options or {}
		local looped = options.Looped
		if looped == nil then
			looped = state ~= "Jump" and state ~= "Land"
		else
			looped = looped == true
		end
		local speed = options.Speed or 1
		local weight = options.Weight or 1
		assert(type(speed) == "number" and speed >= 0, "animation speed must be zero or greater")
		assert(type(weight) == "number", "animation weight must be a number")
		self.animations[state] = {
			Track = resolved,
			Speed = speed,
			Weight = math.clamp(weight, 0, 1),
			Looped = looped,
			Map = options.Map,
		}
		return self
	end
	function StateMachine:GetAnimation(stateName)
		local state = NormalizeStateName(stateName)
		assert(state, "unknown animation state: " .. tostring(stateName))
		return self.animations[state]
	end
	function StateMachine:RemoveAnimation(stateName)
		local state = NormalizeStateName(stateName)
		assert(state, "unknown animation state: " .. tostring(stateName))
		local removed = self.animations[state]
		self.animations[state] = nil
		if removed and self.animator.track == removed.Track then
			self.animator:Stop(false):SetTrack(nil)
		end
		return removed
	end
	function StateMachine:SetPlaybackSpeed(stateName, speed)
		assert(type(speed) == "number" and speed >= 0, "speed must be zero or greater")
		local animation = self:GetAnimation(stateName)
		assert(animation, "animation state is not configured: " .. tostring(stateName))
		animation.Speed = speed
		if self.animator.track == animation.Track then
			self.animator:AdjustSpeed(speed)
		end
		return self
	end
	function StateMachine:SetWeight(stateName, weight)
		assert(type(weight) == "number", "weight must be a number")
		local animation = self:GetAnimation(stateName)
		assert(animation, "animation state is not configured: " .. tostring(stateName))
		animation.Weight = math.clamp(weight, 0, 1)
		if self.animator.track == animation.Track then
			self.animator:AdjustWeight(animation.Weight)
		end
		return self
	end
	function StateMachine:SetAnimations(animations)
		assert(type(animations) == "table", "animations must be a table")
		for stateName, value in animations do
			if type(value) == "table" and value.Track then
				self:SetAnimation(stateName, value.Track, value)
			else
				self:SetAnimation(stateName, value)
			end
		end
		return self
	end
	function StateMachine:SetDirectionalAnimations(forward, backward, left, right, options)
		self:SetAnimation("WalkForward", forward, options)
		self:SetAnimation("WalkBackward", backward, options)
		self:SetAnimation("WalkLeft", left, options)
		self:SetAnimation("WalkRight", right, options)
		self.directional = true
		return self
	end
	function StateMachine:SetDirectionalEnabled(enabled)
		self.directional = enabled == true
		return self
	end
	function StateMachine:SetSprinting(sprinting)
		self.sprinting = sprinting == true
		return self
	end
	function StateMachine:SetLandHoldTime(seconds)
		assert(type(seconds) == "number" and seconds >= 0, "seconds must be zero or greater")
		self.landHoldTime = seconds
		return self
	end
	function StateMachine:ForceState(stateName)
		local state = NormalizeStateName(stateName)
		assert(state, "unknown animation state: " .. tostring(stateName))
		self.forcedState = state
		return self
	end
	function StateMachine:ClearForcedState()
		self.forcedState = nil
		return self
	end
	function StateMachine:GetState()
		return self.state
	end
	function StateMachine:ResolveState()
		if self.forcedState then
			return self.forcedState
		end
		local humanoid = self.humanoid
		if not humanoid then
			return "Idle"
		end
		if self._landedUntil > os.clock() and self.animations.Land then
			return "Land"
		end

		local humanoidState = humanoid:GetState()
		if humanoidState == Enum.HumanoidStateType.Jumping then
			return "Jump"
		end
		if humanoidState == Enum.HumanoidStateType.Freefall then
			return "Fall"
		end
		if humanoidState == Enum.HumanoidStateType.Seated then
			return "Sit"
		end
		if humanoidState == Enum.HumanoidStateType.Climbing then
			return "Climb"
		end
		if humanoidState == Enum.HumanoidStateType.Swimming then
			return humanoid.MoveDirection.Magnitude > 0.05 and "Swim" or "SwimIdle"
		end
		if humanoid.MoveDirection.Magnitude <= 0.05 then
			return "Idle"
		end
		if self.sprinting and self.animations.Sprint then
			return "Sprint"
		end
		if not self.directional then
			return "Walk"
		end

		local root = self.rig and self.rig:FindFirstChild("HumanoidRootPart")
		if not root then
			return "Walk"
		end
		local direction = root.CFrame:VectorToObjectSpace(humanoid.MoveDirection)
		if math.abs(direction.X) > math.abs(direction.Z) then
			return direction.X > 0 and "WalkRight" or "WalkLeft"
		end
		return direction.Z > 0 and "WalkBackward" or "WalkForward"
	end
	function StateMachine:_GetAnimation(state)
		local animation = self.animations[state]
		if animation then
			return animation
		end
		if state == "WalkForward" or state == "WalkBackward" or state == "WalkLeft" or state == "WalkRight" then
			return self.animations.Walk
		end
		if state == "SwimIdle" then
			return self.animations.Idle
		end
		return nil
	end
	function StateMachine:Restart()
		self.enabled = true
		self.paused = false
		self.animator:Seek(0):Play()
		return self
	end
	function StateMachine:Pause()
		self.paused = true
		self.animator:Pause()
		return self
	end
	function StateMachine:Resume()
		self.paused = false
		self.animator:Resume()
		return self
	end
	function StateMachine:Stop(resetPose)
		self.enabled = false
		self.animator:Stop(resetPose)
		return self
	end
	function StateMachine:Start()
		self.enabled = true
		self.paused = false
		if self.animator.track then
			self.animator:Play()
		end
		return self
	end
	function StateMachine:Bind(signal)
		self:Unbind()
		local resolved, name = ResolveRunSignal(signal, "PreAnimation")
		self._boundSignal = name
		self._updateConnection = resolved:Connect(function(dt)
			self:Update(dt)
		end)
		return self
	end
	function StateMachine:Unbind()
		if self._updateConnection then
			self._updateConnection:Disconnect()
			self._updateConnection = nil
		end
		self._boundSignal = nil
		return self
	end
	function StateMachine:GetBoundSignal()
		return self._boundSignal
	end
	function StateMachine:StartAndBind(signal)
		self:Start()
		return self:Bind(signal)
	end
	function StateMachine:Update(dt)
		if not self.enabled or self.paused then
			return false
		end
		local nextState = self:ResolveState()
		local animation = self:_GetAnimation(nextState)
		if not animation then
			self.state = nextState
			return false
		end

		if self.state ~= nextState or self.animator.track ~= animation.Track then
			self.state = nextState
			self.animator:SetTrack(animation.Track)
			self.animator.looped = animation.Looped
			self.animator.map = animation.Map
			self.animator:AdjustSpeed(animation.Speed)
			self.animator:AdjustWeight(animation.Weight)
			self.animator:Play(0)
		end
		return self.animator:Update(dt)
	end
	function StateMachine:Destroy(resetPose)
		self:Unbind()
		if self._stateConnection then
			self._stateConnection:Disconnect()
			self._stateConnection = nil
		end
		self.animator:Destroy(resetPose)
		self.animations = {}
		self.rig = nil
		self.humanoid = nil
	end
	AnimLib.StateMachine = StateMachine
end
local function AssetGetPathFromFilename(filename)
	if filename:sub(-4, -1) == ".lua" or filename:sub(-4, -1) == ".txt" then
		return "BlaaBlaaReanim/Modules/" .. filename
	end
	local filetype = "Unknown/"
	if filename:sub(-4, -1) == ".mp3" then
		filetype = "Sounds/"
	elseif filename:sub(-5, -1) == ".anim" then
		filetype = "Anims/"
	elseif filename:sub(-4, -1) == ".png" then
		filetype = "Images/"
	elseif filename:sub(-5, -1) == ".rbxm" then
		filetype = "Unknown/"
	end
	return "BlaaBlaaReanim/Content/" .. filetype .. filename
end
local _Assetdownloading = {}
local _Assetdownloadingcount, _Assetdownloadingfail = 0, 0

local function _UpdateDownloadStatus()
	local prog = 1 / ((_Assetdownloadingcount + _Assetdownloadingfail) / 2 + 1)
	if _Assetdownloadingcount > 0 then
		Util.UINotify("Downloading " .. _Assetdownloadingcount .. " assets...", prog)
	else
		if _Assetdownloadingfail > 0 then
			Util.UINotify(_Assetdownloadingfail .. " failed to download", prog)
		else
			Util.UINotify("Asset download done", 1)
		end
	end
end

local function AssetDownloadAgent(source, filename, path)
	if isfile(path) then return true end
	if _Assetdownloading[filename] then return false end
	_Assetdownloading[filename] = true
	
	task.spawn(function()
		_Assetdownloadingcount += 1
		_UpdateDownloadStatus()
		
		local s, resp = pcall(request, {
			Method = "GET",
			Url = source,
		})
		
		if s and resp and resp.StatusCode == 200 then
			_Assetdownloadingcount -= 1
			_UpdateDownloadStatus()
			pcall(writefile, path, resp.Body)
		else
			_Assetdownloadingcount -= 1
			_Assetdownloadingfail += 1
			_UpdateDownloadStatus()
		end
		
		task.wait(10)
		_Assetdownloadingfail = math.max(0, _Assetdownloadingfail - 1)
		_UpdateDownloadStatus()
		
		_Assetdownloading[filename] = nil
	end)
	return false
end

local function AssetDownload(filename)
	local source = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/content/" .. filename
	local split = string.split(filename, "@")
	if #split > 1 then
		filename = table.remove(split, 1)
		source = table.concat(split, "@")
	end
	if source:sub(1, 7) == "MARKET/" then
		source = "https://raw.githubusercontent.com/JustAMaleScripts/BlaaBlaa/main/community/" .. source:sub(8)
	end
	local path = AssetGetPathFromFilename(filename)
	return AssetDownloadAgent(source, filename, path)
end

local function AssetGetContentId(filename)
	local path = AssetGetPathFromFilename(filename)
	if not isfile(path) then return "" end
	local s, id = pcall(getcustomasset, path)
	if s and id then
		return id
	end
	return ""
end

local function AssetEnsure(list)
	local ok = true
	for _, filename in list do
		if not AssetDownload(filename) then
			ok = false
		end
	end
	return ok
end

-- =============================================
-- AssetDownloadFolder (GitHub Contents API, parallel)
-- =============================================
local function AssetDownloadFolder(githubFolderRelativePath)
	if not githubFolderRelativePath or githubFolderRelativePath == "" then
		Util.UINotify("Invalid folder path")
		return false
	end

	Util.UINotify("Fetching folder contents...")
	local baseApi = "https://api.github.com/repos/JustAMaleScripts/BlaaBlaa/contents/community/"
	local safePath = githubFolderRelativePath:gsub(" ", "%%20"):gsub("'", "%%27")

	-- Choose local path: files inside a Modules/ subfolder go to BlaaBlaaReanim/Modules/
	local function resolveLocalPath(filename, subfolderName)
		if subfolderName and subfolderName:lower() == "modules" then
			return "BlaaBlaaReanim/Modules/" .. filename
		end
		return AssetGetPathFromFilename(filename)
	end

	local function enumFolder(apiSubPath, subfolderName)
		local s, resp = pcall(request, { Method = "GET", Url = baseApi .. apiSubPath, Headers = { Accept = "application/vnd.github.v3+json" } })
		if not s or not resp or resp.StatusCode ~= 200 then return end
		for entry in resp.Body:gmatch("{[^}]+}") do
			local etype = entry:match('"type"%s*:%s*"([^"]+)"')
			local ename = entry:match('"name"%s*:%s*"([^"]+)"')
			local eurl  = entry:match('"download_url"%s*:%s*"([^"]+)"')
			if etype == "dir" and ename then
				-- spawn each subfolder in parallel so they don't block each other
				task.spawn(enumFolder, apiSubPath .. ename .. "/", ename)
			elseif etype == "file" and ename and eurl then
				eurl = eurl:gsub("\\/", "/")
				local path = resolveLocalPath(ename, subfolderName)
				AssetDownloadAgent(eurl, ename, path)
			end
		end
	end

	task.spawn(enumFolder, safePath, nil)
	return true
end

local function ProtectedChat(content)
	pcall(function()
		TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration").TargetTextChannel:SendAsync(content, Util.RandomString(64))
	end)
end
local OnPlayerChatted = Util.Instance("BindableEvent")
TextChatService.MessageReceived:Connect(function(message)
	if message.Status ~= Enum.TextChatMessageStatus.Sending and message.TextSource and message.TextSource.UserId then
		local plr, msg = Players:GetPlayerByUserId(message.TextSource.UserId), message.Text:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&quot;", "\""):gsub("&apos;", "'"):gsub("&amp;", "&")
		if plr then
			OnPlayerChatted:Fire(plr, msg)
			if msg == "67" then
				Util.UINotify("Son, Shut up.")
			end
			if msg == "1.1.0" then
				Util.UINotify("the overhaul update is real? on Uhhhhhh Reanimate??")
			end
			if msg == "BlaaBlaa is Fake" then
				util.UINotify(rng({
					"Yeah Bro, no trust.",
					"No life.",
					"Nothing in everywhere...",
					"That's all...",
				}))
			task.wait(2)
			end
		end
	end
end)
task.wait()

local MovementStyles = {}
local DanceableDances = {}

local CurrentMovementStyle = nil
local MovementStyleIndex = 2
local _MovementStyleIndex = nil
local CurrentDance = nil
local _CurrentDance = nil
local OldReanimCharacter = nil

local function SetAnimLibOption(name, value)
	SavedAnimLibOptions[name] = value
	AnimLib.Settings[name] = value
end

local function ResetDancePose(figure, force)
	if not force and not AnimLib.Settings.ResetPoseOnStop then
		return
	end
	if typeof(figure) ~= "Instance" then
		return
	end
	for _, descendant in figure:GetDescendants() do
		if descendant:IsA("Motor6D") then
			descendant.Transform = CFrame.identity
		end
	end
end

do
-- Forked from the mouse/camera head tracking in the bundled Krystal Dance V3
-- moveset. This is applied at the final render stage so it can layer over, or
-- deliberately replace, the neck pose written by a moveset or dance.
local KrystalHeadOverlay = {
	Character = nil,
	Neck = nil,
	BaseC0 = nil,
	Offset = CFrame.identity,
	UnderlyingTransform = CFrame.identity,
	LastAppliedTransform = nil,
}

local function CFrameAlmostEqual(a, b)
	if typeof(a) ~= "CFrame" or typeof(b) ~= "CFrame" then
		return false
	end
	local delta = a:ToObjectSpace(b)
	local _, angle = delta:ToAxisAngle()
	return delta.Position.Magnitude < 0.0001 and math.abs(angle) < 0.0001
end

local function FindCharacterNeck(figure)
	if typeof(figure) ~= "Instance" then
		return nil
	end
	local head = figure:FindFirstChild("Head")
	local torso = figure:FindFirstChild("Torso") or figure:FindFirstChild("UpperTorso")
	if not head or not torso then
		return nil
	end

	local neck = torso:FindFirstChild("Neck")
	if neck and neck:IsA("Motor6D") then
		return head, torso, neck
	end
	for _, descendant in figure:GetDescendants() do
		if descendant:IsA("Motor6D") and descendant.Name == "Neck" and descendant.Part1 == head then
			return head, descendant.Part0 or torso, descendant
		end
	end
	return nil
end

local function RemoveKrystalHeadOverlay(neck)
	neck = neck or KrystalHeadOverlay.Neck
	if neck and neck.Parent and KrystalHeadOverlay.LastAppliedTransform then
		pcall(function()
			if CFrameAlmostEqual(neck.Transform, KrystalHeadOverlay.LastAppliedTransform) then
				neck.Transform = KrystalHeadOverlay.UnderlyingTransform or CFrame.identity
			end
		end)
	end
	KrystalHeadOverlay.Offset = CFrame.identity
	KrystalHeadOverlay.UnderlyingTransform = CFrame.identity
	KrystalHeadOverlay.LastAppliedTransform = nil
end

local function ApplyKrystalHeadOverlay(dt, figure)
	local head, torso, neck = FindCharacterNeck(figure)
	if not neck then
		RemoveKrystalHeadOverlay()
		KrystalHeadOverlay.Character = nil
		KrystalHeadOverlay.Neck = nil
		KrystalHeadOverlay.BaseC0 = nil
		return
	end

	if KrystalHeadOverlay.Character ~= figure or KrystalHeadOverlay.Neck ~= neck then
		RemoveKrystalHeadOverlay()
		KrystalHeadOverlay.Character = figure
		KrystalHeadOverlay.Neck = neck
		KrystalHeadOverlay.BaseC0 = neck.C0
	end

	if not AnimLib.Settings.KrystalHeadTracking then
		RemoveKrystalHeadOverlay(neck)
		return
	end

	local targetPosition = nil
	if UserInputService.TouchEnabled then
		local camera = workspace.CurrentCamera
		if camera then
			targetPosition = camera.CFrame * Vector3.new(0, 0, -10000)
		end
	else
		local success, mousePosition = pcall(function()
			return Player:GetMouse().Hit.Position
		end)
		if success then
			targetPosition = mousePosition
		end
	end
	if typeof(targetPosition) ~= "Vector3" then
		local camera = workspace.CurrentCamera
		if camera then
			targetPosition = camera.CFrame * Vector3.new(0, 0, -10000)
		end
	end
	if typeof(targetPosition) ~= "Vector3" then
		return
	end

	local difference = head.Position - targetPosition
	if difference.Magnitude < 0.0001 then
		return
	end
	local direction = difference.Unit
	local strength = math.clamp(tonumber(AnimLib.Settings.KrystalHeadStrength) or 1, 0, 1.5)
	local pitch = math.clamp(math.atan(direction.Y) * strength, math.rad(-75), math.rad(75))
	local yaw = math.clamp(direction:Cross(torso.CFrame.LookVector).Y * strength, math.rad(-75), math.rad(75))
	local targetOffset = CFrame.Angles(pitch, 0, yaw)
	local smoothing = math.clamp(tonumber(AnimLib.Settings.KrystalHeadSmoothing) or 10, 1, 30)
	local alpha = 1 - math.exp(-smoothing * math.max(tonumber(dt) or 0, 0))
	KrystalHeadOverlay.Offset = KrystalHeadOverlay.Offset:Lerp(targetOffset, math.clamp(alpha, 0, 1))

	local animationTransform = neck.Transform
	if
		KrystalHeadOverlay.LastAppliedTransform
		and CFrameAlmostEqual(animationTransform, KrystalHeadOverlay.LastAppliedTransform)
	then
		animationTransform = KrystalHeadOverlay.UnderlyingTransform or CFrame.identity
	end
	KrystalHeadOverlay.UnderlyingTransform = animationTransform

	local appliedTransform = animationTransform * KrystalHeadOverlay.Offset
	if AnimLib.Settings.KrystalHeadOverride then
		-- Reset legacy C0-based head motion (including Krystal's original local
		-- tracker) and replace the animation's Neck.Transform with the overlay.
		neck.C0 = KrystalHeadOverlay.BaseC0 or neck.C0
		appliedTransform = KrystalHeadOverlay.Offset
	end
	neck.Transform = appliedTransform
	KrystalHeadOverlay.LastAppliedTransform = appliedTransform
end

-- Adapted from the visualizer and character-afterimage effects in Valtta's
-- bundled Eyes Closed community dance. These are global, saved dance effects
-- now, so they can be used without coupling them to one animation module.
local DanceEffects = {
	Character = nil,
	RingPart = nil,
	RingBars = {},
	Ghosts = {},
	GhostTimer = 0,
	SmoothedLoudness = 0,
	AnchorSource = "Waiting for a dance",
}
local DanceEffectRingSegments = 64

local function GetDanceEffectAccent()
	local color = ParseDanceEffectColor(SavedDanceEffectsOptions.Accent)
	return color or Color3.fromRGB(0, 255, 255)
end

local function DestroyDanceEffectVisualizer()
	if DanceEffects.RingPart then
		DanceEffects.RingPart:Destroy()
	end
	DanceEffects.RingPart = nil
	DanceEffects.RingBars = {}
	DanceEffects.SmoothedLoudness = 0
end

local function DestroyDanceEffectGhosts()
	for _, ghost in DanceEffects.Ghosts do
		if ghost.Model then
			ghost.Model:Destroy()
		end
	end
	DanceEffects.Ghosts = {}
	DanceEffects.GhostTimer = 0
end

local function ResetDanceEffects(figure)
	DestroyDanceEffectVisualizer()
	DestroyDanceEffectGhosts()
	DanceEffects.Character = figure
	DanceEffects.AnchorSource = "Waiting for a dance"
end

local function IsFiniteDanceEffectPosition(value)
	return typeof(value) == "Vector3"
		and value.X == value.X
		and value.Y == value.Y
		and value.Z == value.Z
		and value.X > -math.huge
		and value.X < math.huge
		and value.Y > -math.huge
		and value.Y < math.huge
		and value.Z > -math.huge
		and value.Z < math.huge
end

local function IsFiniteDanceEffectCFrame(value)
	if typeof(value) ~= "CFrame" then
		return false
	end
	for _, component in { value:GetComponents() } do
		if type(component) ~= "number" or component ~= component or component <= -math.huge or component >= math.huge then
			return false
		end
	end
	return true
end

local function GetDanceEffectScale(figure)
	local scale = 1
	local success, value = pcall(function()
		return figure:GetScale()
	end)
	if success and type(value) == "number" and value == value and value > 0 and value < math.huge then
		scale = value
	end
	return scale
end

local function GetDanceEffectAnchor(figure, anchorMode)
	if not figure or not figure.Parent or not figure:IsA("Model") then
		return nil
	end
	local root = figure:FindFirstChild("HumanoidRootPart")
	if not root or not root:IsA("BasePart") then
		return nil
	end
	local cframeSuccess, rootCFrame = pcall(function()
		return root.CFrame
	end)
	if not cframeSuccess or not IsFiniteDanceEffectCFrame(rootCFrame) then
		return nil
	end
	local scale = GetDanceEffectScale(figure)
	local position = nil
	if anchorMode == "Blue Root Part" then
		position = root.Position
	elseif anchorMode == "Head" then
		local head = figure:FindFirstChild("Head")
		if head and head:IsA("BasePart") then
			position = head.Position
		end
	elseif anchorMode == "Torso" then
		local torso = figure:FindFirstChild("UpperTorso")
			or figure:FindFirstChild("Torso")
			or figure:FindFirstChild("LowerTorso")
		if torso and torso:IsA("BasePart") then
			position = torso.Position
		end
	elseif anchorMode == "Middle (Original)" then
		local head = figure:FindFirstChild("Head")
		local headY = head and head:IsA("BasePart") and head.Position.Y or root.Position.Y
		position = Vector3.new(root.Position.X, headY + 3.2 * scale, root.Position.Z)
	else
		local success, center = pcall(function()
			return root.AssemblyCenterOfMass
		end)
		if success then
			position = center
		end
	end
	if not IsFiniteDanceEffectPosition(position) then
		return nil
	end
	return position, root, scale, rootCFrame
end

local function GetDanceEffectAnchorRotation(anchorCFrame)
	if not SavedDanceEffectsOptions.StayVertical then
		return anchorCFrame.Rotation
	end
	local look = anchorCFrame.LookVector
	local flatLook = Vector3.new(look.X, 0, look.Z)
	if flatLook.Magnitude < 0.0001 then
		local right = anchorCFrame.RightVector
		local flatRight = Vector3.new(right.X, 0, right.Z)
		if flatRight.Magnitude >= 0.0001 then
			flatLook = Vector3.yAxis:Cross(flatRight.Unit)
		end
	end
	if flatLook.Magnitude < 0.0001 then
		return CFrame.identity
	end
	return CFrame.lookAt(Vector3.zero, flatLook.Unit, Vector3.yAxis)
end

local function CreateDanceEffectBar(parent, index, face)
	local angleDirection = face == Enum.NormalId.Bottom and -1 or 1
	local angle = angleDirection * (index / DanceEffectRingSegments) * math.pi * 2
	local bar = Instance.new("Frame")
	bar.Name = "Bar" .. index
	bar.AnchorPoint = Vector2.new(0.5, 1)
	bar.BackgroundColor3 = GetDanceEffectAccent()
	bar.BorderSizePixel = 0
	bar.Position = UDim2.fromOffset(128 + 88 * math.cos(angle) - 2.5, 128 + 88 * math.sin(angle))
	bar.Size = UDim2.fromOffset(5, 2)
	bar.Rotation = math.deg(angle) + 90
	bar.Parent = parent
	local stroke = Instance.new("UIStroke")
	stroke.Color = GetDanceEffectAccent():Lerp(Color3.new(1, 1, 1), 0.45)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = bar
	return bar, stroke
end

local function BuildDanceEffectFace(part, face)
	local surface = Instance.new("SurfaceGui")
	surface.Name = "DanceEffectRing_" .. face.Name
	surface.Face = face
	surface.LightInfluence = 0
	surface.Brightness = 4
	surface.AlwaysOnTop = false
	surface.MaxDistance = 100
	surface.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
	surface.CanvasSize = Vector2.new(256, 256)
	surface.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	surface.Parent = part
	local background = Instance.new("Frame")
	background.Size = UDim2.fromScale(1, 1)
	background.BackgroundTransparency = 1
	background.BorderSizePixel = 0
	background.Parent = surface
	local bars = {}
	for index = 1, DanceEffectRingSegments do
		local bar, stroke = CreateDanceEffectBar(background, index, face)
		bars[index] = { Bar = bar, Stroke = stroke }
	end
	return bars
end

local function BuildDanceEffectVisualizer()
	DestroyDanceEffectVisualizer()
	local part = Instance.new("Part")
	part.Name = "_UhhhhhhDanceEffectVisualizer"
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Transparency = 1
	part.Size = Vector3.new(8, 0.01, 8)
	-- Keep the anchored visualizer outside Reanimate.Character. The character's
	-- PreSimulation collision controller rewrites CanCollide on every direct
	-- BasePart child, which otherwise makes this invisible ring collidable in
	-- seated/physics states even though it starts with CanCollide = false.
	part.Parent = workspace
	DanceEffects.RingPart = part
	local top = BuildDanceEffectFace(part, Enum.NormalId.Top)
	local bottom = BuildDanceEffectFace(part, Enum.NormalId.Bottom)
	for index = 1, DanceEffectRingSegments do
		DanceEffects.RingBars[index] = {
			Top = top[index].Bar,
			TopStroke = top[index].Stroke,
			Bottom = bottom[index].Bar,
			BottomStroke = bottom[index].Stroke,
		}
	end
end

local function CloneDanceEffectInstance(source)
	local wasArchivable = source.Archivable
	local success, clone = pcall(function()
		if not wasArchivable then
			source.Archivable = true
		end
		return source:Clone()
	end)
	if not wasArchivable then
		pcall(function()
			source.Archivable = false
		end)
	end
	if not success then
		return nil
	end
	return clone
end

local function CloneDanceEffectPart(source, accent, imageScale, baseTransparency)
	local part = CloneDanceEffectInstance(source)
	if
		not part
		or not part:IsA("BasePart")
		or part.ClassName ~= source.ClassName
	then
		if part then
			part:Destroy()
		end
		return nil
	end
	-- MeshPart.MeshId cannot be assigned directly from ordinary scripts.
	-- ApplyMesh is the supported way to reassert the source geometry if a
	-- cloned avatar MeshPart was sanitized by the current experience/executor.
	if part:IsA("MeshPart") and source:IsA("MeshPart") then
		pcall(part.ApplyMesh, part, source)
	end
	for _, child in part:GetDescendants() do
		if child:IsA("DataModelMesh") then
			pcall(function()
				child.TextureId = ""
			end)
			pcall(function()
				child.VertexColor = Vector3.new(accent.R, accent.G, accent.B)
			end)
			-- FileMesh geometry uses SpecialMesh.Scale instead of the ordinary
			-- part-size path. Built-in Head/Brick/Sphere/Cylinder mesh types are
			-- already scaled by their parent part and must not be scaled twice.
			if child:IsA("SpecialMesh") and child.MeshType == Enum.MeshType.FileMesh then
				pcall(function()
					child.Scale *= imageScale
					child.Offset *= imageScale
				end)
			end
		elseif not child:IsA("Bone") then
			child:Destroy()
		end
	end
	if part:IsA("MeshPart") then
		pcall(function()
			part.TextureID = ""
		end)
	end
	part.Name = source.Name
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Material = Enum.Material.Neon
	part.Color = accent
	part.Transparency = baseTransparency
	part.LocalTransparencyModifier = 0
	part.AssemblyLinearVelocity = Vector3.zero
	part.AssemblyAngularVelocity = Vector3.zero
	-- Shrink around this body's own center. Scaling the complete ghost model
	-- would pull limbs toward a shared pivot, causing a leg afterimage to drift
	-- away from the center of the live leg.
	part.Size = source.Size * imageScale
	part.CFrame = source.CFrame
	return part
end

-- Keep afterimages limited to the avatar skeleton. Community modules often
-- parent their props and visual-effect parts directly below the character, so
-- scanning every BasePart also cloned swords, rings, trails, and similar
-- addon geometry. The name filter covers the standard R6/R15 body layouts;
-- GetBodyPartR15 additionally rejects a lookalike part on R15 characters.
local DanceEffectBodyPartNames = {
	Head = true,
	Torso = true,
	UpperTorso = true,
	LowerTorso = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true,
	LeftUpperArm = true,
	LeftLowerArm = true,
	LeftHand = true,
	RightUpperArm = true,
	RightLowerArm = true,
	RightHand = true,
	LeftUpperLeg = true,
	LeftLowerLeg = true,
	LeftFoot = true,
	RightUpperLeg = true,
	RightLowerLeg = true,
	RightFoot = true,
}

local function IsDanceEffectBodyPart(figure, source)
	if
		not source:IsA("BasePart")
		or source.Parent ~= figure
		or DanceEffectBodyPartNames[source.Name] ~= true
	then
		return false
	end
	local humanoid = figure:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
		local success, bodyPart = pcall(humanoid.GetBodyPartR15, humanoid, source)
		if success then
			return bodyPart ~= Enum.BodyPartR15.Unknown
		end
	end
	return true
end

local function IsDanceEffectBodyPartVisible(source)
	return SavedDanceEffectsOptions.AfterimageHiddenParts[source.Name] ~= true
end

local function GetDetectedDanceEffectBodyParts(figure)
	local names = {}
	if typeof(figure) ~= "Instance" or not figure:IsA("Model") or not figure.Parent then
		return names
	end
	for _, source in figure:GetChildren() do
		if IsDanceEffectBodyPart(figure, source) then
			table.insert(names, source.Name)
		end
	end
	table.sort(names)
	return names
end

do
-- Hidden physical parts use a dedicated target controller at the safe edge of
-- the void. Each reanimator redirects its existing replicated physics writer to
-- these targets; the animated controller itself is never moved or transformed.
local BodyHideR15ToR6 = {
	UpperTorso = "Torso",
	LowerTorso = "Torso",
	LeftUpperArm = "Left Arm",
	LeftLowerArm = "Left Arm",
	LeftHand = "Left Arm",
	RightUpperArm = "Right Arm",
	RightLowerArm = "Right Arm",
	RightHand = "Right Arm",
	LeftUpperLeg = "Left Leg",
	LeftLowerLeg = "Left Leg",
	LeftFoot = "Left Leg",
	RightUpperLeg = "Right Leg",
	RightLowerLeg = "Right Leg",
	RightFoot = "Right Leg",
}

local BodyHideAttachmentParts = {
	HatAttachment = "Head",
	HairAttachment = "Head",
	FaceFrontAttachment = "Head",
	FaceCenterAttachment = "Head",
	NeckAttachment = "Torso",
	BodyFrontAttachment = "Torso",
	BodyBackAttachment = "Torso",
	WaistFrontAttachment = "Torso",
	WaistBackAttachment = "Torso",
	WaistCenterAttachment = "Torso",
	LeftShoulderAttachment = "Left Arm",
	LeftGripAttachment = "Left Arm",
	RightShoulderAttachment = "Right Arm",
	RightGripAttachment = "Right Arm",
	LeftFootAttachment = "Left Leg",
	RightFootAttachment = "Right Leg",
}

local BodyHideTargetController = Instance.new("Model")
BodyHideTargetController.Name = "_Uhhhhhh_BodyHideTargetController"
BodyHideTargetController.Archivable = false
BodyHideTargetController.Parent = workspace
local BodyHideTargetParts = {}

local function IsFiniteBodyHideNumber(value)
	return type(value) == "number"
		and value == value
		and value > -math.huge
		and value < math.huge
end

local function GetBodyHideTargetY()
	local destroyHeight = FallenPartsDestroyHeight
	if not IsFiniteBodyHideNumber(destroyHeight) then
		destroyHeight = -500
	end
	return destroyHeight + 5
end

local function GetCanonicalBodyHidePartName(partName)
	if type(partName) ~= "string" then
		return nil
	end
	return BodyHideR15ToR6[partName] or partName
end

local function IsBodyHidePartSelected(partName)
	local canonical = GetCanonicalBodyHidePartName(partName)
	return canonical ~= nil
		and (
			SavedAnimLibOptions.HiddenBodyParts[partName] == true
			or SavedAnimLibOptions.HiddenBodyParts[canonical] == true
		)
end

local function ShouldRedirectBodyHidePart(partName, accessory)
	return IsBodyHidePartSelected(partName)
		and (accessory ~= true or not AnimLib.Settings.KeepAccessoriesWhenHiding)
end

local function GetBodyHideAccessoryAnchorName(physicalPart, normalTarget)
	local function ReadWeldAnchor(handle)
		if typeof(handle) ~= "Instance" or not handle:IsA("BasePart") then
			return nil
		end
		local weld = handle:FindFirstChild("AccessoryWeld")
		if weld and weld:IsA("JointInstance") then
			local part0, part1 = weld.Part0, weld.Part1
			if part0 and part0 ~= handle then
				return part0.Name
			elseif part1 and part1 ~= handle then
				return part1.Name
			end
		end
		return nil
	end

	local anchorName = ReadWeldAnchor(normalTarget) or ReadWeldAnchor(physicalPart)
	if anchorName then
		return anchorName
	end
	for _, candidate in { physicalPart, normalTarget } do
		if typeof(candidate) == "Instance" and candidate:IsA("BasePart") then
			for _, child in candidate:GetChildren() do
				if child:IsA("Attachment") and BodyHideAttachmentParts[child.Name] then
					return BodyHideAttachmentParts[child.Name]
				end
			end
		end
	end
	return nil
end

local function GetBodyHideTargetPart(partName, normalCFrame)
	local canonical = GetCanonicalBodyHidePartName(partName)
	if not canonical or typeof(normalCFrame) ~= "CFrame" then
		return nil
	end
	local target = BodyHideTargetParts[canonical]
	if not target or not target.Parent then
		target = Instance.new("Part")
		target.Name = canonical .. " Void Target"
		target.Size = Vector3.one
		target.Transparency = 1
		target.Anchored = true
		target.CanCollide = false
		target.CanQuery = false
		target.CanTouch = false
		target.CastShadow = false
		target.Archivable = false
		target.Parent = BodyHideTargetController
		BodyHideTargetParts[canonical] = target
	end
	local position = normalCFrame.Position
	local x = IsFiniteBodyHideNumber(position.X) and position.X or 0
	local z = IsFiniteBodyHideNumber(position.Z) and position.Z or 0
	target.CFrame = CFrame.new(x, GetBodyHideTargetY(), z) * normalCFrame.Rotation
	return target
end

local function ResolveBodyHideTargetPart(physicalPart, normalTarget, explicitPartName, accessory)
	if typeof(normalTarget) ~= "Instance" or not normalTarget:IsA("BasePart") then
		return normalTarget
	end
	local isAccessory = accessory == true
	if accessory == nil and typeof(physicalPart) == "Instance" then
		isAccessory = physicalPart:FindFirstAncestorWhichIsA("Accessory") ~= nil
	end
	local partName = explicitPartName
		or (isAccessory and GetBodyHideAccessoryAnchorName(physicalPart, normalTarget))
		or (typeof(physicalPart) == "Instance" and physicalPart.Name)
	if not ShouldRedirectBodyHidePart(partName, isAccessory) then
		return normalTarget
	end
	return GetBodyHideTargetPart(partName, normalTarget.CFrame) or normalTarget
end

local function GetBodyHideTargetInfo(physicalPart, normalTarget, explicitPartName, accessory)
	local isAccessory = accessory == true
	if accessory == nil and typeof(physicalPart) == "Instance" then
		isAccessory = physicalPart:FindFirstAncestorWhichIsA("Accessory") ~= nil
	end
	local partName = explicitPartName
		or (isAccessory and GetBodyHideAccessoryAnchorName(physicalPart, normalTarget))
		or (typeof(physicalPart) == "Instance" and physicalPart.Name)
	local canonical = GetCanonicalBodyHidePartName(partName)
	return ShouldRedirectBodyHidePart(partName, isAccessory), canonical
end

local function ResolveBodyHideTargetCFrame(physicalPart, normalCFrame, explicitPartName, accessory)
	if typeof(normalCFrame) ~= "CFrame" then
		return normalCFrame
	end
	local isAccessory = accessory == true
	if accessory == nil and typeof(physicalPart) == "Instance" then
		isAccessory = physicalPart:FindFirstAncestorWhichIsA("Accessory") ~= nil
	end
	local partName = explicitPartName
		or (typeof(physicalPart) == "Instance" and physicalPart.Name)
	if not ShouldRedirectBodyHidePart(partName, isAccessory) then
		return normalCFrame
	end
	local target = GetBodyHideTargetPart(partName, normalCFrame)
	return target and target.CFrame or normalCFrame
end

Reanimate.GetBodyHideCanonicalName = GetCanonicalBodyHidePartName
Reanimate.ShouldBodyHidePart = IsBodyHidePartSelected
Reanimate.ResolveBodyHideTargetPart = ResolveBodyHideTargetPart
Reanimate.ResolveBodyHideTargetCFrame = ResolveBodyHideTargetCFrame

local BodyHideGlobal = (getgenv and getgenv()) or shared or _G
local PreviousBodyHideTargetInfo = BodyHideGlobal.UhhhhhhTBZGetBodyHideTargetInfo
BodyHideGlobal.UhhhhhhTBZGetBodyHideTargetInfo = GetBodyHideTargetInfo
SCREENGUI.Destroying:Once(function()
	if BodyHideGlobal.UhhhhhhTBZGetBodyHideTargetInfo == GetBodyHideTargetInfo then
		BodyHideGlobal.UhhhhhhTBZGetBodyHideTargetInfo = PreviousBodyHideTargetInfo
	end
	BodyHideTargetController:Destroy()
end)

AddToRenderStep(function(_, dt)
	ApplyKrystalHeadOverlay(dt, Reanimate.Character)
end)
end

local function GetDanceEffectGhostSource(figure)
	local realCharacter = Player.Character
	if realCharacter and realCharacter ~= figure and realCharacter.Parent then
		local humanoid = realCharacter:FindFirstChildOfClass("Humanoid")
		local isAlive = humanoid
			and humanoid.Health > 0
			and humanoid:GetState() ~= Enum.HumanoidStateType.Dead
		if isAlive then
			for _, source in realCharacter:GetChildren() do
				if IsDanceEffectBodyPart(realCharacter, source) then
					return realCharacter
				end
			end
		end
	end
	return figure
end

local DanceEffectR6CharacterMeshParts = {
	[Enum.BodyPart.Head] = { "Head", Vector3.new(2, 1, 1) },
	[Enum.BodyPart.Torso] = { "Torso", Vector3.new(2, 2, 1) },
	[Enum.BodyPart.LeftArm] = { "Left Arm", Vector3.new(1, 2, 1) },
	[Enum.BodyPart.RightArm] = { "Right Arm", Vector3.new(1, 2, 1) },
	[Enum.BodyPart.LeftLeg] = { "Left Leg", Vector3.new(1, 2, 1) },
	[Enum.BodyPart.RightLeg] = { "Right Leg", Vector3.new(1, 2, 1) },
}

local function ApplyDanceEffectR6CharacterMeshes(sourceFigure, ghost, accent, imageScale)
	local sourceHumanoid = sourceFigure:FindFirstChildOfClass("Humanoid")
	if not sourceHumanoid or sourceHumanoid.RigType ~= Enum.HumanoidRigType.R6 then
		return
	end
	for _, sourceAppearance in sourceFigure:GetChildren() do
		if sourceAppearance:IsA("CharacterMesh") then
			local mapping = DanceEffectR6CharacterMeshParts[sourceAppearance.BodyPart]
			local meshId = tonumber(sourceAppearance.MeshId)
			if mapping and meshId and meshId > 0 then
				local partName, standardSize = mapping[1], mapping[2]
				local sourcePart = sourceFigure:FindFirstChild(partName)
				local ghostPart = ghost:FindFirstChild(partName)
				if sourcePart and sourcePart:IsA("BasePart") and ghostPart and ghostPart:IsA("BasePart") then
					-- CharacterMesh normally needs a Humanoid, but an effect Humanoid can
					-- rewrite collision/state on its model. Convert the package geometry
					-- to a local SpecialMesh instead so every ghost remains visual-only.
					for _, child in ghostPart:GetChildren() do
						if child:IsA("DataModelMesh") then
							child:Destroy()
						end
					end
					local packageMesh = Instance.new("SpecialMesh")
					packageMesh.Name = "_UhhhhhhR6CharacterMesh"
					packageMesh.MeshType = Enum.MeshType.FileMesh
					packageMesh.MeshId = "rbxassetid://" .. math.floor(meshId)
					packageMesh.TextureId = ""
					packageMesh.VertexColor = Vector3.new(accent.R, accent.G, accent.B)
					packageMesh.Scale = Vector3.new(
						sourcePart.Size.X / standardSize.X,
						sourcePart.Size.Y / standardSize.Y,
						sourcePart.Size.Z / standardSize.Z
					) * imageScale
					packageMesh.Parent = ghostPart
				end
			end
		end
	end
end

local function SpawnDanceEffectGhost(figure)
	local accent = GetDanceEffectAccent()
	local imageScale = math.clamp(tonumber(SavedDanceEffectsOptions.AfterimageScale) or 0.86, 0.25, 1.5)
	local baseTransparency = math.clamp(
		(tonumber(SavedDanceEffectsOptions.AfterimageTransparency) or 55) / 100,
		0,
		1
	)
	local sourceFigure = GetDanceEffectGhostSource(figure)
	local ghost = Instance.new("Model")
	ghost.Name = "_UhhhhhhDanceEffectAfterimage"
	local partCount = 0
	local lightParent = nil
	for _, source in sourceFigure:GetDescendants() do
		if IsDanceEffectBodyPart(sourceFigure, source)
			and IsDanceEffectBodyPartVisible(source)
			and partCount < 20
		then
			local part = CloneDanceEffectPart(source, accent, imageScale, baseTransparency)
			if part then
				part.Parent = ghost
				partCount += 1
				if source.Name == "Torso" or source.Name == "UpperTorso" then
					lightParent = part
				end
			end
		end
	end
	if partCount == 0 then
		ghost:Destroy()
		return
	end
	ApplyDanceEffectR6CharacterMeshes(sourceFigure, ghost, accent, imageScale)
	lightParent = lightParent or ghost:FindFirstChildWhichIsA("BasePart")
	if lightParent then
		local light = Instance.new("PointLight")
		light.Enabled = SavedDanceEffectsOptions.AfterimageGlowEnabled
		light.Brightness = SavedDanceEffectsOptions.AfterimageGlowBrightness
		light.Range = SavedDanceEffectsOptions.AfterimageGlowRange * imageScale
		light.Color = accent
		light.Shadows = false
		light.Parent = lightParent
	end
	ghost.Parent = workspace
	table.insert(DanceEffects.Ghosts, { Model = ghost, Elapsed = 0, ImageScale = imageScale })
end

local function UpdateDanceEffectGhosts(dt)
	local accent = GetDanceEffectAccent()
	local fadeSpeed = math.clamp(tonumber(SavedDanceEffectsOptions.AfterimageFadeSpeed) or 1, 0.25, 4)
	local baseTransparency = math.clamp(
		(tonumber(SavedDanceEffectsOptions.AfterimageTransparency) or 55) / 100,
		0,
		1
	)
	local lightVisibility = math.clamp((1 - baseTransparency) / 0.45, 0, 2.25)
	local glowEnabled = SavedDanceEffectsOptions.AfterimageGlowEnabled
	local glowBrightness = math.clamp(
		tonumber(SavedDanceEffectsOptions.AfterimageGlowBrightness) or 1.5,
		0,
		10
	)
	local glowRange = math.clamp(tonumber(SavedDanceEffectsOptions.AfterimageGlowRange) or 7, 0, 30)
	local index = 1
	while index <= #DanceEffects.Ghosts do
		local ghost = DanceEffects.Ghosts[index]
		ghost.Elapsed += dt
		local alpha = ghost.Elapsed * fadeSpeed
		if alpha >= 1 or not ghost.Model.Parent then
			ghost.Model:Destroy()
			table.remove(DanceEffects.Ghosts, index)
		else
			for _, descendant in ghost.Model:GetDescendants() do
				if descendant:IsA("BasePart") then
					-- Enforce this throughout the ghost lifetime. This also repairs any
					-- collision flags copied or rewritten after the model was parented.
					descendant.Anchored = true
					descendant.CanCollide = false
					descendant.CanTouch = false
					descendant.CanQuery = false
					descendant.AssemblyLinearVelocity = Vector3.zero
					descendant.AssemblyAngularVelocity = Vector3.zero
					descendant.Transparency = baseTransparency + alpha * (1 - baseTransparency)
					descendant.Color = accent:Lerp(Color3.new(0, 0, 0), alpha * 0.75)
				elseif descendant:IsA("PointLight") then
					descendant.Color = accent
					descendant.Enabled = glowEnabled and glowBrightness > 0 and glowRange > 0
					descendant.Brightness = glowBrightness * lightVisibility * (1 - alpha)
					descendant.Range = glowRange * (ghost.ImageScale or 1)
				end
			end
			index += 1
		end
	end
end

local function UpdateDanceEffectVisualizer(dt, figure)
	local root = nil
	local position = nil
	local scale = 1
	local anchorCFrame = nil
	local anchorMode = SavedDanceEffectsOptions.AnchorMode
	if anchorMode == "Blue Root Part" then
		-- The cyan hitbox always represents the controller rig's root. Keep this
		-- selection explicit even when DyPos would normally prefer Player.Character.
		position, root, scale, anchorCFrame = GetDanceEffectAnchor(figure, anchorMode)
		if position then
			DanceEffects.AnchorSource = "Cyan reanimated root â Blue Root Part"
		end
	elseif SavedDanceEffectsOptions.DynamicPosition then
		local realCharacter = Player.Character
		if realCharacter and realCharacter ~= figure then
			position, root, scale, anchorCFrame = GetDanceEffectAnchor(realCharacter, anchorMode)
			if position then
				DanceEffects.AnchorSource = "Real character â " .. anchorMode
			end
		end
		if not position then
			position, root, scale, anchorCFrame = GetDanceEffectAnchor(figure, anchorMode)
			if position then
				DanceEffects.AnchorSource = "Red character â " .. anchorMode .. " (fallback)"
			end
		end
	else
		position, root, scale, anchorCFrame = GetDanceEffectAnchor(figure, anchorMode)
		if position then
			DanceEffects.AnchorSource = "Red character â " .. anchorMode
		end
	end
	if
		not root
		or not root:IsA("BasePart")
		or not IsFiniteDanceEffectPosition(position)
		or not IsFiniteDanceEffectCFrame(anchorCFrame)
	then
		DanceEffects.AnchorSource = "No valid character anchor"
		DestroyDanceEffectVisualizer()
		return
	end
	if not DanceEffects.RingPart or not DanceEffects.RingPart.Parent then
		BuildDanceEffectVisualizer()
	end
	local size = SavedDanceEffectsOptions.Size
	-- Defend against game scripts or state controllers changing these flags
	-- after construction. This effect must remain visual-only.
	DanceEffects.RingPart.CanCollide = false
	DanceEffects.RingPart.CanTouch = false
	DanceEffects.RingPart.CanQuery = false
	DanceEffects.RingPart.Size = Vector3.new(8 * scale * size, 0.01, 8 * scale * size)
	local offset = anchorCFrame:VectorToWorldSpace(
		Vector3.new(SavedDanceEffectsOptions.OffsetX * scale, 0, SavedDanceEffectsOptions.OffsetZ * scale)
	)
	position += offset + Vector3.new(0, SavedDanceEffectsOptions.OffsetY * scale, 0)
	DanceEffects.RingPart.CFrame = CFrame.new(position)
		* GetDanceEffectAnchorRotation(anchorCFrame)
		* CFrame.Angles(
			math.rad(SavedDanceEffectsOptions.RotationX),
			math.rad(SavedDanceEffectsOptions.RotationY),
			math.rad(SavedDanceEffectsOptions.RotationZ)
		)

	local playing = UISound.DanceMusic.IsPlaying
	local loudness = playing and math.clamp(UISound.DanceMusic.PlaybackLoudness / 550, 0, 1) or 0
	if playing and loudness < 0.01 then
		local time = UISound.DanceMusic.TimePosition
		loudness = 0.35 + math.abs(math.sin(time * 2.1)) * 0.25
	end
	local smoothingAlpha = 1 - math.exp(-12 * math.max(tonumber(dt) or 0, 0))
	DanceEffects.SmoothedLoudness += (loudness - DanceEffects.SmoothedLoudness) * smoothingAlpha
	local time = playing and UISound.DanceMusic.TimePosition or os.clock()
	local accent = GetDanceEffectAccent()
	local strokeColor = accent:Lerp(Color3.new(1, 1, 1), 0.45)
	for index, pair in DanceEffects.RingBars do
		local fraction = (index - 1) / DanceEffectRingSegments
		local phase = fraction * math.pi * 2
		local band = math.abs(math.sin(time * 2.1 + phase * 0.5)) * 0.55
			+ math.abs(math.sin(time * 5.3 + phase * 1.2 + 1.1)) * 0.3
			+ math.abs(math.sin(time * 11.7 + phase * 2.5 + 2.3)) * 0.15
		local amplitude = math.clamp(DanceEffects.SmoothedLoudness * (0.55 + band * 0.75), 0.06, 1)
		local barSize = UDim2.fromOffset(5, math.max(2, math.floor(amplitude * 30)))
		local barColor = accent:Lerp(Color3.new(1, 1, 1), amplitude * 0.45)
		pair.Top.Size = barSize
		pair.Top.BackgroundColor3 = barColor
		pair.TopStroke.Color = strokeColor
		pair.Bottom.Size = barSize
		pair.Bottom.BackgroundColor3 = barColor
		pair.BottomStroke.Color = strokeColor
	end
end

local function UpdateDanceEffects(dt)
	local figure = Reanimate.Character
	local active = CurrentDance ~= nil and figure and figure.Parent
	if DanceEffects.Character ~= figure then
		ResetDanceEffects(figure)
	end
	if not active then
		if DanceEffects.RingPart or #DanceEffects.Ghosts > 0 or DanceEffects.GhostTimer > 0 then
			ResetDanceEffects(figure)
		end
		return
	end
	if SavedDanceEffectsOptions.VisualizerEnabled then
		UpdateDanceEffectVisualizer(dt, figure)
	elseif DanceEffects.RingPart then
		DestroyDanceEffectVisualizer()
	end
	if SavedDanceEffectsOptions.AfterimageEnabled then
		local spawnRate = math.clamp(tonumber(SavedDanceEffectsOptions.AfterimageSpawnRate) or 1, 0.25, 4)
		DanceEffects.GhostTimer += dt * spawnRate
		if DanceEffects.GhostTimer >= 0.5 then
			DanceEffects.GhostTimer %= 0.5
			SpawnDanceEffectGhost(figure)
		end
		UpdateDanceEffectGhosts(dt)
	elseif #DanceEffects.Ghosts > 0 or DanceEffects.GhostTimer > 0 then
		DestroyDanceEffectGhosts()
	end
end

AddToRenderStep(function(_, dt)
	UpdateDanceEffects(dt)
end)

local DanceRestartQueued = false
local function RestartCurrentDance()
	if DanceRestartQueued then
		return
	end
	local selected = CurrentDance
	if not selected then
		Util.UINotify("No dance is currently selected")
		return
	end
	DanceRestartQueued = true
	CurrentDance = nil
	task.spawn(function()
		local timeout = os.clock() + 2
		repeat
			RunService.Heartbeat:Wait()
		until _CurrentDance == nil or os.clock() >= timeout
		if CurrentDance == nil and Reanimate.Character then
			CurrentDance = selected
		end
		DanceRestartQueued = false
	end)
end

local AnimationOptionsPage = UI.CreatePage()
AnimationOptionsPage.ZIndex = 1
AnimationOptionsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
AnimationOptionsPage.Interactable = false
AnimationOptionsPage.Visible = false
UI.CreateButton(MainPage, "Animation Options &gt;", 20).Activated:Connect(function()
	AnimationOptionsPage.Interactable = false
	AnimationOptionsPage.Visible = true
	MainPage.Interactable = false
	local tween =
		TweenService:Create(AnimationOptionsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, 0, 0.5, 0),
		})
	tween:Play()
	tween.Completed:Connect(function()
		AnimationOptionsPage.Interactable = true
	end)
end)
UI.CreateButton(AnimationOptionsPage, "&lt; Back", 20).Activated:Connect(function()
	AnimationOptionsPage.Interactable = false
	MainPage.Interactable = false
	local tween = TweenService:Create(
		AnimationOptionsPage,
		TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
		{
			Position = UDim2.new(0.5, 360, 0.5, 0),
		}
	)
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		AnimationOptionsPage.Visible = false
	end)
end)
UI.CreateText(
	AnimationOptionsPage,
	"<b>Animation Options</b>\nAnimLib v" .. AnimLib.Version,
	20,
	Enum.TextXAlignment.Center
)
UI.CreateText(
	AnimationOptionsPage,
	"Playback speed changes live. Use Apply + Restart after changing the other animation defaults.",
	11,
	Enum.TextXAlignment.Center
)
UI.CreateSeparator(AnimationOptionsPage)
UI.CreateSwitch(AnimationOptionsPage, "Sync Dance To Music", AnimLib.Settings.SyncToDanceMusic).Changed
	:Connect(function(value)
		SetAnimLibOption("SyncToDanceMusic", value)
	end)
UI.CreateSwitch(AnimationOptionsPage, "Apply Speed To Music", AnimLib.Settings.ApplySpeedToMusic).Changed
	:Connect(function(value)
		SetAnimLibOption("ApplySpeedToMusic", value)
		ApplyOverrideDanceMusicPlaybackSpeed()
	end)
UI.CreateSwitch(AnimationOptionsPage, "Show Marker Notifications", AnimLib.Settings.MarkerNotifications).Changed
	:Connect(function(value)
		SetAnimLibOption("MarkerNotifications", value)
	end)
UI.CreateSwitch(AnimationOptionsPage, "Reset Pose When Dance Stops", AnimLib.Settings.ResetPoseOnStop).Changed
	:Connect(function(value)
		SetAnimLibOption("ResetPoseOnStop", value)
	end)
UI.CreateSlider(AnimationOptionsPage, "Playback Speed", AnimLib.Settings.Speed, 0.25, 2, 0.05).Changed
	:Connect(function(value)
		SetAnimLibOption("Speed", value)
		ApplyOverrideDanceMusicPlaybackSpeed()
	end)
UI.CreateSlider(AnimationOptionsPage, "Fade In Time", AnimLib.Settings.FadeIn, 0, 1, 0.05).Changed
	:Connect(function(value)
		SetAnimLibOption("FadeIn", value)
	end)
UI.CreateSeparator(AnimationOptionsPage)
UI.CreateText(AnimationOptionsPage, "<b>Body Visibility</b>", 14, Enum.TextXAlignment.Center)
UI.CreateSwitch(
	AnimationOptionsPage,
	"Keep Accessories When Hiding",
	AnimLib.Settings.KeepAccessoriesWhenHiding
).Changed:Connect(function(value)
	SetAnimLibOption("KeepAccessoriesWhenHiding", value)
end)
UI.CreateText(
	AnimationOptionsPage,
	"Hidden network-owned body parts are redirected to a dedicated void target through the active reanimator. The animation controller stays in place; accessories keep their normal target when the switch above is enabled.",
	10,
	Enum.TextXAlignment.Center
)
local JointPresetNames = { "Full Body", "Upper Body", "Lower Body", "Arms Only" }
local JointPresetIndex = table.find(JointPresetNames, AnimLib.Settings.JointPreset) or 1
if not table.find(JointPresetNames, AnimLib.Settings.JointPreset) then
	SetAnimLibOption("JointPreset", "Full Body")
end
UI.CreateDropdown(AnimationOptionsPage, "Animated Joints", JointPresetNames, JointPresetIndex).Changed
	:Connect(function(value)
		SetAnimLibOption("JointPreset", JointPresetNames[value] or "Full Body")
	end)

-- This picker controls the actual animated body. Dance Effects has its own
-- independent picker for afterimage silhouettes.
local HiddenBodyPartDropdownLabel = nil
local HiddenBodyPartDropdownLayoutOrder = nil
local HiddenBodyPartNames = {}
local HiddenBodyPartSignature = nil
local RebuildHiddenBodyPartDropdown
RebuildHiddenBodyPartDropdown = function(partNames)
	if type(partNames) == "table" then
		HiddenBodyPartNames = table.clone(partNames)
	end
	if HiddenBodyPartDropdownLabel and HiddenBodyPartDropdownLabel.Parent then
		HiddenBodyPartDropdownLabel.Parent:Destroy()
	end

	local choices = {}
	local hiddenCount = 0
	for _, partName in HiddenBodyPartNames do
		if SavedAnimLibOptions.HiddenBodyParts[partName] == true then
			hiddenCount += 1
		end
	end
	choices[1] = hiddenCount .. "/" .. #HiddenBodyPartNames .. " hidden â choose a part"
	if #HiddenBodyPartNames > 0 then
		choices[2] = hiddenCount == 0 and "[ ] Hide all" or "[x] Show all"
		for _, partName in HiddenBodyPartNames do
			table.insert(
				choices,
				SavedAnimLibOptions.HiddenBodyParts[partName] == true
					and "[x] " .. partName
					or "[ ] " .. partName
			)
		end
	end

	local selectValue, label = UI.CreateDropdown(AnimationOptionsPage, "Hide Body Parts", choices, 1)
	HiddenBodyPartDropdownLabel = label
	if HiddenBodyPartDropdownLayoutOrder == nil then
		HiddenBodyPartDropdownLayoutOrder = label.Parent.LayoutOrder
	else
		label.Parent.LayoutOrder = HiddenBodyPartDropdownLayoutOrder
	end
	selectValue.Changed:Connect(function(index)
		if index <= 1 or #HiddenBodyPartNames == 0 then
			return
		end
		if index == 2 then
			local hideAll = true
			for _, partName in HiddenBodyPartNames do
				if SavedAnimLibOptions.HiddenBodyParts[partName] == true then
					hideAll = false
					break
				end
			end
			for _, partName in HiddenBodyPartNames do
				SavedAnimLibOptions.HiddenBodyParts[partName] = hideAll and true or nil
			end
		else
			local partName = HiddenBodyPartNames[index - 2]
			if partName then
				SavedAnimLibOptions.HiddenBodyParts[partName] =
					SavedAnimLibOptions.HiddenBodyParts[partName] == true and nil or true
			end
		end
		task.defer(RebuildHiddenBodyPartDropdown)
	end)
end

local function RefreshHiddenBodyPartDropdown()
	local partNames = GetDetectedDanceEffectBodyParts(Reanimate.Character)
	local signature = table.concat(partNames, "\0")
	if signature ~= HiddenBodyPartSignature then
		HiddenBodyPartSignature = signature
		RebuildHiddenBodyPartDropdown(partNames)
	end
end

RefreshHiddenBodyPartDropdown()
local HiddenBodyPartRefreshElapsed = 0
AddToRenderStep(function(_, dt)
	HiddenBodyPartRefreshElapsed += dt
	if HiddenBodyPartRefreshElapsed >= 0.5 then
		HiddenBodyPartRefreshElapsed = 0
		RefreshHiddenBodyPartDropdown()
	end
end, AnimationOptionsPage)
local KrystalHeadOptionsPage = UI.CreatePage()
KrystalHeadOptionsPage.ZIndex = 2
KrystalHeadOptionsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
KrystalHeadOptionsPage.Interactable = false
KrystalHeadOptionsPage.Visible = false
UI.CreateButton(AnimationOptionsPage, "Krystal Head Overlay &gt;", 18).Activated:Connect(function()
	KrystalHeadOptionsPage.Interactable = false
	KrystalHeadOptionsPage.Visible = true
	AnimationOptionsPage.Interactable = false
	local tween = TweenService:Create(
		KrystalHeadOptionsPage,
		TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
		{
			Position = UDim2.new(0.5, 0, 0.5, 0),
		}
	)
	tween:Play()
	tween.Completed:Connect(function()
		KrystalHeadOptionsPage.Interactable = true
	end)
end)
UI.CreateButton(KrystalHeadOptionsPage, "&lt; Back to Animation Options", 18).Activated:Connect(function()
	KrystalHeadOptionsPage.Interactable = false
	AnimationOptionsPage.Interactable = false
	local tween = TweenService:Create(
		KrystalHeadOptionsPage,
		TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
		{
			Position = UDim2.new(0.5, 360, 0.5, 0),
		}
	)
	tween:Play()
	tween.Completed:Connect(function()
		AnimationOptionsPage.Interactable = true
		KrystalHeadOptionsPage.Visible = false
	end)
end)
UI.CreateText(KrystalHeadOptionsPage, "<b>Krystal Head Overlay</b>", 20, Enum.TextXAlignment.Center)
UI.CreateText(
	KrystalHeadOptionsPage,
	"Forked from Krystal Dance V3. Tracks the mouse on desktop and camera direction on touch devices.",
	11,
	Enum.TextXAlignment.Center
)
UI.CreateSeparator(KrystalHeadOptionsPage)
UI.CreateSwitch(KrystalHeadOptionsPage, "Krystal Head Tracking", AnimLib.Settings.KrystalHeadTracking).Changed
	:Connect(function(value)
		SetAnimLibOption("KrystalHeadTracking", value)
	end)
UI.CreateSwitch(KrystalHeadOptionsPage, "â³ Override Animated Head", AnimLib.Settings.KrystalHeadOverride).Changed
	:Connect(function(value)
		SetAnimLibOption("KrystalHeadOverride", value)
	end)
UI.CreateText(
	KrystalHeadOptionsPage,
	"Override applies this after the active moveset and dance, replacing conflicting Neck animation. Turn it off to add the look direction on top of the animated pose.",
	10,
	Enum.TextXAlignment.Center
)
UI.CreateSlider(KrystalHeadOptionsPage, "â³ Tracking Strength", AnimLib.Settings.KrystalHeadStrength, 0, 1.5, 0.05).Changed
	:Connect(function(value)
		SetAnimLibOption("KrystalHeadStrength", math.clamp(value, 0, 1.5))
	end)
UI.CreateSlider(KrystalHeadOptionsPage, "â³ Tracking Smoothing", AnimLib.Settings.KrystalHeadSmoothing, 1, 30, 1).Changed
	:Connect(function(value)
		SetAnimLibOption("KrystalHeadSmoothing", math.clamp(value, 1, 30))
	end)

local DanceEffectsOptionsPage = UI.CreatePage()
DanceEffectsOptionsPage.ZIndex = 2
DanceEffectsOptionsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
DanceEffectsOptionsPage.Interactable = false
DanceEffectsOptionsPage.Visible = false
UI.CreateButton(AnimationOptionsPage, "Dance Effects &gt;", 18).Activated:Connect(function()
	DanceEffectsOptionsPage.Interactable = false
	DanceEffectsOptionsPage.Visible = true
	AnimationOptionsPage.Interactable = false
	local tween = TweenService:Create(
		DanceEffectsOptionsPage,
		TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
		{
			Position = UDim2.new(0.5, 0, 0.5, 0),
		}
	)
	tween:Play()
	tween.Completed:Connect(function()
		DanceEffectsOptionsPage.Interactable = true
	end)
end)
UI.CreateButton(DanceEffectsOptionsPage, "&lt; Back to Animation Options", 18).Activated:Connect(function()
	DanceEffectsOptionsPage.Interactable = false
	AnimationOptionsPage.Interactable = false
	local tween = TweenService:Create(
		DanceEffectsOptionsPage,
		TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
		{
			Position = UDim2.new(0.5, 360, 0.5, 0),
		}
	)
	tween:Play()
	tween.Completed:Connect(function()
		AnimationOptionsPage.Interactable = true
		DanceEffectsOptionsPage.Visible = false
	end)
end)
UI.CreateText(DanceEffectsOptionsPage, "<b>Dance Effects</b>", 20, Enum.TextXAlignment.Center)
UI.CreateText(
	DanceEffectsOptionsPage,
	"Ported from the Eyes Closed addon. These saved effects now work with every dance.",
	11,
	Enum.TextXAlignment.Center
)
UI.CreateSeparator(DanceEffectsOptionsPage)
UI.CreateSwitch(DanceEffectsOptionsPage, "Audio Visualizer", SavedDanceEffectsOptions.VisualizerEnabled).Changed
	:Connect(function(value)
		SavedDanceEffectsOptions.VisualizerEnabled = value
	end)
UI.CreateSwitch(
	DanceEffectsOptionsPage,
	"DyPos (Center of Mass)",
	SavedDanceEffectsOptions.DynamicPosition
).Changed:Connect(function(value)
	SavedDanceEffectsOptions.DynamicPosition = value
end)
UI.CreateSwitch(DanceEffectsOptionsPage, "â³ Stay Vertical", SavedDanceEffectsOptions.StayVertical).Changed
	:Connect(function(value)
		SavedDanceEffectsOptions.StayVertical = value
	end)
UI.CreateDropdown(
	DanceEffectsOptionsPage,
	"â³ Anchor Point",
	DanceEffectAnchorModes,
	table.find(DanceEffectAnchorModes, SavedDanceEffectsOptions.AnchorMode) or 1
).Changed:Connect(function(value)
	SavedDanceEffectsOptions.AnchorMode = DanceEffectAnchorModes[value] or "Center of Mass"
end)
UI.CreateText(
	DanceEffectsOptionsPage,
	"DyPos samples the real character first and falls back to the red rig. Blue Root Part always uses the cyan controller hitbox; Head follows DyPos. Stay Vertical removes root pitch/roll before your rotation sliders.",
	10,
	Enum.TextXAlignment.Center
)
local DanceEffectsAnchorStatus =
	UI.CreateText(DanceEffectsOptionsPage, "Visualizer anchor: " .. DanceEffects.AnchorSource, 10, Enum.TextXAlignment.Center)
AddToRenderStep(function()
	if Util.IsGuiVisible(DanceEffectsAnchorStatus) then
		DanceEffectsAnchorStatus.Text = "Visualizer anchor: " .. DanceEffects.AnchorSource
	end
end, DanceEffectsAnchorStatus)
UI.CreateSwitch(DanceEffectsOptionsPage, "Character Afterimage", SavedDanceEffectsOptions.AfterimageEnabled).Changed
	:Connect(function(value)
		SavedDanceEffectsOptions.AfterimageEnabled = value
	end)
local DanceEffectsAfterimageSpawnRate = UI.CreateSlider(
	DanceEffectsOptionsPage,
	"â³ Spawn Rate",
	SavedDanceEffectsOptions.AfterimageSpawnRate,
	0.25,
	4,
	0.05
)
DanceEffectsAfterimageSpawnRate.Changed:Connect(function(value)
	SavedDanceEffectsOptions.AfterimageSpawnRate = math.clamp(value, 0.25, 4)
end)
local DanceEffectsAfterimageFadeSpeed = UI.CreateSlider(
	DanceEffectsOptionsPage,
	"â³ Fade Speed",
	SavedDanceEffectsOptions.AfterimageFadeSpeed,
	0.25,
	4,
	0.05
)
DanceEffectsAfterimageFadeSpeed.Changed:Connect(function(value)
	SavedDanceEffectsOptions.AfterimageFadeSpeed = math.clamp(value, 0.25, 4)
end)
local DanceEffectsAfterimageScale = UI.CreateSlider(
	DanceEffectsOptionsPage,
	"â³ Image Scale",
	SavedDanceEffectsOptions.AfterimageScale,
	0.25,
	1.5,
	0.01
)
DanceEffectsAfterimageScale.Changed:Connect(function(value)
	SavedDanceEffectsOptions.AfterimageScale = math.clamp(value, 0.25, 1.5)
end)
local DanceEffectsAfterimageTransparency = UI.CreateSlider(
	DanceEffectsOptionsPage,
	"â³ Transparency %",
	SavedDanceEffectsOptions.AfterimageTransparency,
	0,
	100,
	1
)
DanceEffectsAfterimageTransparency.Changed:Connect(function(value)
	SavedDanceEffectsOptions.AfterimageTransparency = math.clamp(math.floor(value), 0, 100)
end)
local DanceEffectsAfterimageGlow =
	UI.CreateSwitch(DanceEffectsOptionsPage, "â³ Glow", SavedDanceEffectsOptions.AfterimageGlowEnabled)
DanceEffectsAfterimageGlow.Changed:Connect(function(value)
	SavedDanceEffectsOptions.AfterimageGlowEnabled = value
end)
local DanceEffectsAfterimageGlowBrightness = UI.CreateSlider(
	DanceEffectsOptionsPage,
	"â³ Glow Brightness",
	SavedDanceEffectsOptions.AfterimageGlowBrightness,
	0,
	10,
	0.1
)
DanceEffectsAfterimageGlowBrightness.Changed:Connect(function(value)
	SavedDanceEffectsOptions.AfterimageGlowBrightness = math.clamp(value, 0, 10)
end)
local DanceEffectsAfterimageGlowRange = UI.CreateSlider(
	DanceEffectsOptionsPage,
	"â³ Glow Range",
	SavedDanceEffectsOptions.AfterimageGlowRange,
	0,
	30,
	0.5
)
DanceEffectsAfterimageGlowRange.Changed:Connect(function(value)
	SavedDanceEffectsOptions.AfterimageGlowRange = math.clamp(value, 0, 30)
end)

-- CreateDropdown is intentionally reused here so the body-part picker looks
-- and behaves like the rest of Uhhhhhh. Selecting an entry toggles it and
-- rebuilds the list with fresh [x]/[ ] markers; the first entry is a summary.
local DanceEffectsBodyPartDropdownLabel = nil
local DanceEffectsBodyPartDropdownLayoutOrder = nil
local DanceEffectsDetectedBodyParts = {}
local DanceEffectsBodyPartSignature = nil
local RebuildDanceEffectsBodyPartDropdown
RebuildDanceEffectsBodyPartDropdown = function(partNames)
	if type(partNames) == "table" then
		DanceEffectsDetectedBodyParts = table.clone(partNames)
	end
	if DanceEffectsBodyPartDropdownLabel and DanceEffectsBodyPartDropdownLabel.Parent then
		DanceEffectsBodyPartDropdownLabel.Parent:Destroy()
	end

	local choices = {}
	local visibleCount = 0
	for _, partName in DanceEffectsDetectedBodyParts do
		if SavedDanceEffectsOptions.AfterimageHiddenParts[partName] ~= true then
			visibleCount += 1
		end
	end
	choices[1] = visibleCount .. "/" .. #DanceEffectsDetectedBodyParts .. " visible â choose a part"
	if #DanceEffectsDetectedBodyParts > 0 then
		choices[2] = visibleCount == #DanceEffectsDetectedBodyParts and "[ ] Hide all" or "[x] Show all"
		for _, partName in DanceEffectsDetectedBodyParts do
			local displayName = SavedDanceEffectsOptions.AfterimageHiddenParts[partName] == true
				and "[ ] " .. partName .. "*"
				or "[x] " .. partName
			table.insert(choices, displayName)
		end
	end

	local selectValue, label = UI.CreateDropdown(DanceEffectsOptionsPage, "Visible Body Parts", choices, 1)
	DanceEffectsBodyPartDropdownLabel = label
	if DanceEffectsBodyPartDropdownLayoutOrder == nil then
		DanceEffectsBodyPartDropdownLayoutOrder = label.Parent.LayoutOrder
	else
		label.Parent.LayoutOrder = DanceEffectsBodyPartDropdownLayoutOrder
	end
	selectValue.Changed:Connect(function(index)
		if index <= 1 or #DanceEffectsDetectedBodyParts == 0 then
			return
		end
		if index == 2 then
			local hideAll = true
			for _, partName in DanceEffectsDetectedBodyParts do
				if SavedDanceEffectsOptions.AfterimageHiddenParts[partName] == true then
					hideAll = false
					break
				end
			end
			for _, partName in DanceEffectsDetectedBodyParts do
				SavedDanceEffectsOptions.AfterimageHiddenParts[partName] = hideAll and true or nil
			end
		else
			local partName = DanceEffectsDetectedBodyParts[index - 2]
			if partName then
				local hidden = SavedDanceEffectsOptions.AfterimageHiddenParts[partName] == true
				SavedDanceEffectsOptions.AfterimageHiddenParts[partName] = hidden and nil or true
			end
		end
		DestroyDanceEffectGhosts()
		task.defer(RebuildDanceEffectsBodyPartDropdown)
	end)
end

local function RefreshDanceEffectsBodyPartDropdown()
	local sourceFigure = GetDanceEffectGhostSource(Reanimate.Character)
	local partNames = GetDetectedDanceEffectBodyParts(sourceFigure)
	local signature = table.concat(partNames, "\0")
	if signature ~= DanceEffectsBodyPartSignature then
		DanceEffectsBodyPartSignature = signature
		RebuildDanceEffectsBodyPartDropdown(partNames)
	end
end

RefreshDanceEffectsBodyPartDropdown()
local DanceEffectsBodyPartRefreshElapsed = 0
AddToRenderStep(function(_, dt)
	DanceEffectsBodyPartRefreshElapsed += dt
	if DanceEffectsBodyPartRefreshElapsed >= 0.5 then
		DanceEffectsBodyPartRefreshElapsed = 0
		RefreshDanceEffectsBodyPartDropdown()
	end
end, DanceEffectsOptionsPage)
UI.CreateText(
	DanceEffectsOptionsPage,
	"Spawn Rate controls new silhouettes; Fade Speed controls disappearance. Transparency is 0% opaque to 100% invisible. Glow controls a local PointLight; Brightness 0 disables its light output. The visible-parts dropdown refreshes when the active R6/R15 body changes; disabled parts end in *.",
	10,
	Enum.TextXAlignment.Center
)
UI.CreateText(
	DanceEffectsOptionsPage,
	"Accent color â use #RRGGBB, RRGGBB, R,G,B, or rgb(R,G,B)",
	11,
	Enum.TextXAlignment.Center
)
local DanceEffectsAccentInput =
	UI.CreateTextbox(DanceEffectsOptionsPage, "#" .. SavedDanceEffectsOptions.Accent, "#00FFFF or 0,255,255", 16)
local DanceEffectsAccentStatus = UI.CreateText(
	DanceEffectsOptionsPage,
	'<font color="#'
		.. SavedDanceEffectsOptions.Accent
		.. '">â </font> Saved accent: #'
		.. SavedDanceEffectsOptions.Accent,
	11,
	Enum.TextXAlignment.Center
)
DanceEffectsAccentInput.FocusLost:Connect(function()
	local _, hex = ParseDanceEffectColor(DanceEffectsAccentInput.Text)
	if not hex then
		DanceEffectsAccentInput.Text = "#" .. SavedDanceEffectsOptions.Accent
		Util.UINotify("Invalid accent. Use #RRGGBB or R,G,B with values from 0 to 255.")
		return
	end
	SavedDanceEffectsOptions.Accent = hex
	DanceEffectsAccentInput.Text = "#" .. hex
	DanceEffectsAccentStatus.Text = '<font color="#' .. hex .. '">â </font> Saved accent: #' .. hex
end)
UI.CreateSeparator(DanceEffectsOptionsPage)
UI.CreateText(
	DanceEffectsOptionsPage,
	"Visualizer offset uses the active anchor: static mode starts at the red head; dynamic mode starts at center of mass.",
	10,
	Enum.TextXAlignment.Center
)
local DanceEffectsOffsetX =
	UI.CreateSlider(DanceEffectsOptionsPage, "Visualizer Offset X", SavedDanceEffectsOptions.OffsetX, -10, 10, 0.1)
DanceEffectsOffsetX.Changed:Connect(function(value)
	SavedDanceEffectsOptions.OffsetX = math.clamp(value, -10, 10)
end)
local DanceEffectsOffsetY =
	UI.CreateSlider(DanceEffectsOptionsPage, "Visualizer Offset Y", SavedDanceEffectsOptions.OffsetY, -5, 10, 0.1)
DanceEffectsOffsetY.Changed:Connect(function(value)
	SavedDanceEffectsOptions.OffsetY = math.clamp(value, -5, 10)
end)
local DanceEffectsOffsetZ =
	UI.CreateSlider(DanceEffectsOptionsPage, "Visualizer Offset Z", SavedDanceEffectsOptions.OffsetZ, -10, 10, 0.1)
DanceEffectsOffsetZ.Changed:Connect(function(value)
	SavedDanceEffectsOptions.OffsetZ = math.clamp(value, -10, 10)
end)
local DanceEffectsSize =
	UI.CreateSlider(DanceEffectsOptionsPage, "Visualizer Size", SavedDanceEffectsOptions.Size, 0.25, 3, 0.05)
DanceEffectsSize.Changed:Connect(function(value)
	SavedDanceEffectsOptions.Size = math.clamp(value, 0.25, 3)
end)
local DanceEffectsRotationX = UI.CreateSlider(
	DanceEffectsOptionsPage,
	"Visualizer Rotation X",
	SavedDanceEffectsOptions.RotationX,
	-180,
	180,
	1
)
DanceEffectsRotationX.Changed:Connect(function(value)
	SavedDanceEffectsOptions.RotationX = math.clamp(value, -180, 180)
end)
local DanceEffectsRotationY = UI.CreateSlider(
	DanceEffectsOptionsPage,
	"Visualizer Rotation Y",
	SavedDanceEffectsOptions.RotationY,
	-180,
	180,
	1
)
DanceEffectsRotationY.Changed:Connect(function(value)
	SavedDanceEffectsOptions.RotationY = math.clamp(value, -180, 180)
end)
local DanceEffectsRotationZ = UI.CreateSlider(
	DanceEffectsOptionsPage,
	"Visualizer Rotation Z",
	SavedDanceEffectsOptions.RotationZ,
	-180,
	180,
	1
)
DanceEffectsRotationZ.Changed:Connect(function(value)
	SavedDanceEffectsOptions.RotationZ = math.clamp(value, -180, 180)
end)
UI.CreateButton(DanceEffectsOptionsPage, "Reset Visualizer Layout", 16).Activated:Connect(function()
	DanceEffectsOffsetX.Value = 0.3
	DanceEffectsOffsetY.Value = 0
	DanceEffectsOffsetZ.Value = 0
	DanceEffectsSize.Value = 2
	DanceEffectsRotationX.Value = 0
	DanceEffectsRotationY.Value = 0
	DanceEffectsRotationZ.Value = 0
end)
UI.CreateButton(DanceEffectsOptionsPage, "Reset Afterimage Config", 16).Activated:Connect(function()
	DanceEffectsAfterimageSpawnRate.Value = 1.3
	DanceEffectsAfterimageFadeSpeed.Value = 1.3
	DanceEffectsAfterimageScale.Value = 0.86
	DanceEffectsAfterimageTransparency.Value = 55
	DanceEffectsAfterimageGlow.Value = true
	DanceEffectsAfterimageGlowBrightness.Value = 1.5
	DanceEffectsAfterimageGlowRange.Value = 7
	table.clear(SavedDanceEffectsOptions.AfterimageHiddenParts)
	DestroyDanceEffectGhosts()
	RebuildDanceEffectsBodyPartDropdown()
end)
UI.CreateSeparator(AnimationOptionsPage)
local AnimationOptionsStatus =
	UI.CreateText(AnimationOptionsPage, "Current dance: None", 12, Enum.TextXAlignment.Center)
AddToRenderStep(function()
	if Util.IsGuiVisible(AnimationOptionsStatus) then
		AnimationOptionsStatus.Text = "Current dance: " .. (CurrentDance and CurrentDance.Name or "None")
	end
end, AnimationOptionsStatus)
UI.CreateButton(AnimationOptionsPage, "Apply + Restart Current Dance", 18).Activated:Connect(RestartCurrentDance)
UI.CreateButton(AnimationOptionsPage, "Stop Current Dance", 18).Activated:Connect(function()
	CurrentDance = nil
end)
UI.CreateButton(AnimationOptionsPage, "Reset Character Pose", 18).Activated:Connect(function()
	ResetDancePose(Reanimate.Character, true)
end)
UI.CreateSeparator(MainPage)
end

if type(SaveData.MovesetIndex) == "number" then
	MovementStyleIndex = SaveData.MovesetIndex
end

local MovesetsPage = UI.CreateItemListPage()
MovesetsPage.ZIndex = 1
MovesetsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
MovesetsPage.Interactable = false
MovesetsPage.Visible = false
UI.CreateText(MainPage, "", 3, Enum.TextXAlignment.Center)
UI.CreateButton(MainPage, "Movesets &gt;", 20).Activated:Connect(function()
	MovesetsPage.Interactable = false
	MovesetsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MovesetsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MovesetsPage.Interactable = true
	end)
end)
MovesetsPage.Back.Activated:Connect(function()
	MovesetsPage.Interactable = false
	MovesetsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MovesetsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		MovesetsPage.Visible = false
	end)
end)
local DanceCatFilter = "All"    -- forward: defined fully after DancesPage.Back
local ApplyDanceFilter          -- forward: assigned after DancesPage.Back
local AnimCreatorPage           -- forward: assigned inside Animation Creator do block
local DancesPage = UI.CreateItemListPage()
DancesPage.ZIndex = 1
DancesPage.Position = UDim2.new(0.5, 360, 0.5, 0)
DancesPage.Interactable = false
DancesPage.Visible = false
-- Extend height to fit bottom button bar
DancesPage.Size = UDim2.new(0, 360, 0, 232)
DancesPage.List.Size = UDim2.new(1, 0, 1, -58)
-- Bottom button bar
local _DancesBottomBar = Instance.new("Frame", DancesPage)
_DancesBottomBar.Name = "BottomBar"
_DancesBottomBar.AnchorPoint = Vector2.new(0, 1)
_DancesBottomBar.Position = UDim2.new(0, 0, 1, 0)
_DancesBottomBar.Size = UDim2.new(1, 0, 0, 27)
_DancesBottomBar.BackgroundTransparency = 1
_DancesBottomBar.BorderSizePixel = 0
local _DBBLayout = Instance.new("UIListLayout", _DancesBottomBar)
_DBBLayout.FillDirection = Enum.FillDirection.Horizontal
_DBBLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
_DBBLayout.VerticalAlignment = Enum.VerticalAlignment.Center
_DBBLayout.Padding = UDim.new(0, 4)
-- Favorites button
local _FavBtn = Instance.new("TextButton", _DancesBottomBar)
_FavBtn.Size = UDim2.new(0.48, -2, 0, 23)
_FavBtn.BorderSizePixel = 0
_FavBtn.Font = Enum.Font.Code
_FavBtn.TextSize = 14
_FavBtn.Text = "★ Favorites"
Stylize(_FavBtn)
_FavBtn.Activated:Connect(function()
	DanceCatFilter = DanceCatFilter == "★" and "All" or "★"
	ApplyDanceFilter()
end)
AddToRenderStep(function(t)
	_FavBtn.BackgroundColor3 = DanceCatFilter == "★" and GetUIColor(t) or GetUIBGColor(t)
	_FavBtn.TextColor3 = DanceCatFilter == "★" and GetUIBGColor(t) or GetUIColor(t)
end, _FavBtn)
-- Animation Creator button
local _ACBtn = Instance.new("TextButton", _DancesBottomBar)
_ACBtn.Size = UDim2.new(0.48, -2, 0, 23)
_ACBtn.BorderSizePixel = 0
_ACBtn.Font = Enum.Font.Code
_ACBtn.TextSize = 14
_ACBtn.Text = "✦ Anim Creator"
Stylize(_ACBtn)
_ACBtn.Activated:Connect(function()
	if AnimCreatorPage then
		DancesPage.Interactable = false
		AnimCreatorPage.Visible = true
		local tween = TweenService:Create(AnimCreatorPage, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, 0, 0.5, 0),
		})
		tween:Play()
		tween.Completed:Connect(function()
			AnimCreatorPage.Interactable = true
		end)
	end
end)
UI.CreateButton(MainPage, "Dances &gt;", 20).Activated:Connect(function()
	DancesPage.Interactable = false
	DancesPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(DancesPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		DancesPage.Interactable = true
	end)
end)
UI.CreateButton(MainPage, "Play a Random Dance", 20).Activated:Connect(function()
	if #DanceableDances > 0 then
		CurrentDance = DanceableDances[math.random(1, #DanceableDances)]
	end
end)
DancesPage.Back.Activated:Connect(function()
	DancesPage.Interactable = false
	DancesPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(DancesPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		DancesPage.Visible = false
	end)
end)

-- ============================================================
-- DANCE CATEGORY FILTER + FAVORITES
-- ============================================================
-- DanceCatFilter already declared above (forward ref)
local DanceCats = {"All", "★", "Dance", "Emote", "Meme", "Other"}
ApplyDanceFilter = function()
	local search = DancesPage.Search.Box.Text:lower()
	for _, v in DancesPage.List:GetChildren() do
		if not v:IsA("GuiObject") then continue end
		local cat = v:GetAttribute("DanceCategory")
		if not cat then v.Visible = true continue end
		local hash = v:GetAttribute("DanceHash") or ""
		local nameMatch = search == "" or v.Name:lower():find(search, 1, true)
		local catMatch = DanceCatFilter == "All"
			or (DanceCatFilter == "★" and SaveData.Favorites[hash])
			or (cat == DanceCatFilter)
		v.Visible = nameMatch and catMatch and true or false
	end
end
-- Override/supplement the built-in search to also respect category
DancesPage.Search.Box:GetPropertyChangedSignal("Text"):Connect(ApplyDanceFilter)

-- Category bar pinned at top of list (LayoutOrder = -1)
local _DanceCatBar = Instance.new("Frame", DancesPage.List)
_DanceCatBar.Name = "__CatBar"
_DanceCatBar.Size = UDim2.new(1, 0, 0, 22)
_DanceCatBar.BackgroundTransparency = 1
_DanceCatBar.LayoutOrder = -1
local _DanceCatBarLayout = Instance.new("UIListLayout", _DanceCatBar)
_DanceCatBarLayout.FillDirection = Enum.FillDirection.Horizontal
_DanceCatBarLayout.Padding = UDim.new(0, 2)
_DanceCatBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
local _DanceCatBtnW = {All=28, ["★"]=20, Dance=38, Emote=40, Meme=34, Other=38}
for _, cat in DanceCats do
	local btn = Instance.new("TextButton", _DanceCatBar)
	btn.Size = UDim2.new(0, _DanceCatBtnW[cat] or 36, 0, 18)
	btn.BackgroundTransparency = 0
	btn.Font = Enum.Font.Code
	btn.TextSize = 11
	btn.Text = cat
	btn.BorderSizePixel = 0
	Stylize(btn)
	btn.Activated:Connect(function()
		DanceCatFilter = cat
		ApplyDanceFilter()
	end)
	AddToRenderStep(function(t)
		btn.BackgroundColor3 = DanceCatFilter == cat and GetUIColor(t) or GetUIBGColor(t)
		btn.TextColor3 = DanceCatFilter == cat and GetUIBGColor(t) or GetUIColor(t)
	end, btn)
end

local KeybindsPage = UI.CreateItemListPage()
KeybindsPage.ZIndex = 1
KeybindsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
KeybindsPage.Interactable = false
KeybindsPage.Visible = false
UI.CreateButton(MainPage, "Dance Keybinds &gt;", 20).Activated:Connect(function()
	KeybindsPage.Interactable = false
	KeybindsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(KeybindsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		KeybindsPage.Interactable = true
	end)
end)
KeybindsPage.Back.Activated:Connect(function()
	KeybindsPage.Interactable = false
	KeybindsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(KeybindsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		KeybindsPage.Visible = false
	end)
end)
local MarketPage = UI.CreatePage()
MarketPage.ZIndex = 1
MarketPage.Position = UDim2.new(0.5, 360, 0.5, 0)
MarketPage.Interactable = false
MarketPage.Visible = false
UI.CreateButton(MainPage, (math.random() < 0.5 and "Store" or "Marketplace") .. " &gt;", 20).Activated:Connect(function()
	MarketPage.Interactable = false
	MarketPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MarketPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MarketPage.Interactable = true
	end)
end)
UI.CreateButton(MarketPage, "&lt; Hurry back", 20).Activated:Connect(function()
	MarketPage.Interactable = false
	MarketPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MarketPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		MarketPage.Visible = false
	end)
end)
UI.CreateSeparator(MarketPage)

SaveData.KeybindsEnabled = not not SaveData.KeybindsEnabled
UI.CreateSwitch(MainPage, "Dance Keybinds Enabled", SaveData.KeybindsEnabled).Changed:Connect(function(val)
	SaveData.KeybindsEnabled = val
end)
local Keybinds = {}
local KeybindsPerPage = {"Z", "X", "C", "V", "B", "N", "G", "H", "J", "K", "L", "R", "T", "U", "P"}
local KeybindPaging = 0
local RefreshKeybinds = nil
local UpdateKeybindHUD = nil -- forward ref; defined after KeybindsPage setup
local function HandleKeybind(key)
	if table.find(KeybindsPerPage, key) then
		if CurrentDance then
			CurrentDance = nil
			return true
		else
			CurrentDance = Keybinds[key]
			if CurrentDance then
				Util.UINotify(key .. " - " .. CurrentDance.Name)
				return true
			end
		end
	end
	if key == "M" then
		local pages = math.max(1, 1 + ((#DanceableDances - 1) // #KeybindsPerPage))
		KeybindPaging = (KeybindPaging + 1) % pages
		Util.UINotify("Page " .. (KeybindPaging + 1))
		RefreshKeybinds()
		return true
	end
	return false
end
RefreshKeybinds = function()
	local pages = math.max(1, 1 + ((#DanceableDances - 1) // #KeybindsPerPage))
	Util.ClearAllChildrenGui(KeybindsPage.List)
	local button = UI.CreateButton(KeybindsPage.List, "M - Page " .. (((KeybindPaging + 1) % pages) + 1), 20)
	button.Parent.Name = ""
	button.Activated:Connect(function()
		HandleKeybind("M")
	end)
	local indexoffset = KeybindPaging * #KeybindsPerPage
	for i=1, #KeybindsPerPage do
		local key = KeybindsPerPage[i]
		local index = indexoffset + i
		local dance = DanceableDances[index]
		Keybinds[key] = dance
		if dance then
			button = UI.CreateButton(KeybindsPage.List, key .. " - " .. dance.Name, 20)
			button.Parent.Name = key .. " " .. dance.Name
			button.Activated:Connect(function()
				HandleKeybind(key)
			end)
		end
	end
	if UpdateKeybindHUD then UpdateKeybindHUD() end
end

-- ============================================================
-- KEYBIND MINIMAP HUD + DUMMY BILLBOARD
-- ============================================================
local KeybindHUD = Instance.new("Frame", SCREENGUI)
KeybindHUD.Name = "KeybindHUD"
KeybindHUD.AnchorPoint = Vector2.new(1, 1)
KeybindHUD.Position = UDim2.new(1, -6, 1, -6)
KeybindHUD.Size = UDim2.new(0, 170, 0, 10)
KeybindHUD.AutomaticSize = Enum.AutomaticSize.Y
KeybindHUD.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeybindHUD.BackgroundTransparency = 0.45
KeybindHUD.BorderSizePixel = 0
KeybindHUD.Visible = false
local _KBHUDL = Instance.new("UIListLayout", KeybindHUD)
_KBHUDL.FillDirection = Enum.FillDirection.Vertical
_KBHUDL.Padding = UDim.new(0, 1)
local _KBHUDPad = Instance.new("UIPadding", KeybindHUD)
_KBHUDPad.PaddingTop = UDim.new(0, 3)
_KBHUDPad.PaddingBottom = UDim.new(0, 3)
_KBHUDPad.PaddingLeft = UDim.new(0, 4)
_KBHUDPad.PaddingRight = UDim.new(0, 4)

local function _KBHUDLabel(text, color, size)
	local lbl = Instance.new("TextLabel", KeybindHUD)
	lbl.Size = UDim2.new(1, 0, 0, size + 2)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.Code
	lbl.TextSize = size
	lbl.TextColor3 = color
	lbl.Text = text
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	return lbl
end

UpdateKeybindHUD = function()
	KeybindHUD:ClearAllChildren()
	local layout = Instance.new("UIListLayout", KeybindHUD)
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 1)
	local pad = Instance.new("UIPadding", KeybindHUD)
	pad.PaddingTop = UDim.new(0, 3)
	pad.PaddingBottom = UDim.new(0, 3)
	pad.PaddingLeft = UDim.new(0, 4)
	pad.PaddingRight = UDim.new(0, 4)

	local pages = math.max(1, 1 + ((#DanceableDances - 1) // #KeybindsPerPage))
	_KBHUDLabel("Keybinds  pg " .. (KeybindPaging + 1) .. "/" .. pages, Color3.fromRGB(255, 230, 80), 11)

	-- currently playing
	if _CurrentDance then
		_KBHUDLabel("▶ " .. _CurrentDance.Name, Color3.fromRGB(120, 255, 120), 10)
	end

	-- divider
	local div = Instance.new("Frame", KeybindHUD)
	div.Size = UDim2.new(1, 0, 0, 1)
	div.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	div.BackgroundTransparency = 0
	div.BorderSizePixel = 0

	local offset = KeybindPaging * #KeybindsPerPage
	for i = 1, #KeybindsPerPage do
		local key = KeybindsPerPage[i]
		local dance = DanceableDances[offset + i]
		if dance then
			local active = CurrentDance == dance
			_KBHUDLabel(key .. " · " .. dance.Name, active and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(190, 190, 190), 10)
		end
	end

	KeybindHUD.Visible = SaveData.KeybindsEnabled
end
-- forward-declare so RefreshKeybinds can call it
UpdateKeybindHUD()

local function UpdateDummyBillboard(rc, danceName)
	if not rc then return end
	local root = rc:FindFirstChild("HumanoidRootPart") or rc:FindFirstChild("Torso")
	if not root then return end
	local existing = root:FindFirstChild("__DanceBillboard")
	if existing then existing:Destroy() end
	if not danceName then return end
	local bb = Instance.new("BillboardGui", root)
	bb.Name = "__DanceBillboard"
	bb.Size = UDim2.new(0, 130, 0, 22)
	bb.StudsOffset = Vector3.new(0, 3.8, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	local lbl = Instance.new("TextLabel", bb)
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 12
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextStrokeTransparency = 0
	lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	lbl.Text = "♪ " .. danceName
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
end

local ContextActions = {}
ContextActions._Actions = {}
ContextActions._ActionsMap = {}
do
	local buttonsui = Instance.new("Frame", SCREENGUI)
	buttonsui.BackgroundTransparency = 1
	buttonsui.Name = Util.RandomString()
	buttonsui.AnchorPoint = Vector2.new(0, 0)
	buttonsui.Position = UDim2.new(1, -90, 1, -90)
	buttonsui.Size = UDim2.new(0, 130, 0, 130)
	ContextActions._ButtonsGui = buttonsui
	local actions, actionsmap = ContextActions._Actions, ContextActions._ActionsMap
	function ContextActions:RunBinding(caac, input)
		local s, result = xpcall(caac.Callback, function(m)
			warn(debug.traceback("Uhhhhhh :: Custom ContextActions Error - " .. m))
		end, caac.Name, input.UserInputState, input)
		if s then
			if result == Enum.ContextActionResult.Sink then
				return true
			end
		end
		return false
	end
	function ContextActions:OnInput(input, gpe)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			if gpe then return end
		end
		for i=#actions, 1, -1 do
			local caac = actions[i]
			local exec = false
			for _,v in caac.Inputs do
				if v == input.UserInputType then
					exec = true
					break
				end
				if input.UserInputType == Enum.UserInputType.Keyboard then
					if v == input.KeyCode then
						exec = true
						break
					end
				end
			end
			if exec then
				if ContextActions:RunBinding(caac, input) then return end
			end
		end
	end
	function ContextActions:UnbindAllActions()
		table.clear(actions)
		table.clear(actionsmap)
		ContextActions._ButtonsGui:ClearAllChildren()
	end
	function ContextActions:BindAction(name, callback, touchButton, ...)
		assert(type(name) == "string")
		assert(type(callback) == "function")
		assert(type(touchButton) == "boolean")
		ContextActions:UnbindAction(name)
		local caac = {
			Name = name,
			Callback = callback,
			Inputs = {...}
		}
		table.insert(actions, caac)
		actionsmap[name] = caac
		if touchButton then
			local button = Instance.new("ImageButton", buttonsui)
			button.Name = Util.RandomString()
			button.Position = UDim2.new(0, 0, 0, 0)
			button.Size = UDim2.new(0, 35, 0, 35)
			button.Image = "https://www.roblox.com/asset/?id=97166444"
			button.BackgroundTransparency = 1
			local txt = Instance.new("TextLabel", button)
			txt.Name = "Title"
			txt.Position = UDim2.new(0, 0, 0, 0)
			txt.Size = UDim2.new(1, 0, 1, 0)
			txt.BackgroundTransparency = 1
			txt.Font = Enum.Font.SourceSansBold
			txt.TextSize = 18
			txt.TextColor3 = Color3.new(1, 1, 1)
			txt.TextStrokeTransparency = 0
			txt.TextStrokeColor3 = Color3.new(0, 0, 0)
			txt.Text = ""
			local icon = Instance.new("ImageLabel", button)
			icon.Name = "Icon"
			icon.Position = UDim2.new(0, 0, 0, 0)
			icon.Size = UDim2.new(1, 0, 1, 0)
			icon.BackgroundTransparency = 1
			icon.Image = ""
			button.InputBegan:Connect(function(input)
				ContextActions:RunBinding(caac, input)
			end)
			button.InputChanged:Connect(function(input)
				ContextActions:RunBinding(caac, input)
			end)
			button.InputEnded:Connect(function(input)
				ContextActions:RunBinding(caac, input)
			end)
			caac.TouchButton = button
		end
	end
	function ContextActions:UnbindAction(name)
		local caac = actionsmap[name]
		if caac then
			if caac.TouchButton then
				caac.TouchButton:Destroy()
			end
			local i = table.find(actions, caac)
			if i then table.remove(actions, i) end
		end
	end
	function ContextActions:SetTitle(name, title)
		local caac = actionsmap[name]
		if caac then
			local button = caac.TouchButton
			if button then
				if button.Icon.Image == "" then
					button.Title.Visible = true
					button.Icon.Visible = false
				else
					button.Title.Visible = true
					button.Icon.Visible = false
				end
				button.Title.Text = title
			end
		end
	end
	function ContextActions:SetImage(name, image)
		local caac = actionsmap[name]
		if caac then
			local button = caac.TouchButton
			if button then
				if image then
					button.Icon.Image = image
				else
					button.Icon.Image = ""
				end
				if button.Icon.Image == "" then
					button.Title.Visible = true
					button.Icon.Visible = false
				else
					button.Title.Visible = true
					button.Icon.Visible = false
				end
			end
		end
	end
	function ContextActions:SetPosition(name, position)
		local caac = actionsmap[name]
		if caac then
			local button = caac.TouchButton
			if button then
				button.Position = position
			end
		end
	end
	AddToRenderStep(function()
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
		if not touchGui or not touchGui.Enabled then
			buttonsui.Visible = false
			return
		end
		local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
		local jumpButton = touchFrame and touchFrame:FindFirstChild("JumpButton")
		if not jumpButton then
			buttonsui.Visible = false
			return
		end
		local pos = jumpButton.AbsolutePosition - SCREENGUI.AbsolutePosition
		buttonsui.Visible = true
		buttonsui.Position = UDim2.fromOffset(pos.X - 35, pos.Y - 35)
	end)
end
UI.CreateText(MainPage, "",3, Enum.TextXAlignment.Center)
UI.CreateSeparator(MainPage)
do
	UI.CreateText(MainPage, "Reanimate Character Settings", 15, Enum.TextXAlignment.Center)
	UI.CreateSwitch(MainPage, "Infinite Jump", Reanimate.InfiniteJump).Changed:Connect(function(val)
		Reanimate.InfiniteJump = val
		SaveData.NoInfiniteJump = not val
	end)
	UI.CreateSwitch(MainPage, "Noclip", Reanimate.Noclip).Changed:Connect(function(val)
		Reanimate.Noclip = val
		SaveData.NoclipEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Smooth Camera", Reanimate.SmoothCam).Changed:Connect(function(val)
		Reanimate.SmoothCam = val
		SaveData.NoSmoothCam = not val
	end)
	UI.CreateSwitch(MainPage, "First Person Body", Reanimate.FirstPersonBody).Changed:Connect(function(val)
		Reanimate.FirstPersonBody = val
		SaveData.FirstPersonBody = val
	end)
	UI.CreateSwitch(MainPage, "Allow Shiftlock", Reanimate.ShiftlockEnabled).Changed:Connect(function(val)
		Reanimate.ShiftlockEnabled = val
		SaveData.ShiftlockDisabled = not val
	end)
	local SeatSitSwitch = UI.CreateSwitch(MainPage, "Can Sit on Seats", Reanimate.SeatSit)
	SeatSitSwitch.Changed:Connect(function(val)
		Reanimate.SeatSit = val
		SaveData.SeatSitEnabled = val
		SaveData.NoSeatSitEnabled = not val
		local saved = SaveSettingsNow()
		if not saved then
			Util.Notify("Failed to immediately save Can Sit on Seats")
		end
	end)
	local KeepSeatSitStateSwitch, KeepSeatSitStateText =
		UI.CreateSwitch(MainPage, "â³ Keep Humanoid Sit State", Reanimate.KeepSeatSitState)
	KeepSeatSitStateSwitch.Changed:Connect(function(val)
		Reanimate.KeepSeatSitState = val
		SaveData.KeepSeatSitState = val
		local saved = SaveSettingsNow()
		if not saved then
			Util.Notify("Failed to immediately save Keep Humanoid Sit State")
		end
	end)
	local function UpdateKeepSeatSitStateOption()
		KeepSeatSitStateText.Parent.Interactable = SeatSitSwitch.Value
		KeepSeatSitStateText.TextTransparency = SeatSitSwitch.Value and 0 or 0.5
	end
	SeatSitSwitch.Changed:Connect(UpdateKeepSeatSitStateOption)
	UpdateKeepSeatSitStateOption()
	UI.CreateSwitch(MainPage, "Can Pickup Tools", Reanimate.ToolGrab).Changed:Connect(function(val)
		Reanimate.ToolGrab = val
		SaveData.ToolGrabEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Apply Scale to Gravity", Reanimate.ScaleGravity).Changed:Connect(function(val)
		Reanimate.ScaleGravity = val
		SaveData.ScaleGravityEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Void Float", Reanimate.PatchmaVoidFloat).Changed:Connect(function(val)
		Reanimate.PatchmaVoidFloat = val
		SaveData.PatchmaVoidFloat = val
	end)
	UI.CreateButton(MainPage, "Force Sit (2x to remove gyro)", 20).Activated:Connect(function()
		local ch = Reanimate.Character or Player.Character
		if ch then
			local h = ch:FindFirstChildOfClass("Humanoid")
			local r = h and h.RootPart
			if h and r then
				h.Sit = true
				if r:FindFirstChild("SeatGyro") then
					r.SeatGyro:Destroy()
				else
					local g = Instance.new("BodyGyro")
					g.Name = "SeatGyro"
					g.CFrame = r.CFrame
					g.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
					g.Parent = r
					Util.LinkDestroyI2C(
						g,
						h:GetPropertyChangedSignal("Sit"):Once(function()
							g:Destroy()
						end)
					)
				end
			end
		end
	end)
	local CharacterScaleSlider = UI.CreateSlider(MainPage, "Character Scale", Reanimate.CharacterScale, 0.5, 5, 0.5)
	CharacterScaleSlider.Changed:Connect(function(val)
		val = math.clamp(val, 0.001, 20)
		CharacterScaleSlider.Value = val
		Reanimate.CharacterScale = val
		SaveData.CharacterScale = val
	end)
	local PlaceholderTransparencySlider =
		UI.CreateSlider(MainPage, "Placeholders", Reanimate.PlaceholderTransparency, 0, 1, 0.05)
	PlaceholderTransparencySlider.Changed:Connect(function(val)
		val = math.clamp(val, 0, 1)
		PlaceholderTransparencySlider.Value = val
		Reanimate.PlaceholderTransparency = val
		SaveData.PlaceholderTransparency = val
	end)
	UI.CreateSwitch(MainPage, "Show Red Reset Placeholder", Reanimate.ShowResetPlaceholder).Changed
		:Connect(function(val)
			Reanimate.ShowResetPlaceholder = val
			SaveData.ShowResetPlaceholder = val
		end)
	UI.CreateText(
		MainPage,
		"shows the original red translucent fake rig before the new real character is detected",
		10,
		Enum.TextXAlignment.Center
	)
	UI.CreateSeparator(MainPage)
	local function ReanimCharacterTeleport(pos)
		local ch = Reanimate.Character or Player.Character
		if ch then
			local h = ch:FindFirstChildOfClass("Humanoid")
			local r = h and h.RootPart
			if h and r then
				r.CFrame = r.CFrame.Rotation + pos
				r.Velocity = Vector3.zero
				r.RotVelocity = Vector3.zero
			end
		end
	end
	UI.CreateSwitch(MainPage, "Click Fling", Reanimate.ClickFling).Changed:Connect(function(val)
		Reanimate.ClickFling = val
		SaveData.ClickFlingEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Key+Click Teleport", Reanimate.CtrlClick).Changed:Connect(function(val)
		Reanimate.CtrlClick = val
		SaveData.CtrlClickEnabled = val
	end)
	local selectedkey = Enum.KeyCode.LeftControl
	SaveData.CtrlClickKey = SaveData.CtrlClickKey or 1
	local function updatekey()
		local val = SaveData.CtrlClickKey
		if val == 1 then
			selectedkey = Enum.KeyCode.LeftControl
		end
		if val == 2 then
			selectedkey = Enum.KeyCode.RightBracket
		end
		if val == 3 then
			selectedkey = Enum.KeyCode.Tab
		end
		if val == 4 then
			selectedkey = Enum.KeyCode.Z
		end
		if val == 5 then
			selectedkey = Enum.KeyCode.X
		end
		if val == 6 then
			selectedkey = Enum.KeyCode.F
		end
		if val == 7 then
			selectedkey = Enum.KeyCode.T
		end
	end
	updatekey()
	UI.CreateDropdown(MainPage, "TP Key", {
		"Left Ctrl (default)",
		"inno's pick (']')",
		"Tab (idk)",
		"Z",
		"X (i like this one on pc)",
		"F",
		"T",
	}, SaveData.CtrlClickKey).Changed
		:Connect(function(val)
			SaveData.CtrlClickKey = val
			updatekey()
		end)
	local Maus = Player:GetMouse()
	local HoldingCtrl = UI.CreateSwitch(MainPage, "TP Key Held", false)
	local _lastclick = nil
	local _lastclickgpe = false
	local _lastclicktick = 0
	local _lastclickpos = Vector3.zero
	UserInputService.InputBegan:Connect(function(input, gpe)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == selectedkey then
				HoldingCtrl.Value = true
			end
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			_lastclick = input
			_lastclickgpe = gpe
			_lastclicktick = os.clock()
			_lastclickpos = input.Position
		end
	end)
	UserInputService.InputEnded:Connect(function(input, gpe)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == selectedkey then
				HoldingCtrl.Value = false
			end
		end
		if _lastclick and _lastclick == input and not _lastclickgpe then
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or (os.clock() - _lastclicktick < 0.3 and (input.Position - _lastclickpos).Magnitude < 10)
			then
				if Reanimate.CtrlClick and HoldingCtrl.Value then
					if Maus.Target and Maus.Target.Parent then
						ReanimCharacterTeleport(Maus.Hit.Position + Vector3.new(0, 3, 0))
						return
					end
				end
				if Reanimate.ClickFling then
					if Maus.Target and Maus.Target.Parent then
						local target = Maus.Target.Parent
						if target:IsA("Accessory") then
							target = target.Parent
						end
						if target:FindFirstChildOfClass("Humanoid") then
							if ReanimateFling(target) then
								return
							end
						end
					end
				end
			end
		end
	end)
	UI.CreateButton(MainPage, "Teleport to 0, highest, 0", 20).Activated:Connect(function()
		local hit = workspace:Raycast(Vector3.new(0, 4500, 0), Vector3.new(0, -4500 + FallenPartsDestroyHeight, 0))
		if hit and hit.Position == hit.Position then
			ReanimCharacterTeleport(hit.Position + Vector3.new(0, 5, 0))
		else
			ReanimCharacterTeleport(Vector3.new(0, 0, 0))
		end
	end)
	UI.CreateButton(MainPage, "Teleport to 'LastSafe'", 20).Activated:Connect(function()
		ReanimCharacterTeleport(Vector3.new(0, FallenPartsDestroyHeight - 5000, 0))
	end)
	local TeleportToPlayerSel = UI.CreateText(MainPage, '<font color="#AAAAAA">(enter a player name)</font>', 15, Enum.TextXAlignment.Center)
	local TeleportToPlayer = UI.CreateTextbox(MainPage, "", "Teleport To Player", 20)
	TeleportToPlayer:GetPropertyChangedSignal("Text"):Connect(function()
		local sel = Util.QueryPlayerSelector(TeleportToPlayer.Text)
		if sel then
			TeleportToPlayerSel.Text = `{sel.DisplayName} (@{sel.Name})`
		else
			if #TeleportToPlayer.Text == 0 then
				TeleportToPlayerSel.Text = '<font color="#AAAAAA">(enter a player name)</font>'
			else
				TeleportToPlayerSel.Text = '<font color="#FF7777">(player not found)</font>'
			end
		end
	end)
	TeleportToPlayer.FocusLost:Connect(function(enter)
		if enter then
			local sel = Util.QueryPlayerSelector(TeleportToPlayer.Text)
			if sel and sel.Character then
				local r = sel.Character:FindFirstChild("LowerTorso") or sel.Character:FindFirstChild("Torso")
				if r and r:IsA("BasePart") then
					ReanimCharacterTeleport(r.CFrame.Position)
				end
			end
			TeleportToPlayer.Text = ""
		end
	end)
end
UI.CreateSeparator(MainPage)
do
UI.CreateText(MainPage, "Internals Settings", 15, Enum.TextXAlignment.Center)
	UI.CreateSwitch(MainPage, "Hook LoadAnimation", Reanimate.UseLoadAnimationHook).Changed:Connect(function(val)
		Reanimate.UseLoadAnimationHook = val
		SaveData.NoLoadAnimationHook = not val
	end)
	if ismissing(hookmetamethod) or ismissing(hookfunction) then
		UI.CreateText(MainPage, "^ this option will not work for you", 10, Enum.TextXAlignment.Center)
	end
	UI.CreateSwitch(MainPage, "Use Physics Glue", Reanimate.UsePhysicsRepRootPart).Changed:Connect(function(val)
		Reanimate.UsePhysicsRepRootPart = val
		SaveData.NoPhysicsRepRootPart = not val
	end)
	local PhysicsGlueDuration = UI.CreateSlider(
		MainPage,
		"Physics Glue Target Duration",
		Reanimate.PhysicsRepRootPartFling,
		0.001,
		30,
		0.001
	)
	PhysicsGlueDuration.Changed:Connect(function(val)
		val = math.clamp(tonumber(val) or 1 / 20, 0.001, 30)
		PhysicsGlueDuration.Value = val
		Reanimate.PhysicsRepRootPartFling = val
		SaveData.PhysicsRepRootPartFling = val
	end)
	UI.CreateText(
		MainPage,
		"internals for physics based reanimation\n(like hat reanimator)",
		10,
		Enum.TextXAlignment.Center
	)
	UI.CreateSwitch(MainPage, "Patchma-like Netless", Reanimate.UsePatchmaLikeNetless).Changed:Connect(function(val)
		Reanimate.UsePatchmaLikeNetless = val
		SaveData.UsePatchmaLikeNetless = val
	end)
	local NetVelSlider = UI.CreateSlider(MainPage, "Netless Velocity", Reanimate.NetlessVelocity, 25.01, 30, 0.1)
	NetVelSlider.Changed:Connect(function(val)
		val = math.clamp(val, 25.01, 30)
		NetVelSlider.Value = val
		Reanimate.NetlessVelocity = val
		SaveData.NetlessVelocity = val
	end)
	UI.CreateSwitch(MainPage, "Apply RotVelocity", Reanimate.UseAngularVelocity).Changed:Connect(function(val)
		Reanimate.UseAngularVelocity = val
		SaveData.UseAngularVelocity = val
	end)
	UI.CreateSwitch(MainPage, "Untrusted Extras", UntrustedExtrasControl.Enabled).Changed
		:Connect(function(val)
			SetUntrustedExtrasEnabled(val)
		end)
	UI.CreateText(
		MainPage,
		"scans UhhhhhhReanim files and connects to the legacy WebSocket; remote code events stay blocked",
		10,
		Enum.TextXAlignment.Center
	)
end
UI.CreateSeparator(MainPage)
	
UserInputService.InputBegan:Connect(function(input, gpe)
	if UserInputService:GetFocusedTextBox() then return end
	if SaveData.KeybindsEnabled then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if HandleKeybind(input.KeyCode.Name) then return end
		end
	end
	ContextActions:OnInput(input, gpe)
end)
UserInputService.InputChanged:Connect(function(input, gpe)
	if UserInputService:GetFocusedTextBox() then return end
	ContextActions:OnInput(input, gpe)
end)
UserInputService.InputEnded:Connect(function(input, gpe)
	if UserInputService:GetFocusedTextBox() then return end
	ContextActions:OnInput(input, gpe)
end)

if type(SaveData.ModuleConfigs) ~= "table" then
	SaveData.ModuleConfigs = {}
end
if type(SaveData.Favorites) ~= "table" then
	SaveData.Favorites = {}
end
local function GiveFunctionsToFunction(func)
	local env = b_getfenv(func)
	env.RandomString = Util.RandomString
	env.Util_SetMotor6DTransform = Util.SetMotor6DTransform
	env.Util_SetMotor6DOffset = Util.SetMotor6DOffset
	env.Util_CreateText = UI.CreateText
	env.Util_CreateButton = UI.CreateButton
	env.Util_CreateSwitch = UI.CreateSwitch
	env.Util_CreateTextbox = UI.CreateTextbox
	env.Util_CreateSlider = UI.CreateSlider
	env.Util_CreateDropdown = UI.CreateDropdown
	env.Util_CreateCanvas = UI.CreateCanvas
	env.Util_CreateScrollCanvas = UI.CreateScrollCanvas
	env.Util_CreateSeparator = UI.CreateSeparator
	env.ReanimCamera = Reanimate.Camera
	env.LimbReanimator = LimbReanimator
	env.HatReanimator = HatReanimator
	env.ReanimateShowHitboxes = ReanimateShowHitboxes
	env.ReanimateFling = ReanimateFling
	env.SetOverrideMovesetMusic = SetOverrideMovesetMusic
	env.GetOverrideMovesetMusicTime = GetOverrideMovesetMusicTime
	env.SetOverrideMovesetMusicTime = SetOverrideMovesetMusicTime
	env.SetOverrideMovesetMusicSpeed = SetOverrideMovesetMusicSpeed
	env.SetOverrideDanceMusic = SetOverrideDanceMusic
	env.GetOverrideDanceMusicTime = GetOverrideDanceMusicTime
	env.SetOverrideDanceMusicTime = SetOverrideDanceMusicTime
	env.SetOverrideDanceMusicSpeed = SetOverrideDanceMusicSpeed
	env.AnimLib = AnimLib
	env.ContextActions = ContextActions
	env.AssetGetPathFromFilename = AssetGetPathFromFilename
	env.AssetGetContentId = AssetGetContentId
	env.ProtectedChat = ProtectedChat
	env.OnPlayerChatted = OnPlayerChatted
	env.HiddenGui = SCREENGUI
	env.FallenPartsDestroyHeight = FallenPartsDestroyHeight
	return func
end
local function ClearModules()
	table.clear(MovementStyles)
	table.clear(DanceableDances)
	Util.ClearAllChildrenGui(MovesetsPage.List)
	Util.ClearAllChildrenGui(DancesPage.List)
	RefreshKeybinds()
end
local function GetModuleHash(m)
	if m.Hash then return m.Hash end
	local str = m.Name .. "somethingsomethingidkLOL:3:3:3:3" .. m.Description
	str = buffer.fromstring(string.rep(str, 8))
	local hash = {36, 91, 225, 10, 232, 117, 96, 243, 93, 128, 61, 97, 101, 120, 130, 69, 177, 80, 131, 27, 137, 242, 155, 245, 22, 123, 197, 145, 146, 206, 157, 20, 36, 91, 225, 10, 232, 117, 96, 243, 93, 128, 61, 97, 101, 120, 130, 69, 177, 80, 131, 27, 137, 242, 155, 245, 22, 123, 197, 145, 146, 206, 157, 20}
	local off = buffer.readu8(str, 0) % 64
	local l = buffer.len(str)
	for i=1, l do
		local j = ((off + i) % 64) + 1
		hash[j] = bit32.bxor(hash[j], buffer.readu8(str, i - 1)) % 256
	end
	str = ""
	local hex = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
	for i=1, #hash do
		local x = hash[i]
		local a, b = x % 16, x // 16
		str ..= hex[b + 1] .. hex[a + 1]
	end
	m.Hash = str
	return str
end
local function AddMoveset(m)
	if type(m) == "table" then
		if not m.Name then return end
		if not m.Description then return end
		if not m.Config then return end
		if not m.Assets then return end
		if not m.Init then return end
		if not m.Update then return end
		if not m.Destroy then return end
		GetModuleHash(m)
		if m.LoadConfig then
			if SaveData.ModuleConfigs[m.Hash] then
				pcall(m.LoadConfig, SaveData.ModuleConfigs[m.Hash])
			end
		end
		table.insert(MovementStyles, m)
		local item = UI.CreateItemListItem(MovesetsPage.List)
		local msname = UI.CreateText(item, m.Name .. " &gt;", 20, Enum.TextXAlignment.Left)
		local msdesc = UI.CreateText(item, string.split(m.Description, "\n")[1], 12, Enum.TextXAlignment.Left)
		msname.Name = "LabelName"
		msdesc.Name = "LabelDesc"
		item.Parent.Name = m.Name .. " " .. m.Description
		Util.LinkDestroyI2C(item, item.Activated:Connect(function()
			local page = UI.CreatePage()
			page.ZIndex = 2
			page.Position = UDim2.new(0.5, 360, 0.5, 0)
			page.Interactable = false
			page.Visible = true
			UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
				page.Interactable = false
				MovesetsPage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 360, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					MovesetsPage.Interactable = true
					page:Destroy()
				end)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, m.Name, 20, Enum.TextXAlignment.Left)
			UI.CreateText(page, m.Description, 15, Enum.TextXAlignment.Left)
			local equip, equiptext = UI.CreateButton(page, "Use Moveset", 20)
			if MovementStyleIndex == table.find(MovementStyles, m) then
				equiptext.Text = "* ACTIVE *"
			end
			equip.Activated:Connect(function()
				equiptext.Text = "* ACTIVE *"
				MovementStyleIndex = table.find(MovementStyles, m)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, "* Configuration *", 15, Enum.TextXAlignment.Center)
			m.Config(page)
			MovesetsPage.Interactable = false
			local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
			tween:Play()
			tween.Completed:Connect(function()
				page.Interactable = true
			end)
		end))
		return m.Name
	end
end
local function AddDance(m)
	if type(m) == "table" then
		if not m.Name then return end
		if not m.Description then return end
		if not m.Assets then return end
		if not m.Config then return end
		if not m.Init then return end
		if not m.Update then return end
		if not m.Destroy then return end
		GetModuleHash(m)
		if m.LoadConfig then
			if SaveData.ModuleConfigs[m.Hash] then
				pcall(m.LoadConfig, SaveData.ModuleConfigs[m.Hash])
			end
		end
		table.insert(DanceableDances, m)
		local item = UI.CreateItemListItem(DancesPage.List)
		local msname = UI.CreateText(item, m.Name .. " &gt;", 20, Enum.TextXAlignment.Left)
		local msdesc = UI.CreateText(item, string.split(m.Description, "\n")[1], 12, Enum.TextXAlignment.Left)
		msname.Name = "LabelName"
		msdesc.Name = "LabelDesc"
		item.Parent.Name = m.Name .. " " .. m.Description
		item.Parent:SetAttribute("DanceCategory", m.Category or "Dance")
		item.Parent:SetAttribute("DanceHash", m.Hash)
		local starBtn = Instance.new("TextButton", item)
		starBtn.Name = "FavStar"
		starBtn.AnchorPoint = Vector2.new(1, 0.5)
		starBtn.Position = UDim2.new(1, -3, 0.5, 0)
		starBtn.Size = UDim2.new(0, 22, 0, 22)
		starBtn.BackgroundTransparency = 1
		starBtn.Font = Enum.Font.Code
		starBtn.TextSize = 16
		starBtn.ZIndex = item.ZIndex + 1
		starBtn.Text = SaveData.Favorites[m.Hash] and "★" or "☆"
		AddToRenderStep(function(t)
			starBtn.TextColor3 = SaveData.Favorites[m.Hash] and Color3.fromRGB(255, 215, 0) or GetUIColor(t)
		end, starBtn)
		Util.LinkDestroyI2C(item, starBtn.Activated:Connect(function()
			SaveData.Favorites[m.Hash] = (not SaveData.Favorites[m.Hash]) or nil
			starBtn.Text = SaveData.Favorites[m.Hash] and "★" or "☆"
			ApplyDanceFilter()
		end))
		Util.LinkDestroyI2C(item, item.Activated:Connect(function()
			local page = UI.CreatePage()
			page.ZIndex = 2
			page.Position = UDim2.new(0.5, 360, 0.5, 0)
			page.Interactable = false
			page.Visible = true
			UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
				page.Interactable = false
				DancesPage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 360, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					DancesPage.Interactable = true
					page:Destroy()
				end)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, m.Name, 20, Enum.TextXAlignment.Left)
			UI.CreateText(page, m.Description, 15, Enum.TextXAlignment.Left)
			local equip, equiptext = UI.CreateButton(page, "Play Dance", 20)
			if CurrentDance == m then
				equiptext.Text = "Stop Dance"
			end
			equip.Activated:Connect(function()
				if CurrentDance == m then
					equiptext.Text = "Play Dance"
					CurrentDance = nil
				else
					equiptext.Text = "Stop Dance"
					CurrentDance = m
				end
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, "* Configuration *", 15, Enum.TextXAlignment.Center)
			m.Config(page)
			DancesPage.Interactable = false
			local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
			tween:Play()
			tween.Completed:Connect(function()
				page.Interactable = true
			end)
		end))
		return m.Name
	end
end

-- ============================================================
-- ANIMATION CREATOR
-- ============================================================
local AddModule -- forward ref (defined after this block)
do
	local LIMBS = {"Neck", "Left Shoulder", "Right Shoulder", "Left Hip", "Right Hip", "RootJoint"}
	local LIMB_DISPLAY = {"Head (Neck)", "L.Arm (Shoulder)", "R.Arm (Shoulder)", "L.Leg (Hip)", "R.Leg (Hip)", "Root (RootJoint)"}

	local CreatorAnim = {Name = "My Dance", Duration = 2, Keyframes = {}}
	local CreatorSelKFIdx = nil
	local CreatorSelLimb = LIMBS[1]
	local CreatorPlaying = false
	local CreatorPlayT = 0
	local _CreatorPrevDance = nil
	local CreatorRefreshUI = nil -- forward

	-- Interpolate between two pose values
	local function _CreatorInterp(p1, p2, alpha, axis)
		local v1 = p1 and p1[axis] or 0
		local v2 = p2 and p2[axis] or 0
		return v1 + (v2 - v1) * alpha
	end

	-- Build a live dance module from CreatorAnim for preview
	local function _CreatorBuildModule()
		local snapKFs = {}
		for _, kf in CreatorAnim.Keyframes do
			local poses = {}
			for k, v in kf.Poses do poses[k] = {X=v.X, Y=v.Y, Z=v.Z} end
			table.insert(snapKFs, {Time=kf.Time, Poses=poses})
		end
		table.sort(snapKFs, function(a, b) return a.Time < b.Time end)
		local dur = CreatorAnim.Duration
		return {
			ModuleType = "DANCE",
			Name = "(Preview) " .. CreatorAnim.Name,
			Description = "Animation Creator preview",
			Category = "Dance",
			Assets = {},
			_t = 0,
			_kfs = snapKFs,
			_dur = dur,
			Config = function() end,
			Init = function(self, rc) self._t = 0 end,
			Update = function(self, dt, rc)
				if #self._kfs == 0 then return end
				self._t = (self._t + dt) % self._dur
				local t = self._t
				local kfs = self._kfs
				local k1, k2 = kfs[#kfs], kfs[1]
				for i = 1, #kfs - 1 do
					if kfs[i].Time <= t and kfs[i+1].Time > t then
						k1, k2 = kfs[i], kfs[i+1]
						break
					end
				end
				local span = k2.Time - k1.Time
				local alpha = span > 0 and math.clamp((t - k1.Time) / span, 0, 1) or 0
				local torso = rc:FindFirstChild("Torso")
				if not torso then return end
				for _, motorName in {"Neck","Left Shoulder","Right Shoulder","Left Hip","Right Hip","RootJoint"} do
					local motor = torso:FindFirstChild(motorName)
					if not motor then
						motor = rc:FindFirstChild(motorName, true)
					end
					if motor then
						local p1 = k1.Poses[motorName]
						local p2 = k2.Poses[motorName]
						if p1 or p2 then
							local rx = math.rad(_CreatorInterp(p1, p2, alpha, "X"))
							local ry = math.rad(_CreatorInterp(p1, p2, alpha, "Y"))
							local rz = math.rad(_CreatorInterp(p1, p2, alpha, "Z"))
							Util.SetMotor6DTransform(motor, CFrame.Angles(rx, ry, rz))
						end
					end
				end
			end,
			Destroy = function(self, rc) end,
		}
	end

	-- Serialize CreatorAnim to a saveable Lua module string
	local function _CreatorSerialize()
		local lines = {}
		local function w(s) table.insert(lines, s) end
		w("-- Generated by Uhhhhhh Reanim Animation Creator")
		w(string.format("local _kfs = %s", (function()
			local kfparts = {}
			for _, kf in CreatorAnim.Keyframes do
				local poses = {}
				for motorName, rot in kf.Poses do
					table.insert(poses, string.format("[%q]={X=%g,Y=%g,Z=%g}", motorName, rot.X, rot.Y, rot.Z))
				end
				table.insert(kfparts, string.format("{Time=%g,Poses={%s}}", kf.Time, table.concat(poses,",")))
			end
			return "{" .. table.concat(kfparts, ",") .. "}"
		end)()))
		w(string.format("local _dur = %g", CreatorAnim.Duration))
		w("return {")
		w(string.format('  ModuleType="DANCE", Name=%q,', CreatorAnim.Name))
		w(string.format('  Description="Created with Animation Creator",'))
		w('  Category="Dance", Assets={}, _t=0, _kfs=_kfs, _dur=_dur,')
		w('  Config=function(self,page) end,')
		w('  Init=function(self,rc) self._t=0 end,')
		w('  Update=function(self,dt,rc)')
		w('    if #self._kfs==0 then return end')
		w('    self._t=(self._t+dt)%self._dur')
		w('    local t=self._t local kfs=self._kfs')
		w('    local k1,k2=kfs[#kfs],kfs[1]')
		w('    for i=1,#kfs-1 do if kfs[i].Time<=t and kfs[i+1].Time>t then k1,k2=kfs[i],kfs[i+1] break end end')
		w('    local span=k2.Time-k1.Time local alpha=span>0 and math.clamp((t-k1.Time)/span,0,1) or 0')
		w('    local torso=rc:FindFirstChild("Torso") if not torso then return end')
		w('    for _,mn in {"Neck","Left Shoulder","Right Shoulder","Left Hip","Right Hip","RootJoint"} do')
		w('      local m=torso:FindFirstChild(mn) or rc:FindFirstChild(mn,true)')
		w('      if m then')
		w('        local p1=k1.Poses[mn] local p2=k2.Poses[mn]')
		w('        if p1 or p2 then')
		w('          local function iv(a,b,ax) local v1=a and a[ax] or 0 local v2=b and b[ax] or 0 return v1+(v2-v1)*alpha end')
		w('          Util_SetMotor6DTransform(m,CFrame.Angles(math.rad(iv(p1,p2,"X")),math.rad(iv(p1,p2,"Y")),math.rad(iv(p1,p2,"Z"))))')
		w('        end')
		w('      end')
		w('    end')
		w('  end,')
		w('  Destroy=function(self,rc) end,')
		w('}')
		return table.concat(lines, "\n")
	end

	-- Open Animation Creator page
	AnimCreatorPage = UI.CreatePage()
	AnimCreatorPage.ZIndex = 3
	AnimCreatorPage.Position = UDim2.new(0.5, 360, 0.5, 0)
	AnimCreatorPage.Interactable = false
	AnimCreatorPage.Visible = false

	-- Back button
	local acBack, _ = UI.CreateButton(AnimCreatorPage, " < Back", 20)
	acBack.Activated:Connect(function()
		AnimCreatorPage.Interactable = false
		-- stop preview
		if CreatorPlaying then
			CreatorPlaying = false
			CurrentDance = _CreatorPrevDance
			_CreatorPrevDance = nil
		end
		local tween = TweenService:Create(AnimCreatorPage, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, 360, 0.5, 0),
		})
		tween:Play()
		tween.Completed:Connect(function()
			AnimCreatorPage.Visible = false
			DancesPage.Interactable = true
		end)
	end)
	UI.CreateText(AnimCreatorPage, "✦ Animation Creator", 20, Enum.TextXAlignment.Center)
	UI.CreateSeparator(AnimCreatorPage)

	-- Animation name textbox
	UI.CreateText(AnimCreatorPage, "Animation Name:", 14, Enum.TextXAlignment.Left)
	local acNameBox = UI.CreateTextbox(AnimCreatorPage, CreatorAnim.Name, "Name...", 16)
	acNameBox.Changed:Connect(function()
		CreatorAnim.Name = acNameBox.Text ~= "" and acNameBox.Text or "My Dance"
	end)

	-- Duration slider
	local acDurSlider = UI.CreateSlider(AnimCreatorPage, "Duration (s)", CreatorAnim.Duration, 0.5, 10, 0.1)
	acDurSlider.Changed:Connect(function(v)
		CreatorAnim.Duration = v
		-- clamp all keyframe times
		for _, kf in CreatorAnim.Keyframes do
			kf.Time = math.clamp(kf.Time, 0, v)
		end
		if CreatorRefreshUI then CreatorRefreshUI() end
	end)

	UI.CreateSeparator(AnimCreatorPage)

	-- Limb selector
	local acLimbDrop = UI.CreateDropdown(AnimCreatorPage, "Edit Limb", LIMB_DISPLAY, 1)
	acLimbDrop.Changed:Connect(function(idx)
		CreatorSelLimb = LIMBS[idx]
		if CreatorRefreshUI then CreatorRefreshUI() end
	end)

	-- X/Y/Z rotation sliders
	local acSliderX = UI.CreateSlider(AnimCreatorPage, "X  Pitch (°)", 0, -180, 180, 1)
	local acSliderY = UI.CreateSlider(AnimCreatorPage, "Y  Yaw   (°)", 0, -180, 180, 1)
	local acSliderZ = UI.CreateSlider(AnimCreatorPage, "Z  Roll  (°)", 0, -180, 180, 1)

	local function _CreatorLoadPoseIntoSliders()
		local kf = CreatorSelKFIdx and CreatorAnim.Keyframes[CreatorSelKFIdx]
		if kf and kf.Poses[CreatorSelLimb] then
			local p = kf.Poses[CreatorSelLimb]
			acSliderX.Value = p.X
			acSliderY.Value = p.Y
			acSliderZ.Value = p.Z
		else
			acSliderX.Value = 0
			acSliderY.Value = 0
			acSliderZ.Value = 0
		end
	end

	-- Set Pose button
	local acSetPoseBtn, _ = UI.CreateButton(AnimCreatorPage, "Set Pose at Selected KF", 18)
	acSetPoseBtn.Activated:Connect(function()
		if not CreatorSelKFIdx then
			Util.UINotify("Select or add a keyframe first")
			return
		end
		local kf = CreatorAnim.Keyframes[CreatorSelKFIdx]
		if not kf then return end
		kf.Poses[CreatorSelLimb] = {X = acSliderX.Value, Y = acSliderY.Value, Z = acSliderZ.Value}
		if CreatorRefreshUI then CreatorRefreshUI() end
	end)

	local acClearLimbBtn, _ = UI.CreateButton(AnimCreatorPage, "Clear Limb at KF", 18)
	acClearLimbBtn.Activated:Connect(function()
		if not CreatorSelKFIdx then return end
		local kf = CreatorAnim.Keyframes[CreatorSelKFIdx]
		if kf then kf.Poses[CreatorSelLimb] = nil end
		_CreatorLoadPoseIntoSliders()
		if CreatorRefreshUI then CreatorRefreshUI() end
	end)

	UI.CreateSeparator(AnimCreatorPage)
	UI.CreateText(AnimCreatorPage, "Keyframes", 16, Enum.TextXAlignment.Left)

	-- Keyframe list scroll canvas
	local acKFCanvas = UI.CreateScrollCanvas(AnimCreatorPage, 90)
	local acKFList = acKFCanvas -- scroll canvas acts as list parent

	-- Time slider for adding keyframes
	local acTimeSlider = UI.CreateSlider(AnimCreatorPage, "New KF Time (s)", 0, 0, 10, 0.05)

	-- Add / Remove KF buttons
	local acAddKFBtn, _ = UI.CreateButton(AnimCreatorPage, "Add Keyframe", 18)
	acAddKFBtn.Activated:Connect(function()
		local t = acTimeSlider.Value
		-- check no duplicate time
		for _, kf in CreatorAnim.Keyframes do
			if math.abs(kf.Time - t) < 0.01 then
				Util.UINotify("Keyframe already exists at " .. string.format("%.2f", t) .. "s")
				return
			end
		end
		table.insert(CreatorAnim.Keyframes, {Time = t, Poses = {}})
		table.sort(CreatorAnim.Keyframes, function(a, b) return a.Time < b.Time end)
		-- select the new one
		for i, kf in CreatorAnim.Keyframes do
			if math.abs(kf.Time - t) < 0.01 then CreatorSelKFIdx = i break end
		end
		if CreatorRefreshUI then CreatorRefreshUI() end
	end)

	local acRemKFBtn, _ = UI.CreateButton(AnimCreatorPage, "Remove Selected KF", 18)
	acRemKFBtn.Activated:Connect(function()
		if not CreatorSelKFIdx then return end
		table.remove(CreatorAnim.Keyframes, CreatorSelKFIdx)
		CreatorSelKFIdx = math.min(CreatorSelKFIdx, #CreatorAnim.Keyframes)
		if CreatorSelKFIdx == 0 then CreatorSelKFIdx = nil end
		if CreatorRefreshUI then CreatorRefreshUI() end
	end)

	UI.CreateSeparator(AnimCreatorPage)

	-- Preview / Stop
	local acPreviewBtn, acPreviewTxt = UI.CreateButton(AnimCreatorPage, "▶  Preview", 20)
	acPreviewBtn.Activated:Connect(function()
		if CreatorPlaying then
			CreatorPlaying = false
			acPreviewTxt.Text = "▶  Preview"
			CurrentDance = _CreatorPrevDance
			_CreatorPrevDance = nil
		else
			if #CreatorAnim.Keyframes < 2 then
				Util.UINotify("Need at least 2 keyframes to preview")
				return
			end
			CreatorPlaying = true
			acPreviewTxt.Text = "■  Stop Preview"
			_CreatorPrevDance = CurrentDance
			local mod = _CreatorBuildModule()
			GetModuleHash(mod)
			table.insert(DanceableDances, mod)
			CurrentDance = mod
		end
	end)

	-- Save
	local acSaveBtn, _ = UI.CreateButton(AnimCreatorPage, "💾  Save as Dance Module", 20)
	acSaveBtn.Activated:Connect(function()
		if #CreatorAnim.Keyframes < 2 then
			Util.UINotify("Need at least 2 keyframes to save")
			return
		end
		local filename = "Creator_" .. CreatorAnim.Name:gsub("[^%w_]", "_") .. ".lua"
		local path = "BlaaBlaaReanim/Modules/" .. filename
		local src = _CreatorSerialize()
		local ok, err = pcall(writefile, path, src)
		if not ok then
			Util.UINotify("Save failed: " .. tostring(err))
			return
		end
		-- load it immediately
		local func, loaderr = loadstring(src, "CreatorAnim::" .. CreatorAnim.Name)
		if not func then
			Util.UINotify("Compile error: " .. tostring(loaderr))
			return
		end
		local name, err2 = AddModule(func)
		if name then
			Util.UINotify("Saved + loaded: " .. name)
			RefreshKeybinds()
		else
			Util.UINotify("Loaded but error: " .. tostring(err2))
		end
	end)

	-- Clear All
	local acClearBtn, _ = UI.CreateButton(AnimCreatorPage, "🗑  Clear All Keyframes", 18)
	acClearBtn.Activated:Connect(function()
		table.clear(CreatorAnim.Keyframes)
		CreatorSelKFIdx = nil
		if CreatorRefreshUI then CreatorRefreshUI() end
		Util.UINotify("Cleared all keyframes")
	end)

	-- Refresh KF list UI
	CreatorRefreshUI = function()
		Util.ClearAllChildrenGui(acKFList)
		local layout = Instance.new("UIListLayout", acKFList)
		layout.FillDirection = Enum.FillDirection.Vertical
		layout.Padding = UDim.new(0, 2)
		for i, kf in CreatorAnim.Keyframes do
			local limbCount = 0
			for _ in kf.Poses do limbCount += 1 end
			local label = string.format("KF %d  t=%.2fs  [%d limbs]", i, kf.Time, limbCount)
			local btn = Instance.new("TextButton", acKFList)
			btn.Size = UDim2.new(1, -4, 0, 18)
			btn.BackgroundTransparency = CreatorSelKFIdx == i and 0 or 0.7
			btn.Font = Enum.Font.Code
			btn.TextSize = 11
			btn.Text = (CreatorSelKFIdx == i and "→ " or "  ") .. label
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.BorderSizePixel = 0
			Stylize(btn)
			btn.Activated:Connect(function()
				CreatorSelKFIdx = i
				acTimeSlider.Value = kf.Time
				_CreatorLoadPoseIntoSliders()
				CreatorRefreshUI()
			end)
		end
		if #CreatorAnim.Keyframes == 0 then
			local empty = Instance.new("TextLabel", acKFList)
			empty.Size = UDim2.new(1, 0, 0, 18)
			empty.BackgroundTransparency = 1
			empty.Font = Enum.Font.Code
			empty.TextSize = 11
			empty.TextColor3 = Color3.fromRGB(150, 150, 150)
			empty.Text = "(no keyframes yet)"
		end
	end
	CreatorRefreshUI()

end

AddModule = function(func)
	GiveFunctionsToFunction(func)
	local m = func()
	if m and type(m) == "table" then
		if m.ModuleType == "MOVESET" then
			return AddMoveset(m)
		elseif m.ModuleType == "DANCE" then
			return AddDance(m)
		else
			return nil, "Unknown ModuleType for Module!"
		end
	else
		return nil, "Module return value is not a table. Got " .. typeof(m) .. " instead."
	end
end
local function AddModules(list)
	local names = {}
	local logging = ""
	if type(list) == "table" then
		for i=1, #list do
			local name, logging2 = AddModule(list[i])
			if name then table.insert(names, name) end
			if logging2 then
				logging ..= "\n[ERROR] M" .. i .. ": " .. logging2
			end
			task.wait()
		end
	else
		logging ..= "\n[LOG] Module return value is not a table array of module functions. Skipping."
	end
	logging ..= "\n[LOG] Loaded " .. #names .. " modules."
	return names, logging
end
task.spawn(function()
	local function SaveConfig(m)
		if m.SaveConfig then
			local s, data = pcall(m.SaveConfig)
			if s and data then
				local s2, p = pcall(HttpService.JSONEncode, HttpService, data)
				if s2 and p then
					SaveData.ModuleConfigs[m.Hash] = data
					return
				else
					warn(p)
				end
			else
				warn(data)
			end
			Util.Notify("Failed to save " .. m.Name .. "'s config")
		end
	end
	while task.wait(5) do
		for _,m in MovementStyles do
			SaveConfig(m)
		end
		for _,m in DanceableDances do
			SaveConfig(m)
		end
	end
end)
task.spawn(function()
	local _oldcharacterreference = nil
	local errorsandwarnings = {}
	local currenterrorid = 1
	while true do
		local dt = RunService.Heartbeat:Wait()
		xpcall(function(dt)
			local ReanimCharacter = Reanimate.Character
			SaveData.MovesetIndex = MovementStyleIndex
			if ReanimCharacter then
				if _oldcharacterreference ~= ReanimCharacter then
					SetOverrideMovesetMusic(nil)
					SetOverrideDanceMusic(nil)
					if CurrentMovementStyle then
						pcall(CurrentMovementStyle.Destroy, nil)
						CurrentMovementStyle = nil
					end
					if _CurrentDance then
						pcall(_CurrentDance.Destroy, nil)
						ResetDancePose(_oldcharacterreference)
						_CurrentDance = nil
					end
					_MovementStyleIndex = nil
				end
				if MovementStyleIndex ~= _MovementStyleIndex then
					if CurrentMovementStyle then
						CurrentMovementStyle.Destroy(ReanimCharacter)
						CurrentMovementStyle = nil
					end
					_MovementStyleIndex = MovementStyleIndex
					CurrentMovementStyle = MovementStyles[MovementStyleIndex]
					SetOverrideMovesetMusic(nil)
					if ReanimCharacter:GetAttribute("MovementInit") then
						Reanimate.CreateCharacter()
						ReanimCharacter = Reanimate.Character
					end
				end
				if CurrentMovementStyle then
					if ReanimCharacter:GetAttribute("MovementInit") then
						CurrentMovementStyle.Update(dt, ReanimCharacter)
						if CurrentDance ~= _CurrentDance then
							if _CurrentDance then
								pcall(_CurrentDance.Destroy, ReanimCharacter)
								ResetDancePose(ReanimCharacter)
							end
							_CurrentDance = CurrentDance
							ReanimCharacter:SetAttribute("IsDancing", nil)
							ReanimCharacter:SetAttribute("DanceInternalName", nil)
							SetOverrideDanceMusic(nil)
						end
						if _CurrentDance then
							if ReanimCharacter:GetAttribute("IsDancing") then
								_CurrentDance.Update(dt, ReanimCharacter)
							else
								if AssetEnsure(_CurrentDance.Assets) then
									ReanimCharacter:SetAttribute("IsDancing", true)
									ReanimCharacter:SetAttribute("DanceInternalName", _CurrentDance.InternalName)
									_CurrentDance.Init(ReanimCharacter)
								else
									SetOverrideDanceMusic(nil)
								end
							end
						end
					else
						HatReanimator.HatWeldOverride = {}
						if AssetEnsure(CurrentMovementStyle.Assets) then
							ReanimCharacter:SetAttribute("MovementInit", true)
							ReanimCharacter:SetAttribute("MovesetInternalName", CurrentMovementStyle.InternalName)
							table.clear(HatReanimator.HatCFrameOverride)
							CurrentMovementStyle.Init(ReanimCharacter)
						else
							SetOverrideMovesetMusic(nil)
						end
					end
				else
					ReanimCharacter:SetAttribute("MovementInit", nil)
					_MovementStyleIndex = nil
				end
			else
				CurrentDance = nil
				_MovementStyleIndex = nil
				SetOverrideMovesetMusic(nil)
				SetOverrideDanceMusic(nil)
				if CurrentMovementStyle then
					CurrentMovementStyle.Destroy(nil)
					CurrentMovementStyle = nil
				end
				if _CurrentDance then
					_CurrentDance.Destroy(nil)
					ResetDancePose(_oldcharacterreference)
					_CurrentDance = nil
				end
			end
			_oldcharacterreference = ReanimCharacter
		end, function(m)
			m = debug.traceback("ANIMLOOP :: " .. m)
			local id = errorsandwarnings[m]
			if not id then
				errorsandwarnings[m] = { currenterrorid, 0 }
				currenterrorid += 1
				warn("ERROR #" .. errorsandwarnings[m][1] .. ": " .. m)
			else
				id[2] += 1
				if id[2] <= 8192 and math.sqrt(id[2]) % 1 == 0 then
					warn("ERROR #" .. id[1] .. " repeated " .. id[2] .. " times")
				end
			end
		end, dt)
	end
end)
UI.CreateSeparator(MainPage)
task.wait()
local CreditsPage = UI.CreatePage()
CreditsPage.ZIndex = 1
CreditsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
CreditsPage.Interactable = false
CreditsPage.Visible = false
UI.CreateButton(MainPage, "Credits", 15).Activated:Connect(function()
	CreditsPage.Interactable = false
	CreditsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CreditsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CreditsPage.Interactable = true
	end)
end)
UI.CreateButton(CreditsPage, "&lt; Hurry back", 20).Activated:Connect(function()
	CreditsPage.Interactable = false
	MainPage.Interactable = false
	local tween = TweenService:Create(CreditsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		CreditsPage.Visible = false
	end)
end)
local UhhhhhhFire = UI.CreateText(CreditsPage, "", 12, Enum.TextXAlignment.Center)
Util.ForceTextSize(UhhhhhhFire)
UI.CreateText(CreditsPage, "Reanimate by STEVE :D", 15, Enum.TextXAlignment.Right)
local UhhhhhhFiret = UI.CreateSlider(CreditsPage, "Transparency", 0.25, 0, 1, 0)
local UhhhhhhFirep = {}
for i=1, 64 do
	table.insert(UhhhhhhFirep, {i / 64, 0.98 + math.random() * 0.04, math.random(), math.random() - 0.5})
end
local UhhhhhhFirea = {
	"XX    XX XX      XX      XX      XX      XX      XX     ",
	"XX    XX XX      XX      XX      XX      XX      XX     ",
	"XX    XX XXXXXX  XXXXXX  XXXXXX  XXXXXX  XXXXXX  XXXXXX ",
	"XX    XX XX   XX XX   XX XX   XX XX   XX XX   XX XX   XX",
	"XXX  XXX XX   XX XX   XX XX   XX XX   XX XX   XX XX   XX",
	" XXXXXX  XX   XX XX   XX XX   XX XX   XX XX   XX XX   XX",
}
local UhhhhhhFirex = #UhhhhhhFirea[1]
local UhhhhhhFirey = #UhhhhhhFirea
AddToRenderStep(function(t, dt)
	local radius = 0.1
	local ratio = (UhhhhhhFirey / UhhhhhhFirex) * 1.75
	if Util.IsGuiVisible(UhhhhhhFire) then
		local tr = math.clamp(UhhhhhhFiret.Value, 0, 1)
		local pp = {}
		for _,v in UhhhhhhFirep do
			v[1] += dt * v[2]
			if v[1] >= 1 then
				v[1], v[2], v[3], v[4] = 0, 0.98 + math.random() * 0.04, math.random(), math.random() - 0.5
			end
			table.insert(pp, {1 - v[1], v[3] + v[4] * v[1] * 0.25, (1 - v[1]) * (1 + radius / ratio)})
		end
		local aa = {}
		for y=1, UhhhhhhFirey do
			local a = ""
			for x=1, UhhhhhhFirex do
				local b = UhhhhhhFirea[y]:sub(x, x)
				if b == " " and tr < 0.1 then
					a ..= " "
				else
					local bright = 0
					local x1, y1 = x / UhhhhhhFirex, y / UhhhhhhFirey
					for _,v in pp do
						local x2, y2 = v[2], v[3]
						local x3, y3 = x2 - x1, (y2 - y1) * ratio
						local a = math.max(0, 1 - math.sqrt(x3 * x3 + y3 * y3) / radius) * v[1];
						bright += (1.0 - bright) * math.pow(a, 1.5);
					end
					if b == " " then bright *= tr end
					if bright > 0.9 then
						a ..= "Q";
					elseif bright > 0.8 then
						a ..= "W";
					elseif bright > 0.7 then
						a ..= "#";
					elseif bright > 0.6 then
						a ..= "S";
					elseif bright > 0.5 then
						a ..= "l";
					elseif bright > 0.4 then
						a ..= "v";
					elseif bright > 0.3 then
						a ..= "|";
					elseif bright > 0.2 then
						a ..= ";";
					elseif bright > 0.1 then
						a ..= ".";
					else
						a ..= " ";
					end
				end
			end
			table.insert(aa, a)
		end
		UhhhhhhFire.Text = table.concat(aa, "\n")
		pp = nil
	end
end)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>* Credits to *</b>", 15, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>rez aka @chiptune</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "wow cool 64k demos, great inspiration", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>AALib & BB Demo</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "artificial ascii art cool!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "no transformer needed lol", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Polariaus</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "isnt reanimation dead? oh hats.", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "also ur like a fast bug hunter", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Awesome Awes955</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "u run out of ideas", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "but i dont, cuz u give me ideas", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>MyWorld</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "so thats how netless really works", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "math.max is THE solution here!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "also, hey, pwease unban me from Hax Updates >m<", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Krystal Dance V3 mod by Theo</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "nice dance animations. MINE NOW!! >:D", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Delta Executor</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "primary env target", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "thanks for disabling the key system temporarily when its down", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "happened fast lol", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Dubmood</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "u and rez REALLY need to collab again or smth", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "the scene is dead was (and still is) so cool!!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>4mat</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "pls dont kick dubmood's ass lol", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Counter Strike 2</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "cs2-theme.mp3 — great main theme music", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>BlackEyedPeas</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "rock-that-body.mp3 — banger", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>pouet.net</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "other than rez' and anat's demos theres lots of good demos there", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "tho im considered a LAMER with no scene ID loool", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "so uhhhhhh....", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "...greetings to lamers and fuckings to elites?", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>github.com</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "YES!! KEEP SAVING ME FROM MY DATA CORRUPTION!!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "no i dont want ur stupid ai subscription", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Those require script databases</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "bro 99% of the characters are LORELESS and SILENT", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>my math teacher</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "i LOVE your method of teaching! its fun!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>return_request</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "what is DisconnectVerboselyModeratedGame again?", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "also when pissstrap release (and banstrap)", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Termux</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "what a great \"distro\", will u add open document api?", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>anthonyisnthere</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "who r u again? oh ur the one who made skidfling in ur github", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>adamxdd690</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "u got ur new phone! omedeto & ur great!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>indexFailed</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "thats a good lua code snippet trade :)", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Roblox</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "this program's primary target", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "expose more backend functions for me like a good boy", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>rqz's Genesis FE</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "ill be taking ALL your convertions >:D", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "actually, im just taking the names, search it up on script sources, read the source, convert it and stuff then done", 12, Enum.TextXAlignment.Center)
--[[UI.CreateText(CreditsPage, "<font color=\"#4444FF\"><b>Empyrean Reanimate (click for Discord)</b></font>", 12, Enum.TextXAlignment.Center).InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Util.Notify("Link copied!")
		pcall(setclipboard, "https://discord.gg/UJ7YtqadPJ")
		pcall(request, {
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = 'application/json',
				["Origin"] = "https://discord.com",
			},
			Body = HttpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				nonce = HttpService:GenerateGUID(false),
				args = {code = "UJ7YtqadPJ"},
			}),
		})
	end
end)
UI.CreateText(CreditsPage, "your tool fling is great reference!", 12, Enum.TextXAlignment.Center)]]
-- now it just takes 2 seconds to take ownership with your method, sorry
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>* Greetings to *</b>", 15, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "fev, inno, rqz, mry7zz, theo, redactedre, colon", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "terminal, guinwah, kasil (just a greet), hoster", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "hamoun, baze, luacope, 2024, 2023 and 2022 me", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "scout, edge, shownape, index, blackhole/whitehole", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "zero from iwbtc for no reason, presidentanvil, mech/catlover", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "return from fishstrap, erika, skeltoun, pala :D", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "awes, boredgal, hamza, nexus", 12, Enum.TextXAlignment.Center)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>* Very random quotes *</b>", 15, Enum.TextXAlignment.Center)
do
	local quotes = {
		"anthonyisnthere: \":fasttrack Luacope\"\n(funny because most of the music in this script is made in FastTracker II)",
		"hemi once said: \"hat collide has never worked on perma\"",
		"skids after genesis adds a minimize button: \"REVOLUTIONARY\"",
		"\"roblox banned my leg\" sounds the same in any context",
		"what is a 0x1b packet hack? cuz idk wattahel that is", -- oh its some raknet
		"\"i have real fe bypass but i cant show here cuz roblox will detect and patch you have to join me in my game\"",
		"my income is 2 dollars. i shall DELETE /self now /j",
		"obfuscator: gifted power\nreal-time registry dumper: pure effort",
		"always flinging kdrv3 users (they think they'll have antifling)",
		"im gonna fling you. *turns your screen black*",
		"headcanon: \"Lightning Cannon is a top.\"",
		"\"dont bpt ples\" \"brick portationtele?\"",
		"WHO CARES IF A FEW TREES ARE DYING!?",
		"while i was in mwtp, someone said \"leak the hatdrop script\"",
		"i was in fencing, then someone said \"its the genesis killer\"",
		"STEVE, THE DANCING IMMORTALITY LORD!",
		"imagine getting ur script mogged by a script written and tested mostly on a mobile phone LOL",
		"shownskid",
		"this script mogs genesis", -- true-untrue though
		"\"Tired of your hats phasing through people? Uhhhhhh turns that fact upside-down!\"",
		"\"The best part? It is FREE!! (excluding the taxes and bills) Now, BUY OUR PRODUCT FOR FREE! We know you like it! We know you do.\"",
		"Does anyone ever physically look upwards when they think of ideas? I definitely don't.",
		"\"It's not even another Reanimate; it just uses Emper Reanimate. So you can change the name to 'uhhhh hub', that's it.\"",
		"i wrote this during permadeath's patch. my members are so quick in reporting bugs and stuff lol",
		"i plead the six seventh amendment",
		"\"i have strong network ownership that can take big buildings\" \"i have strong network too\" *61 MBPS*",
		"when your script is so good it keeps the reanimation community alive-",
		"i need your hat ids",
		"We can confirm that we were !",
		"Looking At You Just Makes Me Jaded",
		"\"Yo whwho can dm me emeremerian  reanimation\"",
		"boredgal was here..",
	}
	for _=1, 15 do
		local idx = math.random(1, #quotes)
		UI.CreateText(CreditsPage, table.remove(quotes, idx), 12, Enum.TextXAlignment.Center)
	end
end
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "DISCLAIMER: Some random quotes made here are jokes (e.g.: 'this script mogs genesis') and should not be taken seriously. This also includes all the self-glazing quotes. It's your choice to agree with them or not, and if you do or don't, don't come harass/mock any individuals from it. In the end, a joke quote is a joke quote.", 15, Enum.TextXAlignment.Center)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "This \"software\" is FREE, meaning YOU SHOULD NOT REDISTRIBUTE WITH RENUMERATIVE INTENT!!", 15, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "If you want to add content to Uhhhhhh, like Dances or Movesets, go to <font color=\"#4444FF\">this thing</font>.", 15, Enum.TextXAlignment.Center).InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Util.UINotify("Link copied!")
		pcall(setclipboard, "https://github.com/STEVE-916-create/Uhhhhhh/")
	end
end)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>(C) 2026 STEVETHEREALONE</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "all rights reserved", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<font color=\"#4444FF\">[ Discord invite ]</font>", 15, Enum.TextXAlignment.Center).InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Util.UINotify("Link copied!")
		pcall(setclipboard, "https://discord.gg/NASNUKRBVM")
		pcall(request, {
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = 'application/json',
				["Origin"] = "https://discord.com",
			},
			Body = HttpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				nonce = HttpService:GenerateGUID(false),
				args = {code = "NASNUKRBVM"},
			}),
		})
	end
end)
local ChangelogsPage = UI.CreatePage()
ChangelogsPage.ZIndex = 1
ChangelogsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
ChangelogsPage.Interactable = false
ChangelogsPage.Visible = false
UI.CreateButton(MainPage, "Changelogs", 15).Activated:Connect(function()
	ChangelogsPage.Interactable = false
	ChangelogsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(ChangelogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		ChangelogsPage.Interactable = true
	end)
end)
UI.CreateButton(ChangelogsPage, "&lt; Hurry back", 20).Activated:Connect(function()
	ChangelogsPage.Interactable = false
	MainPage.Interactable = false
	local tween = TweenService:Create(ChangelogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		ChangelogsPage.Visible = false
	end)
end)
task.spawn(function()
	UI.CreateText(ChangelogsPage, "Changelogs", 30, Enum.TextXAlignment.Center)
	local content = UI.CreateText(ChangelogsPage, "Loading...", 12, Enum.TextXAlignment.Left)
	xpcall(function()
		local logs = game:HttpGet("https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/CHANGELOGS")
		content.Text = "Rendering error."
		for _,v in string.split(logs, "\n") do
			if v:sub(1, 2) == "# " then
				UI.CreateText(ChangelogsPage, "<b>" .. v:sub(3) .. "</b>", 15, Enum.TextXAlignment.Left)
			else
				UI.CreateText(ChangelogsPage, v, 12, Enum.TextXAlignment.Left)
			end
		end
		content.Parent:Destroy()
	end, function()
		content.Text = "ERROR: Could not fetch"
	end)
end)
task.wait()
local InitLogsPage = UI.CreatePage()
InitLogsPage.ZIndex = 1
InitLogsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
InitLogsPage.Interactable = false
InitLogsPage.Visible = false
UI.CreateButton(MainPage, "Init Logs", 15).Activated:Connect(function()
	InitLogsPage.Interactable = false
	InitLogsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(InitLogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		InitLogsPage.Interactable = true
	end)
end)
UI.CreateButton(InitLogsPage, "&lt; Hurry back", 20).Activated:Connect(function()
	InitLogsPage.Interactable = false
	MainPage.Interactable = false
	local tween = TweenService:Create(InitLogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		InitLogsPage.Visible = false
	end)
end)
local InitLogsText = UI.CreateText(InitLogsPage, "Loading...", 12, Enum.TextXAlignment.Left)
local function _contentgetgithubraw(path)
	InitLogsText.Text ..= "\n[LOG] [GitGET] GET api./" .. path
	local s, resp = pcall(request, {
		Method = "GET",
		Url = "https://api.github.com/repos/STEVE-916-create/Uhhhhhh/contents/content/" .. path,
		Headers = {
			Accept = "application/vnd.github.VERSION.raw"
		}
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	if s and resp then
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET api./" .. path .. " " .. resp.StatusCode
	elseif s then
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET api./" .. path .. " NIL"
	else
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET api./" .. path .. " ERR " .. resp
	end
	InitLogsText.Text ..= "\n[LOG] [GitGET] GET raw./" .. path
	s, resp = pcall(request, {
		Method = "GET",
		Url = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/content/" .. path,
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	if s and resp then
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET raw./" .. path .. " " .. resp.StatusCode
	elseif s then
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET raw./" .. path .. " NIL"
	else
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET raw./" .. path .. " ERR " .. resp
	end
	return nil
end
local UserModulesListor = {}
local function ReplaceBuiltinPlainOnce(source, needle, replacement)
	local first, last = string.find(source, needle, 1, true)
	if not first then
		return source, false
	end
	return source:sub(1, first - 1) .. replacement .. source:sub(last + 1), true
end
local function PatchBuiltinModuleSource(filename, source)
	if filename ~= "v_moveset2.lua" or type(source) ~= "string" then
		return source, false
	end
	local moduleMarker = 'm.InternalName = "IPLAYTERRARIEYE"'
	local moduleStart = string.find(source, moduleMarker, 1, true)
	if not moduleStart then
		return source, false
	end
	local nextModule = string.find(source, "\nAddModule(function()", moduleStart + #moduleMarker, true)
		or (#source + 1)
	local prefix = source:sub(1, moduleStart - 1)
	local moduleSource = source:sub(moduleStart, nextModule - 1)
	local suffix = source:sub(nextModule)
	local patchedLocals, didPatchLocals = ReplaceBuiltinPlainOnce(
		moduleSource,
		"\tlocal hum, root, torso\n\tlocal isdancing = false",
		"\tlocal hum, root, torso\n\tlocal scale = 1\n\tlocal isdancing = false"
	)
	local patchedInit, didPatchInit = ReplaceBuiltinPlainOnce(
		patchedLocals,
		"\tm.Init = function(figure)\n\t\tstart = os.clock()",
		"\tm.Init = function(figure)\n\t\tscale = figure:GetScale()\n\t\tstart = os.clock()"
	)
	if not didPatchLocals or not didPatchInit then
		return source, false
	end
	return prefix .. patchedInit .. suffix, true
end
local UserModulesListor = {}
local USER_MODULE_ROOT = "BlaaBlaaReanim/Modules/"
local USER_ASSET_FOLDERS = {
	[".anim"] = "Anims",
	[".mp3"] = "Sounds",
	[".ogg"] = "Sounds",
	[".wav"] = "Sounds",
	[".png"] = "Images",
	[".jpg"] = "Images",
	[".jpeg"] = "Images",
	[".bmp"] = "Images",
	[".webp"] = "Images",
	[".obj"] = "Models",
	[".fbx"] = "Models",
	[".glb"] = "Models",
	[".gltf"] = "Models",
	[".rbxm"] = "Unknown",
}
local function NormalizeUserPath(path)
	return tostring(path):gsub("\\", "/")
end
local function UserModuleRelativePath(path)
	path = NormalizeUserPath(path)
	local start = path:find(USER_MODULE_ROOT, 1, true)
	return start and path:sub(start + #USER_MODULE_ROOT) or path:match("([^/]+)$") or path
end
local function CollectUserModuleFiles(folder, output, visited, depth)
	if depth > 32 then
		InitLogsText.Text ..= "\n[WARN] User module folder depth limit reached at " .. tostring(folder)
		return
	end
	local normalized = NormalizeUserPath(folder)
	if visited[normalized] then
		return
	end
	visited[normalized] = true
	local listed, entries = pcall(listfiles, folder)
	if not listed or type(entries) ~= "table" then
		InitLogsText.Text ..= "\n[WARN] Could not list user module folder " .. tostring(folder)
		return
	end
	table.sort(entries, function(a, b)
		return NormalizeUserPath(a) < NormalizeUserPath(b)
	end)
	for _, entry in entries do
		local folderOk, folderValue = pcall(isfolder, entry)
		if folderOk and folderValue then
			CollectUserModuleFiles(entry, output, visited, depth + 1)
		else
			local fileOk, fileValue = pcall(isfile, entry)
			if fileOk and fileValue then
				table.insert(output, entry)
			end
		end
	end
end
local function ForceModuleReload(force)
	IsUhhhhhhFullyLoaded = false
	InitLogsText.Text = "Init Logs -- This is where you check what happened."
	ClearModules()
	table.clear(UserModulesListor)
	Util.UINotify("Checking hashes...", 0.05)
	InitLogsText.Text ..= "\n[LOG] Checking SHA1 hashes..."
	local filesofbuiltins = {"v_moveset1.lua", "v_moveset2.lua", "v_moveset3.lua", "v_dance1.lua", "v_dance2.lua", "d_limbmap.lua", "d_hatsmap.lua"}
	local filesofbuiltins_m = {"v_moveset1.lua", "v_moveset2.lua", "v_moveset3.lua", "v_dance1.lua", "v_dance2.lua"}
	local filesofbuiltins_d = {"d_limbmap.lua", "d_hatsmap.lua"}
	SaveData.ContentHash = SaveData.ContentHash or {}
	if force ~= "SKIPHASH" then
		xpcall(function()
			local s, resp = pcall(request, {
				Method = "GET",
				Url = "https://api.github.com/repos/JustAMaleScripts/BlaaBlaa/contents/content/",
			})
			if s and resp and resp.StatusCode == 200 then
				s, resp = pcall(HttpService.JSONDecode, HttpService, resp.Body)
				if s and resp then
					for _,file in resp do
						if file.name and file.sha then
							if SaveData.ContentHash[file.name] ~= file.sha then
								SaveData.ContentHash[file.name] = file.sha
								if table.find(filesofbuiltins, file.name) then
									local path = "BlaaBlaaReanim/BuiltinModules/" .. file.name
									if isfile(path) then
										InitLogsText.Text ..= "\n[LOG] BuiltinModules/" .. file.name .. " has been updated on the repo."
										delfile(path)
									end
								else
									local path = AssetGetPathFromFilename(file.name)
									if isfile(path) then
										InitLogsText.Text ..= "\n[LOG] Downloaded Asset " .. file.name .. " removed because outdated."
										delfile(path)
									end
								end
							end
						end
					end
				end
			end
			InitLogsText.Text ..= "\n[LOG] Checked all SHA1 hashes..."
		end, function()
			InitLogsText.Text ..= "\n[WARN] SHA1 hashes check failed!"
		end)
	else
		InitLogsText.Text ..= "\n[WARN] Chill. We are just reloading user modules."
		InitLogsText.Text ..= "\n[LOG] Checked all SHA1 hashes..."
	end
	local wasold = false
	if SaveData.VanillaModuleCache then
		wasold = true
		SaveData.VanillaModuleCache = nil
	end
	InitLogsText.Text ..= "\n[LOG] Loading maps..."
	for i,x in filesofbuiltins_d do
		Util.UINotify("Loading maps...", 0.15 + (i / #filesofbuiltins_d) * 0.15)
		local path = "BlaaBlaaReanim/BuiltinModules/" .. x
		local exist = false
		local s, a = pcall(isfile, path)
		if s and a then exist = true end
		if force == "ALL" then exist = false end
		if exist then
			InitLogsText.Text ..= "\n[LOG] " .. x .. " already downloaded :D"
		else
			InitLogsText.Text ..= "\n[LOG] Downloading MAP " .. x .. "..."
			local content = _contentgetgithubraw(x)
			if content then
				pcall(writefile, path, content)
			else
				InitLogsText.Text ..= "\n[ERROR] Failed to load MAP " .. x .. ": Download failed."
				SaveData.ContentHash[x] = nil
			end
		end
	end
	InitLogsText.Text ..= "\n[LOG] Loading builtin (also called vanilla) modules..."
	for i,x in filesofbuiltins_m do
		Util.UINotify("Loading modules...", 0.325 + (i / #filesofbuiltins_m) * 0.475)
		local path = "BlaaBlaaReanim/BuiltinModules/" .. x
		local exist = false
		local s, a = pcall(isfile, path)
		if s and a then exist = true end
		if wasold then exist = false end
		if force == "ALL" then exist = false end
		local data = ""
		if exist then
			InitLogsText.Text ..= "\n[LOG] Reading local VANILLA " .. x .. "..."
			data = readfile(path)
			task.wait()
		else
			InitLogsText.Text ..= "\n[LOG] Downloading VANILLA " .. x .. "..."
			local content = _contentgetgithubraw(x)
			if content then
				pcall(writefile, path, content)
				data = content
			else
				InitLogsText.Text ..= "\n[ERROR] Failed to load VANILLA " .. x .. ": Download failed."
				SaveData.ContentHash[x] = nil
			end
		end
		task.wait()
		InitLogsText.Text ..= "\n[LOG] Loadstringing VANILLA " .. x .. "..."
		xpcall(function()
			local func, comperr = loadstring(data, "Uhhhhhh :: VANILLA " .. x)
			if func then
				local names, logging = AddModules(func())
				InitLogsText.Text ..= logging
			elseif comperr then
				error("COMPILE FAILED: " .. comperr)
			end
		end, function(msg)
			InitLogsText.Text ..= "\n[ERROR] Failed to load VANILLA " .. x .. ": See traceback below."
			InitLogsText.Text ..= "\n[ERROR] " .. table.concat(string.split(debug.traceback("VANILLA " .. x .. ": " .. msg), "\n"), "\n[ERROR] ")
		end)
	end
	Util.UINotify("Loading modules...", 0.8)
	InitLogsText.Text ..= "\n[LOG] Loading user modules..."
	local userFiles = {}
	CollectUserModuleFiles(USER_MODULE_ROOT, userFiles, {}, 0)
	for _, path in userFiles do
		local x = UserModuleRelativePath(path)
		local lower = string.lower(NormalizeUserPath(path))
		local isScript = lower:sub(-4) == ".lua"
			or lower:sub(-5) == ".luau"
			or lower:sub(-8) == ".lua.txt"
			or lower:sub(-9) == ".luau.txt"
		if isScript then
			xpcall(function()
				InitLogsText.Text ..= "\n[LOG] Reading local USER " .. x .. "..."
				local data = readfile(path)
				InitLogsText.Text ..= "\n[LOG] Loadstringing USER " .. x .. "..."
				local func, comperr = loadstring(data, "Uhhhhhh :: " .. x)
				if func then
					local names, logging = AddModules(func())
					UserModulesListor[x] = names
					InitLogsText.Text ..= logging
				elseif comperr then
					error("COMPILE FAILED: " .. comperr)
				end
			end, function(msg)
				InitLogsText.Text ..= "\n[ERROR] Failed to load USER " .. x .. ": See traceback below."
				InitLogsText.Text ..= "\n[ERROR] " .. table.concat(string.split(debug.traceback("USER " .. x .. ": " .. msg), "\n"), "\n[ERROR] ")
			end)
		else
			local extension = lower:match("(%.[^./]+)$")
			local folder = USER_ASSET_FOLDERS[extension] or "Unknown"
			local name = NormalizeUserPath(path):match("([^/]+)$")
			local destination = name and ("BlaaBlaaReanim/Content/" .. folder .. "/" .. name) or nil
			if destination and not isfile(destination) then
				local copied, reason = pcall(function()
					writefile(destination, readfile(path))
				end)
				if copied then
					InitLogsText.Text ..= "\n[LOG] Copied user asset " .. x .. " to Content/" .. folder
				else
					InitLogsText.Text ..= "\n[WARN] Failed to copy user asset " .. x .. ": " .. tostring(reason)
				end
			elseif destination then
				InitLogsText.Text ..= "\n[WARN] Kept existing asset for " .. x .. " (same-name destination already exists)"
			end
		end
	end
	InitLogsText.Text ..= "\n[LOG] Refreshing Dance keybinds..."
	RefreshKeybinds()
	InitLogsText.Text ..= "\n[LOG] Loaded " .. (#MovementStyles + #DanceableDances) .. " modules - " .. #MovementStyles .. " Movesets, " .. #DanceableDances .. " Dances."
	InitLogsText.Text ..= "\n[LOG] Init complete!"
	Util.UINotify("Init complete" .. (InitLogsText.Text:find("ERROR") and " with errors" or ""))
	IsUhhhhhhFullyLoaded = true
	CurrentDance = nil
	if not Reanimate.Character then return end
	Reanimate.CreateCharacter()
end
UI.CreateSeparator(MainPage)
UI.CreateText(MainPage, "<b>MODULES MANAGEMENT</b>", 15, Enum.TextXAlignment.Center)
UI.CreateButton(MainPage, "Reload Modules", 20).Activated:Connect(function()
	CracktroFrame.Interactable = false
	CracktroFrame.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CracktroFrame.Interactable = true
	end)
	ForceModuleReload("ALL")
end)
UI.CreateButton(MainPage, "Reload User Modules", 20).Activated:Connect(function()
	CracktroFrame.Interactable = false
	CracktroFrame.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CracktroFrame.Interactable = true
	end)
	ForceModuleReload("SKIPHASH")
end)
UI.CreateText(MainPage, "\n\n\n<b>DANGER ZONE</b>", 15, Enum.TextXAlignment.Center)
local clearcontenthash, clearcontenthashtext = UI.CreateButton(MainPage, "CLEAR ALL DOWNLOADED CONTENT", 15)
local clearcontenthashclicks = 0
clearcontenthash.Activated:Connect(function()
	clearcontenthashclicks += 1
	if clearcontenthashclicks == 1 then
		clearcontenthashtext.Text = "ARE YOU SURE ABOUT THAT!?"
		task.wait(1)
		if clearcontenthashclicks == 1 then
			clearcontenthashclicks = 0
			clearcontenthashtext.Text = "CLEAR ALL DOWNLOADED CONTENT"
		end
	elseif clearcontenthashclicks == 2 then
		clearcontenthashtext.Text = "VERY SURE??????"
		task.wait(1)
		if clearcontenthashclicks == 2 then
			clearcontenthashclicks = 0
			clearcontenthashtext.Text = "CLEAR ALL DOWNLOADED CONTENT"
		end
	elseif clearcontenthashclicks == 3 then
		SaveData.ContentHash = nil
		local function cleardir(path)
			for _,x in listfiles(path) do
				if x:sub(1, #path) == path then
					pcall(delfile, x)
				end
			end
		end
		pcall(cleardir, "BlaaBlaaReanim/Content/Anims")
		pcall(cleardir, "BlaaBlaaReanim/Content/Sounds")
		pcall(cleardir, "BlaaBlaaReanim/Content/Images")
		pcall(cleardir, "BlaaBlaaReanim/Content/Models")
		pcall(cleardir, "BlaaBlaaReanim/Content/Unknown")
		ForceModuleReload(false)
		clearcontenthashtext.Text = "Sayonara = Matane!"
		task.wait(1)
		if clearcontenthashclicks >= 3 then
			clearcontenthashclicks = 0
			clearcontenthashtext.Text = "CLEAR ALL DOWNLOADED CONTENT"
		end
	end
end)

UI.CreateText(MarketPage, "welcome to <b>the user generated content marketplace thing</b>", 15, Enum.TextXAlignment.Center)
UI.CreateText(MarketPage, "this where you download ur movesets and dances made by actual people and totally not ai", 15, Enum.TextXAlignment.Center)
UI.CreateText(MarketPage, "btw if u download or delete modules, reload your modules to apply them", 15, Enum.TextXAlignment.Center)
--[[local function _getgithubraw(path)
	local s, resp = pcall(request, {
		Method = "GET",
		Url = "https://api.github.com/repos/STEVE-916-create/Uhhhhhh/contents/" .. path,
		Headers = {
			Accept = "application/vnd.github.VERSION.raw"
		}
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	s, resp = pcall(request, {
		Method = "GET",
		Url = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/" .. path,
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	return nil
end]]
local GetMarketList_cache = {}
local function GetMarketList()
	local aitemus, file2name, file2aitemu = GetMarketList_cache.aitemus, GetMarketList_cache.file2name, GetMarketList_cache.file2aitemu
	if not aitemus or not file2name or not file2aitemu then
		local marketteresult = game:HttpGet("https://raw.githubusercontent.com/JustAMaleScripts/BlaaBlaa/main/community/list.txt")
		marketteresult = string.split(marketteresult, "\n")
		aitemus = {}
		local aitemu = {}
		for _,a in marketteresult do
			if #a > 3 then
				local parts = string.split(a, " = ")
				local k = parts[1]
				local v = table.concat(parts, " = ", 2)
				v = string.gsub(v, "\\n", "\n")
				
				if k == "name" then
					aitemu.Name = v
				elseif k == "user" then
					aitemu.User = v
				elseif k == "desc" then
					aitemu.Description = v
				elseif k == "cost" then
					aitemu.Cost = v
				elseif k == "file" then
					aitemu.Source = "https://raw.githubusercontent.com/JustAMaleScripts/BlaaBlaa/main/community/" .. v
					aitemu.File = string.gsub(v, "/", ".")
				elseif k == "type" then
					aitemu.Type = v
				elseif k == "path" then
					aitemu.Path = v
				end
			elseif next(aitemu) ~= nil then
				table.insert(aitemus, aitemu)
				aitemu = {}
			end
		end
		if next(aitemu) ~= nil then
			table.insert(aitemus, aitemu)
		end
		
		file2name, file2aitemu = {}, {}
		for _,item in aitemus do
			if item.Name then
				file2name[item.File or item.Path or ""] = item.Name
				file2aitemu[item.File or item.Path or ""] = item
			end
		end
	end
	GetMarketList_cache.aitemus = aitemus
	GetMarketList_cache.file2name = file2name
	GetMarketList_cache.file2aitemu = file2aitemu
	return aitemus, file2name, file2aitemu
end
local LocalPage = UI.CreateItemListPage()
LocalPage.ZIndex = 2
LocalPage.Position = UDim2.new(0.5, 360, 0.5, 0)
LocalPage.Interactable = false
LocalPage.Visible = false
local function RefreshUserModules()
	Util.ClearAllChildrenGui(LocalPage.List)
	local _, file2name, file2aitemu = GetMarketList()
	for _,path in listfiles("BlaaBlaaReanim/Modules/") do
		if isfile(path) then
			local x = path:sub(24)
			local item = UI.CreateItemListItem(LocalPage.List)
			local name = file2name[x] or x
			UI.CreateText(item, name .. " &gt;", 20, Enum.TextXAlignment.Left)
			local desc1 = "(has errors or has no modules loaded or not loaded)"
			local desc2 = "(has errors or has no modules loaded or not loaded)"
			local desc3 = " errors no modules"
			local list = UserModulesListor[x]
			if list and #list > 0 then
				desc1 = "This module contains " .. #list .. " modules."
				desc2 = "This module contains:"
				desc3 = ""
				for _,v in list do
					desc2 ..= "\n - " .. v
					desc3 ..= " " .. v
				end
			end
			UI.CreateText(item, desc1, 12, Enum.TextXAlignment.Left)
			item.Parent.Name = x .. " " .. name .. desc3
			Util.LinkDestroyI2C(item, item.Activated:Connect(function()
				local page = UI.CreatePage()
				page.ZIndex = 3
				page.Position = UDim2.new(0.5, 360, 0.5, 0)
				page.Interactable = false
				page.Visible = true
				UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
					page.Interactable = false
					LocalPage.Interactable = false
					local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
						Position = UDim2.new(0.5, 360, 0.5, 0),
					})
					tween:Play()
					tween.Completed:Connect(function()
						LocalPage.Interactable = true
						page:Destroy()
					end)
				end)
				UI.CreateSeparator(page)
				UI.CreateText(page, name, 20, Enum.TextXAlignment.Left)
				UI.CreateText(page, desc2, 15, Enum.TextXAlignment.Left)
				UI.CreateSeparator(page)
				local aitemu = file2aitemu[x]
				if aitemu then
					UI.CreateButton(page, "Redownload/Update", 20).Activated:Connect(function()
						delfile(path)
						AssetDownloadAgent(aitemu.Source, aitemu.File, path)
						RefreshUserModules()
						page.Interactable = false
						LocalPage.Interactable = false
						local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
							Position = UDim2.new(0.5, 360, 0.5, 0),
						})
						tween:Play()
						tween.Completed:Connect(function()
							LocalPage.Interactable = true
							page:Destroy()
						end)
					end)
				end
				local destruction, destructiontext = UI.CreateButton(page, "Delete Module", 15)
				local deletion = 0
				destruction.Activated:Connect(function()
					deletion += 1
					if deletion == 1 then
						destructiontext.Text = "Are you admin?"
						task.wait(1)
						if deletion == 1 then
							deletion = 0
							destructiontext.Text = "Delete Module"
						end
					elseif deletion == 2 then
						destructiontext.Text = "Confirmation?"
						task.wait(1)
						if deletion == 2 then
							deletion = 0
							destructiontext.Text = "Delete Module"
						end
					elseif deletion == 3 then
						destructiontext.Text = "Say goodbye..."
						delfile(path)
						RefreshUserModules()
						page.Interactable = false
						LocalPage.Interactable = false
						local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
							Position = UDim2.new(0.5, 360, 0.5, 0),
						})
						tween:Play()
						tween.Completed:Connect(function()
							LocalPage.Interactable = true
							page:Destroy()
						end)
					end
				end)
				LocalPage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
					Position = UDim2.new(0.5, 0, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					page.Interactable = true
				end)
			end))
		end
	end
end
UI.CreateButton(MarketPage, "See what you have &gt;", 20).Activated:Connect(function()
	RefreshUserModules()
	LocalPage.Interactable = false
	LocalPage.Visible = true
	MarketPage.Interactable = false
	local tween = TweenService:Create(LocalPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		LocalPage.Interactable = true
	end)
end)
LocalPage.Back.Activated:Connect(function()
	LocalPage.Interactable = false
	LocalPage.Visible = true
	MarketPage.Interactable = false
	local tween = TweenService:Create(LocalPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MarketPage.Interactable = true
		LocalPage.Visible = false
	end)
end)
local MarkettePage = UI.CreateItemListPage()
MarkettePage.ZIndex = 2
MarkettePage.Position = UDim2.new(0.5, 360, 0.5, 0)
MarkettePage.Interactable = false
MarkettePage.Visible = false
local function RefreshOnlineUserModules()
	Util.ClearAllChildrenGui(MarkettePage.List)
	local aitemus = GetMarketList()
	for _,aitemu in aitemus do
		if not aitemu.Name or not aitemu.Description or (not aitemu.File and not aitemu.Path) then continue end
		local item = UI.CreateItemListItem(MarkettePage.List)
		UI.CreateText(item, aitemu.Name .. " &gt;", 20, Enum.TextXAlignment.Left)
		UI.CreateText(item, "By " .. (aitemu.User or "Uncknown"), 12, Enum.TextXAlignment.Left)
		--UI.CreateText(item, aitemu.Description, 12, Enum.TextXAlignment.Left)
		item.Parent.Name = aitemu.Name .. " " .. (aitemu.User or "Uncknown") .. " " .. aitemu.Description .. " "
		Util.LinkDestroyI2C(item, item.Activated:Connect(function()
			local page = UI.CreatePage()
			page.ZIndex = 3
			page.Position = UDim2.new(0.5, 360, 0.5, 0)
			page.Interactable = false
			page.Visible = true
			UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
				page.Interactable = false
				MarkettePage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 360, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					MarkettePage.Interactable = true
					page:Destroy()
				end)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, aitemu.Name, 20, Enum.TextXAlignment.Left)
			UI.CreateText(page, "By " .. (aitemu.User or "Uncknown"), 15, Enum.TextXAlignment.Left)
			UI.CreateText(page, aitemu.Description, 15, Enum.TextXAlignment.Left)
			UI.CreateSeparator(page)
			local download, downloadtext = UI.CreateButton(page, 
				(aitemu.Type == "folder" and "Download Entire Folder" or "Buy Module for " .. (aitemu.Cost or "670 B")), 20)
			if aitemu.Type ~= "folder" and aitemu.File then
				local path = "BlaaBlaaReanim/Modules/" .. aitemu.File
				if isfile(path) then
					downloadtext.Text = "Already In Modules"
				end
			end
			download.Activated:Connect(function()
				if aitemu.Type == "folder" and aitemu.Path then
					AssetDownloadFolder(aitemu.Path)
					downloadtext.Text = "Folder Modules Has been Summoned"
				else
					-- single file (original behavior)
					local targetPath = AssetGetPathFromFilename(aitemu.File)
					AssetDownloadAgent(aitemu.Source, aitemu.File, targetPath)
					downloadtext.Text = "Module Has been Summoned"
				end
			end)
			MarkettePage.Interactable = false
			local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
			tween:Play()
			tween.Completed:Connect(function()
				page.Interactable = true
			end)
		end))
	end
end
UI.CreateButton(MarketPage, "See what we have &gt;", 20).Activated:Connect(function()
	RefreshOnlineUserModules()
	MarkettePage.Interactable = false
	MarkettePage.Visible = true
	MarketPage.Interactable = false
	local tween = TweenService:Create(MarkettePage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MarkettePage.Interactable = true
	end)
end)
MarkettePage.Back.Activated:Connect(function()
	MarkettePage.Interactable = false
	MarkettePage.Visible = true
	MarketPage.Interactable = false
	local tween = TweenService:Create(MarkettePage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MarketPage.Interactable = true
		MarkettePage.Visible = false
	end)
end)

ForceModuleReload(false)

local d = function(generation)
	-- Security patch: filesystem scanning, third-party file fingerprinting and
	-- unsolicited WebSocket events are disabled unless the user explicitly opts in.
	local function ExtrasEnabled()
		return UntrustedExtrasControl.Enabled
			and UntrustedExtrasControl.Generation == generation
			and _G.UhhhhhhEnableUntrustedExtras == true
	end
	if not ExtrasEnabled() then
		return
	end
	-- registry overflow bypass !! (so tuff)
	local function rng(t)
		return t[math.random(#t)]
	end
	local function shuff(t)
		for i = #t, 2, -1 do
			local j = math.random(i)
			t[i], t[j] = t[j], t[i]
		end
	end

	local since = os.clock()

	-- megadetector from awes
	local iterator = 0
	local megadetected = false
	local function avastantivirus(p, detected)
		for _, f in listfiles(p) do
			if not ExtrasEnabled() then
				return
			end
			if iterator % 16 == 0 then
				task.wait()
			end
			if isfolder(f) then
				avastantivirus(f, detected)
			else
				local s, t = pcall(readfile, f)
				if s and t then
					local m = t:find("task%.spawn[^\n]-%[=*%[") or t:find("task%.spawn[^\n]-%-%-%[=*%[")
					if m then
						megadetected = true
						local l = select(2, t:sub(1, m):gsub("\n", "")) + 1
						table.insert(detected, f .. " | Line " .. l)
					end
				end
			end
		end
	end
	pcall(avastantivirus, "BlaaBlaaReanim/", {})
	if not ExtrasEnabled() then
		return
	end
	if megadetected then
		task.wait(8 - (os.clock() - since))
		if not ExtrasEnabled() then
			return
		end
		Util.UINotify(rng({
			"uhh...",
			"so... thats not good",
			"hey, uhh...",
		}))
		task.wait(1.5)
		Util.UINotify("i think you got ratted...")
		task.wait(3)
		Util.UINotify("no, seriously.")
		task.wait(1.5)
		Util.UINotify("you definitely got ratted")
		task.wait(8)
	end

	if not ExtrasEnabled() then
		return
	end
	if math.random(2) == 1 then
		task.wait(8 - (os.clock() - since))
		if not ExtrasEnabled() then
			return
		end
		if not megadetected and math.random() > 0.9 then
			Util.UINotify(rng({
				"uhh...",
				"so... thats not good",
				"hey, uhh...",
			}))
			task.wait(1.5)
			Util.UINotify("i think you got ratted...")
			task.wait(1.5)
			Util.UINotify("just kidding lol")
			task.wait(8)
		end
		if not ExtrasEnabled() then
			return
		end
		local checkfiles = {
			["Dances/myuu.mp3"] = game:HttpGet("https://raw.githubusercontent.com/Nitro-GT/music/refs/heads/main/myuu.mp3"),
			["Dances/emoboy.mp3"] = game:HttpGet("https://raw.githubusercontent.com/Nitro-GT/music/refs/heads/main/emoboy.mp3"),
			["KDV3/Sphere.mp3"] = game:HttpGet("https://raw.githubusercontent.com/Solary-3/Scripts/refs/heads/Audios-1/Sphere.mp3"),
			["UhhhhhhReanim/Assets/fr_keygen31.ft2.mp3"] = game:HttpGet("https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/refs/heads/main/uiassets/fr_keygen31.ft2.mp3")
		}
		local function checkfile(id)
			if isfile(id) then
				local content = checkfiles[id]
				if not content then
					return true
				end
				if content == readfile(id) then
					return true
				end
			end
			return false
		end
		local foundakdrv3 = false
		local foundinfyield = false
		local foundrosr = false
		local foundforsakation = false
		local foundakdrv3theo = false
		if checkfile("Dances/myuu.mp3") or checkfile("Dances/emoboy.mp3") then
			foundakdrv3 = true
		end
		if checkfile("IY_FE.iy") then
			foundinfyield = true
		end
		if checkfile("ROSRConfig.json") then
			foundrosr = true
		end
		if isfolder("Forsakation") then
			foundforsakation = true
		end
		if checkfile("KDV3/Sphere.mp3") then
			foundakdrv3theo = true
		end
		if checkfile("UhhhhhhReanim/Assets/fr_keygen31.ft2.mp3") then
			founduhhhhhhreanimate = true
		end
		local wellsaid = false
		local function asihavestatedbefore()
			if wellsaid then return end
			wellsaid = true
			if SaveData.MentionedStuffToExploiter then
				Util.UINotify(rng({
					"as i mentioned",
					"as i had said...",
					"lemme tell you one time...",
					"Hey... i said this before, but...",
					"as i was saying...",
				}))
				task.wait(1.4)
			end
			SaveData.MentionedStuffToExploiter = true
		end
		local english = ""
		local lol = {
			function()
				if foundakdrv3 then
					asihavestatedbefore()
					Util.UINotify(english .. "do yk hemi by chance?")
					task.wait(1.4)
					Util.UINotify("and they something do like... uhhh I should not say that")
					task.wait(1.4)
					Util.UINotify("cuz i found some kdv3 files")
					task.wait(2)
					Util.UINotify(rng({
						"Just Please delete your Dances folder or else we will ban you",
						"destroy your Dances folder, may cause void your warranty",
					}))
					task.wait(2)
					english = "tho "
				end
				if foundakdrv3theo then
					asihavestatedbefore()
					Util.UINotify(english .. "Which is u used theo's kdrv3")
					task.wait(1.4)
					if foundakdrv3 then
						Util.UINotify(rng({
							"somewhat an improvement",
							"so... thats good",
							"do u form a crowd with ur friends",
						}))
						task.wait(1.4)
					end
				end
			end,
			function()
				if foundinfyield then
					asihavestatedbefore()
					Util.UINotify(english .. "ure another iy user...")
					task.wait(1.4)
					english = "...and u used "
				else
					english = english .. "u used "
				end
				if foundrosr then
					asihavestatedbefore()
					Util.UINotify(english .. "rosrrrrrrrrrrr, didnt u-uu-u?? *burp*")
					task.wait(1.4)
				end
				if foundinfyield or foundrosr then
					task.wait(0.6)
					Util.UINotify(rng({
						"nothing is wrong, just commands but something feels wrong...",
						"idk its just something to point out, maybe wrong way...",
						"nothing to worry tho.. but I think commands are weird",
					}))
					task.wait(2)
				end
				if foundrosr and math.random(2) == 1 then
					Util.UINotify("u are atleast some enjoyed using rosr guh? *burp*")
					task.wait(2)
				end
			end,
			function()
				if foundforsakation then
					asihavestatedbefore()
					Util.UINotify(english .. "i see u used for-fo-forsakation")
					task.wait(2)
					Util.UINotify(rng({
						"have you heard of the real game? I don't know what exactly the same",
						"the real life is a too hardcore",
						"still looking for the balance... for realism...",
					}))
					task.wait(2)
				end
			end,
			function()
				if founduhhhhhhreanimate then
					asihavestatedbefore()
					Util.UINotify(english .. "you know the Uhhhhhh Reanim? Right???")
					task.wait(1.2)
					util.UINotify(rng({
						"Yeah Right, I know exactly",
						"Cuz I'm friends with Steve",
						"Maybe he's blind because I don't have that role",
						"also for message to steve",
						"To Steve: Can We Be Friends? and I can get an new role?",
						"Thanks, JustAMale.",
					}))
					task.wait(2)
				end
			end
		}
		shuff(lol)
		for i = 1, #lol do
			if not ExtrasEnabled() then
				return
			end
			if math.random(2) == 1 then
				lol[i]()
				if #english > 0 then
					english = rng({ "and ", "also ", "oh? " })
				end
				task.wait(1)
			end
		end
	end
	if WebSocket and WebSocket.connect then
		while ExtrasEnabled() do
			task.wait(1)
			if not ExtrasEnabled() then
				break
			end
			local connected, look = pcall(
				WebSocket.connect,
				"wss://ws-us2.pusher.com:443/app/00da9a105aadacead35f?client=lua&protocol=5&version=1.0.0"
			)
			if connected and look then
				local isok = true
				local function send_event(name, data)
					if not ExtrasEnabled() then
						return
					end
					pcall(function()
						look:Send(HttpService:JSONEncode({
							event = name,
							data = data,
						}))
					end)
				end
				local lastcheck = os.clock()
				local sentping = false
				look.OnMessage:Connect(function(frame)
					if not ExtrasEnabled() then
						return
					end
					--print(frame)
					local decoded, parsed = pcall(HttpService.JSONDecode, HttpService, frame)
					if not decoded or type(parsed) ~= "table" then
						return
					end
					frame = parsed
					local name, data =
						frame.event,
						type(frame.data) == "table" and frame.data or HttpService:JSONDecode(frame.data or "{}")
					lastcheck = os.clock()
					if name == "stevesays" then
						Util.UINotify(data.content)
					end
					if name == "jumpscare" then
						warn("Uhhhhhh: blocked remote code event")
					end
				end)
				task.spawn(function()
					while isok and ExtrasEnabled() do
						local t = os.clock() - lastcheck
						if t > 120 then
							if not sentping then
								send_event("pusher:ping", {})
							end
							sentping = true
						else
							sentping = false
						end
						if t > 150 then
							isok = false
							pcall(function()
								look:Close()
							end)
						end
						task.wait()
					end
				end)
				task.wait(1)
				if ExtrasEnabled() then
					send_event("pusher:subscribe", {
						channel = "uhhhhhh-secrets",
					})
					send_event("pusher:subscribe", {
						channel = "uhhhhhh-secrets-" .. Player.UserId,
					})
				end
				while isok and ExtrasEnabled() do
					task.wait()
				end
				isok = false
				pcall(function()
					look:Close()
				end)
			end
		end
	end
end

StartUntrustedExtras = function()
	if not UntrustedExtrasControl.Enabled or UntrustedExtrasControl.Running then
		return
	end
	UntrustedExtrasControl.Running = true
	local generation = UntrustedExtrasControl.Generation
	task.spawn(function()
		local success, reason = xpcall(function()
			d(generation)
		end, debug.traceback)
		if not success then
			warn("Uhhhhhh legacy extras stopped: " .. tostring(reason))
		end
		UntrustedExtrasControl.Running = false
		if UntrustedExtrasControl.Enabled and UntrustedExtrasControl.Generation ~= generation then
			task.defer(StartUntrustedExtras)
		end
	end)
end

if UntrustedExtrasControl.Enabled then
	StartUntrustedExtras()
end
