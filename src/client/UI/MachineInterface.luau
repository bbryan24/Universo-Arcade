
--[[
    UNIVERSO ARCADE
    MachineInterface

    Construye el mueble físico de las recreativas.
    Estética retro de los años 90 con gráficos impresos
    y acabados industriales opacos.
]]

local MachineInterface = {}

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

    -- FRANJA IMPRESA DE COLOR

    create("Frame", {

        Name = "ArtworkStripe",

        Position = UDim2.fromScale(0.15, 0.04),
        Size = UDim2.fromScale(0.7, 0.92),

        BackgroundColor3 = theme.Artwork,
        BorderSizePixel = 0,

    }, artwork)

    -- DETALLES GRÁFICOS

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

function MachineInterface.Create(minigameId, playerName, onExit)

    local theme = THEMES[minigameId] or THEMES.BrickBreaker

    local playerGui = game:GetService("Players")
        .LocalPlayer
        :WaitForChild("PlayerGui")

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

    -- BANDA SUPERIOR DEL MUEBLE

    local header = create("Frame", {

        Name = "Header",

        Position = UDim2.fromScale(0.045, 0.035),
        Size = UDim2.fromScale(0.91, 0.105),

        BackgroundColor3 = COLORS.CabinetDark,
        BorderSizePixel = 0,

    }, cabinet)

    addCorner(header, 6)
    addStroke(header, COLORS.MetalDark, 2)

    -- FRANJA DE IDENTIDAD IMPRESA

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

    -- PLACA METÁLICA DE IDENTIFICACIÓN

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

    }, cabinet)

    addCorner(exitButton, 4)

    exitButton.Activated:Connect(function()

        exitButton.Active = false
        exitButton.Text = "SALIENDO..."

        onExit()

    end)

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
    -- SE MANTIENE COMO HIJO DIRECTO DEL CABINET
    -- PARA CONSERVAR LA CONEXIÓN CON LOS MINIJUEGOS.

    create("Frame", {

        Name = "GameScreen",

        Position = UDim2.fromScale(0.055, 0.17),
        Size = UDim2.fromScale(0.89, 0.68),

        BackgroundColor3 = COLORS.ScreenBlack,
        BorderSizePixel = 0,

        ClipsDescendants = true,

    }, cabinet)

    -- DETALLES LATERALES IMPRESOS

    createSideArtwork(cabinet, theme, "Left")
    createSideArtwork(cabinet, theme, "Right")

    -- MARCA DECORATIVA SOBRE LA PANTALLA

    createLabel(
        cabinet,
        "CabinetSlogan",
        theme.Subtitle,
        UDim2.fromScale(0.45, 0.025),
        UDim2.fromScale(0.275, 0.135),
        10,
        COLORS.Muted
    )

    -- ESTADÍSTICAS INTEGRADAS EN LA PARTE INFERIOR

    local stats = create("Frame", {

        Name = "StatsPanel",

        Position = UDim2.fromScale(0.045, 0.885),
        Size = UDim2.fromScale(0.91, 0.075),

        BackgroundColor3 = COLORS.CabinetDark,
        BorderSizePixel = 0,

    }, cabinet)

    addCorner(stats, 5)
    addStroke(stats, COLORS.MetalDark, 2)

    -- SEPARADORES DE LAS ESTADÍSTICAS

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

    create("TextLabel", {
        Name = "ScoreValue",
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.025, 0.43),
        Size = UDim2.fromScale(0.28, 0.48),
        Text = "0",
        TextColor3 = COLORS.White,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        TextScaled = false,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, stats)

    -- LEVEL

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

    create("TextLabel", {
        Name = "LevelValue",
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.36, 0.43),
        Size = UDim2.fromScale(0.28, 0.48),
        Text = "1",
        TextColor3 = COLORS.White,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        TextScaled = false,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, stats)
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

    -- REMACHES METÁLICOS DEL MUEBLE

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

    return gui

end

return MachineInterface
