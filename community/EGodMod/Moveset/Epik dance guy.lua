local modules = {}

table.insert(modules, function()

local m = {}  
m.ModuleType = "MOVESET"  
m.Name = "Epik dance Modded"  
m.Description = "Apart of the Epik dance Modded module pack By n1ght"  
m.InternalName = "EpikDanceszz"  

m.Assets = {"idle.anim", "walk.anim", "Sprint.anim", "Jump.anim", "Fall.anim", "Friday theme.mp3"}  

m.Config = function(parent: GuiBase2d)  
end  

local animator = nil  

local tracks = {}  
local currentTrack = nil  

local animationtime = 0  
local laststate = "none"  
local sprinting = false
local coon1 = nil
local coon2 = nil

local jumpcount = 0
local maxjumps = 2

m.Init = function(figure: Model)  
	local hum = figure:FindFirstChild("Humanoid")  
	if not hum then return end  
	local UIS = game:GetService("UserInputService")

	animator = AnimLib.Animator.new()  
	animator.rig = figure  
	animator.looped = true  

	tracks.idle = AnimLib.Track.fromfile(AssetGetPathFromFilename("idle.anim"))  
	tracks.walk = AnimLib.Track.fromfile(AssetGetPathFromFilename("walk.anim"))  
	tracks.sprint = AnimLib.Track.fromfile(AssetGetPathFromFilename("Sprint.anim"))  
	tracks.jump1 = AnimLib.Track.fromfile(AssetGetPathFromFilename("Jump.anim"))  
	tracks.jump2 = AnimLib.Track.fromfile(AssetGetPathFromFilename("Fall.anim"))  

	tracks.jump1.looped = false  
	tracks.jump2.looped = false  

	animationtime = 0  
	laststate = "none"  
	sprinting = false  
	jumpcount = 0  

	local UsedDouble = false
    local CanDouble = false

    coon1 = hum.StateChanged:Connect(function(_, new)
	if new == Enum.HumanoidStateType.Jumping then
		if jumpcount == 0 then
			jumpcount = 1
			CanDouble = true
		end
	elseif new == Enum.HumanoidStateType.Landed then
		jumpcount = 0
		CanDouble = false
	end
    end)

    coon2 = UIS.JumpRequest:Connect(function()
	if CanDouble and jumpcount == 1 then
		CanDouble = false
		jumpcount = 2
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
    end)
	
	ContextActions:BindAction("EpikSprint", function(_, state)  
		if state == Enum.UserInputState.Begin then  
			sprinting = not sprinting  
		end  
	end, true, Enum.KeyCode.LeftShift)  

	ContextActions:SetTitle("EpikSprint", "Run")  
	ContextActions:SetPosition("EpikSprint", UDim2.new(1, -130, 1, -130))  

	SetOverrideMovesetMusic(AssetGetContentId("Friday theme.mp3"), "Epik Danceszz", 1)
	
end

m.Update = function(dt: number, figure: Model)  
	local hum = figure:FindFirstChild("Humanoid")  
	if not hum then return end  

	local humState = hum:GetState()
	local state = "idle"

	if humState == Enum.HumanoidStateType.Jumping or humState == Enum.HumanoidStateType.Freefall then
		if jumpcount == 1 then
			state = "jump1"
		elseif jumpcount == 2 then
			state = "jump2"
		end
	elseif hum.MoveDirection.Magnitude > 0.1 then
		if sprinting then
			state = "sprint"
		else
			state = "walk"
		end
	end

	if laststate ~= state then  
		animationtime = 0  
		laststate = state  
	else  
		animationtime += dt  
	end  

	local newTrack  

	if state == "idle" then  
		newTrack = tracks.idle  
	elseif state == "walk" then  
		newTrack = tracks.walk  
	elseif state == "sprint" then  
		newTrack = tracks.sprint  
	elseif state == "jump1" then  
		newTrack = tracks.jump1
	elseif state == "jump2" then  
		newTrack = tracks.jump2
	end  

	if currentTrack ~= newTrack then  
		currentTrack = newTrack  
		animator.track = currentTrack  
	end  

	local velocity = hum.RootPart.AssemblyLinearVelocity.Magnitude  
	local speedFactor = velocity / hum.WalkSpeed  

	if speedFactor < 0.1 then  
		speedFactor = 0.1  
	end  

	if state == "walk" or state == "sprint" then  
		animator.speed = speedFactor  
	else  
		animator.speed = 1  
	end  

	animator:Step(animationtime)  

	if sprinting then  
		hum.WalkSpeed = 30  
	else  
		hum.WalkSpeed = 16  
	end  
end  

m.Destroy = function(figure: Model?)  
	animator = nil  
	tracks = {}  
	currentTrack = nil
	coon1:Disconnect()
	coon2:Disconnect()
	coon1 = nil
	coon2 = nil
	jumpcount = 0
	ContextActions:UnbindAction("EpikSprint")  
end  

return m

end)

return modules