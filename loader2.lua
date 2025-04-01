local Games = {
    [14996478064] = "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/HospitalTycoon.lua"
}

local gameFound = false

for PlaceID, ScriptURL in pairs(Games) do
    if PlaceID == game.PlaceId then
        gameFound = true
        -- Only load the script if the game ID matches
        loadstring(game:HttpGet(ScriptURL))()
        break  -- Exit the loop after loading the correct script
    end
end

if not gameFound then
    -- Create a GUI to show "Game Not Supported"
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

    -- Destroy the GUI after countdown
    screenGui:Destroy()
end
