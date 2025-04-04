local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "H4xScripts",
    SubTitle = "Legend of Speed [ULTIMATE]",
    TabWidth = 130,
    Size = UDim2.fromOffset(520, 420),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({Title = "Main", Icon = "locate"})
}

-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

-- Player
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Variables
local AutoPunch = false
local autofarming = false
local instantFarm = false
local orbDelay = 0.5
local currentWorld = localPlayer.leaderstats.WORLD.Value
local activeOrbThread = nil

-- State saving/loading
local function SaveState()
    writefile("H4xScripts_State.txt", tostring(instantFarm))
end

local function LoadState()
    if pcall(function() return readfile("H4xScripts_State.txt") end) then
        return readfile("H4xScripts_State.txt") == "true"
    end
    return false
end

-- Load saved state
instantFarm = LoadState()

-- Character handling
localPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)

-- Auto Punch
local function AutoPunchToggle(state)
    AutoPunch = state
    if AutoPunch then
        task.spawn(function()
            while AutoPunch do
                local args = { [1] = { [1] = "Activate_Punch" } }
                RS:WaitForChild("RemoteEvent"):FireServer(unpack(args))
                task.wait(0.6)
            end
        end)
    end
end

-- Auto Orbs
local function AutoOrbsToggle(state)
    autofarming = state
    if activeOrbThread then
        coroutine.close(activeOrbThread)
        activeOrbThread = nil
    end
    if autofarming then
        activeOrbThread = task.spawn(function()
            local lastWorld = currentWorld
            while autofarming do
                currentWorld = localPlayer.leaderstats.WORLD.Value
                if currentWorld ~= lastWorld then
                    lastWorld = currentWorld
                    task.wait(1)
                end
                local worldFolder = Workspace.Map.Stages.Boosts:FindFirstChild(tostring(currentWorld))
                if worldFolder then
                    local orbs = worldFolder:GetChildren()
                    for _, v in ipairs(orbs) do
                        if not autofarming then break end
                        if localPlayer.leaderstats.WORLD.Value ~= currentWorld then break end
                        for _, part in pairs(v:GetChildren()) do
                            if part:IsA("BasePart") and HRP then
                                firetouchinterest(HRP, part, 0)
                                task.wait()
                                firetouchinterest(HRP, part, 1)
                            end
                        end
                        task.wait(orbDelay)
                    end
                else
                    task.wait(1)
                end
            end
        end)
    end
end

-- Instant Collect + Rejoin
local function InstantCollectAndRejoin()
    -- Warp to max world
    local lastWorld = localPlayer.leaderstats.WORLD.Value
    for i = 1, 30 do
        local args = {
            [1] = {
                [1] = "WarpPlrToOtherMap",
                [2] = "Next"
            }
        }
        RS:WaitForChild("RemoteEvent"):FireServer(unpack(args))
        task.wait(0.4)
        
        local currentWorld = localPlayer.leaderstats.WORLD.Value
        if currentWorld == lastWorld then break end
        lastWorld = currentWorld
    end

    -- Collect orbs
    local worldFolder = Workspace.Map.Stages.Boosts:FindFirstChild(tostring(lastWorld))
    if worldFolder then
        for _, orb in pairs(worldFolder:GetChildren()) do
            local part = orb:FindFirstChildWhichIsA("BasePart")
            if part and HRP then
                firetouchinterest(HRP, part, 0)
                firetouchinterest(HRP, part, 1)
            end
        end
    end

    -- Prepare auto-rejoin
    queue_on_teleport([[
        loadstring(game:HttpGet("YOUR_SCRIPT_URL_HERE"))()
    ]])
    TeleportService:Teleport(game.PlaceId, localPlayer)
end

-- World change monitor
task.spawn(function()
    local lastWorld = currentWorld
    while true do
        currentWorld = localPlayer.leaderstats.WORLD.Value
        if currentWorld ~= lastWorld then
            lastWorld = currentWorld
            if autofarming then
                AutoOrbsToggle(false)
                task.wait(0.5)
                AutoOrbsToggle(true)
            end
        end
        task.wait(0.5)
    end
end)

-- UI Elements
Tabs.Main:AddToggle("AutoPunch", {
    Title = "Auto Punch",
    Default = false,
    Callback = AutoPunchToggle
})

Tabs.Main:AddToggle("AutoOrbs", {
    Title = "Auto Orbs",
    Default = false,
    Callback = AutoOrbsToggle
})

Tabs.Main:AddSlider("OrbDelay", {
    Title = "Auto Orb Delay",
    Description = "Delay between orb collects",
    Default = 0.5,
    Min = 0.1,
    Max = 1,
    Increment = 0.1,
    Rounding = 1,
    Callback = function(val)
        orbDelay = math.round(val * 10) / 10
    end
})

local instantToggle = Tabs.Main:AddToggle("InstantFarm", {
    Title = "INSTANT COLLECT + REJOIN",
    Description = "Automatically restarts when rejoining",
    Default = instantFarm,
    Callback = function(state)
        instantFarm = state
        SaveState()
        if state then
            task.spawn(InstantCollectAndRejoin)
        end
    end
})

-- Auto-run if saved state was true
if instantFarm then
    task.spawn(function()
        task.wait(2) -- Wait for everything to initialize
        instantToggle:Set(true)
    end)
end
