local ServerScriptService = game:GetService("ServerScriptService")

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

MapBuilder.Build()
LightingService.Apply()
ArcadeLightingService.Apply()

print("[Universo Arcade] Inicialización completada.")