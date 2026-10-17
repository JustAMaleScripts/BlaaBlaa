local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActions = game:GetService("ContextActionService")

local modules = {}

table.insert(modules, function()
    local m = {}
    m.ModuleType = "MOVESET"
    m.Name = "Determination"
    m.InternalName = "Determination"
    m.Description = "Driving in my car..."
    m.Assets = {"Deter.mp3", "mination.mp3"}
    m.Config = function(parent) 
		Util_CreateButton(parent,"destroy residue",20,Enum.TextXAlignment.Left).Activated:Connect(function()
			for _, v in workspace:GetDescendants() do
				if v.Name == "baseplatefire" then
					v:Destroy()
				end
			end
			for _, v in game.Lighting:GetDescendants() do
				if v.Name == "atomsphere" then
					v:Destroy()
				end
			end
		end)
	end

    local moduleAlive = false
    local Character
    local assetObject
    local assetScript
    local updateConnections = {}
    local actionBindings = {}
    local flingDebounce = setmetatable({}, {__mode = "k"})
    local sound1, sound2

    local function GetAsset(name)
        for _, assetName in ipairs(m.Assets) do
            if assetName == name then
                local ok, asset = pcall(getcustomasset, "UhhhhhhReanim/Content/Sounds/" .. assetName)
                if ok then return asset end
                return ""
            end
        end
        return ""
    end

    local function ReanimateFlingTarget(target)
        if not target or target == Character or not target:IsA("Model") then
            return false
        end
        if type(ReanimateFling) == "function" then
            local ok, result = pcall(ReanimateFling, target)
            return ok and result ~= false
        end
        return false
    end

    m.Init = function(figure)
        if moduleAlive then return end
        if not figure or not figure:IsA("Model") then return end
        local humanoid = figure:FindFirstChildOfClass("Humanoid")
        local root = figure:FindFirstChild("HumanoidRootPart")
        local torso = figure:FindFirstChild("Torso")
        local head = figure:FindFirstChild("Head")
        if not humanoid or not root or not torso or not head then return end

        moduleAlive = true
        Character = figure

        local Object = game:GetObjects("rbxassetid://7409193749")[1]
        if not Object then
            moduleAlive = false
            Character = nil
            return
        end
        assetObject = Object
        Object.Parent = workspace
        assetScript = Object:FindFirstChild("Determination") or Object
        local script = assetScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = Character
local humanoid = Character:WaitForChild("Humanoid")

sound1 = Instance.new("Sound")
sound1.SoundId = GetAsset("Deter.mp3")
sound1.Volume = 1
sound1.Looped = false
sound1.Parent = workspace

sound2 = Instance.new("Sound")
sound2.SoundId = GetAsset("mination.mp3")
sound2.Volume = 1
sound2.Looped = true
sound2.Parent = workspace

local function playLoop()
	task.spawn(function()
		while humanoid and humanoid.Health > 0 do
			if not sound1.IsLoaded then
				sound1.Loaded:Wait()
			end
			sound1:Play()
			sound1.Ended:Wait()
			if humanoid.Health <= 0 then break end

			if not sound2.IsLoaded then
				sound2.Loaded:Wait() 
			end
			sound2:Play()
			sound2.Ended:Wait()
			if humanoid.Health <= 0 then break end
		end
	end)
end

playLoop()

humanoid.Died:Connect(function()
	sound1:Stop()
	sound2:Stop()
	sound1:Destroy()
	sound2:Destroy()
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = Character
local head = Character:WaitForChild("Head")

local face = head:FindFirstChildOfClass("Decal") or Instance.new("Decal", head)
face.Name = "face"
face.Texture = "http://www.roblox.com/asset/?id=18511766876"

task.spawn(function()
    task.wait(51)
    face.Texture = "http://www.roblox.com/asset/?id=82659004179764"
end)

local ts = game:GetService("TweenService")

plr = game.Players.LocalPlayer
char = Character
game:GetService("RunService").Heartbeat:Wait()
local uis = game:GetService("UserInputService")
local sine = 0
local swingspeed = .4
local change = 1
local rotvalue = 50
local ts = game:GetService("TweenService")
local ins = Instance.new
local rootpart = char:WaitForChild("HumanoidRootPart")
local cf = CFrame.new
local angles = CFrame.Angles
local cos = math.cos
local rad = math.rad
local sin = math.sin
local sub = string.sub
local asin = math.asin
local findstring = string.find
local v3 = Vector3.new
local c3 = Color3.fromRGB
local torso = char:FindFirstChild("Torso")
local hum = char:FindFirstChildOfClass("Humanoid")
local rootjoint = rootpart['RootJoint']
local neck = torso["Neck"]
local LW=torso["Left Shoulder"] 
local LH=torso["Left Hip"] 
local RW=torso["Right Shoulder"] 
local RH=torso["Right Hip"] 
local rarm = char["Right Arm"]
local larm = char["Left Arm"]
local lleg = char["Left Leg"]
local rleg = char["Right Leg"]
local speed = .8
local mousepos = nil 
local attacking = false
local nilmousepos = false
local forWFB = 0
local forWRL = 0
local swingnum = 1
local volume = 7
local walkspeedval = 20
local holding = false
local EFFECTCOLOR = c3(255,0,0)
local baseplateparticles = false
local random = math.random
local ahb = true
local running = false
local lookvector = v3(0,0,0)
local Anim = "Idle"
local creffclone = script:WaitForChild("crefunnies"):Clone()
creffclone.Parent = plr:WaitForChild("PlayerGui")
script.crefunnies:Destroy()
local textbb = script:WaitForChild("textgui"):Clone()
local inputscript = script:WaitForChild("input"):Clone()
inputscript.Parent = plr:WaitForChild("Backpack")
inputscript.Disabled = false
local inputremote = Instance.new("BindableEvent",plr.Backpack)
inputremote.Name = "realremote"
local weapon = script:WaitForChild("weapon")
weapon.Parent = rarm
local weaponhandle = weapon.Part
local trident = weapon.trident
local lightingeffects = false
local flashgui = script.flash:Clone()
local camshakescript = script:WaitForChild("camshake"):Clone()
local tridentsize = trident.Size
local firehand = script:WaitForChild("hand")
local firemesh = script.fire:Clone()
local ellipses = script:WaitForChild("ellipses"):Clone()
local balleffect = script.ball:Clone()
local fireball = script:WaitForChild("fireball"):Clone()
local textgui = script:WaitForChild("guipopup"):Clone()

local glint = Instance.new("Sound") 
glint.EmitterSize = 10 
glint.Looped = false 
glint.MaxDistance = 10000 
glint.Name = "glint" 
glint.PlaybackSpeed = 1 
glint.Playing = false 
glint.RollOffMode = Enum.RollOffMode.Inverse 
glint.SoundId = "rbxassetid://5651577252" 
glint.TimePosition = 0 
glint.Volume = 5
glint.Archivable = true 
glint.PlayOnRemove = false 

local energystrike = Instance.new("Sound") 
energystrike.EmitterSize = 10 
energystrike.Looped = false 
energystrike.MaxDistance = 10000 
energystrike.Name = "energystrike" 
energystrike.PlaybackSpeed = 1 
energystrike.Playing = false 
energystrike.RollOffMode = Enum.RollOffMode.Inverse 
energystrike.SoundId = "rbxassetid://782353443" 
energystrike.TimePosition = 0 
energystrike.Volume = 10 
energystrike.Archivable = true 
energystrike.PlayOnRemove = false 

local swoosh = Instance.new("Sound") 
swoosh.EmitterSize = 10 
swoosh.Looped = false 
swoosh.MaxDistance = 10000 
swoosh.Name = "swoosh" 
swoosh.PlaybackSpeed = 1 
swoosh.Playing = false 
swoosh.RollOffMode = Enum.RollOffMode.Inverse 
swoosh.SoundId = "rbxassetid://3015952873" 
swoosh.TimePosition = 0 
swoosh.Volume = 5
swoosh.Archivable = true 
swoosh.PlayOnRemove = false 

local eyeglow = Instance.new("ParticleEmitter") 
eyeglow.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.new(0,0.73333334922791,1)), 
	ColorSequenceKeypoint.new(1,Color3.new(0.24313725531101,0.92549020051956,1)), 
}) 
eyeglow.LightEmission = 0 
eyeglow.LightInfluence = 1 
eyeglow.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0), 
	NumberSequenceKeypoint.new(0.19977037608624,2.5624995231628), 
	NumberSequenceKeypoint.new(0.49942594766617,0), 
	NumberSequenceKeypoint.new(1,0), 
}) 
eyeglow.Texture = "rbxassetid://2273224484" 
eyeglow.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0), 
	NumberSequenceKeypoint.new(1,0), 
}) 
eyeglow.ZOffset = 0 
eyeglow.Name = "eyeglow" 
eyeglow.Archivable = true 
eyeglow.Acceleration = Vector3.new(0, 0, 0) 
eyeglow.Drag = 0 
eyeglow.LockedToPart = false 
eyeglow.VelocityInheritance = 0 
eyeglow.EmissionDirection = Enum.NormalId.Top 
eyeglow.Enabled = false 
eyeglow.Lifetime = NumberRange.new(0.5, 0.5) 
eyeglow.Rate = 4 
eyeglow.Rotation = NumberRange.new(0, 0) 
eyeglow.RotSpeed = NumberRange.new(0, 0) 
eyeglow.Speed = NumberRange.new(0, 0) 
eyeglow.SpreadAngle = Vector2.new(0, 0) 

local baseplatefire = Instance.new("ParticleEmitter") 
baseplatefire.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.new(1,0,0.015686275437474)), 
	ColorSequenceKeypoint.new(1,Color3.new(1,0,0.015686275437474)), 
}) 
baseplatefire.LightEmission = 0 
baseplatefire.LightInfluence = 1 
baseplatefire.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0), 
	NumberSequenceKeypoint.new(1,0.18750011920929), 
}) 
baseplatefire.Texture = "rbxassetid://286708119" 
baseplatefire.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0.30624997615814), 
	NumberSequenceKeypoint.new(0.59600001573563,0.36300000548363), 
	NumberSequenceKeypoint.new(1,1), 
}) 
baseplatefire.ZOffset = 0 
baseplatefire.Name = "baseplatefire" 
baseplatefire.Archivable = true 
baseplatefire.Acceleration = Vector3.new(0, 0, 0) 
baseplatefire.Drag = 0 
baseplatefire.LockedToPart = false 
baseplatefire.VelocityInheritance = 0 
baseplatefire.EmissionDirection = Enum.NormalId.Top 
baseplatefire.Enabled = true 
baseplatefire.Lifetime = NumberRange.new(2, 4) 
baseplatefire.Rate = 4000 
baseplatefire.Rotation = NumberRange.new(0, 0) 
baseplatefire.RotSpeed = NumberRange.new(0, 0) 
baseplatefire.Speed = NumberRange.new(1.5, 1.5) 
baseplatefire.SpreadAngle = Vector2.new(0, 0) 

local killdust = Instance.new("ParticleEmitter") 
killdust.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.new(1,1,1)), 
	ColorSequenceKeypoint.new(0,Color3.new(0.90196079015732,0.90196079015732,0)), 
	ColorSequenceKeypoint.new(0,Color3.new(0.89616650342941,0.90326583385468,0.0024012266658247)), 
	ColorSequenceKeypoint.new(0,Color3.new(0.87258332967758,0.90857738256454,0.012174438685179)), 
	ColorSequenceKeypoint.new(9.9999997473788e-06,Color3.new(1,1,1)), 
	ColorSequenceKeypoint.new(1,Color3.new(1,1,1)), 
}) 
killdust.LightEmission = 0 
killdust.LightInfluence = 0 
killdust.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0.43749988079071), 
	NumberSequenceKeypoint.new(1,4.6875), 
}) 
killdust.Texture = "rbxassetid://5662390939" 
killdust.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0,1), 
	NumberSequenceKeypoint.new(0.1182548776269,0.60624998807907), 
	NumberSequenceKeypoint.new(0.40163931250572,0.59200000762939), 
	NumberSequenceKeypoint.new(0.82319170236588,0.41874998807907), 
	NumberSequenceKeypoint.new(1,1), 
}) 
killdust.ZOffset = 0 
killdust.Name = "killdust" 
killdust.Archivable = true 
killdust.Acceleration = Vector3.new(0, 0, 0) 
killdust.Drag = 0 
killdust.LockedToPart = false 
killdust.VelocityInheritance = 0 
killdust.EmissionDirection = Enum.NormalId.Top 
killdust.Enabled = false 
killdust.Lifetime = NumberRange.new(2, 2) 
killdust.Rate = 10 
killdust.Rotation = NumberRange.new(0, 360) 
killdust.RotSpeed = NumberRange.new(22.5, 22.5) 
killdust.Speed = NumberRange.new(0, 0) 
killdust.SpreadAngle = Vector2.new(0, 0) 

local specialp1 = Instance.new("ParticleEmitter") 
specialp1.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.new(1,0,0)), 
	ColorSequenceKeypoint.new(1,Color3.new(1,0,0)), 
}) 
specialp1.LightEmission = 0.40000000596046 
specialp1.LightInfluence = 0 
specialp1.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0), 
	NumberSequenceKeypoint.new(0.13732928037643,0.54644823074341), 
	NumberSequenceKeypoint.new(0.23444612324238,0.2732241153717), 
	NumberSequenceKeypoint.new(0.35887709259987,0.87431728839874), 
	NumberSequenceKeypoint.new(0.51745069026947,0.32786905765533), 
	NumberSequenceKeypoint.new(0.6562973856926,1.2021857500076), 
	NumberSequenceKeypoint.new(0.80728375911713,0.21857976913452), 
	NumberSequenceKeypoint.new(0.90364187955856,0.7103830575943), 
	NumberSequenceKeypoint.new(1,0), 
}) 
specialp1.Texture = "rbxassetid://669133414" 
specialp1.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0.60000002384186), 
	NumberSequenceKeypoint.new(1,0.60000002384186), 
}) 
specialp1.ZOffset = 1 
specialp1.Name = "specialp1" 
specialp1.Archivable = true 
specialp1.Acceleration = Vector3.new(0, 0, 0) 
specialp1.Drag = 0 
specialp1.LockedToPart = true 
specialp1.VelocityInheritance = 0 
specialp1.EmissionDirection = Enum.NormalId.Top 
specialp1.Enabled = true 
specialp1.Lifetime = NumberRange.new(0.40000000596046, 0.40000000596046) 
specialp1.Rate = 200 
specialp1.Rotation = NumberRange.new(-180, 180) 
specialp1.RotSpeed = NumberRange.new(30, 30) 
specialp1.Speed = NumberRange.new(15, 15) 
specialp1.SpreadAngle = Vector2.new(50, 50) 

local specialp2 = Instance.new("ParticleEmitter") 
specialp2.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.new(1,0,0)), 
	ColorSequenceKeypoint.new(1,Color3.new(1,0,0)), 
}) 
specialp2.LightEmission = 0 
specialp2.LightInfluence = 0 
specialp2.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0,3.75), 
	NumberSequenceKeypoint.new(1,8.25), 
}) 
specialp2.Texture = "rbxassetid://938683413" 
specialp2.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0.89999997615814), 
	NumberSequenceKeypoint.new(1,0.89999997615814), 
}) 
specialp2.ZOffset = 1 
specialp2.Name = "specialp2" 
specialp2.Archivable = true 
specialp2.Acceleration = Vector3.new(0, 0, 0) 
specialp2.Drag = 0 
specialp2.LockedToPart = true 
specialp2.VelocityInheritance = 0 
specialp2.EmissionDirection = Enum.NormalId.Top 
specialp2.Enabled = true 
specialp2.Lifetime = NumberRange.new(0.20000000298023, 0.20000000298023) 
specialp2.Rate = 100 
specialp2.Rotation = NumberRange.new(-180, 180) 
specialp2.RotSpeed = NumberRange.new(0, 0) 
specialp2.Speed = NumberRange.new(10, 10) 
specialp2.SpreadAngle = Vector2.new(5, 5) 

local killsound = Instance.new("Sound") 
killsound.EmitterSize = 10 
killsound.Looped = false 
killsound.MaxDistance = 10000 
killsound.Name = "killsound" 
killsound.PlaybackSpeed = 1 
killsound.Playing = false 
killsound.RollOffMode = Enum.RollOffMode.Inverse 
killsound.SoundId = "rbxassetid://427025525" 
killsound.TimePosition = 0 
killsound.Volume = 5
killsound.Archivable = true 
killsound.PlayOnRemove = false 

local earthquake1 = Instance.new("Sound") 
earthquake1.EmitterSize = 10 
earthquake1.Looped = false 
earthquake1.MaxDistance = 10000 
earthquake1.Name = "earthquake1" 
earthquake1.PlaybackSpeed = 1 
earthquake1.Playing = false 
earthquake1.RollOffMode = Enum.RollOffMode.Inverse 
earthquake1.SoundId = "rbxassetid://4870579875" 
earthquake1.TimePosition = 4
earthquake1.Volume = 10 
earthquake1.Archivable = true 
earthquake1.PlayOnRemove = false 

local e1distort = Instance.new("DistortionSoundEffect",earthquake1)
e1distort.Level = .7

local summoning = Instance.new("Sound") 
summoning.EmitterSize = 10 
summoning.Looped = false 
summoning.MaxDistance = 10000 
summoning.Name = "summoning" 
summoning.PlaybackSpeed = 1 
summoning.Playing = false 
summoning.RollOffMode = Enum.RollOffMode.Inverse 
summoning.SoundId = "rbxassetid://2836888600" 
summoning.TimePosition = 0 
summoning.Volume = 10 
summoning.Archivable = true 
summoning.PlayOnRemove = false 

local grabsound = Instance.new("Sound") 
grabsound.EmitterSize = 10 
grabsound.Looped = false 
grabsound.MaxDistance = 10000 
grabsound.Name = "grabsound" 
grabsound.PlaybackSpeed = 1 
grabsound.Playing = false 
grabsound.RollOffMode = Enum.RollOffMode.Inverse 
grabsound.SoundId = "rbxassetid://5661425432" 
grabsound.TimePosition = 0 
grabsound.Volume = 10 
grabsound.Archivable = true 
grabsound.PlayOnRemove = false 

local bigtrident = script.bigtrident:Clone()
script.bigtrident:Destroy()

local atmosphere = Instance.new("ColorCorrectionEffect") 
atmosphere.Name = "atmosphere" 
atmosphere.Brightness = 0 
atmosphere.Contrast = 0 
atmosphere.Enabled = true 
atmosphere.Saturation = 0 
atmosphere.TintColor = Color3.new(1,1,1) 
atmosphere.Archivable = true 

local earthparticle = Instance.new("ParticleEmitter") 
earthparticle.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.new(0.42352941632271,0.34509804844856,0.29411765933037)), 
	ColorSequenceKeypoint.new(1,Color3.new(0.42352941632271,0.34509804844856,0.29411765933037)), 
}) 
earthparticle.LightEmission = 0 
earthparticle.LightInfluence = 0 
earthparticle.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0,5), 
	NumberSequenceKeypoint.new(1,0), 
}) 
earthparticle.Texture = "rbxassetid://281633012" 
earthparticle.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0,1), 
	NumberSequenceKeypoint.new(0.036880925297737,0.75409835577011), 
	NumberSequenceKeypoint.new(0.067439407110214,0), 
	NumberSequenceKeypoint.new(1,0), 
}) 
earthparticle.ZOffset = 0 
earthparticle.Name = "earthparticle" 
earthparticle.Archivable = true 
earthparticle.Acceleration = Vector3.new(0, -15, 0) 
earthparticle.Drag = 0 
earthparticle.LockedToPart = false 
earthparticle.VelocityInheritance = 0 
earthparticle.EmissionDirection = Enum.NormalId.Top 
earthparticle.Enabled = true 
earthparticle.Lifetime = NumberRange.new(1, 4) 
earthparticle.Rate = 20 
earthparticle.Rotation = NumberRange.new(0, 360) 
earthparticle.RotSpeed = NumberRange.new(-25, 25) 
earthparticle.Speed = NumberRange.new(0, 35) 
earthparticle.SpreadAngle = Vector2.new(360, 360) 

hum.WalkSpeed = 20
hum.MaxHealth = math.huge
hum.Health = math.huge

pcall(function()
	hum.Animator:Destroy()
	char.Animate:Destroy()
end)


Frame_Speed = 1 / 60
ArtificialHB = Instance.new("BindableEvent", script)
ArtificialHB.Name = "ArtificialHB"

script:WaitForChild("ArtificialHB")

frame = Frame_Speed
tf = 0
allowframeloss = false
tossremainder = false
lastframe = tick()
local arthb = script.ArtificialHB
arthb:Fire()

game:GetService("RunService").Heartbeat:connect(function(s, p)
	if ahb == true then
		tf = tf + s
		if tf >= frame then
			if allowframeloss then
				arthb:Fire()
				lastframe = tick()
			else
				for i = 1, math.floor(tf / frame) do
					arthb:Fire()
				end
				lastframe = tick()
			end
			if tossremainder then
				tf = 0
			else
				tf = tf - frame * math.floor(tf / frame)
			end
		end
	end
end)

function Swait(NUMBER)
	if NUMBER == 0 or NUMBER == nil then
		ArtificialHB.Event:wait()
	else
		for i = 1, NUMBER do
			ArtificialHB.Event:wait()
		end
	end
end

for i,v in pairs({plr}) do
	local the = creffclone:Clone()
	the.plr.Value = plr.Name
	the.Parent = v.PlayerGui
	the.Disabled = false
end


game:GetService("RunService").Heartbeat:wait()


function tweeninfo(tweentime,easestyle,easingdirection)
	return TweenInfo.new(tweentime,Enum.EasingStyle[easestyle],Enum.EasingDirection[easingdirection])
end

function makesound(propertytable)
	local sound = Instance.new("Sound",propertytable[1])
	sound.SoundId = "rbxassetid://" .. propertytable[2]
	sound.Volume = propertytable[3]
	sound.Playing = propertytable[4]
	sound.Looped = propertytable[5]
	sound.Name = propertytable[6]
	sound.EmitterSize = propertytable[7]
	return sound
end

local headimages = {
	[183198803]="rbxassetid://5647872580",
	[88434103]="rbxassetid://5648901354",
}

for i,v in pairs(headimages) do
	if plr.UserId == i then
		textbb.main.head.Image = v
	else
		textbb.main.head.Image = "rbxassetid://5651006219"
	end
end




local theme = makesound({rootpart,2728315619,7,true,true,"The last soul",10})
local origid = 2728315619



function weld(proptable)
	local weld = ins("Weld",proptable[1])
	weld.Part0 = proptable[2]
	weld.Part1 = proptable[3]
	weld.C0 = proptable[4]
	weld.Name = proptable[5]
	return weld
end

local RJW=weld({rootjoint.Parent,rootjoint.Part0,rootjoint.Part1,rootjoint.C0,"RJW"})
RJW.C1 = rootjoint.C1
RJW.Name = rootjoint.Name
local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14) 
local NeckW=weld({neck.Parent,neck.Part0,neck.Part1,neck.C0,"NeckW"})
NeckW.C1 = neck.C1
NeckW.Name = neck.Name

RW,LW = Instance.new("Weld"),Instance.new("Weld")

RW.Name="Right Shoulder"
RW.Part0=char.Torso 
RW.C0=cf(.5, 0, 0)
RW.C1=cf(0, .5, 0) 
RW.Part1=char["Right Arm"] 
RW.Parent=char.Torso 

LW.Name="Left Shoulder"
LW.Part0=char.Torso 
LW.C0=cf(-.5, 0, 0)
LW.C1=cf(0, 0.5, 0) 
LW.Part1=char["Left Arm"] 
LW.Parent=char.Torso

local NeckCF = cf(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)

local RW=weld({torso,torso,rarm,cf(0,0,0),"RW"})

local LW=weld({torso,torso,larm,cf(0,0,0),"LW"})

local RH=weld({torso,torso,rleg,cf(0,0,0),"RH"})

local LH=weld({torso,torso,lleg,cf(0,0,0),"LH"})

RW.C1 = cf(0, 0.5, 0)
LW.C1 = cf(0, 0.5, 0)
RH.C1 = cf(0, 1, 0) *angles(rad(0),rad(0),rad(0))
LH.C1 = cf(0, 1, 0) *angles(rad(0),rad(0),rad(0))

local tridentweld = weld({weaponhandle,weaponhandle,rarm,cf(0,0,0)*angles(0,0,0),"trident weld"})
local tridentc0 = tridentweld.C0



local headshadingfolder = Instance.new("Folder",char.Head)


function chatmessage(message)
    
    for _, v in pairs(char.Head:GetChildren()) do
        if v.ClassName == "BillboardGui" then
            v:Destroy()
        end
    end

    
    local bb = textbb:Clone()
    bb.Parent = char:WaitForChild("Head")
    bb.run.text.Value = "* " .. message 
    bb.run.Disabled = false

    
    local fr = bb.main
    local img = fr.head
    local tl = fr.text

    
    tl.Text = ""
    tl.TextTransparency = 0
    tl.TextColor3 = Color3.new(1, 1, 1) 
    tl.TextSize = 18 

    
    function tweeninfo(tweentime, easestyle, easingdirection)
        return TweenInfo.new(tweentime, Enum.EasingStyle[easestyle], Enum.EasingDirection[easingdirection])
    end

    
    ts:Create(fr, tweeninfo(2, "Sine", "InOut"), {Position = UDim2.new(0.01, 0, 0.02, 0)}):Play()
    wait(1.7)

    
    coroutine.wrap(function()
        while bb.Parent ~= nil do
            ts:Create(fr, tweeninfo(1, "Sine", "InOut"), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            ts:Create(fr, tweeninfo(1, "Sine", "InOut"), {BorderColor3 = Color3.fromRGB(225, 225, 225)}):Play()
            wait(1)
            ts:Create(fr, tweeninfo(1, "Sine", "InOut"), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            ts:Create(fr, tweeninfo(1, "Sine", "InOut"), {BorderColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            wait(1)
        end

    end)()

    
    ts:Create(img, tweeninfo(1, "Quad", "In"), {ImageTransparency = 0}):Play()
    wait(0.7)

    
    local msg = bb.run:WaitForChild("text").Value

    for i = 1, #msg do
        game:GetService("RunService").Stepped:Wait()
        tl.Text = msg:sub(1, i)

    end

    
    wait(3 + (#msg / 15))

    
    ts:Create(fr, tweeninfo(3, "Sine", "InOut"), {BackgroundTransparency = 1}):Play()
    ts:Create(tl, tweeninfo(3, "Sine", "InOut"), {TextTransparency = 1}):Play()
    ts:Create(img, tweeninfo(3, "Sine", "InOut"), {ImageTransparency = 1}):Play()
    wait(3)
    bb:Destroy()
end

function SetTween(SPart,CFr,MoveStyle2,outorin2,AnimTime)
	local MoveStyle = Enum.EasingStyle[MoveStyle2]
	local outorin = Enum.EasingDirection[outorin2]
	local dahspeed=1
	
	local tweeningInformation = TweenInfo.new(
		AnimTime/dahspeed,	
		MoveStyle,
		outorin,
		0,
		false,
		0
	)
	
	local MoveCF = CFr
	local tweenanim = ts:Create(SPart,tweeningInformation,MoveCF)
	
	tweenanim:Play()
end

function rayCast(Pos, Dir, Max, Ignore)  
	return game:service("Workspace"):FindPartOnRay(Ray.new(Pos, Dir.unit * (Max or 999.999)), Ignore) 
end 

function makecustomtween(thing,easingstyle,tweentime,info)
	local the = coroutine.wrap(function()
		ts:Create(thing,tweeninfo(tweentime,easingstyle,"InOut"),info):Play()
		wait(tweentime)
		thing:Destroy()
	end)
	return the()
end

function effect(...)
	local a = {...}
	local pa = a[1]
	pa.Size = a[2]
	pa.CFrame = a[3]
	pa.Color = a[4]
	pa.Material = a[5]
	pa.Transparency = a[6]
	pa.Parent = a[7]
	pa.Anchored = a[8]
	pa.CanCollide = a[9]
	pa.Name = "effectpart"
	if a[10] ~= nil then
		makecustomtween(pa,a[10],a[11],a[12])
	end
	return pa
end

local classnames = {
	"Part",
	"MeshPart",
	"Model",
	"FlagStand",
	"SpawnLocation",
	"TrussPart",
	"WedgePart",
	"CornerWedgePart",
	"UnionOperation",
	"NegateOperation",
	"Seat",
	"VehicleSeat",
	"WorldModel"
}

local blacklistedstrings = {
	";",
	":",
	"'",
	"<",
	">",
	",",
	".",
	"!",
	"@",
	"#",
	"$",
	"%",
	"^",
	"&",
	"*",
	"(",
	")",
	"-",
	"=",
	"+",
	"/",
	"{",
	"}",
	"[",
	"]",
	"|",
	"60128304260637",
}

function kill(object)
    if not object or object == char then
        return
    end
    local model = object:IsA("Model") and object or object:FindFirstAncestorOfClass("Model")
    if model and model ~= char and model:FindFirstChildOfClass("Humanoid") then
        return
    end
    for _, v in pairs(object:GetChildren()) do
        coroutine.wrap(function()
            if v.ClassName == "Part" or v.ClassName == "MeshPart" or v.ClassName == "FlagStand" or v.ClassName == "SpawnLocation" or v.ClassName == "TrussPart" or v.ClassName == "WedgePart" or v.ClassName == "CornerWedgePart" or v.ClassName == "UnionOperation" or v.ClassName == "NegateOperation" or v.ClassName == "Seat" or v.ClassName == "VehicleSeat" then
                inputremote:Fire("effect","ball",v3(0,0,0),v.CFrame,c3(255,255,255),"Neon",0,workspace,true,false,"Quad",3,{Size = Vector3.new(10,10,10),Transparency = 1,Color = c3(0,0,0)})
                local p = Instance.new("Part",workspace)
                p.CFrame = v.CFrame
                p.CanCollide = false
                p.Anchored = true
                p.Size = Vector3.new(2,2,2)
                p.Transparency = 1
                p.Name = "KILLDUSTPARTALSOHIEXPLORERSKID"
                local ks = killsound:Clone()
                ks.Parent = p
                ks:Play()
                local d = killdust:Clone()
                d.Parent = p
                v:Destroy()
                d:Emit(2)
                wait(.5)
                d:Emit(2)
                wait(5)
                p:Destroy()
            end
        end)()
    end
    object:Destroy()
end

function checkobject(a,colortype)
    if not a or not a.Parent or a.Parent == workspace then
        return
    end
    local model = a:IsA("Model") and a or a:FindFirstAncestorOfClass("Model")
    if model and model ~= char and model:FindFirstChildOfClass("Humanoid") then
        if not flingDebounce[model] then
            flingDebounce[model] = true
            ReanimateFlingTarget(model)
            task.delay(0.15, function()
                flingDebounce[model] = nil
            end)
        end
        return
    end
    if a.Parent == char or a == char or a.Parent.Parent == char or (a.Parent.Parent and a.Parent.Parent.Parent == char) or a == script or a.Parent == script then
        return
    end
    for _, v in pairs(classnames) do
        if a.ClassName == v then
            if (a.Parent:IsA("Model") or a.Parent.ClassName == "Model" or a.Parent:IsA("Folder") or a.Parent.ClassName == "Folder" or a.Parent.ClassName == "Script" or a.Parent.ClassName == "LocalScript")
                and (a.Size == Vector3.new(2,2,1) or a.Size == Vector3.new(2,2.1,1) or a.Size == Vector3.new(1,1.105,1) or a.Size == Vector3.new(1,1.227,1) or a.Size == Vector3.new(1,1.253,1) or a.Size == Vector3.new(1,1.277,1) or a.Size == Vector3.new(1,2,1) or a.Size == Vector3.new(2,1,1) or a.Name == "Head" or a.Name == "Torso" or a.Name == "Right Arm" or a.Name == "Left Arm" or a.Name == "Right Leg" or a.Name == "Left Leg" or a.Name == "UpperTorso" or a.Name == "HumanoidRootPart" or a.Name == "LowerTorso" or a.Name == "RightHand" or a.Name == "LeftHand" or a.Name == "RightFoot" or a.Name == "LeftFoot" or a.Name == "LeftUpperArm" or a.Name == "LeftLowerArm" or a.Name == "RightUpperArm" or a.Name == "RightLowerArm" or a.Name == "LeftUpperLeg" or a.Name == "LeftLowerLeg" or a.Name == "RightUpperLeg" or a.Name == "RightLowerLeg") then
                kill(a.Parent)
            end
        end
    end
    if a.ClassName == "WorldModel" and a.Parent ~= nil then
        a:Destroy()
    end
end

function region3damage(color,size,position)
	local colorcheck = color
	
	local r3 = Region3.new(position-(size)/2,position+(size)/2)
	
	
	
	coroutine.wrap(function()
		local locatedparts = workspace:FindPartsInRegion3(r3,char,1000) 
		pcall(function()
			for i,v in pairs(locatedparts) do
				if color == "blue" then
					checkobject(v,"blue")
				elseif color == "orange" then
					checkobject(v,"orange")
				elseif color == "regular" then
					checkobject(v,"regular")
				end
			end
		end)
	end)()
end


function guichat(message)
	for i,v in pairs({plr}) do
		if v.PlayerGui:FindFirstChild("guipopup") then
			v.PlayerGui:FindFirstChild("guipopup"):Destroy()
		end
	end
	for i,v in pairs({plr}) do
		local sc = textgui:Clone()
		sc.run.text.Value = "* ".. message
		sc.Parent = v.PlayerGui
		sc.run.Disabled = false
	end
end









function coloredswing()
	attacking = true
	
	hum.WalkSpeed = 0
	
	
	
	
	
	
	
	
	
	
	coroutine.wrap(function()
		for i = 0,13,.1 do
			Swait()
			SetTween(tridentweld,{C0=tridentc0*cf(.6, -3, -.4) * angles(rad(-25), rad(35), rad(-80))},"Quad","InOut",.1/speed)
			
			SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(10))},"Quad","Out",.3/speed)
			SetTween(NeckW,{C0=NeckCF*angles(rad(30 + 2*cos(sine/75)), rad(0), rad(-10))},"Quad","InOut",0.1/speed)
			SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), .2) * angles(rad(105 - 2*cos(sine/150)),rad(0),rad(0))},"Sine","InOut",0.1/speed)
			SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), -.2) * angles(rad(55 - 2*cos(sine/150)),rad(0),rad(0))},"Sine","InOut",0.1/speed)
			SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.1/speed)
			SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.1/speed)
		end
		for i = 0,15,.1 do
			Swait()
			SetTween(tridentweld,{C0=tridentc0*cf(0, -2, 0) * angles(rad(0), rad(-35), rad(-190))},"Quad","InOut",.05/speed)
			
			SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(20))},"Quad","Out",.2/speed)
			SetTween(NeckW,{C0=NeckCF*angles(rad(0), rad(0), rad(-20))},"Quad","InOut",0.05/speed)
			SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), .2) * angles(rad(90),rad(0),rad(10))},"Sine","InOut",0.05/speed)
			SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), 0) * angles(rad(0),rad(25),rad(0))},"Sine","InOut",0.05/speed)
			SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.05/speed)
			SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.05/speed)
		end
	end)()
	
	for i,v in pairs({plr}) do
		local gui = flashgui:Clone()
		gui.Parent = v:WaitForChild("PlayerGui")
		gui.flashmake.Disabled = false
	end
	ts:Create(atmosphere,tweeninfo(.2,"Sine","InOut"),{TintColor = Color3.fromRGB(89, 89, 89)}):Play()
	
	local blue1
	local blue2
	local blue3
	local colortable = {}
	local random1 = random(1,2)
	local random2 = random(1,2)
	local random3 = random(1,2)

	wait(1)
	local glint1 = glint:Clone()
	glint1.Parent = workspace
	glint1:Play()
	
	local lefteyepart = Instance.new("Part",char)
	lefteyepart.Name = "glow"
	lefteyepart.Anchored = true
	lefteyepart.CanCollide = false
	lefteyepart.Transparency = 1
	lefteyepart.Size = Vector3.new(.1,.1,.1)
	lefteyepart.CFrame = char.Head.CFrame*cf(-.3,.2,-.6)
	
	local righteyepart = Instance.new("Part",char)
	righteyepart.Name = "glow2"
	righteyepart.Anchored = true
	righteyepart.CanCollide = false
	righteyepart.Transparency = 1
	righteyepart.Size = Vector3.new(.1,.1,.1)
	righteyepart.CFrame = char.Head.CFrame*cf(.3,.2,-.6)
	
	local glower = eyeglow:Clone()
	glower.Parent = lefteyepart
	
	local glower2 = eyeglow:Clone()
	glower2.Parent = righteyepart
	
	glower2.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.new(1,0.4705882370472,0.0039215688593686)), 
		ColorSequenceKeypoint.new(1,Color3.new(1,0.55294120311737,0.0078431377187371)), 
	}) 
	
	if random1 == 1 then
		glower:Emit(1)
		table.insert(colortable,"blue")
		blue1 = Color3.fromRGB(47, 126, 130)
		ts:Create(trident,tweeninfo(.2,"Sine","InOut"),{Color = Color3.fromRGB(47, 126, 130)}):Play() 
		ts:Create(atmosphere,tweeninfo(.2,"Sine","InOut"),{TintColor = Color3.fromRGB(47, 126, 130)}):Play() 
	else
		glower2:Emit(1)
		table.insert(colortable,"orange")
		blue1 = Color3.fromRGB(217, 140, 72)
		ts:Create(trident,tweeninfo(.2,"Sine","InOut"),{Color = Color3.fromRGB(217, 140, 72)}):Play() 
		ts:Create(atmosphere,tweeninfo(.2,"Sine","InOut"),{TintColor = Color3.fromRGB(217, 140, 72)}):Play() 
	end
	wait(swingspeed)
	glint1:Play()
	if random2 == 1 then
		glower:Emit(1)
		table.insert(colortable,"blue")
		blue2 = Color3.fromRGB(47, 126, 130)
		ts:Create(trident,tweeninfo(.2,"Sine","InOut"),{Color = Color3.fromRGB(47, 126, 130)}):Play() 
		ts:Create(atmosphere,tweeninfo(.2,"Sine","InOut"),{TintColor = Color3.fromRGB(47, 126, 130)}):Play() 
	else
		glower2:Emit(1)
		table.insert(colortable,"orange")
		blue2 = Color3.fromRGB(217, 140, 72)
		ts:Create(trident,tweeninfo(.2,"Sine","InOut"),{Color = Color3.fromRGB(217, 140, 72)}):Play() 
		ts:Create(atmosphere,tweeninfo(.2,"Sine","InOut"),{TintColor = Color3.fromRGB(217, 140, 72)}):Play() 
	end
	wait(swingspeed)
	local ps = Instance.new("PitchShiftSoundEffect",glint1)
	ps.Octave = .8
	glint1:Play()
	glower.Lifetime = NumberRange.new(.8, .8) 
	glower2.Lifetime = NumberRange.new(.8, .8) 
	if random3 == 1 then
		glower:Emit(1)
		table.insert(colortable,"blue")
		blue3 = Color3.fromRGB(47, 126, 130)
		ts:Create(trident,tweeninfo(.2,"Sine","InOut"),{Color = Color3.fromRGB(47, 126, 130)}):Play() 
		ts:Create(atmosphere,tweeninfo(.2,"Sine","InOut"),{TintColor = Color3.fromRGB(47, 126, 130)}):Play() 
	else
		glower2:Emit(1)
		table.insert(colortable,"orange")
		blue3 = Color3.fromRGB(217, 140, 72)
		ts:Create(trident,tweeninfo(.2,"Sine","InOut"),{Color = Color3.fromRGB(217, 140, 72)}):Play() 
		ts:Create(atmosphere,tweeninfo(.2,"Sine","InOut"),{TintColor = Color3.fromRGB(217, 140, 72)}):Play() 
	end
	wait(swingspeed)
	ts:Create(trident,tweeninfo(1,"Sine","InOut"),{Color = Color3.fromRGB(255,0,0)}):Play() 
	ts:Create(atmosphere,tweeninfo(.4,"Sine","InOut"),{TintColor = Color3.new(1, 0.486275, 0.494118)}):Play()
	
	local bigtrident1 = bigtrident:Clone()
	bigtrident1.Parent = workspace
	bigtrident1.Color = Color3.fromRGB(255,0,0)
	ts:Create(bigtrident1,tweeninfo(swingspeed-.1,"Quad","Out"),{Transparency = 0,CFrame = torso.CFrame*CFrame.new(0,40,-59)*angles(rad(110),0,0)}):Play() 
	
	wait(swingspeed+.1)
	
	local savedposition = bigtrident1.CFrame
	glint1:Destroy()
	
	local swing = swoosh:Clone()
	swing.Parent = workspace
	swing:Play()
	
	ts:Create(trident,tweeninfo(swingspeed-.1,"Sine","InOut"),{Color = blue1}):Play()
	ts:Create(bigtrident1,tweeninfo(swingspeed-.1,"Sine","Out"),{Color = blue1,CFrame = savedposition*angles(rad(-220),0,0)}):Play()
	bigtrident1.Trail.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,blue1), 
		ColorSequenceKeypoint.new(1,blue1), 
	}) 
	inputremote:Fire("effectcolor",blue1)
	EFFECTCOLOR = blue1
	coroutine.wrap(function()
		for i = 0,20,1 do
			Swait()
			inputremote:Fire("region3damage",colortable[1],Vector3.new(50,90,50),bigtrident1.Position)
			
			region3damage(colortable[1],Vector3.new(50,90,50),bigtrident1.Position)
		end

		wait(swingspeed-.2)
		for i = 0,20,1 do
			Swait()
			inputremote:Fire("region3damage",colortable[2],Vector3.new(50,90,50),bigtrident1.Position)
			
			region3damage(colortable[2],Vector3.new(50,90,50),bigtrident1.Position)
		end

		wait(swingspeed-.2)
		for i = 0,20,1 do
			Swait()
			inputremote:Fire("region3damage",colortable[3],Vector3.new(50,90,50),bigtrident1.Position)
			
			region3damage(colortable[3],Vector3.new(50,90,50),bigtrident1.Position)
		end
	end)()

	wait(swingspeed)
	local swing2 = swing:Clone()
	swing2.Playing = false
	swing2.TimePosition = 0
	swing2.Parent = workspace
	swing2:Play()
	
	bigtrident1.Trail.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,blue2), 
		ColorSequenceKeypoint.new(1,blue2), 
	}) 
	inputremote:Fire("effectcolor",blue2)
	EFFECTCOLOR = blue2
	ts:Create(bigtrident1,tweeninfo(swingspeed-.1,"Sine","Out"),{Color = blue2,CFrame = savedposition}):Play()
	ts:Create(trident,tweeninfo(swingspeed-.1,"Sine","InOut"),{Color = blue2}):Play()
	
	wait(swingspeed)
	local swing3 = swing2:Clone()
	swing3.Playing = false
	swing3.TimePosition = 0
	swing3.Parent = workspace
	swing3:Play()
	
	ts:Create(bigtrident1,tweeninfo(swingspeed-.1,"Sine","Out"),{Color = blue3,CFrame = savedposition*angles(rad(-220),0,0)}):Play()
	ts:Create(trident,tweeninfo(swingspeed-.1,"Sine","InOut"),{Color = blue3}):Play()
	bigtrident1.Trail.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,blue3), 
		ColorSequenceKeypoint.new(1,blue3), 
	}) 
	inputremote:Fire("effectcolor",blue3)
	EFFECTCOLOR = blue3
	
	wait(1)
	coroutine.wrap(function()
		lefteyepart:Destroy()
		righteyepart:Destroy()
		swing:Destroy()
		swing2:Destroy()
		swing3:Destroy()
		ts:Create(trident,tweeninfo(.4,"Sine","InOut"),{Color = Color3.fromRGB(255,0,0)}):Play()
		ts:Create(bigtrident1,tweeninfo(1,"Quad","Out"),{Transparency = 1,CFrame = bigtrident1.CFrame*CFrame.new(25,25,25),Size = Vector3.new(0,0,0)}):Play()
		wait(1)
		bigtrident1:Destroy()
	end)()
	hum.WalkSpeed = 20
	inputremote:Fire("effectcolor",c3(255,0,0))
	EFFECTCOLOR = c3(255,0,0)
	
	attacking = false
end

function handfire()

    if attacking then

        return
    end
    attacking = true
    hum.WalkSpeed = 0
    local tridentsize = trident.Size
    ts:Create(trident, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = Vector3.new(0, 0, 0), Transparency = 1}):Play()
    EFFECTCOLOR = Color3.fromRGB(217, 140, 72)
    inputremote:Fire("effectcolor", Color3.fromRGB(217, 140, 72))
    coroutine.wrap(function()
        for i = 0, 6, 0.1 do
            Swait()
            SetTween(tridentweld, {C0 = tridentc0 * CFrame.new(0.3, -3, -1) * CFrame.Angles(math.rad(-25), math.rad(90), math.rad(-70))}, "Quad", "InOut", 0.1 / speed)
            SetTween(RJW, {C0 = RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))}, "Quad", "Out", 0.3 / speed)
            SetTween(NeckW, {C0 = NeckCF * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))}, "Quad", "InOut", 0.1 / speed)
            SetTween(RW, {C0 = CFrame.new(1.5, 0.5 + 0.05 * math.cos(sine / 75), 0) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(-45))}, "Sine", "InOut", 0.1 / speed)
            SetTween(LW, {C0 = CFrame.new(-1.5, 0.5 + 0.05 * math.cos(sine / 75), 0) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(45))}, "Sine", "InOut", 0.1 / speed)
            SetTween(RH, {C0 = CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(-5), math.rad(5))}, "Quad", "InOut", 0.1 / speed)
            SetTween(LH, {C0 = CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(5), math.rad(-5))}, "Quad", "InOut", 0.1 / speed)
        end
        for i = 0, 8, 0.1 do
            Swait()
            SetTween(tridentweld, {C0 = tridentc0 * CFrame.new(0.3, -3, -1) * CFrame.Angles(math.rad(-25), math.rad(90), math.rad(-70))}, "Quad", "InOut", 0.1 / speed)
            SetTween(RJW, {C0 = RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))}, "Quad", "Out", 0.3 / speed)
            SetTween(NeckW, {C0 = NeckCF * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))}, "Quad", "InOut", 0.1 / speed)
            SetTween(RW, {C0 = CFrame.new(1.5, 0.5 + 0.05 * math.cos(sine / 75), 0) * CFrame.Angles(math.rad(90), math.rad(25), math.rad(0))}, "Sine", "InOut", 0.1 / speed)
            SetTween(LW, {C0 = CFrame.new(-1.5, 0.5 + 0.05 * math.cos(sine / 75), 0) * CFrame.Angles(math.rad(90), math.rad(-25), math.rad(0))}, "Sine", "InOut", 0.1 / speed)
            SetTween(RH, {C0 = CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(-5), math.rad(5))}, "Quad", "InOut", 0.1 / speed)
            SetTween(LH, {C0 = CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(5), math.rad(-5))}, "Quad", "InOut", 0.1 / speed)
        end
        wait()
        for i = 0, 2, 0.1 do
            Swait()
            SetTween(tridentweld, {C0 = tridentc0 * CFrame.new(0.3, -3, -1) * CFrame.Angles(math.rad(-25), math.rad(90), math.rad(-70))}, "Quad", "InOut", 0.1 / speed)
            SetTween(RJW, {C0 = RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(-25))}, "Quad", "Out", 0.3 / speed)
            SetTween(NeckW, {C0 = NeckCF * CFrame.Angles(math.rad(0), math.rad(0), math.rad(25))}, "Quad", "InOut", 0.1 / speed)
            SetTween(RW, {C0 = CFrame.new(1.5, 0.5 + 0.05 * math.cos(sine / 75), 0.4) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))}, "Sine", "InOut", 0.05 / speed)
            SetTween(LW, {C0 = CFrame.new(-1.5, 0.5 + 0.05 * math.cos(sine / 75), 0.1) * CFrame.Angles(math.rad(0), math.rad(10), math.rad(-5 + 2 * math.cos(sine / 150)))}, "Sine", "InOut", 0.1 / speed)
            SetTween(RH, {C0 = CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(-5), math.rad(5))}, "Quad", "InOut", 0.1 / speed)
            SetTween(LH, {C0 = CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(5), math.rad(-5))}, "Quad", "InOut", 0.1 / speed)
        end
        for i = 0, 10, 0.1 do
            Swait()
            SetTween(tridentweld, {C0 = tridentc0 * CFrame.new(0.3, -3, -1) * CFrame.Angles(math.rad(-25), math.rad(90), math.rad(-70))}, "Quad", "InOut", 0.1 / speed)
            SetTween(RJW, {C0 = RootCF * CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(10))}, "Quad", "Out", 0.3 / speed)
            SetTween(NeckW, {C0 = NeckCF * CFrame.Angles(math.rad(0), math.rad(0), math.rad(-10))}, "Quad", "InOut", 0.1 / speed)
            SetTween(RW, {C0 = CFrame.new(1.5, 0.5 + 0.05 * math.cos(sine / 75), -0.5) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))}, "Sine", "InOut", 0.05 / speed)
            SetTween(LW, {C0 = CFrame.new(-1.5, 0.5 + 0.05 * math.cos(sine / 75), 0.1) * CFrame.Angles(math.rad(0), math.rad(10), math.rad(-5 + 2 * math.cos(sine / 150)))}, "Sine", "InOut", 0.1 / speed)
            SetTween(RH, {C0 = CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(-5), math.rad(5))}, "Quad", "InOut", 0.1 / speed)
            SetTween(LH, {C0 = CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(5), math.rad(-5))}, "Quad", "InOut", 0.1 / speed)
        end
    end)()
    wait(1)
    coroutine.wrap(function()
        local fireballs = {}
        for i = 0, 10, 1 do
            Swait()
            local ba = fireball:Clone()
            table.insert(fireballs, ba)
            ba.Transparency = 1
            ba.Parent = workspace
            ba.Anchored = true
            ba.CanCollide = false
            ba.Size = Vector3.new(0, 0, 0)
            ba.CFrame = rootpart.CFrame * CFrame.new(-i - 5, 0, -15 + (i * 6))
            ts:Create(ba, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = Vector3.new(2, 2, 2) + Vector3.new(i / 3, i / 3, i / 3), Transparency = 0}):Play()
        end
        for i = 0, 10, 1 do
            Swait()
            local ba = fireball:Clone()
            table.insert(fireballs, ba)
            ba.Transparency = 1
            ba.Parent = workspace
            ba.Anchored = true
            ba.CanCollide = false
            ba.Size = Vector3.new(0, 0, 0)
            ba.CFrame = rootpart.CFrame * CFrame.new(-i - 5, 0, 15 - (i * 6))
            ts:Create(ba, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = Vector3.new(2, 2, 2) + Vector3.new(i / 3, i / 3, i / 3), Transparency = 0}):Play()
        end
        for i = 0, 10, 1 do
            Swait()
            local ba = fireball:Clone()
            table.insert(fireballs, ba)
            ba.Transparency = 1
            ba.Parent = workspace
            ba.Anchored = true
            ba.CanCollide = false
            ba.Size = Vector3.new(0, 0, 0)
            ba.CFrame = rootpart.CFrame * CFrame.new(i + 5, 0, -15 + (i * 6))
            ts:Create(ba, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = Vector3.new(2, 2, 2) + Vector3.new(i / 3, i / 3, i / 3), Transparency = 0}):Play()
        end
        for i = 0, 10, 1 do
            Swait()
            local ba = fireball:Clone()
            table.insert(fireballs, ba)
            ba.Transparency = 1
            ba.Parent = workspace
            ba.Anchored = true
            ba.CanCollide = false
            ba.Size = Vector3.new(0, 0, 0)
            ba.CFrame = rootpart.CFrame * CFrame.new(i + 5, 0, 15 - (i * 6))
            ts:Create(ba, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = Vector3.new(2, 2, 2) + Vector3.new(i / 3, i / 3, i / 3), Transparency = 0}):Play()
        end
        wait(1)
        for i, v in pairs(fireballs) do
            coroutine.wrap(function()
                local bv = Instance.new("BodyVelocity", v)
                v.Anchored = false
                local randomOffset = Vector3.new(
                    math.random(-10, 10) / 10,
                    math.random(-10, 10) / 10,
                    math.random(-5, 5) / 10 
                )
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = (rootpart.CFrame.lookVector + randomOffset) * 100
                coroutine.wrap(function()
                    for i = 0, 20, 0.1 do
                        Swait(10)
                        inputremote:Fire("region3damage", "orange", v.Size, v.Position)
                        region3damage("orange", v.Size, v.Position)
                    end
                end)()
                wait(10)
                v.fire.Enabled = false
                wait(0.9)
                v:Destroy()
            end)()
        end
    end)()
    wait(4)
    hum.WalkSpeed = walkspeedval
    ts:Create(trident, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = tridentsize, Transparency = 0}):Play()
    wait(1)
    inputremote:Fire("effectcolor", Color3.fromRGB(255, 0, 0))
    attacking = false
end

function earthquake()
	attacking = true
	
	inputremote:Fire("effectcolor",c3(217, 140, 72))
	hum.WalkSpeed = 0
   task.spawn(function()
   chatmessage("Feel the wrath of earth.")
   end)
	local pp1 = specialp1:Clone()
	local pp2 = specialp2:Clone()
	pp1.Parent = trident
	pp2.Parent = trident
	for i = 0,2,.1 do
		Swait()
		
		SetTween(tridentweld,{C0=tridentc0*cf(.8, -1, .5) * angles(rad(120), rad(0), rad(-35))},"Quad","InOut",.05/speed) 
		
		SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(0))},"Quad","Out",.25/speed)
		SetTween(NeckW,{C0=NeckCF*angles(rad(-20 + 2*cos(sine/75)), rad(0), rad(0))},"Quad","InOut",0.05/speed)
		SetTween(RW,{C0=cf(1, .6 + .05*cos(sine/75), -.5) * angles(rad(125),rad(0),rad(-30))},"Sine","InOut",0.05/speed)
		SetTween(LW,{C0=cf(-1, .6 + .05*cos(sine/75), -.5) * angles(rad(125),rad(0),rad(30))},"Sine","InOut",0.05/speed)
		SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.05/speed)
		SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.05/speed)
	end
	for i = 0,2,.1 do
		Swait()
		
		SetTween(tridentweld,{C0=tridentc0*cf(-.8, 1.5, .5) * angles(rad(50), rad(180), rad(-35))},"Quad","InOut",.04/speed) 
		
		SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(0))},"Quad","Out",.25/speed)
		SetTween(NeckW,{C0=NeckCF*angles(rad(-20 + 2*cos(sine/75)), rad(0), rad(0))},"Quad","InOut",0.05/speed)
		SetTween(RW,{C0=cf(1, .6 + .05*cos(sine/75), -.5) * angles(rad(125),rad(0),rad(-30))},"Sine","InOut",0.05/speed)
		SetTween(LW,{C0=cf(-1, .6 + .05*cos(sine/75), -.5) * angles(rad(125),rad(0),rad(30))},"Sine","InOut",0.05/speed)
		SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.05/speed)
		SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.05/speed)
	end
	coroutine.wrap(function()
		for i = 0,40,.1 do
			Swait()
			
			SetTween(tridentweld,{C0=tridentc0*cf(-.8, -1.5, .5) * angles(rad(120), rad(182), rad(-35))},"Quad","InOut",.07/speed) 
			
			SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(0))},"Quad","Out",.25/speed)
			SetTween(NeckW,{C0=NeckCF*angles(rad(40), rad(0), rad(0))},"Quad","InOut",0.07/speed)
			SetTween(RW,{C0=cf(1, .6 + .05*cos(sine/75), -.5) * angles(rad(60),rad(0),rad(-30))},"Sine","InOut",0.07/speed)
			SetTween(LW,{C0=cf(-1, .6 + .05*cos(sine/75), -.5) * angles(rad(60),rad(0),rad(30))},"Sine","InOut",0.07/speed)
			SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.07/speed)
			SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.07/speed)
		end
	end)()
	
	local e1 = earthquake1:Clone()
	e1.Parent = workspace
	e1:Play()
	
	coroutine.wrap(function()
		for i,v in pairs({plr}) do
			
				local cs = camshakescript:Clone()
				cs:FindFirstChild("intensity").Value = 5
				cs:FindFirstChild("shaketime").Value = 5
				cs.Parent = v:WaitForChild("Backpack")
				cs.Disabled = false
			
		end
		wait(2)
		for i,v in pairs({plr}) do
			
				local cs = camshakescript:Clone()
				cs:FindFirstChild("intensity").Value = 10
				cs:FindFirstChild("shaketime").Value = 5
				cs.Parent = v:WaitForChild("Backpack")
				cs.Disabled = false
			
		end
		wait(2)
		for i,v in pairs({plr}) do
			
				local cs = camshakescript:Clone()
				cs:FindFirstChild("intensity").Value = 15
				cs:FindFirstChild("shaketime").Value = 1
				cs.Parent = v:WaitForChild("Backpack")
				cs.Disabled = false
			
		end
	end)()
	
	local ppart = Instance.new("Part",workspace)
	ppart.CFrame = rootpart.CFrame * cf(0,-3.8,0)
	ppart.Size = v3(20,.1,20)
	ppart.CanCollide = false
	ppart.Anchored = true
	ppart.Transparency = 1
	
	local particle1 = earthparticle:Clone()
	particle1.Parent = ppart

	coroutine.wrap(function()
		for i = 0,100,1 do
			Swait(3)
			inputremote:Fire("region3damage","orange",ppart.Size+Vector3.new(0,4,0),ppart.Position+Vector3.new(0,3,0))
			region3damage("orange",ppart.Size+Vector3.new(0,4,0),ppart.Position+Vector3.new(0,3,0))
		end
	end)()
	
	local partcast = rayCast(rootpart.Position, cf(rootpart.Position, rootpart.Position - Vector3.new(0, 1, 0)).lookVector, 4, char)
	if partcast ~= nil then
		particle1.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,partcast.Color), 
			ColorSequenceKeypoint.new(1,partcast.Color), 
		}) 
	end
	
	for i = 0,100,1 do
		Swait(3)
		ppart.Size = ppart.Size + v3(2,0,2)
		particle1.Rate = particle1.Rate + 2
		local increase = i*2
		local part = rayCast(rootpart.Position, cf(rootpart.Position, rootpart.Position - Vector3.new(0, 1, 0)).lookVector, 4, char)
		local p = Instance.new("Part",workspace)
		p.Size = Vector3.new(5+i/3,5+i/3,5+i/3)
		if part ~= nil then
			p.Material = part.Material
			p.Color = part.Color
		else
			p.Material = Enum.Material.Slate
			p.Color = Color3.fromRGB(165, 85, 16)
		end
		p.Anchored = false
		p.CanCollide = false
		p.Position = rootpart.Position + Vector3.new(random(-50-increase,50+increase),0,random(-50-increase,50+increase))
		p.Velocity = Vector3.new(random(-200-increase,200+increase),200+increase,random(-200-increase,200+increase))
		p.RotVelocity = Vector3.new(random(-100-increase,100+increase),100+increase,random(-100-increase,100+increase))
		p.Name = "earthquakepart"
		coroutine.wrap(function()
			wait(5)
			p:Destroy()
		end)()
	end
	
	attacking = false
	inputremote:Fire("effectcolor",c3(255,0,0))
	hum.WalkSpeed = walkspeedval
	particle1.Enabled = false
	coroutine.wrap(function()
		pp1.Enabled = false
		pp2.Enabled = false
		wait(2)
		pp1:Destroy()
		pp2:Destroy()
	end)()
	wait(3)
	e1:Destroy()
	ppart:Destroy()
end

function ultrastab() 
	attacking = true
	inputremote:Fire("doidleeffects")
	hum.WalkSpeed = 5
	local pp1 = specialp1:Clone()
	local pp2 = specialp2:Clone()
	pp1.Parent = trident
	pp2.Parent = trident
	coroutine.wrap(function()
		wait(1)
      task.spawn(function()
		chatmessage("Ignorant.")
     end)
	end)()
	for i = 0,15,.1 do
		Swait()
		SetTween(tridentweld,{C0=tridentc0*cf(.5, -2, .5) * angles(rad(0), rad(-35), rad(-100))},"Sine","InOut",.2/speed)
		
		SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(-45))},"Sine","Out",.2/speed)
		SetTween(NeckW,{C0=NeckCF*angles(rad(0), rad(0), rad(45))},"Sine","InOut",0.1/speed)
		SetTween(RW,{C0=cf(1.5, .5, 0) * angles(rad(90),rad(0),rad(40))},"Sine","InOut",0.2/speed)
		SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), 0) * angles(rad(75),rad(0),rad(-20))},"Sine","InOut",0.2/speed)
		
		if Anim == "Idle" then
			SetTween(RH,{C0=cf(.6, -1, .2) * angles(rad(0),rad(45),rad(0))},"Sine","InOut",0.2/speed)
			SetTween(LH,{C0=cf(-.6, -1, -.2) * angles(rad(0),rad(45),rad(0))},"Sine","InOut",0.2/speed)
		elseif Anim == "Walk" then
			local RH2 = cf(-forWRL/7 * cos(sine / 75 ),0,forWFB/7 * cos(sine / 75 ))*angles(sin(-forWFB) * cos(sine / 75 ),0,sin(-forWRL) * cos(sine / 75 ))
			local LH2 = cf(forWRL/7 * cos(sine / 75 ),0,-forWFB/7 * cos(sine / 75 ))*angles(sin(forWFB) * cos(sine / 75 ),0,sin(forWRL) * cos(sine / 75 ))
			SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/75 ), 0+.15* cos(sine/75 ))*RH2 * angles(rad(0 - 5 * cos(sine/75)),rad(45),rad(0))},"Sine","InOut",.07/speed)
			SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/75 ), 0-.15* cos(sine/75 ))*LH2 * angles(rad(0 + 5 * cos(sine/75)),rad(45),rad(0))},"Sine","InOut",.07/speed)
		end
	end
	coroutine.wrap(function()
		
		
		inputremote:Fire("loopfunction",5,"effect","ellipses",v3(0,0,0),trident.CFrame,c3(255,0,0),"Neon",0,workspace,true,false,"Quad",.5,{Size = Vector3.new(1,100,1),Transparency = 1})
		
		inputremote:Fire("loopfunction",5,"effect","ellipses",v3(0,0,0),trident.CFrame*cf(0,5,0)*angles(random(-180,180),random(-180,180),random(-180,180)),c3(255,0,0),"Neon",0,workspace,true,false,"Quad",1,{Size = Vector3.new(1,100,1),Transparency = 1,Orientation = v3(random(-180,180),random(-180,180),random(-180,180))})
		inputremote:Fire("loopfunction",5,"effect","ellipses",v3(0,0,0),trident.CFrame*cf(0,5,0)*angles(random(-180,180),random(-180,180),random(-180,180)),c3(255,0,0),"Neon",0,workspace,true,false,"Quad",1,{Size = Vector3.new(1,100,1),Transparency = 1,Orientation = v3(random(-180,180),random(-180,180),random(-180,180))})
		inputremote:Fire("loopfunction",5,"effect","ellipses",v3(0,0,0),trident.CFrame*cf(0,5,0)*angles(random(-180,180),random(-180,180),random(-180,180)),c3(255,0,0),"Neon",0,workspace,true,false,"Quad",1,{Size = Vector3.new(1,100,1),Transparency = 1,Orientation = v3(random(-180,180),random(-180,180),random(-180,180))})
		inputremote:Fire("loopfunction",5,"effect","ellipses",v3(0,0,0),trident.CFrame*cf(0,5,0)*angles(random(-180,180),random(-180,180),random(-180,180)),c3(255,0,0),"Neon",0,workspace,true,false,"Quad",1,{Size = Vector3.new(1,100,1),Transparency = 1,Orientation = v3(random(-180,180),random(-180,180),random(-180,180))})
		
		inputremote:Fire("loopfunction",5,"effect","ball",v3(0,0,0),trident.CFrame*cf(0,5,0),c3(255,0,0),"Neon",0,workspace,true,false,"Quad",.5,{Size = Vector3.new(25,25,25),Transparency = 1,Color = c3(0,0,0)})
		
		
		for i,v in pairs({plr}) do
			
			local cs = camshakescript:Clone()
			cs:FindFirstChild("intensity").Value = 1
			cs:FindFirstChild("shaketime").Value = 1
			cs.Parent = v:WaitForChild("Backpack")
			cs.Disabled = false
			
		end
		for i = 0,5,.1 do
			Swait()
			inputremote:Fire("region3damage","regular",Vector3.new(20,2,20),trident.Position)
			region3damage("regular",Vector3.new(20,2,20),trident.Position)
		end
	end)()
	local es = energystrike:Clone()
	es.Parent = rootpart
	es:Play()
	for i = 0,5,.1 do
		Swait()
		SetTween(tridentweld,{C0=tridentc0*cf(.2, -4, .2) * angles(rad(0), rad(-35), rad(-170))},"Sine","InOut",.03/speed)
		
		SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(25))},"Quad","Out",.05/speed)
		SetTween(NeckW,{C0=NeckCF*angles(rad(0), rad(0), rad(-25))},"Quad","InOut",0.00001/speed)
		SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), -1) * angles(rad(90),rad(0),rad(15))},"Sine","InOut",0.03/speed)
		SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), 0) * angles(rad(-15),rad(0),rad(-35))},"Sine","InOut",0.03/speed)
		
		if Anim == "Idle" then
			SetTween(RH,{C0=cf(.6, -1, -.2) * angles(rad(0),rad(-35),rad(0))},"Quad","InOut",0.00001/speed)
			SetTween(LH,{C0=cf(-.6, -1, .2) * angles(rad(0),rad(-35),rad(0))},"Quad","InOut",0.00001/speed)
		elseif Anim == "Walk" then
			local RH2 = cf(-forWRL/7 * cos(sine / 75 ),0,forWFB/7 * cos(sine / 75 ))*angles(sin(-forWFB) * cos(sine / 75 ),0,sin(-forWRL) * cos(sine / 75 ))
			local LH2 = cf(forWRL/7 * cos(sine / 75 ),0,-forWFB/7 * cos(sine / 75 ))*angles(sin(forWFB) * cos(sine / 75 ),0,sin(forWRL) * cos(sine / 75 ))
			SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/75 ), 0+.15* cos(sine/75 ))*RH2 * angles(rad(0 - 5 * cos(sine/75)),rad(45),rad(0))},"Sine","InOut",.07/speed)
			SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/75 ), 0-.15* cos(sine/75 ))*LH2 * angles(rad(0 + 5 * cos(sine/75)),rad(45),rad(0))},"Sine","InOut",.07/speed)
		end
	end
	coroutine.wrap(function()
		pp1.Enabled = false
		pp2.Enabled = false
		wait(2)
		pp1:Destroy()
		pp2:Destroy()
		es:Destroy()
	end)()
	attacking = false
	inputremote:Fire("doidleeffects")
	hum.WalkSpeed = walkspeedval
end

function swing()
	attacking = true
	inputremote:Fire("doidleeffects")
	if swingnum == 1 then
		for i = 0,2,.1 do
			Swait()
			SetTween(tridentweld,{C0=tridentc0*cf(.5, -2, .5) * angles(rad(0), rad(-35), rad(-100))},"Sine","InOut",.05/speed)
			
			SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(-45))},"Quad","Out",.1/speed)
			SetTween(NeckW,{C0=NeckCF*angles(rad(0), rad(0), rad(45))},"Quad","InOut",0.05/speed)
			SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), 0) * angles(rad(90),rad(0),rad(20))},"Sine","InOut",0.07/speed)
			SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), 0) * angles(rad(75),rad(0),rad(-20))},"Sine","InOut",0.07/speed)
			if Anim == "Idle" then
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-2),rad(5))},"Quad","InOut",0.07/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(2),rad(-5))},"Quad","InOut",0.07/speed)
			elseif Anim == "Walk" then
				local RH2 = cf(-forWRL/7 * cos(sine / 20 ),0,forWFB/7 * cos(sine / 20 ))*angles(sin(-forWFB) * cos(sine / 20 ),0,sin(-forWRL) * cos(sine / 20 ))
				local LH2 = cf(forWRL/7 * cos(sine / 20 ),0,-forWFB/7 * cos(sine / 20 ))*angles(sin(forWFB) * cos(sine / 20 ),0,sin(forWRL) * cos(sine / 20 ))
				SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/20 ), 0+.15* cos(sine/20 ))*RH2 * angles(rad(0 - 5 * cos(sine/20)),rad(45),rad(0))},"Sine","InOut",.07/speed)
				SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/20 ), 0-.15* cos(sine/20 ))*LH2 * angles(rad(0 + 5 * cos(sine/20)),rad(45),rad(0))},"Sine","InOut",.07/speed)
			end
		end
		coroutine.wrap(function()
			for i = 0,2,.1 do
				Swait()
				inputremote:Fire("region3damage","regular",Vector3.new(10,2,10),trident.Position)
				region3damage("regular",Vector3.new(10,2,10),trident.Position)
			end
		end)()
		for i = 0,2,.1 do
			Swait()
			SetTween(tridentweld,{C0=tridentc0*cf(.2, -4, .2) * angles(rad(0), rad(-35), rad(-170))},"Sine","InOut",.05/speed)
			
			SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(25))},"Quad","Out",.1/speed)
			SetTween(NeckW,{C0=NeckCF*angles(rad(0), rad(0), rad(-25))},"Quad","InOut",0.05/speed)
			SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), -1) * angles(rad(90),rad(0),rad(15))},"Sine","InOut",0.05/speed)
			SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), 0) * angles(rad(-15),rad(0),rad(-35))},"Sine","InOut",0.07/speed)
			if Anim == "Idle" then
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-2),rad(5))},"Quad","InOut",0.07/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(2),rad(-5))},"Quad","InOut",0.07/speed)
			elseif Anim == "Walk" then
				local RH2 = cf(-forWRL/7 * cos(sine / 20 ),0,forWFB/7 * cos(sine / 20 ))*angles(sin(-forWFB) * cos(sine / 20 ),0,sin(-forWRL) * cos(sine / 20 ))
				local LH2 = cf(forWRL/7 * cos(sine / 20 ),0,-forWFB/7 * cos(sine / 20 ))*angles(sin(forWFB) * cos(sine / 20 ),0,sin(forWRL) * cos(sine / 20 ))
				SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/20 ), 0+.15* cos(sine/20 ))*RH2 * angles(rad(0 - 5 * cos(sine/20)),rad(-25),rad(0))},"Sine","InOut",.07/speed)
				SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/20 ), 0-.15* cos(sine/20 ))*LH2 * angles(rad(0 + 5 * cos(sine/20)),rad(-25),rad(0))},"Sine","InOut",.07/speed)
			end
		end
		inputremote:Fire("doidleeffects")
		attacking = false
		swingnum = 2
	elseif swingnum == 2 then
		for i = 0,2,.1 do
			Swait()
			SetTween(tridentweld,{C0=tridentc0*cf(.0, -3, -1.1) * angles(rad(0), rad(90), rad(-90))},"Quad","InOut",.05/speed)
			
			SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(-10), rad(0), rad(0))},"Quad","Out",.2/speed)
			SetTween(NeckW,{C0=NeckCF*angles(rad(5), rad(0), rad(0))},"Quad","InOut",0.05/speed)
			SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), .4) * angles(rad(90),rad(0),rad(0))},"Sine","InOut",0.05/speed)
			SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), .4) * angles(rad(90),rad(0),rad(0))},"Sine","InOut",0.05/speed)
			if Anim == "Idle" then
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(-10),rad(-5),rad(5))},"Quad","InOut",0.05/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(-10),rad(5),rad(-5))},"Quad","InOut",0.05/speed)
			elseif Anim == "Walk" then
				local RH2 = cf(-forWRL/7 * cos(sine / 20 ),0,forWFB/7 * cos(sine / 20 ))*angles(sin(-forWFB) * cos(sine / 20 ),0,sin(-forWRL) * cos(sine / 20 ))
				local LH2 = cf(forWRL/7 * cos(sine / 20 ),0,-forWFB/7 * cos(sine / 20 ))*angles(sin(forWFB) * cos(sine / 20 ),0,sin(forWRL) * cos(sine / 20 ))
				SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/20 ), 0+.15* cos(sine/20 ))*RH2 * angles(rad(0 - 5 * cos(sine/20)),rad(0),rad(0))},"Sine","InOut",.07/speed)
				SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/20 ), 0-.15* cos(sine/20 ))*LH2 * angles(rad(0 + 5 * cos(sine/20)),rad(0),rad(0))},"Sine","InOut",.07/speed)
			end
		end
		coroutine.wrap(function()
			for i = 0,2,.1 do
				Swait()
				inputremote:Fire("region3damage","regular",Vector3.new(9,2,5),trident.Position)
				region3damage("regular",Vector3.new(9,2,5),trident.Position)
			end
		end)()
		for i = 0,2,.1 do
			Swait()
			SetTween(tridentweld,{C0=tridentc0*cf(.0, -3, -1.1) * angles(rad(0), rad(90), rad(-90))},"Quad","InOut",.05/speed)
			
			SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(5), rad(0), rad(0))},"Quad","Out",.2/speed)
			SetTween(NeckW,{C0=NeckCF*angles(rad(0), rad(0), rad(0))},"Quad","InOut",0.05/speed)
			SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), -.8) * angles(rad(90),rad(0),rad(0))},"Sine","InOut",0.05/speed)
			SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), -.8) * angles(rad(90),rad(0),rad(0))},"Sine","InOut",0.05/speed)
			if Anim == "Idle" then
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(5),rad(-5),rad(5))},"Quad","InOut",0.05/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(5),rad(5),rad(-5))},"Quad","InOut",0.05/speed)
			elseif Anim == "Walk" then
				local RH2 = cf(-forWRL/7 * cos(sine / 20 ),0,forWFB/7 * cos(sine / 20 ))*angles(sin(-forWFB) * cos(sine / 20 ),0,sin(-forWRL) * cos(sine / 20 ))
				local LH2 = cf(forWRL/7 * cos(sine / 20 ),0,-forWFB/7 * cos(sine / 20 ))*angles(sin(forWFB) * cos(sine / 20 ),0,sin(forWRL) * cos(sine / 20 ))
				SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/20 ), 0+.15* cos(sine/20 ))*RH2 * angles(rad(0 - 5 * cos(sine/20)),rad(0),rad(0))},"Sine","InOut",.07/speed)
				SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/20 ), 0-.15* cos(sine/20 ))*LH2 * angles(rad(0 + 5 * cos(sine/20)),rad(0),rad(0))},"Sine","InOut",.07/speed)
			end
		end
		inputremote:Fire("doidleeffects")
		attacking = false
		swingnum = 3
	elseif swingnum == 3 then
		for i = 0,2,.1 do
			Swait()
			
			SetTween(tridentweld,{C0=tridentc0*cf(-.8, 1, .7) * angles(rad(100), rad(180), rad(-35))},"Quad","InOut",.05/speed) 
			
			SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(-10), rad(0), rad(0))},"Quad","Out",.25/speed)
			SetTween(NeckW,{C0=NeckCF*angles(rad(-5), rad(0), rad(0))},"Quad","InOut",0.05/speed)
			SetTween(RW,{C0=cf(1, 1 + .05*cos(sine/75), -.5) * angles(rad(150),rad(0),rad(-30))},"Sine","InOut",0.05/speed)
			SetTween(LW,{C0=cf(-1, 1 + .05*cos(sine/75), -.5) * angles(rad(150),rad(0),rad(30))},"Sine","InOut",0.05/speed)
			if Anim == "Idle" then
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(-10),rad(-5),rad(5))},"Quad","InOut",0.05/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(-10),rad(5),rad(-5))},"Quad","InOut",0.05/speed)
			elseif Anim == "Walk" then
				local RH2 = cf(-forWRL/7 * cos(sine / 20 ),0,forWFB/7 * cos(sine / 20 ))*angles(sin(-forWFB) * cos(sine / 20 ),0,sin(-forWRL) * cos(sine / 20 ))
				local LH2 = cf(forWRL/7 * cos(sine / 20 ),0,-forWFB/7 * cos(sine / 20 ))*angles(sin(forWFB) * cos(sine / 20 ),0,sin(forWRL) * cos(sine / 20 ))
				SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/20 ), 0+.15* cos(sine/20 ))*RH2 * angles(rad(0 - 5 * cos(sine/20)),rad(0),rad(0))},"Sine","InOut",.07/speed)
				SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/20 ), 0-.15* cos(sine/20 ))*LH2 * angles(rad(0 + 5 * cos(sine/20)),rad(0),rad(0))},"Sine","InOut",.07/speed)
			end
		end
		coroutine.wrap(function()
			for i = 0,2,.1 do
				Swait()
				inputremote:Fire("region3damage","regular",Vector3.new(14,5,14),trident.Position)
				region3damage("regular",Vector3.new(14,5,14),trident.Position)
			end
		end)()
		for i = 0,2,.1 do
			Swait()
			
			SetTween(tridentweld,{C0=tridentc0*cf(-.8, -1, .7) * angles(rad(100), rad(180), rad(-35))},"Quad","InOut",.05/speed) 
			
			SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(10), rad(0), rad(0))},"Quad","Out",.25/speed)
			SetTween(NeckW,{C0=NeckCF*angles(rad(-5), rad(0), rad(0))},"Quad","InOut",0.05/speed)
			SetTween(RW,{C0=cf(1, .7 + .05*cos(sine/75), -.5) * angles(rad(125),rad(0),rad(-30))},"Sine","InOut",0.05/speed)
			SetTween(LW,{C0=cf(-1, .7 + .05*cos(sine/75), -.5) * angles(rad(125),rad(0),rad(30))},"Sine","InOut",0.05/speed)
			if Anim == "Idle" then
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(10),rad(-5),rad(5))},"Quad","InOut",0.05/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(10),rad(5),rad(-5))},"Quad","InOut",0.05/speed)
			elseif Anim == "Walk" then
				local RH2 = cf(-forWRL/7 * cos(sine / 20 ),0,forWFB/7 * cos(sine / 20 ))*angles(sin(-forWFB) * cos(sine / 20 ),0,sin(-forWRL) * cos(sine / 20 ))
				local LH2 = cf(forWRL/7 * cos(sine / 20 ),0,-forWFB/7 * cos(sine / 20 ))*angles(sin(forWFB) * cos(sine / 20 ),0,sin(forWRL) * cos(sine / 20 ))
				SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/20 ), 0+.15* cos(sine/20 ))*RH2 * angles(rad(0 - 5 * cos(sine/20)),rad(0),rad(0))},"Sine","InOut",.07/speed)
				SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/20 ), 0-.15* cos(sine/20 ))*LH2 * angles(rad(0 + 5 * cos(sine/20)),rad(0),rad(0))},"Sine","InOut",.07/speed)
			end
		end
		inputremote:Fire("doidleeffects")
		attacking = false
		swingnum = 1
	end
end

local songlist = {
	["reallywant"]=2303442953,
	["youlove"]=5345455968,
	["leight"]=1680840607,
	["slowing"]=1203808893,
	["ablix"]=1230326804,
	["toyou"]=3475857304,
	["goingback"]=2915250329,
	["daynnite"]=2371543268,
	["rainbowking"]=3522311451,
	["MAYHEM"]=614032233,
	["socialmedia"]=5127063380,
	["21stcentury"]=5482009290,
	["rainbowpuncher"]=2264258418,
	["theme"]=2728315619,
	
}

function randomquote()
    local quotes = {
        [1] = "...",
        [2] = "All I need is one more soul.",
        [3] = "Why are you getting in my way?",
        [4] = "You already knew this was going to happen, why are you trying to stop me?",
        [5] = "Quit struggling, you are all we need to get past the barrier.",
        [6] = "..."
    }

    local randomnum = math.random(1, #quotes)
    local selectedQuote = quotes[randomnum]

    chatmessage(selectedQuote)
end

function run()
	if running == false then
		attacking = false
		inputremote:Fire("doidleeffects")
		hum.WalkSpeed = 0
		coroutine.wrap(function()
			for i = 0,5,.1 do
				Swait()
				SetTween(tridentweld,{C0=tridentc0*cf(.3, -3, -1) * angles(rad(-25), rad(90), rad(-70))},"Quad","InOut",.1/speed)
				
				SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(0))},"Quad","Out",.3/speed)
				SetTween(NeckW,{C0=NeckCF*angles(rad(10), rad(0), rad(0))},"Quad","InOut",0.1/speed)
				SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), 0) * angles(rad(90),rad(0),rad(0))},"Sine","InOut",0.1/speed)
				SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), 0) * angles(rad(90),rad(0),rad(0))},"Sine","InOut",0.1/speed)
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.1/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.1/speed)
			end
			local sum = summoning:Clone()
			sum.Parent = rootpart
			sum:Play()
			for i = 0,5,.1 do
				Swait()
				SetTween(tridentweld,{C0=tridentc0*cf(.3, -3, -1) * angles(rad(-25), rad(90), rad(-70))},"Quad","InOut",.1/speed)
				
				SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(0))},"Quad","Out",.3/speed)
				SetTween(NeckW,{C0=NeckCF*angles(rad(10), rad(0), rad(0))},"Quad","InOut",0.1/speed)
				SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), 0) * angles(rad(90),rad(0),rad(-45))},"Sine","InOut",0.1/speed)
				SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), 0) * angles(rad(90),rad(0),rad(45))},"Sine","InOut",0.1/speed)
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.1/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.1/speed)
			end
			wait(2)
			sum:Destroy()
		end)()
	wait(.8)
		trident.fire.Enabled = false
		ts:Create(trident,tweeninfo(1,"Sine","InOut"),{Size = Vector3.new(0,0,0),Transparency = 1}):Play()
		wait(1)
		hum.WalkSpeed = 35
		walkspeedval = 35
		running = true
		inputremote:Fire("doidleeffects")
		attacking = false
		
	elseif running == true then
		attacking = false
		inputremote:Fire("doidleeffects")
		hum.WalkSpeed = 0
		coroutine.wrap(function()
			for i = 0,5,.1 do
				Swait()
				SetTween(tridentweld,{C0=tridentc0*cf(.3, -3, -1) * angles(rad(-25), rad(90), rad(-70))},"Quad","InOut",.1/speed)
				
				SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(0))},"Quad","Out",.3/speed)
				SetTween(NeckW,{C0=NeckCF*angles(rad(10), rad(0), rad(0))},"Quad","InOut",0.1/speed)
				SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), 0) * angles(rad(90),rad(0),rad(-45))},"Sine","InOut",0.1/speed)
				SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), 0) * angles(rad(90),rad(0),rad(45))},"Sine","InOut",0.1/speed)
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.1/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.1/speed)
			end
			local sum = summoning:Clone()
			sum.Parent = rootpart
			sum:Play()
			for i = 0,5,.1 do	
				Swait()
				SetTween(tridentweld,{C0=tridentc0*cf(.3, -3, -1) * angles(rad(-25), rad(90), rad(-70))},"Quad","InOut",.1/speed)
				
				SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(0))},"Quad","Out",.3/speed)
				SetTween(NeckW,{C0=NeckCF*angles(rad(10), rad(0), rad(0))},"Quad","InOut",0.1/speed)
				SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), .2) * angles(rad(90),rad(0),rad(0))},"Sine","InOut",0.1/speed)
				SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), -.2) * angles(rad(90),rad(0),rad(0))},"Sine","InOut",0.1/speed)
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.1/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.1/speed)
			end
			trident.fire.Enabled = true
			wait(.5)
			local gr = grabsound:Clone()
			gr.Parent = rootpart
			gr:Play()
			wait(1)
			gr:Destroy()
			sum:Destroy()
		end)()
		wait(.8)
		ts:Create(trident,tweeninfo(1,"Sine","InOut"),{Size = tridentsize,Transparency = 0}):Play()
		wait(1)
		walkspeedval = 20
		hum.WalkSpeed = 20
		running = false
		inputremote:Fire("doidleeffects")
		attacking = false
		
	end
end

rootpart.ChildRemoved:Connect(function()
	if not rootpart:FindFirstChild("The last soul") then
		theme = makesound({rootpart,origid,volume,true,true,"The last soul",10})
	end
end)

plr.Chatted:Connect(function(m)
	if sub(m,0,12) == "/e visualize" then
		inputremote:Fire("visualizemusic")
	elseif sub(m,0,5) == "/e id" then
		local h = 0
		for i,v in pairs(songlist) do
			if sub(m,7) == i then
				theme.SoundId = "rbxassetid://"..v
				origid = v
				h = h + 1
			end
		end
		theme.TimePosition = 0
		if h == 0 then
			theme.SoundId = "rbxassetid://"..sub(m,7)
			origid = sub(m,7)
		end
	elseif sub(m,0,16) == "/e effectstoggle" then
		inputremote:Fire("doidleffectsperm")
	elseif sub(m,0,10) == "/e timepos" then
		theme.TimePosition = sub(m,12)
	elseif sub(m,0,6) == "/e vol" then
		theme.Volume = sub(m,8)
		volume = sub(m,8)
	elseif sub(m,0,11) == "/e emitsize" then
		theme.EmitterSize = sub(m,13)
	else
		chatmessage(m)
	end	
end)


local uis = game:GetService("UserInputService")


local ContextActions = game:GetService("ContextActionService")
local actionNames = {}

local function bindMobileAction(name, title, key, callback, position)
    ContextActions:BindAction(name, function(_, state)
        if state == Enum.UserInputState.Begin then
            callback()
        end
        return Enum.ContextActionResult.Sink
    end, true, key)
    ContextActions:SetTitle(name, title)
    ContextActions:SetPosition(name, position)
    table.insert(actionNames, name)
    table.insert(actionBindings, name)
end

local function refreshMobileButtons()
    for _, name in ipairs(actionNames) do
        pcall(function()
            ContextActions:UnbindAction(name)
        end)
    end
    table.clear(actionNames)

    bindMobileAction("Determination_Handfire", "Handfire", Enum.KeyCode.G, function()
        if not attacking and not running then handfire() end
    end, UDim2.new(1, -130, 1, -130))

    bindMobileAction("Determination_ColoredSwing", "Color", Enum.KeyCode.E, function()
        if not attacking and not running then coloredswing() end
    end, UDim2.new(1, -180, 1, -130))

    bindMobileAction("Determination_Quote", "Quote", Enum.KeyCode.T, function()
        if not attacking and not running then randomquote() end
    end, UDim2.new(1, -230, 1, -130))

    bindMobileAction("Determination_Earthquake", "Earth", Enum.KeyCode.R, function()
        if not attacking and not running then earthquake() end
    end, UDim2.new(1, -130, 1, -180))

    bindMobileAction("Determination_Run", "Run", Enum.KeyCode.Z, function()
        if not attacking then run() end
    end, UDim2.new(1, -180, 1, -180))

    bindMobileAction("Determination_UltraStab", "Stab", Enum.KeyCode.F, function()
        if not attacking and not running then ultrastab() end
    end, UDim2.new(1, -230, 1, -180))

    bindMobileAction("Determination_Slower", "Speed-", Enum.KeyCode.N, function()
        if swingspeed > 0.3 then
            swingspeed -= 0.05
            chatmessage(plr.Name.." increased their attack speed!")
        end
    end, UDim2.new(1, -130, 1, -230))

    bindMobileAction("Determination_Faster", "Speed+", Enum.KeyCode.M, function()
        if swingspeed < 0.6 then
            swingspeed += 0.05
            chatmessage(plr.Name.." decreased their attack speed!")
        end
    end, UDim2.new(1, -180, 1, -230))
end

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if attacking or running then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        swing()
    end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.G then
            handfire()
        elseif input.KeyCode == Enum.KeyCode.E then
            coloredswing()
        elseif input.KeyCode == Enum.KeyCode.T then
            randomquote()
        elseif input.KeyCode == Enum.KeyCode.R then
            earthquake()
        elseif input.KeyCode == Enum.KeyCode.Z then
              run()
        elseif input.KeyCode == Enum.KeyCode.F then
            ultrastab()
        elseif input.KeyCode == Enum.KeyCode.N then
            if swingspeed > 0.3 then
                swingspeed -= 0.05

                chatmessage(plr.Name.." increased their attack speed!")
            end
        elseif input.KeyCode == Enum.KeyCode.M then
            if swingspeed < 0.6 then
                swingspeed += 0.05

                chatmessage(plr.Name.." decreased their attack speed!")
            end
        end
    end
end)

coroutine.wrap(function()
	wait(49)
	
	local rays = Instance.new("SunRaysEffect",game:GetService("Lighting"))
	rays.Intensity = 0
	rays.Name = "rays"
	ts:Create(rays,tweeninfo(1,"Sine","InOut"),{Intensity = .15}):Play()
	local as = atmosphere:Clone()
	as.Parent = game:GetService("Lighting")
	ts:Create(as,tweeninfo(1,"Sine","InOut"),{TintColor = Color3.new(1, 0.486275, 0.494118)}):Play()
	if workspace:FindFirstChild("Baseplate") then
		baseplatefire:Clone().Parent = workspace:FindFirstChild("Baseplate")
	elseif workspace:FindFirstChild("Base") then
		baseplatefire:Clone().Parent = workspace:FindFirstChild("Base")
	end
	wait(1)
	lightingeffects = true
	baseplateparticles = true
	idleeffects = true
	for i = 0,35,1 do
		Swait()
		local meshpart = Instance.new("Part",headshadingfolder)
		local mesh = Instance.new("SpecialMesh",meshpart)
		mesh.MeshType = "Head"
		mesh.Scale = Vector3.new(1.25,1.25,1.25)
		mesh.VertexColor = Vector3.new(1,1,1)
		meshpart.CanCollide = false
		meshpart.Color = Color3.fromRGB(0,0,0)
		meshpart.Material = Enum.Material.Fabric
		meshpart.Transparency = i/35
		meshpart.Position = torso.Position
		meshpart.Size = Vector3.new(1.01, 0.65, 1.01)
		meshpart.formFactor = 3
		local weld = Instance.new("Weld",meshpart)
		weld.Part0 = char.Head
		weld.Part1 = meshpart
		weld.C0 = CFrame.new(0, 0.28 - (i - 1) / 110, 0)
		weld.C1 = CFrame.new(0,0,0)
	end
end)()

coroutine.wrap(function()
	repeat wait(.1) until idleeffects == true
	inputremote:Fire("doidleeffects")
	local c = 0
	
end)()
workspace.Terrain:ClearAllChildren()
game:GetService("RunService").Heartbeat:Connect(function()
	Swait()
	game.JointsService:ClearAllChildren()
	
	
	sine = sine + change
	local hitfloor = rayCast(rootpart.Position, cf(rootpart.Position, rootpart.Position - Vector3.new(0, 1, 0)).lookVector, 4, char)
	
	local Ccf=torso.CFrame
	local Walktest1 = hum.MoveDirection*Ccf.LookVector
	local Walktest2 = hum.MoveDirection*Ccf.RightVector
	forWFB = Walktest1.X+Walktest1.Z
	forWRL = Walktest2.X+Walktest2.Z
	local torvel = (hum.MoveDirection * Vector3.new(1, 0, 1)).magnitude
	
	if rootpart.Velocity.y > 1 and hitfloor == nil then
		Anim = "Jump"
	elseif rootpart.Velocity.y < -1 and hitfloor == nil then
		Anim = "Fall"
	elseif hum.Sit == true then
		Anim = "Sit"	
	elseif torvel < .5 and hitfloor ~= nil  then
		Anim = "Idle"
	elseif torvel > .5 and  hitfloor ~= nil  then
		Anim = "Walk"
	else
		Anim = ""
	end 
	
	

	hum.MaxHealth = 0/0
	hum.Health = 0/0
	
	
	
	sine = sine + change
	if attacking == false then
		if Anim == "Walk" then
			if running == false then
				local RH2 = cf(-forWRL/7 * cos(sine / 25 ),0,forWFB/7 * cos(sine / 25 ))*angles(sin(-forWFB) * cos(sine / 25 ),0,sin(-forWRL) * cos(sine / 25 ))
				local LH2 = cf(forWRL/7 * cos(sine / 25 ),0,-forWFB/7 * cos(sine / 25 ))*angles(sin(forWFB) * cos(sine / 25 ),0,sin(forWRL) * cos(sine / 25 ))
				
				SetTween(tridentweld,{C0=tridentc0*cf(.6, -3, -.4) * angles(rad(-25), rad(35), rad(-80))},"Quad","InOut",.1/speed)
				
				SetTween(RJW,{C0=RootCF*cf(0, 0 , -0.185 + 0.055 * cos(sine / 25) + -sin(sine / 25) / 8) * angles(rad((forWFB*2  - forWFB)*4), rad((-forWRL - -forWRL)*2) , rad(25*forWRL+8 ))},"Quad","InOut",.1/speed)
				SetTween(NeckW,{C0=NeckCF*cf(0, 0, 0) * angles((rad(20+(-forWFB*2 - -forWFB  )*8))+rad(0), rad((forWRL - forWRL)*1)+rad(0), rad(-45*forWRL-2))},"Quad","InOut",.1/speed)
				SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), .2) * angles(rad(105 - 2*cos(sine/150)),rad(0),rad(0))},"Sine","InOut",0.1/speed)
				SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), -.2) * angles(rad(55 - 2*cos(sine/150)),rad(0),rad(0))},"Sine","InOut",0.1/speed)
				SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/25 ), 0+.15* cos(sine/25 ))*RH2 * angles(rad(0 - 5 * cos(sine/25)),rad(0),rad(2.5- 0.0 * cos(sine/25)))},"Sine","InOut",.1/speed)
				SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/25 ), 0-.15* cos(sine/25 ))*LH2 * angles(rad(0 + 5 * cos(sine/25)),rad(0),rad(-2.5- 0.0 * cos(sine/25)))},"Sine","InOut",.1/speed)
			elseif running == true then
				local RH2 = cf(-forWRL/7 * cos(sine / 20 ),0,forWFB/7 * cos(sine / 20 ))*angles(sin(-forWFB) * cos(sine / 20 ),0,sin(-forWRL) * cos(sine / 20 ))
				local LH2 = cf(forWRL/7 * cos(sine / 20 ),0,-forWFB/7 * cos(sine / 20 ))*angles(sin(forWFB) * cos(sine / 20 ),0,sin(forWRL) * cos(sine / 20 ))
				
				SetTween(tridentweld,{C0=tridentc0*cf(.6, -3, -.4) * angles(rad(-25), rad(35), rad(-80))},"Sine","InOut",.1/speed)
				
				SetTween(RJW,{C0=RootCF*cf(0, 0 , -0.185 + 0.055 * cos(sine / 20) + -sin(sine / 20) / 8) * angles(rad((forWFB*2  - forWFB*cos(sine/20))*4), rad((-forWRL - -forWRL*cos(sine/20))*2) , rad(25*forWRL-10  *cos(sine/20)))},"Sine","InOut",.07/speed)
				SetTween(NeckW,{C0=NeckCF*cf(0, 0, 0) * angles((rad(20+(-forWFB*2 - -forWFB  )*8))+rad(0), rad((forWRL - forWRL)*1)+rad(0), rad(-45*forWRL-2))},"Sine","InOut",.07/speed)
				SetTween(RW,{C0=cf(1.5, .5 + .08*cos(sine/75), 0) * angles(rad(0-forWFB*75*cos(sine/20)),rad(0+forWFB*20*cos(sine/20)),rad(0+forWFB*20*cos(sine/20)))},"Sine","InOut",.05/speed)
				SetTween(LW,{C0=cf(-1.5, .5 + .08*cos(sine/75), 0) * angles(rad(0+forWFB*75*cos(sine/20)),rad(0+forWFB*20*cos(sine/20)),rad(0+forWFB*20*cos(sine/20)))},"Sine","InOut",.05/speed)
				SetTween(RH,{C0=cf(.5, -0.75+ .35 * sin(sine/20 ), 0+.15* cos(sine/20 ))*RH2 * angles(rad(0 - 5 * cos(sine/20)),rad(0),rad(2.5- 0.0 * cos(sine/20)))},"Sine","InOut",.05/speed)
				SetTween(LH,{C0=cf(-.5, -0.75- .35 * sin(sine/20 ), 0-.15* cos(sine/20 ))*LH2 * angles(rad(0 + 5 * cos(sine/20)),rad(0),rad(-2.5- 0.0 * cos(sine/20)))},"Sine","InOut",.05/speed)
			end
		elseif Anim == "Idle" then
			
			if running == false then
				SetTween(tridentweld,{C0=tridentc0*cf(.6, -3, -.4) * angles(rad(-25), rad(35), rad(-80))},"Quad","InOut",.1/speed)
				
				SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(10))},"Quad","Out",.3/speed)
				SetTween(NeckW,{C0=NeckCF*angles(rad(30 + 2*cos(sine/75)), rad(0), rad(-10))},"Quad","InOut",0.1/speed)
				SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), .2) * angles(rad(105 - 2*cos(sine/150)),rad(0),rad(0))},"Sine","InOut",0.1/speed)
				SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), -.2) * angles(rad(55 - 2*cos(sine/150)),rad(0),rad(0))},"Sine","InOut",0.1/speed)
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.1/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.1/speed)
			elseif running == true then
				SetTween(tridentweld,{C0=tridentc0*cf(.6, -3, -.4) * angles(rad(-25), rad(35), rad(-80))},"Quad","InOut",.1/speed)
				
				SetTween(RJW,{C0=RootCF*cf(0, 0, 0) * angles(rad(0), rad(0), rad(10))},"Quad","Out",.3/speed)
				SetTween(NeckW,{C0=NeckCF*angles(rad(0+2*cos(sine/150)), rad(0), rad(-10))},"Quad","InOut",0.1/speed)
				SetTween(RW,{C0=cf(1.5, .5 + .05*cos(sine/75), .1) * angles(rad(0),rad(-10),rad(5 - 2*cos(sine/150)))},"Sine","InOut",0.1/speed)
				SetTween(LW,{C0=cf(-1.5, .5 + .05*cos(sine/75), .1) * angles(rad(0),rad(10),rad(-5 + 2*cos(sine/150)))},"Sine","InOut",0.1/speed)
				SetTween(RH,{C0=cf(.5, -1, 0) * angles(rad(0),rad(-5),rad(5))},"Quad","InOut",0.1/speed)
				SetTween(LH,{C0=cf(-.5, -1, 0) * angles(rad(0),rad(5),rad(-5))},"Quad","InOut",0.1/speed)
			end
		elseif Anim == "Jump" then
			change = 0.60*2
			SetTween(tridentweld,{C0=tridentc0*cf(0, -2, 0) * angles(rad(0), rad(-35), rad(-190))},"Quad","InOut",.05/speed)
			
			SetTween(RJW,{C0=RootCF* cf(0, 0 + (0.0395/2) * cos(sine / 250), -0.1 + 0.0395 * cos(sine / 250)) * angles(rad(-6.5 - 1.5 * cos(sine / 250))+(0*forWFB)/2, rad(0)-(0*forWRL)/2, rad(0))},"Quad","Out",0.25)
			SetTween(NeckW,{C0=NeckCF*cf(0,0,0)*angles(rad(-26.5 + 2.5 * cos(sine / 250)), rad(0), rad(-0))},"Quad","Out",0.25)
			SetTween(RW,{C0=cf(1.5, .5 + .05 * cos(sine / 250), 0) * angles(rad(20 - 2 * cos(sine / 250 )), rad(-5), rad(8 + 4 * cos(sine / 250)))},"Quad","Out",0.2)
			SetTween(LW,{C0=cf(-1.5, .5 + .05 * cos(sine / 250), 0) * angles(rad(20 - 2 * cos(sine / 250 )), rad(5), rad(-8 - 4 * cos(sine / 250 )))},"Quad","Out",0.2)
			SetTween(RH,{C0=cf(.5, -.5,-.3) * angles(rad(-15 -1* cos(sine / 20)),rad(0),rad(0))},"Quad","InOut",0.075)
			SetTween(LH,{C0=cf(-.5, -.8,-.1) * angles(rad(-25 +1* cos(sine / 20)),rad(0),rad(0))},"Quad","InOut",0.075)
		elseif Anim == "Fall" then 
			change = 0.60*2
			SetTween(RJW,{C0=RootCF*cf(0, 0 + (0.0395/2) * cos(sine / 250), -0.5 + 0.0395 * cos(sine / 250)) * angles(rad(-torso.Velocity.Y/6)-(0*forWFB)/2, rad(0)+(0*forWRL)/2, rad(0))},"Quad","Out",0.35)
			SetTween(NeckW,{C0=NeckCF*cf(0,0,0)*angles(rad(26.5 + 2.5 * cos(sine / 250)), rad(0), rad(-0))},"Quad","Out",0.25)
			SetTween(RW,{C0=cf(1.5, .5 + .05 * cos(sine / 250), 0) * angles(rad(105 - 2 * cos(sine / 250 )), rad(-15), rad(80 + 4 * cos(sine / 250)))},"Quad","Out",0.2) 
			SetTween(LW,{C0=cf(-1.5, .5 + .05 * cos(sine / 250), 0) * angles(rad(105 - 2 * cos(sine / 250 )), rad(15), rad(-80 - 4 * cos(sine / 250 )))},"Quad","Out",0.2) 
			SetTween(RH,{C0=cf(.5, -.5,-.3) * angles(rad(-15),rad(0),rad(0))},"Quad","InOut",0.075)
			SetTween(LH,{C0=cf(-.5, -.8,-.1) * angles(rad(-25),rad(0),rad(0))},"Quad","InOut",0.075)
		end
	end
end)
        refreshMobileButtons()
    end

    m.Update = function(dt, figure)
        return
    end

    m.Destroy = function()
        moduleAlive = false
        for _, name in ipairs(actionBindings) do
            pcall(function() ContextActions:UnbindAction(name) end)
        end
        table.clear(actionBindings)
        table.clear(flingDebounce)
        if sound1 then pcall(function() sound1:Stop() sound1:Destroy() end) sound1 = nil end
        if sound2 then pcall(function() sound2:Stop() sound2:Destroy() end) sound2 = nil end
        if Character then
            local effects = Character:FindFirstChild("Effects")
            if effects then effects:Destroy() end
        end
        for _, connection in ipairs(updateConnections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(updateConnections)
        if assetObject and assetObject.Parent then
            assetObject:Destroy()
        end
        assetObject = nil
        assetScript = nil
        Character = nil
		for _, v in Players.LocalPlayer.PlayerGui:GetDescendants() do
			if v.Name == "crefunnies" or v.Name == "flash" then
				v:Destroy()
			end
		end
		for _, v in workspace:GetDescendants() do
			if v.Name == "baseplatefire" then
				v:Destroy()
			end
		end
		pcall(function() if game.Lighting.atomsphere then game.Lighting.atomsphere:Destroy() end end)
    end

    return m
end)

return modules
