--[[
    K5 HUB - NEON GREEN UI
    Applied to the original K5-HUB code redeem system.
    Functional redeem logic is preserved; only branding/UI presentation is redesigned.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local CodeRE = ReplicatedStorage.Framework.Systems.CodesSystem.CodeRE

-- Ganti dengan ID gambar logo K5 HUB yang sudah di-upload ke Roblox
local LOGO_IMAGE = "" -- Isi dengan rbxassetid://ID_LOGO_K5 jika sudah upload logo

local CODE_COOLDOWN = 8.6
local BUFFER = 8.5
local REDEEM_DELAY = CODE_COOLDOWN + BUFFER

local Codes = {
    "Locko_SS",
    "MAS ACENG",
    "Aimyoungs",
    "GRAYWOLF",
    "Astral",
}

--==================================================
-- STATE
--==================================================

local AutoRedeem = false
local IsRedeeming = false
local claimedCodes = {}

local totalCodes = #Codes
local processedCount = 0

--==================================================
-- COLORS
--==================================================

local BG = Color3.fromRGB(5, 8, 6)
local PANEL = Color3.fromRGB(10, 15, 11)
local PANEL_LIGHT = Color3.fromRGB(15, 22, 16)

local PURPLE = Color3.fromRGB(145, 255, 0)
local PURPLE_DARK = Color3.fromRGB(65, 125, 0)

local WHITE = Color3.fromRGB(245, 255, 242)
local GREY = Color3.fromRGB(150, 165, 152)

local GREEN = Color3.fromRGB(145, 255, 0)
local RED = Color3.fromRGB(255, 75, 75)

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "K5HubIronSoulCode"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- MAIN
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 680, 0, 455)
Main.ClipsDescendants = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(7, 10, 8)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

--==================================================
-- PREMIUM BACKGROUND / GLOW
--==================================================

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 13, 9)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(6, 10, 7)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 19, 11)),
})
MainGradient.Rotation = 135
MainGradient.Parent = Main

local Glow = Instance.new("Frame")
Glow.Name = "Glow"
Glow.Position = UDim2.new(0, 8, 0, 8)
Glow.Size = UDim2.new(1, -16, 1, -16)
Glow.BackgroundTransparency = 1
Glow.ZIndex = 0
Glow.Parent = Main

local GlowStroke = Instance.new("UIStroke")
GlowStroke.Color = PURPLE
GlowStroke.Thickness = 6
GlowStroke.Transparency = 0.82
GlowStroke.Parent = Glow

-- Neon green accent line
local MainAccent = Instance.new("Frame")
MainAccent.Name = "NeonAccent"
MainAccent.Position = UDim2.new(0, 18, 0, 0)
MainAccent.Size = UDim2.new(1, -36, 0, 3)
MainAccent.BackgroundColor3 = PURPLE
MainAccent.BorderSizePixel = 0
MainAccent.ZIndex = 3
MainAccent.Parent = Main

local MainAccentCorner = Instance.new("UICorner")
MainAccentCorner.CornerRadius = UDim.new(1, 0)
MainAccentCorner.Parent = MainAccent

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = PURPLE_DARK
MainStroke.Thickness = 2
MainStroke.Transparency = 0.05
MainStroke.Parent = Main

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 78)
Header.BackgroundColor3 = Color3.fromRGB(10, 15, 11)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 18)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Position = UDim2.new(0, 0, 1, -16)
HeaderFix.Size = UDim2.new(1, 0, 0, 16)
HeaderFix.BackgroundColor3 = PANEL
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Position = UDim2.new(0, 24, 1, -1)
HeaderLine.Size = UDim2.new(1, -48, 0, 1)
HeaderLine.BackgroundColor3 = PURPLE
HeaderLine.BackgroundTransparency = 0.35
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

--==================================================
-- DRAGGABLE PANEL
--==================================================

local dragging = false
local dragStart = nil
local startPosition = nil

local function updateDrag(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        updateDrag(input)
    end
end)

--==================================================
-- MINIMIZE BUTTON (ke logo K5)
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Position = UDim2.new(0, 8, 0, 8)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.BackgroundColor3 = Color3.fromRGB(24, 35, 22)
CloseButton.Text = "×"
CloseButton.TextColor3 = WHITE
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.AutoButtonColor = false
CloseButton.BorderSizePixel = 0
CloseButton.ZIndex = 5
CloseButton.Parent = Header

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.12), {BackgroundColor3 = RED}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(24, 35, 22)}):Play()
end)

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Logo
local Icon
if LOGO_IMAGE ~= "" then
    Icon = Instance.new("ImageLabel")
    Icon.Image = LOGO_IMAGE
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.BackgroundTransparency = 1
else
    Icon = Instance.new("TextLabel")
    Icon.Text = "K5"
end
Icon.Name = "Logo"
Icon.Position = UDim2.new(0, 48, 0.5, -20)
Icon.Size = UDim2.new(0, 44, 0, 40)
Icon.BackgroundColor3 = PURPLE_DARK
Icon.BackgroundTransparency = 0
Icon.BorderSizePixel = 0

if Icon:IsA("TextLabel") then
    Icon.Text = "K5"
    Icon.TextColor3 = WHITE
    Icon.TextSize = 20
    Icon.Font = Enum.Font.GothamBlack
    Icon.TextXAlignment = Enum.TextXAlignment.Center
    Icon.TextYAlignment = Enum.TextYAlignment.Center
end

Icon.Parent = Header

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 8)
IconCorner.Parent = Icon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = PURPLE
IconStroke.Thickness = 1
IconStroke.Parent = Icon

-- Title
local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 104, 0, 9)
Title.Size = UDim2.new(1, -145, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "K5 HUB"
Title.TextColor3 = WHITE
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 21
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Name = "Version"
Version.Position = UDim2.new(1, -116, 0, 18)
Version.Size = UDim2.new(0, 66, 0, 26)
Version.BackgroundColor3 = PURPLE_DARK
Version.BackgroundTransparency = 0.15
Version.Text = "K5 HUB"
Version.TextColor3 = WHITE
Version.TextSize = 9
Version.Font = Enum.Font.GothamBold
Version.TextXAlignment = Enum.TextXAlignment.Center
Version.TextYAlignment = Enum.TextYAlignment.Center
Version.BorderSizePixel = 0
Version.ZIndex = 4
Version.Parent = Header

local VersionCorner = Instance.new("UICorner")
VersionCorner.CornerRadius = UDim.new(1, 0)
VersionCorner.Parent = Version

local Subtitle = Instance.new("TextLabel")
Subtitle.Position = UDim2.new(0, 104, 0, 32)
Subtitle.Size = UDim2.new(1, -145, 0, 16)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "FAST  •  STABLE  •  SECURE  •  PREMIUM"
Subtitle.TextColor3 = GREY
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = Header

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Position = UDim2.new(0, 26, 0, 96)
Content.Size = UDim2.new(1, -52, 1, -118)
Content.BackgroundTransparency = 1
Content.Parent = Main

--==================================================
-- MINIMIZED LOGO
--==================================================

local FloatingLogo = Instance.new("TextButton")
FloatingLogo.Name = "FloatingLogo"
FloatingLogo.Size = UDim2.new(0, 76, 0, 76)
FloatingLogo.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
FloatingLogo.BackgroundColor3 = BG
FloatingLogo.Text = "K5"
FloatingLogo.TextColor3 = WHITE
FloatingLogo.TextSize = 32
FloatingLogo.Font = Enum.Font.GothamBlack
FloatingLogo.AutoButtonColor = false
FloatingLogo.BorderSizePixel = 0
FloatingLogo.Visible = false
FloatingLogo.ZIndex = 20
FloatingLogo.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0, 22)
FloatingCorner.Parent = FloatingLogo

local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Color = PURPLE
FloatingStroke.Thickness = 3
FloatingStroke.Parent = FloatingLogo

local FloatingScale = Instance.new("UIScale")
FloatingScale.Scale = 1
FloatingScale.Parent = FloatingLogo

local floatingDragging = false
local floatingDragStart = nil
local floatingStartPosition = nil

FloatingLogo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        floatingDragging = true
        floatingDragStart = input.Position
        floatingStartPosition = FloatingLogo.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                floatingDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if floatingDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - floatingDragStart
        FloatingLogo.Position = UDim2.new(
            floatingStartPosition.X.Scale,
            floatingStartPosition.X.Offset + delta.X,
            floatingStartPosition.Y.Scale,
            floatingStartPosition.Y.Offset + delta.Y
        )
    end
end)

FloatingLogo.MouseEnter:Connect(function()
    TweenService:Create(FloatingScale, TweenInfo.new(0.12), {Scale = 1.08}):Play()
end)

FloatingLogo.MouseLeave:Connect(function()
    TweenService:Create(FloatingScale, TweenInfo.new(0.12), {Scale = 1}):Play()
end)

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = Main

local OPEN_TWEEN = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local CLOSE_TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local function minimizePanel()
    CloseButton.Active = false
    FloatingLogo.Visible = true

    TweenService:Create(MainScale, CLOSE_TWEEN, {Scale = 0.08}):Play()
    local fade = TweenService:Create(Main, CLOSE_TWEEN, {BackgroundTransparency = 1})
    fade:Play()
    FloatingLogo.BackgroundTransparency = 1
    TweenService:Create(FloatingLogo, OPEN_TWEEN, {BackgroundTransparency = 0}):Play()

    fade.Completed:Wait()
    Main.Visible = false
    Main.BackgroundTransparency = 0
    MainScale.Scale = 0.08
    CloseButton.Active = true
end

local function restorePanel()
    FloatingLogo.Visible = false
    Main.Visible = true
    MainScale.Scale = 0.08

    TweenService:Create(MainScale, OPEN_TWEEN, {Scale = 1}):Play()
end

--==================================================
-- AUTO REDEEM BOX
--==================================================

local AutoBox = Instance.new("Frame")
AutoBox.Size = UDim2.new(1, 0, 0, 64)
AutoBox.BackgroundColor3 = Color3.fromRGB(14, 21, 15)
AutoBox.BorderSizePixel = 0
AutoBox.Parent = Content

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 12)
AutoCorner.Parent = AutoBox

local AutoStroke = Instance.new("UIStroke")
AutoStroke.Color = Color3.fromRGB(45, 70, 30)
AutoStroke.Thickness = 1
AutoStroke.Parent = AutoBox

local AutoTitle = Instance.new("TextLabel")
AutoTitle.Position = UDim2.new(0, 14, 0, 8)
AutoTitle.Size = UDim2.new(1, -80, 0, 20)
AutoTitle.BackgroundTransparency = 1
AutoTitle.Text = "Auto Redeem"
AutoTitle.TextColor3 = WHITE
AutoTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoTitle.TextSize = 15
AutoTitle.Font = Enum.Font.GothamMedium
AutoTitle.Parent = AutoBox

local AutoStatus = Instance.new("TextLabel")
AutoStatus.Position = UDim2.new(0, 14, 0, 29)
AutoStatus.Size = UDim2.new(1, -80, 0, 16)
AutoStatus.BackgroundTransparency = 1
AutoStatus.Text = "Jalankan redeem kode secara otomatis"
AutoStatus.TextColor3 = GREY
AutoStatus.TextXAlignment = Enum.TextXAlignment.Left
AutoStatus.TextSize = 12
AutoStatus.Font = Enum.Font.Gotham
AutoStatus.Parent = AutoBox

--==================================================
-- TOGGLE
--==================================================

local Toggle = Instance.new("TextButton")
Toggle.Position = UDim2.new(1, -60, 0.5, -13)
Toggle.Size = UDim2.new(0, 46, 0, 26)
Toggle.BackgroundColor3 = Color3.fromRGB(38, 48, 38)
Toggle.Text = ""
Toggle.AutoButtonColor = false
Toggle.BorderSizePixel = 0
Toggle.Parent = AutoBox

Toggle.MouseEnter:Connect(function()
    TweenService:Create(
        Toggle,
        TweenInfo.new(0.12),
        {Size = UDim2.new(0, 49, 0, 28)}
    ):Play()
end)

Toggle.MouseLeave:Connect(function()
    TweenService:Create(
        Toggle,
        TweenInfo.new(0.12),
        {Size = UDim2.new(0, 46, 0, 26)}
    ):Play()
end)

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = Toggle

local Knob = Instance.new("Frame")
Knob.Size = UDim2.new(0, 20, 0, 20)
Knob.Position = UDim2.new(0, 3, 0.5, -10)
Knob.BackgroundColor3 = Color3.fromRGB(220, 215, 230)
Knob.BorderSizePixel = 0
Knob.Parent = Toggle

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = Knob

--==================================================
-- STATISTICS
--==================================================

local Stats = Instance.new("Frame")
Stats.Position = UDim2.new(0, 0, 0, 76)
Stats.Size = UDim2.new(1, 0, 0, 92)
Stats.BackgroundTransparency = 1
Stats.Parent = Content

-- Total Codes
local TotalBox = Instance.new("Frame")
TotalBox.Size = UDim2.new(0.5, -5, 1, 0)
TotalBox.BackgroundColor3 = PANEL_LIGHT
TotalBox.BorderSizePixel = 0
TotalBox.Parent = Stats

local TotalCorner = Instance.new("UICorner")
TotalCorner.CornerRadius = UDim.new(0, 12)
TotalCorner.Parent = TotalBox

local TotalStroke = Instance.new("UIStroke")
TotalStroke.Color = Color3.fromRGB(45, 70, 30)
TotalStroke.Thickness = 1
TotalStroke.Transparency = 0
TotalStroke.Parent = TotalBox

local TotalTitle = Instance.new("TextLabel")
TotalTitle.Position = UDim2.new(0, 12, 0, 10)
TotalTitle.Size = UDim2.new(1, -24, 0, 18)
TotalTitle.BackgroundTransparency = 1
TotalTitle.Text = "TOTAL CODE"
TotalTitle.TextColor3 = GREY
TotalTitle.TextXAlignment = Enum.TextXAlignment.Left
TotalTitle.TextSize = 10
TotalTitle.Font = Enum.Font.GothamBold
TotalTitle.Parent = TotalBox

local TotalValue = Instance.new("TextLabel")
TotalValue.Position = UDim2.new(0, 12, 0, 28)
TotalValue.Size = UDim2.new(1, -24, 0, 35)
TotalValue.BackgroundTransparency = 1
TotalValue.Text = tostring(totalCodes)
TotalValue.TextColor3 = WHITE
TotalValue.TextXAlignment = Enum.TextXAlignment.Left
TotalValue.TextSize = 24
TotalValue.Font = Enum.Font.GothamBold
TotalValue.Parent = TotalBox

-- Success Codes
local SuccessBox = Instance.new("Frame")
SuccessBox.Position = UDim2.new(0.5, 5, 0, 0)
SuccessBox.Size = UDim2.new(0.5, -5, 1, 0)
SuccessBox.BackgroundColor3 = PANEL_LIGHT
SuccessBox.BorderSizePixel = 0
SuccessBox.Parent = Stats

local SuccessCorner = Instance.new("UICorner")
SuccessCorner.CornerRadius = UDim.new(0, 12)
SuccessCorner.Parent = SuccessBox

local SuccessStroke = Instance.new("UIStroke")
SuccessStroke.Color = Color3.fromRGB(45, 70, 30)
SuccessStroke.Thickness = 1
SuccessStroke.Transparency = 0
SuccessStroke.Parent = SuccessBox

local function addCardHover(card, stroke)
    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(18, 28, 19)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {
            Color = PURPLE,
            Transparency = 0.15
        }):Play()
    end)

    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {
            BackgroundColor3 = PANEL_LIGHT
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {
            Color = Color3.fromRGB(45, 70, 30),
            Transparency = 0
        }):Play()
    end)
end

addCardHover(TotalBox, TotalStroke)
addCardHover(SuccessBox, SuccessStroke)

local SuccessTitle = Instance.new("TextLabel")
SuccessTitle.Position = UDim2.new(0, 12, 0, 10)
SuccessTitle.Size = UDim2.new(1, -24, 0, 18)
SuccessTitle.BackgroundTransparency = 1
SuccessTitle.Text = "DIKIRIM"
SuccessTitle.TextColor3 = GREY
SuccessTitle.TextXAlignment = Enum.TextXAlignment.Left
SuccessTitle.TextSize = 10
SuccessTitle.Font = Enum.Font.GothamBold
SuccessTitle.Parent = SuccessBox

local SuccessValue = Instance.new("TextLabel")
SuccessValue.Position = UDim2.new(0, 12, 0, 28)
SuccessValue.Size = UDim2.new(1, -24, 0, 35)
SuccessValue.BackgroundTransparency = 1
SuccessValue.Text = "0"
SuccessValue.TextColor3 = GREEN
SuccessValue.TextXAlignment = Enum.TextXAlignment.Left
SuccessValue.TextSize = 24
SuccessValue.Font = Enum.Font.GothamBold
SuccessValue.Parent = SuccessBox

--==================================================
-- FOOTER STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Position = UDim2.new(0, 4, 0, 180)
Status.Size = UDim2.new(1, -8, 0, 22)
Status.BackgroundTransparency = 1
Status.Text = "●  AUTO REDEEM OFF"
Status.TextColor3 = RED
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.TextSize = 12
Status.Font = Enum.Font.GothamMedium
Status.Parent = Content

local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.Position = UDim2.new(0, 0, 0, 185)
StatusDot.Size = UDim2.new(0, 5, 0, 5)
StatusDot.BackgroundColor3 = RED
StatusDot.BorderSizePixel = 0
StatusDot.Parent = Content

local StatusDotCorner = Instance.new("UICorner")
StatusDotCorner.CornerRadius = UDim.new(1, 0)
StatusDotCorner.Parent = StatusDot

--==================================================
-- UPDATE UI
--==================================================

local function updateUI()
    TotalValue.Text = tostring(totalCodes)
    SuccessValue.Text = tostring(processedCount)

    if AutoRedeem then

        Status.Text = "●  AUTO REDEEM ON  •  Siap memproses kode"
        Status.TextColor3 = GREEN
        StatusDot.BackgroundColor3 = GREEN

        TweenService:Create(
            Toggle,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = PURPLE}
        ):Play()

        TweenService:Create(
            Knob,
            TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(1, -23, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }
        ):Play()

    else

        Status.Text = "●  AUTO REDEEM OFF"
        Status.TextColor3 = RED
        StatusDot.BackgroundColor3 = RED

        TweenService:Create(
            Toggle,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(38, 48, 38)}
        ):Play()

        TweenService:Create(
            Knob,
            TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(220, 215, 230)
            }
        ):Play()

    end
end

updateUI()

local Branding = Instance.new("TextLabel")
Branding.Name = "Branding"
Branding.Position = UDim2.new(0, 4, 1, -26)
Branding.Size = UDim2.new(1, -8, 0, 18)
Branding.BackgroundTransparency = 1
Branding.Text = "K5 HUB  •  NEON CODE SYSTEM"
Branding.TextColor3 = Color3.fromRGB(105, 145, 95)
Branding.TextXAlignment = Enum.TextXAlignment.Right
Branding.TextSize = 9
Branding.Font = Enum.Font.GothamBold
Branding.Parent = Content


--==================================================
-- OPEN / MINIMIZE
--==================================================

CloseButton.MouseButton1Click:Connect(function()
    minimizePanel()
end)

FloatingLogo.MouseButton1Click:Connect(function()
    restorePanel()
end)

--==================================================
-- NEON AMBIENT ANIMATION
--==================================================

task.spawn(function()
    while ScreenGui.Parent do
        TweenService:Create(
            MainAccent,
            TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundTransparency = 0.18}
        ):Play()
        TweenService:Create(
            HeaderLine,
            TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundTransparency = 0.65}
        ):Play()
        task.wait(1.1)

        TweenService:Create(
            MainAccent,
            TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundTransparency = 0}
        ):Play()
        TweenService:Create(
            HeaderLine,
            TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundTransparency = 0.3}
        ):Play()
        task.wait(1.1)
    end
end)

--==================================================
-- REDEEM
--==================================================

local function startRedeem()

    if IsRedeeming then
        return
    end

    IsRedeeming = true

    for index, code in ipairs(Codes) do

        if not AutoRedeem then
            break
        end

        if not claimedCodes[code] then

            print(("[K5-HUB] Redeeming [%d/%d]: %s")
                :format(index, totalCodes, code))

            CodeRE:FireServer({
                event = "usecode",
                code = code
            })

            -- Menandai code yang sudah dikirim
            claimedCodes[code] = true

            -- Menghitung code yang sudah dikirim ke server.
            -- Ini bukan konfirmasi bahwa server menerima/redeem berhasil.
            processedCount += 1

            updateUI()

            if index < totalCodes then
                task.wait(REDEEM_DELAY)
            end

        else

            print("[K5-HUB] Already claimed:", code)

        end
    end

    IsRedeeming = false

    print(("[K5-HUB] Redeem process finished: %d/%d code dikirim ke server"):format(processedCount, totalCodes))

end

--==================================================
-- TOGGLE BUTTON
--==================================================

Toggle.MouseButton1Click:Connect(function()

    AutoRedeem = not AutoRedeem

    updateUI()

    if AutoRedeem then
        task.spawn(startRedeem)
    else
        print("[K5-HUB] Auto Redeem OFF")
    end

end)
