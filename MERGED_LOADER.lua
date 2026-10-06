-- IRONSOUL COMBINED LOADER
-- Loads the original hub UI. The Advanced tab starts the V61.11 modular engine.
getgenv().IronSoulEngineBase = getgenv().IronSoulEngineBase or
    "https://raw.githubusercontent.com/MUshihara/ironsoulkaitun/main/"

local HUB_URL = getgenv().IronSoulHubURL or
    "https://raw.githubusercontent.com/MUshihara/ironsoulkaitun/main/Yuszx_Merged.lua"

loadstring(game:HttpGet(HUB_URL .. "?t=" .. tostring(os.time())))()
