
--[[
    UNIVERSO ARCADE
    MachineInteractionService

    Configura la interacción de los jugadores
    con las 28 recreativas.
]]

local Workspace = game:GetService("Workspace")

local MachineSessionService = require(
    script.Parent:WaitForChild("MachineSessionService")
)

local MachineInteractionService = {}

local function configureMachine(model)

    local screen = model:FindFirstChild("ScreenGlass")

    if not screen then
        warn(
            "[Universo Arcade] No se encontró ScreenGlass en:",
            model.Name
        )
        return false
    end

    -- Evitar duplicar la interacción.
    local oldAttachment = screen:FindFirstChild("InteractionAttachment")

    if oldAttachment then
        oldAttachment:Destroy()
    end

    -- Punto de interacción delante de la pantalla.
    local attachment = Instance.new("Attachment")
    attachment.Name = "InteractionAttachment"
    attachment.Position = Vector3.new(0, 0, 0.08)
    attachment.Parent = screen

    -- Estado inicial de la recreativa.
    model:SetAttribute("IsOccupied", false)
    model:SetAttribute("OccupiedByUserId", 0)

    -- Crear el aviso de interacción.
    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = "MachinePrompt"

    prompt.ActionText = "Jugar"
    prompt.ObjectText = model:GetAttribute("DisplayName") or "Recreativa"

    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.GamepadKeyCode = Enum.KeyCode.ButtonX

    prompt.HoldDuration = 0
    prompt.MaxActivationDistance = 10
    prompt.RequiresLineOfSight = true

    prompt.Parent = attachment

    -- Gestionar el inicio de una sesión.
    prompt.Triggered:Connect(function(player)

        local success, reason =
            MachineSessionService.StartSession(player, model)

        if not success then
            print(
                "[Universo Arcade] No se pudo iniciar la sesión:",
                reason,
                "| Jugador:",
                player.Name
            )
        end

    end)

    return true
end

function MachineInteractionService.Apply()

    local map = Workspace:WaitForChild("Map")
    local arcade = map:WaitForChild("Arcade")

    local machinesFolder = arcade:WaitForChild("ArcadeMachines")

    local configuredMachines = 0

    for _, machine in ipairs(machinesFolder:GetChildren()) do

        if machine:IsA("Model") then

            if configureMachine(machine) then
                configuredMachines += 1
            end

        end

    end

    print(
        "[Universo Arcade] Sistema de interacción preparado:",
        configuredMachines,
        "de",
        #machinesFolder:GetChildren(),
        "recreativas."
    )

end

return MachineInteractionService
