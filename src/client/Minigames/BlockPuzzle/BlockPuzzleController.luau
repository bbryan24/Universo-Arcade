
--[[
    UNIVERSO ARCADE
    BlockPuzzleController

    Controlador principal de BlockPuzzle.

    Gestiona:
    - Tablero lógico.
    - Generación de tetrominós.
    - Bolsa aleatoria de siete piezas.
    - Movimiento y rotaciones.
    - Gravedad.
    - Colisiones.
    - Eliminación de líneas.
    - Puntuación y niveles.
    - HOLD y NEXT.
    - Pausa y reanudación.
    - GAME OVER y reinicio.
    - Limpieza de recursos.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

--==================================================
-- DEPENDENCIAS
--==================================================

local BlockPuzzleBoard = require(
    script.Parent:WaitForChild("BlockPuzzleBoard")
)

local BlockPuzzleInput = require(
    script.Parent:WaitForChild("BlockPuzzleInput")
)

local Config = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("BlockPuzzleConfig")
)

local BlockPuzzleController = {}

--==================================================
-- CONFIGURACIÓN
--==================================================

local COLUMNS = Config.Board.Columns
local ROWS = Config.Board.Rows

local EMPTY_COLOR = Config.Board.EmptyCellColor

local randomGenerator = Random.new()

--==================================================
-- ESTADO GENERAL
--==================================================

local elements = nil
local heartbeatConnection = nil
local restartInputConnection = nil

local running = false
local paused = false
local gameOver = false

local gameOverCallback = nil

local grid = {}

local currentPiece = nil
local holdPiece = nil

local holdUsed = false

local nextPieces = {}
local pieceBag = {}

local score = 0
local level = 1
local lines = 0

local gravityTimer = 0

--==================================================
-- ESTADO DE CONTROLES
--==================================================

local leftPressed = false
local rightPressed = false
local softDropPressed = false

local horizontalDirection = 0
local horizontalTimer = 0
local horizontalRepeating = false

--==================================================
-- CREAR CUADRÍCULA LÓGICA
--==================================================

local function createEmptyGrid()

    grid = {}

    for row = 1, ROWS do

        grid[row] = {}

        for column = 1, COLUMNS do
            grid[row][column] = nil
        end
    end
end

--==================================================
-- COPIAR MATRIZ DE UNA PIEZA
--==================================================

local function copyShape(shape)

    local result = {}

    for row = 1, 4 do
        result[row] = shape[row]
    end

    return result
end

--==================================================
-- BOLSA DE SIETE PIEZAS
--==================================================

local function refillBag()

    local bag = {}

    for _, pieceName in ipairs(Config.PieceNames) do
        table.insert(bag, pieceName)
    end

    -- Fisher-Yates

    for index = #bag, 2, -1 do

        local randomIndex = randomGenerator:NextInteger(
            1,
            index
        )

        bag[index], bag[randomIndex] =
            bag[randomIndex], bag[index]
    end

    for _, pieceName in ipairs(bag) do
        table.insert(pieceBag, pieceName)
    end
end

local function getRandomPiece()

    if #pieceBag == 0 then
        refillBag()
    end

    return table.remove(pieceBag, 1)
end

local function fillNextQueue()

    while #nextPieces < Config.Next.VisiblePieces do

        table.insert(
            nextPieces,
            getRandomPiece()
        )
    end
end

local function takeNextPiece()

    fillNextQueue()

    local pieceName = table.remove(nextPieces, 1)

    fillNextQueue()

    return pieceName
end

--==================================================
-- CREAR PIEZA
--==================================================

local function createPiece(pieceName)

    local definition = Config.Pieces[pieceName]

    return {
        Name = pieceName,

        Shape = copyShape(definition.Shape),

        Color = definition.Color,

        Row = 0,
        Column = 4,
    }
end

--==================================================
-- VALIDAR POSICIÓN
--==================================================

local function canPlace(shape, row, column)

    for shapeRow = 1, 4 do

        for shapeColumn = 1, 4 do

            if string.sub(
                shape[shapeRow],
                shapeColumn,
                shapeColumn
            ) == "X" then

                local boardRow = row + shapeRow - 1
                local boardColumn = column + shapeColumn - 1

                if boardColumn < 1
                    or boardColumn > COLUMNS then

                    return false
                end

                if boardRow > ROWS then
                    return false
                end

                if boardRow >= 1 then

                    if grid[boardRow][boardColumn] ~= nil then
                        return false
                    end
                end
            end
        end
    end

    return true
end

--==================================================
-- DIBUJAR PREVISUALIZACIONES
--==================================================

local function clearPreview(preview)

    if not preview then
        return
    end

    for _, child in ipairs(preview:GetChildren()) do

        if child:IsA("Frame")
            and child.Name == "PreviewCell" then

            child:Destroy()
        end
    end
end

local function drawPreview(preview, pieceName)

    if not preview then
        return
    end

    clearPreview(preview)

    if not pieceName then
        return
    end

    local definition = Config.Pieces[pieceName]
    local shape = definition.Shape

    for row = 1, 4 do

        for column = 1, 4 do

            if string.sub(
                shape[row],
                column,
                column
            ) == "X" then

                local cell = Instance.new("Frame")

                cell.Name = "PreviewCell"

                cell.Size = UDim2.new(
                    0.20, -2,
                    0.20, -2
                )

                cell.Position = UDim2.fromScale(
                    0.1 + ((column - 1) * 0.20),
                    0.1 + ((row - 1) * 0.20)
                )

                cell.BackgroundColor3 = definition.Color
                cell.BorderSizePixel = 0

                cell.Parent = preview
            end
        end
    end
end

local function updatePreviews()

    if not elements then
        return
    end

    drawPreview(
        elements.HoldPreview,
        holdPiece
    )

    for index, preview in ipairs(elements.NextPreviews) do

        drawPreview(
            preview,
            nextPieces[index]
        )
    end
end

--==================================================
-- ACTUALIZAR ESTADÍSTICAS
--==================================================


--==================================================
-- ACTUALIZAR ESTADÍSTICAS
--==================================================

local function updateHUD()

    if not elements then
        return
    end

    -- ESTADÍSTICAS DEL TABLERO DE BLOCKPUZZLE

    elements.ScoreLabel.Text = tostring(score)
    elements.LevelLabel.Text = tostring(level)
    elements.LinesLabel.Text = tostring(lines)

    -- COMUNICAR ESTADÍSTICAS A LA INTERFAZ GENERAL

    if gameOverCallback
        and gameOverCallback.onStatsChanged then

        gameOverCallback.onStatsChanged({

            Score = score,
            Level = level,
            Lines = lines,

        })

    end

end


--==================================================
-- DIBUJAR TABLERO
--==================================================

local function renderBoard()

    if not elements then
        return
    end

    for row = 1, ROWS do

        for column = 1, COLUMNS do

            local index = (row - 1) * COLUMNS + column

            local cell = elements.Cells[index]

            if cell then

                cell.BackgroundColor3 =
                    grid[row][column] or EMPTY_COLOR
            end
        end
    end

    if not currentPiece then
        return
    end

    for shapeRow = 1, 4 do

        for shapeColumn = 1, 4 do

            if string.sub(
                currentPiece.Shape[shapeRow],
                shapeColumn,
                shapeColumn
            ) == "X" then

                local row =
                    currentPiece.Row + shapeRow - 1

                local column =
                    currentPiece.Column + shapeColumn - 1

                if row >= 1 and row <= ROWS
                    and column >= 1 and column <= COLUMNS then

                    local index =
                        (row - 1) * COLUMNS + column

                    local cell = elements.Cells[index]

                    if cell then

                        cell.BackgroundColor3 =
                            currentPiece.Color
                    end
                end
            end
        end
    end
end

--==================================================
-- VELOCIDAD DE GRAVEDAD
--==================================================

local function getDropInterval()

    local gameConfig = Config.Game

    local interval =
        gameConfig.InitialDropInterval
        * (gameConfig.SpeedMultiplier ^ (level - 1))

    interval = math.max(
        gameConfig.MinimumDropInterval,
        interval
    )

    if softDropPressed then

        interval =
            interval / gameConfig.SoftDropMultiplier
    end

    return interval
end

--==================================================
-- FINALIZAR PARTIDA
--==================================================

local function finishGame()

    if gameOver then
        return
    end

    gameOver = true
    running = false
    paused = false

    BlockPuzzleInput.Stop()

    leftPressed = false
    rightPressed = false
    softDropPressed = false

    horizontalDirection = 0

    
    if gameOverCallback and gameOverCallback.onGameOver then

        gameOverCallback.onGameOver({

            Score = score,
            Level = level,
            Lines = lines,

        })

    end

end

--==================================================
-- APARECER NUEVA PIEZA
--==================================================

local function spawnPiece(pieceName)

    currentPiece = createPiece(pieceName)

    if not canPlace(
        currentPiece.Shape,
        currentPiece.Row,
        currentPiece.Column
    ) then

        currentPiece = nil

        renderBoard()
        finishGame()

        return false
    end

    updatePreviews()
    renderBoard()

    return true
end

local function spawnNextPiece()

    return spawnPiece(takeNextPiece())
end

--==================================================
-- ELIMINAR LÍNEAS COMPLETAS
--==================================================

local function clearCompletedLines()

    local cleared = 0
    local row = ROWS

    while row >= 1 do

        local complete = true

        for column = 1, COLUMNS do

            if grid[row][column] == nil then

                complete = false
                break
            end
        end

        if complete then

            table.remove(grid, row)

            local newRow = {}

            for column = 1, COLUMNS do
                newRow[column] = nil
            end

            table.insert(grid, 1, newRow)

            cleared += 1

            -- No bajamos de fila:
            -- hay que revisar la nueva fila
            -- que ha ocupado esta posición.

        else

            row -= 1
        end
    end

    if cleared == 0 then
        return
    end

    local scoring = Config.Scoring

    local points = {
        [1] = scoring.Single,
        [2] = scoring.Double,
        [3] = scoring.Triple,
        [4] = scoring.Tetris,
    }

    score += (points[cleared] or 0) * level

    lines += cleared

    
    -- PROGRESIÓN DE NIVELES
    -- Cada nivel requiere dos líneas más que el anterior.

    local remainingLines = lines
    local calculatedLevel = Config.Game.InitialLevel

    local requiredLines = Config.Game.InitialLinesPerLevel

    while remainingLines >= requiredLines do

        remainingLines -= requiredLines

        calculatedLevel += 1

        requiredLines += Config.Game.AdditionalLinesPerLevel

    end

    level = calculatedLevel


    updateHUD()
end

--==================================================
-- FIJAR PIEZA AL TABLERO
--==================================================

local function lockPiece()

    if not currentPiece then
        return
    end

    local lockedAboveBoard = false

    for shapeRow = 1, 4 do

        for shapeColumn = 1, 4 do

            if string.sub(
                currentPiece.Shape[shapeRow],
                shapeColumn,
                shapeColumn
            ) == "X" then

                local row =
                    currentPiece.Row + shapeRow - 1

                local column =
                    currentPiece.Column + shapeColumn - 1

                if row < 1 then

                    lockedAboveBoard = true

                elseif row <= ROWS
                    and column >= 1
                    and column <= COLUMNS then

                    grid[row][column] =
                        currentPiece.Color
                end
            end
        end
    end

    currentPiece = nil

    clearCompletedLines()

    updateHUD()

    if lockedAboveBoard then

        renderBoard()
        finishGame()

        return
    end

    holdUsed = false

    gravityTimer = 0

    spawnNextPiece()
end

--==================================================
-- MOVER PIEZA
--==================================================

local function movePiece(deltaRow, deltaColumn)

    if not running
        or paused
        or gameOver
        or not currentPiece then

        return false
    end

    local newRow = currentPiece.Row + deltaRow
    local newColumn = currentPiece.Column + deltaColumn

    if not canPlace(
        currentPiece.Shape,
        newRow,
        newColumn
    ) then

        return false
    end

    currentPiece.Row = newRow
    currentPiece.Column = newColumn

    renderBoard()

    return true
end

--==================================================
-- ROTAR MATRIZ
--==================================================

local function rotateShape(shape, clockwise)

    local rotated = {}

    for row = 1, 4 do

        local characters = {}

        for column = 1, 4 do

            local sourceRow
            local sourceColumn

            if clockwise then

                sourceRow = 5 - column
                sourceColumn = row

            else

                sourceRow = column
                sourceColumn = 5 - row
            end

            characters[column] = string.sub(
                shape[sourceRow],
                sourceColumn,
                sourceColumn
            )
        end

        rotated[row] = table.concat(characters)
    end

    return rotated
end

--==================================================
-- GIRAR PIEZA
--==================================================

local function rotatePiece(clockwise)

    if not running
        or paused
        or gameOver
        or not currentPiece then

        return
    end

    -- La pieza O conserva su orientación.

    if currentPiece.Name == "O" then
        return
    end

    local rotated = rotateShape(
        currentPiece.Shape,
        clockwise
    )

    -- Desplazamientos sencillos para permitir
    -- algunas rotaciones cerca de paredes.
    -- El sistema SRS completo se añadirá
    -- durante el pulido de las rotaciones.

    local offsets = {
        {0, 0},
        {0, -1},
        {0, 1},
        {0, -2},
        {0, 2},
        {-1, 0},
        {-2, 0},
    }

    for _, offset in ipairs(offsets) do

        local newRow =
            currentPiece.Row + offset[1]

        local newColumn =
            currentPiece.Column + offset[2]

        if canPlace(
            rotated,
            newRow,
            newColumn
        ) then

            currentPiece.Shape = rotated
            currentPiece.Row = newRow
            currentPiece.Column = newColumn

            renderBoard()

            return
        end
    end
end

--==================================================
-- CAÍDA DE UNA CASILLA
--==================================================

local function dropOneRow()

    if movePiece(1, 0) then
        return true
    end

    if running and not paused and not gameOver then
        lockPiece()
    end

    return false
end

--==================================================
-- CAÍDA INSTANTÁNEA
--==================================================

local function hardDrop()

    if not running
        or paused
        or gameOver
        or not currentPiece then

        return
    end

    local distance = 0

    while movePiece(1, 0) do
        distance += 1
    end

    score += distance * Config.Scoring.HardDropPerCell

    updateHUD()

    lockPiece()
end

--==================================================
-- SISTEMA HOLD
--==================================================

local function holdCurrentPiece()

    if not running
        or paused
        or gameOver
        or not currentPiece then

        return
    end

    if not Config.Hold.Enabled then
        return
    end

    if Config.Hold.OncePerPiece and holdUsed then
        return
    end

    holdUsed = true

    local oldPieceName = currentPiece.Name

    currentPiece = nil

    gravityTimer = 0

    if holdPiece then

        local storedPieceName = holdPiece

        holdPiece = oldPieceName

        spawnPiece(storedPieceName)

    else

        holdPiece = oldPieceName

        spawnNextPiece()
    end

    updatePreviews()
end

--==================================================
-- MOVIMIENTO HORIZONTAL CONTINUO
--==================================================

local function updateHorizontalDirection()

    local direction = 0

    if leftPressed and not rightPressed then
        direction = -1
    elseif rightPressed and not leftPressed then
        direction = 1
    end

    if horizontalDirection == direction then
        return
    end

    horizontalDirection = direction
    horizontalTimer = 0
    horizontalRepeating = false

    if direction ~= 0 then
        movePiece(0, direction)
    end
end

local function updateHorizontalMovement(deltaTime)

    if horizontalDirection == 0 then
        return
    end

    horizontalTimer += deltaTime

    if not horizontalRepeating then

        if horizontalTimer
            < Config.Movement.InitialRepeatDelay then

            return
        end

        horizontalTimer -=
            Config.Movement.InitialRepeatDelay

        horizontalRepeating = true

        movePiece(0, horizontalDirection)
    end

    while horizontalTimer >= Config.Movement.RepeatInterval do

        horizontalTimer -=
            Config.Movement.RepeatInterval

        movePiece(0, horizontalDirection)
    end
end

--==================================================
-- CONFIGURAR CONTROLES
--==================================================

local function startInput()

    BlockPuzzleInput.Start({

        MoveLeftPressed = function()

            leftPressed = true
            updateHorizontalDirection()
        end,

        MoveLeftReleased = function()

            leftPressed = false
            updateHorizontalDirection()
        end,

        MoveRightPressed = function()

            rightPressed = true
            updateHorizontalDirection()
        end,

        MoveRightReleased = function()

            rightPressed = false
            updateHorizontalDirection()
        end,

        SoftDropPressed = function()

            softDropPressed = true
            gravityTimer = 0
        end,

        SoftDropReleased = function()

            softDropPressed = false
            gravityTimer = 0
        end,

        HardDrop = function()
            hardDrop()
        end,

        RotateClockwise = function()
            rotatePiece(true)
        end,

        RotateCounterClockwise = function()
            rotatePiece(false)
        end,

        Hold = function()
            holdCurrentPiece()
        end,
    })
end

--==================================================
-- ACTUALIZAR PARTIDA
--==================================================

local function updateGame(deltaTime)

    if not running or paused or gameOver then
        return
    end

    updateHorizontalMovement(deltaTime)

    gravityTimer += deltaTime

    local interval = getDropInterval()

    if gravityTimer >= interval then

        gravityTimer -= interval

        local moved = dropOneRow()

        if moved and softDropPressed then

            score += Config.Scoring.SoftDropPerCell

            updateHUD()
        end

        -- Limitamos la acumulación de tiempo
        -- para evitar caídas bruscas.

        gravityTimer = math.min(
            gravityTimer,
            getDropInterval()
        )
    end
end

--==================================================
-- RESTABLECER ESTADO DE PARTIDA
--==================================================

local function resetState()

    createEmptyGrid()

    currentPiece = nil
    holdPiece = nil

    holdUsed = false

    nextPieces = {}
    pieceBag = {}

    score = 0
    level = Config.Game.InitialLevel
    lines = 0

    gravityTimer = 0

    leftPressed = false
    rightPressed = false
    softDropPressed = false

    horizontalDirection = 0
    horizontalTimer = 0
    horizontalRepeating = false

    running = true
    paused = false
    gameOver = false

    fillNextQueue()

    updateHUD()
    updatePreviews()
    renderBoard()

    spawnNextPiece()
end

--==================================================
-- INICIAR PARTIDA
--==================================================

function BlockPuzzleController.Start(parent, onGameOver)

    -- Evitar tableros o conexiones duplicadas.

    BlockPuzzleController.Stop()

    if not parent then
        warn("BlockPuzzle: falta el contenedor visual.")
        return false
    end

    if not parent:IsA("GuiObject") then
        warn("BlockPuzzle: el contenedor debe ser un GuiObject.")
        return false
    end

    gameOverCallback = onGameOver

    elements = BlockPuzzleBoard.Create(parent)

    resetState()

    startInput()

    
    heartbeatConnection = RunService.Heartbeat:Connect(
        function(deltaTime)

            updateGame(math.min(deltaTime, 0.1))
        end
    )

    -- REINICIAR DESPUÉS DE GAME OVER

    restartInputConnection = UserInputService.InputBegan:Connect(
        function(input, gameProcessed)

            if not gameOver or not elements then
                return
            end

            local restartRequested = false

            -- REINICIAR CON ESPACIO

            if input.KeyCode == Enum.KeyCode.Space
                and not gameProcessed then

                restartRequested = true

            -- REINICIAR CON CLIC DENTRO DE LA PANTALLA

            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then

                local mousePosition =
                    UserInputService:GetMouseLocation()
                    - GuiService:GetGuiInset()

                local screen = elements.Container.Parent

                if screen and screen:IsA("GuiObject") then

                    local position = screen.AbsolutePosition
                    local size = screen.AbsoluteSize

                    restartRequested =
                        mousePosition.X >= position.X
                        and mousePosition.X <= position.X + size.X
                        and mousePosition.Y >= position.Y
                        and mousePosition.Y <= position.Y + size.Y
                end
            end

            if not restartRequested then
                return
            end

            -- RESTAURAR PANTALLA DE JUEGO

            if gameOverCallback
                and gameOverCallback.onRestart then

                gameOverCallback.onRestart()
            end

            -- REINICIAR TABLERO Y ESTADÍSTICAS

            BlockPuzzleController.Reset()
        end
    )

    return true

end

--==================================================
-- PAUSAR PARTIDA
--==================================================

function BlockPuzzleController.Pause()

    if not running or paused or gameOver then
        return
    end

    paused = true

    BlockPuzzleInput.Stop()

    leftPressed = false
    rightPressed = false
    softDropPressed = false

    horizontalDirection = 0
    horizontalTimer = 0
    horizontalRepeating = false
end

--==================================================
-- REANUDAR PARTIDA
--==================================================

function BlockPuzzleController.Resume()

    if not running or not paused or gameOver then
        return
    end

    paused = false

    gravityTimer = 0

    startInput()
end

--==================================================
-- REINICIAR PARTIDA
--==================================================

function BlockPuzzleController.Reset()

    if not elements then
        return
    end

    BlockPuzzleInput.Stop()

    resetState()

    startInput()
end

--==================================================
-- DETENER Y LIMPIAR
--==================================================

function BlockPuzzleController.Stop()

    running = false
    paused = false
    gameOver = false

    BlockPuzzleInput.Stop()

    if heartbeatConnection then

        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end

        if restartInputConnection then

        restartInputConnection:Disconnect()
        restartInputConnection = nil
    end

    if elements and elements.Container then

        elements.Container:Destroy()
    end

    elements = nil

    currentPiece = nil
    holdPiece = nil

    nextPieces = {}
    pieceBag = {}
    grid = {}

    leftPressed = false
    rightPressed = false
    softDropPressed = false

    horizontalDirection = 0
    horizontalTimer = 0
    horizontalRepeating = false

    gravityTimer = 0

    gameOverCallback = nil
end

--==================================================
-- CONSULTAR ESTADO
--==================================================

function BlockPuzzleController.GetState()

    return {
        Running = running,
        Paused = paused,
        GameOver = gameOver,

        Score = score,
        Level = level,
        Lines = lines,
    }
end

return BlockPuzzleController
