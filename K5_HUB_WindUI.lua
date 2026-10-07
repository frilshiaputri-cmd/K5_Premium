-- K5-HUB | IRONSOUL ENGINE + WINDUI FRONTEND
-- WindUI is the ONLY interface. IronSoul remains the feature engine.

local WINDUI_URL = "https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua"
local BASE = "https://raw.githubusercontent.com/frilshiaputri-cmd/K5_Premium/main/"
local LOGO = "rbxassetid://115820469332666"

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Shared control state consumed by IronSoul modules.
local C = getgenv().IronSoulConfig or {}
C.FPS_CAP = tonumber(C.FPS_CAP) or 8
C.FARM = C.FARM or "NEWBIE"
C.TICKETS = C.TICKETS or "SMART"
C.HEADLESS = C.HEADLESS ~= false
C.CAVE_AUTO = C.CAVE_AUTO ~= false
C.HELL_AUTO = C.HELL_AUTO ~= false
C.SHOP_AUTO = C.SHOP_AUTO ~= false
C.MOBILE_STATUS = C.MOBILE_STATUS == true
C.DEBUG_LOGS = C.DEBUG_LOGS == true
C.AUTO_FARM = C.AUTO_FARM == true
C.FARM_POSITION = C.FARM_POSITION or "Under"
C.AUTO_ATTACK = C.AUTO_ATTACK == true
C.AUTO_SKILL = C.AUTO_SKILL or {false,false,false,false,false}
C.AUTO_CHEST = C.AUTO_CHEST == true
C.AUTO_DRAGON_EGG = C.AUTO_DRAGON_EGG == true
C.WAIT_PARTY_FULL = C.WAIT_PARTY_FULL == true
C.AUTO_OPEN_DOOR = C.AUTO_OPEN_DOOR == true
C.AUTO_REPLAY = C.AUTO_REPLAY == true
C.AUTO_LEAVE = C.AUTO_LEAVE == true
C.ANTI_AFK = C.ANTI_AFK == true
C.WALK_SPEED = tonumber(C.WALK_SPEED) or 16
C.FPS_BOOST = C.FPS_BOOST == true
C.HIDE_PLAYERS = C.HIDE_PLAYERS == true
C.SOUND = C.SOUND ~= false
C.AUTO_LOBBY = C.AUTO_LOBBY == true
C.AUTO_EXECUTE = C.AUTO_EXECUTE == true
C.MAP = C.MAP or "Dungeon"
getgenv().IronSoulConfig = C
getgenv().K5HUB_WindUI = true
getgenv().K5HUB_SetConfig = function(k,v)
    C[k] = v
    getgenv().IronSoulConfig = C
end

local ok, WindUI = pcall(function()
    return loadstring(game:HttpGet(WINDUI_URL))()
end)
if not ok or not WindUI then
    warn("[K5-HUB] WindUI failed:", WindUI)
    return
end

pcall(function() WindUI:SetNotificationLower(true) end)

local Window = WindUI:CreateWindow({
    Title="K5-HUB",
    Author="IRONSOUL",
    Icon=LOGO,
    Folder="K5-HUB",
    Size=UDim2.fromOffset(470,330),
    MinSize=Vector2.new(430,285),
    MaxSize=Vector2.new(600,430),
    Theme="Dark",
    NewElements=true,
    HideSearchBar=false,
    SideBarWidth=140,
    Topbar={Height=42,ButtonsType="Mac"},
    OpenButton={
        Title="K5-HUB", Icon=LOGO, CornerRadius=UDim.new(1,0),
        StrokeThickness=2, Enabled=true, Draggable=true,
        OnlyMobile=false, Scale=0.58,
        Color=ColorSequence.new(Color3.fromRGB(95,35,165),Color3.fromRGB(215,70,255)),
    },
})
pcall(function() Window:Tag({Title="K5-HUB",Icon=LOGO,Color=Color3.fromRGB(145,65,210),Border=true}) end)

local function notify(s)
    pcall(function() Window:Notify({Title="K5-HUB",Content=tostring(s),Icon=LOGO}) end)
end
local function set(k,v) C[k]=v end

-- Player helpers
local antiConn
local function antiAFK(on)
    if antiConn then antiConn:Disconnect(); antiConn=nil end
    if on then
        local vu = game:GetService("VirtualUser")
        antiConn = LocalPlayer.Idled:Connect(function()
            pcall(function()
                vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end)
    end
end
local function hidePlayers(on)
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            for _,o in ipairs(p.Character:GetDescendants()) do
                if o:IsA("BasePart") then o.LocalTransparencyModifier = on and 1 or 0 end
            end
        end
    end
end
local function applySpeed(v)
    C.WALK_SPEED=tonumber(v) or 16
    local char=LocalPlayer.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed=C.WALK_SPEED end
end
local function rejoin()
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer) end)
end
local function hop()
    pcall(function()
        local HttpService=game:GetService("HttpService")
        local url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local data=HttpService:JSONDecode(game:HttpGet(url))
        for _,s in ipairs(data.data or {}) do
            if s.id~=game.JobId and s.playing<s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId,s.id,LocalPlayer)
                break
            end
        end
    end)
end

local Main=Window:Tab({Title="Main",Icon="swords",IconShape="Square",Border=true})
Main:Section({Title="IronSoul Combat",Box=true,BoxBorder=true})
Main:Toggle({Title="Auto Farm",Value=C.AUTO_FARM,Callback=function(v)set("AUTO_FARM",v)end})
Main:Dropdown({Title="Farm Position",Values={"Under","Behind","Above"},Value=C.FARM_POSITION,AllowNone=false,Callback=function(v)set("FARM_POSITION",v)end})
Main:Toggle({Title="Auto Attack",Value=C.AUTO_ATTACK,Callback=function(v)set("AUTO_ATTACK",v)end})
for i=1,5 do
    Main:Toggle({Title="Auto Skill "..i,Value=C.AUTO_SKILL[i],Callback=function(v)C.AUTO_SKILL[i]=v end})
end
Main:Section({Title="Auto Collect",Box=true,BoxBorder=true})
Main:Toggle({Title="Auto Chest",Value=C.AUTO_CHEST,Callback=function(v)set("AUTO_CHEST",v)end})
Main:Toggle({Title="Auto Dragon Egg",Value=C.AUTO_DRAGON_EGG,Callback=function(v)set("AUTO_DRAGON_EGG",v)end})

local Map=Window:Tab({Title="Map",Icon="map",IconShape="Square",Border=true})
Map:Section({Title="Dungeon / Route",Box=true,BoxBorder=true})
Map:Dropdown({Title="Map",Values={"Dungeon","Tower","Cave","Endless Tower","Hell","Inferno"},Value=C.MAP,AllowNone=false,Callback=function(v)set("MAP",v)end})
Map:Toggle({Title="Wait Until Party Full",Value=C.WAIT_PARTY_FULL,Callback=function(v)set("WAIT_PARTY_FULL",v)end})
Map:Toggle({Title="Auto Open Door",Value=C.AUTO_OPEN_DOOR,Callback=function(v)set("AUTO_OPEN_DOOR",v)end})
Map:Toggle({Title="Auto Replay",Value=C.AUTO_REPLAY,Callback=function(v)set("AUTO_REPLAY",v)end})
Map:Toggle({Title="Auto Leave",Value=C.AUTO_LEAVE,Callback=function(v)set("AUTO_LEAVE",v)end})

local Misc=Window:Tab({Title="Misc",Icon="settings",IconShape="Square",Border=true})
Misc:Section({Title="Player",Box=true,BoxBorder=true})
Misc:Toggle({Title="Anti AFK",Value=C.ANTI_AFK,Callback=function(v)set("ANTI_AFK",v)antiAFK(v)end})
Misc:Slider({Title="WalkSpeed",Value={Min=1,Max=500,Default=C.WALK_SPEED},Step=1,IsTooltip=true,IsTextbox=true,Callback=function(v)applySpeed(v)end})
Misc:Toggle({Title="FPS Boost",Value=C.FPS_BOOST,Callback=function(v)set("FPS_BOOST",v)if v and setfpscap then pcall(setfpscap,30)end end})
Misc:Toggle({Title="Hide Players",Value=C.HIDE_PLAYERS,Callback=function(v)set("HIDE_PLAYERS",v)hidePlayers(v)end})
Misc:Toggle({Title="Sound",Value=C.SOUND,Callback=function(v)set("SOUND",v)end})
Misc:Section({Title="Server",Box=true,BoxBorder=true})
Misc:Button({Title="Rejoin Server",Icon="rotate-ccw",Callback=rejoin})
Misc:Button({Title="Server Hop",Icon="shuffle",Callback=hop})

local Advanced=Window:Tab({Title="Advanced",Icon="cpu",IconShape="Square",Border=true})
Advanced:Section({Title="IronSoul Automation",Box=true,BoxBorder=true})
Advanced:Toggle({Title="Auto Lobby When Full",Value=C.AUTO_LOBBY,Callback=function(v)set("AUTO_LOBBY",v)end})
Advanced:Toggle({Title="Auto Execute On Teleport",Value=C.AUTO_EXECUTE,Callback=function(v)set("AUTO_EXECUTE",v)end})
Advanced:Toggle({Title="Cave Auto",Value=C.CAVE_AUTO,Callback=function(v)set("CAVE_AUTO",v)end})
Advanced:Toggle({Title="Hell Auto",Value=C.HELL_AUTO,Callback=function(v)set("HELL_AUTO",v)end})
Advanced:Toggle({Title="Shop Auto",Value=C.SHOP_AUTO,Callback=function(v)set("SHOP_AUTO",v)end})
Advanced:Dropdown({Title="Ticket Mode",Values={"SMART","OFF"},Value=C.TICKETS,AllowNone=false,Callback=function(v)set("TICKETS",v)end})
Advanced:Section({Title="Engine",Box=true,BoxBorder=true})
Advanced:Toggle({Title="Headless Combat",Value=C.HEADLESS,Callback=function(v)set("HEADLESS",v)end})
Advanced:Toggle({Title="Mobile Status",Value=C.MOBILE_STATUS,Callback=function(v)set("MOBILE_STATUS",v)end})
Advanced:Toggle({Title="Debug Logs",Value=C.DEBUG_LOGS,Callback=function(v)set("DEBUG_LOGS",v)end})
Advanced:Paragraph({Title="Engine: IronSoul",Desc="WindUI controls the shared IronSoulConfig. Legacy UI is not loaded.",Image=LOGO,ImageSize=26})

local ConfigTab=Window:Tab({Title="Config",Icon="settings-2",IconShape="Square",Border=true})
ConfigTab:Section({Title="K5-HUB",Box=true,BoxBorder=true})
ConfigTab:Paragraph({Title="WindUI + IronSoul",Desc="WindUI = interface • IronSoul = engine/features",Image=LOGO,ImageSize=30})
ConfigTab:Button({Title="Show Engine Status",Icon="info",Callback=function()
    local r=getgenv().IronSoulRuntime
    notify(r and ("IronSoul "..tostring(r.Version).." | "..tostring(r.Route)) or "IronSoul engine belum aktif.")
end})
ConfigTab:Button({Title="Reset Controls",Icon="refresh-cw",Callback=function()
    getgenv().IronSoulConfig=nil
    notify("Controls reset. Re-execute K5-HUB untuk memakai default.")
end})

pcall(function() Window:Open() end)
antiAFK(C.ANTI_AFK)
applySpeed(C.WALK_SPEED)
hidePlayers(C.HIDE_PLAYERS)
notify("WindUI siap • memuat IronSoul...")

-- K5 control bridge: wires WindUI controls to the IronSoul-style automation
-- without loading the legacy UI.
task.spawn(function()
    local okBridge, errBridge = pcall(function()
        local src=game:HttpGet(BASE.."systems/k5_control_bridge.lua?t="..tostring(os.time()))
        local fn,e=loadstring(src)
        assert(fn,e)
        fn()
    end)
    if not okBridge then notify("K5 bridge gagal: "..tostring(errBridge)) end
end)


-- Start the real IronSoul engine. No legacy Yuszx UI is loaded.
task.spawn(function()
    local okBoot, err=pcall(function()
        local src=game:HttpGet("https://raw.githubusercontent.com/frilshiaputri-cmd/Ironsoulkaitun/main/bootstrap_v61_11.lua?t="..tostring(os.time()))
        local fn,e=loadstring(src)
        assert(fn,e)
        fn()
    end)
    if not okBoot then notify("IronSoul gagal start: "..tostring(err)) end
end)
