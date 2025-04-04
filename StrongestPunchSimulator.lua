repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

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

local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local AutoPunch = false
local autofarming = false
local instantFarm = false
local orbDelay = 0.5
local currentWorld = localPlayer.leaderstats.WORLD.Value
local activeOrbThread = nil
local nextWorldRunning = false

local function InitializeFileSystem()
    if not isfolder("H4xScripts") then
        makefolder("H4xScripts")
    end
    
    if not isfile("H4xScripts/StrongestPunchSimulator.txt") then
        writefile("H4xScripts/StrongestPunchSimulator.txt", "false")
    end
end

local function SaveAutoOrbState(state)
    pcall(function()
        writefile("H4xScripts/StrongestPunchSimulator.txt", tostring(state))
    end)
end

local function LoadAutoOrbState()
    InitializeFileSystem()
    
    local success, result = pcall(function()
        return readfile("H4xScripts/StrongestPunchSimulator.txt") == "true"
    end)
    
    return success and result or false
end

instantFarm = LoadAutoOrbState()

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
    local lastWorld = localPlayer.leaderstats.WORLD.Value
    for i = 1, 25 do
        local args = {
            [1] = {
                [1] = "WarpPlrToOtherMap",
                [2] = "Next"
            }
        }
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
        task.wait(0.3)
        
        local currentWorld = localPlayer.leaderstats.WORLD.Value
        if currentWorld == lastWorld then break end
        lastWorld = currentWorld
    end

    local worldFolder = Workspace.Map.Stages.Boosts:FindFirstChild(tostring(lastWorld))
    if worldFolder then
        for _, orb in pairs(worldFolder:GetChildren()) do
            local part = orb:FindFirstChildWhichIsA("BasePart") or orb.PrimaryPart
            if part and HRP then
                firetouchinterest(HRP, part, 0)
                firetouchinterest(HRP, part, 1)
            end
        end
        
        task.wait(1.2)
        
        for _, orb in pairs(worldFolder:GetChildren()) do
            local part = orb:FindFirstChildWhichIsA("BasePart") or orb.PrimaryPart
            if part and HRP then
                firetouchinterest(HRP, part, 0)
                firetouchinterest(HRP, part, 1)
            end
        end
    end

    local TeleportService = game:GetService("TeleportService")
    task.wait(0.3)
    
    local success = pcall(function()
        TeleportService:Teleport(game.PlaceId)
    end)
    
    if not success then
        task.wait(0.1)
        pcall(function()
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                tostring(math.random(1, 999999999)),
                localPlayer
            )
        end)
    end
    
    task.wait(0.1)
    pcall(function()
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer({[1] = "Reset"})
        TeleportService:Teleport(game.PlaceId)
    end)
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

local function AutoNextWorldToggle(state)
    nextWorldRunning = state
    if state then
        task.spawn(function()
            while nextWorldRunning do
                local args = {
                    [1] = {
                        [1] = "WarpPlrToOtherMap",
                        [2] = "Next"
                    }
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                task.wait(0.8)
            end
        end)
    end
end

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
    Title = "INSTANT COLLECT",
    Description = "Collects all orbs in current world",
    Default = instantFarm,
    Callback = function(state)
        instantFarm = state
        SaveAutoOrbState(state)
        if state then
            task.spawn(InstantCollectAndRejoin)
        end
    end
})

Tabs.Main:AddToggle("AutoNextWorld", {
    Title = "Auto Next World",
    Default = false,
    Callback = AutoNextWorldToggle
})

if instantFarm then
    task.spawn(function()
        task.wait(1)
        if instantToggle then
            pcall(function() instantToggle:Set(true) end)
        end
    end)
end

local autoUpgradeActive = false
local upgradeThread = nil

local Toggle = Tabs.Main:AddToggle("AutoUpgradePet", {
    Title = "Auto Upgrade Pet", 
    Default = false,
    Callback = function(state)
        autoUpgradeActive = state
        
        if upgradeThread then
            coroutine.close(upgradeThread)
            upgradeThread = nil
        end
        
        if state then
            upgradeThread = task.spawn(function()
                while autoUpgradeActive do
                    local args = {
                        [1] = {
                            [1] = "UpgradeCurrentPet"
                        }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                    
                    for _ = 1, 2 do
                        if not autoUpgradeActive then break end
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})

print([[

██╗░░██╗░░██╗██╗██╗░░██╗    ░██████╗░█████╗░██████╗░██╗██████╗░████████╗░██████╗
██║░░██║░██╔╝██║╚██╗██╔╝    ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
███████║██╔╝░██║░╚███╔╝░    ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░╚█████╗░
██╔══██║███████║░██╔██╗░    ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░░╚═══██╗
██║░░██║╚════██║██╔╝╚██╗    ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░██████╔╝
╚═╝░░╚═╝░░░░░╚═╝╚═╝░░╚═╝    ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░
]])
