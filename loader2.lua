repeat task.wait() until game:IsLoaded()

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local HttpService = game:GetService("HttpService")

local Window = Fluent:CreateWindow({
    Title = "H4xScripts",
    SubTitle = "Key System",
    TabWidth = 110,
    Size = UDim2.fromOffset(450, 340),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Key = Window:AddTab({Title = "Key System", Icon = "key"})
}

Window:SelectTab(1)

local Games = {
    [14996478064] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/Hospital%20Tycoon.lua",
    [6875469709] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/StrongestPunchSimulator.lua",
    [7215881810] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/NoLimitStrongestPunchSimulator.lua",
    [17589670912] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/Find%20The%20Auras",
    [126884695634066] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/Grow%20a%20Garden.lua",
    [81440632616906] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/Dig%20to%20Earth's%20CORE!",
    [101268431471855] = "https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/Find%20The%20Hamster%20%5B326%5D.lua"
}

local luarmorGames = {
    [126884695634066] = {
        name = "Grow a Garden",
        loader = "https://api.luarmor.net/files/v3/loaders/b4c256e137c578381032180e15dcc48d.lua"
    },
    [81440632616906] = {
        name = "Dig To The Earth's Core",
        loader = "https://api.luarmor.net/files/v3/loaders/c5e7ecc0f71e8e18b15b82749d6f871a.lua"
    },
    [17589670912] = {
        name = "Find The Auras [570]",
        loader = "https://api.luarmor.net/files/v3/loaders/04ff6b592db39be535c4502a4cc86e81.lua"
    }
}

local InputKey

Tabs.Key:AddInput("Input", {
    Title = "Enter Key",
    Default = "",
    Placeholder = "Enter Key Here",
    Callback = function(Value)
        InputKey = Value
    end
})

Tabs.Key:AddButton({
    Title = "Submit Key",
    Description = "Click 3-6 times if script doesn’t load",
    Callback = function()
        -- Trim spaces from the key
        InputKey = InputKey and InputKey:match("^%s*(.-)%s*$") or ""

        if InputKey == "Free_Key" then
            local url = Games[game.PlaceId]
            if url then
                loadstring(game:HttpGet(url))()
            else
                Fluent:Notify({Title = "Unsupported", Content = "Game not in Free_Key list", Duration = 5})
            end
        else
            script_key = InputKey
            local info = luarmorGames[game.PlaceId]
            if info then
                loadstring(game:HttpGet(info.loader))()
            else
                Fluent:Notify({Title = "Unsupported", Content = "Game not in Luarmor list", Duration = 5})
            end
        end
    end
})

Tabs.Key:AddButton({
    Title = "Discord",
    Description = "Free key in Dc + 24h KeySystem too Max 48",
    Callback = function()
        pcall(function()
            setclipboard("https://discord.gg/AHKgTA7NEd")
        end)
    end
})
Tabs.Key:AddButton({
    Title = "Save Key",
    Description = "Saves you key it will automatically load next time u run script",
    Callback = function()
        if InputKey and InputKey ~= "" then
            pcall(function()
                writefile("H4xScripts/keys.txt", InputKey)
            end)
        end
    end
})

Tabs.Key:AddParagraph({
    Title = "Key Info",
    Content = "We switched key system to Discord!\nReset HWID, fix errors, and get support in our server."
})
