
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

}

-- OBTENER CONTROLADOR

function MinigameRegistry.GetController(minigameId)

    return controllers[minigameId]

end

return MinigameRegistry
