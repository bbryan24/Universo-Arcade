local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local function removeDefaultStudioObjects()
    for _, object in ipairs(Workspace:GetChildren()) do
        if object.Name == "Baseplate" then
            object:Destroy()
            print("[Universo Arcade] Baseplate eliminado.")
        elseif object:IsA("SpawnLocation") then
            object:Destroy()
            print("[Universo Arcade] SpawnLocation predeterminado eliminado.")
        end
    end
end


local function createPlayerSpawn()
    local map = Workspace:WaitForChild("Map")
    local arcade = map:WaitForChild("Arcade")

    local spawn = Instance.new("SpawnLocation")
    spawn.Name = "ArcadePlayerSpawn"

    -- Centro del hub principal.
    spawn.Size = Vector3.new(6, 1, 6)
    spawn.Position = Vector3.new(0, 0.5, 0)

    -- Invisible y sin colisión: el suelo del arcade
    -- seguirá siendo la superficie que pisará el jugador.
    spawn.Transparency = 1
    spawn.CanCollide = false
    spawn.Anchored = true

    spawn.Neutral = true
    spawn.Duration = 0

    spawn.Parent = arcade

    print("[Universo Arcade] Punto de aparición creado.")
end


print("[Universo Arcade] Main iniciado.")

local Services = ServerScriptService
    :WaitForChild("Server")
    :WaitForChild("Services")

local MapBuilder = require(
    Services:WaitForChild("MapBuilder")
)

local LightingService = require(
    Services:WaitForChild("LightingService")
)

print("[Universo Arcade] Servicios básicos cargados.")

local ArcadeLightingService = require(
    Services:WaitForChild("ArcadeLightingService")
)
print("[Universo Arcade] ArcadeLightingService cargado.")

local WallArchitectureService = require(
    Services:WaitForChild("WallArchitectureService")
)

print("[Universo Arcade] WallArchitectureService cargado.")

local WallDecorationService = require(
    Services:WaitForChild("WallDecorationService")
)

local WallPosterService = require(
    Services:WaitForChild("WallPosterService")
)

local MachineInteractionService = require(
    Services:WaitForChild("MachineInteractionService")
)

print("[Universo Arcade] MachineInteractionService cargado.")

removeDefaultStudioObjects()

MapBuilder.Build()
createPlayerSpawn()

MachineInteractionService.Apply()

WallArchitectureService.Apply()
WallDecorationService.Apply()
WallPosterService.Apply()

LightingService.Apply()
ArcadeLightingService.Apply()

print("[Universo Arcade] Inicialización completada.")