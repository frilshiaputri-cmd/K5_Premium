-- K5-HUB stable entry
local url = "https://raw.githubusercontent.com/frilshiaputri-cmd/K5_Premium/main/bootstrap_v61_11.lua?t=" .. tostring(os.time())
local source = game:HttpGet(url)
local fn, err = loadstring(source)
assert(fn, err)
return fn()
