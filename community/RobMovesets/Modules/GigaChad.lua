local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local modules = {}
local function AddModule(factory)
    table.insert(modules, factory)
end

AddModule(function()
    local Object = game:GetObjects("rbxassetid://10611255475")[1]
    local scriptAsset = Object and Object:FindFirstChild("Gigachad")
    if Object and not Object.Parent then
        Object.Parent = workspace
    end
    local m = {}
    m.ModuleType = "MOVESET"
    m.Name = "GigaChad"
    m.InternalName = "GigaChad"
    m.Description = "Idk what to put here"
    m.Assets = {"Muscles.mp3"}

    local Character, Humanoid, Mouse
    local RootPart, Torso, Head, RightArm, LeftArm, RightLeg, LeftLeg
    local RootJoint, Neck, RightShoulder, LeftShoulder, RightHip, LeftHip
    local initialized = false
    local destroyed = false
    local heartbeatConn
    local animThread
    local uisBegin, uisEnd
    local object
    local artificialHB
    local musicSound
    scriptAsset = Object and Object:FindFirstChild("Gigachad")

    m.Config = function(parent)
    end

    local function getRealCharacter()
        local player = Players.LocalPlayer
        if not player then return nil end
        return player.Character
    end

    m.Init = function(figure)
        if initialized then return end
        destroyed = false

        local Player = Players.LocalPlayer
        if not Player then return end

        Character = figure
        Mouse = Player:GetMouse()
        if not Character then return end

        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        RootPart = Character:FindFirstChild("HumanoidRootPart")
        Torso = Character:FindFirstChild("Torso")
        Head = Character:FindFirstChild("Head")
        RightArm = Character:FindFirstChild("Right Arm")
        LeftArm = Character:FindFirstChild("Left Arm")
        RightLeg = Character:FindFirstChild("Right Leg")
        LeftLeg = Character:FindFirstChild("Left Leg")

        if not (Humanoid and RootPart and Torso and Head and RightArm and LeftArm and RightLeg and LeftLeg) then
return
        end

        RootJoint = RootPart:FindFirstChild("RootJoint")
        Neck = Torso:FindFirstChild("Neck")
        RightShoulder = Torso:FindFirstChild("Right Shoulder")
        LeftShoulder = Torso:FindFirstChild("Left Shoulder")
        RightHip = Torso:FindFirstChild("Right Hip")
        LeftHip = Torso:FindFirstChild("Left Hip")
        if not (RootJoint and Neck and RightShoulder and LeftShoulder and RightHip and LeftHip) then
return
        end
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
        Speed = 35
        ROOTC0 = CF(0, 0, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
        NECKC0 = CF(0, 1, 0) * ANGLES(RAD(-90), RAD(0), RAD(180))
        RIGHTSHOULDERC0 = CF(-0.5, 0, 0) * ANGLES(RAD(0), RAD(90), RAD(0))
        LEFTSHOULDERC0 = CF(0.5, 0, 0) * ANGLES(RAD(0), RAD(-90), RAD(0))
        ANIM = "Idle"
        ATTACK = false
        EQUIPPED = false
        HOLD = false
        COMBO = 1
        Rooted = false
        SINE = 0
        KEYHOLD = false
        CHANGE = 2 / Animation_Speed
        WALKINGANIM = false
        Effects = IT("Folder", Character)
        Effects.Name = "Effects"
        ANIMATOR = Humanoid:FindFirstChildOfClass("Animator")
        ANIMATE = Character:FindFirstChild("Animate")
        if ANIMATOR then pcall(function() ANIMATOR:Destroy() end) end
        UNANCHOR = true
        HITPLAYERSOUNDS = {"263032172", "263032182", "263032200", "263032221", "263032252", "263033191"}
        artificialHB = Instance.new("BindableEvent")
        artificialHB.Name = "ArtificialHB"
        frame = Frame_Speed
        tf = 0
        allowframeloss = false
        tossremainder = false
        lastframe = tick()
        heartbeatConn = RunService.Heartbeat:Connect(function(s)
            if destroyed then return end
            tf = tf + s
            if tf >= frame then
                if allowframeloss then
                    artificialHB:Fire()
                    lastframe = tick()
                else
                    for _ = 1, math.floor(tf / frame) do
                        artificialHB:Fire()
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

        function Swait(NUMBER)
            if NUMBER == 0 or NUMBER == nil then
                artificialHB.Event:Wait()
            else
                for _ = 1, NUMBER do
                    artificialHB.Event:Wait()
                end
            end
        end

function Raycast(POSITION, DIRECTION, RANGE, IGNOREDECENDANTS)
	return workspace:FindPartOnRay(Ray.new(POSITION, DIRECTION.unit * RANGE), IGNOREDECENDANTS)
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

function Clerp(a, b, t)
    return a:lerp(b,t)
end

function weld(parent, part0, part1, c0, c1)
	local w = IT("Weld")
	w.Part0 = part0
	w.Part1 = part1
	w.C0 = c0
	w.C1 = c1
	w.Parent = parent
	return w
end

local S = IT("Sound")
function CreateSound(ID, PARENT, VOLUME, PITCH, DOESLOOP)
	local NEWSOUND = nil
	coroutine.resume(coroutine.create(function()
		NEWSOUND = S:Clone()
		NEWSOUND.EmitterSize = 5*VOLUME
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

function WACKYEFFECT2(Table)
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
	local COLORLOOP = (Table.ColorLoop or false)
	local COLOR = (Table.Color or C3(1,1,1))
	local TIME = (Table.Time or 45)
	local SOUNDID = (Table.SoundID or nil)
	local SOUNDPITCH = (Table.SoundPitch or nil)
	local SOUNDVOLUME = (Table.SoundVolume or nil)
	local USEBOOMERANGMATH = (Table.UseBoomerangMath or false)
	local BOOMERANG = (Table.Boomerang or 0)
	local SIZEBOOMERANG = (Table.SizeBoomerang or 0)
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
		elseif TYPE == "Block" or TYPE == "Box" then
			MSH = IT("BlockMesh",EFFECT)
			MSH.Scale = SIZE
		elseif TYPE == "Wave" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "20329976", "", SIZE, VT(0,0,-SIZE.X/8))
		elseif TYPE == "Ring" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "559831844", "", VT(SIZE.X,SIZE.X,0.1), VT(0,0,0))
		elseif TYPE == "Slash" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "662586858", "", VT(SIZE.X/10,0,SIZE.X/10), VT(0,0,0))
		elseif TYPE == "Round Slash" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "662585058", "", VT(SIZE.X/10,0,SIZE.X/10), VT(0,0,0))
		elseif TYPE == "Swirl" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "168892432", "", SIZE, VT(0,0,0))
		elseif TYPE == "Skull" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "4770583", "", SIZE, VT(0,0,0))
		elseif TYPE == "Crystal" then
			MSH = CreateMesh("SpecialMesh", EFFECT, "FileMesh", "9756362", "", SIZE, VT(0,0,0))
		end
		if MSH ~= nil then
			local BOOMR1 = 1+BOOMERANG/50
			local BOOMR2 = 1+SIZEBOOMERANG/50
			local MOVESPEED = nil
			if MOVEDIRECTION ~= nil then
				if USEBOOMERANGMATH == true then
					MOVESPEED = ((CFRAME.p - MOVEDIRECTION).Magnitude/TIME)*BOOMR1
				else
					MOVESPEED = ((CFRAME.p - MOVEDIRECTION).Magnitude/TIME)
				end
			end
			local GROWTH = nil
			if USEBOOMERANGMATH == true then
				GROWTH = (SIZE - ENDSIZE)*(BOOMR2+1)
			else
				GROWTH = (SIZE - ENDSIZE)
			end
			local TRANS = TRANSPARENCY - ENDTRANSPARENCY
			if TYPE == "Block" then
				EFFECT.CFrame = CFRAME*ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)))
			else
				EFFECT.CFrame = CFRAME
			end
			if USEBOOMERANGMATH == true then
				for LOOP = 1, TIME+1 do
					Swait()
					if COLORLOOP == true then
					EFFECT.Color = COLOR
					end
					MSH.Scale = MSH.Scale - (VT((GROWTH.X)*((1 - (LOOP/TIME)*BOOMR2)),(GROWTH.Y)*((1 - (LOOP/TIME)*BOOMR2)),(GROWTH.Z)*((1 - (LOOP/TIME)*BOOMR2)))*BOOMR2)/TIME
					if TYPE == "Wave" then
						MSH.Offset = VT(0,0,-MSH.Scale.Z/8)
					end
					EFFECT.Transparency = EFFECT.Transparency - TRANS/TIME
					if TYPE == "Block" then
						EFFECT.CFrame = CFRAME*ANGLES(RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)),RAD(MRANDOM(0,360)))
					else
						EFFECT.CFrame = EFFECT.CFrame*ANGLES(RAD(ROTATION1),RAD(ROTATION2),RAD(ROTATION3))
					end
					if MOVEDIRECTION ~= nil then
						local ORI = EFFECT.Orientation
						EFFECT.CFrame = CF(EFFECT.Position,MOVEDIRECTION)*CF(0,0,-(MOVESPEED)*((1 - (LOOP/TIME)*BOOMR1)))
						EFFECT.Orientation = ORI
					end
				end
			else
				for LOOP = 1, TIME+1 do
					Swait()
					if COLORLOOP == true then
						EFFECT.Color = COLOR
					end
					MSH.Scale = MSH.Scale - GROWTH/TIME
					if TYPE == "Wave" then
						MSH.Offset = VT(0,0,-MSH.Scale.Z/8)
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
			end
			EFFECT.Transparency = 1
			if PLAYSSOUND == false then
				EFFECT:remove()
			else
				repeat Swait() until EFFECT:FindFirstChildOfClass("Sound") == nil
				EFFECT:remove()
			end
		else
			if PLAYSSOUND == false then
				EFFECT:remove()
			else
				repeat Swait() until EFFECT:FindFirstChildOfClass("Sound") == nil
				EFFECT:remove()
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

function CreateFlyingDebree(FLOOR,POSITION,AMOUNT,BLOCKSIZE,SWAIT,STRENGTH)
	if FLOOR ~= nil then
		for i = 1, AMOUNT do
			local DEBREE = CreatePart(3, Effects, "Neon", FLOOR.Reflectance, FLOOR.Transparency, "Peal", "Debree", BLOCKSIZE, false)
			DEBREE.Material = FLOOR.Material
			DEBREE.Color = FLOOR.Color
			DEBREE.CFrame = POSITION * ANGLES(RAD(MRANDOM(-360,360)),RAD(MRANDOM(-360,360)),RAD(MRANDOM(-360,360)))
			DEBREE.Velocity = VT(MRANDOM(-STRENGTH,STRENGTH),MRANDOM(-STRENGTH,STRENGTH),MRANDOM(-STRENGTH,STRENGTH))
			coroutine.resume(coroutine.create(function()
				Swait(15)
				DEBREE.Parent = workspace
				DEBREE.CanCollide = true
				Debris:AddItem(DEBREE,SWAIT)
			end))
		end
	end
end

function SHAKECAM(POSITION,RANGE,INTENSITY,TIME)
	local CHILDREN = workspace:GetDescendants()
	for index, CHILD in pairs(CHILDREN) do
		if CHILD.ClassName == "Model" then
			local HUM = CHILD:FindFirstChildOfClass("Humanoid")
			if HUM then
				local TORSO = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso")
				if TORSO then
					if (TORSO.Position - POSITION).Magnitude <= RANGE then
						local CAMSHAKER = scriptAsset.CamShake:Clone()
						CAMSHAKER.Shake.Value = INTENSITY
						CAMSHAKER.Timer.Value = TIME
						CAMSHAKER.Parent = CHILD
						CAMSHAKER.Disabled = false
					end
				end
			end
		end
	end
end

function AttachmentCFrame(What)
	return What.Parent.CFrame*CF(What.Position)
end
d = CF(0,0,0)
local la = IT("Weld")
local ra = IT("Weld")
RightShoulder.Parent = nil
LeftShoulder.Parent = nil
ra.Name = "ra"
ra.Part0 = Torso
ra.C0 = CF(1.5, 0.5, 0)
ra.C1 = CF(0, 0.5, 0)
ra.Part1 = RightArm
ra.Parent = Torso

la.Name = "la"
la.Part0 = Torso
la.C0 = CF(-1.5, 0.5, 0)
la.C1 = CF(0, 0.5, 0)
la.Part1 = LeftArm
la.Parent = Torso

local lh = weld(LeftLeg,Torso,LeftLeg,CF(-.5,-1,0),d)
lh.C1 = CF(0,1,0)
local rh = weld(RightLeg,Torso,RightLeg,CF(.5,-1,0),d)
rh.C1 = CF(0,1,0)

local holdin = false
function ManSlaughter()
end
function ApplyDamage(Humanoid)
    if Humanoid and Humanoid.Parent then
        FlingHitTarget(Humanoid.Parent)
    end
end

function ApplyAoE(POSITION,RANGE,MINDMG,MAXDMG,FLING,INSTAKILL)
	for _, CHILD in pairs(workspace:GetDescendants()) do
		if CHILD:IsA("Model") and CHILD ~= Character then
			local HUM = CHILD:FindFirstChildOfClass("Humanoid")
			local TORSO = CHILD:FindFirstChild("Torso") or CHILD:FindFirstChild("UpperTorso") or CHILD:FindFirstChild("HumanoidRootPart")
			if HUM and TORSO and HUM.Health > 0 and (TORSO.Position - POSITION).Magnitude <= RANGE then
				pcall(function()
					ReanimateFling(CHILD)
				end)
			end
		end
	end
end

local function FlingHitTarget(target)
    if not target then return false end
    local model = target
    if not model:IsA("Model") then
        model = model:FindFirstAncestorOfClass("Model")
    end
    if not model or model == Character then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
    if not hum or hum.Health <= 0 or not root then return false end
    local ok, result = pcall(function()
        return ReanimateFling(model)
    end)
    return ok and result ~= false
end

function punchcom()
	ATTACK = true
	if COMBO == 1 then
		if holdin == false then
		COMBO = 2
		end
		CreateSound(2295409459,LeftArm,6,MRANDOM(9,12)/10,false)
		for i = 0,5 do
			Swait()
				local Alpha = .3
  	RootJoint.C0 = RootJoint.C0:lerp(CF(0,0,0)*ANGLES(RAD(0),RAD(25.8),RAD(0))*ROOTC0,Alpha)
  	lh.C0 = lh.C0:lerp(CF(-0.5,-1,-0.1)*ANGLES(RAD(0.4),RAD(7),RAD(-3.3)),Alpha)
  	rh.C0 = rh.C0:lerp(CF(0.5,-1,-0.1)*ANGLES(RAD(0.5),RAD(-7.5),RAD(3.8)),Alpha)
  	la.C0 = la.C0:lerp(CF(-1.5,0.2,0.3)*ANGLES(RAD(105.3),RAD(0),RAD(0)),Alpha)
  	ra.C0 = ra.C0:lerp(CF(1.4,0.5,0.1)*ANGLES(RAD(3.5),RAD(-15.7),RAD(12.5)),Alpha)
  	Neck.C0 = Neck.C0:lerp(CF(0,0,0+ ((1) - 1))*CF(0,0,0)*ANGLES(RAD(0),RAD(-25.8),RAD(0))*NECKC0,Alpha)
		end
		for i = 0,8 do
			Swait()
			  	local Alpha = .4
  	RootJoint.C0 = RootJoint.C0:lerp(CF(0,0,0)*ANGLES(RAD(-10.2),RAD(-41.4),RAD(0))*ROOTC0,Alpha)
  	lh.C0 = lh.C0:lerp(CF(-0.5,-1,-0.1)*ANGLES(RAD(11.4),RAD(19.8),RAD(-3.4)),Alpha)
  	rh.C0 = rh.C0:lerp(CF(0.5,-1,-0.1)*ANGLES(RAD(10.7),RAD(-7.5),RAD(3.8)),Alpha)
  	la.C0 = la.C0:lerp(CF(-0.4,0.2,-1)*ANGLES(RAD(99.6),RAD(-28.4),RAD(78.2)),Alpha)
  	ra.C0 = ra.C0:lerp(CF(1.4,0.5,0.1)*ANGLES(RAD(3.5),RAD(-15.7),RAD(12.5)),Alpha)
  	Neck.C0 = Neck.C0:lerp(CF(0,0,0+ ((1) - 1))*CF(0,0,0)*ANGLES(RAD(0),RAD(41.4),RAD(0))*NECKC0,Alpha)
		end
		ApplyAoE(LeftArm.Position,5,80,99,150,false)
	elseif COMBO == 2 then
	COMBO = 1
	CreateSound(2295409459,RightArm,6,MRANDOM(9,12)/10,false)
	for i = 0,5 do
		Swait()
			local Alpha = .3
  	RootJoint.C0 = RootJoint.C0:lerp(CF(0,0,0)*ANGLES(RAD(0),RAD(-30.1),RAD(0))*ROOTC0,Alpha)
  	lh.C0 = lh.C0:lerp(CF(-0.5,-1,-0.1)*ANGLES(RAD(0.4),RAD(7),RAD(-3.3)),Alpha)
  	rh.C0 = rh.C0:lerp(CF(0.5,-1,-0.1)*ANGLES(RAD(0.5),RAD(-7.5),RAD(3.8)),Alpha)
  	la.C0 = la.C0:lerp(CF(-1.3,0.5,0.3)*ANGLES(RAD(3.4),RAD(20.1),RAD(-9.9)),Alpha)
  	ra.C0 = ra.C0:lerp(CF(1.5,0.5,-0.2)*ANGLES(RAD(109.2),RAD(0),RAD(0)),Alpha)
  	Neck.C0 = Neck.C0:lerp(CF(0,0,0+ ((1) - 1))*CF(0,0,0)*ANGLES(RAD(0),RAD(30.1),RAD(0))*NECKC0,Alpha)
	end
	for i = 0,8 do
		Swait()
		  	local Alpha = .4
  	RootJoint.C0 = RootJoint.C0:lerp(CF(0,0,0)*ANGLES(RAD(-10.2),RAD(45.1),RAD(0))*ROOTC0,Alpha)
  	lh.C0 = lh.C0:lerp(CF(-0.3,-1,-0.2)*ANGLES(RAD(6.7),RAD(7.4),RAD(4)),Alpha)
  	rh.C0 = rh.C0:lerp(CF(0.7,-0.9,-0.2)*ANGLES(RAD(11.4),RAD(-20.3),RAD(11.7)),Alpha)
  	la.C0 = la.C0:lerp(CF(-1.3,0.5,0.3)*ANGLES(RAD(3.4),RAD(20.1),RAD(-9.9)),Alpha)
  	ra.C0 = ra.C0:lerp(CF(0.4,0.3,-0.9)*ANGLES(RAD(105.4),RAD(38),RAD(-83.9)),Alpha)
  	Neck.C0 = Neck.C0:lerp(CF(0,0,0+ ((1) - 1))*CF(0,0,0)*ANGLES(RAD(0),RAD(-45.1),RAD(0))*NECKC0,Alpha)
	end
	ApplyAoE(LeftArm.Position,5,80,99,150,false)
	end
	ATTACK = false
end

local blc
function groundchunk()
	ATTACK = true
	for i = 0,15 do
		Swait()
		  	local Alpha = .1
  	RootJoint.C0 = RootJoint.C0:lerp(CF(0.1,0,0)*ANGLES(RAD(0),RAD(38.9),RAD(0))*ROOTC0,Alpha)
  	lh.C0 = lh.C0:lerp(CF(-0.5,-1,-0.1)*ANGLES(RAD(0.4),RAD(7),RAD(-3.3)),Alpha)
  	rh.C0 = rh.C0:lerp(CF(0.5,-1,-0.1)*ANGLES(RAD(0.5),RAD(-7.5),RAD(3.8)),Alpha)
  	la.C0 = la.C0:lerp(CF(-1.5,0.5,0)*ANGLES(RAD(0),RAD(0),RAD(0)),Alpha)
  	ra.C0 = ra.C0:lerp(CF(1.5,0.9,-0.1)*ANGLES(RAD(163.7),RAD(19.7),RAD(0)),Alpha)
  	Neck.C0 = Neck.C0:lerp(CF(0,0,0+ ((1) - 1))*CF(-0.1,0,-0.1)*ANGLES(RAD(0),RAD(-38.9),RAD(0))*NECKC0,Alpha)
	end
	local hf,hp = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4, Character)
	if hf then
	local bloc = CreatePart(3,Effects,"Neon",0,0,"White","CHUNK",VT(3,3,3),false)
	CreateSound(199145477,RightArm,5,1,false)
	bloc.Massless = true
	bloc.CanCollide = false
	bloc.Color = hf.Color
	bloc.Material = hf.Material
	blc = bloc
	local bw = weld(bloc,bloc,RightArm,CF(0,2.5,0)*ANGLES(0,0,RAD(10)),d)
	WACKYEFFECT2({Time = 45, EffectType = "Sphere", Size = VT(1,.1,1), Size2 = VT(16,.1,16), Transparency = 0, Transparency2 = 1, CFrame = RootPart.CFrame*CF(1.7,-2.9,-1.3), MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = hf.Material, Color = hf.Color,SoundID = nil, SoundPitch = nil, SoundVolume = nil, UseBoomerangMath = false, Boomerang = 0, SizeBoomerang = 0})
	holdin = true
	for i = 0,25 do
		Swait()
		  	local Alpha = .25
  	RootJoint.C0 = RootJoint.C0:lerp(CF(0.1,-0.7,-0.5)*ANGLES(RAD(-25.8),RAD(38.9),RAD(0))*ROOTC0,Alpha)
  	lh.C0 = lh.C0:lerp(CF(-0.5,-0.8,-1)*ANGLES(RAD(-35),RAD(-4.8),RAD(15.2)),Alpha)
  	rh.C0 = rh.C0:lerp(CF(0.3,0,-0.5)*ANGLES(RAD(22.4),RAD(-4.3),RAD(19.7)),Alpha)
  	la.C0 = la.C0:lerp(CF(-1.4,0.5,0.2)*ANGLES(RAD(3.2),RAD(17.2),RAD(-10.7)),Alpha)
  	ra.C0 = ra.C0:lerp(CF(1.7,0.1,-0.5)*ANGLES(RAD(37.8),RAD(-10.2),RAD(24.7)),Alpha)
  	Neck.C0 = Neck.C0:lerp(CF(0,0,0+ ((1) - 1))*CF(-0.1,0,-0.1)*ANGLES(RAD(0),RAD(-38.9),RAD(0))*NECKC0,Alpha)
	end
	end
	ATTACK = false
end

function throwbloc()
	if holdin == true then
		ATTACK = true
		for i = 0,13 do
			Swait()
			  	local Alpha = .1
  	RootJoint.C0 = RootJoint.C0:lerp(CF(0,0,0.3)*ANGLES(RAD(15.1),RAD(0),RAD(0))*ROOTC0,Alpha)
  	lh.C0 = lh.C0:lerp(CF(-0.5,-1.1,-0.1)*ANGLES(RAD(-14.7),RAD(7),RAD(-3.3)),Alpha)
  	rh.C0 = rh.C0:lerp(CF(0.5,-1.1,-0.1)*ANGLES(RAD(-14.6),RAD(-7.5),RAD(3.8)),Alpha)
  	la.C0 = la.C0:lerp(CF(-1.3,0.4,-0.1)*ANGLES(RAD(0),RAD(0),RAD(15)),Alpha)
  	ra.C0 = ra.C0:lerp(CF(1.4,0.7,0.2)*ANGLES(RAD(-159.3),RAD(5.4),RAD(14)),Alpha)
  	Neck.C0 = Neck.C0:lerp(CF(0,0,0+ ((1) - 1))*CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))*NECKC0,Alpha)
		end
		local bloc = blc
		bloc.Weld:Destroy()
		coroutine.resume(coroutine.create(function()
		bloc.CFrame = CF(bloc.Position,Mouse.Hit.p)
		bloc.Anchored = true
		RootPart.Anchored = true
		for i = 1,250 do
			Swait()
			bloc.CFrame = bloc.CFrame*CF(0,0,-4)
			local hit,pos = Raycast(bloc.Position,bloc.CFrame.lookVector,5,Character)
			if hit then break end
		end
		for  i = 1,8 do
			local r = MRANDOM(1,2)
		local db = CreatePart(3,Effects,bloc.Material,0,0,"White","debree",VT(r,r,r),false)
		db.CanCollide = true
		db.Color = bloc.Color
		db.CFrame = bloc.CFrame
		local bv = IT("BodyVelocity",db)
		bv.Velocity = CF(bloc.Position,bloc.CFrame*CF(MRANDOM(-1,1),2,MRANDOM(-1,1)).p).lookVector*50
		Debris:AddItem(bv,.1)
		Debris:AddItem(db,2)
		end
		ApplyAoE(bloc.Position,10,0,0,100,true)
		WACKYEFFECT2({Time = 110, EffectType = "Box", Size = bloc.Size, Size2 = bloc.Size*4.5, Transparency = 0, Transparency2 = 1, CFrame = bloc.CFrame, MoveToPos = nil, RotationX = 0, RotationY = 0, RotationZ = 0, Material = bloc.Material, Color = bloc.Color,SoundID = 157878578, SoundPitch = 1, SoundVolume = 4, UseBoomerangMath = false, Boomerang = 0, SizeBoomerang = 0})
		bloc:Destroy()
		end))
		holdin = false
		for i = 0,20 do
			Swait()
			  	local Alpha = .4
  	RootJoint.C0 = RootJoint.C0:lerp(CF(0,0.1,-0.5)*ANGLES(RAD(-31.5),RAD(0),RAD(0))*ROOTC0,Alpha)
  	lh.C0 = lh.C0:lerp(CF(-0.5,-1.2,-0.2)*ANGLES(RAD(31.9),RAD(7),RAD(-3.3)),Alpha)
  	rh.C0 = rh.C0:lerp(CF(0.5,-1.5,-0.4)*ANGLES(RAD(-89.2),RAD(0.7),RAD(-8.4)),Alpha)
  	la.C0 = la.C0:lerp(CF(-1.3,0.4,-0.1)*ANGLES(RAD(0),RAD(0),RAD(15)),Alpha)
  	ra.C0 = ra.C0:lerp(CF(0.6,0.4,-1.1)*ANGLES(RAD(19.6),RAD(-5.8),RAD(-42.2)),Alpha)
  	Neck.C0 = Neck.C0:lerp(CF(0,0,0+ ((1) - 1))*CF(0,0.1,-0.6)*ANGLES(RAD(22.1),RAD(0),RAD(0))*NECKC0,Alpha)
		end
		RootPart.Anchored = false
		ATTACK = false
	end
end
        animThread = task.spawn(function()
function unanchor()
	for _, c in pairs(Character:GetChildren()) do
		if c:IsA("BasePart") and c ~= RootPart then
			c.Anchored = false
		end
	end
	if UNANCHOR == true then
		RootPart.Anchored = false
	else
		RootPart.Anchored = true
	end
end

Humanoid.Changed:connect(function(Jump)
	if Jump == "Jump" and (Disable_Jump == true) then
		Humanoid.Jump = false
	end
end)

while true do
	Swait()
	if ANIMATE then ANIMATE.Parent = nil end
	for _,v in next, Humanoid:GetPlayingAnimationTracks() do
	    v:Stop();
	end
	SINE = SINE + CHANGE*2
	local TORSOVELOCITY = (RootPart.Velocity * VT(1, 0, 1)).magnitude
	local TORSOVERTICALVELOCITY = RootPart.Velocity.y
	local HITFLOOR,HITPOS,NORMAL = Raycast(RootPart.Position, (CF(RootPart.Position, RootPart.Position + VT(0, -1, 0))).lookVector, 4+Humanoid.HipHeight, Character)
	local TiltVelocity = CF(RootPart.CFrame:vectorToObjectSpace(RootPart.Velocity/1.6))
	local WALKSPEEDVALUE = 16 / (Humanoid.WalkSpeed / 16)
	if TORSOVERTICALVELOCITY > 1 and HITFLOOR == nil then
		ANIM = "Jump"
		if ATTACK == false then
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, 0 ) * ANGLES(RAD(-5), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0 , 0 + ((1) - 1)) * ANGLES(RAD(-25), RAD(0), RAD(0)), 1 / Animation_Speed)
			ra.C0 = Clerp(ra.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(-35), RAD(0), RAD(25 + 10 * COS(SINE / 12))), 1 / Animation_Speed)
			la.C0 = Clerp(la.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(-35), RAD(0), RAD(-25 - 10 * COS(SINE / 12))), 1 / Animation_Speed)
			rh.C0 = Clerp(rh.C0, CF(.5, -0.4, -0.6) * ANGLES(RAD(1), RAD(0), RAD(0)) * ANGLES(RAD(-1 * SIN(SINE / 6)), RAD(0), RAD(0)), 1 / Animation_Speed)
			lh.C0 = Clerp(lh.C0, CF(-.5, -1, 0) * ANGLES(RAD(0), RAD(5), RAD(0)) * ANGLES(RAD(-1 * SIN(SINE / 6)), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
	elseif TORSOVERTICALVELOCITY < -1 and HITFLOOR == nil then
		ANIM = "Fall"
		if ATTACK == false then
			RootJoint.C0 = Clerp(RootJoint.C0, ROOTC0 * CF(0, 0, 0 ) * ANGLES(RAD(15), RAD(0), RAD(0)), 1 / Animation_Speed)
			Neck.C0 = Clerp(Neck.C0, NECKC0 * CF(0, 0 , 0 + ((1) - 1)) * ANGLES(RAD(15), RAD(0), RAD(0)), 1 / Animation_Speed)
			ra.C0 = Clerp(ra.C0, CF(1.5, 0.5, 0) * ANGLES(RAD(35 - 4 * COS(SINE / 6)), RAD(0), RAD(45 + 10 * COS(SINE / 12))), 1 / Animation_Speed)
			la.C0 = Clerp(la.C0, CF(-1.5, 0.5, 0) * ANGLES(RAD(35 - 4 * COS(SINE / 6)), RAD(0), RAD(-45 - 10 * COS(SINE / 12))), 1 / Animation_Speed)
			rh.C0 = Clerp(rh.C0, CF(.5, -0.3, -0.7) * ANGLES(RAD(-25 + 5 * SIN(SINE / 12)), RAD(0), RAD(0)) * ANGLES(RAD(-1 * SIN(SINE / 6)), RAD(0), RAD(0)), 1 / Animation_Speed)
			lh.C0 = Clerp(lh.C0, CF(-.5, -0.8, -0.3) * ANGLES(RAD(-10), RAD(10), RAD(0)) * ANGLES(RAD(-1 * SIN(SINE / 6)), RAD(0), RAD(0)), 1 / Animation_Speed)
		end
	elseif TORSOVELOCITY < 1 and HITFLOOR ~= nil then
		local Alpha = .1
		ANIM = "Idle"
		if ATTACK == false then
  		RootJoint.C0 = RootJoint.C0:lerp(CF(0,0+0.07*COS(SINE/25),0)*ANGLES(RAD(0+4*SIN(SINE/25)),RAD(0),RAD(0))*ROOTC0,Alpha)
  		lh.C0 = lh.C0:lerp(CF(-0.5,-1-0.07*COS(SINE/25),-0.1)*ANGLES(RAD(0.4-4*SIN(SINE/25)),RAD(7),RAD(-3.3)),Alpha)
  		rh.C0 = rh.C0:lerp(CF(0.5,-1-0.07*COS(SINE/25),-0.1)*ANGLES(RAD(0.5-4*SIN(SINE/25)),RAD(-7.5),RAD(3.8)),Alpha)
  		la.C0 = la.C0:lerp(CF(-1.3,0.4+0.09*COS(SINE/25),-0.1)*ANGLES(RAD(0),RAD(0),RAD(15+1*COS(SINE/25))),Alpha)
  		if holdin == true then ra.C0 = ra.C0:lerp(CF(1.4,0.4+0.09*COS(SINE/25),-0.1)*ANGLES(RAD(180),RAD(0),RAD(25-1*COS(SINE/25))),Alpha) else ra.C0 = ra.C0:lerp(CF(1.4,0.4+0.09*COS(SINE/25),-0.1)*ANGLES(RAD(0),RAD(0),RAD(-15-1*COS(SINE/25))),Alpha) end
  		Neck.C0 = Neck.C0:lerp(NECKC0*CF(0,0,0+ ((1) - 1))*ANGLES(RAD(0-3*COS(SINE/25)),RAD(0),RAD(0)),Alpha)
		end
	elseif TORSOVELOCITY > 1 and HITFLOOR ~= nil then
		ANIM = "Walk"
		if ATTACK == false then
		local Alpha = .1
  		RootJoint.C0 = RootJoint.C0:lerp(CF(0,0+0.12*SIN(SINE/WALKSPEEDVALUE*2),0-.10*COS(SINE/(WALKSPEEDVALUE/2)))*ANGLES(RAD(-2+3*SIN(SINE/(WALKSPEEDVALUE/2)))+RAD(TiltVelocity.Z)*1,RAD(10*COS(SINE/WALKSPEEDVALUE)),RAD(0))*ROOTC0,Alpha)
  		lh.C0 = lh.C0:lerp(CF(-0.5,-.9+0.75*COS(SINE/WALKSPEEDVALUE)/2,-.1-.5*COS(SINE/WALKSPEEDVALUE)/2)*ANGLES(RAD(-5+15*COS(SINE/WALKSPEEDVALUE))+RootPart.RotVelocity.Y/-75+SIN(SINE/WALKSPEEDVALUE)/2.5*-RAD(TiltVelocity.Z)*10,RAD(0-5*COS(SINE/WALKSPEEDVALUE)),RAD(0))*ANGLES(RAD(0-2*COS(SINE/WALKSPEEDVALUE)),RAD(0),RAD(0+25*SIN(SINE/WALKSPEEDVALUE)*RAD(TiltVelocity.X)*5.5)),Alpha)
  		rh.C0 = rh.C0:lerp(CF(0.5,-.9-0.75*COS(SINE/WALKSPEEDVALUE)/2,-.1+.5*COS(SINE/WALKSPEEDVALUE)/2)*ANGLES(RAD(-5-15*COS(SINE/WALKSPEEDVALUE))-RootPart.RotVelocity.Y/75+-SIN(SINE/WALKSPEEDVALUE)/2.5*-RAD(TiltVelocity.Z)*10,RAD(0-5*COS(SINE/WALKSPEEDVALUE)),RAD(0))*ANGLES(RAD(0+2*COS(SINE/WALKSPEEDVALUE)),RAD(0),RAD(0+25*SIN(SINE/WALKSPEEDVALUE)*-RAD(TiltVelocity.X)*5.5)),Alpha)
  		la.C0 = la.C0:lerp(CF(-1.5,0.5,0)*ANGLES(RAD(-50*COS(SINE/WALKSPEEDVALUE)),RAD(0),RAD(0)),Alpha)
  		if holdin == true then ra.C0 = ra.C0:lerp(CF(1.5,0.5,0)*ANGLES(RAD(180+3*COS(SINE/WALKSPEEDVALUE)),RAD(0),RAD(25)),Alpha) else ra.C0 = ra.C0:lerp(CF(1.5,0.5,0)*ANGLES(RAD(50*COS(SINE/WALKSPEEDVALUE)),RAD(0),RAD(0)),Alpha) end
  		Neck.C0 = Neck.C0:lerp(NECKC0*CF(0,0,0)*ANGLES(RAD(0+3.5*COS(SINE/WALKSPEEDVALUE)),RAD(0),RAD(-10*COS(SINE/WALKSPEEDVALUE))-RAD(TiltVelocity.X)*3),Alpha)
		end
	end
	unanchor()
	Humanoid.MaxHealth = 1e4
	if Rooted == false then
		Disable_Jump = false
		Humanoid.WalkSpeed = Speed
	elseif Rooted == true then
		Disable_Jump = true
		Humanoid.WalkSpeed = 0
	end
end
        end)

        local mousedown = false
        local currentClick
        ContextActions:BindAction("GigaChad_M1", function(_, state, input)
            if state == Enum.UserInputState.Begin then
                currentClick = input
                mousedown = true
                if not ATTACK then
                    task.spawn(function()
                        local ok = pcall(punchcom)
                        if not ok then
                            ATTACK = false
                        end
                    end)
                end
            elseif state == Enum.UserInputState.End then
                if input == currentClick then
                    mousedown = false
                    currentClick = nil
                end
            end
        end, true, Enum.UserInputType.MouseButton1)
        ContextActions:SetTitle("GigaChad_M1", "M1")
        ContextActions:SetPosition("GigaChad_M1", UDim2.new(1, -130, 1, -130))
        ContextActions:BindAction("GigaChad_Rock", function(_, state)
            if state ~= Enum.UserInputState.Begin then return end
            if ATTACK then return end
            if holdin == false then
                task.spawn(function()
                    local ok = pcall(groundchunk)
                    if not ok then
                        ATTACK = false
                    end
                end)
            else
                task.spawn(function()
                    local ok = pcall(throwbloc)
                    if not ok then
                        ATTACK = false
                    end
                end)
            end
        end, true, Enum.KeyCode.Z)
        ContextActions:SetTitle("GigaChad_Rock", "Rock")
        ContextActions:SetPosition("GigaChad_Rock", UDim2.new(1, -260, 1, -130))
        musicSound = Instance.new("Sound")
        musicSound.SoundId = getcustomasset("UhhhhhhReanim/Content/Sounds/" .. m.Assets[1])
        musicSound.Volume = 1
        musicSound.Looped = true
        musicSound.Parent = workspace
        musicSound:Play()

        initialized = true
    end

    m.Update = function(dt, figure)
        if destroyed or not initialized then return end
        if figure ~= Character then
            Character = figure
        end
    end

    m.Destroy = function()
        destroyed = true
        initialized = false

        pcall(function() ContextActions:UnbindAction("GigaChad_M1") end)
        pcall(function() ContextActions:UnbindAction("GigaChad_Rock") end)

        if heartbeatConn then heartbeatConn:Disconnect(); heartbeatConn = nil end
        if artificialHB then artificialHB:Destroy(); artificialHB = nil end
        if musicSound then musicSound:Destroy(); musicSound = nil end
        if animThread then task.cancel(animThread); animThread = nil end
        if Effects and Effects.Parent then Effects:Destroy() end
        if object and object.Parent then object:Destroy() end
        object = nil
        scriptAsset = nil
    end

    return m
end)

return modules
