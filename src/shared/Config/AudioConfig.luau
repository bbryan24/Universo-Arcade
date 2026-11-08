
--[[
    UNIVERSO ARCADE
    AudioConfig

    Configuración centralizada de los sonidos
    de todas las máquinas recreativas.

    Los IDs de audio se incorporarán
    progresivamente al proyecto.
]]

local AudioConfig = {}

--==================================================
-- CONFIGURACIÓN GENERAL
--==================================================

AudioConfig.Settings = {

    Enabled = true,

    MasterVolume = 0.8,

    EffectsVolume = 0.8,

    MusicVolume = 0.5,

}

--==================================================
-- SONIDOS DE BLOCK PUZZLE
--==================================================

AudioConfig.BlockPuzzle = {

    Move = {
        SoundId = "rbxassetid://124243304900887",
        Volume = 0.25,
    },

    Rotate = {
        SoundId = "rbxassetid://101933360742354",
        Volume = 0.4,
    },

    Lock = {
        SoundId = "rbxassetid://98933370523341",
        Volume = 0.45,
    },

    LineClear = {
        SoundId = "rbxassetid://134726803249303",
        Volume = 0.65,
    },

    Tetris = {
        SoundId = "",
        Volume = 0.85,
    },

    LevelUp = {
        SoundId = "",
        Volume = 0.75,
    },

    GameOver = {
        SoundId = "",
        Volume = 0.7,
    },

}

--==================================================
-- SONIDOS DE BRICK BREAKER
--==================================================

AudioConfig.BrickBreaker = {

    PaddleHit = {
        SoundId = "",
        Volume = 0.45,
    },

    WallHit = {
        SoundId = "",
        Volume = 0.3,
    },

    BrickHit = {
        SoundId = "",
        Volume = 0.5,
    },

    PowerUp = {
        SoundId = "",
        Volume = 0.7,
    },

    LifeLost = {
        SoundId = "",
        Volume = 0.7,
    },

    LevelComplete = {
        SoundId = "",
        Volume = 0.8,
    },

    GameOver = {
        SoundId = "",
        Volume = 0.7,
    },

}

--==================================================
-- FUTUROS MINIJUEGOS
--==================================================

AudioConfig.SpaceShooter = {}

AudioConfig.BubbleShooter = {}

return AudioConfig
