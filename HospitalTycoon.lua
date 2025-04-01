local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "H4xScripts",
    SubTitle = "Hospital Tycoon",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 270),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "locate" }),
}
Window:SelectTab(1)

local autoCollectEnabled = false

local Toggle = Tabs.Main:AddToggle("Auto Collect Cash", {
    Title = "Auto Collect Cash",
    Default = false,
    Callback = function(Value)
        autoCollectEnabled = Value
        if autoCollectEnabled then
            spawn(function()
                while autoCollectEnabled do
                    wait(1.5)
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteCalls"):WaitForChild("GameSpecific"):WaitForChild("Main"):WaitForChild("CollectIncome"):InvokeServer()
                end
            end)
        end
    end
})

local Toggle = Tabs.Main:AddToggle("Auto Build", {
    Title = "Auto Purchase",
    Default = false,
    Callback = function(Value)
        _G.AutoPurchase = Value
        if Value then
            print("[AutoPurchase] Started!")
            AutoBuy()
        else
            print("[AutoPurchase] Stopped!")
        end
    end
})

function ConvertPrice(priceText)
    priceText = priceText:lower():gsub("[^%d%.kmbt]", "")
    local multiplier = 1
    if priceText:find("k") then
        priceText = priceText:gsub("k", "")
        multiplier = 1000
    elseif priceText:find("m") then
        priceText = priceText:gsub("m", "")
        multiplier = 1000000
    elseif priceText:find("b") then
        priceText = priceText:gsub("b", "")
        multiplier = 1000000000
    elseif priceText:find("t") then
        priceText = priceText:gsub("t", "")
        multiplier = 1000000000000
    end
    return tonumber(priceText) and tonumber(priceText) * multiplier or nil
end

function AutoBuy()
    while _G.AutoPurchase do
        local tycoon = workspace.Important.Tycoons["1"]
        local buttonsFolder = tycoon.Important.Buttons
        local buyablesFolder = tycoon.Important.Buyables
        local playerCash = game:GetService("Players").LocalPlayer.DataSave.Common.General.Stats.Cash.Value
        local highestBought = 0
        for _, boughtButton in pairs(buyablesFolder:GetChildren()) do
            local buttonID = tonumber(boughtButton.Name)
            if buttonID and buttonID > highestBought then
                highestBought = buttonID
            end
        end
        local nextButtonID = highestBought + 1
        local nextButton = buttonsFolder:FindFirstChild(tostring(nextButtonID))
        if nextButton then
            local priceLabel = nextButton:FindFirstChild("Display")
                and nextButton.Display:FindFirstChild("BillboardGui")
                and nextButton.Display.BillboardGui:FindFirstChild("Objects")
                and nextButton.Display.BillboardGui.Objects:FindFirstChild("Objects")
                and nextButton.Display.BillboardGui.Objects.Objects:FindFirstChild("Objects")
                and nextButton.Display.BillboardGui.Objects.Objects.Objects:FindFirstChild("TextLabel")
            if priceLabel and priceLabel:IsA("TextLabel") then
                local buttonPrice = ConvertPrice(priceLabel.Text)
                if buttonPrice then
                    print("[AutoPurchase] Next Button: " .. nextButtonID .. " | Price: " .. buttonPrice .. " | Your Cash: " .. playerCash)
                    if playerCash >= buttonPrice then
                        local args = { nextButtonID }
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteCalls")
                            :WaitForChild("GameSpecific"):WaitForChild("Buttons")
                            :WaitForChild("DefaultBuy"):InvokeServer(unpack(args))
                        print("[AutoPurchase] Bought Button: " .. nextButtonID)
                    else
                        print("[AutoPurchase] Not enough cash to buy " .. nextButtonID .. ". Waiting for more cash...")
                        repeat
                            wait(1)
                            playerCash = game:GetService("Players").LocalPlayer.DataSave.Common.General.Stats.Cash.Value
                        until playerCash >= buttonPrice
                        print("[AutoPurchase] Enough cash to buy Button: " .. nextButtonID)
                    end
                else
                    print("[AutoPurchase] Could not read price for button " .. nextButtonID .. ". Price text: " .. priceLabel.Text)
                end
            else
                print("[AutoPurchase] PriceLabel missing for button " .. nextButtonID)
            end
        else
            print("[AutoPurchase] No more buttons to buy!")
        end
        wait(1)
    end
end
