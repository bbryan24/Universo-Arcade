
--[[
    UNIVERSO ARCADE
    BubbleShooterBoard

    Construye la interfaz visual de BubbleShooter.

    Primera versión:
    - Tablero vertical.
    - Filas alternas de burbujas.
    - Burbujas de colores.
    - Lanzador inferior.
    - Interfaz básica de puntuación y nivel.

    La lógica de disparo se implementará
    en BubbleShooterController.
]]

local ReplicatedStorage =
    game:GetService("ReplicatedStorage")

local BubbleShooterConfig = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("BubbleShooterConfig")
)

local BubbleShooterBoard = {}

--==================================================
-- COLORES DE LA INTERFAZ
--==================================================

local COLORS = {

    Background = Color3.fromRGB(10, 15, 29),

    Playfield = Color3.fromRGB(18, 27, 46),

    Border = Color3.fromRGB(68, 120, 165),

    White = Color3.fromRGB(235, 245, 255),

    Secondary = Color3.fromRGB(135, 165, 200),

    Accent = Color3.fromRGB(235, 95, 175),

}

--==================================================
-- CREAR ELEMENTOS DE INTERFAZ
--==================================================

local function create(className, properties, parent)

    local instance = Instance.new(className)

    for property, value in pairs(properties) do
        instance[property] = value
    end

    instance.Parent = parent

    return instance

end

--==================================================
-- CREAR BURBUJA VISUAL
--==================================================

local function createBubble(parent, color, size, position)

    local bubble = create("Frame", {

        Name = "Bubble",

        AnchorPoint = Vector2.new(0.5, 0.5),

        Position = position,

        Size = UDim2.fromScale(size, size),

        BackgroundColor3 = color,

        BorderSizePixel = 0,

        ZIndex = 3,

    }, parent)

    create("UIAspectRatioConstraint", {

        AspectRatio = 1,

    }, bubble)

    create("UICorner", {

        CornerRadius = UDim.new(0.5, 0),

    }, bubble)

    create("UIStroke", {

        Color = Color3.fromRGB(225, 240, 255),

        Transparency = 0.5,

        Thickness = 1.5,

    }, bubble)

    -- REFLEJO SUPERIOR PARA DAR VOLUMEN.

    local highlight = create("Frame", {

        Name = "Highlight",

        AnchorPoint = Vector2.new(0.5, 0),

        Position = UDim2.fromScale(0.38, 0.13),

        Size = UDim2.fromScale(0.35, 0.16),

        BackgroundColor3 = Color3.fromRGB(
            255, 255, 255
        ),

        BackgroundTransparency = 0.55,

        BorderSizePixel = 0,

        ZIndex = 4,

    }, bubble)

    create("UICorner", {

        CornerRadius = UDim.new(1, 0),

    }, highlight)

    return bubble

end

--==================================================
-- CONSTRUIR TABLERO
--==================================================

function BubbleShooterBoard.Create(parent)

    local config = BubbleShooterConfig

    -- CONTENEDOR PRINCIPAL.

    local container = create("Frame", {

        Name = "BubbleShooterContainer",

        Size = UDim2.fromScale(1, 1),

        BackgroundColor3 = COLORS.Background,

        BorderSizePixel = 0,

        ClipsDescendants = true,

    }, parent)

    --==================================================
    -- CABECERA
    --==================================================

    local title = create("TextLabel", {

        Name = "Title",

        Position = UDim2.fromScale(0.05, 0.015),

        Size = UDim2.fromScale(0.9, 0.055),

        BackgroundTransparency = 1,

        Text = "BUBBLE SHOOTER",

        TextColor3 = COLORS.Accent,

        Font = Enum.Font.Arcade,

        TextScaled = true,

    }, container)

    --==================================================
    -- TABLERO CENTRAL
    --==================================================

    local playfield = create("Frame", {

        Name = "Playfield",

        AnchorPoint = Vector2.new(0.5, 0.5),

        Position = UDim2.fromScale(0.5, 0.515),

        Size = UDim2.fromScale(0.66, 0.84),

        BackgroundColor3 = COLORS.Playfield,

        BorderSizePixel = 0,

        ClipsDescendants = true,

    }, container)

    create("UIAspectRatioConstraint", {

        AspectRatio = 0.68,

        DominantAxis = Enum.DominantAxis.Height,

    }, playfield)

    create("UIStroke", {

        Color = COLORS.Border,

        Thickness = 2,

    }, playfield)

    create("UICorner", {

        CornerRadius = UDim.new(0, 6),

    }, playfield)

    --==================================================
    -- FILAS INICIALES DE BURBUJAS
    --==================================================

    local bubbles = {}

    local columns = config.Board.Columns

    local initialRows = config.Board.InitialRows

    local bubbleSize = 0.108

    local horizontalStep = 0.115

    local verticalStep = 0.067

    for row = 1, initialRows do

        bubbles[row] = {}

        -- LAS FILAS PARES TIENEN UNA BURBUJA MENOS
        -- PARA FORMAR LA DISTRIBUCIÓN HEXAGONAL.

        local rowColumns = columns

        if row % 2 == 0 then
            rowColumns = columns - 1
        end

        for column = 1, rowColumns do

            local colorIndex = math.random(
                1,
                #config.Colors
            )

            local color = config.Colors[colorIndex]

            local x =
                0.5
                + (column - (rowColumns + 1) / 2)
                * horizontalStep

            local y =
                0.055
                + (row - 1) * verticalStep

            local bubble = createBubble(
                playfield,
                color,
                bubbleSize,
                UDim2.fromScale(x, y)
            )

            bubble.Name =
                "Bubble_" .. row .. "_" .. column

            bubbles[row][column] = bubble

        end
    end

    --==================================================
    -- LANZADOR INFERIOR
    --==================================================

    local launcher = create("Frame", {

        Name = "Launcher",

        AnchorPoint = Vector2.new(0.5, 1),

        Position = UDim2.fromScale(0.5, 0.98),

        Size = UDim2.fromScale(0.045, 0.14),

        BackgroundColor3 = COLORS.Accent,

        BorderSizePixel = 0,

        Rotation = 0,

        ZIndex = 5,

    }, playfield)

    create("UICorner", {

        CornerRadius = UDim.new(0, 6),

    }, launcher)

    create("UIStroke", {

        Color = COLORS.White,

        Thickness = 1.5,

    }, launcher)

    -- BURBUJA PREPARADA PARA DISPARAR.

    local loadedBubble = createBubble(
        playfield,
        config.Colors[2],
        bubbleSize,
        UDim2.fromScale(0.5, 0.89)
    )

    loadedBubble.Name = "LoadedBubble"

    --==================================================
    -- MARCADORES
    --==================================================

    local scoreLabel = create("TextLabel", {

        Name = "ScoreLabel",

        Position = UDim2.fromScale(0.025, 0.18),

        Size = UDim2.fromScale(0.15, 0.1),

        BackgroundTransparency = 1,

        Text = "SCORE\n0",

        TextColor3 = COLORS.White,

        Font = Enum.Font.GothamBold,

        TextScaled = true,

    }, container)

    local levelLabel = create("TextLabel", {

        Name = "LevelLabel",

        Position = UDim2.fromScale(0.825, 0.18),

        Size = UDim2.fromScale(0.15, 0.1),

        BackgroundTransparency = 1,

        Text = "LEVEL\n1",

        TextColor3 = COLORS.White,

        Font = Enum.Font.GothamBold,

        TextScaled = true,

    }, container)

    local instructions = create("TextLabel", {

        Name = "Instructions",

        AnchorPoint = Vector2.new(0.5, 1),

        Position = UDim2.fromScale(0.5, 0.985),

        Size = UDim2.fromScale(0.9, 0.04),

        BackgroundTransparency = 1,

        Text = "A / D  -  APUNTAR     ESPACIO  -  DISPARAR",

        TextColor3 = COLORS.Secondary,

        Font = Enum.Font.GothamBold,

        TextScaled = true,

    }, container)

    --==================================================
    -- DEVOLVER ELEMENTOS AL CONTROLADOR
    --==================================================

    return {

        Container = container,

        Playfield = playfield,

        Bubbles = bubbles,

        Launcher = launcher,

        LoadedBubble = loadedBubble,

        ScoreLabel = scoreLabel,

        LevelLabel = levelLabel,

        Instructions = instructions,

        Title = title,

    }

end

return BubbleShooterBoard
