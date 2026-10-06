-- K5-HUB | WindUI Edition
local WINDUI_URL = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
local LOGO = "rbxassetid://115820469332666"

local ok, WindUI = pcall(function()
    return loadstring(game:HttpGet(WINDUI_URL))()
end)
if not ok or not WindUI then
    warn("[K5-HUB] WindUI failed to load:", WindUI)
    return
end

pcall(function() WindUI:SetNotificationLower(true) end)

local Window = WindUI:CreateWindow({
    Title = "K5-HUB",
    Author = "Premium",
    Icon = LOGO,
    Folder = "K5-HUB",
    Size = UDim2.fromOffset(470, 330),
    MinSize = Vector2.new(430, 285),
    MaxSize = Vector2.new(600, 430),
    Theme = "Dark",
    NewElements = true,
    HideSearchBar = false,
    SideBarWidth = 140,
    Topbar = {Height = 42, ButtonsType = "Mac"},
    OpenButton = {
        Title = "K5-HUB",
        Icon = LOGO,
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 2,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.58,
        Color = ColorSequence.new(Color3.fromRGB(95,35,165), Color3.fromRGB(215,70,255)),
    },
})

pcall(function()
    Window:Tag({Title="K5-HUB", Icon=LOGO, Color=Color3.fromRGB(145,65,210), Border=true})
end)

local function notify(text)
    pcall(function()
        Window:Notify({Title="K5-HUB", Content=text, Icon=LOGO})
    end)
end

local Main = Window:Tab({Title="Main", Icon="swords", IconShape="Square", Border=true})
Main:Section({Title="Combat", Box=true, BoxBorder=true})
Main:Toggle({Title="Auto Farm", Value=false})
Main:Dropdown({Title="Farm Position", Values={"Under","Behind","Above"}, Value="Under", AllowNone=false})
Main:Toggle({Title="Auto Attack", Value=false})
Main:Toggle({Title="Auto Skill 1", Value=false})
Main:Toggle({Title="Auto Skill 2", Value=false})
Main:Toggle({Title="Auto Skill 3", Value=false})
Main:Toggle({Title="Auto Skill 4", Value=false})
Main:Toggle({Title="Auto Skill 5", Value=false})
Main:Section({Title="Auto Collect", Box=true, BoxBorder=true})
Main:Toggle({Title="Auto Chest", Value=false})
Main:Toggle({Title="Auto Dragon Egg", Value=false})

local Map = Window:Tab({Title="Map", Icon="map", IconShape="Square", Border=true})
Map:Section({Title="Map / Dungeon", Box=true, BoxBorder=true})
Map:Dropdown({Title="Map", Values={"Dungeon","Tower","Cave","Endless Tower","Hell","Inferno"}, Value="Dungeon", AllowNone=false})
Map:Toggle({Title="Wait Until Party Full", Value=false})
Map:Toggle({Title="Auto Open Door", Value=false})
Map:Toggle({Title="Auto Replay", Value=false})
Map:Toggle({Title="Auto Leave", Value=false})

local Misc = Window:Tab({Title="Misc", Icon="settings", IconShape="Square", Border=true})
Misc:Section({Title="Player", Box=true, BoxBorder=true})
Misc:Toggle({Title="Anti AFK", Value=false})
Misc:Slider({Title="WalkSpeed", Value={Min=1,Max=500,Default=16}, Step=1, IsTooltip=true, IsTextbox=true})
Misc:Toggle({Title="FPS Boost", Value=false})
Misc:Toggle({Title="Hide Players", Value=false})
Misc:Toggle({Title="Sound", Value=true})
Misc:Section({Title="Server", Box=true, BoxBorder=true})
Misc:Button({Title="Rejoin Server", Icon="rotate-ccw", Callback=function() notify("Rejoin requested.") end})
Misc:Button({Title="Server Hop", Icon="shuffle", Callback=function() notify("Server hop requested.") end})

local Advanced = Window:Tab({Title="Advanced", Icon="cpu", IconShape="Square", Border=true})
Advanced:Section({Title="Automation", Box=true, BoxBorder=true})
Advanced:Toggle({Title="Auto Lobby When Full", Value=false})
Advanced:Toggle({Title="Auto Execute On Teleport", Value=false})
Advanced:Toggle({Title="Cave Auto", Value=false})
Advanced:Toggle({Title="Hell Auto", Value=false})
Advanced:Toggle({Title="Shop Auto", Value=false})
Advanced:Section({Title="Engine", Box=true, BoxBorder=true})
Advanced:Paragraph({Title="K5-HUB Engine", Desc="WindUI interface rebuilt from scratch. Engine modules can be connected here.", Image=LOGO, ImageSize=26})

local Config = Window:Tab({Title="Config", Icon="settings-2", IconShape="Square", Border=true})
Config:Section({Title="K5-HUB", Box=true, BoxBorder=true})
Config:Paragraph({Title="K5-HUB WindUI", Desc="Compact UI • Draggable • Minimize to logo • Dark/Purple theme", Image=LOGO, ImageSize=30})
Config:Button({Title="Reset UI", Icon="refresh-cw", Callback=function() notify("UI reset.") end})
Config:Button({Title="Show Status", Icon="info", Callback=function() notify("Interface aktif.") end})

pcall(function() Window:Open() end)
notify("WindUI loaded successfully.")
