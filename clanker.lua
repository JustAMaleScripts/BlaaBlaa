--[[

L I N K E D   S W O R D   A I   2
Features:
 - Fast A* Pathfinding (with a binary heap!)
 - More random attack patterns
 - SmartER auto repathfind
 - NEW Dynamic node pathfind
 - Checks to reduce suicides
 - Wandering
 - Some climb stuff
 - Force MoveDirection patch
 - Uses nearest healpad position
 - Determines which playstyle to use more based on deaths, with random chances to use random

]]
--[[ 

A W E S 9 5 5   C O O L   N O T E S   2
tweaked minimal functions and added JUMP_DIST back. yes its very necessary for some reason
i changed the predict player hit. apparently "more responsive ~= more range" thing
i enabled the debug for pathfind node searching cuz its cool
and other things

S T E V E ' S   R E A D M E
that not equals sign broke my editor awes
also, jumping and then swinging isnt a good technique, float will be ur opp
        literally hoster's fr sf bot's problem at testing ^^^^^

]]
local CONFIG = {
	-- studs to detect players
	DETECTION_RADIUS = 200,
	-- should heal when below health
	ALLOW_HEALING = true,
	-- health to heal
	HEALING_BELOW_HEALTH = 50,
	-- when the target is below this radius, immediately charge
	IMMEDIATE_ATTACK_RADIUS = 14,
	-- sword's internal name
	SWORD_NAME = "Sword",
	-- healing pad positions
	HEALING_PAD_POSITIONS = {
		Vector3.new(-124, 256, 4),
		Vector3.new(136, 247, 2),
	},
	-- distance for sword to swing
	DIST_SWING = 10,
	-- when charging, dont jump when below this distance
	CHARGE_NO_JUMP_DIST = 6,
	-- pull out sword when below this distance
	START_COMBAT = 40,
	-- distance from origin (0, 0, 0) to consider yourself flinged
	FLING_RESET_DISTANCE = 1000,
	-- nodes to walk per frame
	NODEWALK_SPEED = 50,
	-- agents to tick per frame
	PATHFIND_SPEED = 200,
	-- player hit prediction via velocity
	PREDICT_PLAYER_HIT = 0.175,
	PREDICT_PLAYER_DIST = 12,
	-- use predefs when theres no path found (usually cheating)
	USE_PREDEFS_ON_NOPATH = false, -- busted rn
	-- force humanoid to move in desired velocity
	PATCH_HUMANOID_MOVE_QUIRKS = true,
	-- difficulty set for bot, more difficulty = speed and reach hacks
	CURRENT_DIFFICULTY = "EASY", -- stub
	-- debug flags
	DEBUG = true,
	DEBUG_NODEWALKER = true,
	DEBUG_PATHFIND_OPEN = true,
}

local CARDINALS = {
	Vector3.xAxis, Vector3.zAxis, -Vector3.xAxis, -Vector3.zAxis,
	Vector3.new(1, 0, 1), Vector3.new(-1, 0, 1), Vector3.new(-1, 0, -1), Vector3.new(1, 0, -1),
}
local VEC3XZ = Vector3.new(1, 0, 1)
local HUM_STATES_SHIFTLOCK = {"Running", "Jumping", "Freefall", "Landed", "Climbing"}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

if not game:IsLoaded() then game.Loaded:Wait() end

local Player = Players.LocalPlayer

local function GetTool(char, back, name)
	if char and back then
		for _,v in char:GetChildren() do
			if v:IsA("Tool") and v.Name == name then
				return v
			end
		end
		for _,v in back:GetChildren() do
			if v:IsA("Tool") and v.Name == name then
				return v
			end
		end
	end
end

local DebugPart = Instance.new("Part")
DebugPart.Anchored = true
DebugPart.CanCollide = false
DebugPart.CanQuery = false
DebugPart.CanTouch = false
DebugPart.Transparency = 1
DebugPart.Size = Vector3.one
DebugPart.Name = "wirefrmane debufging"
DebugPart.Parent = workspace.Terrain
DebugPart.CFrame = CFrame.identity
local DebugWireframe = Instance.new("WireframeHandleAdornment")
DebugWireframe.Color3 = Color3.new(1, 1, 1)
DebugWireframe.Adornee = DebugPart
DebugWireframe.AlwaysOnTop = true
DebugWireframe.Parent = DebugPart
local DebugNodewalker = Instance.new("WireframeHandleAdornment")
DebugNodewalker.Color3 = Color3.new(1, 0, 1)
DebugNodewalker.Adornee = DebugPart
DebugNodewalker.AlwaysOnTop = true
DebugNodewalker.Parent = DebugPart
local DebugPathfinder = Instance.new("WireframeHandleAdornment")
DebugPathfinder.Color3 = Color3.new(0.7, 0.7, 0)
DebugPathfinder.Adornee = DebugPart
DebugPathfinder.AlwaysOnTop = true
DebugPathfinder.Parent = DebugPart
local DebugController = Instance.new("WireframeHandleAdornment")
DebugController.Color3 = Color3.new(0, 1, 0)
DebugController.Adornee = DebugPart
DebugController.AlwaysOnTop = true
DebugController.Parent = DebugPart
local DebugBrain = Instance.new("WireframeHandleAdornment")
DebugBrain.Color3 = Color3.new(0, 0.5, 1)
DebugBrain.Adornee = DebugPart
DebugBrain.AlwaysOnTop = true
DebugBrain.Parent = DebugPart

local function DebugClear(wf)
	if not CONFIG.DEBUG then return end
	wf:Clear()
end
local function CreateDot(wf, pos)
	if not CONFIG.DEBUG then return end
	local p, seg, r = {}, 8, 0.4 + math.sin(os.clock() * 2 + (pos.X + pos.Y + pos.Z) * 0.2) * 0.2
	for i = 1, seg do
		local a = (i / seg) * math.pi * 2
		p[#p + 1] = pos + Vector3.new(math.cos(a)*r, 0, math.sin(a)*r)
	end
	wf:AddPath(p, true)
end
local function CreateCircle(wf, pos, r)
	if not CONFIG.DEBUG then return end
	local p, seg = {}, math.min(6 + (r // 4), 32)
	for i = 1, seg do
		local a = (i / seg) * math.pi * 2
		p[#p + 1] = pos + Vector3.new(math.cos(a)*r, 0, math.sin(a)*r)
	end
	wf:AddPath(p, true)
end
local function CreateLocator(wf, pos)
	if not CONFIG.DEBUG then return end
	local seg, h = 8, 0.25 + math.sin(os.clock() * 2) * 0.25
	pos += Vector3.yAxis * h
	for i = 1, seg do
		local a = (i / seg) * math.pi * 2
		local b = ((i + 1) / seg) * math.pi * 2
		wf:AddLine(pos + Vector3.new(math.cos(a) * 0.5, 1, math.sin(a) * 0.5), pos + Vector3.new(math.cos(b) * 0.5, 1, math.sin(b) * 0.5))
		wf:AddLine(pos + Vector3.new(math.cos(a) * 0.5, 1, math.sin(a) * 0.5), pos)
	end
end
local function CreateLine(wf, a, b)
	if not CONFIG.DEBUG then return end
	wf:AddLine(a, b)
end
local function CreateText(wf, pos, txt)
	if not CONFIG.DEBUG then return end
	wf:AddText(pos, txt, 10)
end

local DebugLines = {
	"CLANKER V2.0, LINKED SWORD AI LOADING...",
	"PATHFINDER ... WAITING FOR CALLS",
	"CONTROLLER - SWORD ... LOADING",
	"             MOVE METHOD ... LOADING",
	"             JUMP ... LOADING",
	"BRAIN - STATE ... LOADING",
	"        PLAYSTYLE ... LOADING",
	"        CHARGING ... LOADING",
	"NO PREDEF ACTS RAN YET...",
}
RunService.PreRender:Connect(function()
	if not workspace.CurrentCamera then return end
	DebugWireframe:Clear()
	DebugWireframe:AddText(workspace.CurrentCamera.Focus.Position, table.concat(DebugLines, "\n"), 10)
end)
task.wait(0.5)

local Characters = {}
local CharactersFF = {}
do
	local AntiflingHumanoids = {}
	local AntiflingBaseParts = {}
	RunService.PreAnimation:Connect(function()
		for i,v in Characters do
			if v:FindFirstChildOfClass("ForceField") then
				if not table.find(CharactersFF, v) then table.insert(CharactersFF, v) end
			else
				local j = table.find(CharactersFF, v)
				if j then table.remove(CharactersFF, j) end
			end
			if not v:IsDescendantOf(workspace) then
				table.remove(Characters, i)
				local j = table.find(CharactersFF, v)
				if j then table.remove(CharactersFF, j) end
			end
		end
		for i,v in AntiflingBaseParts do
			if v:IsDescendantOf(workspace) then
				v.CanCollide = false
				--v.AssemblyLinearVelocity, v.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
			else
				table.remove(AntiflingBaseParts, i)
			end
		end
		for i,v in AntiflingHumanoids do
			if v:IsDescendantOf(workspace) then
				v.EvaluateStateMachine = false
			else
				table.remove(AntiflingHumanoids, i)
			end
		end
	end)
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
		table.insert(Characters, character)
		
		character.DescendantAdded:Connect(OnBasePart)
		for _,v in character:GetDescendants() do
			OnBasePart(v)
		end
	end
	local OnPlayer = function(player)
		if player == Player then
			player.CharacterAdded:Connect(function(character)
				table.insert(Characters, character)
			end)
			if player.Character then table.insert(Characters, player.Character) end
			return
		end
		player.CharacterAdded:Connect(OnCharacter)
		if player.Character then OnCharacter(player.Character) end
	end
	Players.PlayerAdded:Connect(OnPlayer)
	for _,player in Players:GetPlayers() do
		OnPlayer(player)
	end
end

local function IsSafe(value)
	if not value then return false end
	if value ~= value then return false end
	if typeof(value) == "Vector3" then
		if value.Magnitude > 65536 then return false end
	end
	return true
end
local function DirectionDirector(vec, dir)
	if dir.Magnitude == 0 then return dir end
	return dir * dir:Dot(vec)
end

local CollideForcers = {}
for _,v in workspace:GetChildren() do
	if v.Name == "PhantomPlate" and v:IsA("BasePart") then
		local w = v:Clone()
		w.Parent = v
		w.Name ..= "_CollideCopy"
		w.CanCollide = true
		w.Transparency = 1
		table.insert(CollideForcers, w)
	end
end

local RCP = RaycastParams.new()
RCP.FilterType = Enum.RaycastFilterType.Exclude
RCP.RespectCanCollide = true
RCP.IgnoreWater = true
local OVP = OverlapParams.new()
OVP.FilterType = Enum.RaycastFilterType.Exclude
OVP.RespectCanCollide = true
RunService.PreAnimation:Connect(function()
	RCP.FilterDescendantsInstances = Characters
	OVP.FilterDescendantsInstances = Characters
end)
local function PhysicsRaycast(origin, direction)
	return workspace:Raycast(origin, direction, RCP)
end
local function PhysicsBoxcast(origin, size, direction)
	return workspace:Boxcast(origin, size, direction, RCP)
end
local function PhysicsSpherecast(origin, radius, direction)
	return workspace:Spherecast(origin, radius, direction, RCP)
end
local function PhysicsGetPartBoundsInBox(cf, size)
	return workspace:GetPartBoundsInBox(cf, size, OVP)
end
local function PhysicsCheckArea(cf, size)
	return #PhysicsGetPartBoundsInBox(cf, size) > 0
end
local function PhysicsCheckLine(origin, boxsize, direction)
	return #PhysicsGetPartBoundsInBox(
		CFrame.lookAlong(origin, direction) * CFrame.new(0, 0, -direction / 2),
		Vector3.new(boxsize * 2, boxsize * 2, direction.Magnitude)
	) > 0
end
local function EnsureGround(position, downwarped)
	local radius = 1.1
	local direction = Vector3.new(0, -5, 0)
	if downwarped then direction *= 100 end
	position += Vector3.new(0, 0.2 + radius, 0)
	local cast = PhysicsSpherecast(position, radius, direction)
	if cast then
		return position + direction.Unit * (cast.Distance + radius), cast.Instance
	end
end
local function EnsureGroundRay(position, downwarped)
	local direction = Vector3.new(0, -6, 0)
	if downwarped then direction *= 100 end
	position += Vector3.new(0, 1, 0)
	local cast = PhysicsRaycast(position, direction)
	if cast then
		return cast.Position, cast.Instance
	end
end
local function CheckGround(pos)
	return PhysicsCheckLine(pos, 0.6, Vector3.new(0, -5, 0))
end
local function CheckWalkable(a, b)
	-- checks if we can walk without falling or hitting an obstacle
	-- difference in height = we have to fall or jump
	a = EnsureGround(a)
	if not a then return false end
	b = EnsureGround(b)
	if not b then return false end
	if math.abs(a.Y - b.Y) > 1.5 then return false end
	local diff = b - a
	-- we can walk a 0 distance
	if diff == Vector3.zero then return true end
	local dist = diff.Magnitude
	-- rather say no than iterate 50+ times
	if dist > 50 then return false end
	-- is the target on solid ground?
	if not CheckGround(b) then
		return false
	end
	-- can we walk straight to it?
	if PhysicsCheckLine(a + Vector3.new(0, 3, 0), 1.2, diff) then
		return false
	end
	local dir = diff.Unit
	local step = 1
	-- check if we wont run to any falls
	for i=0, dist, step do
		if not CheckGround(a + dir * i) then
			return false
		end
	end
	return true
end
local AINodes = {}
local AINodesMap = {}
local AINodesDyn = {}
local AINodesCount = 0
local AINodesDynCount = 0
local function SnapToGrid(pos)
	return Vector3.new(
		math.floor(pos.X) + 0.5,
		pos.Y,
		math.floor(pos.Z) + 0.5
	)
end
local GetNodeCost_cache = {}
local function GetNodeCost(node)
	if not GetNodeCost_cache[node] then
		local cost = 1
		local result = PhysicsRaycast(node.Position, Vector3.new(0, -5, 0))
		if result then
			if result.Instance.Transparency > 0 then
				cost = 20
			end
		else
			cost = 600
		end
		result = PhysicsRaycast(node.Position, Vector3.new(0, 6, 0))
		if result then
			cost /= math.max(0.01, result.Distance / 6)
		end
		GetNodeCost_cache[node] = cost
	end
	return GetNodeCost_cache[node]
end
local function GetDistance(a, b)
	return ((b.Position - a.Position) * VEC3XZ).Magnitude
end
local function NodesAreVeryNear(a, b)
	if not table.find(a.Nearby, b) then table.insert(a.Nearby, b) end
	if not table.find(b.Nearby, a) then table.insert(b.Nearby, a) end
end
local function EnsureNodesLinked(a, b)
	if not table.find(a.Links, b) then table.insert(a.Links, b) end
	if not table.find(b.BackLinks, a) then table.insert(b.BackLinks, a) end
end
local function BreakLinks(a, b)
	local i = table.find(a.Links, b)
	if i then table.remove(a.Links, i) end
	i = table.find(b.Links, a)
	if i then table.remove(b.Links, i) end
	i = table.find(a.BackLinks, b)
	if i then table.remove(a.BackLinks, i) end
	i = table.find(b.BackLinks, a)
	if i then table.remove(b.BackLinks, i) end
end
local function BreakAllLinks(node)
	for _,v in node.Links do BreakLinks(node, v) end
	for _,v in node.BackLinks do BreakLinks(node, v) end
end
local function HasNodeInXZ(x, z)
	x, z = math.floor(x), math.floor(z)
	if not AINodes[x] then return false end
	if not AINodes[x][z] then return false end
	return true
end
local function GetNode(pos)
	local node, node2 = AINodes, nil
	local fx, fz = math.floor(pos.X), math.floor(pos.Z)
	local k = fx
	node2 = node[k]
	if not node2 then
		node2 = {}
		node[k] = node2
	end
	node = node2
	k = fz
	node2 = node[k]
	if not node2 then
		node2 = {}
		node[k] = node2
	end
	node = node2
	k = math.floor(pos.Y)
	node2 = node[k]
	if not node2 then
		node2 = {}
		node[k] = node2
		node2.Explored = false
		node2.Known = false
		node2.Dynamic = true
		node2.Links = {}
		node2.BackLinks = {}
		node2.Index = #AINodesMap + 1
		pos = SnapToGrid(pos)
		node2.Nearby = {}
		for x = fx - 4, fx + 4 do
			for z = fz - 4, fz + 4 do
				if x == fx and z == fz then continue end
				if HasNodeInXZ(x, z) then
					for _,node3 in AINodes[x][z] do
						NodesAreVeryNear(node2, node3)
					end
				end
			end
		end
		local y = k
		local poz, ground = EnsureGroundRay(pos)
		if poz then
			y = poz.Y + 0.5
			if ground and ground:IsA("BasePart") and ground:IsGrounded() then
				node2.Dynamic = false
			end
		end
		node2.YLevel = pos.Y
		node2.Position = Vector3.new(pos.X, y, pos.Z)
		node2.Ground = ground
		table.insert(AINodesMap, node2)
		AINodesCount += 1
		if node2.Dynamic then
			table.insert(AINodesDyn, node2)
			AINodesDynCount += 1
		end
	end
	node = node2
	return node
end
local function ClosestNode(pos)
	local n, d = nil, 20
	for _,node in AINodesMap do
		local d2 = (pos - node.Position).Magnitude
		if d2 < d then
			d = d2
			n = node
		end
	end
	return n
end
local function IsNodeValid(pos)
	if not pos then return false end
	pos = SnapToGrid(pos)
	-- dont be close to walls
	if PhysicsCheckArea(CFrame.new(pos + Vector3.new(0, 2.5, 0)), Vector3.new(2, 1, 2)) then
		return false
	end
	-- strictly on ground
	if PhysicsCheckArea(CFrame.new(pos + Vector3.new(0, -0.5, 0)), Vector3.new(0.8, 1, 0.8)) then
		return true
	end
	return false
end
local AINodeWalkers = {}
local function NodeStep(pos)
	local result = PhysicsRaycast(SnapToGrid(pos + Vector3.new(0, 6, 0)), Vector3.new(0, -2048, 0))
	if result then
		return result.Position, result.Distance > 12
	end
	return nil, true
end
local function SummonNodeWalk(pos, dir, node)
	dir = dir or Vector3.zero
	local poz = pos + dir
	if node and node.Dynamic then
		if HasNodeInXZ(poz.X, poz.Z) then
			return false
		end
	end
	local newpos, oneway = NodeStep(poz)
	if IsNodeValid(newpos) then
		local cangoto = not PhysicsCheckLine(pos + Vector3.new(0, 4, 0), 0.4, (newpos - pos) * VEC3XZ)
		if cangoto then
			local newnode = GetNode(newpos)
			if node then
				EnsureNodesLinked(node, newnode)
				if not oneway then EnsureNodesLinked(newnode, node) end
			end
			if not newnode.Known then
				newnode.Known = true
				table.insert(AINodeWalkers, newnode)
			end
		end
		return true
	end
	return false
end
local function NodeWalkWalk(node)
	if CONFIG.DEBUG_NODEWALKER then CreateDot(DebugNodewalker, node.Position) end
	for _,dir in CARDINALS do
		if SummonNodeWalk(node.Position, dir, node) then continue end
		if SummonNodeWalk(node.Position, dir * 2, node) then continue end
		--if SummonNodeWalk(node.Position, dir * 3, node) then continue end
		--if SummonNodeWalk(node.Position, dir * 4, node) then continue end
		SummonNodeWalk(node.Position, dir * 5, node)
	end
end
local function NodeWalk(node)
	if node.Explored then return end
	NodeWalkWalk(node)
	node.Explored = true
end
SummonNodeWalk(Vector3.new(0, 247, 0))

-- chatgpt generated this class
-- "oh and look closely at my indents, peak ragebait"
local Heap = {}
function Heap.new(fScore)
	local self = {
		data = {},
		fScore = fScore
	}
	local function swap(t, a, b)
		t[a], t[b] = t[b], t[a]
	end
	function self.push(self, node)
		table.insert(self.data, node)
		local i = #self.data
		while i > 1 do
			local parent = math.floor(i / 2)
			if self.fScore[self.data[i]] < self.fScore[self.data[parent]] then
				swap(self.data, i, parent)
				i = parent
			else
				break
			end
		end
	end
	function self.pop(self)
		if #self.data == 0 then return nil end
		local root = self.data[1]
		local last = table.remove(self.data)
		if #self.data > 0 then
			self.data[1] = last
			local i = 1
			while true do
				local left = i * 2
				local right = left + 1
				local smallest = i
				if left <= #self.data and
					self.fScore[self.data[left]] < self.fScore[self.data[smallest]] then
					smallest = left
				end
				if right <= #self.data and
					self.fScore[self.data[right]] < self.fScore[self.data[smallest]] then
					smallest = right
				end
				if smallest ~= i then
					swap(self.data, i, smallest)
					i = smallest
				else
					break
				end
			end
		end
		return root
	end
	function self.isEmpty(self)
		return #self.data == 0
	end
	function self.size(self)
		return #self.data
	end
	return self
end
local function AreNodesSkippable(a, b)
	if PhysicsRaycast(a + Vector3.new(0, 2, 0), b - a) then return false end
	local aGround = PhysicsRaycast(a + Vector3.new(0, 2, 0), Vector3.new(0, -5, 0))
	local bGround = PhysicsRaycast(b + Vector3.new(0, 2, 0), Vector3.new(0, -5, 0))
	if aGround and bGround then
		if aGround.Instance == bGround.Instance then
			return true
		end
	end
	return false
end
local function OptimisePath(path)
	local i = 1
	while i <= #path - 2 do
		local a = path[i]
		local c = path[i + 2]
		if AreNodesSkippable(a.Position, c.Position) then
			table.remove(path, i + 1)
		else
			i += 1
		end
	end
end
local function Pathfind(start, goal)
	DebugLines[2] = "PATHFOUND NO WAY (NODEWALKER DIDNT EXPLORE THIS AREA)"
	local startnode = ClosestNode(start)
	if not startnode then
		SummonNodeWalk(start)
		return
	end
	local goalnode = ClosestNode(goal)
	if not goalnode then
		SummonNodeWalk(goal)
		return
	end
	DebugPathfinder.Color3 = Color3.new(1, 0, 0)
	local cameFrom = {}
	local gScore = {}
	local fScore = {}
	local costScan = {}
	gScore[startnode] = 0
	fScore[startnode] = GetDistance(startnode, goalnode)
	costScan[startnode] = GetNodeCost(startnode)
	local openSet = Heap.new(fScore)
	openSet:push(startnode)
	local iter = 0
	while not openSet:isEmpty() do
		DebugLines[2] = "PATHFINDING, HEAP SIZE " .. openSet:size()
		iter += 1
		if iter >= CONFIG.PATHFIND_SPEED then
			task.wait()
			iter = 0
			DebugClear(DebugPathfinder)
			CreateLocator(DebugPathfinder, start)
			CreateLocator(DebugPathfinder, goal)
		end
		local current = openSet:pop()
		if current == goalnode then
			DebugPathfinder.Color3 = Color3.new(1, 1, 0)
			local path = {}
			while current do
				table.insert(path, 1, {
					Position = current.Position,
					Cost = costScan[current],
					Node = current,
				})
				current = cameFrom[current]
			end
			OptimisePath(path)
			DebugLines[2] = "PATHFOUND " .. #path .. " WPS"
			DebugClear(DebugPathfinder)
			CreateLocator(DebugPathfinder, start)
			CreateLocator(DebugPathfinder, goal)
			for i=1, #path do
				CreateDot(DebugPathfinder, path[i].Position)
				CreateText(DebugPathfinder, path[i].Position + Vector3.new(0, 3, 0), tostring(path[i].Cost))
				if path[i - 1] then
					CreateLine(DebugPathfinder, path[i - 1].Position, path[i].Position)
				end
			end
			return path
		end
		if CONFIG.DEBUG_PATHFIND_OPEN then CreateDot(DebugPathfinder, current.Position) end
		for _,neighbor in current.Links do
			local cost = GetNodeCost(neighbor)
			if cost > 0 then
				local tentative = gScore[current] + cost * GetDistance(current, neighbor)
				if not gScore[neighbor] or tentative < gScore[neighbor] then
					cameFrom[neighbor] = current
					gScore[neighbor] = tentative
					fScore[neighbor] = tentative + GetDistance(neighbor, goalnode)
					costScan[neighbor] = cost
					openSet:push(neighbor)
				end
			end
		end
	end
	DebugClear(DebugPathfinder)
	DebugLines[2] = "PATHFOUND NO PATH"
end

task.spawn(function()
	local iter = 0
	while true do
		local node = AINodeWalkers[1]
		if node then
			DebugLines[1] = "WALKING " .. #AINodeWalkers .. " NODES, CURRENT: " .. AINodesCount
			iter += 1
			if iter >= CONFIG.NODEWALK_SPEED then
				task.wait()
				DebugClear(DebugNodewalker)
				iter = 0
			end
			for _,v in CollideForcers do v.CanCollide = true end
			NodeWalk(node)
			table.remove(AINodeWalkers, 1)
		else
			DebugClear(DebugNodewalker)
			DebugLines[1] = "WALKED " .. AINodesCount .. " NODES, " .. AINodesDynCount .. " ARE DYNS"
			for _,v in CollideForcers do v.CanCollide = false end
			task.wait()
		end
	end
end)
task.spawn(function()
	local dyn = 1
	while task.wait(0.2) do
		RunService.PreSimulation:Wait()
		local t = os.clock()
		GetNodeCost_cache = {}
		for _,node in AINodesDyn do
			local ceiling = node.Position * VEC3XZ + Vector3.yAxis * (node.YLevel + 32)
			local downward = PhysicsRaycast(ceiling, Vector3.new(0, -1024, 0))
			if downward and downward.Normal.Y > 0.25 then
				node.Position = SnapToGrid(downward.Position + Vector3.new(0, 0.5, 0))
				node.Ground = downward.Instance
			else
				node.Ground = nil
			end
		end
		if AINodesDynCount > 0 then
			local node = AINodesDyn[dyn]
			dyn = (dyn % AINodesDynCount) + 1
			NodeWalkWalk(node)
			BreakAllLinks(node)
			for _,node2 in node.Nearby do
				if node.Position.Y > node2.Position.Y - 6 then
					EnsureNodesLinked(node, node2)
				end
				if node2.Position.Y > node.Position.Y - 6 then
					EnsureNodesLinked(node2, node)
				end
			end
		end
	end
end)

Player.DevComputerMovementMode = Enum.DevComputerMovementMode.Scriptable
Player.DevTouchMovementMode = Enum.DevTouchMovementMode.Scriptable

local function GetNearestCharacter(pos, dist)
	local nearest = nil
	local nearestdist = dist or 20
	for _,char in Characters do
		if char ~= Player.Character and not char:FindFirstChildOfClass("ForceField") then
			local hum = char:FindFirstChildOfClass("Humanoid")
			local root = char:FindFirstChild("HumanoidRootPart")
			if root and hum and hum.Health > 0 and IsSafe(root.Position) then
				local dist = ((root.Position + root.Velocity * CONFIG.PREDICT_PLAYER_HIT - pos) * VEC3XZ).Magnitude
				if dist <= nearestdist then
					nearest = root
					nearestdist = dist
				end
			end
		end
	end
	return nearest, nearestdist
end
local Difficulties = {
	{ -- EASY
		REACH = 0,
		EXTRASPEED = 0,
	},
	{ -- MEDIUM
		REACH = 1,
		EXTRASPEED = 1,
	},
	{ -- HARD
		REACH = 3,
		EXTRASPEED = 2,
	},
}
local function GetDifficulty()
	local W, L = 300, 0
	if Player:FindFirstChild("leaderstats") then
		if Player.leaderstats:FindFirstChild("KOs") then
			W = Player.leaderstats.KOs.Value
		end
		if Player.leaderstats:FindFirstChild("Wipeouts") then
			L = Player.leaderstats.Wipeouts.Value
		end
	end
end

local function Essentials()
	local char = Player.Character
	local back = Player:FindFirstChildOfClass("Backpack")
	if char and back then
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if hum and root and hum:GetState().Name ~= "Dead" then
			if IsSafe(root.Position) and root.Position.Magnitude < CONFIG.FLING_RESET_DISTANCE then
				return char, back, hum, root
			else
				replicatesignal(hum.ServerBreakJoints)
			end
		end
	end
end

local targetMove = idlePosition
local targetLook = Vector3.zero
local targetLookY = 0
local targetJump = false
local haveSword = false
local useSword = false
local overrideController = false
local noPathEvent = nil
task.spawn(function()
	local function PfThread(pf)
		local path = Pathfind(pf.Start, pf.Goal)
		pf.Done = true
		pf.Path = path or {}
		if not path and noPathEvent then
			noPathEvent(pf.Goal)
		end
	end
	local pathfinding = nil
	local pathfinding2 = nil
	local moveToward = nil
	while true do
		local dt = task.wait()
		DebugClear(DebugController)
		if overrideController then
			DebugLines[3] = "PREDEF IS OVERRIDING"
			DebugLines[4] = "PREDEF IS OVERRIDING"
			DebugLines[5] = "PREDEF IS OVERRIDING"
		end
		local char, back, hum, root = Essentials()
		if char then
			local lleg, rleg = char:FindFirstChild("Left Leg"), char:FindFirstChild("Right Leg")
			if lleg then lleg.CanCollide = false end
			if rleg then rleg.CanCollide = false end
			if char:FindFirstChild("Right Arm") then
				local sword = GetTool(char, back, CONFIG.SWORD_NAME)
				if sword then
					if haveSword then
						DebugLines[3] = "SWORD EQUIPPED"
						if sword.Parent == back then sword.Parent = char end
						if useSword or math.random() < 0.1 * dt then
							DebugLines[3] = "SWORD ACTIVATED"
							sword.Enabled = true
							sword:Activate()
						end
					else
						DebugLines[3] = "SWORD SHEATHED"
						if sword.Parent == char then sword.Parent = back end
					end
				else
					DebugLines[3] = "NO SWORD FOUND"
				end
			else
				DebugLines[3] = "NO RIGHT ARM FOUND, NO GRIP"
			end
			if targetLook and table.find(HUM_STATES_SHIFTLOCK, hum:GetState().Name) then
				local diff = (targetLook - root.Position) * VEC3XZ
				if diff.Magnitude > 0 then
					root.CFrame = CFrame.lookAlong(root.CFrame.Position, diff) * CFrame.Angles(0, targetLookY, 0)
					root.RotVelocity = Vector3.zero
				end
			end
			local onLadder = hum:GetState() == Enum.HumanoidStateType.Climbing
			local onGround = hum:GetState() == Enum.HumanoidStateType.Running or onLadder
			local moveDir = Vector3.zero
			local mePos = EnsureGround(root.Position, true) or root.Position
			local targetMove = IsSafe(targetMove) and (EnsureGround(targetMove, true) or targetMove)
			if mePos and targetMove then
				CreateLocator(DebugController, mePos)
				CreateLocator(DebugController, targetMove)
				if CheckWalkable(mePos, targetMove) then
					DebugLines[4] = "MOVE METHOD: MOVETO"
					pathfinding2 = nil
					moveToward = targetMove
				else
					DebugLines[4] = "MOVE METHOD: PATHFIND, IDLE (SHOULDNT HAPPEN)"
					if pathfinding and pathfinding ~= "FORCE" then
						if pathfinding.Done then
							pathfinding2 = pathfinding
							pathfinding = nil
							if moveToward then
								local path = pathfinding2.Path
								local closestDist = 670000
								for i=1, #path do
									local dist = (moveToward - path[i].Position).Magnitude
									if dist < closestDist then
										closestDist = dist
										pathfinding2.Index = i
									end
								end
							end
						else
							DebugLines[4] = "MOVE METHOD: PATHFIND, RUNNING"
						end
					elseif pathfinding == "FORCE" or not pathfinding2 then
						local pf = {}
						pf.Start = mePos
						if pathfinding2 then
							pf.Start = moveToward
						end
						pf.Goal = targetMove
						pf.Index = 1
						pf.Path = {}
						pf.Done = false
						task.spawn(PfThread, pf)
						pathfinding = pf
						DebugLines[4] = "MOVE METHOD: PATHFIND, STARTING"
					end
					local pf = pathfinding2
					if pf and #pf.Path >= pf.Index then
						local path = pathfinding2.Path
						for i=0, 16 do
							local wp = path[pf.Index + i]
							local lwp = path[pf.Index + i - 1]
							local nwp = path[pf.Index + i + 1]
							if wp then
								CreateDot(DebugController, wp.Position)
								if GetNodeCost(wp.Node) ~= wp.Cost then
									pathfinding = pathfinding or "FORCE"
									break
								end
								if nwp and not CheckGround((nwp.Position + wp.Position) / 2) then
									if not onGround then continue end
								end
								if ((wp.Position - mePos) * VEC3XZ).Magnitude < 0.5 then
									pf.Index += i + 1
									break
								end
							else
								break
							end
						end
						if (pathfinding2.Goal - targetMove).Magnitude > 4 then
							pathfinding = pathfinding or "FORCE"
						end
						if path[pf.Index] and CheckGround(path[pf.Index].Position) then
							DebugLines[4] = "METHOD: PATHFIND, PATHING, IDX = " .. pf.Index
							moveToward = path[pf.Index].Position
							if moveToward.Y > mePos.Y + 6 and pf.Index > 1 then
								pf.Index -= 1
							end
						end
					else
						pathfinding2 = nil
					end
				end
				if moveToward then
					CreateLocator(DebugController, moveToward + Vector3.new(0, 1, 0))
					local diff = (moveToward - mePos) * VEC3XZ
					if onGround then
						diff *= 2
					else
						diff *= 0.8
					end
					if diff.Magnitude > 1 then
						moveDir = diff.Unit
					else
						moveDir = diff
					end
				end
			else
				DebugLines[4] = "MOVE METHOD: I HAVE FALLEN AND I CANT GET UP"
			end
			local mustJump = targetJump
			if onGround and not onLadder then
				DebugLines[5] = "JUMP STATE: FUH NAW!"
				local dir = root.Velocity * VEC3XZ
				if mustJump then
					DebugLines[5] = "JUMP STATE: YES! (BRAIN SAID SO)"
				else
					if dir.Magnitude > 0.2 and PhysicsCheckArea(root.CFrame, Vector3.new(4.5, 3, 3.5)) then
						mustJump = true
						DebugLines[5] = "JUMP STATE: YES! (WE WILL HIT AN OBSTACLE)"
					end
				end
				if not mustJump then
					if dir.Magnitude > 0.2 then
						local check1 = PhysicsCheckArea(root.CFrame + dir.Unit * 0.5 + Vector3.new(0, -3, 0), Vector3.new(1, 3, 0.25))
						local check2 = PhysicsCheckArea(root.CFrame + dir.Unit * 1 + Vector3.new(0, -3, 0), Vector3.new(1, 3, 1))
						local check3 = PhysicsCheckArea(root.CFrame + dir.Unit * 2.5 + Vector3.new(0, -506, 0), Vector3.new(1.5, 1024, 5))
						if not check1 and not check2 then
							if check3 then
								mustJump = true
								DebugLines[5] = "JUMP STATE: YES! (MOVEMENT NEEDS TO JUMP OVER LEDGE)"
							else
								moveDir = Vector3.zero
								pathfinding2 = nil
								DebugLines[5] = "JUMP STATE: AW HAIL NAW! (MOVEMENT LEADS TO A VOID)"
							end
						end
					end
				end
			end
			CreateLine(DebugController, root.Position, root.Position + moveDir * 4)
			hum:Move(moveDir)
			if CONFIG.PATCH_HUMANOID_MOVE_QUIRKS and not onLadder then
				local vel = root.Velocity
				local tvel = moveDir * VEC3XZ * hum.WalkSpeed + Vector3.yAxis * vel.Y
				if onGround then
					vel = tvel:Lerp(vel, math.exp(-16 * dt))
				else
					vel = tvel:Lerp(vel, math.exp(-2 * dt))
				end
				root.Velocity = vel
			end
			if mustJump and onGround then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		else
			DebugLines[3] = "ALAS MY SWORD"
			DebugLines[4] = "INVALID CHARACTER"
			DebugLines[5] = "YOU ARE HERE --> t"
			moveToward = nil
			pathfinding = nil
			pathfinding2 = nil
		end
	end
end)

local charge = false
task.spawn(function()
	while true do
		task.wait(math.random() * 5)
		charge = not charge
	end
end)

local strafe = 2
local strafe2 = 2
task.spawn(function()
	while true do
		strafe2 = math.random(-2, 2)
		if math.random() < 0.89 then
			strafe = -strafe
		else
			for _=1, math.random(4) * 2 do
				strafe = -strafe
				task.wait(1 / 9)
			end
		end
		task.wait(math.random() * 2)
	end
end)

local backoff = 19
task.spawn(function()
	while true do
		task.wait(math.random() * 2)
		backoff = math.random(16, 20)
	end
end)

local idlePosition = nil
local chargeJump = 0
local Playstyles = {
	function(dt, hum, root, victim, dist, hitDist, mePos, mePosGround, victimPos, victimCF)
		local vpos = victimPos
		local vcf = CFrame.lookAlong(Vector3.zero, (victimPos - mePos) * VEC3XZ)
		if dist > CONFIG.PREDICT_PLAYER_DIST and victim.Velocity.Magnitude > 1 then
			local voff = victim.Velocity * CONFIG.PREDICT_PLAYER_HIT * VEC3XZ
			vpos += voff
		end
		if dist < CONFIG.IMMEDIATE_ATTACK_RADIUS then
			charge = true
		end
		local closest = 1.5
		if victim.Position.Y < mePos.Y - 0.5 then
			closest = 2.5
		end
		if dist > 9 then
			targetLook = vpos
		else
			targetLook = victimPos
		end
		local lookYDist = (targetLook - mePos).Magnitude
		if lookYDist > 1.5 then
			targetLookY = math.atan(1.5 / lookYDist)
		else
			targetLookY = math.pi * 0.5
		end
		local goingTo = -victim.Velocity.Unit:Dot(vcf.LookVector)
		local goingToR = victim.Velocity.Unit:Dot(vcf.RightVector)
		local swordDir = victimCF:VectorToWorldSpace(Vector3.new(1.5, 0, -1.2).Unit)
		local vdist = ((vpos - mePos) * VEC3XZ).Magnitude
		targetJump = victim.Velocity.Y > 10
		if victim.Velocity.Magnitude > 1 and CheckWalkable(mePosGround, victimPos) then
			local tight = 0
			for _,v in CARDINALS do
				if CheckGround(victimPos + v * 3) then
					tight += 1
					CreateLocator(DebugBrain, victimPos + v * 3)
				end
			end
			if tight > 5 then
				DebugLines[7] = "PLAYSTYLE: CURRENTLY IN BATTLE"
				targetMove = vpos + vcf:VectorToWorldSpace(Vector3.new(strafe, 0, backoff))
				if not CheckGround(targetMove * VEC3XZ + mePosGround * Vector3.yAxis) then
					charge = true
					strafe2 = 0
					DebugLines[7] = "PLAYSTYLE: CHARGING, AREA TOO SMALL"
				end
				if goingTo > 0.7 then
					charge = true
					if vcf.RightVector:Dot(swordDir) + goingToR * 2 > 0 then
						strafe2 = -2
					else
						strafe2 = 2
					end
					if math.abs(goingToR) > 0.7 then
						closest = 3
					end
					DebugLines[7] = "PLAYSTYLE: CHARGING, COMING AT ME"
				end
				if goingTo < -0.55 then
					charge = true
					strafe2 = 0
					closest = 1.5
					DebugLines[7] = "PLAYSTYLE: CHARGING, RUNNING AWAY"
				end
				if charge then
					if vdist > CONFIG.CHARGE_NO_JUMP_DIST or goingTo > 0.8 then
						if os.clock() - chargeJump > 1 then
							chargeJump = os.clock()
							targetJump = true
						end
					end
					targetMove = mePosGround + vcf:VectorToWorldSpace(Vector3.new(strafe2, 0, closest - dist))
				end
			else
				DebugLines[7] = "PLAYSTYLE: CURRENTLY IN 2 STUD FLOOR BATTLE"
				targetMove = vpos + vcf:VectorToWorldSpace(Vector3.new(0, 0, backoff))
				if goingTo > 0.7 then
					charge = true
					DebugLines[7] = "PLAYSTYLE: CHARGING, COMING AT ME"
				end
				if charge then
					if vdist > 6 + goingTo * 4 and dist > 3 then
						targetJump = true
					end
					targetMove = vpos + vcf:VectorToWorldSpace(Vector3.new(0, 0, closest))
				end
			end
		else
			DebugLines[7] = "PLAYSTYLE: NON-MOVING TARGET"
			if vdist > CONFIG.CHARGE_NO_JUMP_DIST or goingTo > 0.8 then
				targetJump = true
			end
			targetMove = vpos + vcf:VectorToWorldSpace(Vector3.new(strafe2, 0, closest))
		end
		if (hum:GetState() == Enum.HumanoidStateType.Running or targetJump) and dist < CONFIG.DIST_SWING or hitDist < 2 then
			useSword = true
			targetLookY += math.pi * 0.25 * (math.random() - 0.5) * 2
		end
	end,
	function(dt, hum, root, victim, dist, hitDist, mePos, mePosGround, victimPos, victimCF)
		local vpos = victimPos + (victim.Velocity * CONFIG.PREDICT_PLAYER_HIT)
		if dist <= 5 then
			vpos = victimPos
		end
		if dist < 14 and dist > 5.5 then
			targetJump = true
		end
		if dist < CONFIG.IMMEDIATE_ATTACK_RADIUS then
			charge = true
		end
		local diff = (victim.Position - root.Position) * VEC3XZ
		local currentDist = diff.Magnitude
		targetLook = vpos
		local lookat = CFrame.lookAlong(Vector3.zero, (vpos - root.Position) * VEC3XZ)
		local lookat2 = CFrame.lookAlong(Vector3.zero, (victim.Position - root.Position) * VEC3XZ)
		if victim.Velocity.Magnitude > 0.2 and CheckWalkable(mePosGround, victimPos) then
			if charge then
				targetJump = true
				if currentDist >= 4 then
					DebugLines[7] = "PLAYSTYLE: CHARGING WITH BIG STRAFE"
					targetMove = vpos + lookat:VectorToWorldSpace(Vector3.new(3, 0, 2))
				else
					DebugLines[7] = "PLAYSTYLE: CHARGING WITH STRICT MOVETO"
					local strafe = lookat2:VectorToWorldSpace(Vector3.new(math.sin(tick() * 4) * 6, 0, -99))
					targetMove = vpos + strafe
				end
				targetLookY = math.pi * 0.45 * (math.random() - 0.45)
			else
				DebugLines[7] = "PLAYSTYLE: CHARGING, COMING AT ME"
				targetMove = vpos + lookat:VectorToWorldSpace(Vector3.new(strafe2, 0, 21.8))
			end
		else
			DebugLines[7] = "PLAYSTYLE: NON-MOVING TARGET"
			targetMove = vpos + lookat:VectorToWorldSpace(Vector3.new(0, 0, 2.5))
			targetLookY = math.pi * 0.1 * (math.random() - 0.1)
		end
		CreateLocator(DebugBrain, targetMove)
		targetLookY = math.pi * 0.05
		if not CheckGround(targetMove, Vector3.new(0, -5, 0)) then
			DebugLines[7] = "PLAYSTYLE: MY MOVE TARGET LEADS TO A CLIFF"
			targetMove = vpos + lookat:VectorToWorldSpace(Vector3.new(0, 0, 2))
		end
		if dist < 8 + Player:GetNetworkPing() + CONFIG.DIST_SWING then
			useSword = true
		end
	end,
	function(dt, hum, root, victim, dist, hitDist, mePos, mePosGround, victimPos, victimCF)
		local vpos = victimPos
		local vcf = CFrame.lookAlong(Vector3.zero, (victimPos - mePos) * VEC3XZ)
		if dist > CONFIG.PREDICT_PLAYER_DIST then
			local voff = victim.Velocity * CONFIG.PREDICT_PLAYER_HIT * VEC3XZ
			vpos += voff
		end
		if dist < CONFIG.IMMEDIATE_ATTACK_RADIUS then
			charge = true
		end
		local closest = 1.5
		if victim.Position.Y < mePos.Y - 0.5 then
			closest = 2.5
		end
		targetLook = victimPos
		local lookYDist = (targetLook - mePos).Magnitude
		if lookYDist > 1.5 then
			targetLookY = math.atan(1.5 / lookYDist)
		else
			targetLookY = math.pi * 0.5
		end
		targetJump = victim.Velocity.Y > 10
		if victim.Velocity.Magnitude > 1 and CheckWalkable(mePosGround, victimPos) then
			DebugLines[7] = "PLAYSTYLE: STRAFING..."
			targetMove = mePosGround + vcf:VectorToWorldSpace(Vector3.new(strafe * 2, 0, (backoff - dist) / 2)) + victim.Velocity / 4
			if vcf.LookVector:Dot(victim.Velocity.Unit) < 0.9 then
				charge = true
			end
			if charge then
				if dist > CONFIG.CHARGE_NO_JUMP_DIST then
					targetJump = true
				end
				DebugLines[7] = "PLAYSTYLE: CHARGING STRAFING..."
				targetMove = mePosGround + vcf:VectorToWorldSpace(Vector3.new(strafe2, 0, -2))
			end
		else
			DebugLines[7] = "PLAYSTYLE: CHARGING STRAFING TO NON MOVING..."
			targetMove = vpos + vcf:VectorToWorldSpace(Vector3.new(strafe2, 0, closest))
		end
		if (hum:GetState() == Enum.HumanoidStateType.Running or targetJump) and dist < CONFIG.DIST_SWING or hitDist < 2 then
			useSword = true
			targetLookY += math.pi * 0.25 * (math.random() - 0.5) * 2
		end
	end,
}
local PlaystylesNames = {
	"MODIFIED WD40",
	"OMNI UNOPTIMISED",
	"STUDIO SF BOT",
}
local PlaystylesDeaths = {}
for _,_ in PlaystylesNames do table.insert(PlaystylesDeaths, 0) end
local function Determination()
	local low, lowv, high, highv = nil, math.huge, nil, 0
	for i,v in PlaystylesDeaths do
		if v <= lowv then
			low, lowv = i, v
		end
		if v >= highv then
			high, highv = i, v
		end
	end
	if low and high then
		local diff = highv - lowv
		if diff > 16 then
			if math.random() > 16 / diff then
				return low
			end
		end
	end
	return math.random(#Playstyles)
end
local function Determined(i)
	PlaystylesDeaths[i] += 1
end

local currentVictim = nil
local currentPlaystyle = nil
local currentPlaystyleName = "NULL"
local currentPlaystyleIndex = 0
while true do
	local dt = task.wait()
	if charge then
		DebugLines[8] = "CHARGING? YES"
	else
		DebugLines[8] = "CHARGING? NO"
	end
	DebugClear(DebugBrain)
	local char, back, hum, root = Essentials()
	if char then
		DebugLines[6] = "BRAIN: NO TARGETS, IDLING"
		DebugLines[7] = "PLAYSTYLE: NO THOUGHTS"
		targetMove = nil
		targetLook = nil
		targetLookY = 0
		targetJump = false
		haveSword = false
		useSword = false
		if overrideController then
			DebugLines[6] = "BRAIN: IN OVERRIDE"
			continue
		end
		if math.random() < 0.3 * dt then
			idlePosition = nil
		end
		if not idlePosition then
			local dir = CFrame.Angles(0, math.random() * math.pi * 2, 0).LookVector * math.random(10, 100)
			local hit = PhysicsRaycast(root.Position + dir + Vector3.new(0, 512, 0), Vector3.new(0, -1024, 0))
			if hit then
				idlePosition = hit.Position
			end
		end
		targetMove = idlePosition
		local distanceToEngage = CONFIG.DETECTION_RADIUS
		if CONFIG.ALLOW_HEALING then
			if hum.Health < CONFIG.HEALING_BELOW_HEALTH then
				distanceToEngage = CONFIG.START_COMBAT
				local healpad, healdist = nil, math.huge
				for _,v in CONFIG.HEALING_PAD_POSITIONS do
					local dist = ((v - root.Position) * VEC3XZ).Magnitude
					if dist < healdist then
						healpad = v
						healdist = dist
					end
				end
				if healpad then
					targetMove = healpad
					targetJump = true -- to fire touch events
					DebugLines[6] = "BRAIN: I BETTER HEAL UP"
				else
					DebugLines[6] = "BRAIN: I AM LOW AND I CANT HEAL UP"
				end
			end
		end
		if currentVictim then
			if IsSafe(currentVictim.Position) then
				local test, _ = GetNearestCharacter(currentVictim.Position)
				if test ~= currentVictim then
					currentVictim = nil
				end
			else
				currentVictim = nil
			end
		end
		local mePos = root.Position
		local mePosGround = EnsureGround(mePos, true) or mePos
		local victim, dist = GetNearestCharacter(mePos, distanceToEngage)
		if not currentVictim or dist < CONFIG.START_COMBAT then
			if currentVictim ~= victim then
				currentPlaystyle = nil
				charge = false
			end
			currentVictim = victim
		end
		if currentVictim then
			victim, dist = currentVictim, (currentVictim.Position - mePos).Magnitude
		end
		if victim and dist then
			DebugLines[6] = "BRAIN: RED ALERT RED ALERT"
			idlePosition = nil
			CreateLine(DebugBrain, mePos, victim.Position)
			local victimCF = victim.CFrame
			local victimPos = EnsureGround(victim.Position, true) or victim.Position
			if dist < CONFIG.START_COMBAT then
				haveSword = true
				CreateCircle(DebugBrain, victimPos, CONFIG.IMMEDIATE_ATTACK_RADIUS)
				CreateLine(DebugBrain, root.CFrame * Vector3.new(1.5, 0.5, 0.5), root.CFrame * Vector3.new(1.5, 0.5, -CONFIG.START_COMBAT))
				local hitPos = root.CFrame * Vector3.new(0, 0, -1)
				CreateCircle(DebugBrain, hitPos, 2)
				local hitDist = ((hitPos - victimPos) * VEC3XZ).Magnitude
				if not currentPlaystyle then
					local i = Determination()
					currentPlaystyle = Playstyles[i]
					currentPlaystyleName = PlaystylesNames[i]
					currentPlaystyleIndex = i
				end
				DebugLines[6] = "BRAIN: IN COMBAT, PLAYSTYLE " .. currentPlaystyleName
				currentPlaystyle(dt, hum, root, victim, dist, hitDist, mePos, mePosGround, victimPos, victimCF)
				if hitDist < 2 and victim.Position.Y > root.Position.Y - 6 then
					local sword = GetTool(char, back, CONFIG.SWORD_NAME)
					local handle = sword and sword:FindFirstChild("Handle")
					if handle then
						firetouchinterest(handle, victim, 0)
						firetouchinterest(handle, victim, 1)
					end
				end
			else
				targetMove = victimPos
			end
		end
	else
		DebugLines[6] = "BRAIN: POW! YOU ARE DEAD! PLAYSTYLE " .. currentPlaystyleName
		DebugLines[7] = "PLAYSTYLE: NO THOUGHTS CUZ DED LOL"
		idlePosition = nil
		if currentPlaystyleIndex > 0 then
			Determined(currentPlaystyleIndex)
		end
		currentPlaystyle = nil
		currentPlaystyleName = "NULL"
		currentPlaystyleIndex = 0
	end
	for i,name in PlaystylesNames do
		DebugLines[6] ..= "\n" .. name .. "'S WOS IS " .. PlaystylesDeaths[i]
	end
end
local Hacking = {
	function(char, back, root, hum, sword, victim)
		DebugLines[9] = "PREDEF RAN: REACHKILL UNREACHED"
		sword.Parent = char
		local handle = sword:FindFirstChild("Handle")
		if handle then
			task.wait(0.1)
			while GetNearestCharacter(victim.Position) == victim do
				firetouchinterest(handle, victim, 0)
				firetouchinterest(handle, victim, 1)
				sword.Enabled = true
				sword:Activate()
				task.wait()
			end
			task.wait(0.5)
			sword.Parent = back
		end
	end
}
noPathEvent = function(goal)
	print(currentVictim, (targetMove - goal).Magnitude)
	if currentVictim and (targetMove - goal).Magnitude < 4 then
		if CONFIG.USE_PREDEFS_ON_NOPATH then
			if #Hacking == 0 then return end
			local char, back, root, hum = Essentials()
			local sword = GetTool(char, back, CONFIG.SWORD_NAME)
			if char and sword then
				overrideController = true
				Hacking[math.random(#Hacking)](char, back, root, hum, sword, currentVictim)
				overrideController = false
			end
		else
			currentVictim = nil
		end
	end
end