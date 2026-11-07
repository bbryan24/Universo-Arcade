
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
local TweenService = game:GetService("TweenService")
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

-- MOMENTO EN EL QUE TERMINÓ LA PARTIDA.

local gameOverTime = 0

-- TIEMPO MÍNIMO ANTES DE PERMITIR REINICIAR.

local GAME_OVER_RESTART_DELAY = 1.5

local gameOverCallback = nil

local grid = {}

local currentPiece = nil
local holdPiece = nil

local holdUsed = false

local nextPieces = {}
local pieceBag = {}

local score = 0
local level = 1

-- NIVEL FORZADO PARA PRUEBAS.
-- NIL SIGNIFICA PROGRESIÓN NORMAL.

local devLevelOverride = nil

local lines = 0

local gravityTimer = 0

--==================================================
-- ANIMACIÓN DE ELIMINACIÓN DE LÍNEAS
--==================================================

local lineClearing = false
local lineClearGeneration = 0

--==================================================
-- ANIMACIÓN DE SUBIDA DE NIVEL
--==================================================

local levelUpGeneration = 0
local levelUpBanner = nil

--==================================================
-- ANIMACIÓN ESPECIAL TETRIS
--==================================================

local tetrisGeneration = 0
local tetrisBanner = nil

--==================================================
-- LOCK DELAY
--==================================================

local lockTimer = 0
local lockResetCount = 0

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


--==================================================
-- DIBUJAR PREVISUALIZACIÓN DE TETROMINÓS
--==================================================


--==================================================
-- DIBUJAR PREVISUALIZACIÓN DE TETROMINÓS
--==================================================

local function drawPreview(preview, pieceName)

    if not preview then
        return
    end

    clearPreview(preview)

    local previousGrid =
        preview:FindFirstChild("TetrominoPreviewGrid")

    if previousGrid then
        previousGrid:Destroy()
    end

    if not pieceName then
        return
    end

    local definition = Config.Pieces[pieceName]
    local shape = definition.Shape

    -- DETERMINAR LOS LÍMITES REALES DE LA PIEZA.

    local minRow = 5
    local maxRow = 0
    local minColumn = 5
    local maxColumn = 0

    for row = 1, 4 do
        for column = 1, 4 do

            if string.sub(shape[row], column, column) == "X" then

                minRow = math.min(minRow, row)
                maxRow = math.max(maxRow, row)

                minColumn = math.min(minColumn, column)
                maxColumn = math.max(maxColumn, column)

            end
        end
    end

    if maxRow == 0 then
        return
    end

    local pieceRows = maxRow - minRow + 1
    local pieceColumns = maxColumn - minColumn + 1

    -- CALCULAR UNA CASILLA CUADRADA.
    -- ADAPTAMOS EL TAMAÑO AL ESPACIO DISPONIBLE.

    local availableWidth = preview.AbsoluteSize.X * 0.88
    local availableHeight = preview.AbsoluteSize.Y * 0.88

    
    -- TAMAÑO MÁXIMO DE CADA BLOQUE.
    -- EVITA QUE LAS PIEZAS ESTIRADAS,
    -- COMO LA I, APAREZCAN GIGANTES.

    local MAX_PREVIEW_CELL_SIZE = 18

    local cellSize = math.min(
        availableWidth / pieceColumns,
        availableHeight / pieceRows,
        MAX_PREVIEW_CELL_SIZE
    )


    -- CONTENEDOR CENTRADO CON EL TAMAÑO REAL.

    local previewGrid = Instance.new("Frame")

    previewGrid.Name = "TetrominoPreviewGrid"

    previewGrid.AnchorPoint = Vector2.new(0.5, 0.5)
    previewGrid.Position = UDim2.fromScale(0.5, 0.5)

    previewGrid.Size = UDim2.fromOffset(
        pieceColumns * cellSize,
        pieceRows * cellSize
    )

    previewGrid.BackgroundTransparency = 1
    previewGrid.BorderSizePixel = 0

    previewGrid.Parent = preview

    -- DIBUJAR LAS CASILLAS.

    for row = minRow, maxRow do
        for column = minColumn, maxColumn do

            if string.sub(shape[row], column, column) == "X" then

                local cell = Instance.new("Frame")

                cell.Name = "PreviewCell"

                cell.Position = UDim2.fromOffset(
                    (column - minColumn) * cellSize,
                    (row - minRow) * cellSize
                )

                cell.Size = UDim2.fromOffset(
                    math.max(1, cellSize - 1),
                    math.max(1, cellSize - 1)
                )

                cell.BackgroundColor3 = definition.Color
                cell.BorderSizePixel = 0

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 2)
                corner.Parent = cell

                cell.Parent = previewGrid
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
-- ANIMACIÓN LEVEL UP
--==================================================

local function animateLevelUp()

    if not elements or not elements.LevelLabel then
        return
    end

    levelUpGeneration += 1

    local generation = levelUpGeneration
    local levelLabel = elements.LevelLabel

    -- ELIMINAR UN AVISO ANTERIOR.

    if levelUpBanner then
        levelUpBanner:Destroy()
        levelUpBanner = nil
    end

    -- RESTABLECER EL MARCADOR ANTES DE ANIMAR.

    levelLabel.TextSize = 17
    levelLabel.TextColor3 = Color3.fromRGB(
        235, 240, 255
    )

    -- CREAR MENSAJE EN EL PANEL IZQUIERDO.

    local banner = Instance.new("TextLabel")

    banner.Name = "LevelUpBanner"

    banner.Position = UDim2.fromScale(0.05, 0.56)
    banner.Size = UDim2.fromScale(0.9, 0.09)

    banner.BackgroundTransparency = 1

    banner.Text = "LEVEL UP!"
    banner.TextColor3 = Color3.fromRGB(
        110, 215, 255
    )

    banner.TextTransparency = 1
    banner.TextSize = 14

    banner.Font = Enum.Font.Arcade
    banner.TextScaled = false

    banner.ZIndex = 10

    banner.Parent = levelLabel.Parent

    levelUpBanner = banner

    -- ENTRADA SUAVE DEL MENSAJE.

    TweenService:Create(
        banner,
        TweenInfo.new(
            0.18,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            TextTransparency = 0,
        }
    ):Play()

    -- DESTACAR EL NÚMERO DEL NIVEL.

    TweenService:Create(
        levelLabel,
        TweenInfo.new(
            0.22,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            TextSize = 24,
            TextColor3 = Color3.fromRGB(
                110, 215, 255
            ),
        }
    ):Play()

    -- MANTENER EL AVISO BREVEMENTE.

    task.delay(0.85, function()

        if generation ~= levelUpGeneration then
            return
        end

        if not elements or not levelLabel.Parent then
            return
        end

        -- DESAPARECER MENSAJE.

        TweenService:Create(
            banner,
            TweenInfo.new(0.35),
            {
                TextTransparency = 1,
            }
        ):Play()

        -- RESTAURAR EL TAMAÑO DEL NIVEL.

        TweenService:Create(
            levelLabel,
            TweenInfo.new(0.35),
            {
                TextSize = 17,
                TextColor3 = Color3.fromRGB(
                    235, 240, 255
                ),
            }
        ):Play()

        task.delay(0.35, function()

            if generation ~= levelUpGeneration then
                return
            end

            if levelUpBanner == banner then
                levelUpBanner = nil
            end

            banner:Destroy()

        end)

    end)

end


--==================================================
-- ANIMACIÓN ESPECIAL: TETRIS!
--==================================================

local function animateTetris()

    if not elements or not elements.Container then
        return
    end

    tetrisGeneration += 1

    local generation = tetrisGeneration

    -- ELIMINAR MENSAJE ANTERIOR.

    if tetrisBanner then
        tetrisBanner:Destroy()
        tetrisBanner = nil
    end

    -- CONTENEDOR DEL MENSAJE.

    local banner = Instance.new("TextLabel")

    banner.Name = "TetrisBanner"

    banner.AnchorPoint = Vector2.new(0.5, 0.5)

    -- CENTRADO SOBRE LA PARTE SUPERIOR
    -- DEL TABLERO CENTRAL.

    banner.Position = UDim2.fromScale(0.5, 0.18)

    banner.Size = UDim2.fromScale(0.38, 0.12)

    banner.BackgroundColor3 =
        Color3.fromRGB(8, 18, 35)

    banner.BackgroundTransparency = 1

    banner.BorderSizePixel = 0

    banner.Text = "TETRIS!"

    banner.TextColor3 =
        Color3.fromRGB(135, 225, 255)

    banner.TextTransparency = 1

    banner.TextSize = 28
    banner.TextScaled = true

    banner.Font = Enum.Font.Arcade

    banner.ZIndex = 30

    banner.Parent = elements.Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = banner

    local stroke = Instance.new("UIStroke")

    stroke.Color = Color3.fromRGB(
        90, 195, 255
    )

    stroke.Thickness = 2
    stroke.Transparency = 1
    stroke.Parent = banner

    local textLimit = Instance.new("UITextSizeConstraint")
    textLimit.MaxTextSize = 28
    textLimit.MinTextSize = 12
    textLimit.Parent = banner

    tetrisBanner = banner

    --==================================================
    -- APARICIÓN
    --==================================================

    TweenService:Create(
        banner,
        TweenInfo.new(
            0.22,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            TextTransparency = 0,

            BackgroundTransparency = 0.15,

            Size = UDim2.fromScale(0.44, 0.14),
        }
    ):Play()

    TweenService:Create(
        stroke,
        TweenInfo.new(0.22),
        {
            Transparency = 0.15,
        }
    ):Play()

    --==================================================
    -- DESAPARICIÓN
    --==================================================

    task.delay(0.95, function()

        if generation ~= tetrisGeneration then
            return
        end

        if not banner.Parent then
            return
        end

        TweenService:Create(
            banner,
            TweenInfo.new(
                0.4,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                TextTransparency = 1,

                BackgroundTransparency = 1,

                Size = UDim2.fromScale(0.40, 0.12),
            }
        ):Play()

        TweenService:Create(
            stroke,
            TweenInfo.new(0.4),
            {
                Transparency = 1,
            }
        ):Play()

        task.delay(0.4, function()

            if generation ~= tetrisGeneration then
                return
            end

            if tetrisBanner == banner then
                tetrisBanner = nil
            end

            banner:Destroy()

        end)

    end)

end


--==================================================
-- DIBUJAR TABLERO Y GHOST PIECE
--==================================================

local function renderBoard()

    if not elements then
        return
    end

    --==================================================
    -- 1. DIBUJAR CUADRÍCULA Y PIEZAS FIJADAS
    --==================================================

    for row = 1, ROWS do

        for column = 1, COLUMNS do

            local index = (row - 1) * COLUMNS + column

            local cell = elements.Cells[index]

            if cell then

                cell.BackgroundColor3 =
                    grid[row][column] or EMPTY_COLOR

                -- RESTABLECER OPACIDAD.
                -- IMPORTANTE PARA ELIMINAR
                -- SOMBRAS DE FOTOGRAMAS ANTERIORES.

                cell.BackgroundTransparency = 0

            end
        end
    end

    if not currentPiece then
        return
    end

    --==================================================
    -- 2. CALCULAR POSICIÓN DE ATERRIZAJE
    --==================================================

    local ghostRow = currentPiece.Row

    -- DESCENDER VIRTUALMENTE HASTA ENCONTRAR
    -- LA PRIMERA COLISIÓN.

    while canPlace(
        currentPiece.Shape,
        ghostRow + 1,
        currentPiece.Column
    ) do

        ghostRow += 1

    end

    --==================================================
    -- 3. DIBUJAR GHOST PIECE
    --==================================================

    -- SI LA PIEZA YA ESTÁ EN EL SUELO,
    -- NO NECESITAMOS DIBUJAR UNA SOMBRA.

    if ghostRow ~= currentPiece.Row then

        for shapeRow = 1, 4 do

            for shapeColumn = 1, 4 do

                local symbol = string.sub(
                    currentPiece.Shape[shapeRow],
                    shapeColumn,
                    shapeColumn
                )

                if symbol == "X" then

                    local row =
                        ghostRow + shapeRow - 1

                    local column =
                        currentPiece.Column + shapeColumn - 1

                    if row >= 1
                        and row <= ROWS
                        and column >= 1
                        and column <= COLUMNS then

                        local index =
                            (row - 1) * COLUMNS + column

                        local cell = elements.Cells[index]

                        if cell then

                            cell.BackgroundColor3 =
                                currentPiece.Color

                            -- SOMBRA SEMITRANSPARENTE.

                            cell.BackgroundTransparency = 0.72

                        end
                    end
                end
            end
        end
    end

    --==================================================
    -- 4. DIBUJAR PIEZA ACTUAL
    --==================================================

    for shapeRow = 1, 4 do

        for shapeColumn = 1, 4 do

            local symbol = string.sub(
                currentPiece.Shape[shapeRow],
                shapeColumn,
                shapeColumn
            )

            if symbol == "X" then

                local row =
                    currentPiece.Row + shapeRow - 1

                local column =
                    currentPiece.Column + shapeColumn - 1

                if row >= 1
                    and row <= ROWS
                    and column >= 1
                    and column <= COLUMNS then

                    local index =
                        (row - 1) * COLUMNS + column

                    local cell = elements.Cells[index]

                    if cell then

                        cell.BackgroundColor3 =
                            currentPiece.Color

                        -- LA PIEZA REAL ES TOTALMENTE OPACA.

                        cell.BackgroundTransparency = 0

                    end
                end
            end
        end
    end

end

--==================================================
-- VELOCIDAD DE GRAVEDAD POR NIVEL
--==================================================

local function getDropInterval()

    local intervals = Config.Game.DropIntervals

    -- LIMITAR EL ÍNDICE A LOS NIVELES CONFIGURADOS.

    local speedLevel = math.clamp(
        level,
        1,
        #intervals
    )

    local interval = intervals[speedLevel]

    -- CAÍDA RÁPIDA.

    if softDropPressed then

        interval =
            interval / Config.Game.SoftDropMultiplier

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

    -- REGISTRAR EL MOMENTO DEL GAME OVER.

    gameOverTime = os.clock()
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
    
    lockTimer = 0
    lockResetCount = 0

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

            requiredLines =
                Config.Game.InitialLinesPerLevel
                + math.floor(
                    (calculatedLevel - Config.Game.InitialLevel)
                    / Config.Game.LevelsPerLineIncrease
                ) * Config.Game.AdditionalLinesPerLevel

    end


    -- COMPROBAR SI SE HA SUBIDO DE NIVEL.

    local previousLevel = level

    -- RESPETAR EL NIVEL DEV SI ESTÁ ACTIVO.

    level = devLevelOverride or calculatedLevel

    updateHUD()

    -- MOSTRAR ANIMACIÓN SOLO EN SUBIDAS
    -- NATURALES, NO CON BOTONES DEV.

    if level > previousLevel
        and devLevelOverride == nil then

        animateLevelUp()

    end

    
    --==================================================
    -- CELEBRACIÓN ESPECIAL: CUATRO LÍNEAS
    --==================================================

    if cleared == 4 then

        animateTetris()

    end


end

--==================================================
-- FIJAR PIEZA AL TABLERO
--==================================================


--==================================================
-- FIJAR PIEZA AL TABLERO
--==================================================

local function lockPiece()

    if not currentPiece or lineClearing then
        return
    end

    local lockedAboveBoard = false

    -- FIJAR LOS BLOQUES DE LA PIEZA.

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

    -- BUSCAR FILAS COMPLETAS SIN ELIMINARLAS.

    local completedRows = {}

    for row = 1, ROWS do

        local complete = true

        for column = 1, COLUMNS do

            if grid[row][column] == nil then
                complete = false
                break
            end
        end

        if complete then
            table.insert(completedRows, row)
        end
    end

    -- ACTUALIZAR EL TABLERO CON LA PIEZA FIJADA.

    renderBoard()

    -- CONTINUAR NORMALMENTE SI NO HAY LÍNEAS.

    if #completedRows == 0 then

        if lockedAboveBoard then

            finishGame()
            return
        end

        holdUsed = false
        gravityTimer = 0
        lockTimer = 0

        spawnNextPiece()

        return
    end

    --==================================================
    -- ANIMACIÓN DE LÍNEAS COMPLETADAS
    --==================================================

    lineClearing = true

    local animationGeneration = lineClearGeneration
    local animationElements = elements

    -- EVITAR QUE UNA ANIMACIÓN ANTIGUA
    -- MODIFIQUE UNA PARTIDA NUEVA.

    local function animationIsValid()

        return lineClearing
            and lineClearGeneration == animationGeneration
            and elements == animationElements
            and running
            and not gameOver

    end

    task.spawn(function()

        local flashColor = Color3.fromRGB(
            185, 230, 255
        )

        -- DOS DESTELLOS SUAVES.

        for _ = 1, 2 do

            if not animationIsValid() then
                return
            end

            -- ILUMINAR LAS FILAS COMPLETAS.

            for _, row in ipairs(completedRows) do

                for column = 1, COLUMNS do

                    local index =
                        (row - 1) * COLUMNS + column

                    local cell = elements.Cells[index]

                    if cell then

                        cell.BackgroundColor3 = flashColor
                        cell.BackgroundTransparency = 0

                    end
                end
            end

            task.wait(0.10)

            if not animationIsValid() then
                return
            end

            -- RECUPERAR SUS COLORES.

            renderBoard()

            task.wait(0.09)

        end

        if not animationIsValid() then
            return
        end

        -- ELIMINAR LAS FILAS DESPUÉS DEL DESTELLO.
        -- ESTA FUNCIÓN TAMBIÉN ACTUALIZA
        -- LA PUNTUACIÓN Y LOS NIVELES.

        clearCompletedLines()

        renderBoard()
        updateHUD()

        lineClearing = false

        if lockedAboveBoard then

            finishGame()
            return
        end

        -- PREPARAR LA SIGUIENTE PIEZA.

        holdUsed = false

        gravityTimer = 0
        lockTimer = 0

        spawnNextPiece()

    end)

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

    
    -- COMPROBAR SI LA PIEZA ESTABA APOYADA
    -- ANTES DE MOVERSE.

    local wasGrounded = not canPlace(
        currentPiece.Shape,
        currentPiece.Row + 1,
        currentPiece.Column
    )

    currentPiece.Row = newRow
    currentPiece.Column = newColumn

    -- REINICIAR EL TIEMPO DE CORTESÍA
    -- SI EL MOVIMIENTO ES LATERAL Y ESTABA APOYADA.

    if deltaRow == 0
        and deltaColumn ~= 0
        and wasGrounded
        and lockResetCount < Config.Game.MaxLockResets then

        lockTimer = 0
        lockResetCount += 1

    end

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

            
            local wasGrounded = not canPlace(
                currentPiece.Shape,
                currentPiece.Row + 1,
                currentPiece.Column
            )

            currentPiece.Shape = rotated
            currentPiece.Row = newRow
            currentPiece.Column = newColumn

            -- REINICIAR LOCK DELAY AL GIRAR
            -- MIENTRAS ESTÁ APOYADA.

            if wasGrounded
                and lockResetCount < Config.Game.MaxLockResets then

                lockTimer = 0
                lockResetCount += 1

            end

            renderBoard()


            return
        end
    end
end

--==================================================
-- CAÍDA DE UNA CASILLA
--==================================================


local function dropOneRow()

    -- SI PUEDE DESCENDER, DESCIENDE.
    -- SI ESTÁ APOYADA, NO SE FIJA INMEDIATAMENTE.
    -- EL LOCK DELAY GESTIONARÁ SU FIJACIÓN.

    return movePiece(1, 0)

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

    if not running
        or paused
        or gameOver
        or lineClearing then

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

    
    --==================================================
    -- CONTROL DE LOCK DELAY
    --==================================================

    if currentPiece then

        local isGrounded = not canPlace(
            currentPiece.Shape,
            currentPiece.Row + 1,
            currentPiece.Column
        )

        if isGrounded then

            -- LA PIEZA ESTÁ APOYADA.
            -- COMENZAR O CONTINUAR EL TEMPORIZADOR.

            lockTimer += deltaTime

            if lockTimer >= Config.Game.LockDelay then

                lockPiece()

            end

        else

            -- SI VUELVE A ESTAR EN EL AIRE,
            -- REINICIAMOS EL TIEMPO, PERO NO
            -- EL CONTADOR DE MOVIMIENTOS.

            lockTimer = 0

        end

    end

end

--==================================================
-- RESTABLECER ESTADO DE PARTIDA
--==================================================

local function resetState()

    tetrisGeneration += 1

    if tetrisBanner then
        tetrisBanner:Destroy()
        tetrisBanner = nil
    end

    levelUpGeneration += 1

    if levelUpBanner then
        levelUpBanner:Destroy()
        levelUpBanner = nil
    end

    if elements and elements.LevelLabel then
        elements.LevelLabel.TextSize = 17
        elements.LevelLabel.TextColor3 =
            Color3.fromRGB(235, 240, 255)
    end

    -- CANCELAR ANIMACIONES DE LA PARTIDA ANTERIOR.

    lineClearGeneration += 1
    lineClearing = false

    createEmptyGrid()

    currentPiece = nil
    holdPiece = nil

    holdUsed = false

    nextPieces = {}
    pieceBag = {}

    score = 0
    level = Config.Game.InitialLevel
    lines = 0

    -- RESTABLECER PROGRESIÓN NORMAL.

    devLevelOverride = nil

    if elements and elements.DevLevelLabel then
        elements.DevLevelLabel.Text = "DEV  LVL 1"
    end

    gravityTimer = 0
    lockTimer = 0
    lockResetCount = 0

    leftPressed = false
    rightPressed = false
    softDropPressed = false

    horizontalDirection = 0
    horizontalTimer = 0
    horizontalRepeating = false

    running = true
    paused = false
    gameOver = false
    gameOverTime = 0

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

    --==================================================
    -- HERRAMIENTAS DEV
    --==================================================

    local devEnabled =
        RunService:IsStudio()
        and Config.Dev.Enabled
        and Config.Dev.ShowLevelControls

    if elements.DevPanel then

        elements.DevPanel.Visible = devEnabled

    end

    if devEnabled then

        -- CAMBIAR NIVEL DE PRUEBAS.

        local function changeDevLevel(amount)

            -- PROTECCIÓN: SOLO ROBLOX STUDIO.

            if not RunService:IsStudio() then
                return
            end

            if not Config.Dev.Enabled
                or not Config.Dev.ShowLevelControls then
                return
            end

            if not running or gameOver then
                return
            end

            -- CALCULAR NUEVO NIVEL.

            local newLevel = math.clamp(
                level + amount,
                Config.Dev.MinimumLevel,
                Config.Dev.MaximumLevel
            )

            level = newLevel
            devLevelOverride = newLevel

            -- REINICIAR TEMPORIZADOR DE GRAVEDAD
            -- PARA APLICAR LA NUEVA VELOCIDAD.

            gravityTimer = 0

            -- ACTUALIZAR INDICADOR DEV.

            if elements.DevLevelLabel then

                elements.DevLevelLabel.Text =
                    "DEV  LVL " .. tostring(level)

            end

            -- ACTUALIZAR ESTADÍSTICAS.

            updateHUD()

            print(
                "[BlockPuzzle DEV] Nivel seleccionado:",
                level,
                "| Intervalo de caída:",
                getDropInterval()
            )

        end

        -- BOTÓN BAJAR NIVEL.

        if elements.DevMinusButton then

            elements.DevMinusButton.Activated:Connect(
                function()

                    changeDevLevel(-1)

                end
            )

        end

        -- BOTÓN SUBIR NIVEL.

        if elements.DevPlusButton then

            elements.DevPlusButton.Activated:Connect(
                function()

                    changeDevLevel(1)

                end
            )

        end

    end

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

            -- IMPEDIR REINICIOS INMEDIATOS.

            if os.clock() - gameOverTime < GAME_OVER_RESTART_DELAY then
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

    tetrisGeneration += 1

    if tetrisBanner then
        tetrisBanner:Destroy()
        tetrisBanner = nil
    end

    levelUpGeneration += 1

    if levelUpBanner then
        levelUpBanner:Destroy()
        levelUpBanner = nil
    end

    -- CANCELAR ANIMACIONES PENDIENTES AL SALIR.

    lineClearGeneration += 1
    lineClearing = false

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
    lockTimer = 0
    lockResetCount = 0

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
