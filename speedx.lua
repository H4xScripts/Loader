-- Speed Hub X UI Library.
-- only the Window, Tab, Section, Label and Button is included.



local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Original AFK function (keeping as it's separate from UI)
task.spawn(function()
pcall(function()
if game.Placeid = 17574618959 then
if game.Workspace:FindFirstChild("RobloxForwardPortals") then
game.Workspace.RobloxForwardPortals:Destroy()
end
end
-- Removed loadstring for simplicity, as it's external code
-- loadstring(game:HttpGet("https://github.com/isMoons/isMoons/blob/main/adspeedhub.lua"))()
end)
end)

local Custom = {} do
Custom.ColorRGB = Color3.fromRGB(250, 7, 7)

function Custom:Create(Name, Properties, Parent)
local _instance = Instance.new(Name)

for i, v in pairs(Properties) do  
  _instance[i] = v  
end  

if Parent then  
  _instance.Parent = Parent  
end  

return _instance

end

function Custom:EnabledAFK()
Player.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
end
end

Custom:EnabledAFK()

local function OpenClose()
local ScreenGui = Custom:Create("ScreenGui", {
Name = "OpenClose",
ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, RunService:IsStudio() and Player.PlayerGui or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")))

local Close_ImageButton = Custom:Create("ImageButton", {
BackgroundColor3 = Color3.fromRGB(0, 0, 0),
BorderColor3 = Color3.fromRGB(255, 0, 0),
Position = UDim2.new(0.1021, 0, 0.0743, 0),
Size = UDim2.new(0, 59, 0, 49),
Image = "rbxassetid://82140212012109",
Visible = false -- Will be set to true by the 'Min' button
}, ScreenGui)

Custom:Create("UICorner", {
Name = "MainCorner",
CornerRadius = UDim.new(0, 9),
}, Close_ImageButton)

local dragging, dragStart, startPos = false, nil, nil

local function UpdateDraggable(input)
local delta = input.Position - dragStart
Close_ImageButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Close_ImageButton.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
dragStart = input.Position
startPos = Close_ImageButton.Position

input.Changed:Connect(function()  
    if input.UserInputState == Enum.UserInputState.End then  
      dragging = false  
    end  
  end)  
end

end)

Close_ImageButton.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
UpdateDraggable(input)
end
end)

return Close_ImageButton
end

local Open_Close = OpenClose()

local function MakeDraggable(topbarobject, object)
local dragging, dragStart, startPos = false, nil, nil

local function UpdatePos(input)
local delta = input.Position - dragStart
local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
object.Position = newPos
end

topbarobject.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = object.Position

input.Changed:Connect(function()  
    if input.UserInputState == Enum.UserInputState.End then  
      dragging = false  
    end  
  end)  
end

end)

topbarobject.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
UpdatePos(input)
end
end)
end

function CircleClick(Button, X, Y)
task.spawn(function()
Button.ClipsDescendants = true

local Circle = Instance.new("ImageLabel")  
Circle.Image = "rbxassetid://266543268"  
Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)  
Circle.ImageTransparency = 0.8999999761581421  
Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  
Circle.BackgroundTransparency = 1  
Circle.ZIndex = 10  
Circle.Name = "Circle"  
Circle.Parent = Button  

local NewX = X - Button.AbsolutePosition.X  
local NewY = Y - Button.AbsolutePosition.Y  
Circle.Position = UDim2.new(0, NewX, 0, NewY)  

local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5  

local Time = 0.5  
local TweenInfo = TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)  

local Tween = TweenService:Create(Circle, TweenInfo, {  
  Size = UDim2.new(0, Size, 0, Size),  
  Position = UDim2.new(0.5, -Size/2, 0.5, -Size/2)  
})  

Tween:Play()  

Tween.Completed:Connect(function()  
  for i = 1, 10 do  
    Circle.ImageTransparency = Circle.ImageTransparency + 0.01  
    wait(Time / 10)  
  end  
  Circle:Destroy()  
end)

end)
end

local Speed_Library = {}

Speed_Library.Unloaded = false

function Speed_Library:CreateWindow(Config)
local Title = Config[1] or Config.Title or ""
local Description = Config[2] or Config.Description or ""
local TabWidth = Config[3] or Config["Tab Width"] or 120 -- Keeping this for the tab frame, but it's fixed now
local SizeUi = Config[4] or Config.SizeUi or UDim2.fromOffset(550, 315)

local SpeedHubXGui = Custom:Create("ScreenGui", {
Name = "SpeedHubXGui",
ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, RunService:IsStudio() and Player.PlayerGui or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")))

local DropShadowHolder = Custom:Create("Frame", {
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = UDim2.new(0, 455, 0, 350), -- Initial size, will be updated
ZIndex = 0,
Name = "DropShadowHolder",
Position = UDim2.new(0, (SpeedHubXGui.AbsoluteSize.X // 2 - 455 // 2), 0, (SpeedHubXGui.AbsoluteSize.Y // 2 - 350 // 2))
}, SpeedHubXGui)

local DropShadow = Custom:Create("ImageLabel", {
Image = "rbxassetid://6015897843",
ImageColor3 = Color3.fromRGB(15, 15, 15),
ImageTransparency = 0.5,
ScaleType = Enum.ScaleType.Slice,
SliceCenter = Rect.new(49, 49, 450, 450),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Position = UDim2.new(0.5, 0, 0.5, 0),
Size = SizeUi,
ZIndex = 0,
Name = "DropShadow"
}, DropShadowHolder)

local Main = Custom:Create("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.fromRGB(15, 15, 15),
BackgroundTransparency = 0.1,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0.5, 0, 0.5, 0),
Size = SizeUi,
Name = "Main"
}, DropShadow)

Custom:Create("UICorner", {}, Main)

Custom:Create("UIStroke", {
Color = Color3.fromRGB(50, 50, 50),
Thickness = 1.6
}, Main)

local Top = Custom:Create("Frame", {
BackgroundColor3 = Color3.fromRGB(0, 0, 0),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 38),
Name = "Top"
}, Main)

local TextLabel = Custom:Create("TextLabel", {
Font = Enum.Font.GothamBold,
Text = Title,
TextColor3 = Color3.fromRGB(255, 255, 255),
TextSize = 14,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Size = UDim2.new(1, -100, 1, 0),
Position = UDim2.new(0, 10, 0, 0)
}, Top)

Custom:Create("UICorner", {}, Top)

local TextLabel1 = Custom:Create("TextLabel", {
Font = Enum.Font.GothamBold,
Text = Description,
TextColor3 = Custom.ColorRGB,
TextSize = 14,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0),
Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
}, Top)

Custom:Create("UIStroke", {
Color = Custom.ColorRGB,
Thickness = 0.4
}, TextLabel1)

local Close = Custom:Create("TextButton", {
Font = Enum.Font.SourceSans,
Text = "",
TextColor3 = Color3.fromRGB(0, 0, 0),
TextSize = 14,
AnchorPoint = Vector2.new(1, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(1, -8, 0.5, 0),
Size = UDim2.new(0, 25, 0, 25),
Name = "Close"
}, Top)

local ImageLabel1 = Custom:Create("ImageLabel", {
Image = "rbxassetid://9886659671",
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0.49, 0, 0.5, 0),
Size = UDim2.new(1, -8, 1, -8)
}, Close)

local Min = Custom:Create("TextButton", {
Font = Enum.Font.SourceSans,
Text = "",
TextColor3 = Color3.fromRGB(0, 0, 0),
TextSize = 14,
AnchorPoint = Vector2.new(1, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(1, -42, 0.5, 0),
Size = UDim2.new(0, 25, 0, 25),
Name = "Min"
}, Top)

Custom:Create("ImageLabel", {
Image = "rbxassetid://9886659276",
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 1,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0.5, 0, 0.5, 0),
Size = UDim2.new(1, -8, 1, -8)
}, Min)

local LayersTab = Custom:Create("Frame", {
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0, 9, 0, 50),
Size = UDim2.new(0, TabWidth, 1, -59),
Name = "LayersTab"
}, Main)

Custom:Create("UICorner", {
CornerRadius = UDim.new(0, 2)
}, LayersTab)

-- This frame acts as the tab content area for the single tab
local Layers = Custom:Create("Frame", {
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0, TabWidth + 18, 0, 50),
Size = UDim2.new(1, -(TabWidth + 9 + 18), 1, -59),
Name = "Layers" -- This is the content area for our single tab
}, Main)

Custom:Create("UICorner", {
CornerRadius = UDim.new(0, 2)
}, Layers)

local NameTab = Custom:Create("TextLabel", {
Font = Enum.Font.GothamBold,
Text = "Single Tab", -- Set the tab name directly
TextColor3 = Color3.fromRGB(255, 255, 255),
TextSize = 24,
TextWrapped = true,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 30),
Name = "NameTab"
}, Layers)

local LayersReal = Custom:Create("Frame", {
AnchorPoint = Vector2.new(0, 1),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
ClipsDescendants = true,
Position = UDim2.new(0, 0, 1, 0),
Size = UDim2.new(1, 0, 1, -33),
Name = "LayersReal"
}, Layers)

local LayersFolder = Custom:Create("Folder", {
Name = "LayersFolder"
}, LayersReal)

-- UIPageLayout is still needed, but only for a single "page"
local LayersPageLayout = Custom:Create("UIPageLayout", {
SortOrder = Enum.SortOrder.LayoutOrder,
Name = "LayersPageLayout",
TweenTime = 0.5,
EasingDirection = Enum.EasingDirection.InOut,
EasingStyle = Enum.EasingStyle.Quad
}, LayersFolder)

-- This scrolling frame will contain the single tab's content
local ScrollTab = Custom:Create("ScrollingFrame", {
CanvasSize = UDim2.new(0, 0, 0, 0), -- Will be updated dynamically
ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
ScrollBarThickness = 0,
Active = true,
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, -10),
Name = "ScrollTab"
}, LayersTab)

Custom:Create("UIListLayout", {
Padding = UDim.new(0, 0),
SortOrder = Enum.SortOrder.LayoutOrder
}, ScrollTab)

local function UpdateScrollTabSize()
local _Total = 0
for _, v in pairs(ScrollTab:GetChildren()) do
if v.Name ~= "UIListLayout" then
_Total = _Total + 3 + v.Size.Y.Offset
end
end
ScrollTab.CanvasSize = UDim2.new(0, 0, 0, _Total)
end

ScrollTab.ChildAdded:Connect(UpdateScrollTabSize)
ScrollTab.ChildRemoved:Connect(UpdateScrollTabSize)

Min.Activated:Connect(function()
CircleClick(Min, Player:GetMouse().X, Player:GetMouse().Y)
DropShadowHolder.Visible = false
if not Open_Close.Visible then Open_Close.Visible = true end
end)

Open_Close.Activated:Connect(function()
DropShadowHolder.Visible = true
if Open_Close.Visible then Open_Close.Visible = false end
end)

Close.Activated:Connect(function()
CircleClick(Close, Player:GetMouse().X, Player:GetMouse().Y)
if SpeedHubXGui then SpeedHubXGui:Destroy() end
if not Speed_Library.Unloaded then Speed_Library.Unloaded = true end
end)

DropShadowHolder.Size = UDim2.new(0, 115 + TextLabel.TextBounds.X + 1 + TextLabel1.TextBounds.X, 0, 350)
MakeDraggable(Top, DropShadowHolder)

--- /// Create the single Tab and its content directly
local SingleTabContentFrame = Custom:Create("ScrollingFrame", {
ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
ScrollBarThickness = 0,
Active = true,
LayoutOrder = 0, -- This is the only tab, so LayoutOrder is 0
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.999,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0),
Name = "SingleTabContent", -- Renamed for clarity
Parent = LayersFolder
})

Custom:Create("UIListLayout", {
Padding = UDim.new(0, 3),
SortOrder = Enum.SortOrder.LayoutOrder,
Parent = SingleTabContentFrame
})

local TabUI = Custom:Create("Frame", {
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.92, -- This is the currently active tab
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
LayoutOrder = 0, -- First and only tab
Size = UDim2.new(1, 0, 0, 30),
Name = "Tab",
Parent = ScrollTab
})

Custom:Create("UICorner", {
CornerRadius = UDim.new(0, 4),
Parent = TabUI
})

local TabButton = Custom:Create("TextButton", {
Font = Enum.Font.GothamBold,
Text = "",
TextColor3 = Color3.fromRGB(255, 255, 255),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.999,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0),
Name = "TabButton",
}, TabUI)

Custom:Create("TextLabel", {
Font = Enum.Font.GothamBold,
Text = "Main", -- Label for the single tab
TextColor3 = Color3.fromRGB(255, 255, 255),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.999,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0),
Position = UDim2.new(0, 30, 0, 0),
Name = "TabName",
}, TabUI)

Custom:Create("ImageLabel", {
Image = "rbxassetid://4973307613", -- Example icon (replace with yours)
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.999,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0, 9, 0, 7),
Size = UDim2.new(0, 16, 0, 16),
Name = "FeatureImg",
}, TabUI)

-- Always choose the first (and only) tab
LayersPageLayout:JumpToIndex(0)
NameTab.Text = "Home"

local ChooseFrame = Custom:Create("Frame", {
BackgroundColor3 = Custom.ColorRGB,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0, 2, 0, 9),
Size = UDim2.new(0, 1, 0, 12),
Name = "ChooseFrame",
}, TabUI)

Custom:Create("UIStroke", {
Color = Custom.ColorRGB,
Thickness = 1.6,
}, ChooseFrame)

Custom:Create("UICorner", {}, ChooseFrame)

-- Simulate a section for the button within the single tab
local Section = Custom:Create("Frame", {
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.999,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
ClipsDescendants = true,
LayoutOrder = 0, -- First item in the tab content
Size = UDim2.new(1, 0, 0, 30), -- Initial size, will expand
Name = "Home"
}, SingleTabContentFrame)

local SectionReal = Custom:Create("Frame", {
AnchorPoint = Vector2.new(0.5, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.935,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
LayoutOrder = 1,
Position = UDim2.new(0.5, 0, 0, 0),
Size = UDim2.new(1, 1, 0, 30),
Name = "SectionReal"
}, Section)

Custom:Create("UICorner", {
CornerRadius = UDim.new(0, 4)
}, SectionReal)

local SectionTitle = Custom:Create("TextLabel", {
Font = Enum.Font.GothamBold,
Text = "Actions", -- Section title for the button
TextColor3 = Color3.fromRGB(230, 230, 230),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
AnchorPoint = Vector2.new(0, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
Position = UDim2.new(0, 10, 0.5, 0),
Size = UDim2.new(1, -50, 0, 13),
Name = "SectionTitle"
}, SectionReal)

local SectionAdd = Custom:Create("Frame", {
AnchorPoint = Vector2.new(0.5, 0),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.9990000128746033,
BorderColor3 = Color3.fromRGB(0, 0, 0),
BorderSizePixel = 0,
ClipsDescendants = true,
LayoutOrder = 1,
Position = UDim2.new(0.5, 0, 0, 38),
Size = UDim2.new(1, 0, 0, 100), -- Initial size, will expand
Name = "SectionAdd"
}, Section)

Custom:Create("UICorner", {
CornerRadius = UDim.new(0, 2)
}, SectionAdd)

Custom:Create("UIListLayout", {
Padding = UDim.new(0, 3),
SortOrder = Enum.SortOrder.LayoutOrder
}, SectionAdd)

local function UpdateSectionSizeForButton()
local SectionSizeYWitdh = 38
for _, v in pairs(SectionAdd:GetChildren()) do
if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
SectionSizeYWitdh = SectionSizeYWitdh + v.Size.Y.Offset + 3
end
end
TweenService:Create(Section, TweenInfo.new(0.1), {Size = UDim2.new(1, 1, 0, SectionSizeYWitdh)}):Play()
TweenService:Create(SectionAdd, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, SectionSizeYWitdh - 38)}):Play()
task.wait(0.5)
-- This update applies to the content frame of the single tab
local OffsetY = 0
for _, child in pairs(SingleTabContentFrame:GetChildren()) do
if child.Name ~= "UIListLayout" then
OffsetY = OffsetY + 3 + child.Size.Y.Offset
end
end
SingleTabContentFrame.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
end

-- Add a single button
local Button = Custom:Create("Frame", {
Name = "Button",
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.935,
BorderSizePixel = 0,
LayoutOrder = 0, -- First (and only) item in the section
Size = UDim2.new(1, 0, 0, 35)
}, SectionAdd)

Custom:Create("UICorner", {
CornerRadius = UDim.new(0, 4)
}, Button)

Custom:Create("TextLabel", {
Name = "ButtonTitle",
Font = Enum.Font.GothamBold,
Text = "Perform Action", -- Button Title
TextColor3 = Color3.fromRGB(231, 231, 231),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.999,
BorderSizePixel = 0,
Position = UDim2.new(0, 10, 0, 10),
Size = UDim2.new(1, -100, 0, 13)
}, Button)

local ButtonContent = Custom:Create("TextLabel", {
Name = "ButtonContent",
Font = Enum.Font.GothamBold,
Text = "Click this button to do something!", -- Button Description
TextColor3 = Color3.fromRGB(255, 255, 255),
TextSize = 12,
TextTransparency = 0.6,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Bottom,
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.999,
BorderSizePixel = 0,
Position = UDim2.new(0, 10, 0, 23),
Size = UDim2.new(1, -100, 0, 12)
}, Button)

local function UpdateButtonSize()
local _Height = 12 + (12 * (ButtonContent.TextBounds.X // ButtonContent.AbsoluteSize.X))
ButtonContent.Size = UDim2.new(1, -100, 0, _Height)

Button.Size = UDim2.new(1, 0, 0, ButtonContent.AbsoluteSize.Y + 33)

end

ButtonContent.TextWrapped = true
UpdateButtonSize()

ButtonContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
ButtonContent.TextWrapped = false
UpdateButtonSize()
ButtonContent.TextWrapped = true
UpdateSectionSizeForButton() -- Call to update the section size
end)

local ButtonButton = Custom:Create("TextButton", {
Name = "ButtonButton",
Font = Enum.Font.SourceSans,
Text = "",
TextColor3 = Color3.fromRGB(0, 0, 0),
TextSize = 14,
BackgroundColor3 = Color3.fromRGB(0, 0, 0),
BackgroundTransparency = 0.999,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0)
}, Button)

local FeatureFrame1 = Custom:Create("Frame", {
Name = "FeatureFrame",
AnchorPoint = Vector2.new(1, 0.5),
BackgroundColor3 = Color3.fromRGB(0, 0, 0),
BackgroundTransparency = 0.999,
BorderSizePixel = 0,
Position = UDim2.new(1, -15, 0.5, 0),
Size = UDim2.new(0, 25, 0, 25)
}, Button)

Custom:Create("ImageLabel", {
Name = "FeatureImg",
Image = "rbxassetid://16932740082", -- Example icon for the button
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
BackgroundTransparency = 0.999,
BorderSizePixel = 0,
Position = UDim2.new(0.5, 0, 0.5, 0),
Size = UDim2.new(1, 0, 1, 0)
}, FeatureFrame1)

ButtonButton.Activated:Connect(function()
CircleClick(ButtonButton, Player:GetMouse().X, Player:GetMouse().Y)
-- Your button's action goes here
warn("Button clicked!")
end)

-- Initial update for the section size after adding the button
UpdateSectionSizeForButton()

return {
-- Return the main GUI element so you can display it
GUI = SpeedHubXGui
}
end

-- Example of how to use the simplified UI
local UI = Speed_Library:CreateWindow({
Title = "Speed Hub X | Version: 3.0 | discord.gg/speedhub",
Description = ""
})

-- Make the GUI visible
UI.GUI.Enabled = true
