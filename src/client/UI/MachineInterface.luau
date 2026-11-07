
--[[
    UNIVERSO ARCADE
    MachineInterface

    Construye el mueble físico de las recreativas.
    Gestiona las vistas, el inicio de partida, la confirmación
    de salida, las estadísticas y las animaciones.
]]

local MachineInterface = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

-- IDENTIDAD VISUAL DE CADA RECREATIVA

local THEMES = {

    BlockPuzzle = {
        Primary = Color3.fromRGB(35, 165, 225),
        Secondary = Color3.fromRGB(25, 85, 145),
        Background = Color3.fromRGB(20, 27, 39),
        Artwork = Color3.fromRGB(25, 105, 160),
        DisplayName = "BLOCK PUZZLE",
        Subtitle = "THE BLOCK CHALLENGE",
        MachineNumber = "UA-001",
    },

    BubbleShooter = {
        Primary = Color3.fromRGB(225, 75, 165),
        Secondary = Color3.fromRGB(145, 45, 110),
        Background = Color3.fromRGB(35, 22, 34),
        Artwork = Color3.fromRGB(155, 45, 115),
        DisplayName = "BUBBLE SHOOTER",
        Subtitle = "COLOR POP CHALLENGE",
        MachineNumber = "UA-002",
    },

    SpaceShooter = {
        Primary = Color3.fromRGB(105, 100, 220),
        Secondary = Color3.fromRGB(65, 55, 145),
        Background = Color3.fromRGB(23, 23, 39),
        Artwork = Color3.fromRGB(75, 65, 155),
        DisplayName = "SPACE SHOOTER",
        Subtitle = "DEFEND THE GALAXY",
        MachineNumber = "UA-003",
    },

    BrickBreaker = {
        Primary = Color3.fromRGB(225, 125, 45),
        Secondary = Color3.fromRGB(145, 65, 25),
        Background = Color3.fromRGB(37, 29, 25),
        Artwork = Color3.fromRGB(165, 80, 30),
        DisplayName = "BRICK BREAKER",
        Subtitle = "BREAK EVERY BRICK",
        MachineNumber = "UA-004",
    },
}

-- COLORES GENERALES DEL MUEBLE

local COLORS = {
    Cabinet = Color3.fromRGB(28, 29, 34),
    CabinetLight = Color3.fromRGB(43, 44, 50),
    CabinetDark = Color3.fromRGB(16, 17, 21),

    Metal = Color3.fromRGB(100, 103, 112),
    MetalDark = Color3.fromRGB(55, 57, 64),

    White = Color3.fromRGB(225, 225, 225),
    Muted = Color3.fromRGB(145, 147, 155),

    ScreenBlack = Color3.fromRGB(5, 6, 10),
}

-- CREACIÓN DE ELEMENTOS

local function create(className, properties, parent)

    local object = Instance.new(className)

    for property, value in pairs(properties) do
        object[property] = value
    end

    object.Parent = parent

    return object

end

local function addCorner(parent, radius)

    create("UICorner", {
        CornerRadius = UDim.new(0, radius),
    }, parent)

end

local function addStroke(parent, color, thickness)

    return create("UIStroke", {
        Color = color,
        Thickness = thickness,
        Transparency = 0,
    }, parent)

end

local function createLabel(
    parent,
    name,
    text,
    size,
    position,
    fontSize,
    color,
    font
)

    return create("TextLabel", {

        Name = name,

        BackgroundTransparency = 1,

        Position = position,
        Size = size,

        Text = text,
        TextColor3 = color,

        TextSize = fontSize,
        Font = font or Enum.Font.GothamBold,

        TextScaled = false,
        TextWrapped = true,

        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,

    }, parent)

end

-- DETALLES METÁLICOS

local function createRivet(parent, position)

    local rivet = create("Frame", {

        Name = "MetalRivet",

        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = position,

        Size = UDim2.fromOffset(8, 8),

        BackgroundColor3 = COLORS.Metal,
        BorderSizePixel = 0,

    }, parent)

    addCorner(rivet, 50)

    create("Frame", {

        Name = "RivetCenter",

        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),

        Size = UDim2.fromScale(0.35, 0.35),

        BackgroundColor3 = COLORS.CabinetDark,
        BorderSizePixel = 0,

    }, rivet)

    return rivet

end

-- GRÁFICOS IMPRESOS LATERALES

local function createSideArtwork(parent, theme, side)

    local isLeft = side == "Left"
    local xPosition = isLeft and 0.018 or 0.962

    local artwork = create("Frame", {

        Name = "Artwork" .. side,

        Position = UDim2.fromScale(xPosition, 0.19),
        Size = UDim2.fromScale(0.02, 0.62),

        BackgroundColor3 = COLORS.CabinetDark,
        BorderSizePixel = 0,

    }, parent)

    addCorner(artwork, 4)

    create("Frame", {

        Name = "ArtworkStripe",

        Position = UDim2.fromScale(0.15, 0.04),
        Size = UDim2.fromScale(0.7, 0.92),

        BackgroundColor3 = theme.Artwork,
        BorderSizePixel = 0,

    }, artwork)

    for index = 1, 5 do

        local detail = create("Frame", {

            Name = "ArtworkDetail" .. index,

            AnchorPoint = Vector2.new(0.5, 0.5),

            Position = UDim2.fromScale(
                0.5,
                0.12 + (index - 1) * 0.18
            ),

            Size = UDim2.fromScale(0.8, 0.035),

            BackgroundColor3 = theme.Primary,
            BorderSizePixel = 0,

        }, artwork)

        addCorner(detail, 2)

    end

end

-- CONSTRUIR RECREATIVA

function MachineInterface.Create(
    minigameId,
    playerName,
    onExit,
    onStart,
    onPause,
    onResume
)

    local theme = THEMES[minigameId] or THEMES.BrickBreaker

    playerName = playerName or "PLAYER"

    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- ESTADO INTERNO DE LA INTERFAZ

    local interface = nil
    local currentView = "Start"
    local previousView = "Start"

    local showView
    local beginGame

    local startInputConnection = nil
    local startRequested = false

    -- INTERFAZ GENERAL

    local gui = create("ScreenGui", {

        Name = "MachineInterface",

        ResetOnSpawn = false,
        IgnoreGuiInset = true,

        DisplayOrder = 50,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

    }, playerGui)

    -- FONDO EXTERIOR

    local background = create("Frame", {

        Name = "ArcadeBackground",

        Size = UDim2.fromScale(1, 1),

        BackgroundColor3 = Color3.fromRGB(3, 4, 8),
        BackgroundTransparency = 0,

        BorderSizePixel = 0,

    }, gui)

    -- CUERPO PRINCIPAL DEL MUEBLE

    local cabinet = create("Frame", {

        Name = "CabinetFrame",

        AnchorPoint = Vector2.new(0.5, 0.5),

        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.88, 0.92),

        BackgroundColor3 = COLORS.Cabinet,
        BorderSizePixel = 0,

    }, background)

    addCorner(cabinet, 12)
    addStroke(cabinet, COLORS.MetalDark, 3)

    -- PANEL FRONTAL INTERIOR

    local cabinetFace = create("Frame", {

        Name = "CabinetFace",

        Position = UDim2.fromScale(0.012, 0.012),
        Size = UDim2.fromScale(0.976, 0.976),

        BackgroundColor3 = COLORS.CabinetLight,
        BorderSizePixel = 0,

    }, cabinet)

    addCorner(cabinetFace, 9)

    -- BANDA SUPERIOR

    local header = create("Frame", {

        Name = "Header",

        Position = UDim2.fromScale(0.045, 0.035),
        Size = UDim2.fromScale(0.91, 0.105),

        BackgroundColor3 = COLORS.CabinetDark,
        BorderSizePixel = 0,

    }, cabinet)

    addCorner(header, 6)
    addStroke(header, COLORS.MetalDark, 2)

    create("Frame", {

        Name = "HeaderAccent",

        Position = UDim2.fromScale(0.025, 0.12),
        Size = UDim2.fromScale(0.95, 0.045),

        BackgroundColor3 = theme.Artwork,
        BorderSizePixel = 0,

    }, header)

    createLabel(
        header,
        "ArcadeTitle",
        "UNIVERSO ARCADE",
        UDim2.fromScale(0.55, 0.42),
        UDim2.fromScale(0.035, 0.04),
        21,
        COLORS.White
    )

    createLabel(
        header,
        "GameTitle",
        theme.DisplayName,
        UDim2.fromScale(0.55, 0.30),
        UDim2.fromScale(0.035, 0.52),
        15,
        theme.Primary
    )

    createLabel(
        header,
        "PlayerName",
        "PLAYER: " .. string.upper(playerName),
        UDim2.fromScale(0.34, 0.35),
        UDim2.fromScale(0.625, 0.10),
        12,
        COLORS.White
    )

    -- PLACA METÁLICA

    local machinePlate = create("Frame", {

        Name = "MachinePlate",

        Position = UDim2.fromScale(0.65, 0.57),
        Size = UDim2.fromScale(0.31, 0.28),

        BackgroundColor3 = COLORS.MetalDark,
        BorderSizePixel = 0,

    }, header)

    addCorner(machinePlate, 3)

    createLabel(
        machinePlate,
        "MachineNumber",
        theme.MachineNumber,
        UDim2.fromScale(0.95, 1),
        UDim2.fromScale(0.025, 0),
        10,
        COLORS.White
    )

    -- BOTÓN DE SALIDA

    local exitButton = create("TextButton", {

        Name = "ExitButton",

        AnchorPoint = Vector2.new(1, 0),

        Position = UDim2.fromScale(0.955, 0.035),
        Size = UDim2.fromOffset(100, 30),

        BackgroundColor3 = Color3.fromRGB(105, 38, 38),
        BorderSizePixel = 0,

        Text = "SALIR  [X]",
        TextColor3 = COLORS.White,

        TextSize = 13,
        Font = Enum.Font.GothamBold,

        AutoButtonColor = true,

        ZIndex = 10,

    }, cabinet)

    addCorner(exitButton, 4)

    -- MARCO DE LA PANTALLA

    local screenBezel = create("Frame", {

        Name = "ScreenBezel",

        Position = UDim2.fromScale(0.045, 0.16),
        Size = UDim2.fromScale(0.91, 0.70),

        BackgroundColor3 = COLORS.CabinetDark,
        BorderSizePixel = 0,

    }, cabinet)

    addCorner(screenBezel, 7)
    addStroke(screenBezel, COLORS.MetalDark, 3)

    -- MOLDURA INTERIOR

    local innerBezel = create("Frame", {

        Name = "InnerBezel",

        Position = UDim2.fromScale(0.012, 0.012),
        Size = UDim2.fromScale(0.976, 0.976),

        BackgroundColor3 = COLORS.ScreenBlack,
        BorderSizePixel = 0,

    }, screenBezel)

    addCorner(innerBezel, 5)

    -- ZONA DE JUEGO

    local gameScreen = create("Frame", {

        Name = "GameScreen",

        Position = UDim2.fromScale(0.055, 0.17),
        Size = UDim2.fromScale(0.89, 0.68),

        BackgroundColor3 = COLORS.ScreenBlack,
        BorderSizePixel = 0,

        ClipsDescendants = true,

    }, cabinet)

    -- DETALLES LATERALES

    createSideArtwork(cabinet, theme, "Left")
    createSideArtwork(cabinet, theme, "Right")

    createLabel(
        cabinet,
        "CabinetSlogan",
        theme.Subtitle,
        UDim2.fromScale(0.45, 0.025),
        UDim2.fromScale(0.275, 0.135),
        10,
        COLORS.Muted
    )

    -- PANEL DE ESTADÍSTICAS

    local stats = create("Frame", {

        Name = "StatsPanel",

        Position = UDim2.fromScale(0.045, 0.885),
        Size = UDim2.fromScale(0.91, 0.075),

        BackgroundColor3 = COLORS.CabinetDark,
        BorderSizePixel = 0,

    }, cabinet)

    addCorner(stats, 5)
    addStroke(stats, COLORS.MetalDark, 2)

    for index = 1, 2 do

        create("Frame", {

            Name = "StatsSeparator" .. index,

            Position = UDim2.fromScale(index / 3, 0.18),
            Size = UDim2.new(0, 2, 0.64, 0),

            BackgroundColor3 = COLORS.MetalDark,
            BorderSizePixel = 0,

        }, stats)

    end

    -- SCORE

    createLabel(
        stats,
        "ScoreTitle",
        "SCORE",
        UDim2.fromScale(0.28, 0.35),
        UDim2.fromScale(0.025, 0.05),
        11,
        theme.Primary
    )

    createLabel(
        stats,
        "ScoreValue",
        "0",
        UDim2.fromScale(0.28, 0.48),
        UDim2.fromScale(0.025, 0.43),
        17,
        COLORS.White
    )

    -- LEVEL

    createLabel(
        stats,
        "LevelTitle",
        "LEVEL",
        UDim2.fromScale(0.28, 0.35),
        UDim2.fromScale(0.36, 0.05),
        11,
        theme.Primary
    )

    createLabel(
        stats,
        "LevelValue",
        "1",
        UDim2.fromScale(0.28, 0.48),
        UDim2.fromScale(0.36, 0.43),
        17,
        COLORS.White
    )

    -- BEST

    createLabel(
        stats,
        "BestTitle",
        "BEST",
        UDim2.fromScale(0.28, 0.35),
        UDim2.fromScale(0.68, 0.05),
        11,
        theme.Primary
    )

    createLabel(
        stats,
        "BestValue",
        "--",
        UDim2.fromScale(0.28, 0.48),
        UDim2.fromScale(0.68, 0.43),
        17,
        COLORS.White
    )

    -- SISTEMA DE VISTAS

    local interfaceOverlay = create("Frame", {

        Name = "InterfaceOverlay",

        Size = UDim2.fromScale(1, 1),

        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        ZIndex = 20,
        Visible = true,

    }, gameScreen)

    local views = {}

    local function createView(name, stateName)

        local view = create("Frame", {

            Name = name,

            Size = UDim2.fromScale(1, 1),

            BackgroundColor3 = COLORS.ScreenBlack,
            BackgroundTransparency = 0.12,

            BorderSizePixel = 0,

            Visible = false,

            ZIndex = 20,

        }, interfaceOverlay)

        views[stateName or name] = view

        return view

    end

    local function createViewPanel(parent, titleText, messageText)

        local panel = create("Frame", {

            Name = "ContentPanel",

            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),

            Size = UDim2.fromScale(0.72, 0.68),

            BackgroundColor3 = COLORS.Cabinet,
            BorderSizePixel = 0,

            ZIndex = 21,

        }, parent)

        addCorner(panel, 10)
        addStroke(panel, theme.Primary, 2)

        createLabel(
            panel,
            "ViewTitle",
            titleText,
            UDim2.fromScale(0.9, 0.25),
            UDim2.fromScale(0.05, 0.08),
            28,
            theme.Primary
        ).ZIndex = 22

        createLabel(
            panel,
            "ViewMessage",
            messageText,
            UDim2.fromScale(0.84, 0.30),
            UDim2.fromScale(0.08, 0.36),
            16,
            COLORS.White,
            Enum.Font.GothamMedium
        ).ZIndex = 22

        return panel

    end

    local function createViewButton(
        parent,
        name,
        text,
        position,
        callback
    )

        local button = create("TextButton", {

            Name = name,

            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = position,

            Size = UDim2.fromScale(0.38, 0.14),

            BackgroundColor3 = theme.Secondary,
            BorderSizePixel = 0,

            Text = text,
            TextColor3 = COLORS.White,

            TextSize = 18,
            Font = Enum.Font.GothamBold,

            AutoButtonColor = true,

            ZIndex = 23,

        }, parent)

        addCorner(button, 6)
        addStroke(button, theme.Primary, 1)

        button.Activated:Connect(callback)

        return button

    end
    
    -- PANTALLA INICIAL
    -- ESTILO ARCADE CLÁSICO PRESS START
    -- PANTALLAS INICIALES DE CADA MINIJUEGO

    local startView = createView("StartView", "Start")

    startView.BackgroundColor3 = Color3.fromRGB(3, 3, 10)
    startView.BackgroundTransparency = 0

    -- BRICK BREAKER

    if minigameId == "BrickBreaker" then

        -- DECORACIÓN: LADRILLOS

        local brickColors = {
            Color3.fromRGB(235, 65, 65),
            Color3.fromRGB(240, 155, 45),
            Color3.fromRGB(235, 215, 65),
            Color3.fromRGB(65, 195, 105),
            Color3.fromRGB(65, 145, 235),
        }

        for row = 1, 2 do
            for column = 1, 7 do

                local brick = create("Frame", {
                    Name = "TitleBrick_" .. row .. "_" .. column,

                    Position = UDim2.fromScale(
                        0.20 + (column - 1) * 0.087,
                        0.12 + (row - 1) * 0.055
                    ),

                    Size = UDim2.fromScale(0.075, 0.035),

                    BackgroundColor3 = brickColors[row + 2],
                    BorderSizePixel = 0,

                    ZIndex = 22,
                }, startView)

                addStroke(brick, Color3.fromRGB(255, 255, 255), 1)

            end
        end

        -- TÍTULO

        local title = createLabel(
            startView,
            "ArcadeGameTitle",
            "BRICK BREAKER",
            UDim2.fromScale(0.9, 0.17),
            UDim2.fromScale(0.05, 0.29),
            48,
            Color3.fromRGB(255, 180, 65),
            Enum.Font.Arcade
        )

        title.ZIndex = 23
        title.TextStrokeColor3 = Color3.fromRGB(185, 65, 15)
        title.TextStrokeTransparency = 0.15

        -- SUBTÍTULO

        local subtitle = createLabel(
            startView,
            "ArcadeSubtitle",
            "THE CLASSIC ARCADE CHALLENGE",
            UDim2.fromScale(0.9, 0.07),
            UDim2.fromScale(0.05, 0.47),
            15,
            Color3.fromRGB(120, 190, 255),
            Enum.Font.Code
        )

        subtitle.ZIndex = 23

        -- PELOTA DECORATIVA

        local decorativeBall = create("Frame", {

            Name = "DecorativeBall",

            Position = UDim2.fromScale(0.18, 0.67),
            Size = UDim2.fromOffset(15, 15),

            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,

            ZIndex = 24,

        }, startView)

        addCorner(decorativeBall, 50)

        local ballTween = TweenService:Create(
            decorativeBall,
            TweenInfo.new(
                1.1,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                -1,
                true
            ),
            {
                Position = UDim2.fromScale(0.80, 0.67),
            }
        )

        ballTween:Play()

        -- PALA DECORATIVA

        local decorativePaddle = create("Frame", {

            Name = "DecorativePaddle",

            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.76),

            Size = UDim2.fromScale(0.19, 0.025),

            BackgroundColor3 = Color3.fromRGB(70, 175, 255),
            BorderSizePixel = 0,

            ZIndex = 23,

        }, startView)

        addCorner(decorativePaddle, 4)

       -- BLOCK PUZZLE

       
    --==================================================
    -- BLOCK PUZZLE - PORTADA CON MINI TABLERO
    --==================================================

    elseif minigameId == "BlockPuzzle" then

        -- CONTENEDOR CENTRADO DEL MINI TABLERO

        local miniBoard = create("Frame", {

            Name = "BlockPuzzleMiniBoard",

            AnchorPoint = Vector2.new(0.5, 0),

            Position = UDim2.fromScale(0.5, 0.08),

            Size = UDim2.fromScale(0.23, 0.46),

            BackgroundColor3 = Color3.fromRGB(15, 22, 38),

            BorderSizePixel = 0,

            ZIndex = 22,

        }, startView)

        addCorner(miniBoard, 5)

        addStroke(
            miniBoard,
            Color3.fromRGB(80, 135, 195),
            2
        )

        -- CUADRÍCULA DE 8 COLUMNAS Y 10 FILAS.
        -- TODAS LAS PIEZAS UTILIZAN LA MISMA REJILLA.

        local columns = 8
        local rows = 10

        local cellSize = 0.09

        local offsetX = 0.14
        local offsetY = 0.05

        -- DISTRIBUCIÓN DEL TABLERO
        -- CADA LETRA REPRESENTA UN COLOR.
        -- "." REPRESENTA UNA CASILLA VACÍA.
        --
        -- DOS FILAS INFERIORES CON UN HUECO
        -- DE DOS COLUMNAS PARA LA PIEZA O.

        local boardPattern = {

            "........",
            "........",
            "........",
            "........",
            "........",
            "........",
            "........",
            "........",
            "LLTT..SS",
            "LJJJ..SS",

        }

        local blockColors = {

            L = Color3.fromRGB(245, 145, 45),
            T = Color3.fromRGB(175, 75, 225),
            S = Color3.fromRGB(75, 220, 95),
            J = Color3.fromRGB(65, 105, 235),

            O = Color3.fromRGB(245, 215, 45),

        }

        -- CREAR UNA CASILLA ALINEADA A LA REJILLA

        
        local function createMiniCell(
            column,
            row,
            color,
            transparency,
            isGhost
        )

            local cell = create("Frame", {

                Name = isGhost and "GhostCell" or "MiniCell",

                Position = UDim2.fromScale(
                    offsetX + (column - 1) * cellSize,
                    offsetY + (row - 1) * cellSize
                ),

                Size = UDim2.fromScale(
                    cellSize - 0.008,
                    cellSize - 0.008
                ),

                BackgroundColor3 = color,
                BackgroundTransparency = transparency or 0,

                BorderSizePixel = 0,
                ZIndex = 23,

            }, miniBoard)

            -- ESQUINAS MÁS SUAVES

            addCorner(cell, 4)

            -- BORDES DISCRETOS

            if isGhost then

                local stroke = addStroke(
                    cell,
                    color,
                    1
                )

                stroke.Transparency = 0.45

            else

                local stroke = addStroke(
                    cell,
                    Color3.fromRGB(180, 200, 230),
                    0.5
                )

                stroke.Transparency = 0.75

            end

            return cell
        end


        -- CREAR FONDO DE LA CUADRÍCULA

        for row = 1, rows do

            for column = 1, columns do

                createMiniCell(
                    column,
                    row,
                    Color3.fromRGB(21, 29, 46),
                    0,
                    false
                )

            end
        end

        -- DIBUJAR PIEZAS YA COLOCADAS

        for row, pattern in ipairs(boardPattern) do

            for column = 1, columns do

                local symbol = string.sub(
                    pattern,
                    column,
                    column
                )

                if symbol ~= "." then

                    createMiniCell(
                        column,
                        row,
                        blockColors[symbol],
                        0,
                        false
                    )

                end
            end
        end

        -- SOMBRA DE UNA PIEZA O
        -- INDICA DÓNDE CAERÁ.

        local ghostPositions = {
            {5, 9},
            {6, 9},
            {5, 10},
            {6, 10},
        }

        for _, position in ipairs(ghostPositions) do

            createMiniCell(
                position[1],
                position[2],
                blockColors.O,
                0.82,
                true
            )
        end

        -- PIEZA O CAYENDO DESDE ARRIBA

        local fallingPiece = create("Frame", {

            Name = "FallingTetromino",

            Size = UDim2.fromScale(1, 1),

            BackgroundTransparency = 1,

            ZIndex = 24,

        }, miniBoard)

        local fallingPositions = {
            {5, 2},
            {6, 2},
            {5, 3},
            {6, 3},
        }

        for _, position in ipairs(fallingPositions) do

            local cell = createMiniCell(
                position[1],
                position[2],
                blockColors.O,
                0,
                false
            )

            cell.ZIndex = 24
            cell.Parent = fallingPiece
        end

        
        --==================================================
        -- ANIMACIÓN DE LA PORTADA DE BLOCKPUZZLE
        --==================================================

        -- DISTANCIA ENTRE LA POSICIÓN INICIAL
        -- Y LAS DOS FILAS INFERIORES.

        local landingDistance = 7 * cellSize

        -- CREAR DESTELLOS SOBRE LAS DOS FILAS.

        local flashRows = {}

        for _, row in ipairs({9, 10}) do

            local flash = create("Frame", {

                Name = "LineClearFlash_" .. row,

                Position = UDim2.fromScale(
                    offsetX,
                    offsetY + (row - 1) * cellSize
                ),

                Size = UDim2.fromScale(
                    columns * cellSize,
                    cellSize - 0.008
                ),

                BackgroundColor3 =
                    Color3.fromRGB(180, 230, 255),

                BackgroundTransparency = 1,

                BorderSizePixel = 0,

                Visible = false,

                ZIndex = 26,

            }, miniBoard)

            addCorner(flash, 3)

            table.insert(flashRows, flash)

        end

        -- REPRODUCIR ANIMACIÓN EN BUCLE.

        task.spawn(function()

            while gui.Parent and startView.Parent do

                -- NO ANIMAR MIENTRAS LA PORTADA
                -- NO ESTÉ EN PANTALLA.

                if currentView ~= "Start" then

                    task.wait(0.2)
                    continue

                end

                -- RESTABLECER POSICIÓN INICIAL.

                fallingPiece.Position =
                    UDim2.fromScale(0, 0)

                fallingPiece.Visible = true

                for _, flash in ipairs(flashRows) do

                    flash.Visible = false
                    flash.BackgroundTransparency = 1

                end

                -- PEQUEÑA ESPERA ANTES DE CAER.

                task.wait(0.45)

                if currentView ~= "Start"
                    or not gui.Parent then

                    continue

                end

                -- CAÍDA SUAVE DE LA PIEZA.

                local fallTween = TweenService:Create(
                    fallingPiece,

                    TweenInfo.new(
                        1.35,
                        Enum.EasingStyle.Sine,
                        Enum.EasingDirection.In
                    ),

                    {
                        Position = UDim2.fromScale(
                            0,
                            landingDistance
                        )
                    }
                )

                fallTween:Play()
                fallTween.Completed:Wait()

                if currentView ~= "Start"
                    or not gui.Parent then

                    continue

                end

                -- PAUSA BREVE AL ENCAJAR.

                task.wait(0.12)

                -- DESTELLO DE LAS DOS FILAS.

                for _, flash in ipairs(flashRows) do

                    flash.Visible = true
                    flash.BackgroundTransparency = 0.35

                    local flashTween = TweenService:Create(
                        flash,

                        TweenInfo.new(
                            0.35,
                            Enum.EasingStyle.Quad,
                            Enum.EasingDirection.Out
                        ),

                        {
                            BackgroundTransparency = 1
                        }
                    )

                    flashTween:Play()

                end

                -- OCULTAR LA PIEZA DURANTE EL REINICIO.

                task.wait(0.40)

                fallingPiece.Visible = false

                -- PAUSA ANTES DE REPETIR.

                task.wait(0.65)

            end

        end)


        -- TÍTULO

        local blockPuzzleTitle = createLabel(
            startView,
            "ArcadeGameTitle",
            "BLOCK PUZZLE",
            UDim2.fromScale(0.9, 0.14),
            UDim2.fromScale(0.05, 0.57),
            42,
            theme.Primary,
            Enum.Font.Arcade
        )

        blockPuzzleTitle.ZIndex = 23

        blockPuzzleTitle.TextStrokeColor3 =
            Color3.fromRGB(20, 40, 60)

        blockPuzzleTitle.TextStrokeTransparency = 0.15

        -- SUBTÍTULO

        local blockPuzzleSubtitle = createLabel(
            startView,
            "ArcadeSubtitle",
            "STACK. ROTATE. CLEAR.",
            UDim2.fromScale(0.9, 0.07),
            UDim2.fromScale(0.05, 0.71),
            17,
            COLORS.White,
            Enum.Font.Code
        )

        blockPuzzleSubtitle.ZIndex = 23


    -- BUBBLE SHOOTER

    elseif minigameId == "BubbleShooter" then

        local bubbleColors = {
            Color3.fromRGB(245, 75, 105),
            Color3.fromRGB(75, 175, 245),
            Color3.fromRGB(245, 205, 65),
            Color3.fromRGB(125, 220, 125),
            Color3.fromRGB(185, 100, 245),
        }

        for row = 1, 3 do
            for column = 1, 7 do

                local bubble = create("Frame", {

                    Name = "TitleBubble_" .. row .. "_" .. column,

                    Position = UDim2.fromScale(
                        0.23 + (column - 1) * 0.09,
                        0.13 + (row - 1) * 0.065
                    ),

                    Size = UDim2.fromScale(0.075, 0.075),

                    BackgroundColor3 =
                        bubbleColors[(row + column - 2) % #bubbleColors + 1],

                    BorderSizePixel = 0,

                    ZIndex = 22,

                }, startView)

                addCorner(bubble, 50)
                addStroke(bubble, Color3.fromRGB(255, 255, 255), 1)

            end
        end

        createLabel(
            startView,
            "ArcadeGameTitle",
            "BUBBLE SHOOTER",
            UDim2.fromScale(0.9, 0.17),
            UDim2.fromScale(0.05, 0.47),
            38,
            theme.Primary,
            Enum.Font.Arcade
        ).ZIndex = 23

        createLabel(
            startView,
            "ArcadeSubtitle",
            "AIM. SHOOT. POP!",
            UDim2.fromScale(0.9, 0.07),
            UDim2.fromScale(0.05, 0.64),
            17,
            COLORS.White,
            Enum.Font.Code
        ).ZIndex = 23

        -- LANZADOR DECORATIVO

        local shooter = create("Frame", {

            Name = "BubbleShooterLauncher",

            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.77),

            Size = UDim2.fromScale(0.09, 0.09),

            BackgroundColor3 = theme.Primary,
            BorderSizePixel = 0,

            ZIndex = 23,

        }, startView)

        addCorner(shooter, 50)

    -- SPACE SHOOTER

    elseif minigameId == "SpaceShooter" then

        -- ESTRELLAS

        local starPositions = {
            {0.15, 0.18},
            {0.28, 0.30},
            {0.78, 0.17},
            {0.85, 0.36},
            {0.18, 0.58},
            {0.80, 0.65},
            {0.35, 0.78},
            {0.68, 0.80},
        }

        for index, position in ipairs(starPositions) do

            create("Frame", {

                Name = "SpaceStar_" .. index,

                Position = UDim2.fromScale(position[1], position[2]),

                Size = UDim2.fromOffset(4, 4),

                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,

                ZIndex = 22,

            }, startView)

        end

        -- NAVES ENEMIGAS

        for index = 1, 3 do

            create("Frame", {

                Name = "EnemyShip_" .. index,

                Position = UDim2.fromScale(
                    0.32 + (index - 1) * 0.16,
                    0.25
                ),

                Size = UDim2.fromScale(0.07, 0.055),

                Rotation = 45,

                BackgroundColor3 = theme.Primary,
                BorderSizePixel = 0,

                ZIndex = 23,

            }, startView)

        end

        createLabel(
            startView,
            "ArcadeGameTitle",
            "SPACE SHOOTER",
            UDim2.fromScale(0.9, 0.17),
            UDim2.fromScale(0.05, 0.46),
            39,
            theme.Primary,
            Enum.Font.Arcade
        ).ZIndex = 23

        createLabel(
            startView,
            "ArcadeSubtitle",
            "DEFEND THE GALAXY",
            UDim2.fromScale(0.9, 0.07),
            UDim2.fromScale(0.05, 0.63),
            17,
            COLORS.White,
            Enum.Font.Code
        ).ZIndex = 23

        -- NAVE DEL JUGADOR

        create("Frame", {

            Name = "PlayerShip",

            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.77),

            Size = UDim2.fromScale(0.055, 0.09),

            Rotation = 45,

            BackgroundColor3 = Color3.fromRGB(100, 220, 255),
            BorderSizePixel = 0,

            ZIndex = 23,

        }, startView)

    end

    -- PRESS START PARPADEANTE (COMÚN)

    local pressStart = createLabel(
        startView,
        "PressStart",
        "PRESS START",
        UDim2.fromScale(0.9, 0.12),
        UDim2.fromScale(0.05, 0.84),
        27,
        Color3.fromRGB(255, 255, 255),
        Enum.Font.Arcade
    )

    pressStart.ZIndex = 24
    pressStart.TextStrokeColor3 = theme.Primary
    pressStart.TextStrokeTransparency = 0.1

    local blinkTween = TweenService:Create(
        pressStart,
        TweenInfo.new(
            0.65,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1,
            true
        ),
        {
            TextTransparency = 1,
        }
    )

    blinkTween:Play()

    -- TRANSICIÓN ENTRE NIVELES

    local levelView = createView(
        "LevelTransitionView",
        "LevelTransition"
    )

    -- TEXTOS DE LA TRANSICIÓN

levelView.BackgroundTransparency = 0

local levelTitle = createLabel(
    levelView,
    "LevelCompleteTitle",
    "LEVEL COMPLETE",
    UDim2.fromScale(0.9, 0.25),
    UDim2.fromScale(0.05, 0.32),
    42,
    theme.Primary,
    Enum.Font.Arcade
)

levelTitle.ZIndex = 21

local levelMessage = createLabel(
    levelView,
    "NextLevelTitle",
    "LEVEL 2",
    UDim2.fromScale(0.9, 0.25),
    UDim2.fromScale(0.05, 0.42),
    38,
    COLORS.White,
    Enum.Font.Arcade
)

levelMessage.ZIndex = 21

levelMessage.Visible = false

       -- GAME OVER

    local gameOverView = createView(
        "GameOverView",
        "GameOver"
    )

    gameOverView.BackgroundTransparency = 0

    -- TÍTULO PRINCIPAL

    local gameOverTitle = createLabel(
        gameOverView,
        "GameOverTitle",
        "GAME OVER",
        UDim2.fromScale(0.9, 0.25),
        UDim2.fromScale(0.05, 0.25),
        42,
        theme.Primary,
        Enum.Font.Arcade
    )

    gameOverTitle.ZIndex = 21

    -- PUNTUACIÓN FINAL

    local finalScoreLabel = createLabel(
        gameOverView,
        "FinalScore",
        "PUNTUACIÓN: 0",
        UDim2.fromScale(0.9, 0.10),
        UDim2.fromScale(0.05, 0.48),
        18,
        COLORS.White,
        Enum.Font.Arcade
    )

    finalScoreLabel.ZIndex = 21

    -- RÉCORD

    local finalBestLabel = createLabel(
        gameOverView,
        "FinalBest",
        "RÉCORD: --",
        UDim2.fromScale(0.9, 0.10),
        UDim2.fromScale(0.05, 0.59),
        16,
        theme.Primary,
        Enum.Font.Arcade
    )

    finalBestLabel.ZIndex = 21

    -- MENSAJE PARA REINICIAR

    local gameOverContinueLabel = createLabel(
        gameOverView,
        "GameOverContinue",
        "PULSA PARA VOLVER A JUGAR",
        UDim2.fromScale(0.9, 0.10),
        UDim2.fromScale(0.05, 0.82),
        11,
        COLORS.White,
        Enum.Font.Arcade
    )

    gameOverContinueLabel.ZIndex = 21

    -- CONFIRMACIÓN DE SALIDA

    local exitView = createView(
        "ExitConfirmationView",
        "ExitConfirmation"
    )

--==================================================
-- PANTALLA DE PAUSA
--==================================================

    local pauseView = createView(
        "PauseView",
        "Pause"
    )

    local pausePanel = createViewPanel(
        pauseView,
        "PAUSED",
        "GAME SUSPENDED"
    )

    -- BOTÓN REANUDAR

createViewButton(
    pausePanel,
    "ResumeButton",
    "RESUME",
    UDim2.fromScale(0.30, 0.80),
    function()

        if currentView ~= "Pause" then
            return
        end

        showView("Gameplay")

        if onResume then
            onResume()
        end

    end
)

-- BOTÓN SALIR

    createViewButton(
        pausePanel,
        "ExitGameButton",
        "EXIT GAME",
        UDim2.fromScale(0.70, 0.80),
        function()

            if currentView ~= "Pause" then
                return
            end

            previousView = "Pause"
            showView("ExitConfirmation")

        end
    )

    local exitPanel = createViewPanel(
        exitView,
        "¿ABANDONAR PARTIDA?",
        "Perderás la puntuación de esta partida, que no se guardará.\n\n¿Quieres abandonar?"
    )

    createViewButton(
        exitPanel,
        "ConfirmExitButton",
        "SÍ, ABANDONAR",
        UDim2.fromScale(0.28, 0.82),
        function()

            if currentView ~= "ExitConfirmation" then
                return
            end

            if onExit then
                onExit()
            end

        end
    )

    createViewButton(
        exitPanel,
        "CancelExitButton",
        "NO, CONTINUAR",
        UDim2.fromScale(0.72, 0.82),
        function()

            if currentView ~= "ExitConfirmation" then
                return
            end

            local viewToRestore = previousView

            showView(viewToRestore)

            if viewToRestore == "Gameplay" and onResume then
                onResume()
            end

        end
    )

    -- CONTROL DE VISIBILIDAD

    showView = function(viewName)

        for name, view in pairs(views) do
            view.Visible = name == viewName
        end

        currentView = viewName

    end

    -- INICIO DE PARTIDA

    beginGame = function()

        if currentView ~= "Start" or startRequested then
            return
        end

        startRequested = true

        showView("Gameplay")

        if onStart then
            onStart()
        end

    end

    -- DETECCIÓN DE TECLADO Y RATÓN

    startInputConnection = UserInputService.InputBegan:Connect(
        function(input, gameProcessed)

            if currentView ~= "Start" then
                return
            end

            -- ESPACIO

            if input.KeyCode == Enum.KeyCode.Space then

                if gameProcessed then
                    return
                end

                beginGame()
                return

            end

            -- CLIC DENTRO DE LA PANTALLA

            if input.UserInputType == Enum.UserInputType.MouseButton1 then

                local mousePosition =
                    UserInputService:GetMouseLocation()
                    - GuiService:GetGuiInset()

                local screenPosition = gameScreen.AbsolutePosition
                local screenSize = gameScreen.AbsoluteSize

                local insideScreen =
                    mousePosition.X >= screenPosition.X
                    and mousePosition.X <= screenPosition.X + screenSize.X
                    and mousePosition.Y >= screenPosition.Y
                    and mousePosition.Y <= screenPosition.Y + screenSize.Y

                if insideScreen then
                    beginGame()
                end

            end

        end
    )

    -- API PÚBLICA DE LA INTERFAZ

    interface = {}

    interface.Gui = gui
    interface.GameScreen = gameScreen

    function interface.GetCurrentView()
        return currentView
    end

    function interface.ShowStartScreen()

        startRequested = false
        showView("Start")

    end

    function interface.ShowGameplay()

        showView("Gameplay")

    end

    function interface.ShowLevelTransition(
            completedLevel,
            nextLevel,
            onContinue
        )

            if currentView == "ExitConfirmation" then
                return
            end

            -- Primera pantalla: LEVEL COMPLETE
            levelTitle.Text = "LEVEL COMPLETE"
            levelTitle.Visible = true
            levelMessage.Visible = false

            showView("LevelTransition")

            task.spawn(function()

                -- Mantener LEVEL COMPLETE durante 2 segundos
                task.wait(2)

                if currentView ~= "LevelTransition" then
                    return
                end

                -- Dejar la pantalla negra durante medio segundo
                levelTitle.Visible = false

                task.wait(0.5)

                if currentView ~= "LevelTransition" then
                    return
                end

                -- Mostrar el siguiente nivel
                levelMessage.Text = "LEVEL " .. tostring(nextLevel)
                levelMessage.Visible = true

                task.wait(2)

                if currentView ~= "LevelTransition" then
                    return
                end

                -- Entrar automáticamente en el siguiente nivel
                showView("Gameplay")

                if onContinue then
                onContinue()
            end

        end)

    end

    function interface.ShowGameOver(gameStats, bestScore)

        gameStats = gameStats or {}

        finalScoreLabel.Text =
            "PUNTUACIÓN: " .. tostring(gameStats.Score or 0)

        finalBestLabel.Text =
            "RÉCORD: " .. tostring(bestScore or "--")

        showView("GameOver")

    end

    function interface.ShowPauseScreen()

        if currentView == "Pause"
            or currentView == "ExitConfirmation"
        then
            return
        end

        if currentView ~= "Gameplay" then
            return
        end

        previousView = "Gameplay"

        if onPause then
            onPause()
        end

        showView("Pause")

    end

    function interface.SetStats(gameStats)

        gameStats = gameStats or {}

        local scoreLabel = stats:FindFirstChild("ScoreValue")
        local levelLabel = stats:FindFirstChild("LevelValue")

        if scoreLabel then
            scoreLabel.Text = tostring(gameStats.Score or 0)
        end

        if levelLabel then
            levelLabel.Text = tostring(gameStats.Level or 1)
        end

    end

    function interface.SetBest(bestScore)

        local bestLabel = stats:FindFirstChild("BestValue")

        if bestLabel then
            bestLabel.Text = tostring(bestScore or "--")
        end

    end

    -- ANIMACIÓN DE ENTRADA

    function interface.AnimateOpen()

        background.BackgroundTransparency = 0.25

        cabinet.Position = UDim2.fromScale(0.5, 1.5)

        local tween = TweenService:Create(
            cabinet,
            TweenInfo.new(
                0.65,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                Position = UDim2.fromScale(0.5, 0.5),
            }
        )

        local backgroundTween = TweenService:Create(
            background,
            TweenInfo.new(0.55),
            {
                BackgroundTransparency = 0,
            }
        )

        tween:Play()
        backgroundTween:Play()

        return tween

    end

    -- ANIMACIÓN DE SALIDA

    function interface.AnimateClose()

        local tween = TweenService:Create(
            cabinet,
            TweenInfo.new(
                0.5,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.In
            ),
            {
                Position = UDim2.fromScale(0.5, 1.5),
            }
        )

        local backgroundTween = TweenService:Create(
            background,
            TweenInfo.new(0.45),
            {
                BackgroundTransparency = 1,
            }
        )

        tween:Play()
        backgroundTween:Play()

        return tween

    end

    -- CIERRE DE LA INTERFAZ

    gui.Destroying:Connect(function()

        if startInputConnection then
            startInputConnection:Disconnect()
            startInputConnection = nil
        end

    end)

    -- BOTÓN DE SALIDA

    exitButton.Activated:Connect(function()

        if not interface then
            return
        end

        if currentView == "Gameplay"
            or currentView == "LevelTransition"
        then

            interface.ShowPauseScreen()

        else

            if onExit then
                onExit()
            end

        end

    end)

    -- ESTADO INICIAL

    showView("Start")

    -- REMACHES METÁLICOS

    createRivet(
        cabinet,
        UDim2.fromScale(0.025, 0.025)
    )

    createRivet(
        cabinet,
        UDim2.fromScale(0.975, 0.025)
    )

    createRivet(
        cabinet,
        UDim2.fromScale(0.025, 0.975)
    )

    createRivet(
        cabinet,
        UDim2.fromScale(0.975, 0.975)
    )

    return gui, interface

end

return MachineInterface
