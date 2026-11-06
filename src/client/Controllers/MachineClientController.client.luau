
--[[
    UNIVERSO ARCADE
    MachineClientController

    Controla:
    - Comunicación con el servidor.
    - Transición de cámara hacia la recreativa.
    - Apertura y cierre de la interfaz.
    - Ciclo de vida de los minijuegos.
    - Pausa, estadísticas y transiciones.
    - Restauración de cámara y personaje.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local MachineInterface = require(
    script.Parent.Parent
        :WaitForChild("UI")
        :WaitForChild("MachineInterface")
)

local BrickBreakerController = require(
    script.Parent.Parent
        :WaitForChild("Minigames")
        :WaitForChild("BrickBreaker")
        :WaitForChild("BrickBreakerController")
)

local remote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("MachineSessionRemote")

-- ESTADO DE SESIÓN

local activeGui = nil
local activeInterface = nil
local activeMachine = nil

local sessionActive = false
local exitRequested = false
local closingAnimationStarted = false
local brickBreakerActive = false

-- CÁMARA

local originalCameraType = nil
local originalCameraSubject = nil
local originalCameraCFrame = nil
local originalFieldOfView = nil

local cameraTween = nil

-- PERSONAJE

local activeHumanoid = nil
local originalWalkSpeed = nil
local originalJumpPower = nil
local originalJumpHeight = nil
local originalAutoRotate = nil

-- FUNCIONES ADELANTADAS

local requestExit
local endMachine

-- GUARDAR CÁMARA

local function saveCamera()

    camera = workspace.CurrentCamera

    originalCameraType = camera.CameraType
    originalCameraSubject = camera.CameraSubject
    originalCameraCFrame = camera.CFrame
    originalFieldOfView = camera.FieldOfView

end

-- CONGELAR PERSONAJE

local function freezeCharacter()

    local character = player.Character

    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    activeHumanoid = humanoid

    originalWalkSpeed = humanoid.WalkSpeed
    originalJumpPower = humanoid.JumpPower
    originalJumpHeight = humanoid.JumpHeight
    originalAutoRotate = humanoid.AutoRotate

    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.JumpHeight = 0
    humanoid.AutoRotate = false

end

-- RESTAURAR PERSONAJE

local function restoreCharacter()

    if not activeHumanoid or not activeHumanoid.Parent then
        activeHumanoid = nil
        return
    end

    activeHumanoid.WalkSpeed = originalWalkSpeed or 16
    activeHumanoid.JumpPower = originalJumpPower or 50
    activeHumanoid.JumpHeight = originalJumpHeight or 7.2
    activeHumanoid.AutoRotate = originalAutoRotate ~= false

    activeHumanoid = nil

end

-- RESTAURAR CÁMARA

local function restoreCamera()

    if cameraTween then
        cameraTween:Cancel()
        cameraTween = nil
    end

    camera = workspace.CurrentCamera

    camera.CameraType = originalCameraType or Enum.CameraType.Custom

    if originalCameraSubject and originalCameraSubject.Parent then
        camera.CameraSubject = originalCameraSubject
    end

    if originalCameraCFrame then
        camera.CFrame = originalCameraCFrame
    end

    if originalFieldOfView then
        camera.FieldOfView = originalFieldOfView
    end

end

-- DESTRUIR INTERFAZ

local function closeInterface()

    if activeGui then
        activeGui:Destroy()
        activeGui = nil
    end

    activeInterface = nil

end

-- DETENER MINIJUEGO

local function stopActiveMinigame()

    if not brickBreakerActive then
        return
    end

    pcall(function()
        BrickBreakerController.Stop()
    end)

    brickBreakerActive = false

    print("[Universo Arcade] BrickBreaker detenido.")

end

-- SOLICITAR SALIDA DE LA RECREATIVA

requestExit = function()

    if not sessionActive or exitRequested then
        return
    end

    exitRequested = true

    print("[Universo Arcade] Solicitando salida de la recreativa.")

    -- La animación se completa antes de solicitar el cierre
    -- de la sesión al servidor.

    if activeInterface and not closingAnimationStarted then

        closingAnimationStarted = true

        local success, tween = pcall(function()
            return activeInterface.AnimateClose()
        end)

        if success and tween then
            tween.Completed:Wait()
        end

    end

    -- La sesión podría haberse cerrado durante la animación.

    if not sessionActive then
        return
    end

    remote:FireServer("RequestEnd")

end

-- INICIAR MINIJUEGO

local function startActiveMinigame(minigameId)

    if minigameId ~= "BrickBreaker" then
        warn("[Universo Arcade] Minijuego todavía no implementado:", minigameId)
        requestExit()
        return
    end

    if not activeGui or not activeInterface then
        warn("[Universo Arcade] No existe la interfaz del minijuego.")
        requestExit()
        return
    end

    local gameScreen = activeInterface.GameScreen

    if not gameScreen or not gameScreen.Parent then
        warn("[Universo Arcade] No se encontró GameScreen.")
        requestExit()
        return
    end

    -- CALLBACKS DEL BRICKBREAKER

    local callbacks = {

        onStatsChanged = function(data)

            if not sessionActive or not activeInterface then
                return
            end

            activeInterface.SetStats(data)

            if data and data.BestScore ~= nil then
                activeInterface.SetBest(data.BestScore)
            end

        end,

        onLevelCompleted = function(completedLevel, nextLevel)

            if not sessionActive or not activeInterface then
                return
            end

            activeInterface.ShowLevelTransition(
                completedLevel,
                nextLevel,
                function()

                    if not sessionActive or exitRequested then
                        return
                    end

                    BrickBreakerController.ContinueLevel()

                end
            )

        end,

        onGameOver = function(data)

            if not sessionActive or not activeInterface then
                return
            end

            data = data or {}

            activeInterface.ShowGameOver(
                data,
                data.BestScore
            )

            if data.BestScore ~= nil then
                activeInterface.SetBest(data.BestScore)
            end

        end,

    }

    -- INICIAR CONTROLADOR

    local success, errorMessage = pcall(function()

        BrickBreakerController.Start(
            gameScreen,
            callbacks
        )

        BrickBreakerController.Pause()

    end)

    if not success then

        warn(
            "[Universo Arcade] Error iniciando BrickBreaker:",
            errorMessage
        )

        pcall(function()
            BrickBreakerController.Stop()
        end)

        requestExit()
        return

    end

    brickBreakerActive = true

    print("[Universo Arcade] BrickBreaker iniciado correctamente.")

end

-- CREAR INTERFAZ Y ABRIR RECREATIVA

local function startMachine(machine, minigameId)

    if sessionActive or activeMachine ~= nil then
        return
    end

    if not machine or not machine.Parent then
        return
    end

    local screen = machine:FindFirstChild("ScreenGlass")

    if not screen or not screen:IsA("BasePart") then
        warn("[Universo Arcade] No se encontró la pantalla de la recreativa.")
        remote:FireServer("RequestEnd")
        return
    end

    sessionActive = true
    exitRequested = false
    closingAnimationStarted = false

    activeMachine = machine

    -- GUARDAR ESTADO ORIGINAL

    saveCamera()
    freezeCharacter()

    -- POSICIÓN DE CÁMARA

    local cameraPosition = screen.CFrame:PointToWorldSpace(
        Vector3.new(0, 0, 5.5)
    )

    local targetCFrame = CFrame.lookAt(
        cameraPosition,
        screen.Position,
        screen.CFrame.UpVector
    )

    camera.CameraType = Enum.CameraType.Scriptable

    -- TRANSICIÓN DE CÁMARA

    cameraTween = TweenService:Create(
        camera,
        TweenInfo.new(
            0.8,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            CFrame = targetCFrame,
            FieldOfView = 55,
        }
    )

    cameraTween:Play()
    cameraTween.Completed:Wait()

    if not sessionActive then
        return
    end

    -- CREAR INTERFAZ

    local success, gui, interface = pcall(function()

        local createdGui, createdInterface = MachineInterface.Create(
            minigameId,
            player.Name,

            -- SALIR

            function()
                requestExit()
            end,

            -- INICIAR PARTIDA

            function()
                if not sessionActive or exitRequested then
                    return
                end

                if not brickBreakerActive then
                    return
                end

                task.defer(function()
                    BrickBreakerController.Resume()
                end)
            end,

            -- PAUSAR

            function()

                if brickBreakerActive then
                    BrickBreakerController.Pause()
                end

            end,

            -- REANUDAR

            function()

                if brickBreakerActive then
                    BrickBreakerController.Resume()
                end

            end
        )

        return createdGui, createdInterface

    end)

    if not success then

        warn("[Universo Arcade] Error creando interfaz:", gui)

        requestExit()
        return

    end

    activeGui = gui
    activeInterface = interface

    print("[Universo Arcade] Interfaz creada:", minigameId)

    -- INICIAR MINIJUEGO

    startActiveMinigame(minigameId)

    if not sessionActive or exitRequested then
        return
    end

    -- ANIMACIÓN DE ENTRADA

    local openSuccess, openError = pcall(function()
        activeInterface.AnimateOpen()
    end)

    if not openSuccess then
        warn("[Universo Arcade] Error en animación de entrada:", openError)
    end

end

-- CERRAR RECREATIVA

endMachine = function(reason)

    if not sessionActive then
        return
    end

    sessionActive = false
    exitRequested = false

    print("[Universo Arcade] Cerrando recreativa:", reason)

    stopActiveMinigame()
    closeInterface()

    restoreCharacter()
    restoreCamera()

    activeMachine = nil
    closingAnimationStarted = false

end

-- EVENTOS DEL SERVIDOR

remote.OnClientEvent:Connect(function(
    action,
    firstArgument,
    secondArgument
)

    if action == "Started" then

        local machine = firstArgument
        local minigameId = secondArgument

        startMachine(machine, minigameId)

    elseif action == "Ended" then

        local reason = firstArgument

        endMachine(reason)

    end

end)

-- LIMPIEZA AL DESAPARECER EL PERSONAJE

player.CharacterRemoving:Connect(function()

    if not sessionActive then
        return
    end

    sessionActive = false
    exitRequested = false

    stopActiveMinigame()
    closeInterface()

    restoreCamera()

    activeMachine = nil
    closingAnimationStarted = false

end)

print("[Universo Arcade] MachineClientController preparado.")
