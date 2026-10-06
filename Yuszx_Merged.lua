--[[
    ═══════════════════════════════════════════════════════════════
    YUSZX HUB - Iron Soul v13 CLEAN
    ═══════════════════════════════════════════════════════════════
    Tabs: Main | Map | Misc | Config
    Features:
    ✨ Intro Animation + Sound
    🎨 Aesthetic UI
    📌 Minimize / Close / Reopen
    🔄 Auto Execute on Teleport
    💾 Config Persistence
    🎁 Auto Claim Codes
    ═══════════════════════════════════════════════════════════════
]]

-- ============================================
-- SOUND
-- ============================================
local SOUND_INTRO = "rbxassetid://1837942721"
local SOUND_SUCCESS = "rbxassetid://9120386436"
local SOUND_CLICK = "rbxassetid://9120386429"
local LOGO_ASSET = "rbxassetid://115820469332666"

local function playSound(id, vol)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = vol or 0.5
        s.Parent = game:GetService("SoundService")
        s:Play()
        task.delay(3, function() s:Destroy() end)
    end)
end

-- ============================================
-- CONFIG MANAGER
-- ============================================
local HttpService = game:GetService("HttpService")
local Player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local CONFIG_FILE = "Yuszx_config_" .. Player.UserId .. ".json"

local DEFAULT_CONFIG = {
    AttackPos = "Behind",
    AutoHoldEgg = false, AutoHitEgg = false, AutoHitChest = false,
    AutoAttack = false, AutoSkill = {false, false, false, false, false},
    AutoLobbyWhenFull = false,
    DungeonMode = "Dungeon", SelectedMap = "Starless Island",
    HellMode = false, InfernoMode = false,
    AutoCreateParty = false, AutoInviteAll = false, WaitFullParty = true,
    AutoOpenDoors = true, AutoReplay = false, AutoLeaveDone = false,
    AutoBuyTickets = false, AutoClaimTower = true,
    WalkSpeed = 16, SpeedEnabled = false,
    AntiAFK = true, AutoReconnect = false, FPSBoost = false,
    SoundNotif = true, HidePlayers = false,
    AutoExecute = true,
    ClaimDelay = 5, ClaimedCodes = {},
    UIMinimized = false,
}

local Config = {}
local currentConfig = {}
for k, v in pairs(DEFAULT_CONFIG) do
    if type(v) == "table" then
        currentConfig[k] = {}
        for k2, v2 in pairs(v) do currentConfig[k][k2] = v2 end
    else currentConfig[k] = v end
end

function Config.load()
    if not readfile or not isfile then return end
    pcall(function()
        if isfile(CONFIG_FILE) then
            local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            for k, v in pairs(data) do currentConfig[k] = v end
        end
    end)
end

function Config.save()
    if not writefile then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(currentConfig))
    end)
end

function Config.get(k, d) return currentConfig[k] ~= nil and currentConfig[k] or d end
function Config.set(k, v) currentConfig[k] = v; Config.save() end

function Config.reset()
    for k, v in pairs(DEFAULT_CONFIG) do
        if type(v) == "table" then
            currentConfig[k] = {}
            for k2, v2 in pairs(v) do currentConfig[k][k2] = v2 end
        else currentConfig[k] = v end
    end
    Config.save()
end

Config.load()

-- ============================================
-- AUTO EXECUTE
-- ============================================
local SCRIPT_URL = "https://raw.githubusercontent.com/frilshiaputri-cmd/K5_Premium/main/Yuszx_Merged.lua"

local function enableAutoExec()
    if queue_on_teleport then
        pcall(function()
            queue_on_teleport([[
                task.wait(2)
                loadstring(game:HttpGet("]] .. SCRIPT_URL .. [["))()
            ]])
            return true
        end)
    end
    return false
end

if Config.get("AutoExecute", true) then enableAutoExec() end

-- ============================================
-- MAP DATA
-- ============================================
local MAP_DATA = {
    Dungeon = {
        { name = "Starless Island", desc = "Beginner", hell = false, inferno = false, party = 1 },
        { name = "Frozen Valley", desc = "Ice", hell = true, inferno = true, party = 2 },
        { name = "Oathless Castle", desc = "Castle", hell = true, inferno = false, party = 3 },
        { name = "Tartarus", desc = "Underworld", hell = true, inferno = false, party = 4 },
        { name = "Sakura Village", desc = "Map 5", hell = true, inferno = false, party = 4 },
    },
    Tower = {
        { name = "Endless Tower", desc = "Infinite", hell = false, inferno = false, party = 1 },
    },
    Cave = {
        { name = "Cave of Crystals", desc = "Crystals", tickets = true, party = 1 },
        { name = "Cave of Runes", desc = "Runes", tickets = true, party = 1 },
        { name = "Abandoned Courtyard", desc = "Dragon Scales", tickets = true, party = 1 },
    },
}

-- ============================================
-- REDEEM CODES (102)
-- ============================================
local REDEEM_CODES = {
    "runekify", "Dray28", "RIKUSOULS", "Ahjughh", "T3nsei",
    "Ghifa", "ALLWAONIRONSOUL", "Sukunay", "MERGIXS", "SIGURIH",
    "CA2", "Lulzsec", "druscxlla", "MAHAFEY", "LALAGANG",
    "Luthador2121", "AAM", "ToadPlaysGamesTTV", "Uzi", "TT_Mentally_ill_K.N",
    "luknojo", "Zeny", "Clipz7112", "PaPaX", "Ryu",
    "Chrisss", "Ryokenn", "DEI_Yumeko", "Gryffin", "ARKANGHEL",
    "tony_vt", "ReyPomuchi", "Freca", "Shan", "TT_oratttt",
    "Lifauzi", "Ewaa", "FRanime_OFFICIEL", "Maple", "Fujiesane",
    "VeeruChan", "HELOS", "LezoCr", "ARES", "Laplace",
    "Deco", "dasher", "Nyxaria", "ProfGab", "SUB2BLAZESTARS",
    "Nothing", "Dism", "FannTzy", "Darkfeniks", "Sneptuno",
    "SUPER MBUD", "Marcell", "Markbhatra", "DrekathSenpai", "Maniaco_666",
    "Kiota2", "WerNate", "Ascart", "Sweetiee24", "Monarch",
    "Aetherix", "SUB2MULTIST789", "Heso", "RENZEI100", "Skywinter86",
    "Ghelayyy", "Heartguard", "RaykorBR", "ZARGAKSTONE", "aldoDM",
    "Kurt", "7Ds_Fangku", "scarletditadora", "Kuyabing", "smiley",
    "Sine", "GT_HANNI", "Erijero", "DanoNano", "WettySNK",
    "Astral", "obe", "Dekday", "Qyuu", "Qwynne",
    "PapiJoy", "Taalonely", "Darren", "MADUNN", "LZZ_019BEST",
    "NisardHelpOnlyWoman", "Staysmoovey", "Les", "Bebek", "PepCalcot",
    "Shirooo0312_IRONSOUL", "omjiwa"
}

-- ============================================
-- TRACKER
-- ============================================
local Tracker = {
    PartySize = 0, StartTime = tick(),
    EggsCollected = 0, ChestsCollected = 0, MobsKilled = 0,
    DungeonRuns = 0, HellRuns = 0, InfernoRuns = 0,
    TowerFloor = 0, TowerBest = 0, SeasonVouchers = 0,
    CaveTickets = 0, CaveRuns = 0,
}

-- ============================================
-- HELPERS
-- ============================================
local function getElapsed()
    local e = tick() - Tracker.StartTime
    local m = math.floor(e / 60)
    return string.format("%dm %ds", m, math.floor(e % 60))
end

local function getCurrentMap()
    local mode = Config.get("DungeonMode", "Dungeon")
    for _, m in ipairs(MAP_DATA[mode] or {}) do
        if m.name == Config.get("SelectedMap", "") then return m end
    end
    return nil
end

local function findCodeRemote()
    local RS = game:GetService("ReplicatedStorage")
    local ok, r = pcall(function()
        return RS:WaitForChild("Framework", 5):WaitForChild("Systems", 5)
            :WaitForChild("CodeSystem", 5):WaitForChild("CodeRE", 5)
    end)
    if ok and r then return r end
    for _, obj in ipairs(RS:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local n = string.lower(obj.Name)
            if string.find(n, "codere") or string.find(n, "redeem") then return obj end
        end
    end
    return nil
end

-- ============================================
-- INTRO ANIMATION
-- ============================================
local function playIntro()
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    local intro = Instance.new("ScreenGui")
    intro.Name = "YuszxIntro"
    intro.Parent = parent
    intro.IgnoreGuiInset = true
    intro.DisplayOrder = 999999
    intro.ResetOnSpawn = false
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BorderSizePixel = 0
    bg.Parent = intro
    
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 0, 0, 100)
    panel.Position = UDim2.new(0.5, 0, 0.5, -50)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
    panel.BorderSizePixel = 0
    panel.Parent = intro
    
    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 12)
    pc.Parent = panel
    
    local ps = Instance.new("UIStroke")
    ps.Color = Color3.fromRGB(0, 200, 255)
    ps.Thickness = 2
    ps.Transparency = 0.3
    ps.Parent = panel
    
    local pg = Instance.new("UIGradient")
    pg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 50, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255)),
    })
    pg.Parent = ps
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "YUSZX HUB"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 42
    title.Font = Enum.Font.GothamBold
    title.TextStrokeTransparency = 0
    title.TextStrokeColor3 = Color3.fromRGB(0, 100, 200)
    title.TextTransparency = 1
    title.Parent = panel
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 25)
    subtitle.Position = UDim2.new(0, 0, 0, 65)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "> Initializing..."
    subtitle.TextColor3 = Color3.fromRGB(150, 200, 255)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Code
    subtitle.TextTransparency = 1
    subtitle.Parent = panel
    
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -40, 0, 4)
    barBg.Position = UDim2.new(0, 20, 1, -15)
    barBg.BackgroundColor3 = Color3.fromRGB(0, 30, 60)
    barBg.BorderSizePixel = 0
    barBg.BackgroundTransparency = 1
    barBg.Parent = panel
    
    local bbc = Instance.new("UICorner")
    bbc.CornerRadius = UDim.new(0, 2)
    bbc.Parent = barBg
    
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg
    
    local bfc = Instance.new("UICorner")
    bfc.CornerRadius = UDim.new(0, 2)
    bfc.Parent = barFill
    
    local bgG = Instance.new("UIGradient")
    bgG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 50, 255)),
    })
    bgG.Parent = barFill
    
    playSound(SOUND_INTRO, 0.6)
    
    local TS = game:GetService("TweenService")
    TS:Create(panel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 100)
    }):Play()
    
    task.wait(0.3)
    TS:Create(title, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
    task.wait(0.15)
    TS:Create(subtitle, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
    task.wait(0.15)
    TS:Create(barBg, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()
    
    local steps = {"Connecting...", "Loading...", "Injecting...", "Ready!"}
    for i, step in ipairs(steps) do
        subtitle.Text = "> " .. step
        TS:Create(barFill, TweenInfo.new(0.4), {
            Size = UDim2.new(i / #steps, 0, 1, 0)
        }):Play()
        playSound(SOUND_CLICK, 0.3)
        task.wait(0.5)
    end
    
    local glitchChars = {"#", "@", "!", "%", "&", "*", "?", "~"}
    local original = "YUSZX HUB"
    local startT = tick()
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if tick() - startT > 0.5 then
            title.Text = original
            title.TextColor3 = Color3.fromRGB(0, 200, 255)
            conn:Disconnect()
            return
        end
        local g = ""
        for j = 1, #original do
            g = g .. (math.random() > 0.5 and glitchChars[math.random(#glitchChars)] or original:sub(j, j))
        end
        title.Text = g
        title.TextColor3 = Color3.fromRGB(math.random(0, 100), 200, 255)
    end)
    
    task.wait(0.7)
    
    for _, obj in ipairs({bg, panel}) do
        TS:Create(obj, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    end
    TS:Create(ps, TweenInfo.new(0.4), { Transparency = 1 }):Play()
    TS:Create(title, TweenInfo.new(0.4), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
    TS:Create(subtitle, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
    TS:Create(barBg, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    TS:Create(barFill, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    
    task.wait(0.5)
    intro:Destroy()
end

playIntro()

-- ============================================
-- UI
-- Compact K5-HUB UI based on the supplied reference.
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "K5-HUB"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 998
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 430, 0, 300)
MainFrame.Position = UDim2.new(0.5, -215, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(175, 75, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.15
UIStroke.Parent = MainFrame

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 35, 170)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 35, 170)),
})
strokeGradient.Parent = UIStroke

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
TopBar.BorderSizePixel = 0
TopBar.Active = true
TopBar.Parent = MainFrame

local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 12)
tbc.Parent = TopBar

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 7, 0, 4)
Logo.BackgroundTransparency = 1
Logo.Image = LOGO_ASSET
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -105, 1, 0)
Title.Position = UDim2.new(0, 43, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "K5-HUB"
Title.TextColor3 = Color3.fromRGB(240, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 28, 0, 26)
MinButton.Position = UDim2.new(1, -63, 0, 6)
MinButton.BackgroundColor3 = Color3.fromRGB(55, 30, 75)
MinButton.Text = "—"
MinButton.TextColor3 = Color3.fromRGB(225, 180, 255)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 15
MinButton.BorderSizePixel = 0
MinButton.AutoButtonColor = false
MinButton.Parent = TopBar

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 7)
mc.Parent = MinButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 26)
CloseButton.Position = UDim2.new(1, -32, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(80, 25, 48)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 175, 200)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.BorderSizePixel = 0
CloseButton.AutoButtonColor = false
CloseButton.Parent = TopBar

local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 7)
cc.Parent = CloseButton

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 30)
TabBar.Position = UDim2.new(0, 8, 0, 46)
TabBar.BackgroundColor3 = Color3.fromRGB(16, 11, 24)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local tbarc = Instance.new("UICorner")
tbarc.CornerRadius = UDim.new(0, 7)
tbarc.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 3)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 3)
TabPadding.PaddingRight = UDim.new(0, 3)
TabPadding.PaddingTop = UDim.new(0, 2)
TabPadding.Parent = TabBar

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -16, 1, -116)
ContentFrame.Position = UDim2.new(0, 8, 0, 82)
ContentFrame.BackgroundColor3 = Color3.fromRGB(11, 8, 18)
ContentFrame.BackgroundTransparency = 0.15
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 3
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(190, 75, 255)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 7)
ContentCorner.Parent = ContentFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 4)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentFrame

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 6)
ContentPadding.PaddingLeft = UDim.new(0, 7)
ContentPadding.PaddingRight = UDim.new(0, 7)
ContentPadding.PaddingBottom = UDim.new(0, 7)
ContentPadding.Parent = ContentFrame

local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -16, 0, 22)
StatusBar.Position = UDim2.new(0, 8, 1, -28)
StatusBar.BackgroundTransparency = 1
StatusBar.Text = "● Ready"
StatusBar.TextColor3 = Color3.fromRGB(190, 120, 255)
StatusBar.Font = Enum.Font.GothamMedium
StatusBar.TextSize = 10
StatusBar.TextXAlignment = Enum.TextXAlignment.Left
StatusBar.Parent = MainFrame

local ReopenButton = Instance.new("ImageButton")
ReopenButton.Size = UDim2.new(0, 52, 0, 52)
ReopenButton.Position = UDim2.new(0, 18, 0.5, -26)
ReopenButton.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
ReopenButton.Image = LOGO_ASSET
ReopenButton.ScaleType = Enum.ScaleType.Fit
ReopenButton.BorderSizePixel = 0
ReopenButton.Active = true
ReopenButton.Visible = false
ReopenButton.Parent = ScreenGui

local rc = Instance.new("UICorner")
rc.CornerRadius = UDim.new(0, 14)
rc.Parent = ReopenButton

local rs = Instance.new("UIStroke")
rs.Color = Color3.fromRGB(190, 70, 255)
rs.Thickness = 2
rs.Transparency = 0.15
rs.Parent = ReopenButton

local function makeDraggable(handle, target)
    local dragging = false
    local dragStart
    local startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end)
end

makeDraggable(TopBar, MainFrame)
makeDraggable(ReopenButton, ReopenButton)

-- ============================================
-- ============================================
-- UI HELPERS
-- ============================================
local function createSection(title)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 24)
    sec.BackgroundTransparency = 1
    sec.Text = "▸ " .. title
    sec.TextColor3 = Color3.fromRGB(0, 200, 255)
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 12
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = ContentFrame
end

local function createToggle(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    frame.BorderSizePixel = 0
    frame.Parent = ContentFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = frame
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 150, 255)
    s.Thickness = 1
    s.Transparency = 0.7
    s.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 230, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 55, 0, 22)
    btn.Position = UDim2.new(1, -65, 0, 6)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(40, 40, 60)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = frame
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 11)
    bc.Parent = btn
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(40, 40, 60)
        if Config.get("SoundNotif", true) then playSound(SOUND_CLICK, 0.2) end
        if callback then callback(state) end
    end)
end

local function createButton(name, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = color or Color3.fromRGB(25, 60, 110)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = ContentFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 150, 255)
    s.Thickness = 1
    s.Transparency = 0.5
    s.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if Config.get("SoundNotif", true) then playSound(SOUND_CLICK, 0.2) end
        if callback then callback() end
    end)
end

local function createDropdown(name, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    frame.BorderSizePixel = 0
    frame.Parent = ContentFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = frame
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 150, 255)
    s.Thickness = 1
    s.Transparency = 0.7
    s.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 14, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(0, 200, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local display = Instance.new("TextButton")
    display.Size = UDim2.new(1, -20, 0, 26)
    display.Position = UDim2.new(0, 10, 0, 28)
    display.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
    display.Text = default
    display.TextColor3 = Color3.fromRGB(200, 220, 255)
    display.Font = Enum.Font.GothamMedium
    display.TextSize = 11
    display.BorderSizePixel = 0
    display.AutoButtonColor = false
    display.Parent = frame
    
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(0, 6)
    dc.Parent = display
    
    local idx = 1
    for i, opt in ipairs(options) do
        if opt == default then idx = i break end
    end
    
    display.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        display.Text = options[idx]
        if Config.get("SoundNotif", true) then playSound(SOUND_CLICK, 0.2) end
        if callback then callback(options[idx]) end
    end)
end

local function createInfoBox(lines, color)
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0, 20 * #lines + 16)
    info.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    info.Text = table.concat(lines, "\n")
    info.TextColor3 = color or Color3.fromRGB(0, 200, 255)
    info.Font = Enum.Font.GothamMedium
    info.TextSize = 11
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.Parent = ContentFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = info
    
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(0, 200, 255)
    s.Thickness = 1
    s.Transparency = 0.7
    s.Parent = info
end

local function createInput(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    frame.BorderSizePixel = 0
    frame.Parent = ContentFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = frame
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 150, 255)
    s.Thickness = 1
    s.Transparency = 0.7
    s.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -110, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 230, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 80, 0, 22)
    box.Position = UDim2.new(1, -90, 0, 6)
    box.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
    box.Text = tostring(default)
    box.TextColor3 = Color3.fromRGB(0, 200, 255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Parent = frame
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = box
    
    box.FocusLost:Connect(function()
        if callback then callback(box.Text) end
    end)
end

-- ============================================
-- TAB SYSTEM
-- ============================================
local tabButtons = {}

local function clearContent()
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

local function updateCanvas()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end

local function createTab(name, icon, buildFunction)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 132, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(150, 180, 220)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = TabBar
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
            b.TextColor3 = Color3.fromRGB(150, 180, 220)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        if Config.get("SoundNotif", true) then playSound(SOUND_CLICK, 0.2) end
        
        clearContent()
        buildFunction()
        task.wait(0.05)
        updateCanvas()
    end)
    
    table.insert(tabButtons, btn)
    return btn
end

-- ============================================
-- TAB 1: MAIN
-- ============================================
createTab("Main", "⚔️", function()
    createSection("Attack Position")
    createDropdown("Attack From", {"Under", "Behind", "Above"},
        Config.get("AttackPos", "Behind"),
        function(v) Config.set("AttackPos", v) end)
    
    createSection("🥚 Egg Handler")
    createToggle("Auto Hold Egg", Config.get("AutoHoldEgg", false),
        function(s) Config.set("AutoHoldEgg", s) end)
    createToggle("Auto Hit Egg", Config.get("AutoHitEgg", false),
        function(s) Config.set("AutoHitEgg", s) end)
    
    createSection("📦 Chest Handler")
    createToggle("Auto Hit Chest", Config.get("AutoHitChest", false),
        function(s) Config.set("AutoHitChest", s) end)
    
    createSection("⚔️ Combat")
    createToggle("Auto Attack", Config.get("AutoAttack", false),
        function(s) Config.set("AutoAttack", s) end)
    
    local skills = Config.get("AutoSkill", {false, false, false, false, false})
    for i = 1, 5 do
        createToggle("Auto Skill " .. i, skills[i], function(s)
            skills[i] = s
            Config.set("AutoSkill", skills)
        end)
    end
    
    createSection("🎒 Inventory")
    createToggle("Auto Lobby When Full", Config.get("AutoLobbyWhenFull", false),
        function(s) Config.set("AutoLobbyWhenFull", s) end)
    
    createSection("Session Stats")
    local stats = Instance.new("TextLabel")
    stats.Name = "MainStats"
    stats.Size = UDim2.new(1, 0, 0, 80)
    stats.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    stats.Text = string.format(
        "🥚 Eggs: %d | 📦 Chests: %d\n⚔️ Kills: %d\n⏱️ Session: %s",
        Tracker.EggsCollected, Tracker.ChestsCollected, Tracker.MobsKilled, getElapsed())
    stats.TextColor3 = Color3.fromRGB(150, 180, 220)
    stats.Font = Enum.Font.GothamMedium
    stats.TextSize = 11
    stats.TextXAlignment = Enum.TextXAlignment.Left
    stats.TextYAlignment = Enum.TextYAlignment.Top
    stats.Parent = ContentFrame
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 8)
    sc.Parent = stats
end)

-- ============================================
-- TAB 2: MAP
-- ============================================
createTab("Map", "🗺️", function()
    local mode = Config.get("DungeonMode", "Dungeon")
    
    createSection("Mode Selection")
    createDropdown("Mode", {"Dungeon", "Tower", "Cave"}, mode, function(v)
        Config.set("DungeonMode", v)
        for _, b in ipairs(tabButtons) do
            if string.find(b.Text, "Map") then b.MouseButton1Click:Fire() end
        end
    end)
    
    local mapList = {}
    for _, map in ipairs(MAP_DATA[mode] or {}) do table.insert(mapList, map.name) end
    
    createSection("Map Selection")
    createDropdown("Select Map", mapList, Config.get("SelectedMap", mapList[1] or ""), function(v)
        Config.set("SelectedMap", v)
        for _, b in ipairs(tabButtons) do
            if string.find(b.Text, "Map") then b.MouseButton1Click:Fire() end
        end
    end)
    
    local map = getCurrentMap()
    if map then
        createSection("Map Info")
        if mode == "Cave" then
            createInfoBox({
                "🕳️ " .. map.name .. " — " .. map.desc,
                "🎫 Butuh Cave Tickets (dari Daily Quest)",
                "👥 Solo: " .. map.party .. " player",
            }, Color3.fromRGB(150, 200, 255))
        else
            createInfoBox({
                "🗺️ " .. map.name .. " — " .. map.desc,
                "👥 Party: " .. map.party .. " player",
                "🔥 Hell: " .. (map.hell and "✅ Tersedia" or "❌ Tidak ada"),
                "💀 Inferno: " .. (map.inferno and "✅ Tersedia" or "❌ Tidak ada"),
            }, Color3.fromRGB(0, 200, 255))
        end
    end
    
    if mode == "Dungeon" and map and map.hell then
        createSection("Difficulty")
        createToggle("Hell Mode", Config.get("HellMode", false),
            function(s) Config.set("HellMode", s) end)
        if map.inferno then
            createToggle("Inferno Mode", Config.get("InfernoMode", false),
                function(s) Config.set("InfernoMode", s) end)
        end
    end
    
    if mode ~= "Cave" and map and map.party > 1 then
        createSection("Party System")
        createToggle("Auto Create Party", Config.get("AutoCreateParty", false),
            function(s) Config.set("AutoCreateParty", s) end)
        createToggle("Auto Invite All Server", Config.get("AutoInviteAll", false),
            function(s) Config.set("AutoInviteAll", s) end)
        createToggle("Wait Until Full", Config.get("WaitFullParty", true),
            function(s) Config.set("WaitFullParty", s) end)
        createInfoBox({
            "👥 Party: " .. Tracker.PartySize .. "/" .. map.party,
            "💡 Butuh " .. map.party .. " player",
        }, Color3.fromRGB(255, 220, 100))
    end
    
    if mode == "Tower" then
        createSection("Tower Progress")
        createInfoBox({
            "🏆 Floor: " .. Tracker.TowerFloor .. " | Best: " .. Tracker.TowerBest,
            "🎟️ Season Vouchers: " .. Tracker.SeasonVouchers,
        }, Color3.fromRGB(255, 220, 100))
    end
    
    if mode == "Cave" then
        createSection("Cave Tickets")
        createInfoBox({
            "🎫 Tickets: " .. Tracker.CaveTickets,
            "💡 Dapet dari Daily Quest",
        }, Color3.fromRGB(100, 200, 255))
    end
    
    createSection("Automation")
    createToggle("Auto Open Doors", Config.get("AutoOpenDoors", true),
        function(s) Config.set("AutoOpenDoors", s) end)
    createToggle("Auto Replay", Config.get("AutoReplay", false),
        function(s) Config.set("AutoReplay", s) end)
    createToggle("Auto Leave When Done", Config.get("AutoLeaveDone", false),
        function(s) Config.set("AutoLeaveDone", s) end)
end)

-- ============================================
-- TAB 3: MISC (Speed + Codes + Utility)
-- ============================================
local claimState = { isClaiming = false, sent = 0, success = 0, failed = 0 }

createTab("Misc", "🎮", function()
    createSection("Speed Control")
    createToggle("Speed Enabled", Config.get("SpeedEnabled", false), function(s)
        Config.set("SpeedEnabled", s)
        if s and Player.Character then
            local hum = Player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Config.get("WalkSpeed", 16) end
        end
    end)
    createInput("WalkSpeed (1-500)", Config.get("WalkSpeed", 16), function(v)
        local n = tonumber(v)
        if n and n >= 1 and n <= 500 then
            Config.set("WalkSpeed", n)
            if Config.get("SpeedEnabled", false) and Player.Character then
                local hum = Player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = n end
            end
        end
    end)
    
    createSection("🎁 Auto Claim Codes")
    local claimedList = Config.get("ClaimedCodes", {})
    local claimCount = 0
    for _ in pairs(claimedList) do claimCount = claimCount + 1 end
    createInfoBox({
        "📦 Total: " .. #REDEEM_CODES .. " | ✅ Claimed: " .. claimCount,
        "⏳ Pending: " .. (#REDEEM_CODES - claimCount),
    }, Color3.fromRGB(0, 200, 255))
    
    createInput("Delay (detik)", Config.get("ClaimDelay", 5), function(v)
        local n = tonumber(v)
        if n and n >= 1 then Config.set("ClaimDelay", n) end
    end)
    
    createButton("🚀 CLAIM ALL CODES", function()
        if claimState.isClaiming then
            StatusBar.Text = "⏳ Sedang claiming..."
            return
        end
        claimState.isClaiming = true
        claimState.sent = 0; claimState.success = 0; claimState.failed = 0
        
        task.spawn(function()
            local remote = findCodeRemote()
            if not remote then
                StatusBar.Text = "❌ Remote gak ketemu!"
                StatusBar.TextColor3 = Color3.fromRGB(255, 50, 50)
                claimState.isClaiming = false
                return
            end
            
            StatusBar.Text = "🚀 Mulai claim " .. #REDEEM_CODES .. " kode..."
            StatusBar.TextColor3 = Color3.fromRGB(0, 200, 255)
            local delay = Config.get("ClaimDelay", 5)
            
            for i, code in ipairs(REDEEM_CODES) do
                if not claimState.isClaiming then break end
                pcall(function()
                    remote:FireServer({ event = "usecode", code = code })
                end)
                claimState.sent = claimState.sent + 1
                StatusBar.Text = string.format("🎁 [%d/%d] %s", claimState.sent, #REDEEM_CODES, code)
                task.wait(delay)
            end
            
            StatusBar.Text = "✅ Done! Sent: " .. claimState.sent
            StatusBar.TextColor3 = Color3.fromRGB(0, 255, 100)
            if Config.get("SoundNotif", true) then playSound(SOUND_SUCCESS, 0.6) end
            claimState.isClaiming = false
        end)
    end, Color3.fromRGB(0, 120, 200))
    
    createButton("⛔ STOP CLAIM", function()
        claimState.isClaiming = false
        StatusBar.Text = "⛔ Claim dihentikan"
        StatusBar.TextColor3 = Color3.fromRGB(255, 100, 100)
    end, Color3.fromRGB(100, 25, 30))
    
    createButton("📋 Copy All Codes", function()
        if setclipboard then
            setclipboard(table.concat(REDEEM_CODES, "\n"))
            StatusBar.Text = "📋 Copied!"
            StatusBar.TextColor3 = Color3.fromRGB(0, 255, 100)
        end
    end, Color3.fromRGB(50, 50, 100))
    
    createSection("Utility")
    createToggle("Anti-AFK", Config.get("AntiAFK", true),
        function(s) Config.set("AntiAFK", s) end)
    createToggle("Auto Reconnect", Config.get("AutoReconnect", false),
        function(s) Config.set("AutoReconnect", s) end)
    createToggle("FPS Boost", Config.get("FPSBoost", false),
        function(s) Config.set("FPSBoost", s) end)
    createToggle("Sound Notification", Config.get("SoundNotif", true),
        function(s) Config.set("SoundNotif", s) end)
    createToggle("Hide Other Players", Config.get("HidePlayers", false),
        function(s) Config.set("HidePlayers", s) end)
    
    createSection("Server")
    createButton("🌐 Server Hop (Low Pop)", function()
        StatusBar.Text = "🌐 Mencari server sepi..."
    end)
    createButton("🔁 Rejoin Server", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end)
end)

-- ============================================
-- TAB 4: CONFIG
-- ============================================
-- ============================================================
-- IRONSOUL V61.11 ADVANCED ENGINE BRIDGE
-- Uses the proven modular engine from ironsoulkaitun-main.
-- The original hub UI remains intact; this bridge starts the
-- advanced engine and maps the compatible settings.
-- ============================================================
local ADVANCED_ENGINE_BASE = "https://raw.githubusercontent.com/frilshiaputri-cmd/K5_Premium/main/"

local function launchAdvancedEngine()
    local env = getgenv()
    env["K5-HUBConfig"] = env["K5-HUBConfig"] or {}
    env["K5-HUBConfig"].FPS_CAP = Config.get("FPSBoost", false) and 8 or 60
    env["K5-HUBConfig"].FARM = Config.get("SelectedMap", "Starless Island")
    env["K5-HUBConfig"].TICKETS = "SMART"
    env["K5-HUBConfig"].HEADLESS = false
    env["K5-HUBConfig"].CAVE_AUTO = Config.get("DungeonMode", "Dungeon") == "Cave"
    env["K5-HUBConfig"].HELL_AUTO = Config.get("HellMode", false) or Config.get("InfernoMode", false)
    env["K5-HUBConfig"].SHOP_AUTO = false
    env["K5-HUBConfig"].DEBUG_LOGS = false

    local url = tostring(env.K5-HUBEngineBase or ADVANCED_ENGINE_BASE) .. "bootstrap_v61_11.lua?hub=1&t=" .. tostring(os.time())
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then
        warn("[K5-HUB] Advanced engine failed: " .. tostring(err))
        pcall(function() StarterGui:SetCore("SendNotification", {
            Title = "K5-HUB V61.11", Text = "Engine gagal dijalankan: " .. tostring(err), Duration = 5
        }) end)
    end
end

createTab("Advanced", "⚙️", function()
    createSection("V61.11 Advanced Engine")
    createInfoBox({
        "Memakai engine modular dari ironsoulkaitun-main.",
        "Combat / Skill / Cave / Dungeon / Transition / Lobby",
        "tetap berasal dari modul V61.11.",
    })
    createButton("🚀 START V61.11 ENGINE", launchAdvancedEngine)
    createButton("📌 LOAD ORIGINAL HUB ENGINE", function()
        pcall(function()
            loadstring(game:HttpGet(ADVANCED_ENGINE_BASE .. "bootstrap.lua?hub=1&t=" .. tostring(os.time())))()
        end)
    end)
end)

createTab("Config", "💾", function()
    createSection("Auto Execute")
    createToggle("Auto Execute on Teleport", Config.get("AutoExecute", true), function(s)
        Config.set("AutoExecute", s)
        if s then enableAutoExec() end
    end)
    createInfoBox({
        "🔄 Script auto-execute di place baru",
        "📌 Support: Delta, Codex, Fluxus",
        "🎮 Cocok buat dungeon (pindah place)",
    }, Color3.fromRGB(0, 200, 255))
    
    createSection("Config File")
    createInfoBox({
        "📁 File: " .. CONFIG_FILE,
        "👤 Akun: " .. Player.Name .. " (ID: " .. Player.UserId .. ")",
        "💾 File tersimpan di folder executor",
    }, Color3.fromRGB(150, 200, 255))
    
    createSection("Actions")
    createButton("💾 Save Config Now", function()
        Config.save()
        StatusBar.Text = "💾 Config saved!"
        StatusBar.TextColor3 = Color3.fromRGB(0, 255, 100)
        if Config.get("SoundNotif", true) then playSound(SOUND_SUCCESS, 0.5) end
    end, Color3.fromRGB(20, 100, 70))
    
    createButton("🔄 Reset All Config", function()
        Config.reset()
        StatusBar.Text = "🔄 Config direset! Restart script."
        StatusBar.TextColor3 = Color3.fromRGB(255, 200, 0)
    end, Color3.fromRGB(100, 50, 15))
    
    createButton("📂 Show Config Content", function()
        if readfile and isfile and isfile(CONFIG_FILE) then
            warn("=== CONFIG CONTENT ===")
            warn(readfile(CONFIG_FILE))
            warn("======================")
            StatusBar.Text = "📂 Cek console output"
        else
            StatusBar.Text = "❌ Config file gak ada"
        end
    end, Color3.fromRGB(40, 60, 100))
    
    createSection("Session Info")
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0, 90)
    info.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    info.Text = string.format(
        "👤 %s (ID: %d)\n⏱️ Session: %s\n🎮 Place ID: %d\n📊 Tabs: Main | Map | Misc | Config",
        Player.Name, Player.UserId, getElapsed(), game.PlaceId)
    info.TextColor3 = Color3.fromRGB(150, 180, 220)
    info.Font = Enum.Font.GothamMedium
    info.TextSize = 11
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.Parent = ContentFrame
    
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 8)
    ic.Parent = info
end)

-- ============================================
-- TAB HANDLER
-- ============================================
tabButtons[1].BackgroundColor3 = Color3.fromRGB(0, 100, 180)
tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
clearContent()
tabButtons[1].MouseButton1Click:Fire()

-- ============================================
-- MINIMIZE / CLOSE
local function showLogo()
    MainFrame.Visible = false
    ReopenButton.Visible = true
end

local function showHub()
    MainFrame.Visible = true
    ReopenButton.Visible = false
end

MinButton.MouseButton1Click:Connect(function()
    showLogo()
    Config.set("UIMinimized", true)
    if Config.get("SoundNotif", true) then playSound(SOUND_CLICK, 0.2) end
end)

CloseButton.MouseButton1Click:Connect(function()
    showLogo()
    Config.set("UIMinimized", true)
    if Config.get("SoundNotif", true) then playSound(SOUND_CLICK, 0.2) end
end)

ReopenButton.MouseButton1Click:Connect(function()
    showHub()
    Config.set("UIMinimized", false)
    if Config.get("SoundNotif", true) then playSound(SOUND_SUCCESS, 0.3) end
end)

if Config.get("UIMinimized", false) then showLogo() end

-- ============================================
-- ============================================
-- AUTO-APPLY SPEED ON RESPAWN
-- ============================================
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Config.get("SpeedEnabled", false) then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Config.get("WalkSpeed", 16) end
    end
end)

-- ============================================
-- ANTI-AFK
-- ============================================
task.spawn(function()
    while true do
        task.wait(60)
        if Config.get("AntiAFK", true) then
            pcall(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0))
            end)
        end
    end
end)

-- ============================================
-- AUTO OPEN DOORS
-- ============================================
task.spawn(function()
    while true do
        task.wait(1)
        if Config.get("AutoOpenDoors", true) then
            pcall(function()
                local char = Player.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local parent = obj.Parent
                        if parent and parent:IsA("BasePart") then
                            local dist = (parent.Position - root.Position).Magnitude
                            if dist < 20 and fireproximityprompt then
                                fireproximityprompt(obj)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================
-- PARTY DETECTOR
-- ============================================
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            Tracker.PartySize = math.min(#game:GetService("Players"):GetPlayers(), 4)
        end)
    end
end)

-- ============================================
-- INIT
-- ============================================
print("[Yuszx] ═══════════════════════════════════")
print("[Yuszx] Iron Soul v13 CLEAN loaded!")
print("[Yuszx] User: " .. Player.Name .. " (ID: " .. Player.UserId .. ")")
print("[Yuszx] Tabs: Main | Map | Misc | Config")
print("[Yuszx] Config: " .. CONFIG_FILE)
print("[Yuszx] Auto Execute: " .. (Config.get("AutoExecute", true) and "ON" or "OFF"))
print("[Yuszx] ═══════════════════════════════════")