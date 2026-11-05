
--[[
    UNIVERSO ARCADE
    MachineSessionService

    Gestiona las sesiones de juego:
    - Un jugador solo puede tener una sesión activa.
    - Una máquina solo puede tener un jugador.
    - Las máquinas se liberan al morir o desconectarse.
]]

local Players = game:GetService("Players")

local MachineSessionService = {}

-- Sesiones activas por jugador.
local activeSessionsByPlayer = {}

-- Jugador que está utilizando cada máquina.
local activeSessionsByMachine = {}

local function getMachinePrompt(machine)
    return machine:FindFirstChild("MachinePrompt", true)
end

function MachineSessionService.EndSession(player, reason)

    local session = activeSessionsByPlayer[player]

    if not session then
        return false
    end

    local machine = session.machine

    -- Desconectar los eventos de la sesión.
    if session.diedConnection then
        session.diedConnection:Disconnect()
    end

    if session.characterRemovingConnection then
        session.characterRemovingConnection:Disconnect()
    end

    -- Liberar los registros.
    activeSessionsByPlayer[player] = nil

    if activeSessionsByMachine[machine] == player then
        activeSessionsByMachine[machine] = nil
    end

    -- Actualizar el estado de la máquina.
    if machine and machine.Parent then

        machine:SetAttribute("IsOccupied", false)
        machine:SetAttribute("OccupiedByUserId", 0)

        local prompt = getMachinePrompt(machine)

        if prompt then
            prompt.ActionText = "Jugar"
        end

    end

    print("----------------------------------------")
    print("[Universo Arcade] Sesión finalizada.")
    print("Jugador:", player.Name)
    print("Máquina:", session.machineId)
    print("Motivo:", reason or "Sin especificar")
    print("----------------------------------------")

    return true
end

function MachineSessionService.StartSession(player, machine)

    if not player or not player:IsA("Player") then
        return false, "Jugador no válido."
    end

    if not machine or not machine:IsA("Model") then
        return false, "Máquina no válida."
    end

    -- Comprobar si el jugador ya está jugando.
    if activeSessionsByPlayer[player] then
        return false, "Ya tienes una partida activa."
    end

    -- Comprobar si la máquina está ocupada.
    if activeSessionsByMachine[machine] then
        return false, "Esta recreativa está ocupada."
    end

    -- Comprobar que el personaje está vivo.
    local character = player.Character
    local humanoid = character
        and character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid.Health <= 0 then
        return false, "El jugador no está disponible."
    end

    local machineId = machine:GetAttribute("MachineId")

    if not machineId then
        return false, "La máquina no tiene identificador."
    end

    -- Crear la sesión.
    local session = {
        player = player,
        machine = machine,
        machineId = machineId,
        minigameId = machine:GetAttribute("MinigameId"),
        startedAt = os.time(),
    }

    -- Registrar la sesión en ambos registros.
    activeSessionsByPlayer[player] = session
    activeSessionsByMachine[machine] = player

    -- Actualizar los atributos replicados de la máquina.
    machine:SetAttribute("IsOccupied", true)
    machine:SetAttribute("OccupiedByUserId", player.UserId)

    -- Cambiar el texto de interacción.
    local prompt = getMachinePrompt(machine)

    if prompt then
        prompt.ActionText = "Ocupada"
    end

    -- Liberar la máquina si el jugador muere.
    session.diedConnection = humanoid.Died:Connect(function()
        MachineSessionService.EndSession(player, "Jugador eliminado")
    end)

    -- También liberar si desaparece el personaje.
    session.characterRemovingConnection =
        player.CharacterRemoving:Connect(function(removingCharacter)

            if removingCharacter == character then
                MachineSessionService.EndSession(
                    player,
                    "Personaje retirado"
                )
            end

        end)

    print("----------------------------------------")
    print("[Universo Arcade] Nueva sesión iniciada.")
    print("Jugador:", player.Name)
    print("Máquina:", machineId)
    print("Minijuego:", session.minigameId)
    print("----------------------------------------")

    return true
end

-- Liberar la sesión cuando alguien abandona el servidor.
Players.PlayerRemoving:Connect(function(player)
    MachineSessionService.EndSession(player, "Jugador desconectado")
end)

return MachineSessionService
