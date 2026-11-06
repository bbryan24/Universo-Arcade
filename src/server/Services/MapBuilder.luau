
--[[
    UNIVERSO ARCADE
    MapBuilder

    Construye la estructura arquitectonica inicial
    del salon arcade.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local MapConfig = require(
    ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("MapConfig")
)

local MapBuilder = {}

-- =====================================================
-- FUNCION GENERAL PARA CREAR PIEZAS
-- =====================================================

local function createPart(parent, name, size, position, color, material)
    local part = Instance.new("Part")

    part.Name = name
    part.Size = size
    part.Position = position
    part.Anchored = true
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Color = color
    part.Material = material or Enum.Material.SmoothPlastic

    part.Parent = parent

    return part
end

-- =====================================================
-- SUELO
-- =====================================================


local function createFloor(parent)
    local arcade = MapConfig.Arcade
    local height = MapConfig.Height

    createPart(
        parent,
        "ArcadeFloor",
        Vector3.new(
            arcade.Width,
            height.FloorThickness,
            arcade.Depth
        ),
        Vector3.new(
            arcade.Center.X,
            height.FloorY - height.FloorThickness / 2,
            arcade.Center.Z
        ),
        Color3.fromRGB(13, 16, 33),
        Enum.Material.Fabric
    )
end





-- =====================================================
-- MOQUETA GEOMETRICA RETRO ARCADE
-- =====================================================

local function createFloorPattern(parent)
    local floorY = MapConfig.Height.FloorY

    local patternFolder = Instance.new("Folder")
    patternFolder.Name = "FloorPattern"
    patternFolder.Parent = parent

    local rng = Random.new(90210)

    -- Paleta de colores retro
    local colors = {
        Color3.fromRGB(25, 105, 145),  -- Azul cian
        Color3.fromRGB(45, 65, 145),   -- Azul arcade
        Color3.fromRGB(105, 55, 145),  -- Morado
        Color3.fromRGB(165, 55, 125),  -- Magenta
        Color3.fromRGB(190, 105, 45),  -- Naranja
        Color3.fromRGB(55, 115, 120),  -- Turquesa
    }

    -- -------------------------------------------------
    -- CREAR FIGURAS GEOMETRICAS
    -- -------------------------------------------------

    local function createShape(
        shapeType,
        x,
        z,
        sizeX,
        sizeZ,
        rotation,
        color
    )
        local piece

        if shapeType == "Circle" then
            piece = Instance.new("Part")
            piece.Shape = Enum.PartType.Cylinder

            piece.Size = Vector3.new(
                0.04,
                sizeX,
                sizeX
            )

        elseif shapeType == "Triangle" then
            piece = Instance.new("WedgePart")

            piece.Size = Vector3.new(
                sizeX,
                sizeZ,
                0.04
            )

        else
            piece = Instance.new("Part")

            piece.Size = Vector3.new(
                sizeX,
                0.04,
                sizeZ
            )
        end

        piece.Name = "GeometricFragment"

        if shapeType == "Circle" then
            piece.CFrame =
                CFrame.new(x, floorY + 0.025, z)
                * CFrame.Angles(0, 0, math.rad(90))

        elseif shapeType == "Triangle" then
            piece.CFrame =
                CFrame.new(x, floorY + 0.025, z)
                * CFrame.Angles(0, math.rad(rotation), 0)
                * CFrame.Angles(math.rad(90), 0, 0)

        else
            piece.CFrame =
                CFrame.new(x, floorY + 0.025, z)
                * CFrame.Angles(0, math.rad(rotation), 0)
        end

        piece.Anchored = true
        piece.CanCollide = false
        piece.CanTouch = false
        piece.CanQuery = false
        piece.CastShadow = false

        piece.Color = color
        piece.Material = Enum.Material.SmoothPlastic

        piece.TopSurface = Enum.SurfaceType.Smooth
        piece.BottomSurface = Enum.SurfaceType.Smooth

        piece.Parent = patternFolder
    end

    -- -------------------------------------------------
    -- COLECCION DE MOTIVOS GEOMETRICOS
    -- -------------------------------------------------

    -- Cada motivo tiene una composicion diferente.
    -- X y Z representan posiciones relativas al centro.
    -- A y B representan las dimensiones de cada figura.

    local motifs = {

        -- MOTIVO 1: triangulos y circulo
        {
            {"Triangle", -0.8, 0, 1.8, 1.5, 0},
            {"Triangle", 0.8, 0.4, 1.3, 1.2, 180},
            {"Circle", 0.5, -0.9, 0.75, 0, 0},
            {"Block", -0.7, 1.0, 1.2, 0.25, 45},
        },

        -- MOTIVO 2: rombos y bloques
        {
            {"Diamond", 0, 0, 1.5, 1.5, 0},
            {"Block", -1.0, 0.8, 1.1, 0.25, -35},
            {"Circle", 1.0, -0.8, 0.65, 0, 0},
        },

        -- MOTIVO 3: circulos y triangulos
        {
            {"Circle", -0.8, -0.5, 1.0, 0, 0},
            {"Circle", 0.9, 0.7, 0.55, 0, 0},
            {"Triangle", 0.8, -0.6, 1.5, 1.3, 90},
            {"Block", -0.5, 1.1, 1.4, 0.2, 25},
        },

        -- MOTIVO 4: composicion abstracta
        {
            {"Diamond", -0.7, -0.5, 1.2, 1.2, 0},
            {"Triangle", 0.8, 0.5, 1.5, 1.4, 180},
            {"Block", 0, -1.0, 1.8, 0.25, -20},
            {"Circle", 1.1, -0.8, 0.55, 0, 0},
        },
    }

    -- -------------------------------------------------
    -- COLOCAR UN MOTIVO EN EL SUELO
    -- -------------------------------------------------

    local function createMotif(centerX, centerZ)
        local motif = motifs[rng:NextInteger(1, #motifs)]

        local rotation = rng:NextInteger(0, 3) * 90

        local radians = math.rad(rotation)

        for _, figure in ipairs(motif) do
            local shapeType = figure[1]

            local offsetX = figure[2]
            local offsetZ = figure[3]

            -- Rotar la composicion completa
            local rotatedX =
                offsetX * math.cos(radians)
                - offsetZ * math.sin(radians)

            local rotatedZ =
                offsetX * math.sin(radians)
                + offsetZ * math.cos(radians)

            local x = centerX + rotatedX
                + rng:NextNumber(-0.15, 0.15)

            local z = centerZ + rotatedZ
                + rng:NextNumber(-0.15, 0.15)

            local sizeX = figure[4]
            local sizeZ = figure[5]

            local pieceRotation = rotation + figure[6]

            local color = colors[
                rng:NextInteger(1, #colors)
            ]

            createShape(
                shapeType,
                x,
                z,
                sizeX,
                sizeZ,
                pieceRotation,
                color
            )
        end
    end


    -- -------------------------------------------------
    -- DISTRIBUCION ORGANICA POR LAS CUATRO SALAS
    -- -------------------------------------------------

    local motifsPerRoom = 16

    -- Separacion minima entre los centros de los motivos.
    local minDistance = 8.5

    -- Limites de colocacion dentro de cada sala.
    local minX = 14
    local maxX = 55

    local minZ = 13
    local maxZ = 45

    -- Cada cuadrante se calcula de forma independiente.
    for _, xDirection in ipairs({-1, 1}) do
        for _, zDirection in ipairs({-1, 1}) do

            local placedMotifs = {}
            local attempts = 0
            local maxAttempts = 2000

            while #placedMotifs < motifsPerRoom
                and attempts < maxAttempts do

                attempts += 1

                -- Posicion completamente aleatoria.
                local xDistance = rng:NextNumber(minX, maxX)
                local zDistance = rng:NextNumber(minZ, maxZ)

                local x = xDirection * xDistance
                local z = zDirection * zDistance

                -- Comprobar distancia respecto a otros motivos.
                local validPosition = true

                for _, existing in ipairs(placedMotifs) do
                    local dx = x - existing.X
                    local dz = z - existing.Z

                    local distance = math.sqrt(
                        dx * dx + dz * dz
                    )

                    if distance < minDistance then
                        validPosition = false
                        break
                    end
                end

                -- Solo colocar el motivo si hay espacio suficiente.
                if validPosition then
                    createMotif(x, z)

                    table.insert(placedMotifs, {
                        X = x,
                        Z = z,
                    })
                end
            end

            print(
                "[Universo Arcade] Motivos colocados:",
                #placedMotifs,
                "de",
                motifsPerRoom
            )
        end
    end
end


    -- El hub central permanece sin patron.
    -- Los corredores tambien permanecen limpios.


-- =====================================================
-- ROTONDA CENTRAL
-- =====================================================

local function createCentralHub(parent)
    local hub = MapConfig.CentralHub
    local floorY = MapConfig.Height.FloorY

    local platform = Instance.new("Part")
    platform.Name = "CentralPlatform"
    platform.Shape = Enum.PartType.Cylinder
    platform.Size = Vector3.new(
        0.6,
        hub.Diameter,
        hub.Diameter
    )

    platform.Orientation = Vector3.new(0, 0, 90)
    platform.Position = Vector3.new(0, floorY + 0.3, 0)
    platform.Anchored = true
    platform.Color = Color3.fromRGB(65, 35, 105)
    platform.Material = Enum.Material.Neon
    platform.Parent = parent

    createPart(
        parent,
        "HologramBase",
        Vector3.new(4, 0.3, 4),
        Vector3.new(0, floorY + 0.75, 0),
        Color3.fromRGB(0, 220, 255),
        Enum.Material.Neon
    )
end

-- =====================================================
-- CORREDORES
-- =====================================================

local function createCorridors(parent)
    local arcade = MapConfig.Arcade
    local corridorWidth = MapConfig.Corridors.Width

    local corridorFolder = Instance.new("Folder")
    corridorFolder.Name = "Corridors"
    corridorFolder.Parent = parent

    local floorY = MapConfig.Height.FloorY + 0.02

    -- Norte y sur.
    for _, direction in ipairs({
        { Name = "North", Z = -1 },
        { Name = "South", Z = 1 },
    }) do
        local length = arcade.Depth / 2 - 10

        createPart(
            corridorFolder,
            direction.Name .. "Corridor",
            Vector3.new(corridorWidth, 0.05, length),
            Vector3.new(
                0,
                floorY,
                direction.Z * (10 + length / 2)
            ),
           Color3.fromRGB(40, 48, 82),
            Enum.Material.SmoothPlastic
        )
    end

    -- Este y oeste.
    for _, direction in ipairs({
        { Name = "West", X = -1 },
        { Name = "East", X = 1 },
    }) do
        local length = arcade.Width / 2 - 10

        createPart(
            corridorFolder,
            direction.Name .. "Corridor",
            Vector3.new(length, 0.05, corridorWidth),
            Vector3.new(
                direction.X * (10 + length / 2),
                floorY,
                0
            ),
            Color3.fromRGB(40, 48, 82),
            Enum.Material.SmoothPlastic
        )
    end
end

-- =====================================================
-- MARCOS DE ACCESO
-- =====================================================


local function createGateFrame(parent, name, orientation, position, openingWidth)
    local frameFolder = Instance.new("Folder")
    frameFolder.Name = name
    frameFolder.Parent = parent

    local floorY = MapConfig.Height.FloorY

    local frameColor = Color3.fromRGB(0, 200, 255)
    local frameMaterial = Enum.Material.Neon

    -- Dimensiones y separacion fisica.
    local wallThickness = 2
    local frameDepth = 2
    local gap = 0.15

    -- Distancia necesaria para que el marco quede
    -- completamente fuera de la pared.
    local separation = wallThickness / 2 + frameDepth / 2 + gap

    local framePosition

    if orientation == "Horizontal" then
        -- Norte: hacia el sur.
        -- Sur: hacia el norte.
        local inwardDirection = position.Z < 0 and 1 or -1

        framePosition = Vector3.new(
            position.X,
            0,
            position.Z + inwardDirection * separation
        )

        -- Columnas laterales.
        for _, direction in ipairs({ -1, 1 }) do
            createPart(
                frameFolder,
                "SidePillar",
                Vector3.new(2, 14, frameDepth),
                Vector3.new(
                    framePosition.X + direction * (openingWidth / 2 + 1),
                    floorY + 7,
                    framePosition.Z
                ),
                frameColor,
                frameMaterial
            )
        end

        -- Viga superior.
        createPart(
            frameFolder,
            "TopBeam",
            Vector3.new(openingWidth + 4, 2, frameDepth),
            Vector3.new(
                framePosition.X,
                floorY + 15,
                framePosition.Z
            ),
            frameColor,
            frameMaterial
        )

    else
        -- Oeste: hacia el este.
        -- Este: hacia el oeste.
        local inwardDirection = position.X < 0 and 1 or -1

        framePosition = Vector3.new(
            position.X + inwardDirection * separation,
            0,
            position.Z
        )

        -- Columnas laterales.
        for _, direction in ipairs({ -1, 1 }) do
            createPart(
                frameFolder,
                "SidePillar",
                Vector3.new(frameDepth, 14, 2),
                Vector3.new(
                    framePosition.X,
                    floorY + 7,
                    framePosition.Z + direction * (openingWidth / 2 + 1)
                ),
                frameColor,
                frameMaterial
            )
        end

        -- Viga superior.
        createPart(
            frameFolder,
            "TopBeam",
            Vector3.new(frameDepth, 2, openingWidth + 4),
            Vector3.new(
                framePosition.X,
                floorY + 15,
                framePosition.Z
            ),
            frameColor,
            frameMaterial
        )
    end
end

-- =====================================================
-- PERIMETRO DEL ARCADE
-- =====================================================

local function createArchitecture(parent)
    local arcade = MapConfig.Arcade

    local width = arcade.Width
    local depth = arcade.Depth

    local wallHeight = 16
    local wallThickness = 2

    local wallColor = Color3.fromRGB(28, 25, 45)

    local architectureFolder = Instance.new("Folder")
    architectureFolder.Name = "Architecture"
    architectureFolder.Parent = parent

    local perimeterFolder = Instance.new("Folder")
    perimeterFolder.Name = "Perimeter"
    perimeterFolder.Parent = architectureFolder

    local gatesFolder = Instance.new("Folder")
    gatesFolder.Name = "ExpansionGates"
    gatesFolder.Parent = architectureFolder

    local entranceFolder = Instance.new("Folder")
    entranceFolder.Name = "SouthEntrance"
    entranceFolder.Parent = architectureFolder

    -- Aperturas de los accesos.
    local expansionOpening = 16
    local southOpening = 18

    local wallY = MapConfig.Height.FloorY + wallHeight / 2

    -- Paredes norte y sur, dejando las aperturas.
    for _, side in ipairs({
        { Name = "North", Z = -(depth / 2 - 1), Opening = expansionOpening },
        { Name = "South", Z = depth / 2 - 1, Opening = southOpening },
    }) do
        local segmentLength = (width - side.Opening) / 2

        for _, direction in ipairs({ -1, 1 }) do
            createPart(
                perimeterFolder,
                side.Name .. "Wall",
                Vector3.new(segmentLength, wallHeight, wallThickness),
                Vector3.new(
                    direction * (side.Opening / 2 + segmentLength / 2),
                    wallY,
                    side.Z
                ),
                wallColor
            )
        end
    end

    -- Paredes este y oeste, dejando las aperturas.
    for _, side in ipairs({
        { Name = "West", X = -(width / 2 - 1) },
        { Name = "East", X = width / 2 - 1 },
    }) do
        local segmentLength = (depth - expansionOpening) / 2

        for _, direction in ipairs({ -1, 1 }) do
            createPart(
                perimeterFolder,
                side.Name .. "Wall",
                Vector3.new(wallThickness, wallHeight, segmentLength),
                Vector3.new(
                    side.X,
                    wallY,
                    direction * (expansionOpening / 2 + segmentLength / 2)
                ),
                wallColor
            )
        end
    end

    -- Acceso norte.
    createGateFrame(
        gatesFolder,
        "NorthGate",
        "Horizontal",
        Vector3.new(0, 0, -(depth / 2 - 1)),
        expansionOpening
    )

    -- Acceso oeste.
    createGateFrame(
        gatesFolder,
        "WestGate",
        "Vertical",
        Vector3.new(-(width / 2 - 1), 0, 0),
        expansionOpening
    )

    -- Acceso este.
    createGateFrame(
        gatesFolder,
        "EastGate",
        "Vertical",
        Vector3.new(width / 2 - 1, 0, 0),
        expansionOpening
    )

    -- Entrada sur hacia el pasillo cinematografico.
    createGateFrame(
        entranceFolder,
        "MainArcadeEntrance",
        "Horizontal",
        Vector3.new(0, 0, depth / 2 - 1),
        southOpening
    )
end

-- =====================================================
-- HABITACIONES ARCADE CON ENTRADAS DIAGONALES
-- =====================================================

local function createZoneArchitecture(parent)
    local arcade = MapConfig.Arcade

    local width = arcade.Width
    local depth = arcade.Depth

    local wallHeight = 16
    local wallThickness = 1.5
    local wallColor = Color3.fromRGB(28, 25, 45)

    local zonesFolder = Instance.new("Folder")
    zonesFolder.Name = "Zones"
    zonesFolder.Parent = parent

    local zones = {
        {
            Name = "BlockPuzzle",
            X = -1,
            Z = -1,
            Color = MapConfig.ZoneColors.BlockPuzzle,
        },
        {
            Name = "BubbleShooter",
            X = 1,
            Z = -1,
            Color = MapConfig.ZoneColors.BubbleShooter,
        },
        {
            Name = "SpaceShooter",
            X = -1,
            Z = 1,
            Color = MapConfig.ZoneColors.SpaceShooter,
        },
        {
            Name = "BrickBreaker",
            X = 1,
            Z = 1,
            Color = MapConfig.ZoneColors.BrickBreaker,
        },
    }

    local floorY = MapConfig.Height.FloorY
    local wallY = floorY + wallHeight / 2

    local centerDistance = 18
    local halfOpening = 8

    for _, zone in ipairs(zones) do
        local zoneFolder = Instance.new("Folder")
        zoneFolder.Name = zone.Name
        zoneFolder.Parent = zonesFolder

        -- Centro del arco.
        local centerX = zone.X * centerDistance
        local centerZ = zone.Z * centerDistance

        -- Extremos reales de las columnas del arco.
        local diagonal = math.sqrt(2)


        -- Extremo que conecta con la pared lateral.
        local endpointA = Vector3.new(
            centerX + zone.X * halfOpening / diagonal,
            0,
            centerZ - zone.Z * halfOpening / diagonal
        )

        -- Extremo que conecta con la pared del fondo.
        local endpointB = Vector3.new(
            centerX - zone.X * halfOpening / diagonal,
            0,
            centerZ + zone.Z * halfOpening / diagonal
        )

        -- Pared lateral: desde el primer extremo
        -- hasta la pared exterior de su mismo lado.
        local outerX = zone.X * (width / 2 - 1)

        local lateralLength = math.abs(outerX - endpointA.X)

        local lateral = Instance.new("Part")
        lateral.Name = "LateralRoomWall"
        lateral.Size = Vector3.new(
            lateralLength + wallThickness,
            wallHeight,
            wallThickness
        )
        lateral.Position = Vector3.new(
            (outerX + endpointA.X) / 2,
            wallY,
            endpointA.Z
        )
        lateral.Anchored = true
        lateral.Color = wallColor
        lateral.Material = Enum.Material.SmoothPlastic
        lateral.Parent = zoneFolder

        -- Pared del fondo: desde el segundo extremo
        -- hasta la pared exterior norte o sur.
        local outerZ = zone.Z * (depth / 2 - 1)

        local backLength = math.abs(outerZ - endpointB.Z)

        local back = Instance.new("Part")
        back.Name = "BackRoomWall"
        back.Size = Vector3.new(
            wallThickness,
            wallHeight,
            backLength + wallThickness
        )
        back.Position = Vector3.new(
            endpointB.X,
            wallY,
            (outerZ + endpointB.Z) / 2
        )
        back.Anchored = true
        back.Color = wallColor
        back.Material = Enum.Material.SmoothPlastic
        back.Parent = zoneFolder

        -- Columnas originales.
        local radial = Vector3.new(
            zone.X / diagonal,
            0,
            zone.Z / diagonal
        )

        local archTangent = Vector3.new(
            -radial.Z,
            0,
            radial.X
        )

        local center = Vector3.new(
            centerX,
            floorY,
            centerZ
        )

        for _, direction in ipairs({-1, 1}) do
            local pillarPosition =
                center + archTangent * direction * halfOpening

            local pillar = Instance.new("Part")
            pillar.Name = "ZonePillar"
            pillar.Size = Vector3.new(2, 14, 2)
            pillar.Position = pillarPosition + Vector3.new(0, 7, 0)
            pillar.Anchored = true
            pillar.Color = zone.Color
            pillar.Material = Enum.Material.Neon
            pillar.Parent = zoneFolder
        end

        -- Viga diagonal original.
        local beam = Instance.new("Part")
        beam.Name = "ZoneArchBeam"
        beam.Size = Vector3.new(18, 2, 2)
        beam.CFrame = CFrame.fromMatrix(
            center + Vector3.new(0, 15, 0),
            archTangent,
            Vector3.yAxis,
            -radial
        )
        beam.Anchored = true
        beam.Color = zone.Color
        beam.Material = Enum.Material.Neon
        beam.Parent = zoneFolder
    end
end


-- =====================================================
-- MAQUINAS ARCADE
-- =====================================================


local function createArcadeCabinet(parent, position, rotation, theme, variant)
	local model = Instance.new("Model")
	model.Name = theme.Name .. "_Machine_" .. variant
	model.Parent = parent

    -- Identificación de la recreativa.
model:SetAttribute(
    "MachineId",
    theme.Name .. "_" .. string.format("%02d", variant)
)

model:SetAttribute("MinigameId", theme.Name)
model:SetAttribute("MachineNumber", variant)
model:SetAttribute("ZoneId", theme.Name)
model:SetAttribute("DisplayName", theme.Title)

	local baseCFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0)

	local function makePart(name, size, offset, color, material, shape, angles)
		local part = Instance.new("Part")
		part.Name = name
		part.Size = size
		part.Anchored = true
		part.CanCollide = true
		part.Material = material or Enum.Material.SmoothPlastic
		part.Color = color or Color3.fromRGB(25, 25, 30)
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth

		if shape then
			part.Shape = shape
		end

		local localCFrame = CFrame.new(offset)

		if angles then
			localCFrame *= CFrame.Angles(
				math.rad(angles.X),
				math.rad(angles.Y),
				math.rad(angles.Z)
			)
		end

		part.CFrame = baseCFrame * localCFrame
		part.Parent = model

		return part
	end

	local dark = Color3.fromRGB(17, 18, 27)
	local black = Color3.fromRGB(5, 6, 11)
	local metal = Color3.fromRGB(75, 78, 90)
	local accent = theme.Accent
	local secondary = theme.Secondary

	-- BASE INFERIOR
	makePart(
		"LowerBase",
		Vector3.new(4.4, 0.65, 3.55),
		Vector3.new(0, 0.45, 0),
		black
	)

	makePart(
		"BaseAccent",
		Vector3.new(4.25, 0.12, 3.6),
		Vector3.new(0, 0.82, 0),
		accent,
		Enum.Material.Neon
	)

	-- CUERPO PRINCIPAL
	makePart(
		"MainCabinet",
		Vector3.new(4.15, 8.45, 3.25),
		Vector3.new(0, 5.15, 0),
		dark
	)

	-- LATERALES EXTERIORES
	for _, side in ipairs({-1, 1}) do
		makePart(
			"SideArmor",
			Vector3.new(0.16, 8.6, 3.45),
			Vector3.new(side * 2.12, 5.2, 0),
			secondary
		)

		makePart(
			"SideNeon",
			Vector3.new(0.08, 7.8, 0.12),
			Vector3.new(side * 2.22, 5.25, 0.05),
			accent,
			Enum.Material.Neon
		)

		makePart(
			"SideArtwork",
			Vector3.new(0.04, 5.3, 1.35),
			Vector3.new(side * 2.22, 5.5, -0.15),
			theme.Artwork,
			Enum.Material.Neon
		)

		makePart(
			"SideLowerDetail",
			Vector3.new(0.05, 1.1, 2.4),
			Vector3.new(side * 2.23, 2.1, 0),
			metal,
			Enum.Material.Metal
		)
	end

	-- MARCO SUPERIOR DE LA PANTALLA
	makePart(
		"ScreenHousing",
		Vector3.new(3.75, 3.25, 0.42),
		Vector3.new(0, 7.35, 1.73),
		black
	)

	makePart(
		"ScreenFrame",
		Vector3.new(3.48, 2.95, 0.16),
		Vector3.new(0, 7.35, 1.99),
		metal,
		Enum.Material.Metal
	)

	makePart(
		"ScreenGlass",
		Vector3.new(3.18, 2.62, 0.08),
		Vector3.new(0, 7.35, 2.105),
		theme.Screen,
		Enum.Material.Glass
	)

	makePart(
		"ScreenGlow",
		Vector3.new(3.08, 2.52, 0.025),
		Vector3.new(0, 7.35, 2.16),
		theme.Screen,
		Enum.Material.Neon
	)

	-- REFLEJO DECORATIVO DE LA PANTALLA
	makePart(
		"ScreenReflection",
		Vector3.new(0.65, 2.3, 0.012),
		Vector3.new(-1.12, 7.35, 2.18),
		Color3.fromRGB(190, 235, 255),
		Enum.Material.Glass
	)

	-- MARQUESINA SUPERIOR
	local marquee = makePart(
		"Marquee",
		Vector3.new(3.9, 1.05, 0.5),
		Vector3.new(0, 9.55, 1.55),
		accent,
		Enum.Material.Neon
	)

	makePart(
		"MarqueeFrame",
		Vector3.new(4.15, 1.25, 0.18),
		Vector3.new(0, 9.55, 1.38),
		black
	)

	-- TEXTO DE LA MARQUESINA
	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.Name = "MarqueeText"
	surfaceGui.Face = Enum.NormalId.Back
	surfaceGui.CanvasSize = Vector2.new(800, 220)
	surfaceGui.LightInfluence = 0
	surfaceGui.Parent = marquee

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromScale(1, 1)
	title.BackgroundTransparency = 1
	title.Text = theme.Title
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBlack
	title.TextStrokeTransparency = 0.25
	title.Parent = surfaceGui

	-- PANEL DE MANDOS INCLINADO
	makePart(
		"ControlPanel",
		Vector3.new(3.85, 0.3, 1.45),
		Vector3.new(0, 4.75, 1.75),
		black,
		Enum.Material.SmoothPlastic,
		nil,
		Vector3.new(-12, 0, 0)
	)

	makePart(
		"ControlPanelSurface",
		Vector3.new(3.55, 0.08, 1.25),
		Vector3.new(0, 4.92, 1.76),
		secondary,
		Enum.Material.SmoothPlastic,
		nil,
		Vector3.new(-12, 0, 0)
	)

	-- JOYSTICK
	makePart(
		"JoystickBase",
		Vector3.new(0.75, 0.13, 0.75),
		Vector3.new(-1.05, 5.05, 1.65),
		metal,
		Enum.Material.Metal,
		Enum.PartType.Cylinder
	)

	makePart(
		"JoystickStem",
		Vector3.new(0.16, 0.65, 0.16),
		Vector3.new(-1.05, 5.42, 1.65),
		metal,
		Enum.Material.Metal
	)

	makePart(
		"JoystickBall",
		Vector3.new(0.38, 0.38, 0.38),
		Vector3.new(-1.05, 5.78, 1.65),
		accent,
		Enum.Material.Neon,
		Enum.PartType.Ball
	)

	-- BOTONES FÍSICOS
	local buttonPositions = {
		Vector3.new(0.25, 5.12, 1.45),
		Vector3.new(0.75, 5.12, 1.65),
		Vector3.new(1.25, 5.12, 1.45),
		Vector3.new(0.75, 5.12, 1.05),
	}

	for index, offset in ipairs(buttonPositions) do
		local buttonColor = index % 2 == 0 and accent or secondary

		makePart(
			"ButtonRing_" .. index,
			Vector3.new(0.48, 0.12, 0.48),
			offset,
			metal,
			Enum.Material.Metal,
			Enum.PartType.Cylinder
		)

		makePart(
			"Button_" .. index,
			Vector3.new(0.34, 0.15, 0.34),
			offset + Vector3.new(0, 0.12, 0),
			buttonColor,
			Enum.Material.Neon,
			Enum.PartType.Ball
		)
	end

	-- RANURA DE MONEDAS
	makePart(
		"CoinSlotFrame",
		Vector3.new(1.05, 0.7, 0.12),
		Vector3.new(1.3, 3.5, 1.68),
		metal,
		Enum.Material.Metal
	)

	makePart(
		"CoinSlot",
		Vector3.new(0.48, 0.07, 0.035),
		Vector3.new(1.3, 3.57, 1.76),
		black
	)

	makePart(
		"CoinReturn",
		Vector3.new(0.75, 0.2, 0.12),
		Vector3.new(1.3, 3.15, 1.68),
		black
	)

	-- ALTAVOCES
	for _, side in ipairs({-1, 1}) do
		makePart(
			"Speaker",
			Vector3.new(0.65, 0.65, 0.12),
			Vector3.new(side * 1.35, 9.0, 1.7),
			black
		)

		for line = 1, 4 do
			makePart(
				"SpeakerGrill",
				Vector3.new(0.45, 0.035, 0.035),
				Vector3.new(side * 1.35, 8.78 + line * 0.13, 1.79),
				metal,
				Enum.Material.Metal
			)
		end
	end

	-- PUERTA DE SERVICIO FRONTAL
	makePart(
		"ServiceDoor",
		Vector3.new(1.65, 1.35, 0.08),
		Vector3.new(0, 2.0, 1.67),
		metal,
		Enum.Material.Metal
	)

	makePart(
		"ServiceDoorInner",
		Vector3.new(1.4, 1.1, 0.04),
		Vector3.new(0, 2.0, 1.73),
		black
	)

	makePart(
		"ServiceLock",
		Vector3.new(0.18, 0.18, 0.08),
		Vector3.new(0.55, 2.0, 1.78),
		accent,
		Enum.Material.Metal
	)

	-- PARTE TRASERA: PANEL DE MANTENIMIENTO

	makePart(
		"RearServicePanel",
		Vector3.new(2.7, 3.8, 0.12),
		Vector3.new(0, 4.8, -1.76),
		black,
		Enum.Material.Metal
	)

	makePart(
		"RearPanelBorder",
		Vector3.new(2.95, 4.05, 0.08),
		Vector3.new(0, 4.8, -1.72),
		secondary,
		Enum.Material.Metal
	)

	makePart(
		"RearPanelInner",
		Vector3.new(2.55, 3.65, 0.06),
		Vector3.new(0, 4.8, -1.84),
		dark,
		Enum.Material.Metal
	)

	-- REJILLAS DE VENTILACIÓN

	for line = 1, 7 do
		makePart(
			"RearVent_" .. line,
			Vector3.new(1.8, 0.07, 0.045),
			Vector3.new(0, 6.0 - line * 0.16, -1.89),
			metal,
			Enum.Material.Metal
		)
	end

	-- TORNILLOS DEL PANEL

	for _, x in ipairs({-1.15, 1.15}) do
		for _, y in ipairs({3.2, 6.4}) do
			makePart(
				"RearPanelScrew",
				Vector3.new(0.12, 0.12, 0.05),
				Vector3.new(x, y, -1.91),
				accent,
				Enum.Material.Metal,
				Enum.PartType.Ball
			)
		end
	end

	-- CABLEADO TRASERO

	local cablePositions = {-0.75, -0.25, 0.35, 0.85}

	for index, x in ipairs(cablePositions) do

		-- Cable vertical
		makePart(
			"RearCable_" .. index,
			Vector3.new(1.8, 0.13, 0.13),
			Vector3.new(x, 2.0, -2.0),
			black,
			Enum.Material.SmoothPlastic,
			Enum.PartType.Cylinder,
			Vector3.new(0, 0, 90)
		)

		-- Conector inferior
		makePart(
			"RearCableConnector_" .. index,
			Vector3.new(0.25, 0.3, 0.22),
			Vector3.new(x, 1.05, -2.0),
			index % 2 == 0 and accent or metal,
			Enum.Material.Metal
		)
	end

	-- PEQUEÑA LÍNEA LUMINOSA TRASERA

	makePart(
		"RearAccentLight",
		Vector3.new(2.3, 0.08, 0.06),
		Vector3.new(0, 6.95, -1.91),
		accent,
		Enum.Material.Neon
	)

	-- ILUMINACIÓN
	local lightPart = makePart(
		"CabinetLight",
		Vector3.new(0.2, 0.2, 0.2),
		Vector3.new(0, 8.0, 2.3),
		accent,
		Enum.Material.Neon
	)

	local light = Instance.new("PointLight")
	light.Color = accent
	light.Brightness = 1.5
	light.Range = 12
	light.Parent = lightPart

	model.PrimaryPart = model:FindFirstChild("LowerBase")

	return model
end



local function createMachinePlaceholders(arcadeFolder)

	-- Crear la carpeta de máquinas dentro del arcade.
	local oldFolder = arcadeFolder:FindFirstChild("ArcadeMachines")

	if oldFolder then
		oldFolder:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = "ArcadeMachines"
	folder.Parent = arcadeFolder

	local themes = {
		{
			Name = "BlockPuzzle",
			Title = "BLOCK PUZZLE",
			Accent = Color3.fromRGB(0, 210, 255),
			Secondary = Color3.fromRGB(35, 90, 220),
			Artwork = Color3.fromRGB(0, 130, 190),
			Screen = Color3.fromRGB(5, 35, 65),
		},
		{
			Name = "BubbleShooter",
			Title = "BUBBLE SHOOTER",
			Accent = Color3.fromRGB(255, 65, 190),
			Secondary = Color3.fromRGB(130, 45, 210),
			Artwork = Color3.fromRGB(190, 35, 150),
			Screen = Color3.fromRGB(55, 5, 65),
		},
		{
			Name = "SpaceShooter",
			Title = "SPACE SHOOTER",
			Accent = Color3.fromRGB(90, 100, 255),
			Secondary = Color3.fromRGB(35, 45, 150),
			Artwork = Color3.fromRGB(60, 45, 190),
			Screen = Color3.fromRGB(8, 8, 55),
		},
		{
			Name = "BrickBreaker",
			Title = "BRICK BREAKER",
			Accent = Color3.fromRGB(255, 155, 35),
			Secondary = Color3.fromRGB(220, 65, 20),
			Artwork = Color3.fromRGB(190, 85, 20),
			Screen = Color3.fromRGB(65, 25, 5),
		},
	}

	local machineNumber = 0

	local function addRoomMachines(theme, sideX, sideZ)

		-- Cuatro máquinas en la pared del fondo.
		local backPositions = {18, 27, 36, 45}

		for _, distance in ipairs(backPositions) do

			local x = sideX * distance
			local z = sideZ * 43

			local rotation = sideZ == -1 and 0 or 180

			machineNumber += 1

			createArcadeCabinet(
				folder,
				Vector3.new(x, 0, z),
				rotation,
				theme,
				machineNumber
			)
		end

		-- Cuatro máquinas en la pared lateral.
		local sidePositions = {18, 27, 36}

		for _, distance in ipairs(sidePositions) do

			local x = sideX * 53
			local z = sideZ * distance

			local rotation = sideX == -1 and 90 or 270

			machineNumber += 1

			createArcadeCabinet(
				folder,
				Vector3.new(x, 0, z),
				rotation,
				theme,
				machineNumber
			)
		end
	end

	-- NOROESTE
	addRoomMachines(themes[1], -1, -1)

	-- NORESTE
	addRoomMachines(themes[2], 1, -1)

	-- SUROESTE
	addRoomMachines(themes[3], -1, 1)

	-- SURESTE
	addRoomMachines(themes[4], 1, 1)

	print("[Universo Arcade] " .. machineNumber .. " máquinas creadas.")
end


-- =====================================================
-- TECHO DEL SALON ARCADE
-- =====================================================

local function createRoof(parent)
    local arcade = MapConfig.Arcade
    local center = arcade.Center

    local width = arcade.Width
    local depth = arcade.Depth

    local roofFolder = Instance.new("Folder")
    roofFolder.Name = "Roof"
    roofFolder.Parent = parent

    -- Altura de la cubierta.
    local roofY = MapConfig.Height.FloorY + 17.5

    -- Colores de la estructura.
    local roofColor = Color3.fromRGB(15, 15, 27)
    local beamColor = Color3.fromRGB(32, 29, 48)
    local detailColor = Color3.fromRGB(55, 48, 75)

    -- -------------------------------------------------
    -- CUATRO PANELES PRINCIPALES
    -- -------------------------------------------------

    local panelWidth = width / 2
    local panelDepth = depth / 2

    for _, xDirection in ipairs({-1, 1}) do
        for _, zDirection in ipairs({-1, 1}) do

            local panelX = center.X + xDirection * panelWidth / 2
            local panelZ = center.Z + zDirection * panelDepth / 2

            createPart(
                roofFolder,
                "RoofPanel",
                Vector3.new(
                    panelWidth,
                    1,
                    panelDepth
                ),
                Vector3.new(
                    panelX,
                    roofY,
                    panelZ
                ),
                roofColor,
                Enum.Material.Metal
            )
        end
    end

    -- -------------------------------------------------
    -- VIGAS ESTRUCTURALES TRANSVERSALES
    -- -------------------------------------------------

    local horizontalPositions = {
        -depth / 2 + 10,
        -depth / 2 + 30,
        center.Z,
        depth / 2 - 30,
        depth / 2 - 10,
    }

    for _, offsetZ in ipairs(horizontalPositions) do
        createPart(
            roofFolder,
            "MainRoofBeam",
            Vector3.new(
                width,
                1.2,
                1
            ),
            Vector3.new(
                center.X,
                roofY - 1.1,
                center.Z + offsetZ
            ),
            beamColor,
            Enum.Material.Metal
        )
    end

    -- -------------------------------------------------
    -- VIGAS ESTRUCTURALES LONGITUDINALES
    -- -------------------------------------------------

    local verticalPositions = {
        -width / 2 + 10,
        -width / 2 + 30,
        center.X,
        width / 2 - 30,
        width / 2 - 10,
    }

    for _, offsetX in ipairs(verticalPositions) do
        createPart(
            roofFolder,
            "SecondaryRoofBeam",
            Vector3.new(
                1,
                1.2,
                depth
            ),
            Vector3.new(
                center.X + offsetX,
                roofY - 1.1,
                center.Z
            ),
            beamColor,
            Enum.Material.Metal
        )
    end

    -- -------------------------------------------------
    -- CIERRE PERIMETRAL DEL TECHO
    -- -------------------------------------------------

    local perimeterHeight = 1
    local perimeterY = roofY - 1

    -- Norte y sur.
    for _, direction in ipairs({-1, 1}) do
        createPart(
            roofFolder,
            "RoofPerimeterBeam",
            Vector3.new(width, perimeterHeight, 2),
            Vector3.new(
                center.X,
                perimeterY,
                center.Z + direction * (depth / 2 - 1)
            ),
            beamColor,
            Enum.Material.Metal
        )
    end

    -- Este y oeste.
    for _, direction in ipairs({-1, 1}) do
        createPart(
            roofFolder,
            "RoofPerimeterBeam",
            Vector3.new(2, perimeterHeight, depth),
            Vector3.new(
                center.X + direction * (width / 2 - 1),
                perimeterY,
                center.Z
            ),
            beamColor,
            Enum.Material.Metal
        )
    end

    -- -------------------------------------------------
    -- DETALLES DECORATIVOS DE LAS VIGAS
    -- -------------------------------------------------

    for _, offsetZ in ipairs(horizontalPositions) do
        createPart(
            roofFolder,
            "RoofBeamDetail",
            Vector3.new(
                width,
                0.12,
                0.15
            ),
            Vector3.new(
                center.X,
                roofY - 1.73,
                center.Z + offsetZ
            ),
            detailColor,
            Enum.Material.Metal
        )
    end

    print("[Universo Arcade] Techo construido correctamente.")
end

-- =====================================================
-- CONSTRUCTOR PRINCIPAL
-- =====================================================

function MapBuilder.Build()
    -- Evitar duplicar construcciones.
    local oldMap = Workspace:FindFirstChild("Map")

    if oldMap then
        oldMap:Destroy()
    end

    local mapFolder = Instance.new("Folder")
    mapFolder.Name = "Map"
    mapFolder.Parent = Workspace

    local arcadeFolder = Instance.new("Folder")
    arcadeFolder.Name = "Arcade"
    arcadeFolder.Parent = mapFolder

    createFloor(arcadeFolder)
    createFloorPattern(arcadeFolder)
    createCentralHub(arcadeFolder)
    createCorridors(arcadeFolder)
    createArchitecture(arcadeFolder)
    createMachinePlaceholders(arcadeFolder)
    createZoneArchitecture(arcadeFolder)
    createRoof(arcadeFolder)

    print("[Universo Arcade] Salon arcade construido correctamente.")

    return mapFolder
end

    return MapBuilder