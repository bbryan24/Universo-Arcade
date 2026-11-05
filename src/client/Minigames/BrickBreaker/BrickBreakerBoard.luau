
--[[
    UNIVERSO ARCADE
    BrickBreakerBoard

    Construye el tablero visual de BrickBreaker.
    Genera formaciones de bloques y gestiona su resistencia.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BrickBreakerConfig = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("BrickBreakerConfig")
)

local BrickBreakerBoard = {}

local randomGenerator = Random.new()

-- COLORES DE LOS BLOQUES

local brickColors = {
    Color3.fromRGB(255, 65, 65),
    Color3.fromRGB(255, 115, 45),
    Color3.fromRGB(255, 185, 45),
    Color3.fromRGB(255, 225, 75),
    Color3.fromRGB(255, 145, 35),
}

local durabilityColors = {
    [2] = {
        [2] = Color3.fromRGB(190, 75, 255),
        [1] = Color3.fromRGB(125, 55, 190),
    },

    [3] = {
        [3] = Color3.fromRGB(50, 210, 255),
        [2] = Color3.fromRGB(40, 145, 220),
        [1] = Color3.fromRGB(35, 95, 160),
    },
}

local durabilityStrokeColors = {
    [2] = Color3.fromRGB(235, 180, 255),
    [3] = Color3.fromRGB(190, 245, 255),
}

-- ELEMENTOS VISUALES

local function createCorner(parent, radius)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent

end

local function createStroke(parent, color, thickness)

    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Parent = parent

    return stroke
end

-- ACTUALIZAR ASPECTO SEGÚN LA RESISTENCIA

local function updateBrickAppearance(data)

    local brick = data.Object
    local hitsRemaining = data.HitsRemaining
    local maxHits = data.MaxHits

    if maxHits == 1 then

        brick.BackgroundColor3 = data.NormalColor
        data.Stroke.Color = Color3.fromRGB(255, 220, 170)
        data.Stroke.Thickness = 1

        data.HitLabel.Visible = false

        return
    end

    brick.BackgroundColor3 =
        durabilityColors[maxHits][hitsRemaining]

    data.Stroke.Color = durabilityStrokeColors[maxHits]
    data.Stroke.Thickness = 2

    data.HitLabel.Text = tostring(hitsRemaining)
    data.HitLabel.Visible = true

end

-- ASIGNAR RESISTENCIA SEGÚN EL NIVEL

local function getDurabilityChances(currentLevel)

    if currentLevel <= 3 then
        return 0, 0
    end

    if currentLevel <= 5 then
        return 0.12, 0
    end

    if currentLevel <= 8 then
        return 0.18, 0.04
    end

    if currentLevel <= 12 then
        return 0.25, 0.08
    end

    return 0.30, 0.15
end

local function assignBrickDurability(data, currentLevel)

    local resistantChance, armoredChance =
        getDurabilityChances(currentLevel)

    local roll = randomGenerator:NextNumber()

    data.MaxHits = 1
    data.HitsRemaining = 1

    if roll < armoredChance then

        data.MaxHits = 3
        data.HitsRemaining = 3

    elseif roll < armoredChance + resistantChance then

        data.MaxHits = 2
        data.HitsRemaining = 2

    end

    updateBrickAppearance(data)

end

-- CREAR TABLERO

function BrickBreakerBoard.Create(parent)

    -- CONTENEDOR PRINCIPAL

    local board = Instance.new("Frame")
    board.Name = "BrickBreakerBoard"
    board.Size = UDim2.fromScale(1, 1)
    board.Position = UDim2.fromScale(0, 0)
    board.BackgroundColor3 = Color3.fromRGB(12, 10, 25)
    board.BorderSizePixel = 0
    board.ClipsDescendants = true
    board.Parent = parent

    createStroke(
        board,
        Color3.fromRGB(255, 145, 35),
        2
    )

    -- ZONA DE LADRILLOS

    local brickContainer = Instance.new("Frame")
    brickContainer.Name = "Bricks"
    brickContainer.Size = UDim2.fromScale(0.93, 0.50)
    brickContainer.Position = UDim2.fromScale(0.035, 0.06)
    brickContainer.BackgroundTransparency = 1
    brickContainer.Parent = board

    local rows = BrickBreakerConfig.Board.BrickRows
    local columns = BrickBreakerConfig.Board.BrickColumns
    local gap = 0.009

    local brickWidth = (1 - gap * (columns - 1)) / columns
    local brickHeight = 0.075
    local verticalGap = 0.025

    local bricks = {}
    local brickData = {}

    -- CREAR LOS 100 BLOQUES DISPONIBLES

    for row = 1, rows do
        for column = 1, columns do

            local brick = Instance.new("Frame")
            brick.Name = "Brick_" .. row .. "_" .. column

            brick.Size = UDim2.fromScale(
                brickWidth,
                brickHeight
            )

            brick.Position = UDim2.fromScale(
                (column - 1) * (brickWidth + gap),
                (row - 1) * (brickHeight + verticalGap)
            )

            local colorIndex = ((row - 1) % #brickColors) + 1
            local normalColor = brickColors[colorIndex]

            brick.BackgroundColor3 = normalColor
            brick.BorderSizePixel = 0
            brick.Parent = brickContainer

            createCorner(brick, 4)

            local stroke = createStroke(
                brick,
                Color3.fromRGB(255, 220, 170),
                1
            )

            -- INDICADOR DE GOLPES RESTANTES

            local hitLabel = Instance.new("TextLabel")
            hitLabel.Name = "HitsLabel"
            hitLabel.Size = UDim2.fromScale(1, 1)
            hitLabel.Position = UDim2.fromScale(0, 0)

            hitLabel.BackgroundTransparency = 1
            hitLabel.BorderSizePixel = 0

            hitLabel.Text = ""
            hitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            hitLabel.TextSize = 11
            hitLabel.Font = Enum.Font.GothamBlack

            hitLabel.TextStrokeTransparency = 0.45
            hitLabel.Visible = false

            hitLabel.ZIndex = 2
            hitLabel.Parent = brick

            local data = {
                Object = brick,
                Row = row,
                Column = column,

                NormalColor = normalColor,
                Stroke = stroke,
                HitLabel = hitLabel,

                MaxHits = 1,
                HitsRemaining = 1,
            }

            table.insert(bricks, brick)
            table.insert(brickData, data)

        end
    end

    -- GENERAR LA FORMACIÓN DE CADA NIVEL

    local function setLevel(currentLevel)

        -- RESTABLECER TODOS LOS BLOQUES

        for _, data in ipairs(brickData) do

            data.Object.Visible = false

            data.MaxHits = 1
            data.HitsRemaining = 1

            updateBrickAppearance(data)

        end

        -- NIVEL 1: DOS HILERAS COMPLETAS

        if currentLevel == 1 then

            for _, data in ipairs(brickData) do
                data.Object.Visible = data.Row <= 2
            end

            print("BrickBreaker | Nivel 1 | 20 bloques")

        -- NIVEL 2: 25 BLOQUES

        elseif currentLevel == 2 then

            for _, data in ipairs(brickData) do

                local active = data.Row <= 2

                if data.Row == 3 and data.Column % 2 == 0 then
                    active = true
                end

                data.Object.Visible = active

            end

            print("BrickBreaker | Nivel 2 | 25 bloques")

        -- NIVEL 3 EN ADELANTE: FORMACIÓN ALEATORIA

       
        -- NIVEL 3 EN ADELANTE:
        -- DESBLOQUEO PROGRESIVO DE FILAS.

        else

            -- CALCULAR CUÁNTAS FILAS ESTÁN DESBLOQUEADAS.

            local maximumRows = math.min(
                3 + math.floor((currentLevel - 2) / 2),
                rows
            )

            -- RECOPILAR SOLO LAS POSICIONES PERMITIDAS.

            local availablePositions = {}

            for _, data in ipairs(brickData) do

                if data.Row <= maximumRows then
                    table.insert(availablePositions, data)
                end

            end

            -- CAPACIDAD REAL DEL NIVEL.

            local capacity = #availablePositions

            -- DEJAR SIEMPRE ALGUNOS HUECOS EN LA FORMACIÓN.

            local maximumBricks = math.max(
                1,
                capacity - math.max(5, math.floor(capacity * 0.15))
            )

            local minimumBricks = math.min(30, maximumBricks)

            local totalBricks = randomGenerator:NextInteger(
                minimumBricks,
                maximumBricks
            )

            -- MEZCLAR SOLO LAS POSICIONES DESBLOQUEADAS.

            for index = #availablePositions, 2, -1 do

                local randomIndex = randomGenerator:NextInteger(
                    1,
                    index
                )

                availablePositions[index], availablePositions[randomIndex] =
                    availablePositions[randomIndex],
                    availablePositions[index]

            end

            -- ACTIVAR LOS BLOQUES ALEATORIOS.

            for index = 1, totalBricks do
                availablePositions[index].Object.Visible = true
            end

            print(
                "BrickBreaker | Nivel "
                    .. currentLevel
                    .. " | Filas máximas: "
                    .. maximumRows
                    .. " | Bloques: "
                    .. totalBricks
            )

        end


        -- ASIGNAR RESISTENCIA A LOS BLOQUES ACTIVOS

        local resistantCount = 0
        local armoredCount = 0

        for _, data in ipairs(brickData) do

            if data.Object.Visible then

                assignBrickDurability(data, currentLevel)

                if data.MaxHits == 2 then
                    resistantCount += 1
                elseif data.MaxHits == 3 then
                    armoredCount += 1
                end

            end

        end

        print(
            "BrickBreaker | Resistentes: "
                .. resistantCount
                .. " | Blindados: "
                .. armoredCount
        )

    end

    -- APLICAR UN IMPACTO A UN BLOQUE

    local function damageBrick(brick)

        for _, data in ipairs(brickData) do

            if data.Object == brick then

                if not brick.Visible then
                    return false
                end

                data.HitsRemaining -= 1

                -- EL BLOQUE SE DESTRUYE

                if data.HitsRemaining <= 0 then

                    brick.Visible = false
                    data.HitLabel.Visible = false

                    return true
                end

                -- EL BLOQUE SIGUE ACTIVO:
                -- ACTUALIZAR SU ASPECTO

                updateBrickAppearance(data)

                return false

            end

        end

        return false
    end

    -- PALA

    local paddle = Instance.new("Frame")
    paddle.Name = "Paddle"

    paddle.Size = UDim2.fromScale(
        BrickBreakerConfig.Paddle.WidthScale,
        BrickBreakerConfig.Paddle.HeightScale
    )

    paddle.Position = UDim2.fromScale(0.5, 0.91)
    paddle.AnchorPoint = Vector2.new(0.5, 0.5)

    paddle.BackgroundColor3 = Color3.fromRGB(255, 165, 55)
    paddle.BorderSizePixel = 0
    paddle.Parent = board

    createCorner(paddle, 6)

    createStroke(
        paddle,
        Color3.fromRGB(255, 220, 160),
        2
    )

    -- PELOTA

    local ball = Instance.new("Frame")
    ball.Name = "Ball"
    ball.Size = UDim2.fromOffset(14, 14)
    ball.Position = UDim2.fromScale(0.5, 0.86)
    ball.AnchorPoint = Vector2.new(0.5, 0.5)

    ball.BackgroundColor3 = Color3.fromRGB(255, 245, 220)
    ball.BorderSizePixel = 0
    ball.Parent = board

    createCorner(ball, 50)

    createStroke(
        ball,
        Color3.fromRGB(255, 175, 75),
        1
    )

    -- DEVOLVER ELEMENTOS

    return {
        Board = board,
        BrickContainer = brickContainer,
        Bricks = bricks,
        Paddle = paddle,
        Ball = ball,

        SetLevel = setLevel,
        DamageBrick = damageBrick,
    }

end

return BrickBreakerBoard
