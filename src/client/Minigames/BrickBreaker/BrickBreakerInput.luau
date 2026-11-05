
--[[
    UNIVERSO ARCADE
    BrickBreakerInput

    Gestiona:
    - Selección del método de control.
    - Movimiento mediante teclado.
    - Movimiento mediante ratón.
    - Lanzamiento de la pelota.
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local BrickBreakerInput = {}

local activeMode = "Keyboard"
local leftPressed = false
local rightPressed = false

local board = nil
local paddle = nil
local onLaunch = nil

local inputConnections = {}
local renderConnection = nil

local paddleSpeed = 600
local paddlePosition = 0.5

local function getMousePosition()

    local mousePosition = UserInputService:GetMouseLocation()
    local topLeftInset = GuiService:GetGuiInset()

    return mousePosition - topLeftInset
end

local function isMouseInsideBoard()

    if not board then
        return false
    end

    local mousePosition = getMousePosition()
    local boardPosition = board.AbsolutePosition
    local boardSize = board.AbsoluteSize

    return mousePosition.X >= boardPosition.X
        and mousePosition.X <= boardPosition.X + boardSize.X
        and mousePosition.Y >= boardPosition.Y
        and mousePosition.Y <= boardPosition.Y + boardSize.Y
end

local function updatePaddlePosition(deltaTime)

    if not board or not paddle then
        return
    end

    local boardWidth = board.AbsoluteSize.X

    if boardWidth <= 0 then
        return
    end

    local paddleWidth = paddle.AbsoluteSize.X
    local halfPaddle = paddleWidth / 2

    local minimumX = halfPaddle / boardWidth
    local maximumX = 1 - minimumX

    if activeMode == "Keyboard" then

        local direction = 0

        if leftPressed then
            direction -= 1
        end

        if rightPressed then
            direction += 1
        end

        paddlePosition +=
            direction * (paddleSpeed / boardWidth) * deltaTime

    elseif activeMode == "Mouse" then

        -- La pala sigue siempre el eje X del ratón.
        -- Si el ratón sale del tablero, la posición se limita
        -- automáticamente a los extremos.

        local mousePosition = getMousePosition()
        local boardPosition = board.AbsolutePosition

        paddlePosition =
            (mousePosition.X - boardPosition.X) / boardWidth
    end

    paddlePosition = math.clamp(
        paddlePosition,
        minimumX,
        maximumX
    )

    paddle.Position = UDim2.new(
        paddlePosition,
        0,
        paddle.Position.Y.Scale,
        paddle.Position.Y.Offset
    )
end

function BrickBreakerInput.SetMode(mode)

    if mode ~= "Keyboard" and mode ~= "Mouse" then
        return
    end

    activeMode = mode

    leftPressed = false
    rightPressed = false

    if paddle then
        paddlePosition = paddle.Position.X.Scale
    end
end

function BrickBreakerInput.GetMode()

    return activeMode
end

function BrickBreakerInput.Start(boardFrame, paddleFrame, launchCallback)

    BrickBreakerInput.Stop()

    board = boardFrame
    paddle = paddleFrame
    onLaunch = launchCallback

    if paddle then
        paddlePosition = paddle.Position.X.Scale
    end

    local function onInputBegan(input, gameProcessed)

        if activeMode == "Keyboard" then

            if gameProcessed then
                return
            end

            if input.KeyCode == Enum.KeyCode.A
                or input.KeyCode == Enum.KeyCode.Left then

                leftPressed = true

            elseif input.KeyCode == Enum.KeyCode.D
                or input.KeyCode == Enum.KeyCode.Right then

                rightPressed = true

            elseif input.KeyCode == Enum.KeyCode.Space then

                if onLaunch then
                    onLaunch()
                end
            end

        elseif activeMode == "Mouse" then

            if input.UserInputType == Enum.UserInputType.MouseButton1
                and isMouseInsideBoard() then

                if onLaunch then
                    onLaunch()
                end
            end
        end
    end

    local function onInputEnded(input)

        if input.KeyCode == Enum.KeyCode.A
            or input.KeyCode == Enum.KeyCode.Left then

            leftPressed = false

        elseif input.KeyCode == Enum.KeyCode.D
            or input.KeyCode == Enum.KeyCode.Right then

            rightPressed = false
        end
    end

    table.insert(
        inputConnections,
        UserInputService.InputBegan:Connect(onInputBegan)
    )

    table.insert(
        inputConnections,
        UserInputService.InputEnded:Connect(onInputEnded)
    )

    renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
        updatePaddlePosition(deltaTime)
    end)
end

function BrickBreakerInput.Stop()

    for _, connection in ipairs(inputConnections) do
        connection:Disconnect()
    end

    table.clear(inputConnections)

    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end

    leftPressed = false
    rightPressed = false

    board = nil
    paddle = nil
    onLaunch = nil
end

return BrickBreakerInput
