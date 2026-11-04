
--[[
    UNIVERSO ARCADE
    WallDecorationService

    Decoracion geometrica de las paredes interiores
    de las cuatro salas arcade.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local MapConfig = require(
    ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("MapConfig")
)

local WallDecorationService = {}

-- =====================================================
-- CONFIGURACION VISUAL
-- =====================================================

local PANEL_COLOR = Color3.fromRGB(17, 19, 34)
local PANEL_INNER = Color3.fromRGB(27, 29, 49)
local METAL_COLOR = Color3.fromRGB(65, 65, 88)

-- =====================================================
-- CREAR PIEZA DECORATIVA
-- =====================================================

local function createDetail(
    parent,
    name,
    baseCFrame,
    offset,
    size,
    color,
    material,
    shape,
    rotation
)
    local part = Instance.new("Part")

    part.Name = name
    part.Size = size
    part.Anchored = true

    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false

    part.Color = color
    part.Material = material or Enum.Material.Metal

    if shape then
        part.Shape = shape
    end

    local localCFrame = CFrame.new(offset)

    if rotation then
        localCFrame *= CFrame.Angles(
            math.rad(rotation.X),
            math.rad(rotation.Y),
            math.rad(rotation.Z)
        )
    end

    part.CFrame = baseCFrame * localCFrame
    part.Parent = parent

    return part
end

-- =====================================================
-- CREAR UN PANEL GEOMETRICO
-- =====================================================

local function createWallPanel(
    parent,
    baseCFrame,
    accent,
    secondary,
    variant
)
    local panel = Instance.new("Model")
    panel.Name = "GeometricWallPanel"
    panel.Parent = parent

    -- Fondo principal.
    createDetail(
        panel,
        "PanelBacking",
        baseCFrame,
        Vector3.new(0, 0, 0),
        Vector3.new(5.6, 3.8, 0.16),
        PANEL_COLOR,
        Enum.Material.Metal
    )

    -- Superficie interior.
    createDetail(
        panel,
        "PanelSurface",
        baseCFrame,
        Vector3.new(0, 0, 0.10),
        Vector3.new(5.25, 3.45, 0.08),
        PANEL_INNER,
        Enum.Material.SmoothPlastic
    )

    -- Molduras exteriores.
    for _, side in ipairs({-1, 1}) do
        createDetail(
            panel,
            "HorizontalFrame",
            baseCFrame,
            Vector3.new(0, side * 1.78, 0.15),
            Vector3.new(5.5, 0.10, 0.08),
            METAL_COLOR,
            Enum.Material.Metal
        )

        createDetail(
            panel,
            "VerticalFrame",
            baseCFrame,
            Vector3.new(side * 2.68, 0, 0.15),
            Vector3.new(0.10, 3.55, 0.08),
            METAL_COLOR,
            Enum.Material.Metal
        )
    end

    -- Franja luminosa lateral.
    local stripeX = variant % 2 == 0 and -2.15 or 2.15

    createDetail(
        panel,
        "NeonAccent",
        baseCFrame,
        Vector3.new(stripeX, 0, 0.19),
        Vector3.new(0.12, 2.65, 0.07),
        accent,
        Enum.Material.Neon
    )

    -- Pieza geométrica diagonal.
    createDetail(
        panel,
        "DiamondShape",
        baseCFrame,
        Vector3.new(-0.65, 0.45, 0.19),
        Vector3.new(0.95, 0.95, 0.09),
        secondary,
        Enum.Material.Neon,
        nil,
        Vector3.new(0, 0, 45)
    )

    -- Triángulo decorativo.
    createDetail(
        panel,
        "TriangleShape",
        baseCFrame,
        Vector3.new(0.75, 0.45, 0.19),
        Vector3.new(1.15, 1.05, 0.08),
        accent,
        Enum.Material.Neon,
        Enum.PartType.Wedge
    )

    -- Círculo decorativo.
    createDetail(
        panel,
        "CircleShape",
        baseCFrame,
        Vector3.new(1.45, -0.95, 0.20),
        Vector3.new(0.65, 0.65, 0.09),
        secondary,
        Enum.Material.Neon,
        Enum.PartType.Ball
    )

    -- Pequeño indicador metálico.
    createDetail(
        panel,
        "StatusIndicator",
        baseCFrame,
        Vector3.new(-0.65, -1.05, 0.20),
        Vector3.new(1.2, 0.10, 0.08),
        accent,
        Enum.Material.Neon
    )

    -- Dos pequeños puntos luminosos.
    for index = 1, 2 do
        createDetail(
            panel,
            "SignalLight",
            baseCFrame,
            Vector3.new(
                1.05 + index * 0.35,
                1.15,
                0.20
            ),
            Vector3.new(0.12, 0.12, 0.08),
            accent,
            Enum.Material.Neon,
            Enum.PartType.Ball
        )
    end
end

-- =====================================================
-- DECORAR UNA PARED
-- =====================================================

local function decorateWall(
    parent,
    wallStart,
    wallCenter,
    normal,
    rotation,
    distances,
    accent,
    secondary
)
    for index, distance in ipairs(distances) do

        local position = wallStart + normal * distance

        local baseCFrame =
            CFrame.new(position)
            * CFrame.Angles(0, math.rad(rotation), 0)

        createWallPanel(
            parent,
            baseCFrame,
            accent,
            secondary,
            index
        )
    end
end

-- =====================================================
-- DECORAR LAS CUATRO SALAS
-- =====================================================

function WallDecorationService.Apply()

    local map = Workspace:WaitForChild("Map")
    local arcade = map:WaitForChild("Arcade")

    -- Evitar duplicar la decoracion.
    local oldFolder = arcade:FindFirstChild("WallDecorations")

    if oldFolder then
        oldFolder:Destroy()
    end

    local decorationFolder = Instance.new("Folder")
    decorationFolder.Name = "WallDecorations"
    decorationFolder.Parent = arcade

    local width = MapConfig.Arcade.Width
    local depth = MapConfig.Arcade.Depth

    local wallThickness = 1.5
    local floorY = MapConfig.Height.FloorY

    local wallHeight = 16
    local wallY = floorY + wallHeight / 2

    local diagonal = math.sqrt(2)
    local centerDistance = 18
    local halfOpening = 8

    local zones = {
        {
            Name = "BlockPuzzle",
            X = -1,
            Z = -1,
            Accent = Color3.fromRGB(0, 190, 255),
            Secondary = Color3.fromRGB(45, 75, 190),
        },
        {
            Name = "BubbleShooter",
            X = 1,
            Z = -1,
            Accent = Color3.fromRGB(255, 50, 190),
            Secondary = Color3.fromRGB(140, 55, 210),
        },
        {
            Name = "SpaceShooter",
            X = -1,
            Z = 1,
            Accent = Color3.fromRGB(100, 80, 255),
            Secondary = Color3.fromRGB(40, 55, 170),
        },
        {
            Name = "BrickBreaker",
            X = 1,
            Z = 1,
            Accent = Color3.fromRGB(255, 160, 35),
            Secondary = Color3.fromRGB(210, 75, 25),
        },
    }

    for _, zone in ipairs(zones) do

        local zoneFolder = Instance.new("Folder")
        zoneFolder.Name = zone.Name
        zoneFolder.Parent = decorationFolder

        local centerX = zone.X * centerDistance
        local centerZ = zone.Z * centerDistance

        -- Extremo de la pared lateral.
        local endpointAX =
            centerX + zone.X * halfOpening / diagonal

        local endpointAZ =
            centerZ - zone.Z * halfOpening / diagonal

        -- Extremo de la pared del fondo.
        local endpointBX =
            centerX - zone.X * halfOpening / diagonal

        local endpointBZ =
            centerZ + zone.Z * halfOpening / diagonal

        local outerX = zone.X * (width / 2 - 1)
        local outerZ = zone.Z * (depth / 2 - 1)

        -- PARED LATERAL.
        -- La decoracion mira hacia el interior de la sala.

        local lateralCenter = Vector3.new(
            (outerX + endpointAX) / 2,
            wallY,
            endpointAZ + zone.Z * (wallThickness / 2 + 0.10)
        )

        local lateralDistances = {7, 17, 27}

        decorateWall(
            zoneFolder,
            Vector3.new(outerX, wallY + 5.2, lateralCenter.Z),
            lateralCenter,
            Vector3.new(-zone.X, 0, 0),
            zone.Z == 1 and 0 or 180,
            lateralDistances,
            zone.Accent,
            zone.Secondary
        )

        -- PARED DEL FONDO.
        -- La decoracion tambien mira hacia el interior.

        local backCenter = Vector3.new(
            endpointBX + zone.X * (wallThickness / 2 + 0.10),
            wallY,
            (outerZ + endpointBZ) / 2
        )

        local backDistances = {6, 13, 20}

        decorateWall(
            zoneFolder,
            Vector3.new(backCenter.X, wallY + 5.2, outerZ),
            backCenter,
            Vector3.new(0, 0, -zone.Z),
            zone.X == 1 and 90 or -90,
            backDistances,
            zone.Accent,
            zone.Secondary
        )
    end

    print("[Universo Arcade] Decoracion de paredes aplicada.")
end

return WallDecorationService
