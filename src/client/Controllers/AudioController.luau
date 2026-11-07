
--[[
    UNIVERSO ARCADE
    AudioController

    Gestiona los efectos de sonido del cliente.

    Utiliza una configuración compartida
    para todos los minijuegos.
]]

local ReplicatedStorage =
    game:GetService("ReplicatedStorage")

local SoundService =
    game:GetService("SoundService")

local AudioConfig = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Config")
        :WaitForChild("AudioConfig")
)

local AudioController = {}

--==================================================
-- ESTADO
--==================================================

local enabled = AudioConfig.Settings.Enabled

local masterVolume =
    AudioConfig.Settings.MasterVolume

local effectsVolume =
    AudioConfig.Settings.EffectsVolume

local soundCache = {}

--==================================================
-- OBTENER CONFIGURACIÓN DE UN SONIDO
--==================================================

local function getSoundConfig(minigame, soundName)

    local minigameSounds = AudioConfig[minigame]

    if not minigameSounds then
        return nil
    end

    return minigameSounds[soundName]

end

--==================================================
-- CREAR O RECUPERAR UN SONIDO
--==================================================

local function getSound(minigame, soundName)

    local soundData =
        getSoundConfig(minigame, soundName)

    if not soundData then
        return nil
    end

    if not soundData.SoundId
        or soundData.SoundId == "" then

        return nil
    end

    local key = minigame .. "_" .. soundName

    if soundCache[key] then
        return soundCache[key]
    end

    local sound = Instance.new("Sound")

    sound.Name = key
    sound.SoundId = soundData.SoundId

    sound.Volume = 1
    sound.Looped = false

    sound.Parent = SoundService

    soundCache[key] = sound

    return sound

end

--==================================================
-- REPRODUCIR EFECTO DE SONIDO
--==================================================

function AudioController.Play(minigame, soundName)

    if not enabled then
        return
    end

    local soundData =
        getSoundConfig(minigame, soundName)

    if not soundData then
        return
    end

    local sound = getSound(minigame, soundName)

    if not sound then
        return
    end

    sound.Volume =
        (soundData.Volume or 1)
        * masterVolume
        * effectsVolume

    SoundService:PlayLocalSound(sound)

end

--==================================================
-- ACTIVAR O DESACTIVAR AUDIO
--==================================================

function AudioController.SetEnabled(value)

    enabled = value == true

end

--==================================================
-- CONTROL DE VOLUMEN GENERAL
--==================================================

function AudioController.SetMasterVolume(value)

    masterVolume = math.clamp(value, 0, 1)

end

--==================================================
-- CONTROL DE VOLUMEN DE EFECTOS
--==================================================

function AudioController.SetEffectsVolume(value)

    effectsVolume = math.clamp(value, 0, 1)

end

--==================================================
-- LIBERAR RECURSOS
--==================================================

function AudioController.Destroy()

    for _, sound in pairs(soundCache) do

        sound:Destroy()

    end

    table.clear(soundCache)

end

return AudioController
