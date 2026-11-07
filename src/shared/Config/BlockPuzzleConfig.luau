
--[[
    UNIVERSO ARCADE
    BlockPuzzleConfig

    Configuración general de BlockPuzzle.

    Define:
    - Dimensiones del tablero.
    - Velocidad y progresión.
    - Sistema de puntuación.
    - Mecánica HOLD.
    - Próximas piezas.
    - Colores y formas de los tetrominós.
]]

local BlockPuzzleConfig = {}

--==================================================
-- TABLERO
--==================================================

BlockPuzzleConfig.Board = {

    Columns = 10,
    Rows = 20,

    EmptyCellColor = Color3.fromRGB(19, 25, 42),

}

--==================================================
-- CONFIGURACIÓN DE PARTIDA
--==================================================


BlockPuzzleConfig.Game = {

    InitialLevel = 1,

    
    -- VELOCIDAD POR NIVEL.
    -- SEGUNDOS PARA DESCENDER UNA CASILLA.

    DropIntervals = {

        0.550, -- NIVEL 1
        0.390, -- NIVEL 2
        0.290, -- NIVEL 3
        0.230, -- NIVEL 4
        0.180, -- NIVEL 5
        0.150, -- NIVEL 6
        0.125, -- NIVEL 7
        0.110, -- NIVEL 8
        0.095, -- NIVEL 9
        0.083, -- NIVEL 10

        0.074, -- NIVEL 11
        0.066, -- NIVEL 12
        0.059, -- NIVEL 13
        0.053, -- NIVEL 14
        0.048, -- NIVEL 15
        0.044, -- NIVEL 16
        0.040, -- NIVEL 17
        0.037, -- NIVEL 18
        0.034, -- NIVEL 19
        0.031, -- NIVEL 20

        0.028, -- NIVEL 21
        0.025, -- NIVEL 22

    },


    SoftDropMultiplier = 20,

    InitialLinesPerLevel = 6,
    AdditionalLinesPerLevel = 1,
    LevelsPerLineIncrease = 2,

    -- TIEMPO DE CORTESÍA AL APOYAR UNA PIEZA

    LockDelay = 0.8,

    -- REINICIOS MÁXIMOS DEL TIEMPO DE CORTESÍA

    MaxLockResets = 15,

}


--==================================================
-- PUNTUACIÓN
--==================================================

BlockPuzzleConfig.Scoring = {

    Single = 100,
    Double = 300,
    Triple = 500,
    Tetris = 800,

    SoftDropPerCell = 1,
    HardDropPerCell = 2,

}

--==================================================
-- SIGUIENTES PIEZAS
--==================================================

BlockPuzzleConfig.Next = {

    VisiblePieces = 5,

    UseSevenBag = true,

}

--==================================================
-- SISTEMA HOLD
--==================================================

BlockPuzzleConfig.Hold = {

    Enabled = true,

    OncePerPiece = true,

}


--==================================================
-- HERRAMIENTAS DE DESARROLLO
--==================================================

BlockPuzzleConfig.Dev = {

    -- Activar herramientas de prueba.

    Enabled = true,

    -- Nivel mínimo y máximo seleccionable.

    MinimumLevel = 1,
    MaximumLevel = 22,

    -- Mostrar controles para cambiar de nivel.

    ShowLevelControls = true,

}


--==================================================
-- MOVIMIENTO HORIZONTAL
--==================================================

BlockPuzzleConfig.Movement = {

    InitialRepeatDelay = 0.17,

    RepeatInterval = 0.05,

}

--==================================================
-- TETROMINÓS
--==================================================

-- Cada pieza utiliza una matriz de 4x4.
-- X representa una casilla ocupada.
-- . representa una casilla vacía.

BlockPuzzleConfig.Pieces = {

    -- PIEZA I

    I = {

        Color = Color3.fromRGB(0, 225, 235),

        Shape = {
            "....",
            "XXXX",
            "....",
            "....",
        },

    },

    -- PIEZA O

    O = {

        Color = Color3.fromRGB(245, 215, 45),

        Shape = {
            ".XX.",
            ".XX.",
            "....",
            "....",
        },

    },

    -- PIEZA T

    T = {

        Color = Color3.fromRGB(175, 75, 225),

        Shape = {
            ".X..",
            "XXX.",
            "....",
            "....",
        },

    },

    -- PIEZA S

    S = {

        Color = Color3.fromRGB(75, 220, 95),

        Shape = {
            ".XX.",
            "XX..",
            "....",
            "....",
        },

    },

    -- PIEZA Z

    Z = {

        Color = Color3.fromRGB(235, 65, 75),

        Shape = {
            "XX..",
            ".XX.",
            "....",
            "....",
        },

    },

    -- PIEZA J

    J = {

        Color = Color3.fromRGB(65, 105, 235),

        Shape = {
            "X...",
            "XXX.",
            "....",
            "....",
        },

    },

    -- PIEZA L

    L = {

        Color = Color3.fromRGB(245, 145, 45),

        Shape = {
            "..X.",
            "XXX.",
            "....",
            "....",
        },

    },

}

--==================================================
-- ORDEN DE LAS PIEZAS
--==================================================

BlockPuzzleConfig.PieceNames = {
    "I",
    "O",
    "T",
    "S",
    "Z",
    "J",
    "L",
}

return BlockPuzzleConfig
