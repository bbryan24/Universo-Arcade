
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
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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

-- ESTADO DE LA PARTIDA

local boardElements = nil
local gameConnection = nil
local inputStarted = false

local score = 0
local lives = 0
local level = 1

local gameStarted = false
local gameOver = false

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

local keyboardButton = nil
local mouseButton = nil
local modeButtons = nil

local developerInterface = nil

local lastHitBrick = nil


-- POWER-UPS

local fallingPowerUps = {}
local powerUpRandom = Random.new()

local basePaddleSize = nil

local paddleWideUntil = 0
local slowBallUntil = 0
local shieldUntil = 0
local fireballUntil = 0

local extraLifeDroppedThisLevel = false

local statusMessageVersion = 0

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
}


-- PROGRESIÓN DE VELOCIDAD

local function getSpeedForLevel(targetLevel)

    local speed = BrickBreakerConfig.Ball.SpeedByLevel[targetLevel]

    if speed then
        return speed
    end

    -- A partir del nivel 13 se mantiene la velocidad máxima.

    return BrickBreakerConfig.Ball.MaximumSpeed
end

-- COLORES

local ORANGE = Color3.fromRGB(255, 165, 55)
local WHITE = Color3.fromRGB(255, 245, 220)
local DARK = Color3.fromRGB(25, 17, 35)

-- INTERFAZ

local function createLabel(parent, name, text, position, size, textSize)

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

local function updateHUD()

    -- HUD dentro de la pantalla de juego.

    if scoreLabel then
        scoreLabel.Text = "PUNTOS: " .. score
    end

    if livesLabel then
        livesLabel.Text = "VIDAS: " .. lives
    end

    if levelLabel then
        levelLabel.Text = "NIVEL: " .. level
    end

    -- Estadísticas del panel inferior de la recreativa.

    if machineScoreValue then
        machineScoreValue.Text = tostring(score)
    end

    if machineLevelValue then
        machineLevelValue.Text = tostring(level)
    end

    -- El récord se implementará más adelante.
    if machineBestValue then
        machineBestValue.Text = "--"
    end
end

local function updateControlButtons()

    if not keyboardButton or not mouseButton then
        return
    end

    if activeMode == "Keyboard" then

        keyboardButton.BackgroundColor3 = ORANGE
        keyboardButton.TextColor3 = DARK

        mouseButton.BackgroundColor3 = Color3.fromRGB(45, 35, 55)
        mouseButton.TextColor3 = WHITE

    else

        mouseButton.BackgroundColor3 = ORANGE
        mouseButton.TextColor3 = DARK

        keyboardButton.BackgroundColor3 = Color3.fromRGB(45, 35, 55)
        keyboardButton.TextColor3 = WHITE
    end
end


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

    task.delay(BrickBreakerConfig.PowerUps.MessageDuration, function()

        if currentVersion ~= statusMessageVersion then
            return
        end

        if statusLabel and statusLabel.Parent then
            statusLabel.Text = ""
        end

    end)
end



-- SISTEMA DE POWER-UPS

local function clearFallingPowerUps()

    for _, powerUp in ipairs(fallingPowerUps) do

        if powerUp.Object and powerUp.Object.Parent then
            powerUp.Object:Destroy()
        end

    end

    table.clear(fallingPowerUps)
end

local function getEffectiveBallSpeed()

    local multiplier = 1

    if os.clock() < slowBallUntil then
        multiplier = BrickBreakerConfig.PowerUps.SlowBallMultiplier
    end

    return currentSpeed * multiplier
end

-- SELECCIONAR POWER-UP SEGÚN SUS PROBABILIDADES

local function selectPowerUpType()

    local weights = BrickBreakerConfig.PowerUps.DropWeights
    local availableTypes = {}
    local totalWeight = 0

    for _, powerUpType in ipairs(POWER_UP_TYPES) do

        local weight = weights[powerUpType.Id] or 0

        -- Solo una vida extra puede aparecer por nivel.
        if powerUpType.Id == "ExtraLife" and extraLifeDroppedThisLevel then
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

-- CREAR UN POWER-UP AL DESTRUIR UN BLOQUE

local function spawnPowerUp(worldPosition)

    if not boardElements then
        return
    end

    local config = BrickBreakerConfig.PowerUps

    if powerUpRandom:NextNumber() > config.DropChance then
        return
    end

    local selectedType = selectPowerUpType()

    if not selectedType then
        return
    end

    -- Reservar la vida extra desde el momento en que aparece.
    if selectedType.Id == "ExtraLife" then
        extraLifeDroppedThisLevel = true
    end

    local board = boardElements.Board

    local localPosition = worldPosition - board.AbsolutePosition

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

-- CREAR PELOTAS ADICIONALES

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

    local sourceVelocity = activeBalls[1] and activeBalls[1].Velocity

    if not sourceVelocity or sourceVelocity.Magnitude <= 0 then
        return
    end

    local sourceBall = activeBalls[1].Object

    local sourcePosition =
        sourceBall.AbsolutePosition + sourceBall.AbsoluteSize / 2

    local board = boardElements.Board

    local localPosition = sourcePosition - board.AbsolutePosition

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
        })

    end
end

-- ACTIVAR POWER-UP

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

        showTimedStatus("¡+" .. config.ScoreBonusPoints .. " PUNTOS!")

    elseif powerUpType == "Shield" then

        if shieldUntil > now then

            -- Un escudo adicional se convierte en puntos.
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

    end

end

-- ACTUALIZAR EFECTOS TEMPORALES

local function updatePowerUpEffects()

    if not boardElements then
        return
    end

    local now = os.clock()

    -- PALA AMPLIADA

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

    -- CADUCIDAD DEL ESCUDO

    if shieldUntil > 0 and now >= shieldUntil then

        shieldUntil = 0

        score += BrickBreakerConfig.PowerUps.ShieldExpiredPoints

        updateHUD()

        showTimedStatus("¡ESCUDO CADUCADO: +100 PUNTOS!")

    end

    -- ACTUALIZAR VELOCIDAD DE TODAS LAS PELOTAS

    if gameStarted then

        local targetSpeed = getEffectiveBallSpeed()

        for _, ballData in ipairs(activeBalls) do

            if ballData.Velocity.Magnitude > 0 then

                if math.abs(ballData.Velocity.Magnitude - targetSpeed) > 0.01 then

                    ballData.Velocity =
                        ballData.Velocity.Unit * targetSpeed

                end

            end

        end

    end

end

-- MOVIMIENTO Y RECOGIDA DE POWER-UPS

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

        -- COMPROBAR COLISIÓN CON LA PALA

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

            activatePowerUp(powerUp.Type)

            object:Destroy()

            table.remove(fallingPowerUps, index)

        elseif center.Y - radius > boardBottom then

            object:Destroy()

            table.remove(fallingPowerUps, index)

        end

    end

end


-- POSICIONAMIENTO DE LA PELOTA

local function positionBallOnPaddle()

    if not boardElements then
        return
    end

    local board = boardElements.Board
    local paddle = boardElements.Paddle
    local ball = boardElements.Ball

    if board.AbsoluteSize.X <= 0 or board.AbsoluteSize.Y <= 0 then
        return
    end

    local paddleY =
        paddle.Position.Y.Scale * board.AbsoluteSize.Y
        + paddle.Position.Y.Offset

    local paddleHeight = paddle.AbsoluteSize.Y
    local ballRadius = ball.AbsoluteSize.X / 2

    local ballX =
        paddle.Position.X.Scale * board.AbsoluteSize.X
        + paddle.Position.X.Offset

    local ballY = paddleY - paddleHeight / 2 - ballRadius - 2

    ball.Position = UDim2.fromOffset(ballX, ballY)
end

-- REINICIAR POSICIÓN DE LA PELOTA


local function resetBall()

    gameStarted = false
    ballVelocity = Vector2.zero

    -- ELIMINAR LAS PELOTAS ADICIONALES.

    for _, ballData in ipairs(activeBalls) do

        if not ballData.IsMain
            and ballData.Object
            and ballData.Object.Parent then

            ballData.Object:Destroy()

        end

    end

    table.clear(activeBalls)

    -- RECUPERAR LA PELOTA PRINCIPAL.

    if boardElements then

        local mainBall = boardElements.Ball

        mainBall.Visible = true

        table.insert(activeBalls, {
            Object = mainBall,
            Velocity = Vector2.zero,
            LastHitBrick = nil,
            IsMain = true,
        })

    end

    -- LIMPIAR POWER-UPS PENDIENTES.

    clearFallingPowerUps()

    -- RESTABLECER EFECTOS TEMPORALES.

    paddleWideUntil = 0
    slowBallUntil = 0
    shieldUntil = 0
    fireballUntil = 0

    if boardElements and basePaddleSize then
        boardElements.Paddle.Size = basePaddleSize
    end

    positionBallOnPaddle()

    setStatus("PULSA ESPACIO O HAZ CLIC PARA JUGAR")

end


-- REINICIAR LADRILLOS

local function restoreBricks()

    if not boardElements then
        return
    end

    -- Aplicar la formación correspondiente al nivel actual.
    if boardElements.SetLevel then
        boardElements.SetLevel(level)
    else
        -- Compatibilidad por si el tablero todavía no tiene SetLevel.
        for _, brick in ipairs(boardElements.Bricks) do

            if brick and brick.Parent then
                brick.Visible = true
            end
        end
    end
end

-- PREPARAR UNA NUEVA PARTIDA

local function resetGame()

    score = 0
    lives = BrickBreakerConfig.Game.InitialLives
    level = 1
    extraLifeDroppedThisLevel = false

    currentSpeed = BrickBreakerConfig.Ball.InitialSpeed

    gameOver = false
    gameStarted = false

    restoreBricks()
    updateHUD()
    resetBall()
end

-- LANZAMIENTO

local function launchBall()

    if gameOver then
        resetGame()
        return
    end

    if gameStarted then
        return
    end

    gameStarted = true

    -- Lanzamiento diagonal inicial.

    local direction = Vector2.new(0.55, -0.84).Unit

ballVelocity = direction * getEffectiveBallSpeed()

    if activeBalls[1] then
        activeBalls[1].Velocity = ballVelocity
    end

    setStatus("")
end

-- COLISIÓN CON LADRILLOS


-- COLISIÓN CON LADRILLOS


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

                        destroyed = boardElements.DamageBrick(brick)

                    else

                        brick.Visible = false
                        destroyed = true

                    end

                    ballData.LastHitBrick = brick

                    if destroyed then

                        score += BrickBreakerConfig.Game.PointsPerBrick

                        updateHUD()

                        spawnPowerUp(brickCenter)

                    end

                    return true

                end

            end

        end

    end

    if ballData.LastHitBrick and not lastHitBrickStillOverlapping then
        ballData.LastHitBrick = nil
    end

    return false
end



-- COLISIÓN CON LA PALA

-- COLISIÓN CON LA PALA

local function handlePaddleCollision(ballPosition, radius, ballData)

    local paddle = boardElements.Paddle

    local paddlePosition = paddle.AbsolutePosition
    local paddleSize = paddle.AbsoluteSize

    local ballBottom = ballPosition.Y + radius

    local paddleTop = paddlePosition.Y

    local overlapsX =
        ballPosition.X + radius >= paddlePosition.X
        and ballPosition.X - radius <= paddlePosition.X + paddleSize.X

    local overlapsY =
        ballBottom >= paddleTop
        and ballPosition.Y - radius <= paddlePosition.Y + paddleSize.Y

    if overlapsX and overlapsY and ballData.Velocity.Y > 0 then

        local paddleCenter = paddlePosition.X + paddleSize.X / 2

        local relativeHit =
            (ballPosition.X - paddleCenter) / (paddleSize.X / 2)

        relativeHit = math.clamp(relativeHit, -0.85, 0.85)

        local direction = Vector2.new(relativeHit, -0.9).Unit

        ballData.Velocity = direction * getEffectiveBallSpeed()

        return true
    end

    return false
end

-- COMPROBAR SI QUEDAN LADRILLOS

local function checkLevelCompleted()

    for _, brick in ipairs(boardElements.Bricks) do

        if brick and brick.Parent and brick.Visible then
            return false
        end
    end

    return true
end

-- COMPLETAR NIVEL

local function completeLevel()

    -- Guardar el nivel que acabamos de superar.
    local completedLevel = level

    -- Preparar el siguiente nivel.
    level += 1
    extraLifeDroppedThisLevel = false

    score += BrickBreakerConfig.Game.PointsPerLevel

    currentSpeed = getSpeedForLevel(level)

    restoreBricks()

    updateHUD()

    resetBall()

    -- Mostrar el nivel que realmente hemos completado.
    setStatus("¡NIVEL " .. completedLevel .. " COMPLETADO!")
end

-- PERDER UNA VIDA

local function loseLife()

    lives -= 1

    updateHUD()

    if lives <= 0 then

        gameStarted = false
        gameOver = true

        ballVelocity = Vector2.zero

        setStatus("GAME OVER - PULSA ESPACIO PARA REINICIAR")

        return
    end

    resetBall()

    setStatus("HAS PERDIDO UNA VIDA")
end

-- ACTUALIZACIÓN DE LA PELOTA



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

    -- ACTUALIZAR TODAS LAS PELOTAS.

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

        -- MOVIMIENTO.

        ballPosition += ballData.Velocity * deltaTime

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

        -- COLISIÓN CON LOS LADRILLOS.

        local hitBrick = handleBrickCollision(
            ballPosition,
            radius,
            ballData
        )

        -- LA BOLA DE FUEGO ATRAVIESA LOS LADRILLOS.

        if hitBrick and not isFireball then

            ballData.Velocity = Vector2.new(
                ballData.Velocity.X,
                -ballData.Velocity.Y
            )

        end

        -- COMPROBAR SI LA PELOTA HA CAÍDO.

        if ballPosition.Y - radius > bottom then

            -- ESCUDO: SALVAR UNA PELOTA.

            if shieldUntil > os.clock() then

                shieldUntil = 0

                ballPosition = Vector2.new(
                    ballPosition.X,
                    bottom - radius
                )

                ballData.Velocity = Vector2.new(
                    ballData.Velocity.X,
                    -math.abs(ballData.Velocity.Y)
                )

                showTimedStatus("¡ESCUDO ACTIVADO: PELOTA SALVADA!")

            else

                -- PERDER ESTA PELOTA.

                table.remove(activeBalls, index)

                if ballData.IsMain then

                    ball.Visible = false

                else

                    ball:Destroy()

                end

                -- SOLO SE PIERDE UNA VIDA
                -- CUANDO NO QUEDA NINGUNA PELOTA.

                if #activeBalls == 0 then

                    loseLife()
                    return

                end

                continue

            end

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


-- SELECTOR DE CONTROLES

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

        button.BackgroundColor3 = Color3.fromRGB(45, 35, 55)
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


-- HERRAMIENTAS DE DESARROLLADOR

local function jumpToLevel(targetLevel)

    if not RunService:IsStudio() then
        return
    end

    targetLevel = math.floor(tonumber(targetLevel) or 0)

    if targetLevel < 1 then
        return
    end

    -- Cambiar el nivel sin modificar la puntuación.

    level = targetLevel
    extraLifeDroppedThisLevel = false

    -- Recuperar las vidas si la partida estaba terminada.

    if lives <= 0 then
        lives = BrickBreakerConfig.Game.InitialLives
    end

    gameOver = false

    -- Aplicar la velocidad correspondiente al nivel.

    currentSpeed = getSpeedForLevel(level)

    -- Generar los ladrillos del nivel seleccionado.

    restoreBricks()

    updateHUD()

    -- Dejar la pelota preparada para comenzar.

    resetBall()

    print(
        "BrickBreaker DEV | Salto al nivel "
            .. level
            .. " | Velocidad: "
            .. currentSpeed
    )
end

local function createDeveloperTools(parent)

    -- Esta interfaz no existe fuera de Roblox Studio.

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

    -- BOTÓN DEV

    local devButton = Instance.new("TextButton")
    devButton.Name = "DevButton"
    devButton.Size = UDim2.fromScale(0.12, 0.065)
    devButton.Position = UDim2.fromScale(0.75, 0.005)

    devButton.BackgroundColor3 = Color3.fromRGB(115, 55, 190)
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

    -- PANEL DE DESARROLLADOR

    local panel = Instance.new("Frame")
    panel.Name = "LevelPanel"
    panel.Size = UDim2.fromScale(0.25, 0.23)
    panel.Position = UDim2.fromScale(0.72, 0.08)

    panel.BackgroundColor3 = Color3.fromRGB(25, 17, 40)
    panel.BorderSizePixel = 0

    panel.Visible = false
    panel.ZIndex = 22
    panel.Parent = container

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 8)
    panelCorner.Parent = panel

    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(180, 100, 255)
    panelStroke.Thickness = 2
    panelStroke.Parent = panel

    -- TÍTULO

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.fromScale(0.9, 0.22)
    title.Position = UDim2.fromScale(0.05, 0.04)

    title.BackgroundTransparency = 1
    title.Text = "SALTAR A NIVEL"
    title.TextColor3 = WHITE
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold

    title.ZIndex = 23
    title.Parent = panel

    -- CAMPO DEL NIVEL

    local levelInput = Instance.new("TextBox")
    levelInput.Name = "LevelInput"
    levelInput.Size = UDim2.fromScale(0.42, 0.25)
    levelInput.Position = UDim2.fromScale(0.29, 0.31)

    levelInput.BackgroundColor3 = Color3.fromRGB(45, 35, 60)
    levelInput.BorderSizePixel = 0

    levelInput.Text = "16"
    levelInput.PlaceholderText = "Nivel"
    levelInput.TextColor3 = WHITE
    levelInput.PlaceholderColor3 = Color3.fromRGB(170, 160, 180)

    levelInput.TextSize = 17
    levelInput.Font = Enum.Font.GothamBold
    levelInput.ClearTextOnFocus = false

    levelInput.ZIndex = 23
    levelInput.Parent = panel

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = levelInput

    -- BOTONES DECREMENTAR E INCREMENTAR

    local function createPanelButton(name, text, position, size)

        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = size
        button.Position = position

        button.BackgroundColor3 = Color3.fromRGB(65, 45, 85)
        button.BorderSizePixel = 0

        button.Text = text
        button.TextColor3 = WHITE
        button.TextSize = 15
        button.Font = Enum.Font.GothamBold

        button.ZIndex = 23
        button.Parent = panel

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = button

        return button
    end

    local minusButton = createPanelButton(
        "MinusButton",
        "-",
        UDim2.fromScale(0.08, 0.31),
        UDim2.fromScale(0.17, 0.25)
    )

    local plusButton = createPanelButton(
        "PlusButton",
        "+",
        UDim2.fromScale(0.75, 0.31),
        UDim2.fromScale(0.17, 0.25)
    )

    -- BOTÓN SALTAR

    local jumpButton = createPanelButton(
        "JumpButton",
        "SALTAR",
        UDim2.fromScale(0.12, 0.66),
        UDim2.fromScale(0.76, 0.25)
    )

    jumpButton.BackgroundColor3 = Color3.fromRGB(145, 75, 220)
    jumpButton.TextSize = 13

    -- FUNCIONES DE LOS BOTONES

    minusButton.Activated:Connect(function()

        local value = math.floor(tonumber(levelInput.Text) or 1)

        levelInput.Text = tostring(math.max(1, value - 1))

    end)

    plusButton.Activated:Connect(function()

        local value = math.floor(tonumber(levelInput.Text) or 1)

        levelInput.Text = tostring(value + 1)

    end)

    jumpButton.Activated:Connect(function()

        local targetLevel = tonumber(levelInput.Text)

        if not targetLevel or targetLevel < 1 then
            levelInput.Text = "1"
            return
        end

        jumpToLevel(targetLevel)

        panel.Visible = false

    end)

    devButton.Activated:Connect(function()

        panel.Visible = not panel.Visible

    end)
end


-- INICIAR CONTROLADOR

function BrickBreakerController.Start(parent)

    if boardElements then
        BrickBreakerController.Stop()
    end

    -- CREAR TABLERO CON EL MÓDULO EXISTENTE

    boardElements = BrickBreakerBoard.Create(parent)

local board = boardElements.Board

basePaddleSize = boardElements.Paddle.Size

    paddleWideUntil = 0
    slowBallUntil = 0
    shieldUntil = 0
    fireballUntil = 0

extraLifeDroppedThisLevel = false

table.clear(activeBalls)

-- CONECTAR ESTADÍSTICAS DE LA RECREATIVA

local cabinet = parent.Parent
local statsPanel = cabinet and cabinet:FindFirstChild("StatsPanel")

if statsPanel then

    machineScoreValue = statsPanel:FindFirstChild("ScoreValue")
    machineLevelValue = statsPanel:FindFirstChild("LevelValue")
    machineBestValue = statsPanel:FindFirstChild("BestValue")

else

    warn("BrickBreaker: No se encontró StatsPanel en la recreativa.")

end

-- RESERVAR ESPACIO PARA LOS CONTROLES
-- TABLERO MÁS ESTRECHO Y ALTO.

board.Position = UDim2.fromScale(0.14, 0.08)
board.Size = UDim2.fromScale(0.72, 0.92)

    -- HUD

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

    -- SELECTOR DE CONTROLES

    createControlSelector(parent)

    -- HERRAMIENTAS DE DESARROLLADOR

    createDeveloperTools(parent)

    -- INICIAR INPUT

    BrickBreakerInput.Start(
        board,
        boardElements.Paddle,
        launchBall
    )

    inputStarted = true

    -- PREPARAR PARTIDA

    resetGame()

    -- ACTUALIZACIÓN CONTINUA

    gameConnection = RunService.Heartbeat:Connect(function(deltaTime)

    if boardElements and not gameOver then

        local safeDeltaTime = math.min(deltaTime, 0.033)

            updatePowerUpEffects()

            updateFallingPowerUps(safeDeltaTime)

            updateBall(safeDeltaTime)

        end

    end)
end

-- DETENER CONTROLADOR

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

    clearFallingPowerUps()

    paddleWideUntil = 0
    slowBallUntil = 0

    basePaddleSize = nil

    if boardElements and boardElements.Board then
        boardElements.Board:Destroy()
    end

    boardElements = nil
   

    scoreLabel = nil
    livesLabel = nil
    levelLabel = nil
    statusLabel = nil

    machineScoreValue = nil
    machineLevelValue = nil
    machineBestValue = nil

    keyboardButton = nil
    mouseButton = nil

    score = 0
    lives = 0
    level = 1

    gameStarted = false
    gameOver = false

    ballVelocity = Vector2.zero

    table.clear(activeBalls)

shieldUntil = 0
fireballUntil = 0

extraLifeDroppedThisLevel = false
statusMessageVersion += 1

end

return BrickBreakerController
