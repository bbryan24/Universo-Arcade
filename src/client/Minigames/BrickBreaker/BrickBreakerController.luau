--[[
    UNIVERSO ARCADE
    BrickBreakerController

    Controlador principal de la partida:
    - Movimiento de la pelota.
    - Colisiones con paredes, pala y ladrillos.
    - Puntuación.
    - Vidas.
    - Niveles.
    - Reinicio de partida.
    - Selección de controles.
    - Sistema de power-ups.
    - Herramientas DEV.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local BrickBreakerBoard = require(
    script.Parent:WaitForChild("BrickBreakerBoard")
)

local BrickBreakerInput = require(
    script.Parent:WaitForChild("BrickBreakerInput")
)

local BrickBreakerConfig = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("BrickBreakerConfig")
)

local BrickBreakerController = {}

--==================================================
-- ESTADO DE LA PARTIDA
--==================================================

local boardElements = nil
local gameConnection = nil
local inputStarted = false

local score = 0
local lives = 0
local level = 1

local gameStarted = false
local gameOver = false

-- CICLO DE VIDA E INTEGRACIÓN CON LA INTERFAZ

type BrickBreakerStats = {
    Score: number,
    Lives: number,
    Level: number,
}

type BrickBreakerCallbacks = {
    onStatsChanged: ((data: BrickBreakerStats) -> ())?,
    onLevelCompleted: ((completedLevel: number, nextLevel: number) -> ())?,
    onGameOver: ((data: BrickBreakerStats) -> ())?,
}

local callbacks: BrickBreakerCallbacks = {}
local isTransitioning = false
local pendingCompletedLevel = nil

-- Declaración anticipada para evitar crear una variable global.
local resetGame

local ballVelocity = Vector2.zero
local activeBalls = {}

local currentSpeed = BrickBreakerConfig.Ball.InitialSpeed
local activeMode = "Keyboard"

local scoreLabel = nil
local livesLabel = nil
local levelLabel = nil
local statusLabel = nil

-- ESTADÍSTICAS DE LA RECREATIVA

local machineScoreValue = nil
local machineLevelValue = nil
local machineBestValue = nil

-- CONTROLES

local keyboardButton = nil
local mouseButton = nil
local modeButtons = nil

-- INTERFAZ DEV

local developerInterface = nil
local developerPauseButton = nil

--==================================================
-- POWER-UPS
--==================================================

local fallingPowerUps = {}
local powerUpRandom = Random.new()

local basePaddleSize = nil

local paddleWideUntil = 0
local slowBallUntil = 0
local shieldUntil = 0
local fireballUntil = 0
local magnetUntil = 0

local extraLifeDroppedThisLevel = false

-- PAUSA

local isPaused = false
local pausedAt = 0

local statusMessageVersion = 0

--==================================================
-- TIPOS DE POWER-UPS
--==================================================

local POWER_UP_TYPES = {
    {
        Id = "WidePaddle",
        Label = "P",
        Color = Color3.fromRGB(45, 135, 235),
    },

    {
        Id = "SlowBall",
        Label = "↓",
        Color = Color3.fromRGB(145, 80, 220),
    },

    {
        Id = "ExtraLife",
        Label = "+",
        Color = Color3.fromRGB(220, 65, 95),
    },

    {
        Id = "ScoreBonus",
        Label = "★",
        Color = Color3.fromRGB(245, 190, 45),
    },

    {
        Id = "Shield",
        Label = "S",
        Color = Color3.fromRGB(45, 210, 230),
    },

    {
        Id = "Fireball",
        Label = "F",
        Color = Color3.fromRGB(245, 85, 35),
    },

    {
        Id = "MultiBall",
        Label = "3",
        Color = Color3.fromRGB(235, 110, 220),
    },

    {
        Id = "Magnet",
        Label = "M",
        Color = Color3.fromRGB(70, 235, 190),
    },
}

--==================================================
-- COLORES VISUALES DE LOS POWER-UPS
--==================================================

local VISUAL_COLORS = {
    WidePaddle = Color3.fromRGB(75, 175, 255),
    SlowBall = Color3.fromRGB(180, 105, 255),
    ExtraLife = Color3.fromRGB(255, 90, 120),
    ScoreBonus = Color3.fromRGB(255, 210, 70),
    Shield = Color3.fromRGB(115, 235, 255),
    Fireball = Color3.fromRGB(255, 115, 35),
    MultiBall = Color3.fromRGB(255, 125, 235),
    Magnet = Color3.fromRGB(70, 235, 190),
}

--==================================================
-- COLORES GENERALES
--==================================================

local ORANGE = Color3.fromRGB(255, 165, 55)
local WHITE = Color3.fromRGB(255, 245, 220)
local DARK = Color3.fromRGB(25, 17, 35)

--==================================================
-- FUNCIONES VISUALES GENERALES
--==================================================

local function removeVisual(parent, name)

    if not parent then
        return
    end

    local visual = parent:FindFirstChild(name)

    if visual then
        visual:Destroy()
    end

end

local function createGlow(parent, name, color, thickness)

    local existing = parent:FindFirstChild(name)

    if existing and existing:IsA("UIStroke") then

        existing.Color = color
        existing.Thickness = thickness

        return existing
    end

    local stroke = Instance.new("UIStroke")

    stroke.Name = name
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = 0.08
    stroke.Parent = parent

    return stroke
end

--==================================================
-- EFECTO VISUAL: BOLA DE FUEGO
--==================================================

local function createFireVisual(ball)

    if ball:FindFirstChild("FireVisual") then
        return
    end

    createGlow(
        ball,
        "FireGlow",
        Color3.fromRGB(255, 105, 25),
        2.5
    )

    local container = Instance.new("Frame")

    container.Name = "FireVisual"
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.fromScale(0.5, 0.5)
    container.Size = UDim2.fromScale(2.05, 2.05)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ZIndex = ball.ZIndex + 2
    container.Parent = ball

    local flameColors = {
        Color3.fromRGB(255, 65, 25),
        Color3.fromRGB(255, 125, 25),
        Color3.fromRGB(255, 195, 55),
        Color3.fromRGB(255, 95, 35),
    }

    local flamePositions = {
        UDim2.fromScale(0.18, 0.34),
        UDim2.fromScale(0.39, 0.12),
        UDim2.fromScale(0.62, 0.16),
        UDim2.fromScale(0.82, 0.36),
    }

    for index = 1, 4 do

        local flame = Instance.new("Frame")

        flame.Name = "Flame" .. index
        flame.AnchorPoint = Vector2.new(0.5, 0.5)
        flame.Position = flamePositions[index]
        flame.Size = UDim2.fromScale(0.24, 0.43)
        flame.BackgroundColor3 = flameColors[index]
        flame.BackgroundTransparency = 0.08
        flame.BorderSizePixel = 0
        flame.Rotation = (index - 2.5) * 17
        flame.ZIndex = container.ZIndex
        flame.Parent = container

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = flame

        local tween = TweenService:Create(
            flame,
            TweenInfo.new(
                0.22 + index * 0.035,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                -1,
                true
            ),
            {
                Size = UDim2.fromScale(0.17, 0.58),

                Position = UDim2.fromScale(
                    flamePositions[index].X.Scale,
                    flamePositions[index].Y.Scale - 0.09
                ),

                BackgroundTransparency = 0.28,
            }
        )

        tween:Play()

    end

end

--==================================================
-- EFECTO VISUAL: BOLA LENTA
--==================================================

local function createSlowVisual(ball)

    if ball:FindFirstChild("SlowVisual") then
        return
    end

    createGlow(
        ball,
        "SlowGlow",
        Color3.fromRGB(175, 105, 255),
        2
    )

    local ring = Instance.new("Frame")

    ring.Name = "SlowVisual"
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Position = UDim2.fromScale(0.5, 0.5)
    ring.Size = UDim2.fromScale(1.8, 1.8)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel = 0
    ring.ZIndex = ball.ZIndex + 1
    ring.Parent = ball

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ring

    local stroke = Instance.new("UIStroke")

    stroke.Color = Color3.fromRGB(190, 125, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    stroke.Parent = ring

    TweenService:Create(
        ring,
        TweenInfo.new(
            1.1,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1
        ),
        {
            Rotation = 360,
        }
    ):Play()

end

--==================================================
-- EFECTO VISUAL: MULTIBOLA
--==================================================

local function createMultiBallVisual(ball)

    createGlow(
        ball,
        "MultiBallGlow",
        Color3.fromRGB(255, 125, 235),
        2
    )

end

--==================================================
-- EFECTO VISUAL: PALA AMPLIADA
--==================================================

local function createWidePaddleVisual(paddle)

    if paddle:FindFirstChild("WidePaddleGlow") then
        return
    end

    local stroke = Instance.new("UIStroke")

    stroke.Name = "WidePaddleGlow"
    stroke.Color = VISUAL_COLORS.WidePaddle
    stroke.Thickness = 2.5
    stroke.Transparency = 0.05
    stroke.Parent = paddle

    TweenService:Create(
        stroke,
        TweenInfo.new(
            0.45,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ),
        {
            Transparency = 0.45,
            Thickness = 4,
        }
    ):Play()

end

--==================================================
-- ESCUDO DE ANCHO COMPLETO
--==================================================

local function updateShieldVisual()

    if not boardElements then
        return
    end

    local board = boardElements.Board
    local shield = board:FindFirstChild("ShieldBarrier")

    if shieldUntil <= os.clock() then

        removeVisual(board, "ShieldBarrier")

        return
    end

    if not shield then

        shield = Instance.new("Frame")

        shield.Name = "ShieldBarrier"
        shield.AnchorPoint = Vector2.new(0, 0)
        shield.BackgroundColor3 = Color3.fromRGB(105, 225, 255)
        shield.BackgroundTransparency = 0.58
        shield.BorderSizePixel = 0
        shield.ZIndex = 8
        shield.Parent = board

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = shield

        local stroke = Instance.new("UIStroke")

        stroke.Color = Color3.fromRGB(155, 245, 255)
        stroke.Thickness = 2
        stroke.Transparency = 0.05
        stroke.Parent = shield

        TweenService:Create(
            stroke,
            TweenInfo.new(
                0.5,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                -1,
                true
            ),
            {
                Transparency = 0.5,
                Thickness = 3.5,
            }
        ):Play()

    end

    local boardSize = board.AbsoluteSize

    local shieldHeight = 9
    local shieldMargin = 6

    shield.Position = UDim2.fromOffset(
        shieldMargin,
        boardSize.Y - 34
    )

    shield.Size = UDim2.fromOffset(
        math.max(0, boardSize.X - shieldMargin * 2),
        shieldHeight
    )

end

--==================================================
-- ACTUALIZAR TODOS LOS EFECTOS VISUALES
--==================================================

local function updatePowerUpVisuals()

    if not boardElements then
        return
    end

    local now = os.clock()
    local paddle = boardElements.Paddle

    if now < paddleWideUntil then

        createWidePaddleVisual(paddle)

    else

        removeVisual(paddle, "WidePaddleGlow")

    end

    updateShieldVisual()

    for _, ballData in ipairs(activeBalls) do

        local ball = ballData.Object

        if ball and ball.Parent then

            if now < fireballUntil then

                createFireVisual(ball)

            else

                removeVisual(ball, "FireVisual")
                removeVisual(ball, "FireGlow")

            end

            if now < slowBallUntil then

                createSlowVisual(ball)

            else

                removeVisual(ball, "SlowVisual")
                removeVisual(ball, "SlowGlow")

            end

            if ballData.IsMain then

                removeVisual(ball, "MultiBallGlow")

            else

                createMultiBallVisual(ball)

            end

            if now < magnetUntil then

                createGlow(
                    ball,
                    "MagnetGlow",
                    VISUAL_COLORS.Magnet,
                    2.5
                )

            else

                removeVisual(ball, "MagnetGlow")

            end

        end

    end

end

--==================================================
-- EFECTO AL RECOGER UN POWER-UP
--==================================================

local function showPowerUpPickupEffect(worldPosition, powerUpType)

    if not boardElements then
        return
    end

    local board = boardElements.Board

    local localPosition =
        worldPosition - board.AbsolutePosition

    local color =
        VISUAL_COLORS[powerUpType]
        or Color3.fromRGB(255, 255, 255)

    local messages = {
        WidePaddle = "PALA AMPLIADA",
        SlowBall = "BOLA LENTA",
        ExtraLife = "+1 VIDA",
        ScoreBonus = "+100 PUNTOS",
        Shield = "ESCUDO",
        Fireball = "BOLA DE FUEGO",
        MultiBall = "MULTIBOLA",
        Magnet = "IMÁN ACTIVADO",
    }

    local burst = Instance.new("Frame")

    burst.Name = "PowerUpPickupEffect"
    burst.AnchorPoint = Vector2.new(0.5, 0.5)
    burst.Position = UDim2.fromOffset(
        localPosition.X,
        localPosition.Y
    )
    burst.Size = UDim2.fromOffset(18, 18)
    burst.BackgroundTransparency = 1
    burst.BorderSizePixel = 0
    burst.ZIndex = 30
    burst.Parent = board

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = burst

    local stroke = Instance.new("UIStroke")

    stroke.Color = color
    stroke.Thickness = 3
    stroke.Transparency = 0.05
    stroke.Parent = burst

    local message = Instance.new("TextLabel")

    message.Name = "PickupMessage"
    message.AnchorPoint = Vector2.new(0.5, 1)
    message.Position = UDim2.fromScale(0.5, -0.2)
    message.Size = UDim2.fromOffset(150, 22)
    message.BackgroundTransparency = 1
    message.Text = messages[powerUpType] or "POWER-UP"
    message.TextColor3 = color
    message.TextStrokeTransparency = 0.35
    message.TextSize = 12
    message.Font = Enum.Font.GothamBlack
    message.ZIndex = 31
    message.Parent = burst

    TweenService:Create(
        burst,
        TweenInfo.new(
            0.38,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.fromOffset(48, 48),
            BackgroundTransparency = 1,
        }
    ):Play()

    TweenService:Create(
        stroke,
        TweenInfo.new(
            0.38,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Transparency = 1,
            Thickness = 1,
        }
    ):Play()

    TweenService:Create(
        message,
        TweenInfo.new(
            0.55,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Position = UDim2.fromScale(0.5, -1.15),
            TextTransparency = 1,
            TextStrokeTransparency = 1,
        }
    ):Play()

    task.delay(0.6, function()

        if burst and burst.Parent then
            burst:Destroy()
        end

    end)

end

--==================================================
-- PROGRESIÓN DE VELOCIDAD
--==================================================

local function getSpeedForLevel(targetLevel)

    local speed =
        BrickBreakerConfig.Ball.SpeedByLevel[targetLevel]

    if speed then
        return speed
    end

    return BrickBreakerConfig.Ball.MaximumSpeed

end

local function getEffectiveBallSpeed()

    local multiplier = 1

    if os.clock() < slowBallUntil then

        multiplier =
            BrickBreakerConfig.PowerUps.SlowBallMultiplier

    end

    return currentSpeed * multiplier

end

--==================================================
-- INTERFAZ: CREAR ETIQUETAS
--==================================================

local function createLabel(
    parent,
    name,
    text,
    position,
    size,
    textSize
)

    local label = Instance.new("TextLabel")

    label.Name = name
    label.Text = text
    label.Position = position
    label.Size = size

    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0

    label.TextColor3 = WHITE
    label.TextSize = textSize
    label.Font = Enum.Font.GothamBold

    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center

    label.ZIndex = 5
    label.Parent = parent

    return label

end

--==================================================
-- ACTUALIZAR HUD
--==================================================

local function updateHUD()

    if scoreLabel then
        scoreLabel.Text = "PUNTOS: " .. score
    end

    if livesLabel then
        livesLabel.Text = "VIDAS: " .. lives
    end

    if levelLabel then
        levelLabel.Text = "NIVEL: " .. level
    end

    if machineScoreValue then
        machineScoreValue.Text = tostring(score)
    end

    if machineLevelValue then
        machineLevelValue.Text = tostring(level)
    end

    if machineBestValue then
        machineBestValue.Text = "--"
    end

        if callbacks.onStatsChanged then
        callbacks.onStatsChanged({
            Score = score,
            Lives = lives,
            Level = level,
        })
    end

end

--==================================================
-- MENSAJES DE ESTADO
--==================================================

local function setStatus(message)

    statusMessageVersion += 1

    if statusLabel then
        statusLabel.Text = message
    end

end

local function showTimedStatus(message)

    statusMessageVersion += 1

    local currentVersion = statusMessageVersion

    if statusLabel then
        statusLabel.Text = message
    end

    task.delay(
        BrickBreakerConfig.PowerUps.MessageDuration,
        function()

            if currentVersion ~= statusMessageVersion then
                return
            end

            if statusLabel and statusLabel.Parent then
                statusLabel.Text = ""
            end

        end
    )

end

--==================================================
-- SELECCIÓN DE CONTROLES
--==================================================

local function updateControlButtons()

    if not keyboardButton or not mouseButton then
        return
    end

    if activeMode == "Keyboard" then

        keyboardButton.BackgroundColor3 = ORANGE
        keyboardButton.TextColor3 = DARK

        mouseButton.BackgroundColor3 =
            Color3.fromRGB(45, 35, 55)

        mouseButton.TextColor3 = WHITE

    else

        mouseButton.BackgroundColor3 = ORANGE
        mouseButton.TextColor3 = DARK

        keyboardButton.BackgroundColor3 =
            Color3.fromRGB(45, 35, 55)

        keyboardButton.TextColor3 = WHITE

    end

end

--==================================================
-- LIMPIAR POWER-UPS QUE ESTÁN CAYENDO
--==================================================

local function clearFallingPowerUps()

    for _, powerUp in ipairs(fallingPowerUps) do

        if powerUp.Object and powerUp.Object.Parent then
            powerUp.Object:Destroy()
        end

    end

    table.clear(fallingPowerUps)

end

--==================================================
-- SELECCIONAR POWER-UP ALEATORIO
--==================================================

local function selectPowerUpType()

    local weights = BrickBreakerConfig.PowerUps.DropWeights

    local availableTypes = {}
    local totalWeight = 0

    for _, powerUpType in ipairs(POWER_UP_TYPES) do

        local weight = weights[powerUpType.Id] or 0

        if powerUpType.Id == "ExtraLife"
            and extraLifeDroppedThisLevel then

            weight = 0

        end

        if weight > 0 then

            totalWeight += weight

            table.insert(availableTypes, {
                Type = powerUpType,
                Weight = weight,
            })

        end

    end

    if totalWeight <= 0 then
        return nil
    end

    local roll = powerUpRandom:NextNumber(0, totalWeight)
    local accumulatedWeight = 0

    for _, entry in ipairs(availableTypes) do

        accumulatedWeight += entry.Weight

        if roll <= accumulatedWeight then
            return entry.Type
        end

    end

    return availableTypes[#availableTypes].Type

end

--==================================================
-- CREAR UN POWER-UP
--==================================================

local function spawnPowerUp(worldPosition, forcedType)

    if not boardElements then
        return
    end

    local config = BrickBreakerConfig.PowerUps

    if not forcedType
        and powerUpRandom:NextNumber() > config.DropChance then

        return
    end

    local selectedType =
        forcedType or selectPowerUpType()

    if not selectedType then
        return
    end

    if selectedType.Id == "ExtraLife" and not forcedType then
        extraLifeDroppedThisLevel = true
    end

    local board = boardElements.Board

    local localPosition =
        worldPosition - board.AbsolutePosition

    local token = Instance.new("Frame")

    token.Name = "PowerUp_" .. selectedType.Id
    token.AnchorPoint = Vector2.new(0.5, 0.5)

    token.Position = UDim2.fromOffset(
        localPosition.X,
        localPosition.Y
    )

    token.Size = UDim2.fromOffset(
        config.Size,
        config.Size
    )

    token.BackgroundColor3 = selectedType.Color
    token.BorderSizePixel = 0

    token.ZIndex = 10
    token.Parent = board

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = token

    local stroke = Instance.new("UIStroke")

    stroke.Color = WHITE
    stroke.Thickness = 1.5
    stroke.Parent = token

    local label = Instance.new("TextLabel")

    label.Name = "Symbol"
    label.Size = UDim2.fromScale(1, 1)

    label.BackgroundTransparency = 1

    label.Text = selectedType.Label
    label.TextColor3 = WHITE

    label.TextSize = 17
    label.Font = Enum.Font.GothamBlack

    label.ZIndex = 11
    label.Parent = token

    table.insert(fallingPowerUps, {
        Object = token,
        Type = selectedType.Id,
    })

end

--==================================================
-- POSICIÓN DE LA PELOTA SOBRE LA PALA
--==================================================

local function positionBallOnPaddle()

    if not boardElements then
        return
    end

    local board = boardElements.Board
    local paddle = boardElements.Paddle
    local ball = boardElements.Ball

    if board.AbsoluteSize.X <= 0
        or board.AbsoluteSize.Y <= 0 then

        return
    end

    local paddlePosition = paddle.AbsolutePosition
    local paddleSize = paddle.AbsoluteSize
    local boardPosition = board.AbsolutePosition

    local ballRadius = ball.AbsoluteSize.X / 2

    local ballX =
        paddlePosition.X + paddleSize.X / 2

    local ballY =
        paddlePosition.Y - ballRadius - 2

    ball.Position = UDim2.fromOffset(
        ballX - boardPosition.X,
        ballY - boardPosition.Y
    )

end

--==================================================
-- POSICIONAR PELOTAS ATRAPADAS POR MAGNET
--==================================================

local function positionAttachedBall(ballData)

    if not boardElements then
        return
    end

    local ball = ballData.Object

    if not ball or not ball.Parent then
        return
    end

    local board = boardElements.Board
    local paddle = boardElements.Paddle

    local paddlePosition = paddle.AbsolutePosition
    local paddleSize = paddle.AbsoluteSize
    local boardPosition = board.AbsolutePosition

    local radius = ball.AbsoluteSize.X / 2

    local ballX =
        paddlePosition.X
        + paddleSize.X / 2
        + (ballData.AttachOffsetX or 0)

    local ballY =
        paddlePosition.Y - radius - 2

    ball.Position = UDim2.fromOffset(
        ballX - boardPosition.X,
        ballY - boardPosition.Y
    )

end

--==================================================
-- DIRECCIÓN DE RELANZAMIENTO MAGNÉTICO
--==================================================

local function getMagnetLaunchDirection(ballData)

    local paddle = boardElements.Paddle
    local paddleWidth = paddle.AbsoluteSize.X

    local relativeHit = 0

    if paddleWidth > 0 then

        relativeHit =
            (ballData.AttachOffsetX or 0) / (paddleWidth / 2)

    end

    relativeHit = math.clamp(relativeHit, -0.85, 0.85)

    return Vector2.new(
        relativeHit,
        -0.9
    ).Unit

end

local function releaseAttachedBall(ballData)

    if not ballData.Attached then
        return
    end

    ballData.Attached = false

    ballData.Velocity =
        getMagnetLaunchDirection(ballData)
        * getEffectiveBallSpeed()

    ballData.AttachOffsetX = nil

end

--==================================================
-- CREAR PELOTAS ADICIONALES: MULTIBALL
--==================================================

local function createMultiBall()

    if not boardElements or not gameStarted then
        return
    end

    local config = BrickBreakerConfig.PowerUps
    local maximumBalls = config.MultiBallMaximum

    if #activeBalls >= maximumBalls then

        score += config.MultiBallDuplicatePoints

        updateHUD()

        showTimedStatus("¡MULTIBOLA AL MÁXIMO: +100 PUNTOS!")

        return
    end

    -- Buscar una pelota que realmente esté en movimiento.

    local sourceBallData = nil

    for _, ballData in ipairs(activeBalls) do

        if not ballData.Attached
            and ballData.Velocity.Magnitude > 0 then

            sourceBallData = ballData
            break

        end

    end

    if not sourceBallData then
        return
    end

    local sourceBall = sourceBallData.Object

    local sourceVelocity = sourceBallData.Velocity

    local sourcePosition =
        sourceBall.AbsolutePosition + sourceBall.AbsoluteSize / 2

    local board = boardElements.Board

    local localPosition =
        sourcePosition - board.AbsolutePosition

    local ballsToCreate = math.min(
        config.MultiBallExtraCount,
        maximumBalls - #activeBalls
    )

    local angle = math.rad(config.MultiBallAngle)

    for index = 1, ballsToCreate do

        local direction

        if index == 1 then

            direction = Vector2.new(
                sourceVelocity.X * math.cos(angle)
                    - sourceVelocity.Y * math.sin(angle),

                sourceVelocity.X * math.sin(angle)
                    + sourceVelocity.Y * math.cos(angle)
            ).Unit

        else

            direction = Vector2.new(
                sourceVelocity.X * math.cos(-angle)
                    - sourceVelocity.Y * math.sin(-angle),

                sourceVelocity.X * math.sin(-angle)
                    + sourceVelocity.Y * math.cos(-angle)
            ).Unit

        end

        local newBall = sourceBall:Clone()

        for _, visualName in ipairs({
            "FireVisual",
            "FireGlow",
            "SlowVisual",
            "SlowGlow",
            "MultiBallGlow",
            "MagnetGlow",
        }) do

            removeVisual(newBall, visualName)

        end

        newBall.Name = "ExtraBall_" .. tostring(index)

        newBall.Position = UDim2.fromOffset(
            localPosition.X,
            localPosition.Y
        )

        newBall.Visible = true
        newBall.Parent = board

        table.insert(activeBalls, {
            Object = newBall,
            Velocity = direction * getEffectiveBallSpeed(),
            LastHitBrick = nil,
            IsMain = false,
            Attached = false,
            AttachOffsetX = nil,
        })

    end

end

--==================================================
-- ACTIVAR POWER-UP
--==================================================

local function activatePowerUp(powerUpType)

    local config = BrickBreakerConfig.PowerUps
    local now = os.clock()

    if powerUpType == "WidePaddle" then

        paddleWideUntil = now + config.PaddleDuration

        showTimedStatus("¡PALA AMPLIADA!")

    elseif powerUpType == "SlowBall" then

        slowBallUntil = now + config.SlowBallDuration

        showTimedStatus("¡BOLA LENTA!")

    elseif powerUpType == "ExtraLife" then

        if lives < config.ExtraLifeMax then

            lives += 1

            showTimedStatus("¡VIDA EXTRA!")

        else

            score += 50

            showTimedStatus("¡50 PUNTOS EXTRA!")

        end

        updateHUD()

    elseif powerUpType == "ScoreBonus" then

        score += config.ScoreBonusPoints

        updateHUD()

        showTimedStatus(
            "¡+" .. config.ScoreBonusPoints .. " PUNTOS!"
        )

    elseif powerUpType == "Shield" then

        if shieldUntil > now then

            score += config.ShieldExpiredPoints

            updateHUD()

            showTimedStatus("¡ESCUDO DUPLICADO: +100 PUNTOS!")

        else

            shieldUntil = now + config.ShieldDuration

            showTimedStatus("¡ESCUDO ACTIVADO!")

        end

    elseif powerUpType == "Fireball" then

        fireballUntil = now + config.FireballDuration

        showTimedStatus("¡BOLA DE FUEGO!")

    elseif powerUpType == "MultiBall" then

        local previousCount = #activeBalls

        createMultiBall()

        if #activeBalls > previousCount then
            showTimedStatus("¡MULTIBOLA!")
        end

    elseif powerUpType == "Magnet" then

        magnetUntil = math.huge

        showTimedStatus("¡IMÁN PREPARADO! ATRAPA LA PELOTA")

    end

    updatePowerUpVisuals()

end

--==================================================
-- ACTUALIZAR EFECTOS TEMPORALES
--==================================================

local function updatePowerUpEffects()

    if not boardElements then
        return
    end

    local now = os.clock()

    -- PALA AMPLIADA.

    if basePaddleSize then

        if now < paddleWideUntil then

            local multiplier =
                BrickBreakerConfig.PowerUps.PaddleWidthMultiplier

            boardElements.Paddle.Size = UDim2.new(
                basePaddleSize.X.Scale * multiplier,
                basePaddleSize.X.Offset * multiplier,
                basePaddleSize.Y.Scale,
                basePaddleSize.Y.Offset
            )

        else

            boardElements.Paddle.Size = basePaddleSize

        end

    end

    -- CADUCIDAD DEL ESCUDO.

    if shieldUntil > 0 and now >= shieldUntil then

        shieldUntil = 0

        score += BrickBreakerConfig.PowerUps.ShieldExpiredPoints

        updateHUD()

        showTimedStatus("¡ESCUDO CADUCADO: +100 PUNTOS!")

    end

    -- EL IMÁN NO CADUCA POR TIEMPO.
    -- SE CONSUME AL RELANZAR UNA PELOTA ATRAPADA.

    -- ACTUALIZAR VELOCIDAD DE TODAS LAS PELOTAS.

    if gameStarted then

        local targetSpeed = getEffectiveBallSpeed()

        for _, ballData in ipairs(activeBalls) do

            if not ballData.Attached
                and ballData.Velocity.Magnitude > 0 then

                if math.abs(
                    ballData.Velocity.Magnitude - targetSpeed
                ) > 0.01 then

                    ballData.Velocity =
                        ballData.Velocity.Unit * targetSpeed

                end

            end

        end

    end

    updatePowerUpVisuals()

end

--==================================================
-- MOVIMIENTO Y RECOGIDA DE POWER-UPS
--==================================================

local function updateFallingPowerUps(deltaTime)

    if not boardElements then
        return
    end

    local board = boardElements.Board
    local paddle = boardElements.Paddle

    local paddlePosition = paddle.AbsolutePosition
    local paddleSize = paddle.AbsoluteSize

    local boardBottom =
        board.AbsolutePosition.Y + board.AbsoluteSize.Y

    local fallSpeed = BrickBreakerConfig.PowerUps.FallSpeed

    for index = #fallingPowerUps, 1, -1 do

        local powerUp = fallingPowerUps[index]
        local object = powerUp.Object

        if not object or not object.Parent then

            table.remove(fallingPowerUps, index)

            continue

        end

        local currentPosition = object.Position

        local newY =
            currentPosition.Y.Offset + fallSpeed * deltaTime

        object.Position = UDim2.fromOffset(
            currentPosition.X.Offset,
            newY
        )

        local center =
            object.AbsolutePosition + object.AbsoluteSize / 2

        local radius = object.AbsoluteSize.X / 2

        local closestX = math.clamp(
            center.X,
            paddlePosition.X,
            paddlePosition.X + paddleSize.X
        )

        local closestY = math.clamp(
            center.Y,
            paddlePosition.Y,
            paddlePosition.Y + paddleSize.Y
        )

        local distanceX = center.X - closestX
        local distanceY = center.Y - closestY

        local caught =
            distanceX * distanceX + distanceY * distanceY
            <= radius * radius

        if caught then

            showPowerUpPickupEffect(center, powerUp.Type)

            activatePowerUp(powerUp.Type)

            object:Destroy()

            table.remove(fallingPowerUps, index)

        elseif center.Y - radius > boardBottom then

            object:Destroy()

            table.remove(fallingPowerUps, index)

        end

    end

end

--==================================================
-- RESTAURAR LADRILLOS
--==================================================

local function restoreBricks()

    if not boardElements then
        return
    end

    if boardElements.SetLevel then

        boardElements.SetLevel(level)

    else

        for _, brick in ipairs(boardElements.Bricks) do

            if brick and brick.Parent then
                brick.Visible = true
            end

        end

    end

end

--==================================================
-- REINICIAR PELOTA Y EFECTOS
--==================================================

local function resetBall()

    if not boardElements then
        return
    end

    gameStarted = false

    ballVelocity = Vector2.zero

    -- ELIMINAR PELOTAS ADICIONALES.

    for _, ballData in ipairs(activeBalls) do

        if not ballData.IsMain
            and ballData.Object
            and ballData.Object.Parent then

            ballData.Object:Destroy()

        end

    end

    table.clear(activeBalls)

    -- RESTABLECER PELOTA PRINCIPAL.

    local mainBall = boardElements.Ball

    mainBall.Visible = true

    removeVisual(mainBall, "FireVisual")
    removeVisual(mainBall, "FireGlow")
    removeVisual(mainBall, "SlowVisual")
    removeVisual(mainBall, "SlowGlow")
    removeVisual(mainBall, "MultiBallGlow")
    removeVisual(mainBall, "MagnetGlow")

    table.insert(activeBalls, {
        Object = mainBall,
        Velocity = Vector2.zero,
        LastHitBrick = nil,
        IsMain = true,
        Attached = false,
        AttachOffsetX = nil,
    })

    -- LIMPIAR POWER-UPS QUE ESTÉN CAYENDO.

    clearFallingPowerUps()

    -- RESTABLECER EFECTOS TEMPORALES.

    paddleWideUntil = 0
    slowBallUntil = 0
    shieldUntil = 0
    fireballUntil = 0
    magnetUntil = 0

    -- RESTABLECER TAMAÑO DE LA PALA.

    if basePaddleSize then
        boardElements.Paddle.Size = basePaddleSize
    end

    removeVisual(boardElements.Paddle, "WidePaddleGlow")

    updateShieldVisual()
    updatePowerUpVisuals()

    -- COLOCAR PELOTA EN EL CENTRO DE LA PALA.

    positionBallOnPaddle()

    setStatus("PULSA ESPACIO O HAZ CLIC PARA JUGAR")

end

--==================================================
-- LANZAR PELOTA
--==================================================

local function launchBall()

        if isPaused or isTransitioning or gameOver then
        return
    end

    -- SI LA PARTIDA YA ESTÁ EN MARCHA,
    -- LIBERAR LAS PELOTAS ATRAPADAS POR EL IMÁN.

    if gameStarted then

        local releasedAny = false

        for _, ballData in ipairs(activeBalls) do

            if ballData.Attached then

                releaseAttachedBall(ballData)

                releasedAny = true

            end

        end

        if releasedAny then

            -- EL IMÁN SE CONSUME AL LANZAR.
            magnetUntil = 0

            updatePowerUpVisuals()

            showTimedStatus("¡IMÁN CONSUMIDO!")

        end

        return

    end

    -- LANZAMIENTO NORMAL CON DIRECCIÓN FIJA.

    gameStarted = true

    local direction = Vector2.new(0.55, -0.84).Unit

    ballVelocity =
        direction * getEffectiveBallSpeed()

    if activeBalls[1] then

        activeBalls[1].Velocity = ballVelocity

    end

    setStatus("")

end

--==================================================
-- INICIAR LA PELOTA DESDE LA INTERFAZ
--==================================================

function BrickBreakerController.Launch()

    if not boardElements then
        return
    end

    launchBall()

end

--==================================================
-- COLISIÓN CON LADRILLOS
--==================================================

local function handleBrickCollision(ballPosition, radius, ballData)

    if not boardElements then
        return false
    end

    local lastHitBrickStillOverlapping = false

    for _, brick in ipairs(boardElements.Bricks) do

        if brick and brick.Parent and brick.Visible then

            local brickPosition = brick.AbsolutePosition
            local brickSize = brick.AbsoluteSize

            local closestX = math.clamp(
                ballPosition.X,
                brickPosition.X,
                brickPosition.X + brickSize.X
            )

            local closestY = math.clamp(
                ballPosition.Y,
                brickPosition.Y,
                brickPosition.Y + brickSize.Y
            )

            local distanceX = ballPosition.X - closestX
            local distanceY = ballPosition.Y - closestY

            local distanceSquared =
                distanceX * distanceX + distanceY * distanceY

            if distanceSquared <= radius * radius then

                if brick == ballData.LastHitBrick then

                    lastHitBrickStillOverlapping = true

                else

                    local brickCenter =
                        brick.AbsolutePosition + brick.AbsoluteSize / 2

                    local destroyed

                    if boardElements.DamageBrick then

                        destroyed =
                            boardElements.DamageBrick(brick)

                    else

                        brick.Visible = false
                        destroyed = true

                    end

                    ballData.LastHitBrick = brick

                    if destroyed then

                        score +=
                            BrickBreakerConfig.Game.PointsPerBrick

                        updateHUD()

                        spawnPowerUp(brickCenter)

                    end

                    return true

                end

            end

        end

    end

    if ballData.LastHitBrick
        and not lastHitBrickStillOverlapping then

        ballData.LastHitBrick = nil

    end

    return false

end

--==================================================
-- COLISIÓN CON LA PALA
--==================================================

local function handlePaddleCollision(
    ballPosition,
    radius,
    ballData
)

    local paddle = boardElements.Paddle

    local paddlePosition = paddle.AbsolutePosition
    local paddleSize = paddle.AbsoluteSize

    local ballBottom = ballPosition.Y + radius
    local paddleTop = paddlePosition.Y

    local overlapsX =
        ballPosition.X + radius >= paddlePosition.X
        and ballPosition.X - radius
            <= paddlePosition.X + paddleSize.X

    local overlapsY =
        ballBottom >= paddleTop
        and ballPosition.Y - radius
            <= paddlePosition.Y + paddleSize.Y

    if overlapsX
        and overlapsY
        and ballData.Velocity.Y > 0 then

        local paddleCenter =
            paddlePosition.X + paddleSize.X / 2

        local relativeHit =
            (ballPosition.X - paddleCenter)
            / (paddleSize.X / 2)

        relativeHit = math.clamp(
            relativeHit,
            -0.85,
            0.85
        )

        -- MAGNET: ATRAPAR EN EL PUNTO DE CONTACTO.

        if magnetUntil == math.huge then

            ballData.Attached = true

            ballData.AttachOffsetX = math.clamp(
                ballPosition.X - paddleCenter,
                -(paddleSize.X / 2 - radius),
                paddleSize.X / 2 - radius
            )

            ballData.Velocity = Vector2.zero

            showTimedStatus("¡PELOTA ATRAPADA POR EL IMÁN!")

            return true
        end

        -- REBOTE NORMAL.

        local direction = Vector2.new(
            relativeHit,
            -0.9
        ).Unit

        ballData.Velocity =
            direction * getEffectiveBallSpeed()

        return true

    end

    return false

end

--==================================================
-- COMPROBAR SI QUEDAN LADRILLOS
--==================================================

local function checkLevelCompleted()

    for _, brick in ipairs(boardElements.Bricks) do

        if brick and brick.Parent and brick.Visible then
            return false
        end

    end

    return true

end

--==================================================
-- COMPLETAR NIVEL
--==================================================

local function completeLevel()

    if isTransitioning or gameOver then
        return
    end

    local completedLevel = level

    pendingCompletedLevel = completedLevel

    isTransitioning = true
    gameStarted = false
    ballVelocity = Vector2.zero

    -- DETENER LOS CONTROLES DURANTE LA TRANSICIÓN.

    if inputStarted then

        BrickBreakerInput.Stop()

        inputStarted = false

    end

    level += 1

    extraLifeDroppedThisLevel = false

    score += BrickBreakerConfig.Game.PointsPerLevel

    currentSpeed = getSpeedForLevel(level)

    updateHUD()

    -- LA INTERFAZ SE ENCARGARÁ DE MOSTRAR LA TRANSICIÓN.

    if callbacks.onLevelCompleted then

        callbacks.onLevelCompleted(
            completedLevel,
            level
        )

    else

        BrickBreakerController.ContinueLevel()

    end

end

--==================================================
-- CONTINUAR DESPUÉS DE LA TRANSICIÓN DE NIVEL
--==================================================

function BrickBreakerController.ContinueLevel()

    if not boardElements or not isTransitioning then
        return
    end

    isTransitioning = false

    restoreBricks()

    updateHUD()

    resetBall()

    setStatus(
        "¡NIVEL "
            .. tostring(pendingCompletedLevel)
            .. " COMPLETADO!"
    )

    pendingCompletedLevel = nil

    -- REACTIVAR LOS CONTROLES.

    if not inputStarted then

        BrickBreakerInput.Start(
            boardElements.Board,
            boardElements.Paddle,
            launchBall
        )

        BrickBreakerInput.SetMode(activeMode)

        inputStarted = true

    end

end

--==================================================
-- PERDER UNA VIDA
--==================================================

local function loseLife()

    lives -= 1

    updateHUD()

    if lives <= 0 then

        gameStarted = false
        gameOver = true
        isTransitioning = false

        ballVelocity = Vector2.zero

        -- DETENER LOS CONTROLES AL TERMINAR LA PARTIDA.

        if inputStarted then

            BrickBreakerInput.Stop()

            inputStarted = false

        end

        paddleWideUntil = 0
        slowBallUntil = 0
        shieldUntil = 0
        fireballUntil = 0
        magnetUntil = 0

        clearFallingPowerUps()

        updatePowerUpVisuals()

        setStatus("GAME OVER")

        if callbacks.onGameOver then

            callbacks.onGameOver({
                Score = score,
                Lives = lives,
                Level = level,
            })

        end

        return

    end

    resetBall()

    setStatus("HAS PERDIDO UNA VIDA")

end

--==================================================
-- ACTUALIZAR PELOTAS
--==================================================

local function updateBall(deltaTime)

    if not boardElements or not gameStarted then
        return
    end

    local board = boardElements.Board

    local boardSize = board.AbsoluteSize
    local boardPosition = board.AbsolutePosition

    if boardSize.X <= 0 or boardSize.Y <= 0 then
        return
    end

    local left = boardPosition.X
    local right = boardPosition.X + boardSize.X
    local top = boardPosition.Y
    local bottom = boardPosition.Y + boardSize.Y

    local isFireball = os.clock() < fireballUntil

    -- LÍNEA DEL ESCUDO, A LO ANCHO DEL TABLERO.

    local shieldY = bottom - 34

    for index = #activeBalls, 1, -1 do

        local ballData = activeBalls[index]
        local ball = ballData.Object

        if not ball or not ball.Parent then

            table.remove(activeBalls, index)

            continue

        end

        local radius = ball.AbsoluteSize.X / 2

        local ballPosition =
            ball.AbsolutePosition + ball.AbsoluteSize / 2

        -- PELOTAS ATRAPADAS POR MAGNET.

        if ballData.Attached then

            positionAttachedBall(ballData)

            continue

        end

        -- GUARDAR POSICIÓN ANTERIOR PARA DETECTAR
        -- EL CRUCE DE LA LÍNEA DEL ESCUDO.

        local previousBottom = ballPosition.Y + radius

        -- MOVIMIENTO.

        ballPosition +=
            ballData.Velocity * deltaTime

        -- PARED IZQUIERDA.

        if ballPosition.X - radius <= left then

            ballPosition = Vector2.new(
                left + radius,
                ballPosition.Y
            )

            ballData.Velocity = Vector2.new(
                math.abs(ballData.Velocity.X),
                ballData.Velocity.Y
            )

        end

        -- PARED DERECHA.

        if ballPosition.X + radius >= right then

            ballPosition = Vector2.new(
                right - radius,
                ballPosition.Y
            )

            ballData.Velocity = Vector2.new(
                -math.abs(ballData.Velocity.X),
                ballData.Velocity.Y
            )

        end

        -- PARED SUPERIOR.

        if ballPosition.Y - radius <= top then

            ballPosition = Vector2.new(
                ballPosition.X,
                top + radius
            )

            ballData.Velocity = Vector2.new(
                ballData.Velocity.X,
                math.abs(ballData.Velocity.Y)
            )

        end

        -- COLISIÓN CON LA PALA.

        handlePaddleCollision(
            ballPosition,
            radius,
            ballData
        )

        -- SI MAGNET HA ATRAPADO ESTA PELOTA,
        -- NO SE PROCESAN MÁS COLISIONES EN ESTE FRAME.

        if ballData.Attached then

            positionAttachedBall(ballData)

            continue

        end

        -- COLISIÓN CON LADRILLOS.

        local hitBrick = handleBrickCollision(
            ballPosition,
            radius,
            ballData
        )

        -- BOLA DE FUEGO: ATRAVIESA LOS LADRILLOS.

        if hitBrick and not isFireball then

            ballData.Velocity = Vector2.new(
                ballData.Velocity.X,
                -ballData.Velocity.Y
            )

        end

        -- ESCUDO: SALVAR UNA PELOTA AL CRUZAR SU LÍNEA.
        -- No depende de la posición de la pala.

        if shieldUntil > os.clock()
            and ballData.Velocity.Y > 0 then

            local currentBottom = ballPosition.Y + radius

            if previousBottom < shieldY
                and currentBottom >= shieldY then

                shieldUntil = 0

                ballPosition = Vector2.new(
                    ballPosition.X,
                    shieldY - radius
                )

                ballData.Velocity = Vector2.new(
                    ballData.Velocity.X,
                    -math.abs(ballData.Velocity.Y)
                )

                updateShieldVisual()

                showTimedStatus(
                    "¡ESCUDO ACTIVADO: PELOTA SALVADA!"
                )

            end

        end

        -- COMPROBAR SI LA PELOTA HA CAÍDO.

        if ballPosition.Y - radius > bottom then

            table.remove(activeBalls, index)

            if ballData.IsMain then

                ball.Visible = false

            else

                ball:Destroy()

            end

            -- SOLO SE PIERDE UNA VIDA CUANDO
            -- NO QUEDA NINGUNA PELOTA.

            if #activeBalls == 0 then

                loseLife()

                return

            end

            continue

        end

        -- ACTUALIZAR POSICIÓN VISUAL.

        ball.Position = UDim2.fromOffset(
            ballPosition.X - boardPosition.X,
            ballPosition.Y - boardPosition.Y
        )

    end

    -- COMPROBAR SI QUEDAN LADRILLOS.

    if gameStarted and checkLevelCompleted() then
        completeLevel()
    end

end

--==================================================
-- REINICIAR PARTIDA COMPLETA
--==================================================

resetGame = function()

    score = 0

    lives = BrickBreakerConfig.Game.InitialLives

    level = 1

    extraLifeDroppedThisLevel = false

    currentSpeed = BrickBreakerConfig.Ball.InitialSpeed

    gameOver = false
    gameStarted = false

    isPaused = false
    pausedAt = 0

    if developerPauseButton then

        developerPauseButton.Text = "PAUSAR"

        developerPauseButton.BackgroundColor3 =
            Color3.fromRGB(185, 105, 45)

    end

    restoreBricks()

    updateHUD()

    resetBall()

end

--==================================================
-- SELECTOR DE CONTROLES
--==================================================

local function createControlSelector(parent)

    local selector = Instance.new("Frame")

    selector.Name = "ControlSelector"
    selector.Size = UDim2.fromScale(0.42, 0.07)
    selector.Position = UDim2.fromScale(0.29, 0.005)

    selector.BackgroundTransparency = 1
    selector.ZIndex = 6
    selector.Parent = parent

    local layout = Instance.new("UIListLayout")

    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 8)
    layout.Parent = selector

    local function createModeButton(name, text)

        local button = Instance.new("TextButton")

        button.Name = name
        button.Size = UDim2.new(0.48, 0, 1, 0)

        button.BackgroundColor3 =
            Color3.fromRGB(45, 35, 55)

        button.BorderSizePixel = 0

        button.Text = text
        button.TextColor3 = WHITE
        button.TextSize = 12
        button.Font = Enum.Font.GothamBold

        button.AutoButtonColor = true
        button.ZIndex = 7
        button.Parent = selector

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = button

        return button

    end

    keyboardButton = createModeButton(
        "KeyboardButton",
        "TECLADO"
    )

    mouseButton = createModeButton(
        "MouseButton",
        "RATÓN"
    )

    keyboardButton.Activated:Connect(function()

        activeMode = "Keyboard"

        BrickBreakerInput.SetMode(activeMode)

        updateControlButtons()

    end)

    mouseButton.Activated:Connect(function()

        activeMode = "Mouse"

        BrickBreakerInput.SetMode(activeMode)

        updateControlButtons()

    end)

    modeButtons = selector

    updateControlButtons()

    return selector

end

--==================================================
-- HERRAMIENTAS DEV: SALTAR DE NIVEL
--==================================================

local function jumpToLevel(targetLevel)

    if not RunService:IsStudio() then
        return
    end

    targetLevel = math.floor(
        tonumber(targetLevel) or 0
    )

    if targetLevel < 1 then
        return
    end

    level = targetLevel

    extraLifeDroppedThisLevel = false

    if lives <= 0 then
        lives = BrickBreakerConfig.Game.InitialLives
    end

    gameOver = false

    currentSpeed = getSpeedForLevel(level)

    restoreBricks()

    updateHUD()

    resetBall()

    print(
        "BrickBreaker DEV | Salto al nivel "
            .. level
            .. " | Velocidad: "
            .. currentSpeed
    )

end

--==================================================
-- PAUSAR Y REANUDAR PARTIDA
--==================================================

local function setPaused(shouldPause)

    if shouldPause == isPaused then
        return
    end

    if shouldPause then

        isPaused = true
        pausedAt = os.clock()

        -- DETENER INPUT PARA QUE LA PALA TAMPOCO SE MUEVA.

        if inputStarted then
            BrickBreakerInput.Stop()
            inputStarted = false
        end

        if developerPauseButton then
            developerPauseButton.Text = "REANUDAR"
            developerPauseButton.BackgroundColor3 =
                Color3.fromRGB(45, 155, 100)
        end

        setStatus("PARTIDA PAUSADA")

    else

        local pauseDuration = os.clock() - pausedAt

        -- COMPENSAR LOS TEMPORIZADORES DE LOS POWER-UPS.

        if paddleWideUntil > 0 then
            paddleWideUntil += pauseDuration
        end

        if slowBallUntil > 0 then
            slowBallUntil += pauseDuration
        end

        if shieldUntil > 0 then
            shieldUntil += pauseDuration
        end

        if fireballUntil > 0 then
            fireballUntil += pauseDuration
        end

        if magnetUntil > 0 then
            magnetUntil += pauseDuration
        end

        isPaused = false
        pausedAt = 0

        -- VOLVER A ACTIVAR LOS CONTROLES.

        if boardElements
            and not gameOver
            and not isTransitioning
            and not inputStarted
        then
            BrickBreakerInput.Start(
                boardElements.Board,
                boardElements.Paddle,
                launchBall
            )

            BrickBreakerInput.SetMode(activeMode)
            inputStarted = true
        end

        if developerPauseButton then
            developerPauseButton.Text = "PAUSAR"
            developerPauseButton.BackgroundColor3 =
                Color3.fromRGB(185, 105, 45)
        end

        if gameStarted then
            setStatus("")
        else
            setStatus("PULSA ESPACIO O HAZ CLIC PARA JUGAR")
        end

        updatePowerUpVisuals()

    end
end

--==================================================
-- PAUSA DESDE LA INTERFAZ
--==================================================

function BrickBreakerController.Pause()
    setPaused(true)
end

function BrickBreakerController.Resume()
    setPaused(false)
end

--==================================================
-- HERRAMIENTAS DE DESARROLLADOR
--==================================================

local function createDeveloperTools(parent)

    if not RunService:IsStudio() then
        return
    end

    local container = Instance.new("Frame")

    container.Name = "DeveloperTools"
    container.Size = UDim2.fromScale(1, 1)
    container.BackgroundTransparency = 1
    container.ZIndex = 20
    container.Parent = parent

    developerInterface = container

    -- BOTÓN DEV.

    local devButton = Instance.new("TextButton")

    devButton.Name = "DevButton"
    devButton.Size = UDim2.fromScale(0.12, 0.065)
    devButton.Position = UDim2.fromScale(0.75, 0.005)

    devButton.BackgroundColor3 =
        Color3.fromRGB(115, 55, 190)

    devButton.BorderSizePixel = 0

    devButton.Text = "DEV"
    devButton.TextColor3 = WHITE
    devButton.TextSize = 13
    devButton.Font = Enum.Font.GothamBold

    devButton.ZIndex = 21
    devButton.Parent = container

    local devCorner = Instance.new("UICorner")
    devCorner.CornerRadius = UDim.new(0, 5)
    devCorner.Parent = devButton

    -- BOTÓN DE PAUSA.

    developerPauseButton = Instance.new("TextButton")

    developerPauseButton.Name = "PauseButton"
    developerPauseButton.Size = UDim2.fromScale(0.12, 0.065)
    developerPauseButton.Position = UDim2.fromScale(0.87, 0.005)

    developerPauseButton.BackgroundColor3 =
        Color3.fromRGB(185, 105, 45)

    developerPauseButton.BorderSizePixel = 0

    developerPauseButton.Text = "PAUSAR"
    developerPauseButton.TextColor3 = WHITE
    developerPauseButton.TextSize = 12
    developerPauseButton.Font = Enum.Font.GothamBold

    developerPauseButton.ZIndex = 21
    developerPauseButton.Parent = container

    local pauseCorner = Instance.new("UICorner")
    pauseCorner.CornerRadius = UDim.new(0, 5)
    pauseCorner.Parent = developerPauseButton

    developerPauseButton.Activated:Connect(function()

        setPaused(not isPaused)

    end)

    -- PANEL DE DESARROLLADOR.

    local panel = Instance.new("Frame")

    panel.Name = "LevelPanel"
    panel.Size = UDim2.fromScale(0.30, 0.60)
    panel.Position = UDim2.fromScale(0.68, 0.08)

    panel.BackgroundColor3 = Color3.fromRGB(25, 17, 40)
    panel.BorderSizePixel = 0

    panel.Visible = false
    panel.ClipsDescendants = false
    panel.ZIndex = 22
    panel.Parent = container

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 8)
    panelCorner.Parent = panel

    local panelStroke = Instance.new("UIStroke")

    panelStroke.Color = Color3.fromRGB(180, 100, 255)
    panelStroke.Thickness = 2
    panelStroke.Parent = panel

    local function createPanelLabel(
        name,
        text,
        position,
        size
    )

        local label = Instance.new("TextLabel")

        label.Name = name
        label.Size = size
        label.Position = position
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = WHITE
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        label.ZIndex = 23
        label.Parent = panel

        return label

    end

    local function createPanelButton(
        name,
        text,
        position,
        size
    )

        local button = Instance.new("TextButton")

        button.Name = name
        button.Size = size
        button.Position = position

        button.BackgroundColor3 =
            Color3.fromRGB(65, 45, 85)

        button.BorderSizePixel = 0

        button.Text = text
        button.TextColor3 = WHITE
        button.TextSize = 13
        button.Font = Enum.Font.GothamBold

        button.ZIndex = 23
        button.Parent = panel

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = button

        return button

    end

    -- SECCIÓN: SALTAR DE NIVEL.

    createPanelLabel(
        "LevelTitle",
        "SALTAR A NIVEL",
        UDim2.fromScale(0.05, 0.035),
        UDim2.fromScale(0.9, 0.13)
    )

    local levelInput = Instance.new("TextBox")

    levelInput.Name = "LevelInput"
    levelInput.Size = UDim2.fromScale(0.42, 0.13)
    levelInput.Position = UDim2.fromScale(0.29, 0.18)

    levelInput.BackgroundColor3 =
        Color3.fromRGB(45, 35, 60)

    levelInput.BorderSizePixel = 0
    levelInput.Text = "16"
    levelInput.PlaceholderText = "Nivel"
    levelInput.TextColor3 = WHITE

    levelInput.PlaceholderColor3 =
        Color3.fromRGB(170, 160, 180)

    levelInput.TextSize = 17
    levelInput.Font = Enum.Font.GothamBold
    levelInput.ClearTextOnFocus = false

    levelInput.ZIndex = 23
    levelInput.Parent = panel

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = levelInput

    local minusButton = createPanelButton(
        "MinusButton",
        "-",
        UDim2.fromScale(0.08, 0.18),
        UDim2.fromScale(0.17, 0.13)
    )

    local plusButton = createPanelButton(
        "PlusButton",
        "+",
        UDim2.fromScale(0.75, 0.18),
        UDim2.fromScale(0.17, 0.13)
    )

    local jumpButton = createPanelButton(
        "JumpButton",
        "SALTAR",
        UDim2.fromScale(0.12, 0.34),
        UDim2.fromScale(0.76, 0.13)
    )

    jumpButton.BackgroundColor3 =
        Color3.fromRGB(145, 75, 220)

    -- SECCIÓN: GENERAR POWER-UPS.

    createPanelLabel(
        "PowerUpTitle",
        "GENERAR POWER-UP",
        UDim2.fromScale(0.05, 0.52),
        UDim2.fromScale(0.9, 0.10)
    )

    local selectedPowerUpIndex = 1
    local selectedPowerUp =
        POWER_UP_TYPES[selectedPowerUpIndex]

    local powerUpSelectButton = createPanelButton(
        "PowerUpSelectButton",
        selectedPowerUp.Label .. "  " .. selectedPowerUp.Id,
        UDim2.fromScale(0.08, 0.64),
        UDim2.fromScale(0.84, 0.13)
    )

    powerUpSelectButton.BackgroundColor3 =
        selectedPowerUp.Color

    local spawnPowerUpButton = createPanelButton(
        "SpawnPowerUpButton",
        "GENERAR POWER-UP",
        UDim2.fromScale(0.08, 0.80),
        UDim2.fromScale(0.84, 0.13)
    )

    spawnPowerUpButton.BackgroundColor3 =
        Color3.fromRGB(35, 135, 155)

    -- CAMBIAR POWER-UP SELECCIONADO.

    powerUpSelectButton.Activated:Connect(function()

        selectedPowerUpIndex += 1

        if selectedPowerUpIndex > #POWER_UP_TYPES then
            selectedPowerUpIndex = 1
        end

        selectedPowerUp =
            POWER_UP_TYPES[selectedPowerUpIndex]

        powerUpSelectButton.Text =
            selectedPowerUp.Label
            .. "  "
            .. selectedPowerUp.Id

        powerUpSelectButton.BackgroundColor3 =
            selectedPowerUp.Color

    end)

    -- GENERAR POWER-UP SELECCIONADO.

    spawnPowerUpButton.Activated:Connect(function()

        if not boardElements then
            return
        end

        local board = boardElements.Board

        local spawnPosition =
            board.AbsolutePosition + Vector2.new(
                board.AbsoluteSize.X * 0.5,
                math.max(
                    18,
                    BrickBreakerConfig.PowerUps.Size
                )
            )

        spawnPowerUp(
            spawnPosition,
            selectedPowerUp
        )

    end)

    -- BOTÓN MENOS.

    minusButton.Activated:Connect(function()

        local value =
            math.floor(tonumber(levelInput.Text) or 1)

        levelInput.Text =
            tostring(math.max(1, value - 1))

    end)

    -- BOTÓN MÁS.

    plusButton.Activated:Connect(function()

        local value =
            math.floor(tonumber(levelInput.Text) or 1)

        levelInput.Text = tostring(value + 1)

    end)

    -- SALTAR AL NIVEL INTRODUCIDO.

    jumpButton.Activated:Connect(function()

        local targetLevel =
            tonumber(levelInput.Text)

        if not targetLevel or targetLevel < 1 then

            levelInput.Text = "1"

            return
        end

        jumpToLevel(targetLevel)

        panel.Visible = false

    end)

    -- ABRIR Y CERRAR PANEL.

    devButton.Activated:Connect(function()

        panel.Visible = not panel.Visible

    end)

end

--==================================================
-- INICIAR CONTROLADOR
--==================================================

function BrickBreakerController.Start(
    parent,
    eventCallbacks: BrickBreakerCallbacks?
)

    if boardElements then
        BrickBreakerController.Stop()
    end

    callbacks = eventCallbacks or {}

    isTransitioning = false
    pendingCompletedLevel = nil

    -- CREAR TABLERO.

    boardElements = BrickBreakerBoard.Create(parent)

    local board = boardElements.Board

    basePaddleSize = boardElements.Paddle.Size

    -- RESTABLECER ESTADOS.

    paddleWideUntil = 0
    slowBallUntil = 0
    shieldUntil = 0
    fireballUntil = 0
    magnetUntil = 0

    isPaused = false
    pausedAt = 0

    extraLifeDroppedThisLevel = false

    table.clear(activeBalls)

    -- CONECTAR ESTADÍSTICAS DE LA RECREATIVA.

    local cabinet = parent.Parent

    local statsPanel =
        cabinet and cabinet:FindFirstChild("StatsPanel")

    if statsPanel then

        machineScoreValue =
            statsPanel:FindFirstChild("ScoreValue")

        machineLevelValue =
            statsPanel:FindFirstChild("LevelValue")

        machineBestValue =
            statsPanel:FindFirstChild("BestValue")

    else

        warn(
            "BrickBreaker: No se encontró StatsPanel en la recreativa."
        )

    end

    -- RESERVAR ESPACIO PARA LOS CONTROLES.

    board.Position = UDim2.fromScale(0.14, 0.08)
    board.Size = UDim2.fromScale(0.72, 0.92)

    -- HUD.

    scoreLabel = createLabel(
        board,
        "ScoreLabel",
        "PUNTOS: 0",
        UDim2.fromScale(0.02, 0.005),
        UDim2.fromScale(0.28, 0.055),
        14
    )

    livesLabel = createLabel(
        board,
        "LivesLabel",
        "VIDAS: 3",
        UDim2.fromScale(0.36, 0.005),
        UDim2.fromScale(0.28, 0.055),
        14
    )

    levelLabel = createLabel(
        board,
        "LevelLabel",
        "NIVEL: 1",
        UDim2.fromScale(0.70, 0.005),
        UDim2.fromScale(0.28, 0.055),
        14
    )

    statusLabel = createLabel(
        board,
        "StatusLabel",
        "",
        UDim2.fromScale(0.05, 0.94),
        UDim2.fromScale(0.90, 0.05),
        13
    )

    statusLabel.TextColor3 = ORANGE

    -- SELECTOR DE CONTROLES.

    createControlSelector(parent)

    -- HERRAMIENTAS DEV.

    createDeveloperTools(parent)

    -- INICIAR INPUT.

    BrickBreakerInput.Start(
        board,
        boardElements.Paddle,
        launchBall
    )

    BrickBreakerInput.SetMode(activeMode)

    inputStarted = true

    -- PREPARAR PARTIDA.

    resetGame()

    -- ACTUALIZACIÓN CONTINUA.

    gameConnection = RunService.Heartbeat:Connect(
        function(deltaTime)

            if not boardElements
                or gameOver
                or isPaused
                or isTransitioning then

                return
            end

            local safeDeltaTime = math.min(
                deltaTime,
                0.033
            )

            updatePowerUpEffects()

            updateFallingPowerUps(safeDeltaTime)

            -- ANTES DEL PRIMER LANZAMIENTO,
            -- LA PELOTA SIGUE EL CENTRO DE LA PALA.

            if not gameStarted then
                positionBallOnPaddle()
            end

            updateBall(safeDeltaTime)

        end
    )

end

--==================================================
-- DETENER CONTROLADOR
--==================================================

function BrickBreakerController.Stop()

    if gameConnection then

        gameConnection:Disconnect()

        gameConnection = nil

    end

    if inputStarted then

        BrickBreakerInput.Stop()

        inputStarted = false

    end

    if modeButtons then

        modeButtons:Destroy()

        modeButtons = nil

    end

    if developerInterface then

        developerInterface:Destroy()

        developerInterface = nil

    end

    developerPauseButton = nil

    clearFallingPowerUps()

    -- RESTABLECER TEMPORIZADORES.

    paddleWideUntil = 0
    slowBallUntil = 0
    shieldUntil = 0
    fireballUntil = 0
    magnetUntil = 0

    basePaddleSize = nil

    -- DESTRUIR TABLERO.

    if boardElements and boardElements.Board then
        boardElements.Board:Destroy()
    end

    boardElements = nil

    -- LIMPIAR HUD.

    scoreLabel = nil
    livesLabel = nil
    levelLabel = nil
    statusLabel = nil

    machineScoreValue = nil
    machineLevelValue = nil
    machineBestValue = nil

    keyboardButton = nil
    mouseButton = nil

    -- RESTABLECER PARTIDA.

    score = 0
    lives = 0
    level = 1

    gameStarted = false
    gameOver = false

    ballVelocity = Vector2.zero

    table.clear(activeBalls)

    extraLifeDroppedThisLevel = false

    isPaused = false
    pausedAt = 0

    statusMessageVersion += 1

        isTransitioning = false
    pendingCompletedLevel = nil

    callbacks = {}

end

return BrickBreakerController