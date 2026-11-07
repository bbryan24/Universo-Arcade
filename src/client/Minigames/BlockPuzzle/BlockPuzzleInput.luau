
--[[
    UNIVERSO ARCADE
    BlockPuzzleInput

    Gestiona los controles del jugador
    durante las partidas de BlockPuzzle.
]]

local UserInputService = game:GetService("UserInputService")

local BlockPuzzleInput = {}

local callbacks = {}
local pressedKeys = {}

local inputBeganConnection = nil
local inputEndedConnection = nil

-- EJECUTAR CALLBACK

local function callCallback(callbackName)

    local callback = callbacks[callbackName]

    if callback then
        callback()
    end
end

-- SOLTAR UNA TECLA

local function releaseKey(keyCode)

    if not pressedKeys[keyCode] then
        return
    end

    pressedKeys[keyCode] = nil

    if keyCode == Enum.KeyCode.A
        or keyCode == Enum.KeyCode.Left then

        callCallback("MoveLeftReleased")

    elseif keyCode == Enum.KeyCode.D
        or keyCode == Enum.KeyCode.Right then

        callCallback("MoveRightReleased")

    elseif keyCode == Enum.KeyCode.S
        or keyCode == Enum.KeyCode.Down then

        callCallback("SoftDropReleased")
    end
end

-- SOLTAR TODAS LAS TECLAS ACTIVAS

local function releaseAllKeys()

    for keyCode in pairs(pressedKeys) do
        releaseKey(keyCode)
    end

    pressedKeys = {}
end

-- INICIAR ESCUCHA DE CONTROLES

function BlockPuzzleInput.Start(newCallbacks)

    BlockPuzzleInput.Stop()

    callbacks = newCallbacks or {}

    inputBeganConnection = UserInputService.InputBegan:Connect(
        function(input, gameProcessed)

            if gameProcessed then
                return
            end

            if input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end

            local keyCode = input.KeyCode

            if pressedKeys[keyCode] then
                return
            end

            pressedKeys[keyCode] = true

            -- MOVIMIENTO IZQUIERDA

            if keyCode == Enum.KeyCode.A
                or keyCode == Enum.KeyCode.Left then

                callCallback("MoveLeftPressed")

            -- MOVIMIENTO DERECHA

            elseif keyCode == Enum.KeyCode.D
                or keyCode == Enum.KeyCode.Right then

                callCallback("MoveRightPressed")

            -- CAÍDA RÁPIDA

            elseif keyCode == Enum.KeyCode.S
                or keyCode == Enum.KeyCode.Down then

                callCallback("SoftDropPressed")

            -- CAÍDA INSTANTÁNEA

            elseif keyCode == Enum.KeyCode.Space then

                callCallback("HardDrop")

            -- GIRAR A LA DERECHA

            elseif keyCode == Enum.KeyCode.E
                or keyCode == Enum.KeyCode.Up then

                callCallback("RotateClockwise")

            -- GIRAR A LA IZQUIERDA

            elseif keyCode == Enum.KeyCode.Q then

                callCallback("RotateCounterClockwise")

            -- GUARDAR PIEZA

            elseif keyCode == Enum.KeyCode.C then

                callCallback("Hold")
            end
        end
    )

    inputEndedConnection = UserInputService.InputEnded:Connect(
        function(input)

            if input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end

            releaseKey(input.KeyCode)
        end
    )
end

-- DETENER ESCUCHA DE CONTROLES

function BlockPuzzleInput.Stop()

    releaseAllKeys()

    if inputBeganConnection then
        inputBeganConnection:Disconnect()
        inputBeganConnection = nil
    end

    if inputEndedConnection then
        inputEndedConnection:Disconnect()
        inputEndedConnection = nil
    end

    callbacks = {}
end

return BlockPuzzleInput
