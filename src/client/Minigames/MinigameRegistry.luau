
--[[
    UNIVERSO ARCADE
    MinigameRegistry

    Registro central de los controladores
    disponibles para los minijuegos.
]]

local MinigameRegistry = {}

-- CONTROLADORES REGISTRADOS

local controllers = {

    BrickBreaker = require(
        script.Parent
            :WaitForChild("BrickBreaker")
            :WaitForChild("BrickBreakerController")
    ),

    BlockPuzzle = require(
        script.Parent
            :WaitForChild("BlockPuzzle")
            :WaitForChild("BlockPuzzleController")
    ),

    BubbleShooter = require(
        script.Parent
            :WaitForChild("BubbleShooter")
            :WaitForChild("BubbleShooterController")
    ),

}

-- OBTENER CONTROLADOR

function MinigameRegistry.GetController(minigameId)

    return controllers[minigameId]

end

return MinigameRegistry
