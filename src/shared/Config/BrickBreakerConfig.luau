
--[[
    UNIVERSO ARCADE
    BrickBreakerConfig

    Configuración general del minijuego BrickBreaker.
]]

local BrickBreakerConfig = {}

-- REGLAS GENERALES
BrickBreakerConfig.Game = {
    InitialLives = 3,
    PointsPerBrick = 10,
    PointsPerLevel = 100,
}

-- TABLERO
BrickBreakerConfig.Board = {
    BrickRows = 10,
    BrickColumns = 10,
    BrickGap = 6,
}

-- PELOTA
BrickBreakerConfig.Ball = {
    InitialSpeed = 280,
    MaximumSpeed = 575,

    SpeedByLevel = {
        [1] = 280,
        [2] = 350,
        [3] = 405,
        [4] = 450,
        [5] = 475,
        [6] = 500,
        [7] = 520,
        [8] = 535,
        [9] = 545,
        [10] = 555,
        [11] = 560,
        [12] = 570,
        [13] = 575,
    },
}

-- POWER-UPS
BrickBreakerConfig.PowerUps = {

    -- Probabilidad general de caída por bloque destruido.
    DropChance = 0.15,

    FallSpeed = 185,
    Size = 24,

    -- Probabilidades relativas de cada power-up.
    -- La vida extra solamente puede caer una vez por nivel.
    DropWeights = {
        WidePaddle = 25,
        SlowBall = 22,
        ExtraLife = 8,
        ScoreBonus = 18,
        Shield = 12,
        Fireball = 8,
        MultiBall = 7,
    },

    -- PALA AMPLIADA
    PaddleWidthMultiplier = 1.5,
    PaddleDuration = 10,

    -- BOLA LENTA
    SlowBallMultiplier = 0.75,
    SlowBallDuration = 8,

    -- VIDA EXTRA
    ExtraLifeMax = 5,

    -- BONUS DE PUNTUACIÓN
    ScoreBonusPoints = 100,

    -- ESCUDO
    ShieldDuration = 12,
    ShieldExpiredPoints = 100,

    -- BOLA DE FUEGO
    FireballDuration = 3,

    -- MULTIBOLA
    MultiBallExtraCount = 2,
    MultiBallMaximum = 3,
    MultiBallAngle = 25,
    MultiBallDuplicatePoints = 100,

    -- MENSAJES
    MessageDuration = 2,
}

-- PALA
BrickBreakerConfig.Paddle = {
    WidthScale = 0.16,
    HeightScale = 0.025,
    Speed = 600,
}

return BrickBreakerConfig
