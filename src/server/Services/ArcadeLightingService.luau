
--[[
    UNIVERSO ARCADE
    Servicio de iluminacion arquitectonica.

    Distribucion:
    - 4 focos blancos por sala.
    - 3 focos blancos por corredor.
    - 4 focos blancos en el hub central.
    - Tiras LED decorativas en el hub.
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
-- CONFIGURACION GENERAL
-- =====================================================

-- Los focos quedan por debajo de las vigas del techo.
local LIGHT_Y = MapConfig.Height.FloorY + 15.25

local WHITE = Color3.fromRGB(225, 235, 255)

-- =====================================================
-- CREACION DE FOCOS
-- =====================================================

local function createDownlight(
    parent,
    name,
    position,
    brightness,
    range,
    angle
)
    local fixture = Instance.new("Part")

    fixture.Name = name
    fixture.Size = Vector3.new(0.3, 0.3, 0.3)
    fixture.Position = position
    fixture.Anchored = true

    fixture.Transparency = 1
    fixture.CanCollide = false
    fixture.CanTouch = false
    fixture.CanQuery = false
    fixture.CastShadow = false

    fixture.Parent = parent

    local light = Instance.new("SpotLight")

    light.Name = name .. "_SpotLight"
    light.Color = WHITE
    light.Brightness = brightness
    light.Range = range
    light.Angle = angle
    light.Face = Enum.NormalId.Bottom
    light.Shadows = false

    light.Parent = fixture

    return fixture
end

-- =====================================================
-- CREACION DE TIRAS LED
-- =====================================================

local function createLED(
    parent,
    name,
    size,
    position,
    color
)
    local led = Instance.new("Part")

    led.Name = name
    led.Size = size
    led.Position = position
    led.Anchored = true

    led.CanCollide = false
    led.CanTouch = false
    led.CanQuery = false
    led.CastShadow = false

    led.Color = color
    led.Material = Enum.Material.Neon

    led.TopSurface = Enum.SurfaceType.Smooth
    led.BottomSurface = Enum.SurfaceType.Smooth

    led.Parent = parent

    return led
end

-- =====================================================
-- ILUMINACION DE LAS CUATRO SALAS
-- =====================================================

local function createRoomLighting(parent)
    local floorY = MapConfig.Height.FloorY

    local rooms = {
        {
            Name = "BlockPuzzle",
            X = -1,
            Z = -1,
        },
        {
            Name = "BubbleShooter",
            X = 1,
            Z = -1,
        },
        {
            Name = "SpaceShooter",
            X = -1,
            Z = 1,
        },
        {
            Name = "BrickBreaker",
            X = 1,
            Z = 1,
        },
    }

    -- Posiciones locales dentro de cada sala.
    -- Evitan las vigas y las filas de maquinas.
    local positions = {
        { X = 22, Z = 14 },
        { X = 42, Z = 14 },
        { X = 22, Z = 32 },
        { X = 42, Z = 32 },
    }

    for _, room in ipairs(rooms) do
        local roomFolder = Instance.new("Folder")
        roomFolder.Name = room.Name .. "_Lighting"
        roomFolder.Parent = parent

        for index, offset in ipairs(positions) do
            local position = Vector3.new(
                room.X * offset.X,
                LIGHT_Y,
                room.Z * offset.Z
            )

            createDownlight(
                roomFolder,
                room.Name .. "_MainLight_" .. index,
                position,
                3,
                38,
                100
            )
        end
    end
end

-- =====================================================
-- ILUMINACION DE LOS CUATRO CORREDORES
-- =====================================================

local function createCorridorLighting(parent)
    local corridorsFolder = Instance.new("Folder")
    corridorsFolder.Name = "CorridorLighting"
    corridorsFolder.Parent = parent

    local corridorPositions = {
        {
            Name = "North",
            Positions = {
                Vector3.new(0, LIGHT_Y, -16),
                Vector3.new(0, LIGHT_Y, -25),
                Vector3.new(0, LIGHT_Y, -34),
            },
        },
        {
            Name = "South",
            Positions = {
                Vector3.new(0, LIGHT_Y, 16),
                Vector3.new(0, LIGHT_Y, 25),
                Vector3.new(0, LIGHT_Y, 34),
            },
        },
        {
            Name = "West",
            Positions = {
                Vector3.new(-16, LIGHT_Y, 0),
                Vector3.new(-25, LIGHT_Y, 0),
                Vector3.new(-34, LIGHT_Y, 0),
            },
        },
        {
            Name = "East",
            Positions = {
                Vector3.new(16, LIGHT_Y, 0),
                Vector3.new(25, LIGHT_Y, 0),
                Vector3.new(34, LIGHT_Y, 0),
            },
        },
    }

    for _, corridor in ipairs(corridorPositions) do
        local corridorFolder = Instance.new("Folder")
        corridorFolder.Name = corridor.Name
        corridorFolder.Parent = corridorsFolder

        for index, position in ipairs(corridor.Positions) do
            createDownlight(
                corridorFolder,
                corridor.Name .. "_Light_" .. index,
                position,
                2,
                20,
                90
            )
        end
    end
end

-- =====================================================
-- ILUMINACION DEL HUB CENTRAL
-- =====================================================

local function createHubLighting(parent)
    local hubFolder = Instance.new("Folder")
    hubFolder.Name = "HubLighting"
    hubFolder.Parent = parent

    local hubPositions = {
        Vector3.new(-6, LIGHT_Y, 0),
        Vector3.new(6, LIGHT_Y, 0),
        Vector3.new(0, LIGHT_Y, -6),
        Vector3.new(0, LIGHT_Y, 6),
    }

    for index, position in ipairs(hubPositions) do
        createDownlight(
            hubFolder,
            "Hub_MainLight_" .. index,
            position,
            2.5,
            24,
            100
        )
    end

    -- Cuatro tiras LED formando un marco cuadrado.
    local ledY = MapConfig.Height.FloorY + 15.55

    local cyan = Color3.fromRGB(0, 210, 255)
    local purple = Color3.fromRGB(145, 75, 255)

    createLED(
        hubFolder,
        "Hub_LED_North",
        Vector3.new(7, 0.12, 0.18),
        Vector3.new(0, ledY, -7.5),
        cyan
    )

    createLED(
        hubFolder,
        "Hub_LED_South",
        Vector3.new(7, 0.12, 0.18),
        Vector3.new(0, ledY, 7.5),
        purple
    )

    createLED(
        hubFolder,
        "Hub_LED_West",
        Vector3.new(0.18, 0.12, 7),
        Vector3.new(-7.5, ledY, 0),
        purple
    )

    createLED(
        hubFolder,
        "Hub_LED_East",
        Vector3.new(0.18, 0.12, 7),
        Vector3.new(7.5, ledY, 0),
        cyan
    )
end

-- =====================================================
-- CONSTRUCTOR PRINCIPAL
-- =====================================================

function ArcadeLightingService.Apply()
    local map = Workspace:WaitForChild("Map")
    local arcade = map:WaitForChild("Arcade")

    -- Evitar duplicados al reiniciar el servicio.
    local oldFolder = arcade:FindFirstChild(
        "ArchitecturalLighting"
    )

    if oldFolder then
        oldFolder:Destroy()
    end

    local lightingFolder = Instance.new("Folder")
    lightingFolder.Name = "ArchitecturalLighting"
    lightingFolder.Parent = arcade

    createRoomLighting(lightingFolder)
    createCorridorLighting(lightingFolder)
    createHubLighting(lightingFolder)

    print(
        "[Universo Arcade] Iluminacion arquitectonica aplicada."
    )
end

return ArcadeLightingService
