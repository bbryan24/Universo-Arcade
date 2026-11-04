
--[[
    UNIVERSO ARCADE
    Servicio de iluminación ambiental.

    Estilo: mezcla de arcade clásico y futurista.
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
    -- Iluminación general.
-- La tecnología de iluminación se configura desde Studio.
    Lighting.ClockTime = 0
    Lighting.Brightness = 2
    Lighting.ExposureCompensation = 0

    -- Ambiente oscuro, pero con suficiente visibilidad.
    Lighting.Ambient = Color3.fromRGB(65, 55, 95)
    Lighting.OutdoorAmbient = Color3.fromRGB(35, 30, 55)
    Lighting.ColorShift_Top = Color3.fromRGB(35, 25, 65)
    Lighting.ColorShift_Bottom = Color3.fromRGB(15, 15, 30)

    Lighting.EnvironmentDiffuseScale = 0.35
    Lighting.EnvironmentSpecularScale = 0.7

    -- Resplandor de los elementos luminosos.
    local bloom = getOrCreateEffect("BloomEffect", "ArcadeBloom")
    bloom.Intensity = 0.18
    bloom.Size = 18
    bloom.Threshold = 1.5

    -- Ajuste general del color.
    local colorCorrection = getOrCreateEffect(
        "ColorCorrectionEffect",
        "ArcadeColorCorrection"
    )

    colorCorrection.Brightness = -0.03
    colorCorrection.Contrast = 0.15
    colorCorrection.Saturation = 0.15
    colorCorrection.TintColor = Color3.fromRGB(220, 215, 255)

    -- Ambiente ligeramente brumoso para dar profundidad.
    local atmosphere = getOrCreateEffect(
        "Atmosphere",
        "ArcadeAtmosphere"
    )

    atmosphere.Density = 0.12
    atmosphere.Offset = 0.1
    atmosphere.Color = Color3.fromRGB(145, 125, 190)
    atmosphere.Decay = Color3.fromRGB(65, 45, 110)
    atmosphere.Glare = 0
    atmosphere.Haze = 0.5
end

return LightingService
