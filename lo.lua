local SimpleUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local function tween(obj, props, info)
    info = info or TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

function SimpleUI:CreateWindow(WindowSettings)
    WindowSettings = {
        Name = WindowSettings.Name or "SimpleUI",
        Subtitle = WindowSettings.Subtitle or "",
        LogoID = WindowSettings.LogoID or "",
        LoadingEnabled = WindowSettings.LoadingEnabled or false,
        LoadingTitle = WindowSettings.LoadingTitle or "Loading",
        LoadingSubtitle = WindowSettings.LoadingSubtitle or "",
        ConfigSettings = WindowSettings.ConfigSettings or { RootFolder = "", ConfigFolder = "SimpleUI" },
        Bind = WindowSettings.Bind or Enum.KeyCode.F6
    }

    local SimpleUI = Instance.new("ScreenGui")
    SimpleUI.Name = "SimpleUI"
    SimpleUI.Parent = CoreGui
    SimpleUI.IgnoreGuiInset = true

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.Parent = SimpleUI

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main

    local dragBar = Instance.new("Frame")
    dragBar.Size = UDim2.new(1, 0, 0, 30)
    dragBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dragBar.Parent = Main

    local UICornerDrag = Instance.new("UICorner")
    UICornerDrag.CornerRadius = UDim.new(0, 8)
    UICornerDrag.Parent = dragBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 5, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowSettings.Name .. " | " .. WindowSettings.Subtitle
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Font = Enum.Font.SourceSansBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = dragBar

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -30, 0, 0)
    Close.BackgroundTransparency = 1
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 14
    Close.Font = Enum.Font.SourceSansBold
    Close.Parent = dragBar

    local Navigation = Instance.new("Frame")
    Navigation.Size = UDim2.new(0, 150, 1, -30)
    Navigation.Position = UDim2.new(0, 0, 0, 30)
    Navigation.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Navigation.BackgroundTransparency = 0.1
    Navigation.Parent = Main

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -150, 1, -30)
    TabContainer.Position = UDim2.new(0, 150, 0, 30)
    TabContainer.BackgroundTransparency = 1
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 4
    TabContainer.Parent = Main

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = TabContainer

    local Window = { Tabs = {}, CurrentTab = nil, State = true, Bind = WindowSettings.Bind }

    local dragging, dragInput, dragStart, startPos
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    Close.MouseButton1Click:Connect(function()
        SimpleUI.Enabled = false
        Window.State = false
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == WindowSettings.Bind then
            SimpleUI.Enabled = not SimpleUI.Enabled
            Window.State = SimpleUI.Enabled
        end
    end)

    if WindowSettings.LoadingEnabled then
        local LoadingScreen = Instance.new("Frame")
        LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
        LoadingScreen.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        LoadingScreen.BackgroundTransparency = 0.2
        LoadingScreen.Parent = SimpleUI

        local LoadingTitle = Instance.new("TextLabel")
        LoadingTitle.Size = UDim2.new(0.5, 0, 0, 50)
        LoadingTitle.Position = UDim2.new(0.25, 0, 0.4, 0)
        LoadingTitle.BackgroundTransparency = 1
        LoadingTitle.Text = WindowSettings.LoadingTitle
        LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        LoadingTitle.TextSize = 24
        LoadingTitle.Font = Enum.Font.SourceSansBold
        LoadingTitle.Parent = LoadingScreen

        local LoadingSubtitle = Instance.new("TextLabel")
        LoadingSubtitle.Size = UDim2.new(0.5, 0, 0, 30)
        LoadingSubtitle.Position = UDim2.new(0.25, 0, 0.5, 0)
        LoadingSubtitle.BackgroundTransparency = 1
        LoadingSubtitle.Text = WindowSettings.LoadingSubtitle
        LoadingSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        LoadingSubtitle.TextSize = 18
        LoadingSubtitle.Font = Enum.Font.SourceSans
        LoadingSubtitle.Parent = LoadingScreen

        task.wait(2)
        tween(LoadingScreen, {BackgroundTransparency = 1})
        tween(LoadingTitle, {TextTransparency = 1})
        tween(LoadingSubtitle, {TextTransparency = 1})
        task.wait(0.5)
        LoadingScreen:Destroy()
    end

    function Window:CreateTab(TabSettings)
        TabSettings = {
            Name = TabSettings.Name or "Tab",
            Icon = TabSettings.Icon or "home",
            ImageSource = TabSettings.ImageSource or "Material",
            ShowTitle = TabSettings.ShowTitle or true
        }

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.BackgroundTransparency = 0.25
        TabButton.Text = TabSettings.ShowTitle and TabSettings.Name or ""
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.Parent = Navigation

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -12)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = TabSettings.ImageSource == "Material" and SimpleUI.MaterialIcons[TabSettings.Icon] or "rbxassetid://" .. TabSettings.Icon
        TabIcon.Parent = TabButton

        local TabPage = Instance.new("Frame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.Parent = TabContainer

        local Tab = { Page = TabPage }
        Window.Tabs[TabSettings.Name] = Tab

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
            end
            TabPage.Visible = true
            Window.CurrentTab = TabSettings.Name
        end)

        if not Window.CurrentTab then
            TabPage.Visible = true
            Window.CurrentTab = TabSettings.Name
        end

        function Tab:CreateSection(SectionName)
            local Section = Instance.new("Frame")
            Section.Size = UDim2.new(1, -10, 0, 30)
            Section.Position = UDim2.new(0, 5, 0, 0)
            Section.BackgroundTransparency = 1
            Section.Parent = TabPage

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, 0, 1, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = SectionName or "Section"
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 16
            SectionTitle.Font = Enum.Font.SourceSansBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section

            TabContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
            return Section
        end

        return Tab
    end

    function Window:CreateHomeTab(HomeSettings)
        HomeSettings = {
            SupportedExecutors = HomeSettings.SupportedExecutors or {},
            DiscordInvite = HomeSettings.DiscordInvite or "",
            Icon = HomeSettings.Icon or "home"
        }

        local HomeTab = Window:CreateTab({Name = "Home", Icon = HomeSettings.Icon, ImageSource = "Material", ShowTitle = true})
        local Section = HomeTab:CreateSection("Home")

        local WelcomeLabel = Instance.new("TextLabel")
        WelcomeLabel.Size = UDim2.new(1, -10, 0, 50)
        WelcomeLabel.BackgroundTransparency = 1
        WelcomeLabel.Text = "Welcome to " .. WindowSettings.Name
        WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        WelcomeLabel.TextSize = 18
        WelcomeLabel.Font = Enum.Font.SourceSansBold
        WelcomeLabel.TextWrapped = true
        WelcomeLabel.Parent = HomeTab.Page

        if HomeSettings.DiscordInvite ~= "" then
            local DiscordButton = Instance.new("TextButton")
            DiscordButton.Size = UDim2.new(1, -10, 0, 30)
            DiscordButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            DiscordButton.Text = "Join Discord"
            DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DiscordButton.TextSize = 14
            DiscordButton.Font = Enum.Font.SourceSans
            DiscordButton.Parent = HomeTab.Page
            DiscordButton.MouseButton1Click:Connect(function()
                print("Discord Invite: " .. HomeSettings.DiscordInvite)
            end)
        end

        TabContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        return HomeTab
    end

    SimpleUI.MaterialIcons = {
        home = "http://www.roblox.com/asset/?id=6026568195",
        view_in_ar = "http://www.roblox.com/asset/?id=6031079158"
    }

    return Window
end

function SimpleUI:Destroy()
    self.Parent:Destroy()
end

return SimpleUI
