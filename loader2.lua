local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local KeySystem = Instance.new("ScreenGui")
KeySystem.Name = "KeySystem"
KeySystem.Parent = game:GetService("CoreGui")
KeySystem.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = KeySystem
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

MainFrame.Position = UDim2.new(0.5, -175, 0.4, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 0)
MainFrame.Visible = true

local appearTween = TweenService:Create(
    MainFrame,
    TweenInfo.new(0.5, Enum.EasingStyle.Quint),
    {Size = UDim2.new(0, 350, 0, 250), Position = UDim2.new(0.5, -175, 0.5, -125)}
)
appearTween:Play()

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 8)
UICorner_2.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1.0
Title.Position = UDim2.new(0, 50, 0, 0)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "H4xScripts KeySystem"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize = 14.000
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundTransparency = 1.0
CloseButton.Position = UDim2.new(1, -30, 0.5, -10)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageRectOffset = Vector2.new(284, 4)
CloseButton.ImageRectSize = Vector2.new(24, 24)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(220, 220, 220)}):Play()
end)

local GameLogo = Instance.new("ImageLabel")
GameLogo.Name = "GameLogo"
GameLogo.Parent = TitleBar
GameLogo.BackgroundTransparency = 1.0
GameLogo.Position = UDim2.new(0, 10, 0.5, -12)
GameLogo.Size = UDim2.new(0, 24, 0, 24)
GameLogo.Image = "rbxassetid://7072718362"

local InputFrame = Instance.new("Frame")
InputFrame.Name = "InputFrame"
InputFrame.Parent = MainFrame
InputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
InputFrame.BorderSizePixel = 0
InputFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
InputFrame.Size = UDim2.new(0.9, 0, 0, 90)

local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 6)
UICorner_3.Parent = InputFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Parent = InputFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
KeyBox.BorderSizePixel = 0
KeyBox.Position = UDim2.new(0.06, 0, 0.2, 0)
KeyBox.Size = UDim2.new(0.6, 0, 0.5, 0)
KeyBox.Font = Enum.Font.Gotham
KeyBox.PlaceholderText = "Enter your key here..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(220, 220, 220)
KeyBox.TextSize = 14.000
KeyBox.TextXAlignment = Enum.TextXAlignment.Left

local UICorner_4 = Instance.new("UICorner")
UICorner_4.CornerRadius = UDim.new(0, 4)
UICorner_4.Parent = KeyBox

local SubmitButton = Instance.new("TextButton")
SubmitButton.Name = "SubmitButton"
SubmitButton.Parent = InputFrame
SubmitButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
SubmitButton.BorderSizePixel = 0
SubmitButton.Position = UDim2.new(0.7, 0, 0.2, 0)
SubmitButton.Size = UDim2.new(0.25, 0, 0.5, 0)
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.Text = "LOAD"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextSize = 14.000

local UICorner_5 = Instance.new("UICorner")
UICorner_5.CornerRadius = UDim.new(0, 4)
UICorner_5.Parent = SubmitButton

local function setupButtonHover(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

setupButtonHover(SubmitButton, Color3.fromRGB(80, 160, 80), Color3.fromRGB(100, 180, 100))

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1.0
StatusLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: Waiting for key..."
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 12.000
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Parent = MainFrame
Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0, 0, 0.8, 0)
Divider.Size = UDim2.new(1, 0, 0, 1)

local Footer = Instance.new("Frame")
Footer.Name = "Footer"
Footer.Parent = MainFrame
Footer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Footer.BorderSizePixel = 0
Footer.Position = UDim2.new(0, 0, 0.8, 1)
Footer.Size = UDim2.new(1, 0, 0, 49)

local UICorner_7 = Instance.new("UICorner")
UICorner_7.CornerRadius = UDim.new(0, 8)
UICorner_7.Parent = Footer

local buttonPositions = {
    UDim2.new(0.05, 0, 0.5, -12),
    UDim2.new(0.2, 0, 0.5, -12),
    UDim2.new(0.35, 0, 0.5, -12),
    UDim2.new(0.5, 0, 0.5, -12),
    UDim2.new(0.65, 0, 0.5, -15)
}

local DiscordButton = Instance.new("ImageButton")
DiscordButton.Name = "DiscordButton"
DiscordButton.Parent = Footer
DiscordButton.BackgroundTransparency = 1.0
DiscordButton.Position = buttonPositions[1]
DiscordButton.Size = UDim2.new(0, 24, 0, 24)
DiscordButton.Image = "rbxassetid://7733960981"
DiscordButton.ImageColor3 = Color3.fromRGB(88, 101, 242)

local SaveButton = Instance.new("ImageButton")
SaveButton.Name = "SaveButton"
SaveButton.Parent = Footer
SaveButton.BackgroundTransparency = 1.0
SaveButton.Position = buttonPositions[2]
SaveButton.Size = UDim2.new(0, 24, 0, 24)
SaveButton.Image = "rbxassetid://3926305904"
SaveButton.ImageRectOffset = Vector2.new(164, 124)
SaveButton.ImageRectSize = Vector2.new(36, 36)

local LoadButton = Instance.new("ImageButton")
LoadButton.Name = "LoadButton"
LoadButton.Parent = Footer
LoadButton.BackgroundTransparency = 1.0
LoadButton.Position = buttonPositions[3]
LoadButton.Size = UDim2.new(0, 24, 0, 24)
LoadButton.Image = "rbxassetid://3926305904"
LoadButton.ImageRectOffset = Vector2.new(124, 124)
LoadButton.ImageRectSize = Vector2.new(36, 36)

local CopyButton = Instance.new("ImageButton")
CopyButton.Name = "CopyButton"
CopyButton.Parent = Footer
CopyButton.BackgroundTransparency = 1.0
CopyButton.Position = buttonPositions[4]
CopyButton.Size = UDim2.new(0, 24, 0, 24)
CopyButton.Image = "rbxassetid://3926305904"
CopyButton.ImageRectOffset = Vector2.new(964, 324)
CopyButton.ImageRectSize = Vector2.new(36, 36)

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Name = "GetKeyButton"
GetKeyButton.Parent = Footer
GetKeyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
GetKeyButton.BorderSizePixel = 0
GetKeyButton.Position = buttonPositions[5]
GetKeyButton.Size = UDim2.new(0.25, 0, 0, 30)
GetKeyButton.Font = Enum.Font.GothamBold
GetKeyButton.Text = "GET KEY"
GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyButton.TextSize = 12.000

local UICorner_8 = Instance.new("UICorner")
UICorner_8.CornerRadius = UDim.new(0, 4)
UICorner_8.Parent = GetKeyButton

local function setupIconHover(icon, normalColor, hoverColor, tooltip)
    local Tooltip = Instance.new("TextLabel")
    Tooltip.Name = "Tooltip"
    Tooltip.Parent = icon
    Tooltip.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Tooltip.BorderSizePixel = 0
    Tooltip.Position = UDim2.new(0.5, 0, -1.5, 0)
    Tooltip.Size = UDim2.new(0, 80, 0, 20)
    Tooltip.AnchorPoint = Vector2.new(0.5, 0.5)
    Tooltip.Font = Enum.Font.Gotham
    Tooltip.Text = tooltip
    Tooltip.TextColor3 = Color3.fromRGB(220, 220, 220)
    Tooltip.TextSize = 12.000
    Tooltip.Visible = false
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Tooltip
    
    icon.MouseEnter:Connect(function()
        TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = hoverColor}):Play()
        Tooltip.Visible = true
    end)
    icon.MouseLeave:Connect(function()
        TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = normalColor}):Play()
        Tooltip.Visible = false
    end)
end

setupIconHover(DiscordButton, Color3.fromRGB(88, 101, 242), Color3.fromRGB(108, 121, 255), "Discord")
setupIconHover(SaveButton, Color3.fromRGB(220, 220, 220), Color3.fromRGB(100, 255, 100), "Save Key")
setupIconHover(LoadButton, Color3.fromRGB(220, 220, 220), Color3.fromRGB(100, 200, 255), "Load Key")
setupIconHover(CopyButton, Color3.fromRGB(220, 220, 220), Color3.fromRGB(255, 200, 100), "Copy Script")
setupButtonHover(GetKeyButton, Color3.fromRGB(80, 160, 80), Color3.fromRGB(100, 180, 100))

local gameLoaders = {
    ["126884695634066"] = {
        name = "Grow a Garden",
        loader = "https://api.luarmor.net/files/v3/loaders/b4c256e137c578381032180e15dcc48d.lua"
    },
    ["81440632616906"] = {
        name = "Dig To The Earth's Core",
        loader = "https://api.luarmor.net/files/v3/loaders/c5e7ecc0f71e8e18b15b82749d6f871a.lua"
    },
    ["17589670912"] = {
        name = "Find The Auras [570]",
        loader = "https://api.luarmor.net/files/v3/loaders/04ff6b592db39be535c4502a4cc86e81.lua"
    }
}

local function saveKeyToFile(key)
    if not isfolder("H4xScripts") then
        makefolder("H4xScripts")
    end
    
    local success, err = pcall(function()
        writefile("H4xScripts/keys.txt", HttpService:JSONEncode({
            key = key,
            timestamp = os.time()
        }))
    end)
    
    if success then
        StatusLabel.Text = "Status: Key saved successfully!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        StatusLabel.Text = "Status: Error saving key!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

local function loadKeyFromFile()
    if not isfolder("H4xScripts") or not isfile("H4xScripts/keys.txt") then
        StatusLabel.Text = "Status: No saved key found!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
        return nil
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile("H4xScripts/keys.txt"))
    end)
    
    if success and data.key then
        KeyBox.Text = data.key
        StatusLabel.Text = "Status: Key loaded from save!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        return data.key
    else
        StatusLabel.Text = "Status: Error loading key!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return nil
    end
end

local function runLoader(key)
    script_key = key
    local currentPlaceId = tostring(game.PlaceId)
    local currentGameId = tostring(game.GameId)
    
    local loaderData = gameLoaders[currentPlaceId] or gameLoaders[currentGameId]
    
    if loaderData then
        StatusLabel.Text = "Status: Loading "..loaderData.name.."..."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        local pulseTween = TweenService:Create(
            StatusLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, -1, true),
            {TextTransparency = 0.5}
        )
        pulseTween:Play()
        
        local success, err = pcall(function()
            loadstring(game:HttpGet(loaderData.loader))()
        end)
        
        pulseTween:Cancel()
        StatusLabel.TextTransparency = 0
        
        if not success then
            StatusLabel.Text = "Status: Error loading script!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        else
            StatusLabel.Text = "Status: Script loaded successfully!"
            task.wait(1)
            
            local closeTween = TweenService:Create(
                MainFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quint),
                {Size = UDim2.new(0, 350, 0, 0), Position = UDim2.new(0.5, -175, 0.5, -125)}
            )
            closeTween:Play()
            closeTween.Completed:Wait()
            KeySystem:Destroy()
        end
    else
        StatusLabel.Text = "Status: Unrecognized game ID!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        setclipboard(currentGameId)
    end
end

CloseButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint),
        {Size = UDim2.new(0, 350, 0, 0), Position = UDim2.new(0.5, -175, 0.5, -125)}
    )
    closeTween:Play()
    closeTween.Completed:Wait()
    KeySystem:Destroy()
end)

SubmitButton.MouseButton1Click:Connect(function()
    local key = KeyBox.Text:gsub("%W", "")
    if #key >= 16 then
        TweenService:Create(SubmitButton, TweenInfo.new(0.1), {Size = UDim2.new(0.23, 0, 0.45, 0)}):Play()
        task.wait(0.1)
        TweenService:Create(SubmitButton, TweenInfo.new(0.1), {Size = UDim2.new(0.25, 0, 0.5, 0)}):Play()
        
        runLoader(key)
    else
        StatusLabel.Text = "Status: Invalid key (min 16 chars)"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
        
        local shakeTween = TweenService:Create(
            KeyBox,
            TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 3, true),
            {Position = UDim2.new(0.05, 0, 0.2, 0)}
        )
        shakeTween:Play()
    end
end)

DiscordButton.MouseButton1Click:Connect(function()
    TweenService:Create(DiscordButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 22, 0, 22)}):Play()
    task.wait(0.1)
    TweenService:Create(DiscordButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 24, 0, 24)}):Play()
    
    setclipboard("https://discord.gg/TZ93aSb6Ks")
    StatusLabel.Text = "Status: Discord link copied!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
end)

SaveButton.MouseButton1Click:Connect(function()
    TweenService:Create(SaveButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 22, 0, 22)}):Play()
    task.wait(0.1)
    TweenService:Create(SaveButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 24, 0, 24)}):Play()
    
    local key = KeyBox.Text:gsub("%W", "")
    if #key >= 16 then
        saveKeyToFile(key)
    else
        StatusLabel.Text = "Status: Invalid key (min 16 chars)"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
    end
end)

LoadButton.MouseButton1Click:Connect(function()
    TweenService:Create(LoadButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 22, 0, 22)}):Play()
    task.wait(0.1)
    TweenService:Create(LoadButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 24, 0, 24)}):Play()
    
    loadKeyFromFile()
end)

CopyButton.MouseButton1Click:Connect(function()
    TweenService:Create(CopyButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 22, 0, 22)}):Play()
    task.wait(0.1)
    TweenService:Create(CopyButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 24, 0, 24)}):Play()
    
    local currentGameId = tostring(game.GameId)
    local scriptText = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader2.lua"))()'
    setclipboard(scriptText)
    StatusLabel.Text = "Status: Script copied to clipboard!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
end)

GetKeyButton.MouseButton1Click:Connect(function()
    TweenService:Create(GetKeyButton, TweenInfo.new(0.1), {Size = UDim2.new(0.23, 0, 0, 28)}):Play()
    task.wait(0.1)
    TweenService:Create(GetKeyButton, TweenInfo.new(0.1), {Size = UDim2.new(0.25, 0, 0, 30)}):Play()
    
    setclipboard("https://ads.luarmor.net/get_key?for=H4xScript-KYdlkvTJgNRS")
    StatusLabel.Text = "Status: Key link copied!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

task.spawn(function()
    task.wait(1)
    loadKeyFromFile()
end)
