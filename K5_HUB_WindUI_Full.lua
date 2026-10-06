-- K5-HUB WindUI Full
-- Compact WindUI frontend + K5 configuration + V61.11 engine bridge.
-- Main engine: https://raw.githubusercontent.com/frilshiaputri-cmd/K5_Premium/main/Yuszx_Merged.lua

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Player = Players.LocalPlayer

local BASE = "https://raw.githubusercontent.com/frilshiaputri-cmd/K5_Premium/main/"
local ENGINE = BASE .. "bootstrap_v61_11.lua"
local ORIGINAL = BASE .. "Yuszx_Merged.lua"
local WINDUI = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
local LOGO = "rbxassetid://115820469332666"
local CONFIG_FILE = "K5_HUB_WindUI_" .. Player.UserId .. ".json"

local DEFAULT = {
    AttackPos = "Behind",
    AutoHoldEgg = false, AutoHitEgg = false, AutoHitChest = false,
    AutoAttack = false, AutoSkill1 = false, AutoSkill2 = false,
    AutoSkill3 = false, AutoSkill4 = false, AutoSkill5 = false,
    AutoLobbyWhenFull = false,
    DungeonMode = "Dungeon", SelectedMap = "Starless Island",
    HellMode = false, InfernoMode = false,
    AutoCreateParty = false, AutoInviteAll = false, WaitFullParty = true,
    AutoOpenDoors = true, AutoReplay = false, AutoLeaveDone = false,
    SpeedEnabled = false, WalkSpeed = 16,
    AntiAFK = true, AutoReconnect = false, FPSBoost = false,
    SoundNotif = true, HidePlayers = false, AutoExecute = true,
    ClaimDelay = 5
}

local Config = {}
for k,v in pairs(DEFAULT) do Config[k] = v end

local function save()
    if writefile then
        pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(Config)) end)
    end
end
local function load()
    if readfile and isfile and isfile(CONFIG_FILE) then
        pcall(function()
            local t = HttpService:JSONDecode(readfile(CONFIG_FILE))
            for k,v in pairs(t) do Config[k] = v end
        end)
    end
end
load()

local function notify(WindUI, title, content)
    pcall(function()
        WindUI:Notify({Title = title or "K5-HUB", Content = content or "", Duration = 3})
    end)
end

local function runUrl(url)
    local ok, result = pcall(function()
        local src = game:HttpGet(url .. (string.find(url,"?",1,true) and "&" or "?") .. "t=" .. os.time())
        local fn, err = loadstring(src)
        assert(fn, err)
        return fn()
    end)
    return ok, result
end

local function setSpeed()
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and Config.SpeedEnabled then hum.WalkSpeed = Config.WalkSpeed end
end

local function antiAfkLoop()
    task.spawn(function()
        while task.wait(60) do
            if Config.AntiAFK then
                pcall(function()
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                end)
            end
        end
    end)
end
antiAfkLoop()
Player.CharacterAdded:Connect(function() task.wait(1); setSpeed() end)

local ok, WindUI = pcall(function()
    return loadstring(game:HttpGet(WINDUI))()
end)
if not ok or not WindUI then
    warn("[K5-HUB] WindUI failed: " .. tostring(WindUI))
    return
end

local Window = WindUI:CreateWindow({
    Title = "K5-HUB",
    Icon = LOGO,
    Author = "Premium",
    Folder = "K5-HUB",
    Size = UDim2.fromOffset(470, 330),
    MinSize = Vector2.new(430, 285),
    MaxSize = Vector2.new(620, 450),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 145,
    HasOutline = true,
    Topbar = {
        Height = 42,
        Buttons = {"Close", "Minimize"}
    }
})

pcall(function()
    Window:EditOpenButton({
        Title = "K5-HUB",
        Icon = LOGO,
        CornerRadius = UDim.new(0, 12),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromRGB(150,60,255), Color3.fromRGB(40,120,255)),
        Draggable = true
    })
end)

local Main = Window:Tab({Title="Main", Icon="swords"})
local Map = Window:Tab({Title="Map", Icon="map"})
local Misc = Window:Tab({Title="Misc", Icon="gamepad-2"})
local Advanced = Window:Tab({Title="Advanced", Icon="cpu"})
local ConfigTab = Window:Tab({Title="Config", Icon="settings"})

Main:Section({Title="Combat"})
Main:Dropdown({Title="Attack Position", Values={"Under","Behind","Above"}, Value=Config.AttackPos,
    Callback=function(v) Config.AttackPos=v; save() end})
for i,name in ipairs({"AutoHoldEgg","AutoHitEgg","AutoHitChest","AutoAttack","AutoSkill1","AutoSkill2","AutoSkill3","AutoSkill4","AutoSkill5","AutoLobbyWhenFull"}) do
    Main:Toggle({Title=name, Value=Config[name], Callback=function(v) Config[name]=v; save() end})
end

Map:Section({Title="Map Selection"})
Map:Dropdown({Title="Mode", Values={"Dungeon","Tower","Cave"}, Value=Config.DungeonMode,
    Callback=function(v) Config.DungeonMode=v; save(); notify(WindUI,"K5-HUB","Mode: "..v) end})
Map:Dropdown({Title="Map", Values={
    "Starless Island","Frozen Valley","Oathless Castle","Tartarus","Sakura Village",
    "Endless Tower","Cave of Crystals","Cave of Runes","Abandoned Courtyard"
}, Value=Config.SelectedMap, Callback=function(v) Config.SelectedMap=v; save() end})
Map:Section({Title="Automation"})
for i,name in ipairs({"HellMode","InfernoMode","AutoCreateParty","AutoInviteAll","WaitFullParty","AutoOpenDoors","AutoReplay","AutoLeaveDone"}) do
    Map:Toggle({Title=name, Value=Config[name], Callback=function(v) Config[name]=v; save() end})
end

Misc:Section({Title="Movement"})
Misc:Toggle({Title="Speed Enabled", Value=Config.SpeedEnabled, Callback=function(v)
    Config.SpeedEnabled=v; save(); setSpeed()
end})
Misc:Input({Title="WalkSpeed 1-500", Value=tostring(Config.WalkSpeed), Placeholder="16",
    Callback=function(v)
        local n=tonumber(v)
        if n and n>=1 and n<=500 then Config.WalkSpeed=n; save(); setSpeed() end
    end})
Misc:Section({Title="Utility"})
for i,name in ipairs({"AntiAFK","AutoReconnect","FPSBoost","SoundNotif","HidePlayers"}) do
    Misc:Toggle({Title=name, Value=Config[name], Callback=function(v) Config[name]=v; save() end})
end
Misc:Button({Title="Rejoin Server", Callback=function()
    TeleportService:Teleport(game.PlaceId, Player)
end})

Advanced:Section({Title="IronSoul V61.11"})
Advanced:Paragraph({Title="Engine", Content="K5 local modular engine: Combat / Skills / Cave / Dungeon / Transition / Lobby."})
Advanced:Button({Title="START V61.11 ENGINE", Callback=function()
    local ok2, err = runUrl(ENGINE)
    notify(WindUI, ok2 and "K5-HUB" or "Engine Error", ok2 and "V61.11 started." or tostring(err))
end})
Advanced:Button({Title="LOAD ORIGINAL HUB ENGINE", Callback=function()
    local ok2, err = runUrl(ORIGINAL)
    notify(WindUI, ok2 and "K5-HUB" or "Load Error", ok2 and "Original engine loaded." or tostring(err))
end})

ConfigTab:Section({Title="Configuration"})
ConfigTab:Toggle({Title="Auto Execute on Teleport", Value=Config.AutoExecute, Callback=function(v)
    Config.AutoExecute=v; save()
    if v and queue_on_teleport then
        pcall(function()
            queue_on_teleport("task.wait(2); loadstring(game:HttpGet('"..BASE.."MERGED_LOADER.lua'))()")
        end)
    end
end})
ConfigTab:Button({Title="Save Config", Callback=function() save(); notify(WindUI,"K5-HUB","Config saved.") end})
ConfigTab:Button({Title="Reset Config", Callback=function()
    for k,v in pairs(DEFAULT) do Config[k]=v end
    save()
    notify(WindUI,"K5-HUB","Config reset. Reopen script to refresh controls.")
end})
ConfigTab:Paragraph({Title="Files", Content=CONFIG_FILE})

pcall(function() Window:Open() end)
notify(WindUI, "K5-HUB", "WindUI loaded successfully.")
