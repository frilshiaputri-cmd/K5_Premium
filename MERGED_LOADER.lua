-- K5-HUB LOCAL REPO LOADER
-- Main entry point for the K5_Premium repository.
local BASE = "https://raw.githubusercontent.com/frilshiaputri-cmd/K5_Premium/main/"
getgenv().IronSoulEngineBase = BASE
getgenv()["K5-HUBEngineBase"] = BASE
local HUB_URL = BASE .. "Yuszx_Merged.lua"
local ok, err = pcall(function()
    loadstring(game:HttpGet(HUB_URL .. "?t=" .. tostring(os.time())))()
end)
if not ok then
    warn("[K5-HUB] Loader failed: " .. tostring(err))
end
