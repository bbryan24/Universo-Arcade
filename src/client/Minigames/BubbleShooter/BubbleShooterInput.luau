
--[[
    UNIVERSO ARCADE
    BubbleShooterInput

    Gestiona los controles de BubbleShooter.

    Controles:
    - A / Flecha izquierda: apuntar izquierda.
    - D / Flecha derecha: apuntar derecha.
    - Espacio: disparar (se conectará después).

    La lógica del juego permanece
    en BubbleShooterController.
]]

local UserInputService =
    game:GetService("UserInputService")

local BubbleShooterInput = {}

--==================================================
-- ESTADO
--==================================================

local inputBeganConnection = nil
local inputEndedConnection = nil

local leftPressed = false
local rightPressed = false

local onShootCallback = nil

--==================================================
-- DETENER CONTROLES
--==================================================

function BubbleShooterInput.Stop()

    if inputBeganConnection then
        inputBeganConnection:Disconnect()
        inputBeganConnection = nil
    end

    if inputEndedConnection then
        inputEndedConnection:Disconnect()
        inputEndedConnection = nil
    end

    leftPressed = false
    rightPressed = false

    onShootCallback = nil

end

--==================================================
-- INICIAR CONTROLES
--==================================================

function BubbleShooterInput.Start(onShoot)

    BubbleShooterInput.Stop()

    onShootCallback = onShoot

    inputBeganConnection =
        UserInputService.InputBegan:Connect(
            function(input, gameProcessed)

                if gameProcessed then
                    return
                end

                local key = input.KeyCode

                if key == Enum.KeyCode.A
                    or key == Enum.KeyCode.Left then

                    leftPressed = true

                elseif key == Enum.KeyCode.D
                    or key == Enum.KeyCode.Right then

                    rightPressed = true

                elseif key == Enum.KeyCode.Space then

                    if onShootCallback then
                        onShootCallback()
                    end

                end

            end
        )

    inputEndedConnection =
        UserInputService.InputEnded:Connect(
            function(input)

                local key = input.KeyCode

                if key == Enum.KeyCode.A
                    or key == Enum.KeyCode.Left then

                    leftPressed = false

                elseif key == Enum.KeyCode.D
                    or key == Enum.KeyCode.Right then

                    rightPressed = false

                end

            end
        )

end

--==================================================
-- OBTENER DIRECCIÓN DE APUNTADO
--==================================================

function BubbleShooterInput.GetAimDirection()

    if leftPressed and not rightPressed then
        return -1
    end

    if rightPressed and not leftPressed then
        return 1
    end

    return 0

end

return BubbleShooterInput
