
--[[
    UNIVERSO ARCADE
    MachineInterface

    Construye la interfaz común de las recreativas.
    Cada minijuego utiliza su propia combinación de colores.
]]

local MachineInterface = {}

local THEMES = {
    BlockPuzzle = {
        Primary = Color3.fromRGB(0, 190, 255),
        Secondary = Color3.fromRGB(30, 90, 180),
        Background = Color3.fromRGB(5, 18, 35),
        DisplayName = "BLOCK PUZZLE",
    },

    BubbleShooter = {
        Primary = Color3.fromRGB(255, 50, 190),
        Secondary = Color3.fromRGB(150, 35, 120),
        Background = Color3.fromRGB(35, 8, 30),
        DisplayName = "BUBBLE SHOOTER",
    },

    SpaceShooter = {
        Primary = Color3.fromRGB(100, 80, 255),
        Secondary = Color3.fromRGB(55, 45, 160),
        Background = Color3.fromRGB(12, 8, 35),
        DisplayName = "SPACE SHOOTER",
    },

    BrickBreaker = {
        Primary = Color3.fromRGB(255, 160, 35),
        Secondary = Color3.fromRGB(180, 85, 20),
        Background = Color3.fromRGB(35, 17, 5),
        DisplayName = "BRICK BREAKER",
    },
}

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
    create("UIStroke", {
        Color = color,
        Thickness = thickness,
        Transparency = 0.15,
    }, parent)
end

local function createLabel(parent, text, size, position, fontSize, color)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Position = position,
        Size = size,
        Text = text,
        TextColor3 = color,
        TextSize = fontSize,
        Font = Enum.Font.GothamBold,
        TextScaled = false,
    }, parent)
end

function MachineInterface.Create(minigameId, playerName, onExit)

    local theme = THEMES[minigameId] or THEMES.BrickBreaker

    local gui = create("ScreenGui", {
        Name = "MachineInterface",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 50,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))

    -- Fondo general.
    local background = create("Frame", {
        Name = "ArcadeBackground",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(3, 5, 12),
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
    }, gui)

    -- Marco exterior de la recreativa.
    local cabinet = create("Frame", {
        Name = "CabinetFrame",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.88, 0.88),
        BackgroundColor3 = Color3.fromRGB(12, 13, 23),
        BorderSizePixel = 0,
    }, background)

    addCorner(cabinet, 18)
    addStroke(cabinet, theme.Primary, 3)

    -- Cabecera.
    local header = create("Frame", {
        Name = "Header",
        Position = UDim2.fromScale(0.025, 0.025),
        Size = UDim2.fromScale(0.95, 0.12),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
    }, cabinet)

    addCorner(header, 10)
    addStroke(header, theme.Primary, 2)

    createLabel(
        header,
        "UNIVERSO ARCADE",
        UDim2.fromScale(0.55, 0.4),
        UDim2.fromScale(0.025, 0.08),
        22,
        theme.Primary
    )

    createLabel(
        header,
        theme.DisplayName,
        UDim2.fromScale(0.55, 0.35),
        UDim2.fromScale(0.025, 0.53),
        17,
        Color3.fromRGB(235, 235, 245)
    )

    createLabel(
        header,
        "PLAYER: " .. string.upper(playerName),
        UDim2.fromScale(0.36, 0.7),
        UDim2.fromScale(0.62, 0.15),
        15,
        Color3.fromRGB(220, 220, 230)
    )

    -- Zona central de juego.
    local gameScreen = create("Frame", {
        Name = "GameScreen",
        Position = UDim2.fromScale(0.045, 0.17),
        Size = UDim2.fromScale(0.91, 0.53),
        BackgroundColor3 = Color3.fromRGB(2, 3, 9),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, cabinet)

    addCorner(gameScreen, 8)
    addStroke(gameScreen, theme.Secondary, 3)

    createLabel(
        gameScreen,
        "INSERT COIN. PLAY FOREVER.",
        UDim2.fromScale(0.9, 0.1),
        UDim2.fromScale(0.05, 0.1),
        16,
        theme.Primary
    )

    createLabel(
        gameScreen,
        "READY",
        UDim2.fromScale(0.9, 0.25),
        UDim2.fromScale(0.05, 0.35),
        42,
        Color3.fromRGB(245, 245, 255)
    )

    createLabel(
        gameScreen,
        "GAME INITIALIZING...",
        UDim2.fromScale(0.9, 0.1),
        UDim2.fromScale(0.05, 0.72),
        15,
        theme.Primary
    )

    -- Panel inferior de puntuación.
    local stats = create("Frame", {
        Name = "StatsPanel",
        Position = UDim2.fromScale(0.045, 0.72),
        Size = UDim2.fromScale(0.91, 0.09),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
    }, cabinet)

    addCorner(stats, 8)
    addStroke(stats, theme.Secondary, 2)

    createLabel(
        stats,
        "SCORE",
        UDim2.fromScale(0.3, 0.35),
        UDim2.fromScale(0.05, 0.1),
        15,
        theme.Primary
    )

    createLabel(
        stats,
        "0",
        UDim2.fromScale(0.3, 0.4),
        UDim2.fromScale(0.05, 0.48),
        20,
        Color3.fromRGB(255, 255, 255)
    )

    createLabel(
        stats,
        "BEST",
        UDim2.fromScale(0.3, 0.35),
        UDim2.fromScale(0.62, 0.1),
        15,
        theme.Primary
    )

    createLabel(
        stats,
        "--",
        UDim2.fromScale(0.3, 0.4),
        UDim2.fromScale(0.62, 0.48),
        20,
        Color3.fromRGB(255, 255, 255)
    )

    -- Representación visual de los controles físicos.
    local controls = create("Frame", {
        Name = "ControlsPanel",
        Position = UDim2.fromScale(0.045, 0.83),
        Size = UDim2.fromScale(0.91, 0.12),
        BackgroundColor3 = Color3.fromRGB(18, 19, 29),
        BorderSizePixel = 0,
    }, cabinet)

    addCorner(controls, 10)
    addStroke(controls, theme.Primary, 2)

    -- Joystick decorativo.
    local joystickBase = create("Frame", {
        Name = "JoystickBase",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.2, 0.55),
        Size = UDim2.fromOffset(62, 62),
        BackgroundColor3 = Color3.fromRGB(35, 37, 48),
        BorderSizePixel = 0,
    }, controls)

    addCorner(joystickBase, 50)
    addStroke(joystickBase, theme.Secondary, 3)

    create("Frame", {
        Name = "JoystickStick",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(13, 38),
        Rotation = -15,
        BackgroundColor3 = Color3.fromRGB(190, 195, 210),
        BorderSizePixel = 0,
    }, joystickBase)

    local joystickBall = create("Frame", {
        Name = "JoystickBall",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.2),
        Size = UDim2.fromOffset(24, 24),
        BackgroundColor3 = theme.Primary,
        BorderSizePixel = 0,
    }, joystickBase)

    addCorner(joystickBall, 50)

    -- Botones decorativos.
    local buttonPositions = {
        {x = 0.55, color = theme.Primary},
        {x = 0.68, color = theme.Secondary},
        {x = 0.81, color = Color3.fromRGB(235, 235, 245)},
    }

    for index, buttonInfo in ipairs(buttonPositions) do

        local button = create("Frame", {
            Name = "ActionButton" .. index,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(buttonInfo.x, 0.55),
            Size = UDim2.fromOffset(38, 38),
            BackgroundColor3 = buttonInfo.color,
            BorderSizePixel = 0,
        }, controls)

        addCorner(button, 50)
        addStroke(button, Color3.fromRGB(5, 5, 10), 2)

    end

    -- Salida.
    local exitButton = create("TextButton", {
        Name = "ExitButton",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.975, 0.025),
        Size = UDim2.fromOffset(110, 38),
        BackgroundColor3 = Color3.fromRGB(110, 25, 35),
        Text = "SALIR  [X]",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = true,
    }, cabinet)

    addCorner(exitButton, 7)

    exitButton.Activated:Connect(function()
        exitButton.Active = false
        exitButton.Text = "SALIENDO..."
        onExit()
    end)

    return gui
end

return MachineInterface
