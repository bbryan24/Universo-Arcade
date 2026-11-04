
--[[
    UNIVERSO ARCADE
    Servicio de iluminacion ambiental.

    Objetivo:
    - Ambiente nocturno y futurista.
    - Mejor visibilidad general.
    - Neones definidos sin halos excesivos.
    - Personajes y maquinas nitidos.
]]

local Lighting = game:GetService("Lighting")

local LightingService = {}

local function getOrCreateEffect(className, effectName)
    local effect = Lighting:FindFirstChild(effectName)

    if effect and not effect:IsA(className) then
        effect:Destroy()
        effect = nil
    end

    if not effect then
        effect = Instance.new(className)
        effect.Name = effectName
        effect.Parent = Lighting
    end

    return effect
end

function LightingService.Apply()

    -- ================================================
    -- ILUMINACION GENERAL
    -- ================================================

    Lighting.ClockTime = 0
    Lighting.Brightness = 2.5
    Lighting.ExposureCompensation = 0.1

    -- Ambiente oscuro, pero con mejor visibilidad.
    Lighting.Ambient = Color3.fromRGB(90, 85, 120)
    Lighting.OutdoorAmbient = Color3.fromRGB(65, 60, 90)

    Lighting.ColorShift_Top = Color3.fromRGB(25, 20, 55)
    Lighting.ColorShift_Bottom = Color3.fromRGB(20, 20, 35)

    Lighting.EnvironmentDiffuseScale = 0.5
    Lighting.EnvironmentSpecularScale = 0.6

    -- ================================================
    -- BLOOM: CONTROL DE LOS HALOS
    -- ================================================

    local bloom = getOrCreateEffect(
        "BloomEffect",
        "ArcadeBloom"
    )

    bloom.Intensity = 0.08
    bloom.Size = 12
    bloom.Threshold = 2

    -- ================================================
    -- CORRECCION DE COLOR
    -- ================================================

    local colorCorrection = getOrCreateEffect(
        "ColorCorrectionEffect",
        "ArcadeColorCorrection"
    )

    colorCorrection.Brightness = 0
    colorCorrection.Contrast = 0.08
    colorCorrection.Saturation = 0.08
    colorCorrection.TintColor = Color3.fromRGB(235, 230, 255)

    -- ================================================
    -- ATMOSFERA
    -- ================================================

    local atmosphere = getOrCreateEffect(
        "Atmosphere",
        "ArcadeAtmosphere"
    )

    atmosphere.Density = 0.04
    atmosphere.Offset = 0.1
    atmosphere.Color = Color3.fromRGB(160, 150, 200)
    atmosphere.Decay = Color3.fromRGB(75, 60, 120)
    atmosphere.Glare = 0
    atmosphere.Haze = 0.2
end

return LightingService
