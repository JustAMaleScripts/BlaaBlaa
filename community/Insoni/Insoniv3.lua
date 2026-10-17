-- Insoniv3.lua
-- Created with Moveset Creator V6
-- Place in: UhhhhhhReanim/Modules/Insoniv3.lua

cloneref = cloneref or function(o) return o end

local Debris     = cloneref(game:GetService("Debris"))
local RunService = cloneref(game:GetService("RunService"))
local Players    = cloneref(game:GetService("Players"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local TweenService = cloneref(game:GetService("TweenService"))

local Player = Players.LocalPlayer

local modules = {}
local function AddModule(m)
    table.insert(modules, m)
end

-- san_lua: convert any string to a valid Lua identifier (no spaces)
-- used only for table keys that are Lua identifiers (mode actions)
local function san_lua(s)
    return (s or ""):gsub("[^%w_]", "_")
end

AddModule(function()
    local m = {}
    m.ModuleType   = "MOVESET"
    m.Name         = "Insoni v3 beta moveset"
    m.Description  = "Still works in progress and its super larry so it should work."
    m.InternalName = "Insoniv3"
    m.UseNewSounds = true
    m.SprintExtra = true

    m.Assets = {
        "insoni idle normal used for both versions.anim",
        "insoni walk used for both versions.anim",
        "insoni jump used for both versions.anim",
        "insoni fall used for both versions.anim",
        "insoni run used for both versions.anim",
        "insoni head emote.anim",
        "insoni laugh emote.anim",
        "insoni lay emote.anim",
        "insoni sit emote.anim",
        "insoni sit 2 emote.anim",
        "insoni sit 3 emote.anim",
        "insoni sit buggy used for both versions.anim",
        "idle random laugh.anim",
        "insoni walk current.mp3",
        "insoni jump current.mp3",
        "insoni sprint extra.mp3",
        "insoni walk old.mp3",
        "insoni jump old.mp3",
        "insoni run extra old.mp3",
        "player speak 1.mp3",
        "player speak 2.mp3",
        "player speak 3.mp3",
        "player death.mp3",
        "trip current.mp3",
        "TRIP Fall.mp3",
        "player movement turn cam.mp3",
    }

    m.FlingEnabled = {
        -- no default attacks
    }

    -- Forward declarations used by the config callbacks.
    local figureRef = nil
    local currentBase = "idle"
    local refreshMovementSounds
    local disableSprint
    local refreshSprintButton

    m.Config = function(parent)
        Util_CreateText(parent, "Insoni v3 beta moveset", 18, Enum.TextXAlignment.Center)
        Util_CreateSeparator(parent)
        Util_CreateSwitch(parent, "Use New Sounds", m.UseNewSounds).Changed:Connect(function(v)
            m.UseNewSounds = v
            if figureRef then refreshMovementSounds() end
        end)
        Util_CreateSwitch(parent, "Sprint Extra", m.SprintExtra).Changed:Connect(function(v)
            m.SprintExtra = v
            if not v and disableSprint then disableSprint() end
            if refreshSprintButton then refreshSprintButton() end
        end)
    end

    m.SaveConfig = function()
        return { UseNewSounds = m.UseNewSounds, SprintExtra = m.SprintExtra }
    end

    m.LoadConfig = function(save)
        if save and save.UseNewSounds ~= nil then
            m.UseNewSounds = save.UseNewSounds
            if figureRef then refreshMovementSounds() end
        end
        if save and save.SprintExtra ~= nil then
            m.SprintExtra = save.SprintExtra
            if not m.SprintExtra and disableSprint then disableSprint() end
            if refreshSprintButton then refreshSprintButton() end
        end
    end

    -- STATE
    local baseAnims    = {}
    local actionAnims  = {}
    local animJump     = nil
    local animFall     = nil
    local actionStart  = {}
    local emoteActionsBound = {}
    local currentAction = nil
    local wasInAir      = false
    local flingActive   = false
    local touchConns    = {}
    local allJoints     = {}
    local SPEED_WALK    = 10
    local SPEED_SPRINT  = 16
    local DEFAULT_JUMP_POWER = 50
    local TRIP_WALK_SPEED = 0 -- no walking during the trip
    local TRIP_JUMP_POWER = 0 -- no jumping during the trip
    local TRIP_DURATION = 5
    local isSprinting   = false
    -- Per-animation sounds
    local snd_insoni_walk_used_for_both_versions_anim = nil
    local snd_insoni_jump_used_for_both_versions_anim = nil
    local snd_insoni_run_used_for_both_versions_anim = nil
    local soundParent = nil
    local movementSoundFiles = {
        new = { walk = "insoni walk current.mp3", jump = "insoni jump current.mp3", sprint = "insoni sprint extra.mp3" },
        old = { walk = "insoni walk old.mp3", jump = "insoni jump old.mp3", sprint = "insoni run extra old.mp3" },
    }
    local speakSounds = {}
    local speakConn = nil
    local lastVoiceIndex = nil
    local deathSound = nil
    local tripSound = nil
    local turnCamSound = nil
    local deathConn = nil
    local stateConn = nil
    local jumpConn = nil
    local cameraConn = nil
    local lastCameraCFrame = nil
    local cameraBlur = nil
    local createdCameraBlur = false
    local motionTripConn = nil
    local motionTripReady = true
    local lastTurnCamAt = 0
    local lastTripAt = 0
    local tripTween = nil
    local turnCamTween = nil
    local TRIP_SOUND_COOLDOWN = 2.5
    local TURN_CAM_ANGULAR_THRESHOLD = 2.8 -- radians per second; only sharp camera turns
    local CAMERA_TRIP_ANGULAR_THRESHOLD = 27.5 -- require a sustained, exceptionally fast camera turn
    local CAMERA_TURN_SOUND_ACTIVE = false
    local JUMP_COOLDOWN_SECONDS = 1
    local nextJumpAllowedAt = 0
    -- Blur responds to angular speed, so harder turns produce stronger blur.
    local CAMERA_BLUR_SPEED_SCALE = 0.75
    local CAMERA_BLUR_MAX = 22
    local CAMERA_BLUR_RECOVERY = 11
    local tripSoundPlayedForCurrentFall = false
    local cameraTripStunActive = false
    local cameraTripGeneration = 0
    local emoteDefinitions = {
        { key = "Head", label = "Head", file = "insoni head emote.anim", looped = true, x = -320, y = -130 },
        { key = "Laugh", label = "Laugh", file = "insoni laugh emote.anim", looped = true, x = -240, y = -130 },
        { key = "Lay", label = "Lay", file = "insoni lay emote.anim", looped = true, x = -160, y = -130 },
        { key = "Sit", label = "Sit", file = "insoni sit emote.anim", looped = true, x = -320, y = -205 },
        { key = "Sit2", label = "Sit 2", file = "insoni sit 2 emote.anim", looped = true, x = -240, y = -205 },
        { key = "Sit3", label = "Sit 3", file = "insoni sit 3 emote.anim", looped = true, x = -160, y = -205 },
    }
    -- Random laugh is automatic, not a user-facing emote button.
    local nextRandomLaughAt = 0
    local RANDOM_LAUGH_MIN_DELAY = 30
    local RANDOM_LAUGH_MAX_DELAY = 75

    -- HELPERS
    local function makeSound(filename, parent, volume, looped)
        local s = Instance.new("Sound")
        s.SoundId = AssetGetContentId(filename)
        s.Volume  = volume or 0.8
        s.Looped  = looped or false
        s.Parent  = parent
        return s
    end

    local function playSharpFadeIn(sound, tweenRefName)
        if not sound or not sound.Parent then return end
        local oldTween
        if tweenRefName == "trip" then
            oldTween = tripTween
        else
            oldTween = turnCamTween
        end
        if oldTween then pcall(function() oldTween:Cancel() end) end
        sound:Stop()
        sound.TimePosition = 0
        sound.Volume = 0
        sound:Play()
        local tween = TweenService:Create(sound, TweenInfo.new(0.055, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Volume = 0.8})
        if tweenRefName == "trip" then tripTween = tween else turnCamTween = tween end
        tween:Play()
    end

    local function playTripSound()
        local now = os.clock()
        if not tripSound or now - lastTripAt < TRIP_SOUND_COOLDOWN then return end
        lastTripAt = now
        tripSoundPlayedForCurrentFall = true
        playSharpFadeIn(tripSound, "trip")
    end

    -- Camera trips require a sustained, exceptionally fast turn. Ordinary blur,
    -- small camera movements, falling states, and grounded tipping do not trigger it.
    local function triggerActualTrip(hum)
        if cameraTripStunActive or not hum or not hum.Parent then return end
        cameraTripStunActive = true
        motionTripReady = false
        cameraTripGeneration += 1
        local generation = cameraTripGeneration
        local oldHipHeight = hum.HipHeight
        local beingEditedValue
        pcall(function()
            local gui = Player:FindFirstChildOfClass("PlayerGui")
            local ui = gui and gui:FindFirstChild("PlayerUi")
            local value = ui and ui:FindFirstChild("BeingEdited")
            if value and value:IsA("BoolValue") then
                beingEditedValue = value
                value.Value = true
            end
        end)
        hum.UseJumpPower = true
        -- Lock all movement during the trip, regardless of walk/sprint state.
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        hum.HipHeight = -2.1
        task.delay(TRIP_DURATION, function()
            if generation ~= cameraTripGeneration then return end
            if hum and hum.Parent then
                hum.WalkSpeed = isSprinting and SPEED_SPRINT or SPEED_WALK
                hum.UseJumpPower = true
                hum.JumpPower = DEFAULT_JUMP_POWER
                hum.HipHeight = oldHipHeight
            end
            if beingEditedValue and beingEditedValue.Parent then
                beingEditedValue.Value = false
            end
            cameraTripStunActive = false
            motionTripReady = true
        end)
    end

    local function isFirstPersonCamera(camera, figure)
        if not camera or not figure then return false end

        -- LockFirstPerson is definitive. Also support Roblox's normal Classic
        -- camera when the player has zoomed all the way into first person.
        if Player.CameraMode == Enum.CameraMode.LockFirstPerson then
            return true
        end

        local head = figure:FindFirstChild("Head")
        if not head then return false end
        return (camera.CFrame.Position - head.Position).Magnitude <= 1.0
    end

    local function setupCameraTurnSound(figure)
        if cameraConn then cameraConn:Disconnect(); cameraConn = nil end
        if motionTripConn then motionTripConn:Disconnect(); motionTripConn = nil end
        motionTripReady = true
        lastCameraCFrame = nil
        local boundTripBlur = nil
        cameraConn = RunService.RenderStepped:Connect(function(dt)
            local camera = workspace.CurrentCamera
            if not camera then return end

            -- Reuse the named Motion blur if one already exists; otherwise create
            -- one and remember that this module owns it.
            if not cameraBlur or cameraBlur.Parent ~= camera then
                if cameraBlur and createdCameraBlur then
                    cameraBlur:Destroy()
                end
                local existing = camera:FindFirstChild("Motion")
                if existing and existing:IsA("BlurEffect") then
                    cameraBlur = existing
                    createdCameraBlur = false
                else
                    cameraBlur = Instance.new("BlurEffect")
                    cameraBlur.Name = "Motion"
                    cameraBlur.Size = 0
                    cameraBlur.Parent = camera
                    createdCameraBlur = true
                end
            end

            -- Trip detection is checked after angular speed is measured below.
            -- A blur value alone is not enough: the player must be turning the
            -- camera exceptionally hard, preventing tiny movements from tripping.
            if cameraBlur ~= boundTripBlur then
                if motionTripConn then motionTripConn:Disconnect(); motionTripConn = nil end
                boundTripBlur = cameraBlur
            end

            local currentCFrame = camera.CFrame
            local previous = lastCameraCFrame
            lastCameraCFrame = currentCFrame
            local angle = 0
            if previous and dt > 0 then
                local dot = math.clamp(previous.LookVector:Dot(currentCFrame.LookVector), -1, 1)
                angle = math.acos(dot)
            end

            local angularSpeed = (previous and dt > 0) and (angle / math.max(dt, 1 / 240)) or 0
            -- Stronger camera turns create more blur; the effect eases back to zero.
            local blurTarget = math.clamp(angularSpeed * CAMERA_BLUR_SPEED_SCALE, 0, CAMERA_BLUR_MAX)
            local blend = 1 - math.exp(-CAMERA_BLUR_RECOVERY * math.max(dt, 0))
            cameraBlur.Size = cameraBlur.Size + (blurTarget - cameraBlur.Size) * blend

            -- Only a genuinely extreme camera turn may trigger MotionTrip.
            -- Ordinary blur, tiny camera movements, and existing blur effects
            -- cannot trip the character by themselves.
            if motionTripReady and not cameraTripStunActive
                and cameraBlur.Size > 16
                and angularSpeed >= CAMERA_TRIP_ANGULAR_THRESHOLD then
                local currentFigure = figureRef
                local currentHum = currentFigure and currentFigure:FindFirstChildOfClass("Humanoid")
                if currentHum then
                    playTripSound()
                    triggerActualTrip(currentHum)
                end
            end

            -- In first person, loop the camera-turn MP3 only while the player is
            -- actively making a sharp turn. Do not restart it on every frame.
            local shouldPlayTurnSound = previous ~= nil and dt > 0
                and figureRef == figure
                and isFirstPersonCamera(camera, figure)
                and angularSpeed >= TURN_CAM_ANGULAR_THRESHOLD
            if shouldPlayTurnSound then
                if turnCamSound and turnCamSound.Parent and not CAMERA_TURN_SOUND_ACTIVE then
                    CAMERA_TURN_SOUND_ACTIVE = true
                    turnCamSound.Looped = true
                    turnCamSound.Volume = 0
                    turnCamSound.TimePosition = 0
                    turnCamSound:Play()
                    if turnCamTween then pcall(function() turnCamTween:Cancel() end) end
                    turnCamTween = TweenService:Create(turnCamSound, TweenInfo.new(0.055, Enum.EasingStyle.Linear), {Volume = 0.8})
                    turnCamTween:Play()
                end
            elseif CAMERA_TURN_SOUND_ACTIVE then
                CAMERA_TURN_SOUND_ACTIVE = false
                if turnCamTween then pcall(function() turnCamTween:Cancel() end); turnCamTween = nil end
                if turnCamSound then
                    turnCamSound:Stop()
                    turnCamSound.TimePosition = 0
                    turnCamSound.Volume = 0.8
                end
            end
        end)
    end

    refreshMovementSounds = function()
        if not soundParent then return end
        local wasWalkPlaying = snd_insoni_walk_used_for_both_versions_anim and snd_insoni_walk_used_for_both_versions_anim.IsPlaying
        local wasJumpPlaying = snd_insoni_jump_used_for_both_versions_anim and snd_insoni_jump_used_for_both_versions_anim.IsPlaying
        local wasSprintPlaying = snd_insoni_run_used_for_both_versions_anim and snd_insoni_run_used_for_both_versions_anim.IsPlaying
        for _, sound in ipairs({snd_insoni_walk_used_for_both_versions_anim, snd_insoni_jump_used_for_both_versions_anim, snd_insoni_run_used_for_both_versions_anim}) do
            if sound then sound:Stop(); sound:Destroy() end
        end
        local mode = m.UseNewSounds and "new" or "old"
        local files = movementSoundFiles[mode]
        snd_insoni_walk_used_for_both_versions_anim = makeSound(files.walk, soundParent, 0.8, true)
        snd_insoni_jump_used_for_both_versions_anim = makeSound(files.jump, soundParent, 0.8, false)
        snd_insoni_jump_used_for_both_versions_anim.Looped = false
        snd_insoni_jump_used_for_both_versions_anim.PlaybackSpeed = 1
        snd_insoni_run_used_for_both_versions_anim = makeSound(files.sprint, soundParent, 0.8, true)
        if currentBase == "walk" or wasWalkPlaying then snd_insoni_walk_used_for_both_versions_anim:Play() end
        if currentBase == "jump" or wasJumpPlaying then snd_insoni_jump_used_for_both_versions_anim:Play() end
        if currentBase == "sprint" or wasSprintPlaying then snd_insoni_run_used_for_both_versions_anim:Play() end
    end

    local function loadAnim(fig, file, looped)
        local a = AnimLib.Animator.new()
        a.rig    = fig
        a.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
        a.looped = looped or false
        a.speed  = 1
        a.weight = 0
        return a
    end

    -- Play exactly one random voice clip whenever the local player sends a chat message.
    local function playRandomSpeakVoice()
        if #speakSounds == 0 then return end
        local index = math.random(1, #speakSounds)
        -- Avoid repeating the same clip twice in a row when possible.
        if #speakSounds > 1 and index == lastVoiceIndex then
            index = (index % #speakSounds) + 1
        end
        lastVoiceIndex = index
        for i, sound in ipairs(speakSounds) do
            if sound then
                sound:Stop()
                sound.TimePosition = 0
            end
        end
        local selected = speakSounds[index]
        if selected then selected:Play() end
    end

    local function setSpeed(speed)
        if not figureRef then return end
        local hum = figureRef:FindFirstChildOfClass("Humanoid")
        if hum then
            if cameraTripStunActive then
                hum.WalkSpeed = TRIP_WALK_SPEED
            else
                hum.WalkSpeed = speed
            end
        end
    end

    local function clearBase()
        for _, a in pairs(baseAnims) do a.weight = 0 end
    end

    local function setBase(state)
        if currentBase == state then return end
        currentBase = state
        clearBase()
        -- rage overrides locomotion anims
        if baseAnims[state] then baseAnims[state].weight = 1 end
        -- per-base audio
        if state == "walk" then
            if snd_insoni_walk_used_for_both_versions_anim and not snd_insoni_walk_used_for_both_versions_anim.IsPlaying then snd_insoni_walk_used_for_both_versions_anim:Play() end
        else
            if snd_insoni_walk_used_for_both_versions_anim then snd_insoni_walk_used_for_both_versions_anim:Stop() end
        end
        if state == "jump" then
            if snd_insoni_jump_used_for_both_versions_anim and not snd_insoni_jump_used_for_both_versions_anim.IsPlaying then
                snd_insoni_jump_used_for_both_versions_anim.TimePosition = 0
                snd_insoni_jump_used_for_both_versions_anim:Play()
            end
        end
        -- The jump sound is a one-shot: don't stop it when the jump animation
        -- transitions into the fall animation or when the character lands.
        if state == "sprint" then
            if snd_insoni_run_used_for_both_versions_anim and not snd_insoni_run_used_for_both_versions_anim.IsPlaying then snd_insoni_run_used_for_both_versions_anim:Play() end
        else
            if snd_insoni_run_used_for_both_versions_anim then snd_insoni_run_used_for_both_versions_anim:Stop() end
        end
    end

    local function stopAllAnimSounds()
        -- no per-action sounds
    end

    local function stopAction()
        for _, anim in pairs(actionAnims) do anim.weight = 0 end
        stopAllAnimSounds()
        currentAction = nil
        flingActive   = false
    end

    local function playAction(name)
        if currentAction == name then
            stopAction()
            currentBase = "none"
            return
        end
        if currentAction then stopAction() end
        local a = actionAnims[name]
        if not a then return end
        clearBase()
        if snd_insoni_walk_used_for_both_versions_anim then snd_insoni_walk_used_for_both_versions_anim:Stop() end
        -- Do not cut off the one-shot jump sound if an action is selected midair.
        if snd_insoni_run_used_for_both_versions_anim then snd_insoni_run_used_for_both_versions_anim:Stop() end
        a.weight       = 1
        actionStart[a] = os.clock()
        currentAction  = name
        flingActive    = m.FlingEnabled[name] == true
    end

    local function bindEmoteButtons()
        for _, def in ipairs(emoteDefinitions) do
            local emoteKey = def.key
            local emoteLabel = def.label
            local emoteX = def.x
            local emoteY = def.y
            local actionName = "InsoniEmote_" .. emoteKey
            if not emoteActionsBound[actionName] then
                ContextActions:BindAction(actionName, function(_, inputState)
                    if inputState == Enum.UserInputState.Begin then
                        playAction(emoteKey)
                    end
                end, true)
                ContextActions:SetTitle(actionName, emoteLabel)
                ContextActions:SetPosition(actionName, UDim2.new(1, emoteX, 1, emoteY))
                emoteActionsBound[actionName] = true
            end
        end
    end

    local function unbindEmoteButtons()
        for actionName in pairs(emoteActionsBound) do
            ContextActions:UnbindAction(actionName)
            emoteActionsBound[actionName] = nil
        end
    end

    local sprintActionBound = false

    local function toggleSprint()
        if not m.SprintExtra or cameraTripStunActive then return end
        isSprinting = not isSprinting
        if isSprinting then
            setSpeed(SPEED_SPRINT)
            ContextActions:SetTitle("GM_Sprint", "Walk")
        else
            setSpeed(SPEED_WALK)
            ContextActions:SetTitle("GM_Sprint", "Run")
        end
    end

    -- The Sprint Extra setting controls whether the sprint action/button exists.
    -- When enabled, ContextActionService shows its touch button on mobile and
    -- also binds LeftShift on keyboard. When disabled, both are unbound.
    refreshSprintButton = function()
        if m.SprintExtra then
            if not sprintActionBound then
                ContextActions:BindAction("GM_Sprint", function(_, inputState, _)
                    if inputState == Enum.UserInputState.Begin then toggleSprint() end
                end, true, Enum.KeyCode.LeftShift)
                sprintActionBound = true
            end
            ContextActions:SetTitle("GM_Sprint", isSprinting and "Walk" or "Run")
            ContextActions:SetPosition("GM_Sprint", UDim2.new(1, -80, 1, -130))
        else
            if disableSprint then disableSprint() end
            if sprintActionBound then
                ContextActions:UnbindAction("GM_Sprint")
                sprintActionBound = false
            end
        end
    end

    disableSprint = function()
        if isSprinting then
            isSprinting = false
            setSpeed(SPEED_WALK)
            ContextActions:SetTitle("GM_Sprint", "Run")
            if snd_insoni_run_used_for_both_versions_anim then
                snd_insoni_run_used_for_both_versions_anim:Stop()
            end
            local hum = figureRef and figureRef:FindFirstChildOfClass("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0.1 then
                setBase("walk")
            else
                setBase("idle")
            end
        end
    end

    local function setupFlingTouched(figure)
        local function hookPart(part)
            local conn = part.Touched:Connect(function(hit)
                if not flingActive then return end
                if not hit or not hit.Parent then return end
                local target = hit.Parent
                if target:IsA("Accessory") then target = target.Parent end
                if target == figure then return end
                if not target:FindFirstChildOfClass("Humanoid") then return end
                ReanimateFling(target)
            end)
            table.insert(touchConns, conn)
        end
        for _, part in ipairs(figure:GetDescendants()) do
            if part:IsA("BasePart") then hookPart(part) end
        end
        table.insert(touchConns, figure.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") then hookPart(part) end
        end))
    end

    -- INIT
    m.Init = function(figure)
        figureRef = figure
        local hrp = figure:FindFirstChild("HumanoidRootPart") or figure
        local hum = figure:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = DEFAULT_JUMP_POWER
            hum.WalkSpeed = SPEED_WALK
        end

        allJoints = {}
        for _, v in ipairs(figure:GetDescendants()) do
            if v:IsA("Motor6D") then table.insert(allJoints, v) end
        end

        baseAnims = {
        idle = loadAnim(figure, "insoni idle normal used for both versions.anim", true),
        walk = loadAnim(figure, "insoni walk used for both versions.anim", true),
        jump = loadAnim(figure, "insoni jump used for both versions.anim", false),
        fall = loadAnim(figure, "insoni fall used for both versions.anim", true),
        sprint = loadAnim(figure, "insoni run used for both versions.anim", true),
        }
        animJump = baseAnims.jump
        animFall = baseAnims.fall
        actionAnims = {}
        for _, def in ipairs(emoteDefinitions) do
            actionAnims[def.key] = loadAnim(figure, def.file, def.looped)
        end
        -- Sit Buggy is deliberately not a button; it plays only when the
        -- Humanoid actually enters a seated state.
        actionAnims.SitBuggy = loadAnim(figure, "insoni sit buggy used for both versions.anim", true)
        actionAnims.RandomLaugh = loadAnim(figure, "idle random laugh.anim", false)
        nextRandomLaughAt = os.clock() + math.random(RANDOM_LAUGH_MIN_DELAY, RANDOM_LAUGH_MAX_DELAY)

        -- Initialize movement sounds from the selected audio set.
        soundParent = hrp
        refreshMovementSounds()

        -- One-shot character event sounds. TRIP Fall is used when a real trip occurs.
        deathSound = makeSound("player death.mp3", hrp, 0.8, false)
        tripSound = makeSound("TRIP Fall.mp3", hrp, 0.8, false)
        turnCamSound = makeSound("player movement turn cam.mp3", hrp, 0.8, true)
        turnCamSound.Looped = true
        CAMERA_TURN_SOUND_ACTIVE = false
        tripSoundPlayedForCurrentFall = false
        cameraTripStunActive = false
        cameraTripGeneration += 1
        lastTripAt = 0
        lastTurnCamAt = 0
        lastCameraCFrame = nil
        nextJumpAllowedAt = 0

        if deathConn then deathConn:Disconnect() end
        deathConn = hum and hum.Died:Connect(function()
            if deathSound and deathSound.Parent then
                deathSound:Stop()
                deathSound.TimePosition = 0
                deathSound:Play()
            end
        end) or nil

        if stateConn then stateConn:Disconnect() end
        stateConn = hum and hum.StateChanged:Connect(function(_, newState)
            -- Ordinary falls, landings, and ragdoll state changes do not cause a trip.
            -- MotionTrip is triggered only by a sustained, extreme camera turn.
            if newState == Enum.HumanoidStateType.Running or newState == Enum.HumanoidStateType.Landed then
                tripSoundPlayedForCurrentFall = false
            end
        end) or nil
        -- Enforce the one-second jump cooldown in the moveset itself. Rejected
        -- jump requests are cleared before they can trigger the jump animation.
        if jumpConn then jumpConn:Disconnect() end
        jumpConn = hum and hum:GetPropertyChangedSignal("Jump"):Connect(function()
            if not hum or not hum.Parent or not hum.Jump then return end
            local now = os.clock()
            if now < nextJumpAllowedAt then
                hum.Jump = false
            else
                nextJumpAllowedAt = now + JUMP_COOLDOWN_SECONDS
            end
        end) or nil
        setupCameraTurnSound(figure)

        -- Custom voice clips: only one of 1, 2, or 3 plays per chat message.
        speakSounds = {
            makeSound("player speak 1.mp3", hrp, 0.8, false),
            makeSound("player speak 2.mp3", hrp, 0.8, false),
            makeSound("player speak 3.mp3", hrp, 0.8, false),
        }
        speakConn = nil
        local connectedToNewChat = false
        pcall(function()
            if TextChatService and TextChatService.SendingMessage then
                speakConn = TextChatService.SendingMessage:Connect(function(message)
                    if message and message.Text and message.Text ~= "" then
                        playRandomSpeakVoice()
                    end
                end)
                connectedToNewChat = speakConn ~= nil
            end
        end)
        -- Fallback for experiences using the legacy chat system.
        if not connectedToNewChat then
            speakConn = Player.Chatted:Connect(function(message)
                if message and message ~= "" then playRandomSpeakVoice() end
            end)
        end

        setSpeed(SPEED_WALK)
        setBase("idle")
        setupFlingTouched(figure)

        refreshSprintButton()
        bindEmoteButtons()

    end

    -- UPDATE
    m.Update = function(dt, figure)
        local hum = figure:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local inAir = hum.FloorMaterial == Enum.Material.Air
        if cameraTripStunActive then
            hum.UseJumpPower = true
            hum.WalkSpeed = TRIP_WALK_SPEED
            hum.JumpPower = TRIP_JUMP_POWER
        end

        -- Actual seating uses the special Sit Buggy animation, without a button.
        local actuallySeated = hum.Sit or hum:GetState() == Enum.HumanoidStateType.Seated
        if actuallySeated then
            if currentAction ~= "SitBuggy" then
                if currentAction then stopAction() end
                playAction("SitBuggy")
            end
        elseif currentAction == "SitBuggy" then
            stopAction()
            currentBase = "none"
        end

        -- Movement cancels a manually selected emote so locomotion can resume.
        -- The seated Sit Buggy animation remains active only while actually seated.
        if currentAction and currentAction ~= "SitBuggy"
            and (hum.MoveDirection.Magnitude > 0.1 or hum.FloorMaterial == Enum.Material.Air) then
            stopAction()
            currentBase = "none"
        end

        -- auto-stop finished actions
        if currentAction then
            local a = actionAnims[currentAction]
            if a and actionStart[a] then
                local elapsed  = os.clock() - actionStart[a]
                local duration = a.track and a.track.Time or 0
                if not a.looped and duration > 0 and elapsed >= duration / (a.speed or 1) then
                    a.weight      = 0
                    stopAllAnimSounds()
                    currentAction = nil
                    flingActive   = false
                    currentBase   = "none"
                end
            end
        end

        -- Trigger the random laugh occasionally while standing still. It has no button
        -- and never interrupts movement, jumping, or a manually selected emote.
        if not currentAction and not inAir
            and hum.MoveDirection.Magnitude <= 0.1
            and os.clock() >= nextRandomLaughAt then
            playAction("RandomLaugh")
            nextRandomLaughAt = os.clock() + math.random(RANDOM_LAUGH_MIN_DELAY, RANDOM_LAUGH_MAX_DELAY)
        end

        -- locomotion state machine
        if not currentAction then
            if inAir then
                if not wasInAir then
                    clearBase()
                    currentBase           = "jump"
                    animJump.weight       = 1
                    actionStart[animJump] = os.clock()
                    if snd_insoni_walk_used_for_both_versions_anim then snd_insoni_walk_used_for_both_versions_anim:Stop() end
                    if snd_insoni_run_used_for_both_versions_anim then snd_insoni_run_used_for_both_versions_anim:Stop() end
                    if snd_insoni_jump_used_for_both_versions_anim then
                        -- Start the entire jump sound once. It is deliberately not stopped
                        -- when the jump animation transitions to fall or when the player lands.
                        snd_insoni_jump_used_for_both_versions_anim:Stop()
                        snd_insoni_jump_used_for_both_versions_anim.TimePosition = 0
                        snd_insoni_jump_used_for_both_versions_anim.Looped = false
                        snd_insoni_jump_used_for_both_versions_anim.PlaybackSpeed = 1
                        snd_insoni_jump_used_for_both_versions_anim:Play()
                    end
                end
                -- Play the fall animation once the jump starts descending.
                local root = figure:FindFirstChild("HumanoidRootPart")
                if root and root.AssemblyLinearVelocity.Y <= 0 and currentBase ~= "fall" then
                    setBase("fall")
                end
            else
                if wasInAir then
                    if animJump then animJump.weight = 0 end
                    if animFall then animFall.weight = 0 end
                    -- Let the jump sound finish naturally after landing.
                end
                local moving = hum.MoveDirection.Magnitude > 0.1
                if moving then
                    if isSprinting then setBase("sprint") else setBase("walk") end
                else
                    setBase("idle")
                end
            end
        end

        wasInAir = inAir
        local now = os.clock()
        for _, a in pairs(baseAnims) do if a.weight > 0 then a:Step(now) end end
        for a, start in pairs(actionStart) do if a.weight > 0 then a:Step(now - start) end end
    end

    -- DESTROY
    m.Destroy = function(figure)
        ContextActions:UnbindAction("GM_Sprint")
        sprintActionBound = false
        unbindEmoteButtons()

        for _, conn in ipairs(touchConns) do conn:Disconnect() end
        table.clear(touchConns)

        stopAllAnimSounds()
        if speakConn then speakConn:Disconnect() speakConn = nil end
        for _, sound in ipairs(speakSounds) do
            if sound then sound:Stop() sound:Destroy() end
        end
        table.clear(speakSounds)
        lastVoiceIndex = nil
        if deathConn then deathConn:Disconnect(); deathConn = nil end
        if stateConn then stateConn:Disconnect(); stateConn = nil end
        if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
        if cameraConn then cameraConn:Disconnect(); cameraConn = nil end
        if motionTripConn then motionTripConn:Disconnect(); motionTripConn = nil end
        motionTripReady = true
        if cameraBlur then
            if createdCameraBlur then
                cameraBlur:Destroy()
            elseif cameraBlur.Parent then
                cameraBlur.Size = 0
            end
        end
        cameraBlur = nil
        createdCameraBlur = false
        if tripTween then pcall(function() tripTween:Cancel() end) end
        if turnCamTween then pcall(function() turnCamTween:Cancel() end) end
        tripTween = nil
        turnCamTween = nil
        if deathSound then deathSound:Stop(); deathSound:Destroy() end
        if tripSound then tripSound:Stop(); tripSound:Destroy() end
        if turnCamSound then turnCamSound:Stop(); turnCamSound:Destroy() end
        CAMERA_TURN_SOUND_ACTIVE = false
        deathSound = nil
        tripSound = nil
        turnCamSound = nil
        lastCameraCFrame = nil
    if snd_insoni_walk_used_for_both_versions_anim then snd_insoni_walk_used_for_both_versions_anim:Stop() snd_insoni_walk_used_for_both_versions_anim:Destroy() snd_insoni_walk_used_for_both_versions_anim = nil end
    if snd_insoni_jump_used_for_both_versions_anim then snd_insoni_jump_used_for_both_versions_anim:Stop() snd_insoni_jump_used_for_both_versions_anim:Destroy() snd_insoni_jump_used_for_both_versions_anim = nil end
    if snd_insoni_run_used_for_both_versions_anim then snd_insoni_run_used_for_both_versions_anim:Stop() snd_insoni_run_used_for_both_versions_anim:Destroy() snd_insoni_run_used_for_both_versions_anim = nil end
        soundParent = nil

        for _, joint in ipairs(allJoints) do
            if joint and joint.Parent then joint.Transform = CFrame.identity end
        end
        allJoints = {}

        for _, a in pairs(baseAnims)   do a.weight = 0 end
        for _, a in pairs(actionAnims) do a.weight = 0 end

        setSpeed(16)
        actionStart   = {}
        currentAction = nil
        currentBase   = "idle"
        wasInAir      = false
        flingActive   = false
        figureRef     = nil
        animJump      = nil
        animFall      = nil
        baseAnims     = {}
        actionAnims   = {}
        isSprinting = false
        nextRandomLaughAt = 0
        tripSoundPlayedForCurrentFall = false
        cameraTripStunActive = false
        cameraTripGeneration += 1
        lastTripAt = 0
        lastTurnCamAt = 0
        nextJumpAllowedAt = 0
    end

    return m
end)

return modules