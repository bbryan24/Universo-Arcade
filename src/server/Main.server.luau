
--[[
    UNIVERSO ARCADE
    Punto de entrada del servidor.
]]

local ServerScriptService = game:GetService("ServerScriptService")

local MapBuilder = require(
    ServerScriptService:WaitForChild("Server")
        :WaitForChild("Services")
        :WaitForChild("MapBuilder")
)

MapBuilder.Build()
