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

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local AutoPunch = false
local autofarming = false
local instantFarm = false
local orbDelay = 0.5
local currentWorld = localPlayer.leaderstats.WORLD.Value
local activeOrbThread = nil

-- Local saving of InstantFarm state
local savedState = {}
local function loadInstantFarmState()
    if pcall(function() return readfile("InstantFarmState.txt") end) then
        return readfile("InstantFarmState.txt") == "true"
    else
        return false -- Default to false if no saved state found
    end
end

local function saveInstantFarmState(state)
    writefile("StrongestPunchSimulator.txt", tostring(state))
end

instantFarm = loadInstantFarmState()  -- Load saved state

localPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)

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

local function InstantCollectAndRejoin()
    -- Step 1: Warp until we hit max world
    local lastWorld = localPlayer.leaderstats.WORLD.Value
    local attempts = 0
    local maxAttempts = 30  -- Safety limit

    while attempts < maxAttempts do
        local args = {
            [1] = {
                [1] = "WarpPlrToOtherMap",
                [2] = "Next"
            }
        }
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
        task.wait(0.4)

        local currentWorld = localPlayer.leaderstats.WORLD.Value
        if currentWorld == lastWorld then
            break
        end

        lastWorld = currentWorld
        attempts += 1
    end

    -- Step 2: INSTANTLY collect all orbs in current world
    local worldFolder = Workspace.Map.Stages.Boosts:FindFirstChild(tostring(lastWorld))
    if worldFolder then
        local orbParts = {}
        for _, orb in pairs(worldFolder:GetChildren()) do
            table.insert(orbParts, orb:FindFirstChildWhichIsA("BasePart"))
        end

        for _, part in ipairs(orbParts) do
            if part and HRP then
                firetouchinterest(HRP, part, 0)
                firetouchinterest(HRP, part, 1)
            end
        end
    end

    -- Step 3: Set up auto-reload & rejoin
    queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/StrongestPunchSimulator.lua'))()")
    TeleportService:Teleport(game.PlaceId, localPlayer)
end

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

Tabs.Main:AddToggle("InstantFarm", {
    Title = "INSTANT COLLECT + REJOIN",
    Description = "If u wanna stop Try when its changing world",
    Default = instantFarm,
    Callback = function(state)
        instantFarm = state
        if instantFarm then
            task.spawn(function()
                InstantCollectAndRejoin()
            end)
        end
        saveInstantFarmState(state)  -- Save state when toggled
    end
})


local nextWorldRunning = false  -- Flag to control the loop

Tabs.Main:AddToggle("AutoNextWorld", {
    Title = "Auto Next World",
    Default = false,
    Callback = function(state)
        if state then
            -- If the toggle is turned on, start the loop
            if not nextWorldRunning then
                nextWorldRunning = true
                spawn(function()
                    while nextWorldRunning do  -- Check the flag to control the loop
                        task.wait(0.8)
                        local args = {
                            [1] = {
                                [1] = "WarpPlrToOtherMap",
                                [2] = "Next"
                            }
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                    end
                end)
            end
        else
            -- If the toggle is turned off, stop the loop
            nextWorldRunning = false
        end
    end
})


