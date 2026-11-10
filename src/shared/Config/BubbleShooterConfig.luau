
--[[
    UNIVERSO ARCADE
    BubbleShooterConfig

    Configuración principal de BubbleShooter.

    Inspirado en los juegos arcade clásicos
    de disparar y agrupar burbujas.

    Versión inicial: 0.1
]]

local BubbleShooterConfig = {}

--==================================================
-- TABLERO
--==================================================

BubbleShooterConfig.Board = {

    -- Columnas de referencia del tablero.
    -- Más adelante alternaremos filas para
    -- construir una cuadrícula hexagonal.

    Columns = 8,

    -- Filas máximas del tablero.

    Rows = 12,

    -- Filas ocupadas al empezar.

    InitialRows = 5,

    -- Separación visual entre burbujas.

    BubbleSpacing = 2,

}

--==================================================
-- LANZADOR
--==================================================

BubbleShooterConfig.Launcher = {

    -- Velocidad de desplazamiento
    -- de las burbujas disparadas.

    ProjectileSpeed = 420,

    -- Ángulo máximo de apuntado.
    -- No permitimos disparar hacia abajo.

    MaxAngle = 75,

    -- Velocidad de rotación del lanzador.

    AimSpeed = 150,

}

--==================================================
-- COLORES
--==================================================

BubbleShooterConfig.Colors = {

    Color3.fromRGB(235, 65, 85),   -- ROJO

    Color3.fromRGB(65, 145, 245),  -- AZUL

    Color3.fromRGB(80, 215, 130),  -- VERDE

    Color3.fromRGB(245, 205, 65),  -- AMARILLO

    Color3.fromRGB(185, 95, 240),  -- MORADO

}

--==================================================
-- PARTIDA
--==================================================

BubbleShooterConfig.Game = {

    InitialLevel = 1,

    InitialScore = 0,

    -- Número mínimo de burbujas conectadas
    -- para eliminarlas en futuras versiones.

    MatchCount = 3,

}

--==================================================
-- DESARROLLO
--==================================================

BubbleShooterConfig.Dev = {

    Enabled = true,

    ShowDebugInfo = true,

}

return BubbleShooterConfig
