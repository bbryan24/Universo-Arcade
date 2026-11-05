--[[
    UNIVERSO ARCADE
    MachineClientController

    Controla:
    - Comunicación con el servidor.
    - Transición de cámara hacia la recreativa.
    - Apertura de la interfaz.
    - Salida y restauración de la cámara.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local MachineInterface = require(
    script.Parent.Parent:WaitForChild("UI"):WaitForChild("MachineInterface")
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

local activeGui = nil
local activeMachine = nil
local sessionActive = false
local exitRequested = false
local brickBreakerActive = false

local originalCameraType = nil
local originalCameraSubject = nil
local originalCameraCFrame = nil
local originalFieldOfView = nil

local activeHumanoid = nil
local originalWalkSpeed = nil
local originalJumpPower = nil
local originalJumpHeight = nil
local originalAutoRotate = nil

local cameraTween = nil

local function saveCamera()

    camera = workspace.CurrentCamera

    originalCameraType = camera.CameraType
    originalCameraSubject = camera.CameraSubject
    originalCameraCFrame = camera.CFrame
    originalFieldOfView = camera.FieldOfView

end

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

local function closeInterface()

    if activeGui then
        activeGui:Destroy()
        activeGui = nil
    end

end

-- INICIAR EL MINIJUEGO CORRESPONDIENTE

local function startActiveMinigame(minigameId)

    if minigameId ~= "BrickBreaker" then
        return
    end

    if not activeGui then
        warn("[Universo Arcade] No existe la interfaz del minijuego.")
        return
    end

    local arcadeBackground = activeGui:FindFirstChild("ArcadeBackground", true)
    local cabinetFrame = arcadeBackground
        and arcadeBackground:FindFirstChild("CabinetFrame", true)

    local gameScreen = cabinetFrame
        and cabinetFrame:FindFirstChild("GameScreen", true)

    if not gameScreen then
        warn("[Universo Arcade] No se encontró GameScreen.")
        remote:FireServer("RequestEnd")
        return
    end

    -- Ocultar los textos provisionales de la interfaz.

    for _, child in ipairs(gameScreen:GetChildren()) do

        if child:IsA("TextLabel") then
            child.Visible = false
        end

    end

    -- Iniciar BrickBreaker.

    local success, errorMessage = pcall(function()
        BrickBreakerController.Start(gameScreen)
    end)

    if not success then

        warn("[Universo Arcade] Error iniciando BrickBreaker:", errorMessage)

        pcall(function()
            BrickBreakerController.Stop()
        end)

        remote:FireServer("RequestEnd")
        return
    end

    brickBreakerActive = true

    print("[Universo Arcade] BrickBreaker iniciado correctamente.")

end

-- DETENER EL MINIJUEGO ACTIVO

local function stopActiveMinigame()

    if not brickBreakerActive then
        return
    end

    BrickBreakerController.Stop()

    brickBreakerActive = false

    print("[Universo Arcade] BrickBreaker detenido.")

end

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
    activeMachine = machine

    -- Guardar el estado original.
    saveCamera()
    freezeCharacter()

    -- Colocar la cámara delante de la pantalla.
    local cameraPosition = screen.CFrame:PointToWorldSpace(
        Vector3.new(0, 0, 5.5)
    )

    local targetCFrame = CFrame.lookAt(
        cameraPosition,
        screen.Position,
        screen.CFrame.UpVector
    )

    -- Activar cámara controlada por el cliente.
    camera.CameraType = Enum.CameraType.Scriptable

    -- Transición suave.
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

    -- Comprobar que la sesión sigue activa.
    if not sessionActive then
        return
    end

    -- Mostrar interfaz.
    activeGui = MachineInterface.Create(
        minigameId,
        player.Name,
        function()

            if exitRequested then
                return
            end

            exitRequested = true

            remote:FireServer("RequestEnd")

        end
    )

    print("[Universo Arcade] Interfaz abierta:", minigameId)

    startActiveMinigame(minigameId)

end

local function endMachine(reason)

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

end

remote.OnClientEvent:Connect(function(action, firstArgument, secondArgument)

    if action == "Started" then

        local machine = firstArgument
        local minigameId = secondArgument

        startMachine(machine, minigameId)

    elseif action == "Ended" then

        local reason = firstArgument

        endMachine(reason)

    end

end)

-- Si el personaje desaparece, limpiar la interfaz local.
player.CharacterRemoving:Connect(function()

    stopActiveMinigame()

    if activeGui then
        closeInterface()
    end

    sessionActive = false
    activeMachine = nil
    exitRequested = false

end)

print("[Universo Arcade] MachineClientController preparado.")
