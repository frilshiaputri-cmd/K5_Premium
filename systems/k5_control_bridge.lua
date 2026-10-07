-- K5-HUB IRONSOUL CONTROL BRIDGE
-- WindUI controls this bridge; IronSoul remains the automation engine.
-- Reuses the verified IronSoul-style target/orbit/attack/replay behavior
-- from the user's uploaded K5 IronSoul AutoFarm source.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local C = getgenv().IronSoulConfig or {}
getgenv().IronSoulConfig = C

local state = {
    target=nil, kind=nil, phase=0, lastScan=0, lastAttack=0,
    lastSkill={0,0,0,0}, lastEgg=0, lastReplay=0, lastPortal=0,
    lastPortalPos=nil, started=false
}
local skillKeys={"G","R","E","Q"}

local function status(s)
    local f=getgenv().IronSoulStatus
    if type(f)=="function" then pcall(f,"K5 | "..tostring(s)) end
end

local function character()
    local ch=LocalPlayer.Character
    if not ch then return end
    return ch,ch:FindFirstChild("HumanoidRootPart"),ch:FindFirstChildOfClass("Humanoid")
end

local function lobby()
    return workspace:FindFirstChild("MatchRoom")~=nil
       and workspace:FindFirstChild("WorldEnemys")==nil
       and workspace:FindFirstChild("DragonEgg")==nil
end

local function part(obj)
    if not obj then return end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
            or obj:FindFirstChildWhichIsA("BasePart",true)
    end
    return obj:FindFirstChildWhichIsA("BasePart",true)
end

local function aliveEnemy(m)
    if not m or not m:IsA("Model") or m==LocalPlayer.Character then return false end
    local h=m:FindFirstChildOfClass("Humanoid")
    local r=m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart
    return h and h.Health>0 and r~=nil
end

local function nearestEnemy(root)
    local best,dist=nil,math.huge
    for _,o in ipairs(workspace:GetDescendants()) do
        if aliveEnemy(o) then
            local p=o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart
            local d=(root.Position-p.Position).Magnitude
            if d<dist and d<=math.max(tonumber(C.FARM_RANGE) or 25,100) then
                best,dist=p,d
            end
        end
    end
    return best,dist
end

local function findChest(root)
    local best,dist=nil,math.huge
    for _,o in ipairs(workspace:GetChildren()) do
        if string.match(string.lower(o.Name),"^chest") then
            local p=part(o)
            if p then
                local d=(root.Position-p.Position).Magnitude
                if d<dist then best,dist=p,d end
            end
        end
    end
    return best,dist
end

local function findEgg()
    if C.AUTO_DRAGON_EGG~=true then return end
    local e=workspace:FindFirstChild("DragonEgg")
    if e and not e:GetAttribute("Broken") then return part(e) end
end

local function choose(root)
    if C.AUTO_DRAGON_EGG==true then
        local e=findEgg()
        if e then return e,"egg" end
    end
    if C.AUTO_CHEST==true then
        local c=findChest(root)
        if c then return c,"chest" end
    end
    return nearestEnemy(root),"enemy"
end

local function press(key)
    if type(VirtualInputManager)~="table" and VirtualInputManager==nil then return end
    pcall(function()
        local k=Enum.KeyCode[key]
        if not k then return end
        VirtualInputManager:SendKeyEvent(true,k,false,game)
        task.wait(0.025)
        VirtualInputManager:SendKeyEvent(false,k,false,game)
    end)
end

local function attack(ch)
    if C.AUTO_ATTACK~=true then return end
    if os.clock()-state.lastAttack<0.09 then return end
    state.lastAttack=os.clock()
    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new()) end)
    local tool=ch:FindFirstChildOfClass("Tool")
    if tool then pcall(function() tool:Activate() end) end
end

local function runSkills()
    local a=C.AUTO_SKILL
    if type(a)~="table" then return end
    -- Skill 1 = Base Attack, Skills 2-5 = verified G/R/E/Q input actions.
    if a[1]==true then attack(LocalPlayer.Character) end
    for i,key in ipairs(skillKeys) do
        if a[i+1]==true and os.clock()-state.lastSkill[i]>=2 then
            state.lastSkill[i]=os.clock()
            press(key)
        end
    end
end

local function triggerEgg(p)
    if os.clock()-state.lastEgg<12 then return end
    state.lastEgg=os.clock()
    local m=p:FindFirstAncestor("DragonEgg") or p.Parent
    local prompt=m and m:FindFirstChildWhichIsA("ProximityPrompt",true)
    if prompt and type(fireproximityprompt)=="function" then
        pcall(fireproximityprompt,prompt)
    else
        press("F")
    end
end

local function visible(o)
    if not o or not o.Parent then return false end
    if o:IsA("GuiObject") and not o.Visible then return false end
    local p=o.Parent
    while p and p~=game do
        if p:IsA("GuiObject") and not p.Visible then return false end
        p=p.Parent
    end
    return true
end

local function replay()
    if C.AUTO_REPLAY~=true or os.clock()-state.lastReplay<8 then return end
    local pg=LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end
    for _,o in ipairs(pg:GetDescendants()) do
        if o:IsA("TextLabel") then
            local t=string.lower(o.Text or "")
            if string.find(t,"play") and string.find(t,"again") then
                local b=o:FindFirstAncestorWhichIsA("TextButton") or o:FindFirstAncestorWhichIsA("ImageButton")
                if b and visible(b) then
                    state.lastReplay=os.clock()
                    pcall(function()
                        if type(firesignal)=="function" then firesignal(b.MouseButton1Click) else b:Activate() end
                    end)
                    return
                end
            end
        elseif (o:IsA("TextButton") or o:IsA("ImageButton")) and visible(o) then
            local n=string.lower(o.Name)
            if string.find(n,"replay") or string.find(n,"restart") or string.find(n,"again") then
                state.lastReplay=os.clock()
                pcall(function() if type(firesignal)=="function" then firesignal(o.MouseButton1Click) else o:Activate() end end)
                return
            end
        end
    end
end

local function nextStage(root)
    if C.AUTO_OPEN_DOOR~=true or os.clock()-state.lastPortal<4 then return end
    for _,o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") then
            local n=string.lower(o.Name)
            local pn=o.Parent and string.lower(o.Parent.Name) or ""
            local trigger=o:FindFirstChildOfClass("ProximityPrompt") or o:FindFirstChildOfClass("TouchInterest") or o:FindFirstChildOfClass("TouchTransmitter")
            if trigger and (string.find(n,"portal") or string.find(pn,"portal") or string.find(n,"door") or string.find(pn,"door") or string.find(n,"gate") or string.find(pn,"gate")) then
                local d=(root.Position-o.Position).Magnitude
                if d<=600 then
                    state.lastPortal=os.clock(); state.lastPortalPos=o.Position
                    pcall(function()
                        local dir=(o.Position-root.Position)
                        if dir.Magnitude<0.1 then dir=root.CFrame.LookVector else dir=dir.Unit end
                        root.CFrame=CFrame.new(o.Position-dir*2+Vector3.new(0,1,0))
                        task.wait(0.05)
                        if type(firetouchinterest)=="function" then firetouchinterest(root,o,0); task.wait(0.05); firetouchinterest(root,o,1) end
                        press("F")
                    end)
                    return
                end
            end
        end
    end
end

local function dead()
    local life=LocalPlayer:GetAttribute("RemainLife")
    return type(life)=="number" and life<=0
end

local function tick()
    local ch,root,hum=character()
    if not ch or not root or not hum or hum.Health<=0 or lobby() then return end
    if dead() then state.target=nil; state.kind=nil; return end

    if not state.target or not state.target.Parent then
        state.target,state.kind=choose(root)
    end

    if not state.target then
        replay(); nextStage(root)
        status("SEARCHING")
        return
    end

    local p=state.target
    if state.kind=="enemy" then
        local m=p.Parent
        local h=m and m:FindFirstChildOfClass("Humanoid")
        if not h or h.Health<=0 then state.target=nil; state.kind=nil; return end
    end

    state.phase += 0.06*(tonumber(C.ORBIT_SPEED) or 4)
    local r=tonumber(C.ORBIT_RADIUS) or 6
    local y=tonumber(C.ORBIT_HEIGHT) or 5
    local mode=C.FARM_POSITION or "Under"
    local pos
    if mode=="Above" then
        pos=p.Position+Vector3.new(math.sin(state.phase)*r,y,math.cos(state.phase)*r)
    elseif mode=="Behind" then
        local back=p.CFrame.LookVector*-r
        pos=p.Position+Vector3.new(back.X,-y,back.Z)
    else
        pos=p.Position+Vector3.new(math.sin(state.phase)*r,-y,math.cos(state.phase)*r)
    end
    root.CFrame=CFrame.lookAt(pos,p.Position)

    local dist=(root.Position-p.Position).Magnitude
    if state.kind=="egg" then
        if dist<=24 then triggerEgg(p) end
    elseif dist<=(tonumber(C.FARM_RANGE) or 25) then
        attack(ch)
        runSkills()
    end
end

local function start()
    if state.started then return end
    state.started=true
    task.spawn(function()
        while true do
            if C.AUTO_FARM==true then
                if os.clock()-state.lastScan>=0.25 then
                    state.lastScan=os.clock()
                    tick()
                end
                task.wait(0.08)
            else
                state.target=nil; state.kind=nil
                task.wait(0.2)
            end
        end
    end)

    RunService.Stepped:Connect(function()
        if C.AUTO_FARM~=true or C.FARM_NOCLIP==false or lobby() then return end
        local ch=LocalPlayer.Character
        if ch then
            for _,p in ipairs(ch:GetChildren()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end
    end)

    status("Control Bridge ONLINE")
end

getgenv().K5IronSoulBridge = {
    Version="1.0",
    Start=start,
    State=state,
}
start()
