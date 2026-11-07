
--[[
    UNIVERSO ARCADE
    BlockPuzzleBoard

    Construye los elementos visuales
    del tablero de BlockPuzzle.
]]

local BlockPuzzleBoard = {}
local RunService = game:GetService("RunService")

-- COLORES

local COLORS = {
    Background = Color3.fromRGB(12, 10, 25),
    Board = Color3.fromRGB(8, 12, 24),
    EmptyCell = Color3.fromRGB(19, 25, 42),
    Border = Color3.fromRGB(65, 95, 135),
    White = Color3.fromRGB(235, 240, 255),
    Secondary = Color3.fromRGB(130, 155, 190),
}

-- CREAR ETIQUETAS

local function createLabel(parent, name, text, size, position, textSize, color)

    local label = Instance.new("TextLabel")

    label.Name = name
    label.Text = text

    label.Size = size
    label.Position = position

    label.BackgroundTransparency = 1

    label.TextColor3 = color or COLORS.White
    label.Font = Enum.Font.Arcade
    label.TextSize = textSize

    label.TextScaled = false
    label.TextWrapped = true

    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center

    label.Parent = parent

    return label
end

-- CREAR CONTENEDORES LATERALES

local function createPanel(parent, name, position, size)

    local panel = Instance.new("Frame")

    panel.Name = name
    panel.Position = position
    panel.Size = size

    panel.BackgroundColor3 = COLORS.Background
    panel.BorderSizePixel = 0

    panel.Parent = parent

    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.Border
    stroke.Thickness = 2
    stroke.Parent = panel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = panel

    return panel
end

-- CREAR TABLERO

function BlockPuzzleBoard.Create(parent)

    -- CONTENEDOR PRINCIPAL

    local container = Instance.new("Frame")

    container.Name = "BlockPuzzleBoard"
    container.Size = UDim2.fromScale(1, 1)

    container.BackgroundColor3 = COLORS.Background
    container.BorderSizePixel = 0

    container.Parent = parent

    -- PANEL IZQUIERDO

    local leftPanel = createPanel(
        container,
        "LeftPanel",
        UDim2.fromScale(0.035, 0.05),
        UDim2.fromScale(0.245, 0.90)
    )

    createLabel(
        leftPanel,
        "HoldTitle",
        "HOLD",
        UDim2.fromScale(0.9, 0.10),
        UDim2.fromScale(0.05, 0.02),
        15,
        COLORS.White
    )

    local holdPreview = createPanel(
        leftPanel,
        "HoldPreview",
        UDim2.fromScale(0.08, 0.13),
        UDim2.fromScale(0.84, 0.19)
    )

    -- ESTADÍSTICAS

    createLabel(
        leftPanel,
        "ScoreTitle",
        "SCORE",
        UDim2.fromScale(0.9, 0.07),
        UDim2.fromScale(0.05, 0.40),
        13,
        COLORS.Secondary
    )

    local scoreLabel = createLabel(
        leftPanel,
        "ScoreValue",
        "0",
        UDim2.fromScale(0.9, 0.08),
        UDim2.fromScale(0.05, 0.47),
        17,
        COLORS.White
    )

    createLabel(
        leftPanel,
        "LevelTitle",
        "LEVEL",
        UDim2.fromScale(0.9, 0.07),
        UDim2.fromScale(0.05, 0.61),
        13,
        COLORS.Secondary
    )

    local levelLabel = createLabel(
        leftPanel,
        "LevelValue",
        "1",
        UDim2.fromScale(0.9, 0.08),
        UDim2.fromScale(0.05, 0.68),
        17,
        COLORS.White
    )

    createLabel(
        leftPanel,
        "LinesTitle",
        "LINES",
        UDim2.fromScale(0.9, 0.07),
        UDim2.fromScale(0.05, 0.81),
        13,
        COLORS.Secondary
    )

    local linesLabel = createLabel(
        leftPanel,
        "LinesValue",
        "0",
        UDim2.fromScale(0.9, 0.08),
        UDim2.fromScale(0.05, 0.88),
        17,
        COLORS.White
    )

    -- TABLERO CENTRAL

    local boardFrame = Instance.new("Frame")

    boardFrame.Name = "Grid"
    boardFrame.Position = UDim2.fromScale(0.375, 0.05)
    boardFrame.Size = UDim2.fromScale(0.25, 0.90)

    boardFrame.BackgroundColor3 = COLORS.Board
    boardFrame.BorderSizePixel = 0

    boardFrame.ClipsDescendants = true
    boardFrame.Parent = container

    local boardStroke = Instance.new("UIStroke")
    boardStroke.Color = COLORS.Border
    boardStroke.Thickness = 2
    boardStroke.Parent = boardFrame

    -- CUADRÍCULA

    local gridLayout = Instance.new("UIGridLayout")

    gridLayout.Name = "CellLayout"
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

    gridLayout.CellSize = UDim2.new(0.1, -1, 0.05, -1)
    gridLayout.CellPadding = UDim2.fromOffset(1, 1)

    gridLayout.Parent = boardFrame

    -- CASILLAS VACÍAS

    local cells = {}

    for index = 1, 200 do

        local cell = Instance.new("Frame")

        cell.Name = "Cell_" .. index
        cell.LayoutOrder = index

        cell.BackgroundColor3 = COLORS.EmptyCell
        cell.BorderSizePixel = 0

        cell.Parent = boardFrame

        cells[index] = cell
    end

    -- PANEL DERECHO

    local rightPanel = createPanel(
        container,
        "RightPanel",
        UDim2.fromScale(0.72, 0.05),
        UDim2.fromScale(0.245, 0.90)
    )

    createLabel(
        rightPanel,
        "NextTitle",
        "NEXT",
        UDim2.fromScale(0.9, 0.08),
        UDim2.fromScale(0.05, 0.02),
        15,
        COLORS.White
    )

    -- PRÓXIMAS CINCO PIEZAS

    local nextPreviews = {}

    for index = 1, 5 do

        local preview = createPanel(
            rightPanel,
            "NextPiece_" .. index,
            UDim2.fromScale(0.08, 0.12 + ((index - 1) * 0.17)),
            UDim2.fromScale(0.84, 0.15)
        )

        nextPreviews[index] = preview
    end


    --==================================================
    -- HERRAMIENTAS DEV - CONTROL DE NIVEL
    --==================================================

    local devPanel = Instance.new("Frame")

    devPanel.Name = "DevLevelPanel"

    
    -- PANEL DEV DEBAJO DEL PANEL IZQUIERDO.
    -- NO DEBE TAPAR LA CUADRÍCULA.

    devPanel.AnchorPoint = Vector2.new(0, 0)

    devPanel.Position = UDim2.fromScale(0.035, 0.955)

    devPanel.Size = UDim2.fromScale(0.245, 0.042)


    devPanel.BackgroundColor3 =
        Color3.fromRGB(38, 42, 58)

    devPanel.BorderSizePixel = 0
    devPanel.ZIndex = 5

    devPanel.Parent = container

    -- HERRAMIENTAS DEV SOLO EN ROBLOX STUDIO.
    -- EN EL JUEGO PUBLICADO ESTARÁN OCULTAS.

    devPanel.Visible = RunService:IsStudio()

    local devCorner = Instance.new("UICorner")
    devCorner.CornerRadius = UDim.new(0, 5)
    devCorner.Parent = devPanel

    local devLabel = createLabel(
        devPanel,
        "DevLevelLabel",
        "DEV  LVL 1",
        UDim2.fromScale(0.50, 0.9),
        UDim2.fromScale(0.25, 0.05),
        11,
        Color3.fromRGB(245, 190, 85)
    )

    devLabel.ZIndex = 6

    -- BOTÓN PARA BAJAR NIVEL

    local devMinusButton = Instance.new("TextButton")

    devMinusButton.Name = "DevMinusButton"
    devMinusButton.Size = UDim2.fromScale(0.23, 0.85)
    devMinusButton.Position = UDim2.fromScale(0.01, 0.075)

    devMinusButton.Text = "-"
    devMinusButton.TextSize = 21
    devMinusButton.Font = Enum.Font.GothamBold

    devMinusButton.TextColor3 = COLORS.White
    devMinusButton.BackgroundColor3 =
        Color3.fromRGB(105, 65, 55)

    devMinusButton.BorderSizePixel = 0
    devMinusButton.ZIndex = 6
    devMinusButton.Parent = devPanel

    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 4)
    minusCorner.Parent = devMinusButton

    -- BOTÓN PARA SUBIR NIVEL

    local devPlusButton = Instance.new("TextButton")

    devPlusButton.Name = "DevPlusButton"
    devPlusButton.Size = UDim2.fromScale(0.23, 0.85)
    devPlusButton.Position = UDim2.fromScale(0.76, 0.075)

    devPlusButton.Text = "+"
    devPlusButton.TextSize = 21
    devPlusButton.Font = Enum.Font.GothamBold

    devPlusButton.TextColor3 = COLORS.White
    devPlusButton.BackgroundColor3 =
        Color3.fromRGB(55, 100, 75)

    devPlusButton.BorderSizePixel = 0
    devPlusButton.ZIndex = 6
    devPlusButton.Parent = devPanel

    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 4)
    plusCorner.Parent = devPlusButton


    -- RESULTADO

    return {
        Container = container,

        Board = boardFrame,
        Cells = cells,

        HoldPreview = holdPreview,
        NextPreviews = nextPreviews,

        ScoreLabel = scoreLabel,
        LevelLabel = levelLabel,
        LinesLabel = linesLabel,

        DevPanel = devPanel,
        DevLevelLabel = devLabel,
        DevMinusButton = devMinusButton,
        DevPlusButton = devPlusButton,
    }
end

return BlockPuzzleBoard
