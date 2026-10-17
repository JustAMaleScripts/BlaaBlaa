cloneref = cloneref or function(o) return o end

local Debris = cloneref(game:GetService("Debris"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))

local Player = Players.LocalPlayer

local modules = {}

local function AddModule(m)
    table.insert(modules, m)
end

AddModule(function()
    local m = {}

    m.ModuleType = "MOVESET"
    m.Name = "Witch"
    m.Description = "I think i hear my ex-wife"
    m.InternalName = "Witch"

    m.Assets = {
        "Walk.anim",
        "Idle.anim",
        "CrouchCry.anim",
        "Angry.anim",
        "AngryIdle.anim",
        "Run.anim",
        "Swing.anim",
        "SwingTwo.anim",
        "WTheme.mp3",
        "AngryTheme.mp3",
        "AngryScream.mp3",
        "Crying.mp3",
        "Cry.mp3",
        "CryTwo.mp3",
        "WanderSound.mp3",
	"L4DWitch.rbxmx",
    }

    m.FlingEnabled = {}

    m.Config = function(parent)
        Util_CreateText(parent, "Witch", 18, Enum.TextXAlignment.Center)
        Util_CreateSeparator(parent)
    end

    m.SaveConfig = function()
        return {}
    end

    m.LoadConfig = function(save)
    end

    local figureRef = nil

    local walkAnim = nil
    local idleAnim = nil
    local crouchAnim = nil
    local angryAnim = nil
    local angryIdleAnim = nil
    local runAnim = nil
    local swingAnim = nil
    local swingTwoAnim = nil

    local animationStarts = {}

    local leftClaw = nil
    local rightClaw = nil
    local clawAsset = nil

    local crouchKey = nil
    local swingKey = nil

    local crouchAction = "GM_Witch_Crouch"
    local swingAction = "GM_Witch_Swing"

    local crouching = false
    local angry = false
    local enraged = false
    local swinging = false

    local nearbyPlayer = nil
    local angryStartTime = nil
    local rageStartTime = nil

    local currentCry = nil
    local wTheme = nil
    local angryTheme = nil
    local angryScreams = {}

    local walkingSince = nil
    local wanderingPlayed = false
    local lastMoving = false
    local nextCryTime = 0

    local startledHighlight = nil
    local alertToken = 0

    local cleanupObjects = {}
    local cleanupConnections = {}

    local function addObject(obj)
        if obj then
            table.insert(cleanupObjects, obj)
        end
        return obj
    end

    local function addConnection(conn)
        if conn then
            table.insert(cleanupConnections, conn)
        end
        return conn
    end

    local function cleanup()
        for _, conn in ipairs(cleanupConnections) do
            pcall(function()
                conn:Disconnect()
            end)
        end

        table.clear(cleanupConnections)

        for _, obj in ipairs(cleanupObjects) do
            pcall(function()
                obj:Destroy()
            end)
        end

        table.clear(cleanupObjects)
    end

    local function soundPath(file)
        return getcustomasset(AssetGetPathFromFilename(file))
    end

    local function loadAnim(fig, file, looped)
        local a = AnimLib.Animator.new()
        a.rig = fig
        a.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(file))
        a.looped = looped or false
        a.speed = 1
        a.weight = 0
        return a
    end

    local function getRandomKey()
        local keys = {
            Enum.KeyCode.A,
            Enum.KeyCode.B,
            Enum.KeyCode.C,
            Enum.KeyCode.D,
            Enum.KeyCode.E,
            Enum.KeyCode.F,
            Enum.KeyCode.G,
            Enum.KeyCode.H,
            Enum.KeyCode.I,
            Enum.KeyCode.J,
            Enum.KeyCode.K,
            Enum.KeyCode.L,
            Enum.KeyCode.M,
            Enum.KeyCode.N,
            Enum.KeyCode.O,
            Enum.KeyCode.P,
            Enum.KeyCode.Q,
            Enum.KeyCode.R,
            Enum.KeyCode.S,
            Enum.KeyCode.T,
            Enum.KeyCode.U,
            Enum.KeyCode.V,
            Enum.KeyCode.W,
            Enum.KeyCode.X,
            Enum.KeyCode.Y,
            Enum.KeyCode.Z,
        }

        return keys[math.random(1, #keys)]
    end

    local function playAnim(anim, name, speed, looped, weight)
        if not anim then
            return
        end

        if anim.weight > 0 then
            anim.speed = speed or 1
            anim.looped = looped == true
            return
        end

        local animations = {
            walkAnim,
            idleAnim,
            crouchAnim,
            angryAnim,
            angryIdleAnim,
            runAnim,
            swingAnim,
            swingTwoAnim,
        }

        for _, other in ipairs(animations) do
            if other and other ~= anim then
                other.weight = 0
            end
        end

        anim.weight = weight or 0.7
        anim.speed = speed or 1
        anim.looped = looped == true
        animationStarts[name] = os.clock()

        pcall(function()
            anim:Step(0)
        end)
    end

    local function stopAnimations()
        local animations = {
            walkAnim,
            idleAnim,
            crouchAnim,
            angryAnim,
            angryIdleAnim,
            runAnim,
            swingAnim,
            swingTwoAnim,
        }

        for _, anim in ipairs(animations) do
            if anim then
                anim.weight = 0
            end
        end
    end

    local function stepAnimation(anim, name)
        if not anim or anim.weight <= 0 then
            return
        end

        local started = animationStarts[name] or os.clock()
        local elapsed = os.clock() - started

        pcall(function()
            anim:Step(elapsed)
        end)
    end

    local function removeStartledHighlight()
        if startledHighlight then
            pcall(function()
                startledHighlight:Destroy()
            end)
            startledHighlight = nil
        end
    end

    local function hideStartledAlert()
        alertToken += 1
    end

    local function showStartledAlert(targetPlayer)
        alertToken += 1
        local thisAlert = alertToken

        local playerGui = Player:FindFirstChildOfClass("PlayerGui")
        if not playerGui or not targetPlayer then
            return
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "WitchStartledAlert"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
        addObject(screenGui)

        local alertFrame = Instance.new("Frame")
        alertFrame.Size = UDim2.new(0, 430, 0, 55)
        alertFrame.Position = UDim2.new(0.5, -215, 0.67, 0)
        alertFrame.BackgroundTransparency = 1
        alertFrame.Parent = screenGui

        local warningIcon = Instance.new("ImageLabel")
        warningIcon.Size = UDim2.new(0, 38, 0, 38)
        warningIcon.Position = UDim2.new(0, 0, 0.5, -19)
        warningIcon.BackgroundTransparency = 1
        warningIcon.Image = "rbxassetid://130209261465194"
        warningIcon.Parent = alertFrame

        local alertText = Instance.new("TextLabel")
        alertText.Size = UDim2.new(1, -50, 1, 0)
        alertText.Position = UDim2.new(0, 50, 0, 0)
        alertText.BackgroundTransparency = 1
        alertText.TextColor3 = Color3.new(1, 1, 1)
        alertText.TextStrokeTransparency = 0.65
        alertText.TextSize = 22
        alertText.Font = Enum.Font.GothamBold
        alertText.TextXAlignment = Enum.TextXAlignment.Left
        alertText.TextYAlignment = Enum.TextYAlignment.Center
        alertText.Text = targetPlayer.Name .. " has startled the Witch!"
        alertText.Parent = alertFrame

        task.spawn(function()
            TweenService:Create(
                warningIcon,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {ImageTransparency = 0}
            ):Play()

            task.wait(0.2)

            if thisAlert ~= alertToken then
                return
            end

            TweenService:Create(
                warningIcon,
                TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0, 8, 0.5, -19)}
            ):Play()

            task.wait(0.2)

            if thisAlert ~= alertToken then
                return
            end

            alertText.TextTransparency = 0

            task.wait(3.5)

            if thisAlert == alertToken and screenGui.Parent then
                screenGui:Destroy()
            end
        end)
    end

    local function getClosestPlayer()
        local character = figureRef or Player.Character
        if not character then
            return nil
        end

        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            return nil
        end

        local closestPlayer = nil
        local closestDistance = 40

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= Player then
                local otherCharacter = otherPlayer.Character

                if otherCharacter then
                    local otherRoot = otherCharacter:FindFirstChild("HumanoidRootPart")
                    local otherHumanoid = otherCharacter:FindFirstChildOfClass("Humanoid")

                    if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
                        local distance = (rootPart.Position - otherRoot.Position).Magnitude

                        if distance <= closestDistance then
                            closestDistance = distance
                            closestPlayer = otherPlayer
                        end
                    end
                end
            end
        end

        return closestPlayer
    end

    local function smoothlyFacePlayer(targetPlayer, deltaTime)
        local character = figureRef or Player.Character
        if not character or not targetPlayer then
            return
        end

        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local targetCharacter = targetPlayer.Character

        if not rootPart or not targetCharacter then
            return
        end

        local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            return
        end

        local position = rootPart.Position
        local targetPosition = Vector3.new(
            targetRoot.Position.X,
            position.Y,
            targetRoot.Position.Z
        )

        local direction = targetPosition - position

        if direction.Magnitude <= 0.01 then
            return
        end

        local targetCFrame = CFrame.lookAt(
            position,
            position + direction.Unit
        )

        rootPart.CFrame = rootPart.CFrame:Lerp(
            targetCFrame,
            math.clamp(deltaTime * 1.5, 0, 1)
        )
    end

    local function createSound(name, volume, looped)
        local sound = Instance.new("Sound")
        sound.Name = name
        sound.SoundId = soundPath(name)
        sound.Volume = volume or 1
        sound.Looped = looped == true
        sound.Parent = workspace
        addObject(sound)
        return sound
    end

    local function createRobloxSound(soundId, volume, looped)
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = volume or 1
        sound.Looped = looped == true
        sound.Parent = workspace
        addObject(sound)
        return sound
    end

    local function stopAngryScreams()
        for _, sound in ipairs(angryScreams) do
            if sound and sound.Parent then
                pcall(function()
                    sound:Stop()
                    sound:Destroy()
                end)
            end
        end

        table.clear(angryScreams)
    end

    local function ensureTheme()
        if wTheme and wTheme.Parent then
            return
        end

        wTheme = createSound("WTheme.mp3", 0.7, true)
    end

    local function stopAngryTheme()
        if angryTheme then
            pcall(function()
                angryTheme:Stop()
                angryTheme:Destroy()
            end)
            angryTheme = nil
        end
    end

    local function returnToCrouch()
        local character = figureRef or Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        stopAngryScreams()
        stopAngryTheme()

        angry = false
        enraged = false
        swinging = false
        nearbyPlayer = nil
        angryStartTime = nil
        rageStartTime = nil

        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        end

        removeStartledHighlight()
        hideStartledAlert()

        playAnim(crouchAnim, "Crouch", 1, true,0.3)
        ensureTheme()

        if wTheme and not wTheme.IsPlaying then
            wTheme:Play()
        end
    end

    local function endRage()
        local character = figureRef or Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        stopAngryScreams()
        stopAngryTheme()

        angry = false
        enraged = false
        swinging = false
        crouching = false
        nearbyPlayer = nil
        angryStartTime = nil
        rageStartTime = nil

        if humanoid then
            humanoid.WalkSpeed = 7
            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        end

        removeStartledHighlight()
        hideStartledAlert()

        playAnim(idleAnim, "Idle", 1, true,0.3)
        ensureTheme()

        if wTheme and not wTheme.IsPlaying then
            wTheme:Play()
        end
    end

    local function startEnraged()
        if enraged then
            return
        end

        local character = figureRef or Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if not humanoid then
            return
        end

        stopAngryScreams()

        enraged = true
        angry = true
        rageStartTime = tick()

        humanoid.WalkSpeed = 23
        humanoid.JumpPower = 0
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

        if wTheme then
            wTheme:Stop()
        end

        removeStartledHighlight()

        if nearbyPlayer and nearbyPlayer.Character then
            startledHighlight = Instance.new("Highlight")
            startledHighlight.Name = "WitchStartledPlayer"
            startledHighlight.Adornee = nearbyPlayer.Character
            startledHighlight.FillTransparency = 0.5
            startledHighlight.OutlineTransparency = 0
            startledHighlight.Parent = nearbyPlayer.Character
            addObject(startledHighlight)

            task.spawn(function()
                showStartledAlert(nearbyPlayer)
            end)
        end

        angryTheme = createSound("AngryTheme.mp3", 1, true)
        angryTheme:Play()

        playAnim(angryIdleAnim, "AngryIdle", 1, true,0.3)
    end

    local function startAngry(targetPlayer)
        if angry or enraged then
            return
        end

        local character = figureRef or Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if not humanoid then
            return
        end

        angry = true
        nearbyPlayer = targetPlayer
        angryStartTime = tick()

        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

        stopAnimations()
        playAnim(angryAnim, "Angry", 1, false,0.3)

        stopAngryScreams()

        task.spawn(function()
            for i = 1, 3 do
                if not angry or enraged or not nearbyPlayer then
                    return
                end

                local scream = createSound("AngryScream.mp3", 1, false)
                table.insert(angryScreams, scream)
                scream:Play()

                task.wait(2.7)
            end
        end)
    end

    local function setCrouch(state)
        if angry or enraged then
            return
        end

        local character = figureRef or Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if not humanoid then
            return
        end

        crouching = state

        if crouching then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

            playAnim(crouchAnim, "Crouch", 1, true,0.3)

            ensureTheme()
            if not wTheme.IsPlaying then
                wTheme:Play()
            end
        else
            humanoid.WalkSpeed = 7
            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

            playAnim(idleAnim, "Idle", 1, true,0.3)

            ensureTheme()
            if not wTheme.IsPlaying then
                wTheme:Play()
            end
        end
    end

    local function swing()
        if not enraged or swinging then
            return
        end

        local character = figureRef or Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not rootPart then
            return
        end

        swinging = true
        humanoid.WalkSpeed = 5

        local chosenAnimation
        local chosenName

        if math.random(1, 2) == 1 then
            chosenAnimation = swingAnim
            chosenName = "Swing"
        else
            chosenAnimation = swingTwoAnim
            chosenName = "SwingTwo"
        end

        local hit = false
        local hitTarget = nil

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= Player then
                local otherCharacter = otherPlayer.Character

                if otherCharacter then
                    local otherRoot = otherCharacter:FindFirstChild("HumanoidRootPart")
                    local otherHumanoid = otherCharacter:FindFirstChildOfClass("Humanoid")

                    if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
                        local offset = otherRoot.Position - rootPart.Position
                        local distance = offset.Magnitude

                        if distance <= 8 and distance > 0 then
                            local direction = offset.Unit
                            local facing = rootPart.CFrame.LookVector
                            local dot = facing:Dot(direction)

                            if dot > 0 then
                                hit = true
                                hitTarget = otherCharacter
                                break
                            end
                        end
                    end
                end
            end
        end

        local swingSound

        if hit then
            swingSound = createRobloxSound("rbxassetid://125713486368273", 1, false)

            if hitTarget then
                ReanimateFling(hitTarget)
                spawn(function()
                    task.wait(1)
                    if hitTarget:FindFirstChild("HumanoidRootPart") then
                        local puppygirlembarrasinglypissingonyourlegtomarkyouasherterritory = hitTarget.HumanoidRootPart.Position - rootPart.Position
                        if puppygirlembarrasinglypissingonyourlegtomarkyouasherterritory.Magnitude > 5000 then
                            enraged = false
                            angry = false
                        end
                    end
                end)
            end
        else
            swingSound = createRobloxSound("rbxassetid://97058775859375", 1, false)
        end

        swingSound:Play()

        playAnim(chosenAnimation, chosenName, 1, false,0.35)

        task.wait(0.5)

        if enraged then
            humanoid.WalkSpeed = 23
        end

        swinging = false

        if enraged then
            if humanoid.MoveDirection.Magnitude > 0 then
                playAnim(runAnim, "Run", 1, true,0.3)
            else
                playAnim(angryIdleAnim, "AngryIdle", 1, true,0.3)
            end
        end
    end

    local function playAmbientCry()
        if currentCry or angry or enraged then
            return
        end

        local character = figureRef or Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if not humanoid or humanoid.MoveDirection.Magnitude > 0 then
            return
        end

        local cries = {
            "Crying.mp3",
            "Cry.mp3",
            "CryTwo.mp3",
        }

        currentCry = createSound(cries[math.random(1, #cries)], 1, false)
        currentCry:Play()

        local thisCry = currentCry
        thisCry.Ended:Connect(function()
            if currentCry == thisCry then
                currentCry = nil
                nextCryTime = os.clock() + 2
            end
        end)
    end

    local function setupClaws(character)
        local ok, objects = pcall(function()
            return game:GetObjects(getcustomasset(AssetGetPathFromFilename("L4DWitch.rbxmx")))
        end)

        if not ok or not objects or not objects[1] then
            warn("[Witch] Failed to load L4DWitch.rbxmx")
            return
        end

        clawAsset = objects[1]
        addObject(clawAsset)

        local leftArm = character:FindFirstChild("Left Arm")
        local rightArm = character:FindFirstChild("Right Arm")

        if not leftArm or not rightArm then
            leftArm = character:FindFirstChild("LeftHand") or character:FindFirstChild("LeftLowerArm")
            rightArm = character:FindFirstChild("RightHand") or character:FindFirstChild("RightLowerArm")
        end

        if not leftArm or not rightArm then
            return
        end

        leftClaw = clawAsset:FindFirstChild("LeftClaw", true)
        rightClaw = clawAsset:FindFirstChild("RightClaw", true)

        if not leftClaw or not rightClaw then
            return
        end

        leftClaw.Anchored = false
        rightClaw.Anchored = false

        leftClaw.Parent = leftArm
        rightClaw.Parent = rightArm

        local leftWeld = leftClaw:FindFirstChild("LeftClaw", true)
        local rightWeld = rightClaw:FindFirstChild("RightClaw", true)

        if leftWeld then
            leftWeld.Part0 = leftArm
            leftWeld.Part1 = leftClaw
        end

        if rightWeld then
            rightWeld.Part0 = rightArm
            rightWeld.Part1 = rightClaw
        end
    end

    m.Init = function(figure)
        figureRef = figure
        math.randomseed(os.clock() * 100000)

        walkAnim = loadAnim(figure, "Walk.anim", true)
        idleAnim = loadAnim(figure, "Idle.anim", true)
        crouchAnim = loadAnim(figure, "CrouchCry.anim", true)
        angryAnim = loadAnim(figure, "Angry.anim", false)
        angryIdleAnim = loadAnim(figure, "AngryIdle.anim", true)
        runAnim = loadAnim(figure, "Run.anim", true)
        swingAnim = loadAnim(figure, "Swing.anim", false)
        swingTwoAnim = loadAnim(figure, "SwingTwo.anim", false)
        -- set up stuff
        setupClaws(figure)

        wTheme = createSound("WTheme.mp3", 0.7, true)

        crouchKey = Enum.KeyCode.C --getRandomKey()
        swingKey = Enum.KeyCode.E --getRandomKey()

        --[=[while swingKey == crouchKey do
            swingKey = getRandomKey()
        end]=]

        ContextActions:BindAction(
            crouchAction,
            function(_, inputState)
                if inputState == Enum.UserInputState.Begin then
                    setCrouch(not crouching)
                end
            end,
            true,
            crouchKey
        )

        ContextActions:SetTitle(crouchAction, "Crouch")
        ContextActions:SetPosition(crouchAction, UDim2.new(1, -120, 1, -110))

        ContextActions:BindAction(
            swingAction,
            function(_, inputState)
                if inputState == Enum.UserInputState.Begin then
                    task.spawn(swing)
                end
            end,
            true,
            swingKey
        )

        ContextActions:SetTitle(swingAction, "Swing")
        ContextActions:SetPosition(swingAction, UDim2.new(1, -240, 1, -110))

        local humanoid = figure:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = 7
            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        end

        nextCryTime = os.clock() + 2
        playAnim(idleAnim, "Idle", 1, true,0.3)
        wTheme:Play()
    end

    m.Update = function(dt, figure)
        local character = figureRef or figure or Player.Character
        if not character or not character.Parent then
            return
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not rootPart or humanoid.Health <= 0 then
            return
        end

        stepAnimation(walkAnim, "Walk")
        stepAnimation(idleAnim, "Idle")
        stepAnimation(crouchAnim, "Crouch")
        stepAnimation(angryAnim, "Angry")
        stepAnimation(angryIdleAnim, "AngryIdle")
        stepAnimation(runAnim, "Run")
        stepAnimation(swingAnim, "Swing")
        stepAnimation(swingTwoAnim, "SwingTwo")

        if wTheme and wTheme.IsPlaying and wTheme.TimePosition >= 14.5 then
            wTheme.TimePosition = 0
        end

        local moving = humanoid.MoveDirection.Magnitude > 0

        if not angry and not enraged then
            if moving then
                if not lastMoving then
                    walkingSince = tick()
                    wanderingPlayed = false
                end

                if walkingSince
                    and tick() - walkingSince >= 10
                    and not wanderingPlayed
                then
                    wanderingPlayed = true

                    local wanderingSound = createSound("WanderSound.mp3", 1, false)
                    wanderingSound:Play()
                end
            else
                walkingSince = nil
                wanderingPlayed = false
            end
        else
            walkingSince = nil
            wanderingPlayed = false
        end

        lastMoving = moving

        if not angry and not enraged and not moving and not currentCry then
            if os.clock() >= nextCryTime then
                playAmbientCry()
            end
        end

        if enraged then
            if rageStartTime and tick() - rageStartTime >= 30 then
                endRage()
                return
            end

            if not swinging then
                if moving then
                    playAnim(runAnim, "Run", 1, true,0.3)
                else
                    playAnim(angryIdleAnim, "AngryIdle", 1, true,0.3)
                end
            end

            if humanoid.WalkSpeed ~= 23 and not swinging then
                humanoid.WalkSpeed = 23
            end

            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

            return
        end

        if angry then
            if nearbyPlayer then
                local targetCharacter = nearbyPlayer.Character
                local targetRoot = targetCharacter
                    and targetCharacter:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = targetCharacter
                    and targetCharacter:FindFirstChildOfClass("Humanoid")

                if not targetRoot
                    or not targetHumanoid
                    or targetHumanoid.Health <= 0
                then
                    returnToCrouch()
                    return
                end

                local distance = (rootPart.Position - targetRoot.Position).Magnitude

                if distance > 40 then
                    returnToCrouch()
                    return
                end

                smoothlyFacePlayer(nearbyPlayer, dt)

                if angryStartTime
                    and tick() - angryStartTime >= 7
                then
                    startEnraged()
                end
            else
                returnToCrouch()
            end

            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

            return
        end

        if crouching then
            if humanoid.WalkSpeed ~= 0 then
                humanoid.WalkSpeed = 0
            end

            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

            if not swinging then
                playAnim(crouchAnim, "Crouch", 1, true,0.3)
            end

            local targetPlayer = getClosestPlayer()

            if targetPlayer then
                startAngry(targetPlayer)
            end
        else
            if humanoid.WalkSpeed ~= 7 then
                humanoid.WalkSpeed = 7
            end

            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

            if not swinging then
                if moving then
                    playAnim(walkAnim, "Walk", 1, true,0.3)
                else
                    playAnim(idleAnim, "Idle", 1, true,0.3)
                end
            end
        end
    end

    m.Destroy = function(figure)
        ContextActions:UnbindAction(crouchAction)
        ContextActions:UnbindAction(swingAction)

        crouching = false
        angry = false
        enraged = false
        swinging = false

        stopAngryScreams()
        stopAngryTheme()
        hideStartledAlert()
        removeStartledHighlight()

        if currentCry then
            pcall(function()
                currentCry:Stop()
                currentCry:Destroy()
            end)
            currentCry = nil
        end

        if wTheme then
            pcall(function()
                wTheme:Stop()
                wTheme:Destroy()
            end)
            wTheme = nil
        end

        stopAnimations()
        cleanup()

        if figure then
            for _, joint in ipairs(figure:GetDescendants()) do
                if joint:IsA("Motor6D") then
                    joint.Transform = CFrame.identity
                end
            end
        end

        leftClaw = nil
        rightClaw = nil
        clawAsset = nil

        walkAnim = nil
        idleAnim = nil
        crouchAnim = nil
        angryAnim = nil
        angryIdleAnim = nil
        runAnim = nil
        swingAnim = nil
        swingTwoAnim = nil

        figureRef = nil
        crouchKey = nil
        swingKey = nil
        nearbyPlayer = nil
        angryStartTime = nil
        rageStartTime = nil
        rageStartTime = nil
        walkingSince = nil
        wanderingPlayed = false
        lastMoving = false
        nextCryTime = 0
        table.clear(animationStarts)
    end

    return m
end)

return modules
