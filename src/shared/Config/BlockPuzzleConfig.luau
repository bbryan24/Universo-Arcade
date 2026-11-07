
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

    InitialDropInterval = 0.65,

    SpeedMultiplier = 0.80,

    MinimumDropInterval = 0.06,

    SoftDropMultiplier = 20,

    InitialLinesPerLevel = 8,

    AdditionalLinesPerLevel = 1,

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
