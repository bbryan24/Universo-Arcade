--[[
    UNIVERSO ARCADE
    Servicio de iluminación arquitectónica.

    Añade iluminación decorativa y funcional al salón:
    - Tiras LED en el techo.
    - Focos de iluminación general.
    - Iluminación especial para el hub central.
]]

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MapConfig = require(
    ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("MapConfig")
)

local ArcadeLightingService = {}

-- =====================================================
-- CREACIÓN DE PIEZAS
-- =====================================================

local function createLightPart(parent, name, size, position, color)
    local part = Instance.new("Part")

    part.Name = name
    part.Size = size
    part.Position = position
    part.Anchored = true

    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false

    part.Color = color
    part.Material = Enum.Material.Neon

    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth

    part.Parent = parent

    return part
end

-- =====================================================
-- LUCES FUNCIONALES
-- =====================================================

local function addPointLight(parent, name, color, brightness, range)
    local light = Instance.new("PointLight")

    light.Name = name
    light.Color = color
    light.Brightness = brightness
    light.Range = range
    light.Shadows = false

    light.Parent = parent

    return light
end

local function addSpotLight(parent, name, color, brightness, range, angle)
    local light = Instance.new("SpotLight")

    light.Name = name
    light.Color = color
    light.Brightness = brightness
    light.Range = range
    light.Angle = angle
    light.Face = Enum.NormalId.Bottom
    light.Shadows = false

    light.Parent = parent

    return light
end

-- =====================================================
-- ILUMINACIÓN DE LAS CUATRO SALAS
-- =====================================================

local function createRoomLighting(parent)
    local arcade = MapConfig.Arcade
    local floorY = MapConfig.Height.FloorY

    local roomWidth = arcade.Width / 2
    local roomDepth = arcade.Depth / 2

    local roomCenterX = roomWidth / 2
    local roomCenterZ = roomDepth / 2

    local ledY = floorY + 16.91
    local fixtureY = floorY + 16.4

    local ledLength = roomWidth - 12

    local rooms = {
        {
            Name = "BlockPuzzle",
            X = -1,
            Z = -1,
            Color = Color3.fromRGB(0, 190, 255),
        },
        {
            Name = "BubbleShooter",
            X = 1,
            Z = -1,
            Color = Color3.fromRGB(255, 50, 190),
        },
        {
            Name = "SpaceShooter",
            X = -1,
            Z = 1,
            Color = Color3.fromRGB(100, 80, 255),
        },
        {
            Name = "BrickBreaker",
            X = 1,
            Z = 1,
            Color = Color3.fromRGB(255, 160, 35),
        },
    }

    for _, room in ipairs(rooms) do
        local centerX = arcade.Center.X + room.X * roomCenterX
        local centerZ = arcade.Center.Z + room.Z * roomCenterZ

        -- Tira LED integrada visualmente en el techo.
        local led = createLightPart(
            parent,
            room.Name .. "_CeilingLED",
            Vector3.new(ledLength, 0.12, 0.2),
            Vector3.new(centerX, ledY, centerZ),
            room.Color
        )

        -- Resplandor suave de la propia tira.
        addPointLight(
            led,
            room.Name .. "_LEDGlow",
            room.Color,
            0.55,
            18
        )

        -- Foco principal de iluminación de la sala.
        local fixture = Instance.new("Part")

        fixture.Name = room.Name .. "_MainLight"
        fixture.Size = Vector3.new(0.3, 0.3, 0.3)
        fixture.Position = Vector3.new(centerX, fixtureY, centerZ)
        fixture.Anchored = true

        fixture.Transparency = 1
        fixture.CanCollide = false
        fixture.CanTouch = false
        fixture.CanQuery = false
        fixture.CastShadow = false

        fixture.Parent = parent

        addSpotLight(
            fixture,
            room.Name .. "_Downlight",
         Color3.fromRGB(215, 225, 255),
            2.8,
            45,
            110
        )

        -- Un pequeño toque de color ambiental por sala.
        addPointLight(
            fixture,
            room.Name .. "_AmbientGlow",
            room.Color,
            0.45,
            24
        )
    end
end

-- =====================================================
-- ILUMINACIÓN DEL HUB CENTRAL
-- =====================================================

local function createHubLighting(parent)
    local floorY = MapConfig.Height.FloorY

    local ledY = floorY + 16.91
    local fixtureY = floorY + 16.4

    local cyan = Color3.fromRGB(0, 220, 255)
    local purple = Color3.fromRGB(130, 75, 255)

    -- Dos tiras cruzadas sobre el centro.
    createLightPart(
        parent,
        "Hub_CeilingLED_Cyan",
        Vector3.new(8, 0.12, 0.18),
        Vector3.new(0, ledY, 0),
        cyan
    )

    createLightPart(
        parent,
        "Hub_CeilingLED_Purple",
        Vector3.new(0.18, 0.12, 8),
        Vector3.new(0, ledY, 0),
        purple
    )

    -- Luz central.
    local fixture = Instance.new("Part")

    fixture.Name = "Hub_CentralLight"
    fixture.Size = Vector3.new(0.3, 0.3, 0.3)
    fixture.Position = Vector3.new(0, fixtureY, 0)
    fixture.Anchored = true

    fixture.Transparency = 1
    fixture.CanCollide = false
    fixture.CanTouch = false
    fixture.CanQuery = false
    fixture.CastShadow = false

    fixture.Parent = parent

    addPointLight(
        fixture,
        "Hub_MainGlow",
        Color3.fromRGB(220, 230, 255),
        1.8,
        28
        )

    addSpotLight(
    fixture,
       "Hub_Downlight",
      Color3.fromRGB(220, 230, 255),
        2.5,
        28,
        100
    )
end

-- =====================================================
-- CONSTRUCTOR PRINCIPAL
-- =====================================================

function ArcadeLightingService.Apply()
    local map = Workspace:WaitForChild("Map")
    local arcade = map:WaitForChild("Arcade")

    -- Evitar duplicar luces al volver a ejecutar el servicio.
    local oldFolder = arcade:FindFirstChild("ArchitecturalLighting")

    if oldFolder then
        oldFolder:Destroy()
    end

    local lightingFolder = Instance.new("Folder")
    lightingFolder.Name = "ArchitecturalLighting"
    lightingFolder.Parent = arcade

    createRoomLighting(lightingFolder)
    createHubLighting(lightingFolder)

    print("[Universo Arcade] Iluminación arquitectónica aplicada.")
end

return ArcadeLightingService