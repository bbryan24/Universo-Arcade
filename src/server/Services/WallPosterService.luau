
local Workspace = game:GetService("Workspace")

local WallPosterService = {}

local POSTER_WIDTH = 3.5
local POSTER_HEIGHT = 4.4
local POSTER_Y = 7.2

local COLORS = {
    Dark = Color3.fromRGB(15, 18, 38),
    White = Color3.fromRGB(235, 232, 220),
    Cyan = Color3.fromRGB(0, 190, 255),
    Pink = Color3.fromRGB(255, 65, 180),
    Purple = Color3.fromRGB(125, 95, 255),
    Orange = Color3.fromRGB(255, 160, 55),
    Tape = Color3.fromRGB(205, 195, 160),
}

local POSTER_DESIGNS = {
    BlockPuzzle = {
        Title = "BLOCK\nATTACK!",
        Subtitle = "FIT THE FUTURE",
        Background = Color3.fromRGB(13, 29, 49),
        Accent = COLORS.Cyan,
        Secondary = COLORS.Purple,
        Number = "01",
    },

    BubbleShooter = {
        Title = "BUBBLE\nBLAST!",
        Subtitle = "A NEW ARCADE CLASSIC",
        Background = Color3.fromRGB(42, 16, 48),
        Accent = COLORS.Pink,
        Secondary = COLORS.Purple,
        Number = "02",
    },

    SpaceShooter = {
        Title = "SPACE\nINVADERS",
        Subtitle = "DEFEND THE GALAXY",
        Background = Color3.fromRGB(17, 18, 49),
        Accent = COLORS.Purple,
        Secondary = COLORS.Cyan,
        Number = "03",
    },

    BrickBreaker = {
        Title = "BRICK\nBREAKER",
        Subtitle = "BREAK YOUR LIMITS",
        Background = Color3.fromRGB(49, 25, 15),
        Accent = COLORS.Orange,
        Secondary = Color3.fromRGB(255, 210, 100),
        Number = "04",
    },
}

local function createUI(className, parent, properties)
    local object = Instance.new(className)

    for property, value in pairs(properties) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function createPosterArtwork(poster, design)
    local surface = createUI("SurfaceGui", poster, {
        Name = "PosterArtwork",
        Face = Enum.NormalId.Front,
        SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
        PixelsPerStud = 80,
        LightInfluence = 1,
        AlwaysOnTop = false,
    })

    local background = createUI("Frame", surface, {
        Name = "Background",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = design.Background,
        BorderSizePixel = 0,
    })

    -- Franja superior.
    createUI("Frame", background, {
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundColor3 = design.Accent,
        BorderSizePixel = 0,
    })

    -- Número de la colección.
    createUI("TextLabel", background, {
        Position = UDim2.fromScale(0.08, 0.08),
        Size = UDim2.fromScale(0.3, 0.08),
        BackgroundTransparency = 1,
        Text = "UNIVERSO ARCADE",
        TextColor3 = design.Accent,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Título principal.
    createUI("TextLabel", background, {
        Position = UDim2.fromScale(0.07, 0.19),
        Size = UDim2.fromScale(0.86, 0.25),
        BackgroundTransparency = 1,
        Text = design.Title,
        TextColor3 = COLORS.White,
        TextScaled = true,
        Font = Enum.Font.GothamBlack,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })

    -- Ilustración geométrica central.
    local illustration = createUI("Frame", background, {
        Position = UDim2.fromScale(0.08, 0.51),
        Size = UDim2.fromScale(0.84, 0.27),
        BackgroundTransparency = 1,
    })

    if design.Number == "01" then
        -- Bloques encajados.
        for row = 0, 2 do
            for column = 0, 3 do
                if (row + column) % 3 ~= 1 then
                    createUI("Frame", illustration, {
                        Position = UDim2.fromScale(
                            0.08 + column * 0.22,
                            0.08 + row * 0.29
                        ),
                        Size = UDim2.fromScale(0.17, 0.23),
                        BackgroundColor3 =
                            (row + column) % 2 == 0
                            and design.Accent
                            or design.Secondary,
                        BorderSizePixel = 0,
                    })
                end
            end
        end

    elseif design.Number == "02" then
        -- Burbujas distribuidas siguiendo una trayectoria.
        local bubbles = {
            {0.12, 0.55, 0.15},
            {0.30, 0.25, 0.19},
            {0.49, 0.12, 0.13},
            {0.67, 0.32, 0.20},
            {0.84, 0.58, 0.13},
        }

        for _, bubble in ipairs(bubbles) do
            createUI("Frame", illustration, {
                Position = UDim2.fromScale(bubble[1], bubble[2]),
                Size = UDim2.fromScale(bubble[3], bubble[3]),
                BackgroundColor3 = design.Accent,
                BorderSizePixel = 0,
            })

            local circle = illustration:GetChildren()[#illustration:GetChildren()]
            createUI("UICorner", circle, {
                CornerRadius = UDim.new(1, 0),
            })
        end

    elseif design.Number == "03" then
        -- Nave espacial y estrellas.
        createUI("Frame", illustration, {
            Position = UDim2.fromScale(0.40, 0.18),
            Size = UDim2.fromScale(0.20, 0.62),
            BackgroundColor3 = design.Accent,
            BorderSizePixel = 0,
            Rotation = 45,
        })

        for index = 1, 5 do
            createUI("Frame", illustration, {
                Position = UDim2.fromScale(
                    0.08 + index * 0.16,
                    index % 2 == 0 and 0.05 or 0.78
                ),
                Size = UDim2.fromScale(0.035, 0.035),
                BackgroundColor3 = COLORS.White,
                BorderSizePixel = 0,
            })
        end

    else
        -- Ladrillos escalonados.
        for row = 0, 2 do
            for column = 0, 3 do
                createUI("Frame", illustration, {
                    Position = UDim2.fromScale(
                        0.04 + column * 0.24 + (row % 2) * 0.06,
                        0.08 + row * 0.29
                    ),
                    Size = UDim2.fromScale(0.20, 0.22),
                    BackgroundColor3 =
                        row % 2 == 0
                        and design.Accent
                        or design.Secondary,
                    BorderSizePixel = 0,
                })
            end
        end
    end

    -- Eslogan inferior.
    createUI("TextLabel", background, {
        Position = UDim2.fromScale(0.07, 0.84),
        Size = UDim2.fromScale(0.86, 0.09),
        BackgroundTransparency = 1,
        Text = design.Subtitle,
        TextColor3 = COLORS.White,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Número decorativo.
    createUI("TextLabel", background, {
        Position = UDim2.fromScale(0.78, 0.91),
        Size = UDim2.fromScale(0.15, 0.06),
        BackgroundTransparency = 1,
        Text = design.Number,
        TextColor3 = design.Accent,
        TextScaled = true,
        Font = Enum.Font.GothamBlack,
    })
end

local function createTape(parent, posterFrame, x, y, rotation)
    local tape = Instance.new("Part")
    tape.Name = "PosterTape"
    tape.Size = Vector3.new(0.65, 0.16, 0.025)
    tape.Anchored = true
    tape.CanCollide = false
    tape.CanTouch = false
    tape.CanQuery = false
    tape.Material = Enum.Material.SmoothPlastic
    tape.Color = COLORS.Tape
    tape.Transparency = 0.12

    tape.CFrame =
        posterFrame
        * CFrame.new(x, y, -0.075)
        * CFrame.Angles(0, 0, math.rad(rotation))

    tape.Parent = parent
end

local function createPoster(parent, wallPosition, normal, design, rotation, tapeVariant)
    local poster = Instance.new("Part")
    poster.Name = "ArcadePoster"
    poster.Size = Vector3.new(
        POSTER_WIDTH,
        POSTER_HEIGHT,
        0.12
    )
    poster.Anchored = true
    poster.CanCollide = false
    poster.CanTouch = false
    poster.CanQuery = false
    poster.Material = Enum.Material.SmoothPlastic
    poster.Color = design.Background

    local posterPosition = wallPosition + normal * 1.09

local posterFrame = CFrame.lookAt(
    posterPosition,
    posterPosition + normal
) * CFrame.Angles(0, 0, math.rad(rotation))

    poster.CFrame = posterFrame
    poster.Parent = parent

    createPosterArtwork(poster, design)

    -- Cinta adhesiva en algunas esquinas.
    if tapeVariant == 1 then
        createTape(parent, posterFrame, -1.25, 2.05, -12)
        createTape(parent, posterFrame, 1.25, -2.05, 9)

    elseif tapeVariant == 2 then
        createTape(parent, posterFrame, 1.25, 2.05, 11)
    end
end

local function decorateRoom(parent, zone, design)
    local width = 60
    local depth = 50

    local centerX = zone.X * 18
    local centerZ = zone.Z * 18

    local diagonal = 8 / math.sqrt(2)

    local endpointAX = centerX + zone.X * diagonal
    local endpointAZ = centerZ - zone.Z * diagonal

    local endpointBX = centerX - zone.X * diagonal
    local endpointBZ = centerZ + zone.Z * diagonal

    local outerX = zone.X * (width / 2 - 1)
    local outerZ = zone.Z * (depth / 2 - 1)

        -- Desplazamos los pósteres hacia el extremo
        -- de cada pared, alejándolos de los marcos.
        local wallOffset = 0.65

        local lateralCenter = Vector3.new(
            (outerX + endpointAX) / 2 + zone.X * wallOffset,
            POSTER_Y,
            endpointAZ
        )

        local backCenter = Vector3.new(
            endpointBX,
            POSTER_Y,
            (outerZ + endpointBZ) / 2 + zone.Z * wallOffset
        )

    local lateralNormal = Vector3.new(0, 0, zone.Z)
    local backNormal = Vector3.new(zone.X, 0, 0)

    -- Un póster por cada pared interior.
    -- El primero recto y el segundo ligeramente torcido.
    createPoster(
        parent,
        lateralCenter,
        lateralNormal,
        design,
        0,
        1
    )

    createPoster(
        parent,
        backCenter,
        backNormal,
        design,
        -2.5,
        2
    )
end

function WallPosterService.Apply()
    local map = Workspace:WaitForChild("Map")
    local arcade = map:WaitForChild("Arcade")

    local oldFolder = arcade:FindFirstChild("WallPosters")

    if oldFolder then
        oldFolder:Destroy()
    end

    local folder = Instance.new("Folder")
    folder.Name = "WallPosters"
    folder.Parent = arcade

    decorateRoom(
    folder,
    Vector3.new(-1, 0, -1),
    POSTER_DESIGNS.BlockPuzzle
)

decorateRoom(
    folder,
    Vector3.new(1, 0, -1),
    POSTER_DESIGNS.BubbleShooter
)

decorateRoom(
    folder,
    Vector3.new(-1, 0, 1),
    POSTER_DESIGNS.SpaceShooter
)

decorateRoom(
    folder,
    Vector3.new(1, 0, 1),
    POSTER_DESIGNS.BrickBreaker
)

    print("[Universo Arcade] Pósteres retro aplicados.")
end

return WallPosterService
