
--[[
    UNIVERSO ARCADE
    BubbleShooterController

    Controlador principal de BubbleShooter.

    Primera fase:
    - Crear y mostrar el tablero.
    - Gestionar inicio, pausa y salida.
    - Preparar la comunicación con MachineInterface.

    Los disparos y las colisiones se añadirán
    después de comprobar la interfaz visual.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local BubbleShooterInput = require(
    script.Parent:WaitForChild("BubbleShooterInput")
)

local Config = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("BubbleShooterConfig")
)


local BubbleShooterBoard = require(
    script.Parent:WaitForChild("BubbleShooterBoard")
)

local BubbleShooterController = {}

--==================================================
-- ESTADO DE LA PARTIDA
--==================================================

local elements = nil
local callbacks = nil

local running = false
local paused = false

local score = 0
local level = 1


--==================================================
-- CONTROL DEL LANZADOR
--==================================================

local aimAngle = 0
local aimConnection = nil

--==================================================
-- ESTADO DEL DISPARO
--==================================================

local activeProjectile = nil
local projectilePosition = nil
local projectileDirection = nil

--==================================================
-- ACTUALIZAR ESTADÍSTICAS
--==================================================

local function updateHUD()

    if elements then

        elements.ScoreLabel.Text =
            "SCORE\n" .. tostring(score)

        elements.LevelLabel.Text =
            "LEVEL\n" .. tostring(level)

    end

    if callbacks and callbacks.onStatsChanged then

        callbacks.onStatsChanged({

            Score = score,
            Level = level,

        })

    end

end


--==================================================
-- FINALIZAR DISPARO
--==================================================

local function finishShot()

    if activeProjectile then

        activeProjectile:Destroy()
        activeProjectile = nil

    end

    projectilePosition = nil
    projectileDirection = nil

    -- PREPARAR LA SIGUIENTE BURBUJA.

    if elements and elements.LoadedBubble then

        elements.LoadedBubble.Visible = true

    end

end

--==================================================
-- DISPARAR BURBUJA
--==================================================

local function shootBubble()

    if not running or paused or not elements then
        return
    end

    -- SOLO PERMITIR UN PROYECTIL ACTIVO.

    if activeProjectile then
        return
    end

    local playfield = elements.Playfield
    local loadedBubble = elements.LoadedBubble

    local boardSize = playfield.AbsoluteSize

    if boardSize.X <= 0 or boardSize.Y <= 0 then
        return
    end

    -- CENTRO INICIAL EN PÍXELES.

    local startX =
        boardSize.X * loadedBubble.Position.X.Scale

    local startY =
        boardSize.Y * loadedBubble.Position.Y.Scale

    -- CONVERTIR ÁNGULO A DIRECCIÓN.

    local angleRadians = math.rad(aimAngle)

    projectileDirection = Vector2.new(
        math.sin(angleRadians),
        -math.cos(angleRadians)
    )

    projectilePosition = Vector2.new(
        startX,
        startY
    )

    -- CREAR BURBUJA EN MOVIMIENTO.

    local projectile = loadedBubble:Clone()

    projectile.Name = "ActiveProjectile"

    projectile.Position = UDim2.fromOffset(
        startX,
        startY
    )

    projectile.ZIndex = 6
    projectile.Visible = true

    projectile.Parent = playfield

    activeProjectile = projectile

    -- OCULTAR TEMPORALMENTE LA BURBUJA CARGADA.

    loadedBubble.Visible = false

end

--==================================================
-- ACTUALIZAR MOVIMIENTO DEL PROYECTIL
--==================================================

local function updateProjectile(deltaTime)

    if not running
        or paused
        or not elements
        or not activeProjectile
        or not projectilePosition
        or not projectileDirection then

        return
    end

    local playfield = elements.Playfield

    local boardSize = playfield.AbsoluteSize

    if boardSize.X <= 0 or boardSize.Y <= 0 then
        return
    end

    local radius =
        activeProjectile.AbsoluteSize.X / 2

    if radius <= 0 then
        return
    end

    local speed = Config.Launcher.ProjectileSpeed

    -- AVANZAR SEGÚN LA VELOCIDAD Y EL TIEMPO.

    local newPosition =
        projectilePosition
        + projectileDirection * speed * deltaTime

    --==================================================
    -- REBOTES EN PAREDES LATERALES
    --==================================================

    local minX = radius
    local maxX = boardSize.X - radius

    if newPosition.X < minX then

        newPosition = Vector2.new(
            minX + (minX - newPosition.X),
            newPosition.Y
        )

        projectileDirection = Vector2.new(
            -projectileDirection.X,
            projectileDirection.Y
        )

    elseif newPosition.X > maxX then

        newPosition = Vector2.new(
            maxX - (newPosition.X - maxX),
            newPosition.Y
        )

        projectileDirection = Vector2.new(
            -projectileDirection.X,
            projectileDirection.Y
        )

    end

    -- MANTENER LA BURBUJA DENTRO DEL TABLERO.

    newPosition = Vector2.new(
        math.clamp(newPosition.X, minX, maxX),
        newPosition.Y
    )

    projectilePosition = newPosition

    activeProjectile.Position = UDim2.fromOffset(
        newPosition.X,
        newPosition.Y
    )

    --==================================================
    -- COLISIÓN CON EL TECHO
    --==================================================

    if newPosition.Y <= radius then

        finishShot()
        return

    end

    --==================================================
    -- COLISIÓN CON BURBUJAS INICIALES
    --==================================================

    local projectileRadius = radius

    for _, row in pairs(elements.Bubbles) do

        for _, bubble in pairs(row) do

            if bubble and bubble.Parent then

                local bubbleCenter =
                    bubble.AbsolutePosition
                    + bubble.AbsoluteSize / 2
                    - playfield.AbsolutePosition

                local bubbleRadius =
                    bubble.AbsoluteSize.X / 2

                local distance =
                    (newPosition - bubbleCenter).Magnitude

                if distance <=
                    projectileRadius + bubbleRadius then

                    finishShot()
                    return

                end

            end

        end

    end

end


--==================================================
-- ACTUALIZAR APUNTADO
--==================================================

local function updateAim(deltaTime)

    if not running
        or paused
        or not elements then

        return
    end

    local direction =
        BubbleShooterInput.GetAimDirection()

    if direction == 0 then
        return
    end

    -- MODIFICAR EL ÁNGULO SEGÚN EL TIEMPO
    -- TRANSCURRIDO ENTRE FOTOGRAMAS.

    aimAngle +=
        direction
        * Config.Launcher.AimSpeed
        * deltaTime

    -- LIMITAR EL APUNTADO PARA EVITAR
    -- DISPARAR HACIA ABAJO.

    aimAngle = math.clamp(
        aimAngle,
        -Config.Launcher.MaxAngle,
        Config.Launcher.MaxAngle
    )

    -- GIRAR VISUALMENTE EL LANZADOR.

    elements.Launcher.Rotation = aimAngle

end


--==================================================
-- INICIAR MINIJUEGO
--==================================================

function BubbleShooterController.Start(parent, gameCallbacks)

    BubbleShooterController.Stop()

    callbacks = gameCallbacks

    score = 0
    level = 1

    running = true
    paused = false

    -- CONSTRUIR TABLERO.

    
    elements = BubbleShooterBoard.Create(parent)

    -- REINICIAR ÁNGULO.

    aimAngle = 0
    elements.Launcher.Rotation = aimAngle

    -- ACTIVAR CONTROLES.

    BubbleShooterInput.Start(function()

        shootBubble()

    end)

    -- ACTUALIZAR EL APUNTADO CADA FOTOGRAMA.

    aimConnection = RunService.Heartbeat:Connect(
        function(deltaTime)

            updateAim(deltaTime)

            updateProjectile(deltaTime)

        end
    )

    updateHUD()


end

--==================================================
-- PAUSAR MINIJUEGO
--==================================================

function BubbleShooterController.Pause()

    if not running then
        return
    end

    paused = true

end

--==================================================
-- REANUDAR MINIJUEGO
--==================================================

function BubbleShooterController.Resume()

    if not running then
        return
    end

    paused = false

end

--==================================================
-- REINICIAR PARTIDA
--==================================================

function BubbleShooterController.Reset()

    finishShot()

    score = 0
    level = 1

    running = true
    paused = false

    updateHUD()

end

--==================================================
-- DETENER MINIJUEGO
--==================================================

function BubbleShooterController.Stop()

    finishShot()

    running = false
    paused = false

    -- DESACTIVAR CONTROLES.

    BubbleShooterInput.Stop()

    -- DETENER ACTUALIZACIÓN DEL APUNTADO.

    if aimConnection then
        aimConnection:Disconnect()
        aimConnection = nil
    end

    aimAngle = 0

    if elements then

        if elements.Container then
            elements.Container:Destroy()
        end

        elements = nil

    end

    callbacks = nil

end

--==================================================
-- CONSULTAR ESTADO
--==================================================

function BubbleShooterController.GetState()

    return {

        Running = running,
        Paused = paused,
        Score = score,
        Level = level,

    }

end

return BubbleShooterController
