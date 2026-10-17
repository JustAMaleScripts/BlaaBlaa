local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActions = game:GetService("ContextActionService")
local Player = Players.LocalPlayer

local modules = {}
local function AddModule(factory)
    table.insert(modules, factory)
end

AddModule(function()
    local m = {}
    m.ModuleType = "MOVESET"
    m.Name = "Noob Switcher V5"
    m.InternalName = "NoobSwitcherV5"
    m.Description = "My favorite old script!"
    m.Assets = {"Time.mp3", "Light.mp3", "Warak.mp3", "Noobz4life.mp3", "Robot.mp3", "Banish.mp3", "Dominus.mp3"}
    m.Config = function(parent) end

    local Character
    local moduleAlive = false
    local actionBindings = {}
    local updateConnection
    local assetObject
    local assetScript
    local mouse
    local legacyHeartbeatConnection
    local heartbeatEvent
    local animationThread
    local RefreshContextButtons
    local song

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

    local function FindRealCharacter()
        local lp = Players.LocalPlayer
        if not lp then
            return nil
        end

        local wanted = tostring(lp.Name)
        local fake = lp.Character

        for _, inst in ipairs(workspace:GetChildren()) do
            if inst:IsA("Model") and inst.Name == wanted and inst ~= fake then
                return inst
            end
        end

        for _, inst in ipairs(workspace:GetDescendants()) do
            if inst:IsA("Model") and inst.Name == wanted and inst ~= fake then
                return inst
            end
        end

        local onlyMatch
        for _, inst in ipairs(workspace:GetDescendants()) do
            if inst:IsA("Model") and inst.Name == wanted then
                if onlyMatch then
                    return nil
                end
                onlyMatch = inst
            end
        end
        return onlyMatch
    end

    m.Init = function(figure)
        if moduleAlive then return end

        local animationCharacter = figure

        if not animationCharacter or not animationCharacter:IsA("Model") then
            return
        end



        local realCharacter = FindRealCharacter()
        if (not realCharacter or realCharacter == animationCharacter)
            and Player.Character and Player.Character ~= animationCharacter then
            realCharacter = Player.Character
        end

        if not realCharacter then
            return
        end


        Character = animationCharacter


        local ColorCharacter = realCharacter



        local deadline = os.clock() + 10
        while os.clock() < deadline do
            local h = Character:FindFirstChildOfClass("Humanoid")
            local r = Character:FindFirstChild("HumanoidRootPart")
            local t = Character:FindFirstChild("Torso")
            local hd = Character:FindFirstChild("Head")
            if h and r and t and hd then
                break
            end
            task.wait()
        end


        local function StripAvatarAppearance(model)
            if not model then return end
            for _, obj in ipairs(model:GetChildren()) do
                if obj:IsA("Accessory")
                    or obj:IsA("Shirt")
                    or obj:IsA("Pants")
                    or obj:IsA("ShirtGraphic") then
                    obj:Destroy()
                end
            end
        end

        StripAvatarAppearance(realCharacter)



        assetObject = game:GetObjects("rbxassetid://4654502164")[1]
        if not assetObject then
            return
        end
        assetObject.Parent = workspace
        assetScript = assetObject:FindFirstChild("noob") or assetObject

        local sounds = {"Time.mp3", "Light.mp3", "Warak.mp3", "Noobz4life.mp3", "Robot.mp3", "Banish.mp3", "Dominus.mp3"}
        for _, name in ipairs(sounds) do
            if not isfile(name) then
                writefile(name, game:HttpGet("https://github.com/ian49972/smth/raw/refs/heads/main/" .. name))
            end
        end


        local Player = Players.LocalPlayer
        local Mouse = Player:GetMouse()
        mouse = Mouse
        local PlayerGui = Player:FindFirstChildOfClass("PlayerGui")
        local Cam = workspace.CurrentCamera
        local Backpack = Player:FindFirstChildOfClass("Backpack")



        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        local Torso = Character:FindFirstChild("Torso")
        local Head = Character:FindFirstChild("Head")
        local RightArm = Character:FindFirstChild("Right Arm")
        local LeftArm = Character:FindFirstChild("Left Arm")
        local RightLeg = Character:FindFirstChild("Right Leg")
        local LeftLeg = Character:FindFirstChild("Left Leg")
        local RootJoint = RootPart and RootPart:FindFirstChild("RootJoint")
        local Neck = Torso and Torso:FindFirstChild("Neck")
        local RightShoulder = Torso and Torso:FindFirstChild("Right Shoulder")
        local LeftShoulder = Torso and Torso:FindFirstChild("Left Shoulder")
        local RightHip = Torso and Torso:FindFirstChild("Right Hip")
        local LeftHip = Torso and Torso:FindFirstChild("Left Hip")

        if not (Humanoid and RootPart and Torso and Head and RightArm and LeftArm and RightLeg and LeftLeg and RootJoint and Neck and RightShoulder and LeftShoulder and RightHip and LeftHip) then
            if assetObject then assetObject:Destroy() end
            assetObject, assetScript = nil, nil
            return
        end


        _G.NoobSwitcherV5Character = Character

IT = Instance.new
CF = CFrame.new
VT = Vector3.new
RAD = math.rad
C3 = Color3.new
UD2 = UDim2.new
BRICKC = BrickColor.new
ANGLES = CFrame.Angles
EULER = CFrame.fromEulerAnglesXYZ
COS = math.cos
ACOS = math.acos
SIN = math.sin
ASIN = math.asin
ABS = math.abs
MRANDOM = math.random
FLOOR = math.floor

Animation_Speed = 3
Frame_Speed = 1 / 60
local Speed = 20
local SIZE = 1
local Player_Size = 1
local ROOTC0 = CF(0, 0, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
local NECKC0 = CF(0, 1, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
local RIGHTSHOULDERC0 = CF(-0.5, 0, 0) * ANGLES(RAD(0), RAD(90), RAD(0))
local LEFTSHOULDERC0 = CF(0.5, 0, 0) * ANGLES(RAD(0), RAD(-90), RAD(0))
local DAMAGEMULTIPLIER = 1
local ANIM = "Idle"
local ATTACK = false
local EQUIPPED = false
local HOLD = false
local COMBO = 1
local Rooted = false
local SINE = 0
local KEYHOLD = false
local CHANGE = 2 / Animation_Speed
local WALKINGANIM = false
local VALUE1 = false
local VALUE2 = false
local ROBLOXIDLEANIMATION = IT("Animation")
ROBLOXIDLEANIMATION.Name = "Roblox Idle Animation"
ROBLOXIDLEANIMATION.AnimationId = "http://www.roblox.com/asset/?id=180435571"
local ATANIM = IT("Animation")
ATANIM.Name = "Attack Animation"
ATANIM.AnimationId = "http://www.roblox.com/asset/?id=74894663"

local WEAPONGUI
if PlayerGui then
    WEAPONGUI = IT("ScreenGui")
    WEAPONGUI.Name = "Weapon GUI"
    WEAPONGUI.Parent = PlayerGui
end
local Effects = IT("Folder", Character)
Effects.Name = "Effects"

local ANIMATOR = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
local ANIMATE = Character:FindFirstChild("Animate")
local UNANCHOR = true

local function unanchor()



    if not Character then return end

    if UNANCHOR == true and RootPart then
        RootPart.Anchored = false
    end

    for _, obj in ipairs(Character:GetChildren()) do
        if obj:IsA("Part") and obj ~= RootPart then
            obj.Anchored = false
        end
    end



    if noob then
        for _, obj in ipairs(noob:GetChildren()) do
            if obj:IsA("Part") then
                obj.Anchored = false
            end
        end
    end
end

local ReanimateFlingTarget

local CLOCKLOOP = 0
local CLOCKTARGET = nil
local CLOCKSPEED = 1
local CLONE




pcall(function()
    CLONE = Character:Clone()
end)
if CLONE then
    if CLONE then CLONE.Parent = nil end
end
Character.Archivable = false
local sick = Instance.new("Sound",Torso)


local mode = "noob"


local dark = IT("Model")
local dominus = IT("Model")
local master = IT("Model")
local banish = IT("Model")
local noob = IT("Model")
local Robot = IT("Model")
local lg = IT("Model")

Robot.Parent = nil
lg.Parent = nil

dark.Parent = nil
banish.Parent = nil
master.Parent = nil
dominus.Parent = nil
noob.Parent = nil









heartbeatEvent = Instance.new("BindableEvent")
local ArtificialHB = heartbeatEvent
ArtificialHB.Name = "ArtificialHB"

local frame = Frame_Speed
local tf = 0
local allowframeloss = false
local tossremainder = false
local lastframe = tick()
local heartbeatConnection = RunService.Heartbeat:Connect(function(s)
    tf = tf + s
    if tf >= frame then
        if allowframeloss then
            ArtificialHB:Fire()
            lastframe = tick()
        else
            for i = 1, math.floor(tf / frame) do
                ArtificialHB:Fire()
            end
            lastframe = tick()
        end
        if tossremainder then
            tf = 0
        else
            tf = tf - frame * math.floor(tf / frame)
        end
    end
end)








function Raycast(POSITION, DIRECTION, RANGE, IGNOREDECENDANTS)
	return workspace:FindPartOnRay(Ray.new(POSITION, DIRECTION.unit * RANGE), IGNOREDECENDANTS)
end

function PositiveAngle(NUMBER)
	if NUMBER >= 0 then
		NUMBER = 0
	end
	return NUMBER
end

function NegativeAngle(NUMBER)
	if NUMBER <= 0 then
		NUMBER = 0
	end
	return NUMBER
end

function Swait(NUMBER)
	if NUMBER == 0 or NUMBER == nil then
		ArtificialHB.Event:Wait()
	else
		for i = 1, NUMBER do
			ArtificialHB.Event:Wait()
		end
	end
end

function CreateMesh(MESH, PARENT, MESHTYPE, MESHID, TEXTUREID, SCALE, OFFSET)
	local NEWMESH = IT(MESH)
	if MESH == "SpecialMesh" then
		NEWMESH.MeshType = MESHTYPE
		if MESHID ~= "nil" and MESHID ~= "" then
			NEWMESH.MeshId = "http://www.roblox.com/asset/?id="..MESHID
		end
		if TEXTUREID ~= "nil" and TEXTUREID ~= "" then
			NEWMESH.TextureId = "http://www.roblox.com/asset/?id="..TEXTUREID
		end
	end
	NEWMESH.Offset = OFFSET or VT(0, 0, 0)
	NEWMESH.Scale = SCALE
	NEWMESH.Parent = PARENT
	return NEWMESH
end

function CreatePart(FORMFACTOR, PARENT, MATERIAL, REFLECTANCE, TRANSPARENCY, BRICKCOLOR, NAME, SIZE, ANCHOR)
	local NEWPART = IT("Part")
	NEWPART.formFactor = FORMFACTOR
	NEWPART.Reflectance = REFLECTANCE
	NEWPART.Transparency = TRANSPARENCY
	NEWPART.CanCollide = false
	NEWPART.Locked = true
	NEWPART.Anchored = true
	if ANCHOR == false then
		NEWPART.Anchored = false
	end
	NEWPART.BrickColor = BRICKC(tostring(BRICKCOLOR))
	NEWPART.Name = NAME
	NEWPART.Size = SIZE
	NEWPART.Position = Torso.Position
	NEWPART.Material = MATERIAL
	NEWPART:BreakJoints()
	NEWPART.Parent = PARENT
	return NEWPART
end

	local function weldBetween(a, b)
	    local weldd = Instance.new("ManualWeld")
	    weldd.Part0 = a
	    weldd.Part1 = b
	    weldd.C0 = CFrame.new()
	    weldd.C1 = b.CFrame:inverse() * a.CFrame
	    weldd.Parent = a
	    return weldd
	end


function QuaternionFromCFrame(cf)
	local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components()
	local trace = m00 + m11 + m22
	if trace > 0 then
		local s = math.sqrt(1 + trace)
		local recip = 0.5 / s
		return (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip, s * 0.5
	else
		local i = 0
		if m11 > m00 then
			i = 1
		end
		if m22 > (i == 0 and m00 or m11) then
			i = 2
		end
		if i == 0 then
			local s = math.sqrt(m00 - m11 - m22 + 1)
			local recip = 0.5 / s
			return 0.5 * s, (m10 + m01) * recip, (m20 + m02) * recip, (m21 - m12) * recip
		elseif i == 1 then
			local s = math.sqrt(m11 - m22 - m00 + 1)
			local recip = 0.5 / s
			return (m01 + m10) * recip, 0.5 * s, (m21 + m12) * recip, (m02 - m20) * recip
		elseif i == 2 then
			local s = math.sqrt(m22 - m00 - m11 + 1)
			local recip = 0.5 / s return (m02 + m20) * recip, (m12 + m21) * recip, 0.5 * s, (m10 - m01) * recip
		end
	end
end

function QuaternionToCFrame(px, py, pz, x, y, z, w)
	local xs, ys, zs = x + x, y + y, z + z
	local wx, wy, wz = w * xs, w * ys, w * zs
	local xx = x * xs
	local xy = x * ys
	local xz = x * zs
	local yy = y * ys
	local yz = y * zs
	local zz = z * zs
	return CFrame.new(px, py, pz, 1 - (yy + zz), xy - wz, xz + wy, xy + wz, 1 - (xx + zz), yz - wx, xz - wy, yz + wx, 1 - (xx + yy))
end

function QuaternionSlerp(a, b, t)
	local cosTheta = a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
	local startInterp, finishInterp;
	if cosTheta >= 0.0001 then
		if (1 - cosTheta) > 0.0001 then
			local theta = ACOS(cosTheta)
			local invSinTheta = 1 / SIN(theta)
			startInterp = SIN((1 - t) * theta) * invSinTheta
			finishInterp = SIN(t * theta) * invSinTheta
		else
			startInterp = 1 - t
			finishInterp = t
		end
	else
		if (1 + cosTheta) > 0.0001 then
			local theta = ACOS(-cosTheta)
			local invSinTheta = 1 / SIN(theta)
			startInterp = SIN((t - 1) * theta) * invSinTheta
			finishInterp = SIN(t * theta) * invSinTheta
		else
			startInterp = t - 1
			finishInterp = t
		end
	end
	return a[1] * startInterp + b[1] * finishInterp, a[2] * startInterp + b[2] * finishInterp, a[3] * startInterp + b[3] * finishInterp, a[4] * startInterp + b[4] * finishInterp
end

function Clerp(a, b, t)
	local qa = {QuaternionFromCFrame(a)}
	local qb = {QuaternionFromCFrame(b)}
	local ax, ay, az = a.x, a.y, a.z
	local bx, by, bz = b.x, b.y, b.z
	local _t = 1 - t
	return QuaternionToCFrame(_t * ax + t * bx, _t * ay + t * by, _t * az + t * bz, QuaternionSlerp(qa, qb, t))
end

function CreateFrame(PARENT, TRANSPARENCY, BORDERSIZEPIXEL, POSITION, SIZE, COLOR, BORDERCOLOR, NAME)
	local frame = IT("Frame")
	frame.BackgroundTransparency = TRANSPARENCY
	frame.BorderSizePixel = BORDERSIZEPIXEL
	frame.Position = POSITION
	frame.Size = SIZE
	frame.BackgroundColor3 = COLOR
	frame.BorderColor3 = BORDERCOLOR
	frame.Name = NAME
	frame.Parent = PARENT
	return frame
end

function CreateLabel(PARENT, TEXT, TEXTCOLOR, TEXTFONTSIZE, TEXTFONT, TRANSPARENCY, BORDERSIZEPIXEL, STROKETRANSPARENCY, NAME)
	local label = IT("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UD2(1, 0, 1, 0)
	label.Position = UD2(0, 0, 0, 0)
	label.TextColor3 = TEXTCOLOR
	label.TextStrokeTransparency = STROKETRANSPARENCY
	label.TextTransparency = TRANSPARENCY
	label.FontSize = TEXTFONTSIZE
	label.Font = TEXTFONT
	label.BorderSizePixel = BORDERSIZEPIXEL
	label.TextStrokeColor3 = C3(1,1,1)
	label.TextScaled = false
	label.Text = TEXT
	label.Name = NAME
	label.Parent = PARENT
	return label
end

local FXFolder = assetScript:FindFirstChild'Effects'
FXFolder.Parent = nil

NewInstance = function(instance,parent,properties)
	local inst = Instance.new(instance)
	inst.Parent = parent
	if(properties)then
		for i,v in next, properties do
			pcall(function() inst[i] = v end)
		end
	end
	return inst;
end

function CamShake(who,times,intense,origin)
	coroutine.wrap(function()
		if(FXFolder:FindFirstChild'CamShake')then
			local cam = FXFolder.CamShake:Clone()
			cam:WaitForChild'intensity'.Value = intense
			cam:WaitForChild'times'.Value = times

	 		if(origin)then NewInstance((typeof(origin) == 'Instance' and "ObjectValue" or typeof(origin) == 'Vector3' and 'Vector3Value'),cam,{Name='origin',Value=origin}) end
			cam.Parent = who
			wait()
			cam.Disabled = false
		end
	end)()
end

local S = setmetatable({},{__index = function(s,i) return game:service(i) end})
local Plrs = S.Players

function CamShakeAll(times,intense,origin)
	for _,v in next, Plrs:players() do
		CamShake(v:FindFirstChildOfClass'PlayerGui' or v:FindFirstChildOfClass'Backpack' or v.Character,times,intense,origin)
	end
end

function NoOutlines(PART)
	PART.TopSurface, PART.BottomSurface, PART.LeftSurface, PART.RightSurface, PART.FrontSurface, PART.BackSurface = 10, 10, 10, 10, 10, 10
end

function CreateWeldOrSnapOrMotor(TYPE, PARENT, PART0, PART1, C0, C1)
	local NEWWELD = IT(TYPE)
	NEWWELD.Part0 = PART0
	NEWWELD.Part1 = PART1
	NEWWELD.C0 = C0
	NEWWELD.C1 = C1
	NEWWELD.Parent = PARENT
	return NEWWELD
end

local S = IT("Sound")
function CreateSound(ID, PARENT, VOLUME, PITCH, DOESLOOP)
	local NEWSOUND = nil
	coroutine.resume(coroutine.create(function()
		NEWSOUND = S:Clone()
		NEWSOUND.Parent = PARENT
		NEWSOUND.Volume = VOLUME
		NEWSOUND.Pitch = PITCH
		NEWSOUND.SoundId = "http://www.roblox.com/asset/?id="..ID
		NEWSOUND:play()
		if DOESLOOP == true then
			NEWSOUND.Looped = true
		else
			repeat wait(1) until NEWSOUND.Playing == false
			NEWSOUND:remove()
		end
	end))
	return NEWSOUND
end

function CFrameFromTopBack(at, top, back)
	local right = top:Cross(back)
	return CF(at.x, at.y, at.z, right.x, top.x, back.x, right.y, top.y, back.y, right.z, top.z, back.z)
end


function WACKYEFFECT(Table)
	local TYPE = (Table.EffectType or "Sphere")
	local SIZE = (Table.Size or VT(1,1,1))
	local ENDSIZE = (Table.Size2 or VT(0,0,0))
	local TRANSPARENCY = (Table.Transparency or 0)
	local ENDTRANSPARENCY = (Table.Transparency2 or 1)
	local CFRAME = (Table.CFrame or Torso.CFrame)
	local MOVEDIRECTION = (Table.MoveToPos or nil)
	local ROTATION1 = (Table.RotationX or 0)
	local ROTATION2 = (Table.RotationY or 0)
	local ROTATION3 = (Table.RotationZ or 0)
	local MATERIAL = (Table.Material or "Neon")
	local COLOR = (Table.Color or C3(1,1,1))
	local TIME = (Table.Time or 45)
	local SOUNDID = (Table.SoundID or nil)
	local SOUNDPITCH = (Table.SoundPitch or nil)
	local SOUNDVOLUME = (Table.SoundVolume or nil)
	coroutine.resume(coroutine.create(function()
		local PLAYSSOUND = false
		local SOUND = nil
		local EFFECT = CreatePart(3, Effects, MATERIAL, 0, TRANSPARENCY, BRICKC("Pearl"), "Effect", VT(1,1,1), true)
		if SOUNDID ~= nil and SOUNDPITCH ~= nil and SOUNDVOLUME ~= nil then
			PLAYSSOUND = true
			SOUND = CreateSound(SOUNDID, EFFECT, SOUNDVOLUME, SOUNDPITCH, false)
		end
		EFFECT.Color = COLOR
		local MSH = nil
		if TYPE == "Sphere" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "Sphere", "", "", SIZE, VT(0,0,0))
		elseif TYPE == "Block" then
			MSH = IT("BlockMesh",EFFECT)
			MSH.Scale = VT(SIZE.X,SIZE.X,SIZE.X)
		elseif TYPE == "Wave" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "20329976", "", SIZE, VT(0,0,-SIZE.X/8))
		elseif TYPE == "Ring" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "559831844", "", VT(SIZE.X,SIZE.X,0.1), VT(0,0,0))
		elseif TYPE == "Slash" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "662586858", "", VT(SIZE.X/10,0,SIZE.X/10), VT(0,0,0))
		elseif TYPE == "Round Slash" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "662585058", "", VT(SIZE.X/10,0,SIZE.X/10), VT(0,0,0))
		elseif TYPE == "Swirl" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "1051557", "", SIZE, VT(0,0,0))
		elseif TYPE == "Skull" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "4770583", "", SIZE, VT(0,0,0))
		elseif TYPE == "Crystal" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "9756362", "", SIZE, VT(0,0,0))
		end
		if MSH ~= nil then
			local MOVESPEED = nil
			if MOVEDIRECTION ~= nil then
				MOVESPEED = (CFRAME.p - MOVEDIRECTION).Magnitude/TIME
			end
			local GROWTH = SIZE - ENDSIZE
			local TRANS = TRANSPARENCY - ENDTRANSPARENCY
			if TYPE == "Block" then
				EFFECT.CFrame = CFRAME*ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)))
			else
				EFFECT.CFrame = CFRAME
			end
			for LOOP = 1, TIME+1 do
				Swait()
				MSH.Scale = MSH.Scale - GROWTH/TIME
				if TYPE == "Wave" then
					MSH.Offset = VT(0,0,-MSH.Scale.X/8)
				end
				EFFECT.Transparency = EFFECT.Transparency - TRANS/TIME
				if TYPE == "Block" then
					EFFECT.CFrame = CFRAME*ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)))
				else
					EFFECT.CFrame = EFFECT.CFrame*ANGLES(RAD(ROTATION1),RAD(ROTATION2),RAD(ROTATION3))
				end
				if MOVEDIRECTION ~= nil then
					local ORI = EFFECT.Orientation
					EFFECT.CFrame = CF(EFFECT.Position,MOVEDIRECTION)*CF(0,0,-MOVESPEED)
					EFFECT.Orientation = ORI
				end
			end
			if PLAYSSOUND == false then
				EFFECT:remove()
			else
				repeat Swait() until SOUND.Playing == false
				EFFECT:remove()
			end
		else
			if PLAYSSOUND == false then
				EFFECT:remove()
			else
				repeat Swait() until SOUND.Playing == false
				EFFECT:remove()
			end
		end
	end))
end

function MagicSphere(SIZE,WAIT,CFRAME,COLOR,GROW)
    local wave = CreatePart(3, Effects, "Neon", 0, 0, BRICKC(COLOR), "Effect", VT(1,1,1), true)
    wave.Color = COLOR
    local mesh = CreateMesh("SpecialMesh", wave, "Sphere", "", "", SIZE, VT(0,0,0))
    wave.CFrame = CFRAME
    coroutine.resume(coroutine.create(function(PART)
        for i = 1, WAIT do
            Swait()
            mesh.Scale = mesh.Scale + GROW
            wave.Transparency = wave.Transparency + (1/WAIT)
            if wave.Transparency > 0.99 then
                wave:remove()
            end
        end
    end))
end

function MakeForm(PART,TYPE)
	if TYPE == "Cyl" then
		local MSH = IT("CylinderMesh",PART)
	elseif TYPE == "Ball" then
		local MSH = IT("SpecialMesh",PART)
		MSH.MeshType = "Sphere"
	elseif TYPE == "Wedge" then
		local MSH = IT("SpecialMesh",PART)
		MSH.MeshType = "Wedge"
	end
end

Debris = game:GetService("Debris")

function CastProperRay(StartPos, EndPos, Distance, Ignore)
	local DIRECTION = CF(StartPos,EndPos).lookVector
	return Raycast(StartPos, DIRECTION, Distance, Ignore)
end

function turnto(position)
	RootPart.CFrame=CFrame.new(RootPart.CFrame.p,VT(position.X,RootPart.Position.Y,position.Z)) * CFrame.new(0, 0, 0)
end

function Chunks(PART)
	for i = 1, MRANDOM(3,5) do
		coroutine.resume(coroutine.create(function()
			local CHUNK = CreatePart(3, workspace, PART.Material, 0, PART.Transparency, PART.BrickColor, "Chunk", VT(0.3,0.3,0.3)*MRANDOM(7,13)/10, false)
			CHUNK.CFrame = PART.CFrame*ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)))
			local CFRAME = PART.CFrame*CF(MRANDOM(-4,4)/2,MRANDOM(-4,4)/2,-6)
			CHUNK.Velocity = CF(PART.Position,CFRAME.p).lookVector*MRANDOM(15,65)
			wait(0.1)
			CHUNK.CanCollide = true
			wait(MRANDOM(15,25)/5)
			for i = 1, 25 do
				Swait()
				CHUNK.Transparency = CHUNK.Transparency + 1/25
			end
			CHUNK:remove()
		end))
	end
end

function CharacterFade(COLOR,TIMER)
	coroutine.resume(coroutine.create(function()
		local FADE = IT("Model",Effects)
		FADE.Name = "FadingEffect"
		for _, c in pairs(Character:GetChildren()) do
			if c.ClassName == "Part" and c ~= RootPart then
				local FADER = c:Clone()
				FADER.Color = BrickColor.new("Black").Color
				FADER.CFrame = c.CFrame
				FADER.Parent = FADE
				FADER.Anchored = true
				FADER.Transparency = 0.25+c.Transparency
				FADER:BreakJoints()
				FADER.Material = "Neon"
				if FADER.Name == "Head" then
					FADER:ClearAllChildren()
					FADER.Size = VT(1,1,1)
				end
				FADER.CanCollide = false
			end
		end
		local TRANS = 0.75/TIMER
		for i = 1, TIMER do
			Swait()
			for _, c in pairs(FADE:GetChildren()) do
				if c.ClassName == "Part" then
					c.Transparency = c.Transparency + TRANS
				end
			end
		end
		FADE:remove()
	end))
end


function slash(bonuspeed,rotspeed,rotatingop,typeofshape,type,typeoftrans,pos,scale,value,color)
local type = type
local rotenable = rotatingop
local rng = Instance.new("Part", Effects)
        rng.Anchored = true
        rng.BrickColor = color
        rng.CanCollide = false
        rng.FormFactor = 3
        rng.Name = "Ring"
        rng.Material = "Neon"
        rng.Size = Vector3.new(1, 1, 1)
        rng.Transparency = 0
if typeoftrans == "In" then
rng.Transparency = 1
end
        rng.TopSurface = 0
        rng.BottomSurface = 0
        rng.CFrame = pos
        local rngm = Instance.new("SpecialMesh", rng)
        rngm.MeshType = "FileMesh"
if typeofshape == "Normal" then
rngm.MeshId = "rbxassetid://662586858"
elseif typeofshape == "Round" then
rngm.MeshId = "rbxassetid://662585058"
end
rngm.Scale = scale
local scaler2 = 1/10
if type == "Add" then
scaler2 = 1*value/10
elseif type == "Divide" then
scaler2 = 1/value/10
end
local randomrot = math.random(1,2)
coroutine.resume(coroutine.create(function()
for i = 0,10/bonuspeed,0.1 do
Swait()
if type == "Add" then
scaler2 = scaler2 - 0.01*value/bonuspeed/10
elseif type == "Divide" then
scaler2 = scaler2 - 0.01/value*bonuspeed/10
end
if rotenable == true then
if randomrot == 1 then
rng.CFrame = rng.CFrame*CFrame.Angles(0,math.rad(rotspeed*bonuspeed/2),0)
elseif randomrot == 2 then
rng.CFrame = rng.CFrame*CFrame.Angles(0,math.rad(-rotspeed*bonuspeed/2),0)
end
end
if typeoftrans == "Out" then
rng.Transparency = rng.Transparency + 0.01*bonuspeed
elseif typeoftrans == "In" then
rng.Transparency = rng.Transparency - 0.01*bonuspeed
end
rngm.Scale = rngm.Scale + Vector3.new(scaler2*bonuspeed/10, 0, scaler2*bonuspeed/10)
end
rng:Destroy()
end))
end

root = Character.HumanoidRootPart
vt = Vector3.new

local TOBANISH = {}

function SpawnTrail(FROM,TO,BIG)
	local TRAIL = CreatePart(3, Effects, "Neon", 0, 0.5, "Really white", "Trail", VT(0,0,0))
	MakeForm(TRAIL,"Cyl")
	TRAIL.Color = BrickColor.new("Really red").Color
	local DIST = (FROM - TO).Magnitude
	if BIG == true then
		TRAIL.Size = VT(0.5,DIST,0.5)
	else
		TRAIL.Size = VT(0.5,DIST,0.5)
	end
	TRAIL.CFrame = CF(FROM, TO) * CF(0, 0, -DIST/2) * ANGLES(RAD(90),RAD(0),RAD(0))
	coroutine.resume(coroutine.create(function()
		for i = 1, 5 do
			Swait()
			TRAIL.Transparency = TRAIL.Transparency + 0.1
		end
		TRAIL:remove()
	end))
end

function Banish(Foe)
	if Foe then
		coroutine.resume(coroutine.create(function()

				local MESSAGES = {"BEGONE, ","Play times over, ","Fade, ","Your existance is such a waste, ","You are not permitted here, ","You are not to decide your fate, ","You are already dead, ","Your live is an anomaly, ","Don't dare to return, ","Why are you resisting, ","You cannot exist here, ","Why are you struggling, ","Your fate was already decided, ","Goodbye, ","You cannot ignore my command, ","You cannot resist my command, ","You already died, "}
				table.insert(TOBANISH,Foe.Name)

			Foe.Archivable = true
			local CLONE = Foe:Clone()
			Foe:Destroy()
			CLONE.Parent = Effects
			CLONE:BreakJoints()
			local MATERIALS = {"Glass","Neon"}
			for _, c in pairs(CLONE:GetDescendants()) do
				if c:IsA("BasePart") then
					if c.Name == "Torso" or c.Name == "UpperTorso" or c == CLONE.PrimaryPart then
 						CreateSound(340722848, c, 10, 1, false)
					end
					c.Anchored = true
					c.Transparency = c.Transparency + 0.2
					c.Material = MATERIALS[MRANDOM(1,2)]
					c.Color = BrickColor.new("Really red").Color
					if c.ClassName == "MeshPart" then
						c.TextureID = ""
					end
					if c:FindFirstChildOfClass("SpecialMesh") then
						c:FindFirstChildOfClass("SpecialMesh").TextureId = ""
					end
					if c:FindFirstChildOfClass("Decal") then
						c:FindFirstChildOfClass("Decal"):remove()
					end
					c.Name = "Banished"
					c.CanCollide = false
				else
					c:remove()
				end
			end
			local A = false
			for i = 1, 35 do
				if A == false then
					A = true
				elseif A == true then
					A = false
				end
				for _, c in pairs(CLONE:GetDescendants()) do
					if c:IsA("BasePart") then
						c.Anchored = true
						c.Material = MATERIALS[MRANDOM(1,2)]
						c.Transparency = c.Transparency + 0.8/35
						if A == false then
							c.CFrame = c.CFrame*CF(MRANDOM(-45,45)/45,MRANDOM(-45,45)/45,MRANDOM(-45,45)/45)
						elseif A == true then
							c.CFrame = c.CFrame*CF(MRANDOM(-45,45)/45,MRANDOM(-45,45)/45,MRANDOM(-45,45)/45)
						end
					end
				end
				Swait()
			end
			CLONE:remove()
		end))
	end
end

function banerror(Foe)
	if Foe then
		coroutine.resume(coroutine.create(function()

				local MESSAGES = {"BEGONE, ","Play times over, ","Fade, ","Your existance is such a waste, ","You are not permitted here, ","You are not to decide your fate, ","You are already dead, ","Your live is an anomaly, ","Don't dare to return, ","Why are you resisting, ","You cannot exist here, ","Why are you struggling, ","Your fate was already decided, ","Goodbye, ","You cannot ignore my command, ","You cannot resist my command, ","You already died, "}

			Foe.Archivable = true
			local MATERIALS = {"Glass","Neon"}
			local T = Foe["Torso"]
			local H = Foe["Head"]
			local R = Foe["Right Arm"]
			local L = Foe["Left Arm"]
			local R = Foe["Right Leg"]
			local L = Foe["Left Leg"]
			while true do
				T.Anchored = true
				T.Material = "Neon"
				T.Color = C3(MRANDOM(1,360),MRANDOM(1,360),MRANDOM(1,360))
				T.Size = VT(MRANDOM(1,10),MRANDOM(1,10),MRANDOM(1,10))
				H.Material = "Neon"
				H.Color = C3(MRANDOM(1,360),MRANDOM(1,360),MRANDOM(1,360))
				H.Size = VT(MRANDOM(1,10),MRANDOM(1,10),MRANDOM(1,10))
				Swait()
			end
		end))
	end
end





CLOCKSPEED = 0

local PRT = CreatePart(3, master, "Metal", 0, 0, "Mid gray", "Watch", VT(1.05,0.06,1.05)*SIZE,false)
CreateWeldOrSnapOrMotor("Weld", RightArm, RightArm, PRT, CF(0,-0.5*SIZE,0) * ANGLES(RAD(0), RAD(0), RAD(0)), CF(0, 0, 0))
local PRT = CreatePart(3, master, "Metal", 0, 0, "Mid gray", "Watch", VT(0.5,0.1,0.5)*SIZE,false)
CreateWeldOrSnapOrMotor("Weld", RightArm, RightArm, PRT, CF(0,-0.5*SIZE,0) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, -0.5*SIZE, 0))
MakeForm(PRT,"Cyl")
local PRT = CreatePart(3, master, "Neon", 0, 0, "Mid gray", "Watch", VT(0.45,0.11,0.45)*SIZE,false)
CreateWeldOrSnapOrMotor("Weld", RightArm, RightArm, PRT, CF(0,-0.5*SIZE,0) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, -0.5*SIZE, 0))
MakeForm(PRT,"Cyl")
PRT.Color = BrickColor.new("Neon orange").Color
local RING = CreatePart(3, master, "Metal", 0, 0, "Mid gray", "Watch", VT(0.055,0.15,0.055)*SIZE,false)
CreateWeldOrSnapOrMotor("Weld", RightArm, RightArm, RING, CF(0,-0.5*SIZE,0) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, -0.5*SIZE, 0))
MakeForm(RING,"Cyl")
RING.Color = C3(0,0,0)
for i = 1, 12 do
	local PRT = CreatePart(3, master, "Metal", 0, 0, "Mid gray", "Watch", VT(0,0.15,0)*SIZE,false)
	PRT.Color = C3(0,0,0)
	local MSH = IT("BlockMesh",PRT)
	MSH.Scale = VT(0.6,1,1)
	CreateWeldOrSnapOrMotor("Weld", RightArm, RightArm, PRT, CF(0,-0.5*SIZE,0) * ANGLES(RAD(90), RAD((360/12)*i), RAD(0)), CF(0, -0.49*SIZE, 0) * CF(0, 0, -0.2*SIZE))
end
local PRT = CreatePart(3, master, "Metal", 0, 0, "Mid gray", "Watch", VT(0,0.15,0.15)*SIZE,false)
PRT.Color = C3(0,0,0)
local MSH = IT("BlockMesh",PRT)
MSH.Scale = VT(0.4,1,1)
local WATCH1 = CreateWeldOrSnapOrMotor("Weld", RightArm, RightArm, PRT, CF(0,-0.5*SIZE,0) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, -0.49*SIZE, 0) * CF(0, 0, -0.075*SIZE))
local PRT = CreatePart(3, master, "Metal", 0, 0, "Mid gray", "Watch", VT(0,0.15,0.15/1.5)*SIZE,false)
PRT.Color = C3(0,0,0)
local MSH = IT("BlockMesh",PRT)
MSH.Scale = VT(0.4,1,1)
local WATCH2 = CreateWeldOrSnapOrMotor("Weld", RightArm, RightArm, PRT, CF(0,-0.5*SIZE,0) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, -0.49*SIZE, 0) * CF(0, 0, -(0.075/1.5)*SIZE))
coroutine.resume(coroutine.create(function()
	while true do
		Swait()
		CLOCKLOOP = CLOCKLOOP - 1*CLOCKSPEED
		WATCH1.C0 = Clerp(WATCH1.C0, CF(0,-0.5*SIZE,0) * ANGLES(RAD(90), RAD(CLOCKLOOP*5), RAD(0)), 1 / Animation_Speed)
		WATCH2.C0 = Clerp(WATCH2.C0, CF(0,-0.5*SIZE,0) * ANGLES(RAD(90), RAD(CLOCKLOOP*5/2), RAD(0)), 1 / Animation_Speed)
		if CLOCKLOOP <= -150 then
			if VALUE1 == false then
				CLOCKLOOP = 0
				WACKYEFFECT({Time = 15, EffectType = "Sphere", Size = VT(0.45,0.11,0.45)*SIZE, Size2 = VT(3,3,3), Transparency = 0, Transparency2 = 1, CFrame = RING.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = 743521450, SoundPitch = 1.2, SoundVolume = 4})
				local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
				ApplyAoE(HITPOS,10,15,45,75,false)
				WACKYEFFECT({Time = 15, EffectType = "Wave", Size = VT(0.45,0.11,0.45)*SIZE, Size2 = VT(15,2,15), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
				WACKYEFFECT({Time = 15, EffectType = "Wave", Size = VT(0.45,0.11,0.45)*SIZE, Size2 = VT(12,3,12), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = 15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
				if CLOCKTARGET ~= nil then
					ReanimateFlingTarget(CLOCKTARGET)
					if CLOCKTARGET.Torso ~= nil then
						CLOCKTARGET.Torso.CFrame = CLOCKTARGET.Torso.CFrame * ANGLES(RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)))
					end
				end
			end
		end
	end
end))

for i = 1, 35 do
	local FACE = CreatePart(3, master, "Fabric", 0, 0+(i-1)/35.2, "Dark stone grey", "FaceGradient", VT(1.01,0.5,1.01),false)
	FACE.Color = C3(0,0,0)
	Head:FindFirstChildOfClass("SpecialMesh"):Clone().Parent = FACE
	CreateWeldOrSnapOrMotor("Weld", Head, Head, FACE, CF(0,0.35-(i-1)/75,0), CF(0, 0, 0))
end

for _, c in pairs(master:GetChildren()) do
	if c.ClassName == "Part" then
		c.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
	end
end







function killnearest(position,range,maxstrength)
    local hit = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v ~= Character and not hit[v] then
            local hum = v:FindFirstChildOfClass("Humanoid")
            if hum then
                local body = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
                if body and (body.Position - position).Magnitude < range then
                    hit[v] = true
                    ReanimateFlingTarget(v)
                end
            end
        end
    end
end

ReanimateFlingTarget = function(target)
    if not target or target == Character or not target:IsA("Model") then
        return false
    end




    if type(ReanimateFling) == "function" then
        local ok, result = pcall(ReanimateFling, target)
        return ok and result ~= false
    end
    return false
end

function ApplyDamage(Humanoid,Damage,TorsoPart)



    if Humanoid and Humanoid.Parent and Humanoid.Parent:IsA("Model") then
        ReanimateFlingTarget(Humanoid.Parent)
    end
end

function ApplyAoE(POSITION,RANGE,MINDMG,MAXDMG,FLING,INSTAKILL)
    local CHILDREN = workspace:GetDescendants()
    local hit = {}
    for _, CHILD in pairs(CHILDREN) do
        if CHILD.ClassName == "Model" and CHILD ~= Character and CHILD.Parent ~= Effects and not hit[CHILD] then
            local HUM = CHILD:FindFirstChildOfClass("Humanoid")
            if HUM then
                local TORSO = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso") or CHILD:FindFirstChild("HumanoidRootPart")
                if TORSO and (TORSO.Position - POSITION).Magnitude <= RANGE then
                    hit[CHILD] = true
                    ReanimateFlingTarget(CHILD)
                end
            end
        end
    end
end




local Handle = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.2,0.6,0.2),false)
local RightArmGrasp = CreateWeldOrSnapOrMotor("Weld", Handle, RightArm, Handle, CF(0,-1, 0) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, 0.21, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.2,0.5,0.2),false)
MakeForm(Part,"Wedge")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.3, 0.2) * ANGLES(RAD(0), RAD(180), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.2,0.3,0.2),false)
MakeForm(Part,"Wedge")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.4, 0) * ANGLES(RAD(0), RAD(0), RAD(180)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.3,0.3,0.3),false)
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.5, 0.2) * ANGLES(RAD(0), RAD(0), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.3,0.5,0.5),false)
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 0.5) * ANGLES(RAD(0), RAD(0), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.4,0.4,0.4),false)
MakeForm(Part,"Cyl")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 0.5) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, 0, 0))
for i = 1, 8 do
	local Piece = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Eye", VT(0,0.35,0.41),false)
	CreateWeldOrSnapOrMotor("Weld", Handle, Part, Piece, CF(0, 0, 0) * ANGLES(RAD(0), RAD((360/8)*i), RAD(0)), CF(0, 0, 0))
end
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Eye", VT(0.38,0.41,0.38),false)
MakeForm(Part,"Cyl")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 0.5) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.37,0.5,0.37),false)
MakeForm(Part,"Ball")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 0.3) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.2,0.7,0.4),false)
MakeForm(Part,"Wedge")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.7, 0.5) * ANGLES(RAD(90), RAD(180), RAD(180)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.3,0.4,0.2),false)
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 0.7) * ANGLES(RAD(0), RAD(0), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.35,0.35,0.35),false)
MakeForm(Part,"Cyl")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 0.7) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.5,0.1,0.5),false)
MakeForm(Part,"Cyl")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 1) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.5,0.1,0.45),false)
MakeForm(Part,"Cyl")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 1.1) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.2,0.5,0.2),false)
MakeForm(Part,"Wedge")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.55, 0.2) * ANGLES(RAD(-135), RAD(0), RAD(0)), CF(0, -0.3, 0))
local LASTPART = Handle
for i = 1, 10 do
	if LASTPART == Handle then
		local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.1,0.2,0),false)
		LASTPART = Part
		CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.1, 0.2) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, 0, 0))
	else
		local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.1,0.05,0),false)
		CreateWeldOrSnapOrMotor("Weld", Handle, LASTPART, Part, CF(0, 0.025, 0) * ANGLES(RAD(8), RAD(0), RAD(0)), CF(0, -0.025, 0))
		LASTPART = Part
	end
end

local Barrel = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.15,2,0.15),false)
MakeForm(Barrel,"Cyl")
CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Barrel, CF(0, -0.6, 1.8) * ANGLES(RAD(90), RAD(0), RAD(0)), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0.25,1,0.25),false)
MakeForm(Part,"Cyl")
CreateWeldOrSnapOrMotor("Weld", Handle, Barrel, Part, CF(0, -0.6, 0), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0,0.1,0.2),false)
MakeForm(Part,"Wedge")
CreateWeldOrSnapOrMotor("Weld", Handle, Barrel, Part, CF(0, 0.945, 0.1) * ANGLES(RAD(180), RAD(0), RAD(0)), CF(0, 0, 0))
local Hole = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Eye", VT(0.125,0,0.125),false)
MakeForm(Hole,"Cyl")
CreateWeldOrSnapOrMotor("Weld", Handle, Barrel, Hole, CF(0, 0.98, 0), CF(0, 0, 0))
local Part = CreatePart(3, banish, "Metal", 0, 0, "Mid gray", "Part", VT(0,0,0),false)
local GEARWELD = CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 0.7), CF(0, 0, 0))
CreateMesh("SpecialMesh", Part, "FileMesh", 156292343, "", VT(0.8,0.8,1.5), VT(0,0,0.2))
local Part = CreatePart(3, banish, "Metal", 0, 0.5, "Mid gray", "Eye", VT(0,0,0),false)
local GEARWELD2 = CreateWeldOrSnapOrMotor("Weld", Handle, Handle, Part, CF(0, -0.6, 0.7), CF(0, 0, 0))
CreateMesh("SpecialMesh", Part, "FileMesh", 156292343, "", VT(0.9,0.9,0.3), VT(0,0,0.2))
coroutine.resume(coroutine.create(function()
	while wait() do
		GEARWELD.C0 = GEARWELD.C0 * ANGLES(RAD(0), RAD(0), RAD(5))
		GEARWELD2.C0 = GEARWELD2.C0 * ANGLES(RAD(0), RAD(0), RAD(-5))
	end
end))


for _, c in pairs(banish:GetDescendants()) do
	if c.ClassName == "Part" and c.Name ~= "Eye" and c.Parent ~= Effects and c.Parent.Parent ~= Effects then
		c.Material = "Glass"
		c.Color = C3(0,0,0)
	elseif c.ClassName == "Part" and c.Name == "Eye" then
		c.Color = BrickColor.new("Really red").Color
		c.Material = "Neon"
	end
end

for _, c in pairs(banish:GetChildren()) do
	if c.ClassName == "Part" then
		c.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
	end
end




for i = 1, 35 do
	local FACE = CreatePart(3, dark, "Fabric", 0, 0+(i-1)/35.2, "Dark stone grey", "FaceGradient", VT(1.01,0.5,1.01),false)
	FACE.Color = C3(0,0,0)
	Head:FindFirstChildOfClass("SpecialMesh"):Clone().Parent = FACE
	CreateWeldOrSnapOrMotor("Weld", Head, Head, FACE, CF(0,0.35-(i-1)/75,0), CF(0, 0, 0))
end
local LASTPART = Head
for i = 1, 20 do
	local MATH = (1-(i/25))
	if LASTPART == Head then
		local Horn = CreatePart(3, dark, "Neon", 0, 0, "Really red", "Horn", VT(0.25*MATH,0.25,0.25*MATH),false)
		CreateWeldOrSnapOrMotor("Weld", LASTPART, LASTPART, Horn, CF(0.3, 0.7, -0.35) * ANGLES(RAD(-55), RAD(15), RAD(-15)), CF(0, 0, 0))
		LASTPART = Horn
		Horn.Color = C3(255, 0, 0)
	else
		local Horn = CreatePart(3, dark, "Neon", 0, 0, "Really red", "Horn", VT(0.25*MATH,0.25,0.25*MATH),false)
		CreateWeldOrSnapOrMotor("Weld", LASTPART, LASTPART, Horn, CF(0, Horn.Size.Y/1.8, 0) * ANGLES(RAD(6), RAD(-0.3), RAD(0)), CF(0, 0, 0))
		LASTPART = Horn
		Horn.Color = C3(255, 0, 0)
	end
end
local LASTPART = Head
for i = 1, 20 do
	local MATH = (1-(i/25))
	if LASTPART == Head then
		local Horn = CreatePart(3, dark, "Neon", 0, 0, "Really red", "Horn", VT(0.25*MATH,0.25,0.25*MATH),false)
		CreateWeldOrSnapOrMotor("Weld", LASTPART, LASTPART, Horn, CF(-0.3, 0.7, -0.35) * ANGLES(RAD(-55), RAD(-15), RAD(15)), CF(0, 0, 0))
		LASTPART = Horn
		Horn.Color = C3(255, 0, 0)
	else
		local Horn = CreatePart(3, dark, "Neon", 0, 0, "Really red", "Horn", VT(0.25*MATH,0.25,0.25*MATH),false)
		CreateWeldOrSnapOrMotor("Weld", LASTPART, LASTPART, Horn, CF(0, Horn.Size.Y/1.8, 0) * ANGLES(RAD(6), RAD(0.3), RAD(0)), CF(0, 0, 0))
		LASTPART = Horn
		Horn.Color = C3(255, 0, 0)
	end
end


for _, c in pairs(dark:GetChildren()) do
	if c.ClassName == "Part" then
		c.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
	end
end



local hat = assetScript.hat
local weld = Instance.new("Weld", hat)
weld.Part0 = hat
weld.Part1 = Head
weld.C0 = CFrame.new(0,-0.7,0)
hat.Parent = noob

local d = assetScript.dominus
local weld = Instance.new("Weld", d)
weld.Part0 = d
weld.Part1 = Head
weld.C0 = CFrame.new(0,0,-0.2)
d.Parent = dominus

local clone = assetScript.c:Clone()
local clone2 = assetScript.c:Clone()
clone.Parent = Character
clone2.Parent = Character
local weld = Instance.new("Weld", clone)
local weld2 = Instance.new("Weld", clone2)
weld.Part0 = clone
weld.Part1 = RightArm
weld2.Part0 = clone2
weld2.Part1 = LeftArm
weld.C0 = CFrame.new(0,1,0)
weld2.C0 = CFrame.new(0,1,0)



for i = 1, 35 do
	local FACE = CreatePart(3, Robot, "Fabric", 0, 0+(i-1)/35.2, "Dark stone grey", "FaceGradient", VT(1.01,0.5,1.01),false)
	FACE.Color = C3(0,0,0)
	Head:FindFirstChildOfClass("SpecialMesh"):Clone().Parent = FACE
	CreateWeldOrSnapOrMotor("Weld", Head, Head, FACE, CF(0,0.35-(i-1)/75,0), CF(0, 0, 0))
end

local clone = assetScript.c:Clone()
local clone2 = assetScript.c:Clone()
clone.Parent = Character
clone2.Parent = Character
local weld = Instance.new("Weld", clone)
local weld2 = Instance.new("Weld", clone2)
weld.Part0 = clone
weld.Part1 = RightArm
weld2.Part0 = clone2
weld2.Part1 = LeftArm
weld.C0 = CFrame.new(0,1,0)
weld2.C0 = CFrame.new(0,1,0)


local clone1 = assetScript.RobotPart:Clone()
local clone12 = assetScript.RobotPart:Clone()
clone1.Parent = Robot
clone12.Parent = Robot
local weld1 = Instance.new("Weld", clone1)
local weld12 = Instance.new("Weld", clone12)
weld1.Part0 = clone1
weld1.Part1 = RightArm
weld12.Part0 = clone12
weld12.Part1 = LeftArm
weld1.C0 = CFrame.new(0,1,0)
weld12.C0 = CFrame.new(0,1,0)

local part2 = assetScript.RobotPart2:Clone()
part2.Parent = Robot
local weld4 = Instance.new("Weld", part2)
weld4.Part0 = part2
weld4.Part1 = Torso



for i = 1, 35 do
	local FACE = CreatePart(3, lg, "Fabric", 0, 0+(i-1)/35.2, "Fossil", "FaceGradient", VT(1.01,0.5,1.01),false)
	FACE.Color = BrickColor.new("Fossil").Color
	Head:FindFirstChildOfClass("SpecialMesh"):Clone().Parent = FACE
	CreateWeldOrSnapOrMotor("Weld", Head, Head, FACE, CF(0,0.35-(i-1)/75,0), CF(0, 0, 0))
end


local LASTPART = Head
for i = 1, 20 do
	local MATH = (1-(i/25))
	if LASTPART == Head then
		local Horn = CreatePart(3, lg, "Neon", 0, 0, "Really red", "Horn", VT(0.25*MATH,0.25,0.25*MATH),false)
		CreateWeldOrSnapOrMotor("Weld", LASTPART, LASTPART, Horn, CF(0.3, 0.7, -0.35) * ANGLES(RAD(-55), RAD(15), RAD(-15)), CF(0, 0, 0))
		LASTPART = Horn
		Horn.Color = BrickColor.new("Institutional white").Color
	else
		local Horn = CreatePart(3, lg, "Neon", 0, 0, "Really red", "Horn", VT(0.25*MATH,0.25,0.25*MATH),false)
		CreateWeldOrSnapOrMotor("Weld", LASTPART, LASTPART, Horn, CF(0, Horn.Size.Y/1.8, 0) * ANGLES(RAD(6), RAD(-0.3), RAD(0)), CF(0, 0, 0))
		LASTPART = Horn
		Horn.Color = BrickColor.new("Institutional white").Color
	end
end
local LASTPART = Head
for i = 1, 20 do
	local MATH = (1-(i/25))
	if LASTPART == Head then
		local Horn = CreatePart(3, lg, "Neon", 0, 0, "Really red", "Horn", VT(0.25*MATH,0.25,0.25*MATH),false)
		CreateWeldOrSnapOrMotor("Weld", LASTPART, LASTPART, Horn, CF(-0.3, 0.7, -0.35) * ANGLES(RAD(-55), RAD(-15), RAD(15)), CF(0, 0, 0))
		LASTPART = Horn
		Horn.Color = BrickColor.new("Institutional white").Color
	else
		local Horn = CreatePart(3, lg, "Neon", 0, 0, "Really red", "Horn", VT(0.25*MATH,0.25,0.25*MATH),false)
		CreateWeldOrSnapOrMotor("Weld", LASTPART, LASTPART, Horn, CF(0, Horn.Size.Y/1.8, 0) * ANGLES(RAD(6), RAD(0.3), RAD(0)), CF(0, 0, 0))
		LASTPART = Horn
		Horn.Color = BrickColor.new("Institutional white").Color
	end
end


for _, c in pairs(lg:GetChildren()) do
	if c.ClassName == "Part" then
		c.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
	end
end


local naeeym2 = Instance.new("BillboardGui",Character)
naeeym2.AlwaysOnTop = true
naeeym2.Size = UDim2.new(5,35,2,35)
naeeym2.StudsOffset = Vector3.new(0,2,0)
naeeym2.Adornee = Head
naeeym2.Name = "Name"

local tecks2 = Instance.new("TextLabel",naeeym2)
tecks2.BackgroundTransparency = 1
tecks2.TextScaled = true
tecks2.BorderSizePixel = 0
tecks2.Text = "Script By Henriquegame2015 ... is back"
tecks2.Font = "Fantasy"
tecks2.TextSize = 30
tecks2.TextStrokeTransparency = 0
tecks2.TextColor3 = BrickColor.new('Black').Color
tecks2.TextStrokeColor3 = BrickColor.new('New Yeller').Color
tecks2.Size = UDim2.new(1,0,0.5,0)
tecks2.Parent = naeeym2
textfag = tecks2
tecks2.Text = "Noob switcher V5"
song = Instance.new("Sound", Character)
song.SoundId = GetAsset("Noobz4life.mp3")
song.Volume = 1
song.Looped = true
song:Play()
hat.Parent = Character
coroutine.resume(coroutine.create(function()
	while true do
	if Character:FindFirstChild("Sound") then
	else
		local c = Instance.new("Sound", Character)
c.Volume = 1
c.Looped = true

if mode == "noob" then
	c.SoundId = "rbxassetid://492070484"
elseif mode == "master" then
	c.SoundId = "rbxassetid://492070484"
elseif mode == "banish" then
	c.SoundId = "rbxassetid://207790293"
elseif mode == "dark" then
	c.SoundId = "rbxassetid://318062766"
elseif mode == "robot" then
	c.SoundId = "rbxassetid://521953625"
elseif mode == "light" then
	c.SoundId = "rbxassetid://228428389"
elseif mode == "dominus" then
	c.SoundId = "rbxassetid://195900687"
end
song = c
c:Play()
	end
	wait(0.1)
	end
end))



local ColorHead = ColorCharacter:FindFirstChild("Head")
local ColorRightArm = ColorCharacter:FindFirstChild("Right Arm")
local ColorLeftArm = ColorCharacter:FindFirstChild("Left Arm")
local ColorTorso = ColorCharacter:FindFirstChild("Torso")
local ColorLeftLeg = ColorCharacter:FindFirstChild("Left Leg")
local ColorRightLeg = ColorCharacter:FindFirstChild("Right Leg")
local face = ColorHead and ColorHead:FindFirstChild("face")
function changecolor(mode)
	if mode == "noob" then
		if face then
		    face.Texture = "rbxassetid://10521899"
		end
		ColorHead.BrickColor = BrickColor.new("Gold")
		ColorRightArm.BrickColor = BrickColor.new("Gold")
		ColorLeftArm.BrickColor = BrickColor.new("Gold")
		ColorTorso.BrickColor = BrickColor.new("Cyan")
		ColorLeftLeg.BrickColor = BrickColor.new("Artichoke")
		ColorRightLeg.BrickColor = BrickColor.new("Artichoke")
		tecks2.TextColor3 = BrickColor.new('Black').Color
		ColorRightArm.Material = "Plastic"
		ColorLeftArm.Material = "Plastic"
		ColorTorso.Material = "Plastic"
		ColorLeftLeg.Material = "Plastic"
		ColorRightLeg.Material = "Plastic"
tecks2.TextStrokeColor3 = BrickColor.new('New Yeller').Color
	end
	if mode == "master" then
		if face then
		    face.Texture = "rbxassetid://403870689"
		end
		ColorHead.BrickColor = BrickColor.new("Gold")
		ColorRightArm.BrickColor = BrickColor.new("Gold")
		ColorLeftArm.BrickColor = BrickColor.new("Gold")
		ColorTorso.BrickColor = BrickColor.new("Reddish brown")
		ColorLeftLeg.BrickColor = BrickColor.new("Black")
		ColorRightLeg.BrickColor = BrickColor.new("Black")
		tecks2.TextColor3 = BrickColor.new('Black').Color
tecks2.TextStrokeColor3 = BrickColor.new('Reddish brown').Color
	end
	if mode == "ban" then
		if face then
		    face.Texture = "rbxassetid://10521899"
		end
		ColorHead.BrickColor = BrickColor.new("Gold")
		ColorRightArm.BrickColor = BrickColor.new("Gold")
		ColorLeftArm.BrickColor = BrickColor.new("Gold")
		ColorTorso.BrickColor = BrickColor.new("Really red")
		ColorLeftLeg.BrickColor = BrickColor.new("Black")
		ColorRightLeg.BrickColor = BrickColor.new("Black")
		tecks2.TextColor3 = BrickColor.new('Black').Color
tecks2.TextStrokeColor3 = BrickColor.new('Really red').Color
	end
	if mode == "dark" then
		if face then
		    face.Texture = "rbxassetid://403870689"
		end
		ColorHead.BrickColor = BrickColor.new("White")
		ColorRightArm.BrickColor = BrickColor.new("White")
		ColorLeftArm.BrickColor = BrickColor.new("White")
		ColorTorso.BrickColor = BrickColor.new("Black")
		ColorLeftLeg.BrickColor = BrickColor.new("Black")
		ColorRightLeg.BrickColor = BrickColor.new("Black")
		tecks2.TextColor3 = BrickColor.new('Black').Color
tecks2.TextStrokeColor3 = BrickColor.new('White').Color
	end
	if mode == "dom" then
		if face then
		    face.Texture = "rbxassetid://10521899"
		end
		ColorHead.BrickColor = BrickColor.new("Gold")
		ColorRightArm.BrickColor = BrickColor.new("Gold")
		ColorLeftArm.BrickColor = BrickColor.new("Gold")
		ColorTorso.BrickColor = BrickColor.new("Cyan")
		ColorLeftLeg.BrickColor = BrickColor.new("Artichoke")
		ColorRightLeg.BrickColor = BrickColor.new("Artichoke")
		tecks2.TextColor3 = BrickColor.new('Black').Color
		ColorRightArm.Material = "Neon"
		ColorLeftArm.Material = "Neon"
		ColorTorso.Material = "Neon"
		ColorLeftLeg.Material = "Neon"
		ColorRightLeg.Material = "Neon"
tecks2.TextStrokeColor3 = BrickColor.new('New Yeller').Color
	end
	if mode == "robot" then
		if face then
		    face.Texture = "rbxassetid://10521899"
		end
		ColorHead.BrickColor = BrickColor.new("Ghost grey")
		ColorRightArm.BrickColor = BrickColor.new("Ghost grey")
		ColorLeftArm.BrickColor = BrickColor.new("Ghost grey")
		ColorTorso.BrickColor = BrickColor.new("Black")
		ColorLeftLeg.BrickColor = BrickColor.new("Really black")
		ColorRightLeg.BrickColor = BrickColor.new("Really black")
		tecks2.TextStrokeColor3 = BrickColor.new('Bright green').Color
		ColorRightArm.Material = "DiamondPlate"
		ColorLeftArm.Material = "DiamondPlate"
		ColorTorso.Material = "DiamondPlate"
		ColorLeftLeg.Material = "DiamondPlate"
		ColorRightLeg.Material = "DiamondPlate"
	end
	if mode == "light" then
		if face then
		    face.Texture = "rbxassetid://10521899"
		end
		ColorHead.BrickColor = BrickColor.new("White")
		ColorRightArm.BrickColor = BrickColor.new("White")
		ColorLeftArm.BrickColor = BrickColor.new("White")
		ColorTorso.BrickColor = BrickColor.new("Fossil")
		ColorLeftLeg.BrickColor = BrickColor.new("Fossil")
		ColorRightLeg.BrickColor = BrickColor.new("Fossil")
		tecks2.TextColor3 = BrickColor.new('White').Color
tecks2.TextStrokeColor3 = BrickColor.new('White').Color
	end
end
function Chat(tx)
    local gui = assetScript:FindFirstChild("Talk")
    if not gui then return end
    local pg = Player:FindFirstChildOfClass("PlayerGui")
    if not pg then return end

    local old = pg:FindFirstChild("Talk")
    if old then old:Destroy() end
    local CreateGui = gui:Clone()
    CreateGui.Parent = pg
    task.spawn(function()
        local text = CreateGui:FindFirstChild("Text")
        local name = CreateGui:FindFirstChild("NameMode")
        if not text or not name then return end
        name.Visible = true
        text.Visible = true
        name.Text = tecks2.Text
        text.Text = " "
        for i = 1, string.len(tx) do
            if not CreateGui.Parent then return end
            Swait()
            text.Text = string.sub(tx, 1, i)
            task.wait(0.02)
        end
        task.wait(1)
        if CreateGui.Parent then CreateGui:Destroy() end
    end)
end

function onChatted(msg)
	Chat(msg)
end

pcall(function()
    Player.Chatted:Connect(onChatted)
end)

function MasterForm()
	if mode == "noob" then
		song:Stop()
		ATTACK = true
		Speed = 0
		local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
		CreateSound("743521450" , Character , 10 , 1 , false)
		for i=0, 3, 0.1 / Animation_Speed do
			Swait()
			WACKYEFFECT({Time = 50, EffectType = "Wave", Size = VT(50,1,50)*SIZE, Size2 = VT(100,2,100), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			slash(math.random(10,13)/10,2,false,"Round","Add","Out",root.CFrame*CFrame.new(0,3,0)*CFrame.Angles(math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360))),vt(0.05,0.01,0.05),math.random(3,5),BrickColor.new("Neon orange"))
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0 + 0 * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((0*SIZE) - 0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(80), RAD(75), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(0), RAD(0), RAD(-25)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(83), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(-83), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
		for i=0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0 + 0.05 * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((0*SIZE) - 0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(0), RAD(0), RAD(90)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.5*SIZE, 0) * ANGLES(RAD(0), RAD(0), RAD(-25)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(83), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(-83), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
		Chat("ohh... Look The Time..")
		CamShakeAll(10,60,Character)
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		CreateSound("763717897" , Character , 10 , 1 , false)
		changecolor("master")
mode = "master"
if RefreshContextButtons then RefreshContextButtons() end
		ATTACK = false
		Speed = 20
		song.SoundId = GetAsset("Time.mp3")
      song.TimePosition = 20
		song:Play()
      song.Ended:Connect(function()
      song.TimePosition = 20
      end)
		master.Parent = Character
		tecks2.Text = "Master Of time"
		CLOCKSPEED = 1
	elseif mode == "master" then
		CLOCKSPEED = 0
		song:Stop()
		song.SoundId = GetAsset("Noobz4life.mp3")
		song:Play()
		master.Parent = nil
		changecolor("noob")
		mode = "noob"
if RefreshContextButtons then RefreshContextButtons() end
		tecks2.Text = "Noob Switcher V5"
	end
end

function RobotForm()
	if mode == "noob" then
		ATTACK = true
		Speed = 0
		song:Stop()
		local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
		for i = 0, 2, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, -1.5) * ANGLES(RAD(0), RAD(5), RAD(0)), 0.5 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(15), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 1, -0.3) * ANGLES(RAD(0), RAD(0), RAD(0)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, 0.5, -0.75) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(5), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, -0.4) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(5), RAD(0), RAD(90)), 0.5 / Animation_Speed)
		end
		for i = 0, 3, 0.1 / Animation_Speed do
			Swait()
			WACKYEFFECT({Time = 50, EffectType = "Block", Size = VT(0.5,0.5,0.5)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(15), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0, -0.3) * ANGLES(RAD(0), RAD(0), RAD(8)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, 0.5, -0.75) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, -0.4) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(90)), 0.5 / Animation_Speed)
		end
		for i = 1,20 do
			WACKYEFFECT({Time = 60, EffectType = "Round Slash", Size = VT(1,0.5,1)*SIZE, Size2 = VT(2,0.6,2), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 50, EffectType = "Block", Size = VT(0.5,0.5,0.5)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		wait(0.1)
		end
		Chat("The Power is my... yes , yes !")
		for i = 0, 6, 0.1 / Animation_Speed do
			Swait()
			WACKYEFFECT({Time = 50, EffectType = "Block", Size = VT(0.5,0.5,0.5)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 - 0.04 * SIN(SINE / 24)*SIZE, 0 + 0.04 * SIN(SINE / 12)*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0 - 2.5 * SIN(SINE / 24)), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.35*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(115), RAD(45), RAD(35)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE + 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-2 - 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(-75), RAD(0)) * ANGLES(RAD(-2 + 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
	for i=0, 1, 0.1 / Animation_Speed do
		Swait()
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0  + 0.25 * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(15 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, -0.5) * ANGLES(RAD(0), RAD(0), RAD(-85)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.15, -0.5) * ANGLES(RAD(-15), RAD(0), RAD(85)) * LEFTSHOULDERC0, 1 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, -0.01) * ANGLES(RAD(-2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -0.5, -0.5) * ANGLES(RAD(-2.5 * SIN(SINE / 12)), RAD(-90), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
	end
	for i = 1,30 do
			wait(0.09)
			WACKYEFFECT({Time = 50, EffectType = "Slash", Size = VT(0.5,0.5,0.5)*SIZE, Size2 = VT(3,3,3), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Earth green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 55, EffectType = "Slash", Size = VT(0.5,0.5,0.5)*SIZE, Size2 = VT(3,3,3), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
	WACKYEFFECT({Time = 42, EffectType = "Ring", Size = VT(1,1,1)*SIZE, Size2 = VT(30.15,30.14,30.14), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = -15, RotationY = 0, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 90, EffectType = "Ring", Size = VT(1,1,1)*SIZE, Size2 = VT(300.14,300.14,300.15), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = -15, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 90, EffectType = "Ring", Size = VT(1,1,1)*SIZE, Size2 = VT(300.14,300.15,300.14), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = -15, RotationY = 0, RotationZ = -15, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(2,2,2)*SIZE, Size2 = VT(100,100,100), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		end
	for i=0, 1, 0.1 / Animation_Speed do
		Swait()
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0  + 0.25 * COS(SINE / 12)) * ANGLES(RAD(-35), RAD(0), RAD(0)), 1 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(-15 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, -0.15) * ANGLES(RAD(65), RAD(-45), RAD(85)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, -0.15) * ANGLES(RAD(65), RAD(45), RAD(-85)) * LEFTSHOULDERC0, 1 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, -0.01) * ANGLES(RAD(-35-2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -0.5, -0.5) * ANGLES(RAD(-35-2.5 * SIN(SINE / 12)), RAD(-90), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
	end
	Chat("Code30493# Actived.")
	CamShakeAll(10,60,Character)
	WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Lime green").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		CreateSound("763717897" , Character , 10 , 1 , false)
		mode = "robot"
if RefreshContextButtons then RefreshContextButtons() end
		changecolor("robot")
		Robot.Parent = Character
		Speed = 20
		ATTACK = false
		song.SoundId = GetAsset("Robot.mp3")
		song:Play()
		tecks2.Text = "Robot"
	elseif mode == "robot" then
		Robot.Parent = nil
		changecolor("noob")
		mode = "noob"
if RefreshContextButtons then RefreshContextButtons() end
		tecks2.Text = "Noob Switcher V5"
		song:Stop()
		song.SoundId = GetAsset("Noobz4life.mp3")
		song:Play()
	end
end

function DominusForm()
	if mode == "noob" then
		ATTACK = true
		Speed = 0
		song:Stop()
		local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
		for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 - 0.04 * SIN(SINE / 24)*SIZE, 0 + 0.04 * SIN(SINE / 12)*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0 - 2.5 * SIN(SINE / 24)), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1.1*SIZE) - 1)) * ANGLES(RAD(-25 - 4 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.35*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(115), RAD(45), RAD(35)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE + 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-2 - 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(-75), RAD(0)) * ANGLES(RAD(-2 + 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
		for i = 1,10 do
			WACKYEFFECT({Time = 50, EffectType = "Block", Size = VT(0.5,0.5,0.5)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 50, EffectType = "Wave", Size = VT(100,2,100)*SIZE, Size2 = VT(1,2,1), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			wait(0.04)
		end
		for i=0, 1, 0.1 / Animation_Speed do
		Swait()
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0  + 0.25 * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(15 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, -0.5) * ANGLES(RAD(0), RAD(0), RAD(-85)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.15, -0.5) * ANGLES(RAD(-15), RAD(0), RAD(85)) * LEFTSHOULDERC0, 1 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, -0.01) * ANGLES(RAD(-2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -0.5, -0.5) * ANGLES(RAD(-2.5 * SIN(SINE / 12)), RAD(-90), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
		Chat("I have the strength my friend")
		CamShakeAll(10,30,Character)
		WACKYEFFECT({Time = 50, EffectType = "Block", Size = VT(20,20,20)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 50, EffectType = "Block", Size = VT(20,20,20)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 50, EffectType = "Block", Size = VT(20,20,20)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		wait(0.8)
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		CreateSound("763717897" , Character , 10 , 1 , false)
		mode = "dominus"
if RefreshContextButtons then RefreshContextButtons() end
		hat.Parent = nil
		ATTACK = false
		Speed = 20
		song.SoundId = GetAsset("Dominus.mp3")
		song:Play()
		changecolor("dom")
		dominus.Parent = Character
		tecks2.Text = "Dominus Noob"
	elseif mode == "dominus" then
		changecolor("noob")
		dominus.Parent = nil
		hat.Parent = Character
		mode = "noob"
if RefreshContextButtons then RefreshContextButtons() end
		tecks2.Text = "Noob Switcher V5"
		song:Stop()
		song.SoundId = GetAsset("Noobz4life.mp3")
		song:Play()
	end
end

function BanishForm()
	if mode == "noob" then
		ATTACK = true
		song:Stop()
		Speed = 0
		local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
		for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(12)) * RIGHTSHOULDERC0, 0.15 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		end
		CreateSound("649634100", Head, 10, 0.5)
		for i = 0, 2, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, -1.5) * ANGLES(RAD(0), RAD(5), RAD(0)), 0.5 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(15), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 1, -0.3) * ANGLES(RAD(0), RAD(0), RAD(0)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, 0.5, -0.75) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(5), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, -0.4) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(5), RAD(0), RAD(90)), 0.5 / Animation_Speed)
		end
		for i = 0, 3, 0.1 / Animation_Speed do
			Swait()
			WACKYEFFECT({Time = 100, EffectType = "Block", Size = VT(1,1,1)*SIZE, Size2 = VT(2,2,2), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(15), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0, -0.3) * ANGLES(RAD(0), RAD(0), RAD(8)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, 0.5, -0.75) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, -0.4) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(90)), 0.5 / Animation_Speed)
		end
		for i = 1,10 do
			WACKYEFFECT({Time = 60, EffectType = "Block", Size = VT(1,0.5,1)*SIZE, Size2 = VT(2,0.6,2), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 60, EffectType = "Round Slash", Size = VT(1,0.5,1)*SIZE, Size2 = VT(2,0.6,2), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			wait(0.3)
		end
		banish.Parent = Character
		for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, -1.5) * ANGLES(RAD(0), RAD(5), RAD(0)), 0.5 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(15), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 1.25, -0.3) * ANGLES(RAD(0), RAD(0), RAD(0)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, 0.5, -0.75) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(5), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, -0.4) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(5), RAD(0), RAD(90)), 0.5 / Animation_Speed)
		end
		Chat("don't abuse me, if not you will see ...")
		wait(0.05)
		CamShakeAll(10,30,Character)
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		CreateSound("763717897" , Character , 10 , 1 , false)
		mode = "banish"
if RefreshContextButtons then RefreshContextButtons() end
		changecolor("ban")
		tecks2.Text = "Banisher Noob"
		Speed = 20
		song.SoundId = GetAsset("Banish.mp3")
		song:Play()
		ATTACK = false
	elseif mode == "banish" then
		song:Stop()
		song.SoundId = GetAsset("Noobz4life.mp3")
		song:Play()
		banish.Parent = nil
		changecolor("noob")
		mode = "noob"
if RefreshContextButtons then RefreshContextButtons() end
		tecks2.Text = "Noob Switcher V5"
	end
end

function DarkForm()
	if mode == "noob" then
		song:Stop()
		Speed = 0
		Chat("the darkness consumes me.")
		ATTACK = true
		local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
		for i=0, 0.5, 0.1 / Animation_Speed do
		Swait()
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0  + 0.25 * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(15 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, -0.5) * ANGLES(RAD(0), RAD(0), RAD(-85)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.15, -0.5) * ANGLES(RAD(-15), RAD(0), RAD(85)) * LEFTSHOULDERC0, 1 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, -0.01) * ANGLES(RAD(-2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -0.5, -0.5) * ANGLES(RAD(-2.5 * SIN(SINE / 12)), RAD(-90), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
		for i = 1,25 do
			wait(0.08)
			WACKYEFFECT({Time = 50, EffectType = "Slash", Size = VT(2,2,2)*SIZE, Size2 = VT(5,5,5), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("White").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 55, EffectType = "Slash", Size = VT(2,2,2)*SIZE, Size2 = VT(5,5,5), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 35, EffectType = "Block", Size = VT(15,15,15)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		end
		for i=0, 1, 0.1 / Animation_Speed do
		Swait()
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0  + 0.25 * COS(SINE / 12)) * ANGLES(RAD(-35), RAD(0), RAD(0)), 1 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(-15 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, -0.15) * ANGLES(RAD(65), RAD(-45), RAD(85)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, -0.15) * ANGLES(RAD(65), RAD(45), RAD(-85)) * LEFTSHOULDERC0, 1 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, -0.01) * ANGLES(RAD(-35-2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -0.5, -0.5) * ANGLES(RAD(-35-2.5 * SIN(SINE / 12)), RAD(-90), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
		CamShakeAll(10,30,Character)
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		CreateSound("763717897" , Character , 10 , 1 , false)
		Speed = 20
		ATTACK = false
		mode = "dark"
if RefreshContextButtons then RefreshContextButtons() end
		dark.Parent = Character
		changecolor("dark")
		song.SoundId = GetAsset("Warak.mp3")
		song:Play()
		tecks2.Text = "Dark"
	elseif mode == "dark" then
		song:Stop()
		song.SoundId = GetAsset("Noobz4life.mp3")
		song:Play()
		dark.Parent = nil
		changecolor("noob")
		mode = "noob"
if RefreshContextButtons then RefreshContextButtons() end
		tecks2.Text = "Noob Switcher V5"
	end
end


function Shot()
	ATTACK = true
	Rooted = false
	for i=0, 0.5, 0.22 / Animation_Speed do
		Swait()
		turnto(Mouse.Hit.p)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.35, 0.6, -0.4) * ANGLES(RAD(170), RAD(0), RAD(20)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(90)), 0.5 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(-90)), 0.5 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(90), RAD(0), RAD(90)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
	end
	repeat
		for i=0, 0.5, 0.22 / Animation_Speed do
			Swait()
			turnto(Mouse.Hit.p)
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(90)), 0.5 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(-90)), 0.5 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(90), RAD(0), RAD(90)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
           	LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.35, 0.6, -0.4) * ANGLES(RAD(170), RAD(0), RAD(20)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			 RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
		end
		local HIT,POS = CastProperRay(Hole.Position, Mouse.Hit.p, 1000, Character)
		SpawnTrail(Hole.Position,POS)
		if HIT ~= nil then
			if HIT.Parent ~= workspace and HIT.Parent.ClassName ~= "Folder" then
				Banish(HIT.Parent)
			end
		end
		WACKYEFFECT({Time = 25, EffectType = "Wave", Size = VT(0,0,0), Size2 = VT(0,0,0), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = Hole.CFrame*CF(4,4,4).p, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = nil, SoundVolume = nil})
		WACKYEFFECT({Time = 25, EffectType = "Wave", Size = VT(0,0,0), Size2 = VT(0,0,0), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 5, RotationZ = 0, Material = "Neon", Color = C3(0,0,0), SoundID = 904440937, SoundPitch = 0.95, SoundVolume = 0.5})
		WACKYEFFECT({Time = 25, EffectType = "Wave", Size = VT(0,0,0), Size2 = VT(0,0,0), Transparency = 0, Transparency2 = 1, CFrame = CF(POS,Hole.Position) * ANGLES(RAD(-90), RAD(0), RAD(0)), MoveToPos = nil, RotationX = 0, RotationY = -5, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 1, SoundVolume = 8})
		WACKYEFFECT({Time = 25, EffectType = "Wave", Size = VT(0,0,0), Size2 = VT(0,0,0), Transparency = 0, Transparency2 = 1, CFrame = CF(POS,Hole.Position) * ANGLES(RAD(-90), RAD(0), RAD(0)), MoveToPos = nil, RotationX = 0, RotationY = 5, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 1, SoundVolume = 8})
		local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4*SIZE, Character)
		WACKYEFFECT({Time = 15, EffectType = "Wave", Size = VT(0,2,0), Size2 = VT(150,0,150), Transparency = 1, Transparency2 = 1, CFrame = CF(Head.Position) * ANGLES(RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360)), RAD(MRANDOM(0,360))), MoveToPos = nil, RotationX = 0, RotationY = 5, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/2})
		WACKYEFFECT({Time = 15, EffectType = "Wave", Size = VT(0,2,0), Size2 = VT(350,0,350), Transparency = 0.2, Transparency2 = 1, CFrame = CF(HITPOS) * ANGLES(RAD(0), RAD(MRANDOM(0,360)), RAD(0)), MoveToPos = nil, RotationX = 0, RotationY = 5, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = MRANDOM(9,11)/10, SoundVolume = MRANDOM(9,11)/2})
		for i=0, 0.5, 0.22 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(90)), 0.5 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(-90)), 0.25 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.35, 0.6, -0.4) * ANGLES(RAD(170), RAD(0), RAD(20)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(90), RAD(15), RAD(90)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
		end
	until KEYHOLD == false
	ATTACK = false
	Rooted = false
end

function Lava()
	ATTACK = true
	Rooted = false
	Speed = 0
	for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(12)) * RIGHTSHOULDERC0, 0.15 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		end
		for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, -1.5) * ANGLES(RAD(0), RAD(5), RAD(0)), 0.5 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(15), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 1, -0.3) * ANGLES(RAD(0), RAD(0), RAD(0)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, 0.5, -0.75) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(5), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, -0.4) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(5), RAD(0), RAD(90)), 0.5 / Animation_Speed)
		end
		for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			WACKYEFFECT({Time = 100, EffectType = "Block", Size = VT(1,1,1)*SIZE, Size2 = VT(2,2,2), Transparency = 0, Transparency2 = 1, CFrame = RightArm.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(15), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0, -0.3) * ANGLES(RAD(0), RAD(0), RAD(8)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, 0.5, -0.75) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, -0.4) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(90)), 0.5 / Animation_Speed)
		end
		local new = assetScript.Lava:Clone()
		new.Parent = Effects
new.CanCollide = false
new.Anchored = true
new.Position = Vector3.new(Torso.Position.X , Torso.Position.Y - 11 , Torso.Position.Z)
new.Material = "Neon"
new.Color = BrickColor.new("Really red").Color
local trs = 1

for i = 1,10 do
	trs = trs - 0.1
	new.Transparency = trs
	wait(0.1)
end
CreateSound("159882598" , Character , 10 , 1 , false)
Chat("Die!!!")
wait(1)
CreateSound("62339698" , Character , 10 , 0.8 , false)
ApplyAoE(new.Position , 900 , 90 , 100 , 0 , true)
for i = 1,10 do
	trs = trs + 0.1
	new.Position = Vector3.new(new.Position.X , new.Position.Y + 2 , new.Position.Z)
	new.Transparency = trs
	wait(0.08)
end
new:Destroy()
ATTACK = false
Rooted = false
Speed = 20
end

function TimeStop()
	Chat("Now You Are Slow..")
	local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
	local p = game.Players:GetChildren()
	for i = 1,#p do
		if p[i].Name == Player.Name then
		else
			p[i].Character:FindFirstChildOfClass("Humanoid").WalkSpeed = p[i].Character:FindFirstChildOfClass("Humanoid").WalkSpeed/2
		end
	end
	CreateSound("1636723480" , Character , 10 , 1 , false)
	ApplyAoE(HITPOS, 1000 , 25 , 50 , 0 , false)
end

function BlackRole()
	ATTACK = true
	Rooted = false
	Speed = 0
	Chat("beware of the black hole friend.")
	for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 - 0.04 * SIN(SINE / 24)*SIZE, 0 + 0.04 * SIN(SINE / 12)*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0 - 2.5 * SIN(SINE / 24)), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1.1*SIZE) - 1)) * ANGLES(RAD(-25 - 4 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.35*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(115), RAD(45), RAD(35)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.25*SIZE, 0.5*SIZE, 0.5*SIZE) * ANGLES(RAD(-35), RAD(25 - 2.5 * SIN(SINE / 12)), RAD(55 - 2.5 * SIN(SINE / 12))) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE + 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-2 - 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(-75), RAD(0)) * ANGLES(RAD(-2 + 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
	end
	local ball = Instance.new("Part", Character)
	ball.Anchored = true
	ball.Material = "Neon"
	ball.CanCollide = false
	ball.Shape = "Ball"
	ball.Parent = Effects
	ball.Color = BrickColor.new("Black").Color
	ball.Size = Vector3.new(1,1,1)
	ball.Position = Vector3.new(Torso.Position.X , Torso.Position.Y - 10 , Torso.Position.Z)
	wait(0.2)
	for i = 1,25 do
		ball.Position = Vector3.new(ball.Position.X , ball.Position.Y + 1 , ball.Position.Z)
		wait(0.02)
	end
	wait(1)
	local p = game.Workspace:GetChildren()
	for i = 1,#p do
		if p[i].Name == Player.Name then
		elseif p[i]:FindFirstChildOfClass("Humanoid") and p[i]:FindFirstChild("Torso") then
						local yep2 = Instance.new("BodyPosition", p[i].Torso)
	yep2.Position = ball.Position
		end
	end
	local ballS = 1
	for i = 1,14 do
		ballS = ballS + 1
		ball.Size = Vector3.new(ballS,ballS,ballS)
		wait(0.03)
	end
	wait(0.05)
	CreateSound("487214658" , Character , 10 , 1 , false)
	wait(3.64)
	WACKYEFFECT({Time = 70, EffectType = "Block", Size = VT(1,1,1)*SIZE, Size2 = VT(50,50,50), Transparency = 0, Transparency2 = 1, CFrame = ball.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 70, EffectType = "Block", Size = VT(1,1,1)*SIZE, Size2 = VT(50,50,50), Transparency = 0, Transparency2 = 1, CFrame = ball.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
CreateSound("262562442" , Character , 10 , 1 , false)
ApplyAoE(ball.Position , 100 , 90 , 100 , 0 , true)
ball:Destroy()
for i = 1,#p do
		if p[i].Name == Player.Name then
		elseif p[i]:FindFirstChildOfClass("Humanoid") and p[i]:FindFirstChildOfClass("Torso") and p[i].Torso:FindFirstChildOfClass("BodyPosition") then
				p[i].Torso:FindFirstChildOfClass("BodyPosition"):Destroy()
		end
	end
ATTACK = false
Rooted = false
Speed = 20
end

function Neckless()
	local TARGET = Mouse.Target
	if TARGET ~= nil then
		if TARGET.Parent:FindFirstChildOfClass("Humanoid") then
			local HUM = TARGET.Parent:FindFirstChildOfClass("Humanoid")
			local ROOT = TARGET.Parent:FindFirstChild("HumanoidRootPart") or TARGET.Parent:FindFirstChild("Torso") or TARGET.Parent:FindFirstChild("UpperTorso")
			if ROOT and HUM.Health > 0 then
				local FOE = Mouse.Target.Parent
				local HEAD = FOE:FindFirstChild("Head")
				if HEAD then
					ATTACK = true
					Rooted = true
					CharacterFade(C3(1,0,0),150)
					RootPart.CFrame = ROOT.CFrame*CF(0,0,2)
					for _, c in pairs(FOE:GetChildren()) do
						if c.ClassName == "Part" then
							c.Anchored = true
						end
					end
					CreateSound(235097614, Torso, 1, 3, false)
					for i=0, 0.75, 0.1 / Animation_Speed do
						Swait()
						RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0 + 0.05 * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
						Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(0 - 2.5 * COS(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
						RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.1, 0.5, -0.6) * ANGLES(RAD(130), RAD(0), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
						LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.1, 0.5, -0.6) * ANGLES(RAD(130), RAD(0), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
						RightHip.C0 = Clerp(RightHip.C0, CF(1, -1 - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(85), RAD(0)) * ANGLES(RAD(-1), RAD(0), RAD(0)), 1 / Animation_Speed)
						LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1 - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(-85), RAD(0)) * ANGLES(RAD(-1), RAD(0), RAD(0)), 1 / Animation_Speed)
					end
					if ROOT.Name == "HumanoidRootPart" then
						ROOT:remove()
					end

					ApplyDamage(HUM,0,true)
					Chunks(HEAD)
					HEAD.CFrame = HEAD.CFrame  * ANGLES(RAD(0), RAD(90), RAD(0))
					CreateSound(363808674, HEAD, 15, 1, false)
					ROOT.Anchored = false
					for i=0, 0.5, 0.1 / Animation_Speed do
						Swait()
						RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0 + 0.05 * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
						Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(0 - 2.5 * COS(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
						RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.1, 0.65, -1.5) * ANGLES(RAD(130), RAD(0), RAD(-35)) * RIGHTSHOULDERC0, 2 / Animation_Speed)
						LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.1, 0.5, 0) * ANGLES(RAD(130), RAD(0), RAD(0)) * LEFTSHOULDERC0, 2 / Animation_Speed)
						RightHip.C0 = Clerp(RightHip.C0, CF(1, -1 - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(85), RAD(0)) * ANGLES(RAD(-1), RAD(0), RAD(0)), 1 / Animation_Speed)
						LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1 - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(-85), RAD(0)) * ANGLES(RAD(-1), RAD(0), RAD(0)), 1 / Animation_Speed)
					end
					for _, c in pairs(FOE:GetChildren()) do
						if c.ClassName == "Part" then
							c.Anchored = false
						end
					end
					ATTACK = false
					Rooted = false
				end
			end
		end
	end
end

function Lunar_Blast()
    local HITBODIES = {}
    local CENTER = CreatePart(3, Effects, "SmoothPlastic", 0, 1, "Relly red", "CenterPart", VT(0,0,0))
    local HITFLOOR,ECH,NORMAL = Raycast(Mouse.Hit.p+VT(0,2,0), (CF(Mouse.Hit.p, Mouse.Hit.p + VT(0, -1, 0))).lookVector, 10000000, Character)
    CENTER.CFrame = CF(ECH)
    local RAY = CreatePart(3, Effects, "Neon", 0, 1, "Relly red", "Laser01", VT(25,99999,25))
    RAY.Color = BrickColor.new("New Yeller").Color
    MakeForm(RAY,"Cyl")
    RAY.CFrame = CF(ECH)
    for i = 1, 75 do
        Swait()
        RAY.Transparency = RAY.Transparency - 1/75
        RAY.Size = RAY.Size - VT(25/75,0,25/75)
        MagicSphere(VT(1,1,1),15,CF(ECH)*CF(MRANDOM(-15,15),MRANDOM(0,100),MRANDOM(-15,15)),C3(1,1,1),VT(0,0,0))
    end
    killnearest(ECH,25,25)
CamShakeAll(12,20,Character)
    MagicSphere(VT(0,0,0),55,CF(ECH),BrickColor.new("New Yeller").Color,VT(2,2,2))
    for i = 1, 25 do
        MagicSphere(VT(1,1,1),i*3,CF(ECH)*CF(MRANDOM(-45,45),MRANDOM(-45,45),MRANDOM(-45,45)),C3(1,1,1),VT(0,0,0))
    end
    CreateSound("168586621", CENTER, 10, 0.8)
    RAY:remove()
    Debris:AddItem(CENTER,5)
end

function SuperDominus()
	ATTACK = true
	Rooted = false
	Speed = 0
	Chat("This is...")
	local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
	for i=0, 2, 0.1 / Animation_Speed do
				Swait()
				WACKYEFFECT({Time = 35, EffectType = "Block", Size = VT(1,1,1)*SIZE, Size2 = VT(2,2,2), Transparency = 0, Transparency2 = 1, CFrame = RightLeg.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
				RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(-15), RAD(0), RAD(0)), 2 / Animation_Speed)
				Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(25), RAD(0), RAD(0)), 2 / Animation_Speed)
				RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(-25), RAD(0), RAD(0)) * RIGHTSHOULDERC0, 2 / Animation_Speed)
				LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(-25), RAD(0), RAD(0)) * LEFTSHOULDERC0, 2 / Animation_Speed)
				RightHip.C0 = Clerp(RightHip.C0, CF(1, -0.35, -0.75) * ANGLES(RAD(50), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 2 / Animation_Speed)
				LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(-30), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 2 / Animation_Speed)
	end
			for i=0, 0.9, 0.1 / Animation_Speed do
				Swait()
				RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, -0.4, -0.1) * ANGLES(RAD(35), RAD(0), RAD(0)), 1 / Animation_Speed)
				Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(25), RAD(0), RAD(0)), 1 / Animation_Speed)
				RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(45), RAD(0), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
				LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(45), RAD(0), RAD(0)) * LEFTSHOULDERC0, 1 / Animation_Speed)
				RightHip.C0 = Clerp(RightHip.C0, CF(1, -0.9, -0.6) * ANGLES(RAD(35), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
				LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1.1, 0) * ANGLES(RAD(35), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 1 / Animation_Speed)
			end
			Chat("Epic Broooooooo !!!")
			CamShakeAll(60,300,Character)
			WACKYEFFECT({Time = 70, EffectType = "Wave", Size = VT(1,1,1)*SIZE, Size2 = VT(200,100,200), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 70, EffectType = "Wave", Size = VT(1,1,1)*SIZE, Size2 = VT(100,200,100), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			ApplyAoE(HITPOS,200,100,100,0,true)
			CreateSound("824687369" , Torso , 10 , 0.7 , false)
			WACKYEFFECT({Time = 70, EffectType = "Block", Size = VT(1,1,1)*SIZE, Size2 = VT(130,130,130), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 70, EffectType = "Ring", Size = VT(1,1,1)*SIZE, Size2 = VT(30.15,30.14,30.14), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = -15, RotationY = 0, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 70, EffectType = "Ring", Size = VT(1,1,1)*SIZE, Size2 = VT(30.14,30.14,30.15), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = -15, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 70, EffectType = "Ring", Size = VT(1,1,1)*SIZE, Size2 = VT(30.14,30.15,30.14), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = -15, RotationY = 0, RotationZ = -15, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
wait(1)
ATTACK = false
Rooted = false
Speed = 20
end

function ClockDestroyer()
	ATTACK = true
	Rooted = false
	Speed = 0
	local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
	local p = game.Players:GetChildren()
	for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 - 0.04 * SIN(SINE / 24)*SIZE, 0 + 0.04 * SIN(SINE / 12)*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0 - 2.5 * SIN(SINE / 24)), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1.1*SIZE) - 1)) * ANGLES(RAD(-25 - 4 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.35*SIZE, 0.65*SIZE, 0*SIZE) * ANGLES(RAD(115), RAD(45), RAD(35)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.25*SIZE, 0.5*SIZE, 0.5*SIZE) * ANGLES(RAD(-35), RAD(25 - 2.5 * SIN(SINE / 12)), RAD(55 - 2.5 * SIN(SINE / 12))) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE + 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-2 - 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(-75), RAD(0)) * ANGLES(RAD(-2 + 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
	end
	for i = 1,#p do
		if p[i].Name == Player.Name then
		else
			p[i].Character:FindFirstChildOfClass("Humanoid").WalkSpeed = p[i].Character:FindFirstChildOfClass("Humanoid").WalkSpeed/2
		end
	end
	CreateSound("1636723480" , Character , 10 , 1 , false)
	Chat("You dont Can Escape..")
	WACKYEFFECT({Time = 50, EffectType = "Wave", Size = VT(1,1,1)*SIZE, Size2 = VT(10,500,10), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
	local bom = true
		coroutine.resume(coroutine.create(function()
			repeat
				WACKYEFFECT({Time = 35, EffectType = "Block", Size = VT(0.5,0.5,0.5)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Neon orange").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
				wait(0.06)
			until bom == false
		end))
	for i = 1,20 do
		local bomb = assetScript.Bomb:Clone()
		bomb.Parent = Effects
		local x = math.random(-100,100)
		local z = math.random(-100,100)
		bomb.Position = Vector3.new(Torso.Position.X + x, Torso.Position.Y + 70 , Torso.Position.Z + z)
		coroutine.resume(coroutine.create(function()
			local ps = bomb.Position.Y
			for i = 1,48 do
				ps = ps - 1.5
				bomb.Position =  Vector3.new(bomb.Position.X, ps , bomb.Position.Z)
				wait(0.0005)
			end
					WACKYEFFECT({Time = 35, EffectType = "Block", Size = VT(1,1,1)*SIZE, Size2 = VT(15,15,15), Transparency = 0, Transparency2 = 1, CFrame = bomb.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
					WACKYEFFECT({Time = 50, EffectType = "Block", Size = VT(1,1,1)*SIZE, Size2 = VT(25,25,25), Transparency = 0, Transparency2 = 1, CFrame = bomb.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
					ApplyAoE(bomb.Position , 15 , 30 , 40 , 0 , false)
					CreateSound("168586621" , bomb , 10 , 0.7 , false)
					bomb.Transparency = 1
					wait(1)
					bomb:Destroy()
		end))
		wait(0.5)
	end
	bom = false
	ATTACK = false
	Rooted = false
	Speed = 20
end

function BlastShoot()
	ATTACK = true
	Rooted = false
	for i=0, 0.5, 0.22 / Animation_Speed do
		Swait()
		turnto(Mouse.Hit.p)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.35, 0.6, -0.4) * ANGLES(RAD(170), RAD(0), RAD(20)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(90)), 0.5 / Animation_Speed)
		Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(-90)), 0.5 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(90), RAD(0), RAD(90)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
		RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
		LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
	end
	CreateSound(363808674, Effects, 10, 1, false)
	for i = 1,6 do
	WACKYEFFECT({Time = 45, EffectType = "Block", Size = VT(0.2,0.2,0.2)*SIZE, Size2 = VT(0.8,0.8,0.8), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
WACKYEFFECT({Time = 55, EffectType = "Sphere", Size = VT(3.55,3.55,3.55), Size2 = VT(95,95,95), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 30, RotationY = 30, RotationZ = 30, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = 743521450, SoundPitch = 0.95, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Sphere", Size = VT(3.55,3.5,3.5), Size2 = VT(50,3.5,3.5), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 30, RotationY = 30, RotationZ = 30, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = 0, SoundPitch = 0.95, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Sphere", Size = VT(3.5,3.5,3.55), Size2 = VT(3.5,3.5,50), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 30, RotationY = 30, RotationZ = 30, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = 0, SoundPitch = 0.95, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Sphere", Size = VT(3.5,3.55,3.5), Size2 = VT(3.5,50,3.5), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 30, RotationY = 30, RotationZ = 30, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = 0, SoundPitch = 0.95, SoundVolume = 6})
		wait(0.5)
	end
	for i=0, 0.5, 0.22 / Animation_Speed do
			Swait()
			turnto(Mouse.Hit.p)
			RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(90)), 0.5 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(-90)), 0.5 / Animation_Speed)
			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(90), RAD(0), RAD(90)) * RIGHTSHOULDERC0, 0.5 / Animation_Speed)
           	LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.35, 0.6, -0.4) * ANGLES(RAD(170), RAD(0), RAD(20)) * LEFTSHOULDERC0, 0.5 / Animation_Speed)
			 RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.5 / Animation_Speed)
	end
	local HIT,POS = CastProperRay(Hole.Position, Mouse.Hit.p, 1000, Character)
		SpawnTrail(Hole.Position,POS)
		ATTACK = false
		Rooted = false
		coroutine.resume(coroutine.create(function()
		local int = Instance.new("Part", Effects)
		int.Anchored = true
		int.CanCollide = false
		int.Transparency = 1
		int.Position = Mouse.Hit.Position
		wait(0.1)
		WACKYEFFECT({Time = 50, EffectType = "Sphere", Size = VT(20,20,20)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		wait(0.5)
		for i= 1,4 do
		WACKYEFFECT({Time = 25, EffectType = "Sphere", Size = VT(1,1,1)*SIZE, Size2 = VT(1,400,1), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = -15, RotationY = 0, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 25, EffectType = "Sphere", Size = VT(1,1,1)*SIZE, Size2 = VT(1,400,1), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = -15, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 25, EffectType = "Sphere", Size = VT(1,1,1)*SIZE, Size2 = VT(1,400,1), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
wait(0.6)
end

wait(1)
WACKYEFFECT({Time = 50, EffectType = "Sphere", Size = VT(1,1,1)*SIZE, Size2 = VT(400,400,400), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
WACKYEFFECT({Time = 50, EffectType = "Sphere", Size = VT(1,1,1)*SIZE, Size2 = VT(1,400,1), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = -15, RotationY = 0, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 50, EffectType = "Sphere", Size = VT(1,1,1)*SIZE, Size2 = VT(1,400,1), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = -15, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 50, EffectType = "Sphere", Size = VT(1,1,1)*SIZE, Size2 = VT(1,400,1), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
	ApplyAoE(int.CFrame , 400 , 999 , 999 , false , true)
		CamShakeAll(400,900,Character)
		CreateSound("763717897" , workspace , 10 , 1 , false)
		wait(0.5)
		int:Destroy()
		end))
end

function LightForm()
	if mode == "dark" then
		ATTACK = true
		Speed = 0
		song:Stop()
		for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(15 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, -0.5) * ANGLES(RAD(0), RAD(0), RAD(-85)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.15, -0.5) * ANGLES(RAD(-15), RAD(0), RAD(85)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		end
		for i = 1,10 do
			WACKYEFFECT({Time = 80, EffectType = "Sphere", Size = VT(1,0.5,0.5)*SIZE, Size2 = VT(200,0.5,0.5), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -7, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 80, EffectType = "Sphere", Size = VT(1,0.5,0.5)*SIZE, Size2 = VT(200,0.5,0.5), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = -7, RotationY = -7, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 80, EffectType = "Sphere", Size = VT(1,0.5,0.5)*SIZE, Size2 = VT(200,0.5,0.5), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -7, RotationZ = -7, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		wait(0.54)
		end
		for i = 0, 1, 0.1 / Animation_Speed do
			Swait()
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(-15 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
		RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, -0.15) * ANGLES(RAD(65), RAD(-45), RAD(85)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
		LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, -0.15) * ANGLES(RAD(65), RAD(45), RAD(-85)) * LEFTSHOULDERC0, 1 / Animation_Speed)
			RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
		end
		local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(10,1,10)*SIZE, Size2 = VT(600,1,600), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		WACKYEFFECT({Time = 40, EffectType = "Block", Size = VT(60,60,60)*SIZE, Size2 = VT(60,60,60), Transparency = 0, Transparency2 = 1, CFrame = Torso.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
	CreateSound("763717897" , Character , 10 , 1 , false)
	mode = "light"
if RefreshContextButtons then RefreshContextButtons() end
	song.SoundId = GetAsset("Light.mp3")
	changecolor("light")
	Speed = 20
	song:Play()
	tecks2.Text = "Light"
	lg.Parent = Character
	ATTACK = false
	dark.Parent = nil
	elseif mode == "light" then
		changecolor("noob")
		lg.Parent = nil
		mode = "noob"
if RefreshContextButtons then RefreshContextButtons() end
		tecks2.Text = "Noob Switcher V5"
		song:Stop()
		song.SoundId = GetAsset("Noobz4life.mp3")
		song:Play()
	end
end

changecolor("noob")
coroutine.resume(coroutine.create(function()
	while true do
		if mode == "banish" then
			wait(0.3)
			local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
			WACKYEFFECT({Time = 45, EffectType = "Block", Size = VT(0.2,0.2,0.2)*SIZE, Size2 = VT(0.8,0.8,0.8), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 37, EffectType = "Wave", Size = VT(45,0.5,45)*SIZE, Size2 = VT(0.5,1,0.5), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		for i = 1,2 do
			WACKYEFFECT({Time = 80, EffectType = "Ring", Size = VT(0.1,0.1,0.1)*SIZE, Size2 = VT(0.15,0.14,0.14), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = -15, RotationY = 0, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 65, EffectType = "Ring", Size = VT(0.1,0.1,0.1)*SIZE, Size2 = VT(0.14,0.14,0.15), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = -15, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 45, EffectType = "Ring", Size = VT(0.1,0.1,0.1)*SIZE, Size2 = VT(0.14,0.15,0.14), Transparency = 0, Transparency2 = 1, CFrame = Hole.CFrame, MoveToPos = nil, RotationX = -15, RotationY = 0, RotationZ = -15, Material = "Neon", Color = BrickColor.new("Really red").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		end
		end
		if mode == "dark" then
			wait(1)
			WACKYEFFECT({Time = 100, EffectType = "Block", Size = VT(0.5,0.5,0.5)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 100, EffectType = "Block", Size = VT(0.5,0.5,0.5)*SIZE, Size2 = VT(1,1,1), Transparency = 0, Transparency2 = 1, CFrame = clone2.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Black").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 100, EffectType = "Slash", Size = VT(0.1,0.1,0.1)*SIZE, Size2 = VT(0.2,0.2,0.2), Transparency = 0, Transparency2 = 1, CFrame = clone.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("White").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
			WACKYEFFECT({Time = 100, EffectType = "Slash", Size = VT(0.1,0.1,0.1)*SIZE, Size2 = VT(0.2,0.2,0.2), Transparency = 0, Transparency2 = 1, CFrame = clone2.CFrame, MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("White").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		end
		if mode == "dominus" then
			wait(1)
			local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
		WACKYEFFECT({Time = 100, EffectType = "Wave", Size = VT(1,1,1)*SIZE, Size2 = VT(400,1,400), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("New Yeller").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		end
		if mode == "light" then
			wait(0.6)
			CamShakeAll(13,25,Character)
			local HITFLOOR,HITPOS = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 25*SIZE, Character)
		WACKYEFFECT({Time = 59, EffectType = "Sphere", Size = VT(1,0.1,1)*SIZE, Size2 = VT(10,0.1,10), Transparency = 0, Transparency2 = 1, CFrame = CF(HITPOS), MoveToPos = nil, RotationX = 0, RotationY = -15, RotationZ = 0, Material = "Neon", Color = BrickColor.new("Institutional white").Color, SoundID = nil, SoundPitch = 0.5, SoundVolume = 6})
		end
		wait(0.02)
	end
end))






local function MouseDown()
    if ATTACK == false then
    end
end

local function MouseUp()
    HOLD = false
end

local KeyDown

local MODE_BUTTONS = {
    {key = Enum.KeyCode.E, name = "NoobSwitcher_E", title = "Master (E)"},
    {key = Enum.KeyCode.Q, name = "NoobSwitcher_Q", title = "Banish (Q)"},
    {key = Enum.KeyCode.R, name = "NoobSwitcher_R", title = "Dark (R)"},
    {key = Enum.KeyCode.T, name = "NoobSwitcher_T", title = "Dominus (T)"},
    {key = Enum.KeyCode.F, name = "NoobSwitcher_F", title = "Robot (F)"},
    {key = Enum.KeyCode.L, name = "NoobSwitcher_L", title = "Light (L)"},
}

local ATTACK_BUTTONS = {
    master = {
        {key = Enum.KeyCode.Z, name = "NoobSwitcher_Z", title = "Time Stop (Z)"},
        {key = Enum.KeyCode.X, name = "NoobSwitcher_X", title = "Black Role (X)"},
        {key = Enum.KeyCode.C, name = "NoobSwitcher_C", title = "Clock Destroyer (C)"},
    },
    banish = {
        {key = Enum.KeyCode.Z, name = "NoobSwitcher_Z", title = "Shot (Z)"},
        {key = Enum.KeyCode.X, name = "NoobSwitcher_X", title = "Lava (X)"},
        {key = Enum.KeyCode.C, name = "NoobSwitcher_C", title = "Blast Shoot (C)"},
    },
    dark = {
        {key = Enum.KeyCode.Z, name = "NoobSwitcher_Z", title = "Neckless (Z)"},
    },
    dominus = {
        {key = Enum.KeyCode.Z, name = "NoobSwitcher_Z", title = "Lunar Blast (Z)"},
        {key = Enum.KeyCode.X, name = "NoobSwitcher_X", title = "Super Dominus (X)"},
    },
    robot = {},
    light = {},
}

local MODE_KEY_BY_MODE = {
    master = Enum.KeyCode.E,
    banish = Enum.KeyCode.Q,
    dark = Enum.KeyCode.R,
    dominus = Enum.KeyCode.T,
    robot = Enum.KeyCode.F,
    light = Enum.KeyCode.L,
}

local function AddContextButton(bindings, entry, position)
    ContextActions:BindAction(entry.name, function(_, state)
        if state == Enum.UserInputState.Begin then
            KeyDown(entry.key)
        elseif state == Enum.UserInputState.End then
            KeyUp()
        end
    end, true, entry.key)
    ContextActions:SetTitle(entry.name, entry.title)
    if position then
        ContextActions:SetPosition(entry.name, position)
    end
    bindings[#bindings + 1] = entry.name
end

RefreshContextButtons = function()
    for _, name in ipairs(actionBindings) do
        pcall(function() ContextActions:UnbindAction(name) end)
    end
    table.clear(actionBindings)

    local entries = {}
    if mode == "noob" then

        for _, entry in ipairs(MODE_BUTTONS) do
            entries[#entries + 1] = entry
        end
    else

        local modeKey = MODE_KEY_BY_MODE[mode]
        if modeKey then
            for _, entry in ipairs(MODE_BUTTONS) do
                if entry.key == modeKey then
                    entries[#entries + 1] = entry
                    break
                end
            end
        end
        for _, entry in ipairs(ATTACK_BUTTONS[mode] or {}) do
            entries[#entries + 1] = entry
        end
    end




    local cols = 2
    for i, entry in ipairs(entries) do
        local index = i - 1
        local col = index % cols
        local row = math.floor(index / cols)
        local position = UDim2.new(1, -130 - col * 50, 1, -130 - row * 50)
        AddContextButton(actionBindings, entry, position)
    end
end

KeyDown = function(key)
    KEYHOLD = true
    if ATTACK then return end

    if key == Enum.KeyCode.Z then
        if mode == "banish" then
            task.spawn(Shot)
        elseif mode == "master" then
            task.spawn(TimeStop)
        elseif mode == "dark" then
            task.spawn(Neckless)
        elseif mode == "dominus" then
            task.spawn(Lunar_Blast)
        end
    elseif key == Enum.KeyCode.X then
        if mode == "banish" then
            task.spawn(Lava)
        elseif mode == "master" then
            task.spawn(BlackRole)
        elseif mode == "dominus" then
            task.spawn(SuperDominus)
        end
    elseif key == Enum.KeyCode.C then
        if mode == "master" then
            task.spawn(ClockDestroyer)
        elseif mode == "banish" then
            task.spawn(BlastShoot)
        end
    elseif key == Enum.KeyCode.E then
        task.spawn(MasterForm)
    elseif key == Enum.KeyCode.Q then
        task.spawn(BanishForm)
    elseif key == Enum.KeyCode.R then
        task.spawn(DarkForm)
    elseif key == Enum.KeyCode.T then
        task.spawn(DominusForm)
    elseif key == Enum.KeyCode.F then
        task.spawn(RobotForm)
    elseif key == Enum.KeyCode.L then
        task.spawn(LightForm)
    end
end

function KeyUp()
    KEYHOLD = false
end

local function BindMovesetInput()
    RefreshContextButtons()
    return actionBindings
end



        if Mouse then
            local cam = workspace.CurrentCamera
            updateConnection = RunService.RenderStepped:Connect(function()
                if not moduleAlive then return end
                if not cam then cam = workspace.CurrentCamera end


            end)
        end

        legacyHeartbeatConnection = heartbeatConnection

        BindMovesetInput()

        moduleAlive = true



        animationThread = task.spawn(function()
            while moduleAlive do
                Swait()
                if ANIMATE then
                    ANIMATE.Parent = nil
                end
                SINE = SINE + CHANGE
                local TORSOVELOCITY = (RootPart.Velocity * VT(1, 0, 1)).magnitude
                local TORSOVERTICALVELOCITY = RootPart.Velocity.y
                local LV = Torso.CFrame:pointToObjectSpace(Torso.Velocity - Torso.Position)
                HITFLOOR = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4 * Player_Size, Character)
                local WALKSPEEDVALUE = 0
                if Speed < 35 then
                    WALKSPEEDVALUE = 6
                else
                    WALKSPEEDVALUE = 3
                end
                if ANIM == "Walk" and TORSOVELOCITY > 1 and Rooted == false then
                    RootJoint.C1 = Clerp(RootJoint.C1, ROOTC0 * CF(0, 0, -0.15 * COS(SINE / (WALKSPEEDVALUE / 2)) * Player_Size) * ANGLES(RAD(0), RAD(0) - RootPart.RotVelocity.Y / 75, RAD(0)), 2 * (1) / Animation_Speed)
                    Neck.C1 = Clerp(Neck.C1, CF(0 * Player_Size, -0.5 * Player_Size, 0 * Player_Size) * ANGLES(RAD(-90), RAD(0), RAD(180)) * ANGLES(RAD(2.5 * SIN(SINE / (WALKSPEEDVALUE / 2))), RAD(0), RAD(0) - Head.RotVelocity.Y / 30), 0.2 * (Humanoid.WalkSpeed / 16) / Animation_Speed)
                    if Speed < 35 then
                        RightHip.C1 = Clerp(RightHip.C1, CF(0.5 * Player_Size, 0.875 * Player_Size - 0.125 * SIN(SINE / WALKSPEEDVALUE) * Player_Size, -0.125 * COS(SINE / WALKSPEEDVALUE) * Player_Size) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0) - RightLeg.RotVelocity.Y / 75, RAD(0), RAD(56 * COS(SINE / WALKSPEEDVALUE))), 0.2 * (WALKSPEEDVALUE) / Animation_Speed)
                        LeftHip.C1 = Clerp(LeftHip.C1, CF(-0.5 * Player_Size, 0.875 * Player_Size + 0.125 * SIN(SINE / WALKSPEEDVALUE) * Player_Size, 0.125 * COS(SINE / WALKSPEEDVALUE) * Player_Size) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0) + LeftLeg.RotVelocity.Y / 75, RAD(0), RAD(56 * COS(SINE / WALKSPEEDVALUE))), 0.2 * (WALKSPEEDVALUE) / Animation_Speed)
                    else
                        RightHip.C1 = Clerp(RightHip.C1, CF(0.5 * Player_Size, 0.875 * Player_Size - 0.125 * SIN(SINE / WALKSPEEDVALUE) * Player_Size, -0.125 * COS(SINE / WALKSPEEDVALUE) * Player_Size) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0) - RightLeg.RotVelocity.Y / 75, RAD(0), RAD(80 * COS(SINE / WALKSPEEDVALUE))), 0.2 * (WALKSPEEDVALUE) / Animation_Speed)
                        LeftHip.C1 = Clerp(LeftHip.C1, CF(-0.5 * Player_Size, 0.875 * Player_Size + 0.125 * SIN(SINE / WALKSPEEDVALUE) * Player_Size, 0.125 * COS(SINE / WALKSPEEDVALUE) * Player_Size) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0) + LeftLeg.RotVelocity.Y / 75, RAD(0), RAD(80 * COS(SINE / WALKSPEEDVALUE))), 0.2 * (WALKSPEEDVALUE) / Animation_Speed)
                    end
                elseif (ANIM ~= "Walk") or (TORSOVELOCITY < 1) or Rooted == true then
                    RootJoint.C1 = Clerp(RootJoint.C1, ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
                    Neck.C1 = Clerp(Neck.C1, CF(0 * Player_Size, -0.5 * Player_Size, 0 * Player_Size) * ANGLES(RAD(-90), RAD(0), RAD(180)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
                    RightHip.C1 = Clerp(RightHip.C1, CF(0.5 * Player_Size, 1 * Player_Size, 0 * Player_Size) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
                    LeftHip.C1 = Clerp(LeftHip.C1, CF(-0.5 * Player_Size, 1 * Player_Size, 0 * Player_Size) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
                end
                if TORSOVERTICALVELOCITY > 1 and HITFLOOR == nil then
                    ANIM = "Jump"
                    if ATTACK == false then
                        RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, 0) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
                        Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0 * Player_Size, 0 + ((1) - 1)) * ANGLES(RAD(-20), RAD(0), RAD(0)), 0.2 / Animation_Speed)
                        RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(-40), RAD(0), RAD(20)) * RIGHTSHOULDERC0, 0.2 / Animation_Speed)
                        LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(-40), RAD(0), RAD(-20)) * LEFTSHOULDERC0, 0.2 / Animation_Speed)
                        RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, -0.3) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(-20)), 0.2 / Animation_Speed)
                        LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, -0.3) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(-5), RAD(0), RAD(20)), 0.2 / Animation_Speed)
                    end
                elseif TORSOVERTICALVELOCITY < -1 and HITFLOOR == nil then
                    ANIM = "Fall"
                    if ATTACK == false then
                        RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, 0 ) * ANGLES(RAD(0), RAD(0), RAD(0)), 0.2 / Animation_Speed)
                        Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0 , 0 + ((1) - 1)) * ANGLES(RAD(20), RAD(0), RAD(0)), 0.2 / Animation_Speed)
                        RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(60)) * RIGHTSHOULDERC0, 0.2 / Animation_Speed)
                        LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-60)) * LEFTSHOULDERC0, 0.2 / Animation_Speed)
                        RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, 0) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(20)), 0.2 / Animation_Speed)
                        LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1, 0) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(10)), 0.2 / Animation_Speed)
                    end
                elseif TORSOVELOCITY < 1 and HITFLOOR ~= nil then
                    ANIM = "Idle"
                    if ATTACK == false then
            	if mode == "noob" then
                       RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 - 0.04 * SIN(SINE / 24)*SIZE, 0 + 0.04 * SIN(SINE / 12)*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0 - 2.5 * SIN(SINE / 24)), RAD(0)), 1 / Animation_Speed)
            			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(-5 - 2.5 * SIN(SINE / 12)), RAD(7 * COS(SINE / 24)), RAD(0)), 1 / Animation_Speed)
            			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.25*SIZE, 0.5*SIZE, 0.5*SIZE) * ANGLES(RAD(-35), RAD(-25 + 2.5 * SIN(SINE / 12)), RAD(-55 + 2.5 * SIN(SINE / 12))) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.25*SIZE, 0.5*SIZE, 0.5*SIZE) * ANGLES(RAD(-35), RAD(25 - 2.5 * SIN(SINE / 12)), RAD(55 - 2.5 * SIN(SINE / 12))) * LEFTSHOULDERC0, 1 / Animation_Speed)
            			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE + 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-2 - 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
            			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(-75), RAD(0)) * ANGLES(RAD(-2 + 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
            	        elseif mode == "master" then
            		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 - 0.04 * SIN(SINE / 24)*SIZE, 0 + 0.04 * SIN(SINE / 12)*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0 - 2.5 * SIN(SINE / 24)), RAD(0)), 1 / Animation_Speed)
            			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(-5 - 2.5 * SIN(SINE / 12)), RAD(7 * COS(SINE / 24)), RAD(0)), 1 / Animation_Speed)
            			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 1*SIZE, -0.3*SIZE) * ANGLES(RAD(0.98), RAD(-119.59 + 2.5 * SIN(SINE / 25)), RAD(-175.39 + 2.5 * SIN(SINE / 12))) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.25*SIZE, 0.5*SIZE, 0.5*SIZE) * ANGLES(RAD(-35), RAD(25 - 2.5 * SIN(SINE / 12)), RAD(55 - 2.5 * SIN(SINE / 12))) * LEFTSHOULDERC0, 1 / Animation_Speed)
            			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE + 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-2 - 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
            			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(-75), RAD(0)) * ANGLES(RAD(-2 + 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
            	elseif mode == "banish" then
            RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0 + 0.05 * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(-45)), 0.15 / Animation_Speed)
            			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(45)), 0.15 / Animation_Speed)
            			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.35, 0.5, -0.5) * ANGLES(RAD(130), RAD(-35), RAD(-7))* RIGHTSHOULDERC0, 0.15 / Animation_Speed)
            			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.25, 0.5, 0.5) * ANGLES(RAD(-25), RAD(0), RAD(-15)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
            			RightHip.C0 = Clerp(RightHip.C0, CF(1, -1 - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(75), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
            			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1 - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(-50), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
            elseif mode == "dark" then
            RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0 + 0.05 * COS(SINE / 12)) * ANGLES(RAD(0), RAD(0), RAD(-45)), 0.15 / Animation_Speed)
            			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(45)), 0.15 / Animation_Speed)
            			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5*SIZE, 0.5*SIZE, -0.1*SIZE) * ANGLES(RAD(-35), RAD(-500 + 2.5 * SIN(SINE / 12)), RAD(-55 + 2.5 * SIN(SINE / 12))) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5*SIZE, 0.5*SIZE, -0.1*SIZE) * ANGLES(RAD(-35), RAD(500 - 2.5 * SIN(SINE / 12)), RAD(55 - 2.5 * SIN(SINE / 12))) * LEFTSHOULDERC0, 1 / Animation_Speed)
            			RightHip.C0 = Clerp(RightHip.C0, CF(1, -1 - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(75), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
            			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1 - 0.05 * COS(SINE / 12), -0.01) * ANGLES(RAD(0), RAD(-50), RAD(0)) * ANGLES(RAD(-8), RAD(0), RAD(0)), 0.15 / Animation_Speed)
            	elseif mode == "dominus" then
            		 RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, 0 + 0.25 * COS(SINE / 12)) * ANGLES(RAD(4 + 2.5 * SIN(SINE / 12)), RAD(0), RAD(5 + 2.5 * SIN(SINE / 12))), 1 / Animation_Speed)
                        Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(0 + 4.5 * SIN(SINE / 12)), RAD(0), RAD(-5 - 2.5 * SIN(SINE / 12))), 1 / Animation_Speed)
                        RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5 + 0.25 * COS(SINE / 12), 0) * ANGLES(RAD(0), RAD(0 - 2.5 * SIN(SINE / 12)), RAD(5 + 7.5 * SIN(SINE / 12))) * RIGHTSHOULDERC0, 1 / Animation_Speed)
                        LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5 + 0.25 * COS(SINE / 12), 0) * ANGLES(RAD(0), RAD(0 + 2.5 * SIN(SINE / 12)), RAD(-5 - 7.5 * SIN(SINE / 12))) * LEFTSHOULDERC0, 1 / Animation_Speed)
                        RightHip.C0 = Clerp(RightHip.C0, CF(1, -1, -0.01) * ANGLES(RAD(-2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
                        LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -0.5, -0.5) * ANGLES(RAD(-2.5 * SIN(SINE / 12)), RAD(-90), RAD(0)) * ANGLES(RAD(-8 - 2.5 * SIN(SINE / 12)), RAD(0), RAD(0)), 1 / Animation_Speed)
            elseif mode == "robot" then
            		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 - 0.04 * SIN(SINE / 24)*SIZE, 0 + 0.04 * SIN(SINE / 12)*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0 - 2.5 * SIN(SINE / 24)), RAD(0)), 1 / Animation_Speed)
            			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(-5 - 2.5 * SIN(SINE / 12)), RAD(7 * COS(SINE / 24)), RAD(0)), 1 / Animation_Speed)
            			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1, 0.5 + 0.05 * SIN(SINE / 12), -0.5) * ANGLES(RAD(0), RAD(0), RAD(-100)) * ANGLES(RAD(20), RAD(0), RAD(0)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
            			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE + 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-2 - 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
            			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(-75), RAD(0)) * ANGLES(RAD(-2 + 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
            	elseif mode == "light" then
            		RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0 - 0.04 * SIN(SINE / 24)*SIZE, 0 + 0.04 * SIN(SINE / 12)*SIZE, 0 + 0.05*SIZE * COS(SINE / 12)) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(0 - 2.5 * SIN(SINE / 24)), RAD(0)), 1 / Animation_Speed)
            			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(-5 - 2.5 * SIN(SINE / 12)), RAD(7 * COS(SINE / 24)), RAD(0)), 1 / Animation_Speed)
            			RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(12)) * RIGHTSHOULDERC0, 0.15 / Animation_Speed)
            			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(0), RAD(0), RAD(-12)) * LEFTSHOULDERC0, 0.15 / Animation_Speed)
            			RightHip.C0 = Clerp(RightHip.C0, CF(1*SIZE, -1*SIZE + 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(75), RAD(0)) * ANGLES(RAD(-2 - 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)
            			LeftHip.C0 = Clerp(LeftHip.C0, CF(-1*SIZE, -1*SIZE - 0.06 * SIN(SINE / 24) - 0.05*SIZE * COS(SINE / 12), -0.01*SIZE) * ANGLES(RAD(0 - 2.5 * SIN(SINE / 12)), RAD(-75), RAD(0)) * ANGLES(RAD(-2 + 2.5 * SIN(SINE / 24)), RAD(0), RAD(0)), 1 / Animation_Speed)

            end
            end
                elseif TORSOVELOCITY > 1 and HITFLOOR ~= nil and Rooted == false then
                    ANIM = "Walk"


                    if ATTACK == false then
                        if Speed < 35 then
                            RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, -0.1) * ANGLES(RAD(5), RAD(0), RAD(0)), 0.15 / Animation_Speed)
                            Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(5 - 8 * SIN(SINE / (WALKSPEEDVALUE / 2))), RAD(0), RAD(0)), 0.15 / Animation_Speed)
                            RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.25*SIZE, 0.5*SIZE, 0.3*SIZE) * ANGLES(RAD(-45), RAD(0), RAD(-45)) * RIGHTSHOULDERC0, 1 / Animation_Speed)
            			LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.25*SIZE, 0.5*SIZE, 0.3*SIZE) * ANGLES(RAD(-40), RAD(0), RAD(45)) * LEFTSHOULDERC0, 1 / Animation_Speed)
                            RightHip.C0 = Clerp(RightHip.C0, CF(1 , -1 - 0.15 * COS(SINE / WALKSPEEDVALUE*2), -0.2+ 0.2 * COS(SINE / WALKSPEEDVALUE)) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(-15)), 2 / Animation_Speed)
                            LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1 - 0.15 * COS(SINE / WALKSPEEDVALUE*2), -0.2+ -0.2 * COS(SINE / WALKSPEEDVALUE)) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(15)), 2 / Animation_Speed)
            else
                            RootJoint.C0 = Clerp(RootJoint.C0,ROOTC0 * CF(0, 0, -0.1) * ANGLES(RAD(15), RAD(0), RAD(0)), 0.15 / Animation_Speed)
                            Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0, 0 + ((1) - 1)) * ANGLES(RAD(5 - 8 * SIN(SINE / (WALKSPEEDVALUE / 2))), RAD(0), RAD(0)), 0.15 / Animation_Speed)
                            RightShoulder.C0 = Clerp(RightShoulder.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(80 * COS(SINE / WALKSPEEDVALUE)), RAD(0), RAD(-30 * COS(SINE / WALKSPEEDVALUE))) * RIGHTSHOULDERC0, 1 / Animation_Speed)
                            LeftShoulder.C0 = Clerp(LeftShoulder.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(-80 * COS(SINE / WALKSPEEDVALUE)), RAD(0), RAD(-30 * COS(SINE / WALKSPEEDVALUE))) * LEFTSHOULDERC0, 1 / Animation_Speed)
                            RightHip.C0 = Clerp(RightHip.C0, CF(1 , -1 - 0.15 * COS(SINE / WALKSPEEDVALUE*2), -0.2+ 0.2 * COS(SINE / WALKSPEEDVALUE)) * ANGLES(RAD(0), RAD(90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(-15)), 2 / Animation_Speed)
                            LeftHip.C0 = Clerp(LeftHip.C0, CF(-1, -1 - 0.15 * COS(SINE / WALKSPEEDVALUE*2), -0.2+ -0.2 * COS(SINE / WALKSPEEDVALUE)) * ANGLES(RAD(0), RAD(-90), RAD(0)) * ANGLES(RAD(0), RAD(0), RAD(15)), 2 / Animation_Speed)
                        end
                    end
                end
                unanchor()
                Humanoid.MaxHealth = math.huge
                Humanoid.Health = math.huge
                if Rooted == false then
                    Disable_Jump = false
                    Humanoid.WalkSpeed = Speed
                elseif Rooted == true then
                    Disable_Jump = true
                    Humanoid.WalkSpeed = 0
                end
                local MATHS = {"0","1"}
                Humanoid.Name = MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]..MATHS[MRANDOM(1,#MATHS)]
                Humanoid.PlatformStand = false
            end



























        end)



        pcall(function()
            changecolor("noob")
            if hat then hat.Parent = Character end
        end)
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
        if updateConnection then updateConnection:Disconnect() updateConnection = nil end
        if legacyHeartbeatConnection then legacyHeartbeatConnection:Disconnect() legacyHeartbeatConnection = nil end
        if heartbeatEvent then pcall(function() heartbeatEvent:Destroy() end) heartbeatEvent = nil end
        if Character then
            local effects = Character:FindFirstChild("Effects")
            if effects then effects:Destroy() end
        end
        if song then
            pcall(function()
                song:Stop()
                song:Destroy()
            end)
            song = nil
        end
        if assetObject and assetObject.Parent then assetObject:Destroy() end
        assetObject, assetScript, Character = nil, nil, nil
    end

    return m
end)

return modules
