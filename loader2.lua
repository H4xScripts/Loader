repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
local Games = {
    [14996478064] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/Hospital%20Tycoon.lua",
    [6875469709] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/StrongestPunchSimulator.lua",
    [7215881810] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/NoLimitStrongestPunchSimulator.lua",
    [17589670912] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/Find%20The%20Auras",
    [126884695634066] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/Grow%20a%20Garden.lua"
}

local gameFound = false

for PlaceID, ScriptURL in pairs(Games) do
    if PlaceID == game.PlaceId then
        gameFound = true
        loadstring(game:HttpGet(ScriptURL))()
        break 
    end
end

if not gameFound then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 400, 0, 100)
    textLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
    textLabel.Text = "Game Not Supported"
    textLabel.TextSize = 30
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.BackgroundTransparency = 0.5
    textLabel.Parent = screenGui

    local countdown = 3
    while countdown > 0 do
        textLabel.Text = "Game Not Supported\n" .. countdown
        wait(1)
        countdown = countdown - 1
    end

    screenGui:Destroy()
end
