
--[[
    UNIVERSO ARCADE
    Configuración general del mapa.

    Todas las medidas están expresadas en studs.
    Norte = Z negativo.
    Sur   = Z positivo.
    Oeste = X negativo.
    Este  = X positivo.
]]

local MapConfig = {}

-- Dimensiones generales del salón arcade.
MapConfig.Arcade = {
    Width = 120,
    Depth = 100,
    Center = Vector3.new(0, 0, 0),
}

-- Alturas generales.
MapConfig.Height = {
    FloorThickness = 1,
    FloorY = 0,
}

-- Rotonda central.
MapConfig.CentralHub = {
    Diameter = 20,
    Radius = 10,
}

-- Corredores principales.
MapConfig.Corridors = {
    Width = 10,
}

-- Puertas de expansión.
MapConfig.ExpansionGates = {
    North = true,
    East = true,
    West = true,
}

-- Colores provisionales de las zonas.
MapConfig.ZoneColors = {
    BlockPuzzle = Color3.fromRGB(0, 190, 255),
    BubbleShooter = Color3.fromRGB(255, 50, 190),
    SpaceShooter = Color3.fromRGB(100, 80, 255),
    BrickBreaker = Color3.fromRGB(255, 160, 35),
}

return MapConfig
