
--[[
    UNIVERSO ARCADE
    WallArchitectureService

    Patrones geometricos distribuidos por toda
    la superficie de las paredes interiores.

    Arquitectura retrofuturista integrada.
    No modifica las paredes originales.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local MapConfig = require(
    ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("MapConfig")
)

local WallArchitectureService = {}

-- =====================================================
-- PALETA GENERAL
-- =====================================================

local COLORS = {
    Dark = Color3.fromRGB(25, 28, 44),
    Medium = Color3.fromRGB(35, 39, 57),
    Light = Color3.fromRGB(47, 51, 69),
    Metal = Color3.fromRGB(58, 62, 79),
}

-- =====================================================
-- CREAR DETALLE INTEGRADO EN LA PARED
-- =====================================================

local function createSurfacePart(
    parent,
    frame,
    name,
    x,
    y,
    width,
    height,
    color,
    rotation,
    shape
)
    local part = Instance.new("Part")

    part.Name = name
    part.Anchored = true

    part.Size = Vector3.new(
        width,
        height,
        0.035
    )

    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false

    part.Color = color
    part.Material = Enum.Material.SmoothPlastic

    if shape then
        part.Shape = shape
    end

    local offset =
        CFrame.new(x, y, 0.012)
        * CFrame.Angles(
            0,
            0,
            math.rad(rotation or 0)
        )

    part.CFrame = frame * offset
    part.Parent = parent

    return part
end

-- =====================================================
-- BLOCK PUZZLE
-- Cuadriculas irregulares y piezas encajadas.
-- =====================================================

local function createBlockPattern(
    parent,
    frame,
    x,
    y,
    variant,
    accent
)
    local direction = variant % 2 == 0 and 1 or -1

    -- Lineas que sugieren una cuadrícula rota.
    createSurfacePart(
        parent, frame, "BlockLine",
        x - 1.4, y + 0.65,
        2.3, 0.10,
        COLORS.Metal
    )

    createSurfacePart(
        parent, frame, "BlockLine",
        x + 0.8, y - 0.55,
        2.1, 0.10,
        COLORS.Medium
    )

    createSurfacePart(
        parent, frame, "BlockLine",
        x - 1.0, y - 0.55,
        0.10, 1.25,
        COLORS.Light
    )

    -- Piezas rectangulares integradas.
    createSurfacePart(
        parent, frame, "BlockSurface",
        x + direction * 1.15, y + 0.65,
        0.85, 0.85,
        COLORS.Medium
    )

    createSurfacePart(
        parent, frame, "BlockSurface",
        x - direction * 0.25, y - 0.55,
        0.85, 0.85,
        COLORS.Light
    )

    createSurfacePart(
        parent, frame, "BlockAccent",
        x + direction * 1.15, y + 0.65,
        0.10, 0.55,
        accent
    )
end

-- =====================================================
-- BUBBLE SHOOTER
-- Trayectorias curvas y arcos entrelazados.
-- =====================================================


local function createBubblePattern(
    parent,
    frame,
    x,
    y,
    variant,
    accent
)
    local direction = variant % 2 == 0 and 1 or -1

    -- Dibuja una curva Bézier cúbica mediante
    -- pequeños segmentos orientados según su trayectoria.
    local function drawSmoothCurve(
        name,
        p0,
        p1,
        p2,
        p3,
        color,
        thickness,
        segments
    )
        local previousX
        local previousY

        for index = 0, segments do
            local t = index / segments
            local inverse = 1 - t

            local bx =
                inverse ^ 3 * p0[1]
                + 3 * inverse ^ 2 * t * p1[1]
                + 3 * inverse * t ^ 2 * p2[1]
                + t ^ 3 * p3[1]

            local by =
                inverse ^ 3 * p0[2]
                + 3 * inverse ^ 2 * t * p1[2]
                + 3 * inverse * t ^ 2 * p2[2]
                + t ^ 3 * p3[2]

            local currentX = x + bx * direction
            local currentY = y + by

            if previousX ~= nil then
                local deltaX = currentX - previousX
                local deltaY = currentY - previousY

                local length = math.sqrt(
                    deltaX * deltaX + deltaY * deltaY
                )

                local angle = math.deg(
                    math.atan2(deltaY, deltaX)
                )

                createSurfacePart(
                    parent,
                    frame,
                    name,
                    (previousX + currentX) / 2,
                    (previousY + currentY) / 2,
                    length + 0.08,
                    thickness,
                    color,
                    angle
                )
            end

            previousX = currentX
            previousY = currentY
        end
    end

    -- Trayectoria principal: una curva amplia y fluida.
    drawSmoothCurve(
        "BubbleFlow",
        {-2.2, -0.65},
        {-1.8, 1.45},
        {0.65, 1.45},
        {2.15, 0.15},
        COLORS.Medium,
        0.065,
        18
    )

    -- Segunda trayectoria: una onda inferior,
    -- más abierta y con una dirección diferente.
    drawSmoothCurve(
        "BubbleFlowSecondary",
        {-2.0, -1.0},
        {-0.75, -1.8},
        {0.8, -1.55},
        {2.2, -0.65},
        COLORS.Light,
        0.055,
        18
    )

    -- Pequeños puntos que representan burbujas
    -- siguiendo el recorrido, sin formar agrupaciones.
    createSurfacePart(
        parent,
        frame,
        "BubbleDetail",
        x - 1.75 * direction,
        y + 0.95,
        0.22,
        0.22,
        accent,
        0,
        Enum.PartType.Ball
    )

    createSurfacePart(
        parent,
        frame,
        "BubbleDetail",
        x + 1.9 * direction,
        y - 0.15,
        0.30,
        0.30,
        COLORS.Medium,
        0,
        Enum.PartType.Ball
    )
end


-- =====================================================
-- SPACE SHOOTER
-- Diagonales, trayectorias y formas angulares.
-- =====================================================

local function createSpacePattern(
    parent,
    frame,
    x,
    y,
    variant,
    accent
)
    local direction = variant % 2 == 0 and 1 or -1

    createSurfacePart(
        parent, frame, "AngularLine",
        x - 1.15, y + 0.55,
        3.2, 0.11,
        COLORS.Light,
        32 * direction
    )

    createSurfacePart(
        parent, frame, "AngularLine",
        x + 0.8, y - 0.55,
        2.6, 0.09,
        COLORS.Medium,
        32 * direction
    )

    createSurfacePart(
        parent, frame, "AngularAccent",
        x - 1.25, y - 0.75,
        1.5, 0.09,
        accent,
        -32 * direction
    )

    createSurfacePart(
        parent, frame, "AngularShape",
        x + 1.65 * direction, y + 0.8,
        0.65, 0.65,
        COLORS.Dark,
        45
    )

    createSurfacePart(
        parent, frame, "AngularShape",
        x - 1.7 * direction, y - 0.1,
        0.45, 0.45,
        COLORS.Medium,
        45
    )
end

-- =====================================================
-- BRICK BREAKER
-- Bloques desplazados y lineas escalonadas.
-- =====================================================

local function createBrickPattern(
    parent,
    frame,
    x,
    y,
    variant,
    accent
)
    local direction = variant % 2 == 0 and 1 or -1

    -- Primera fila.
    createSurfacePart(
        parent, frame, "BrickLine",
        x - 1.45, y + 0.65,
        1.65, 0.38,
        COLORS.Light
    )

    createSurfacePart(
        parent, frame, "BrickLine",
        x + 0.35, y + 0.65,
        1.65, 0.38,
        COLORS.Medium
    )

    -- Segunda fila desplazada.
    createSurfacePart(
        parent, frame, "BrickLine",
        x - 0.55, y,
        1.65, 0.38,
        COLORS.Medium
    )

    createSurfacePart(
        parent, frame, "BrickLine",
        x + 1.25 * direction, y,
        1.45, 0.38,
        COLORS.Light
    )

    -- Tercera fila.
    createSurfacePart(
        parent, frame, "BrickLine",
        x - 1.45, y - 0.65,
        1.65, 0.38,
        COLORS.Medium
    )

    createSurfacePart(
        parent, frame, "BrickAccent",
        x + 0.35, y - 0.65,
        1.65, 0.38,
        accent
    )
end

-- =====================================================
-- GENERAR EL MOTIVO DE CADA SALA
-- =====================================================

local function createPattern(
    parent,
    frame,
    x,
    y,
    variant,
    zone
)
    if zone.Style == "Blocks" then

        createBlockPattern(
            parent, frame, x, y,
            variant, zone.Accent
        )

    elseif zone.Style == "Bubbles" then

        createBubblePattern(
            parent, frame, x, y,
            variant, zone.Accent
        )

    elseif zone.Style == "Angles" then

        createSpacePattern(
            parent, frame, x, y,
            variant, zone.Accent
        )

    elseif zone.Style == "Bricks" then

        createBrickPattern(
            parent, frame, x, y,
            variant, zone.Accent
        )
    end
end

-- =====================================================
-- DECORAR UNA PARED COMPLETA
-- =====================================================

local function decorateWall(
    parent,
    wallCenter,
    wallLength,
    yaw,
    normal,
    zone,
    wallName,
    wallThickness
)
    local folder = Instance.new("Folder")
    folder.Name = wallName
    folder.Parent = parent

    -- Superficie interior de la pared.
    local surfaceCenter =
        wallCenter
        + normal * (wallThickness / 2 + 0.015)

    local wallFrame =
        CFrame.new(surfaceCenter)
        * CFrame.Angles(0, math.rad(yaw), 0)

    -- Cinco columnas distribuidas a lo largo
    -- de la pared y tres franjas de altura.
    local columns = {
        -wallLength * 0.40,
        -wallLength * 0.20,
        0,
        wallLength * 0.20,
        wallLength * 0.40,
    }

    -- La zona superior queda reservada para
    -- los carteles suspendidos existentes.
    local rows = {
        -5.2,
        -2.0,
        1.2,
    }

    local variant = 0

    for rowIndex, y in ipairs(rows) do

        for columnIndex, x in ipairs(columns) do

            variant += 1

            -- Pequeña variación para evitar
            -- una cuadrícula demasiado perfecta.
            local offsetX =
                ((columnIndex + rowIndex) % 2 == 0)
                and 0.35 or -0.35

            local offsetY =
                ((columnIndex * rowIndex) % 2 == 0)
                and 0.18 or -0.18

            createPattern(
                folder,
                wallFrame,
                x + offsetX,
                y + offsetY,
                variant,
                zone
            )
        end
    end

    -- Líneas estructurales discretas en la
    -- parte inferior y en la separación superior.
    for _, height in ipairs({-6.7, 3.3}) do

        createSurfacePart(
            folder,
            wallFrame,
            "ArchitecturalGroove",
            0,
            height,
            wallLength - 1.5,
            0.075,
            COLORS.Metal
        )
    end
end

-- =====================================================
-- APLICAR A LAS CUATRO SALAS
-- =====================================================

function WallArchitectureService.Apply()

    local map = Workspace:WaitForChild("Map")
    local arcade = map:WaitForChild("Arcade")

    -- Limpiar únicamente la arquitectura anterior.
    local previous = arcade:FindFirstChild("WallArchitecture")

    if previous then
        previous:Destroy()
    end

    local architectureFolder = Instance.new("Folder")
    architectureFolder.Name = "WallArchitecture"
    architectureFolder.Parent = arcade

    local width = MapConfig.Arcade.Width
    local depth = MapConfig.Arcade.Depth

    local floorY = MapConfig.Height.FloorY

    local wallThickness = 1.5
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
            Accent = Color3.fromRGB(0, 115, 165),
            Style = "Blocks",
        },
        {
            Name = "BubbleShooter",
            X = 1,
            Z = -1,
            Accent = Color3.fromRGB(165, 45, 125),
            Style = "Bubbles",
        },
        {
            Name = "SpaceShooter",
            X = -1,
            Z = 1,
            Accent = Color3.fromRGB(85, 75, 175),
            Style = "Angles",
        },
        {
            Name = "BrickBreaker",
            X = 1,
            Z = 1,
            Accent = Color3.fromRGB(175, 105, 35),
            Style = "Bricks",
        },
    }

    for _, zone in ipairs(zones) do

        local zoneFolder = Instance.new("Folder")
        zoneFolder.Name = zone.Name
        zoneFolder.Parent = architectureFolder

        local centerX = zone.X * centerDistance
        local centerZ = zone.Z * centerDistance

        -- Extremos de las paredes originales.
        local endpointAX =
            centerX + zone.X * halfOpening / diagonal

        local endpointAZ =
            centerZ - zone.Z * halfOpening / diagonal

        local endpointBX =
            centerX - zone.X * halfOpening / diagonal

        local endpointBZ =
            centerZ + zone.Z * halfOpening / diagonal

        local outerX = zone.X * (width / 2 - 1)
        local outerZ = zone.Z * (depth / 2 - 1)

        -- =============================================
        -- PARED LATERAL
        -- =============================================

        local lateralCenter = Vector3.new(
            (outerX + endpointAX) / 2,
            wallY,
            endpointAZ
        )

        local lateralLength =
            math.abs(endpointAX - outerX)

        local lateralNormal =
            Vector3.new(0, 0, zone.Z)

        local lateralYaw =
            zone.Z == 1 and 0 or 180

        decorateWall(
            zoneFolder,
            lateralCenter,
            lateralLength,
            lateralYaw,
            lateralNormal,
            zone,
            "LateralWall",
            wallThickness
        )

        -- =============================================
        -- PARED DEL FONDO
        -- =============================================

        local backCenter = Vector3.new(
            endpointBX,
            wallY,
            (outerZ + endpointBZ) / 2
        )

        local backLength =
            math.abs(endpointBZ - outerZ)

        local backNormal =
            Vector3.new(zone.X, 0, 0)

        local backYaw =
            zone.X == 1 and 90 or -90

        decorateWall(
            zoneFolder,
            backCenter,
            backLength,
            backYaw,
            backNormal,
            zone,
            "BackWall",
            wallThickness
        )
    end

    print("[Universo Arcade] Patrones completos de pared aplicados.")
end

return WallArchitectureService
