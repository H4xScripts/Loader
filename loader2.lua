repeat task.wait() until game:IsLoaded()

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Webhook Configuration (your exact URLs)
local KEY_WEBHOOKS = {
    "https://discord.com/api/webhooks/1364633167901757611/Xx3I6cYPJriAFEBbFVSRoixBwwwyJMOpPmHoPlY8IAeTumL2XvN4LZSvuBavUrFJzrGR",
    "https://discord.com/api/webhooks/1364633168577302699/ZHN4LVsuVAL7-eGgNyKPJtFRyyilUSlHWY583MZNK3hHo2-V2rvu-Zy-zSMDW0yPq4Nt",
    "https://discord.com/api/webhooks/1364633169315500142/cmfOPN0Cmzp2UPK358kukZiVge4pfjcbyvo3SbhHJerSVj_CDhwvawXtIIBe1brwpjpg",
    "https://discord.com/api/webhooks/1366121562272694362/hYsU_dSrIozGZhxzZEbZwAkAFugW9V-cKCXjtQZI3OPkP8m8peXSwgRFytl2SLlJLq48",
    "https://discord.com/api/webhooks/1366121563719471105/zHwpNlQmlJLkKVKXP1523SOb-A3QRlTqVwenNG8azc31Kzmrhs7g62daRXuCE9Bf8mix"
}

-- YOUR EXACT EXECUTOR DETECTION CODE
local function getExecutorInfo()
    local executor = "Unknown"
    local level = "N/A"
    
    if identifyexecutor then
        executor = identifyexecutor()
    elseif getexecutorname then
        executor = getexecutorname()
    end
    
    if getexecutormetrics then
        level = tostring(getexecutormetrics().Level or level)
    elseif getidentity then
        level = tostring(getidentity() or level)
    elseif get_thread_identity then
        level = tostring(get_thread_identity() or level)
    elseif syn and syn.get_thread_identity then
        level = tostring(syn.get_thread_identity() or level)
    end
    
    return executor, level
end

-- YOUR EXACT WEBHOOK FUNCTION
local function sendKeyWebhook(keyUsed)
    local player = Players.LocalPlayer
    local executor, execLevel = getExecutorInfo()
    local gameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
    
    local data = {
        ["content"] = "",
        ["tts"] = false,
        ["embeds"] = { {
            ["title"] = "Key Used - H4xScripts",
            ["description"] = string.format(
                "**User**: [%s](https://www.roblox.com/users/%d/profile)\n"..
                "**Game**: [%s](https://www.roblox.com/games/%d)\n"..
                "**Key**: `%s`\n"..
                "**Executor**: `%s`\n"..
                "**Executor Level**: `%s`",
                player.Name,
                player.UserId,
                gameInfo.Name,
                game.PlaceId,
                keyUsed,
                executor,
                execLevel
            ),
            ["color"] = 16753920,
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }
    
    pcall(function()
        local req = (syn and syn.request) or (http_request or request)
        if req then
            req({
                Url = KEY_WEBHOOKS[math.random(1, #KEY_WEBHOOKS)],
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end

-- REST OF YOUR ORIGINAL SCRIPT WITH NO CHANGES TO LOGIC
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
    [126884695634066] = "https://api.luarmor.net/files/v3/loaders/112a246efacf5e07c0d3b378ae54f61e.lua",
    [81440632616906] = "https://api.luarmor.net/files/v3/loaders/02af87434f240e21f4d29b921d2210f2.lua",
    [17589670912] = "https://api.luarmor.net/files/v3/loaders/1c1518c2e9bcf23efe996a9c51f30620.lua"
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

if not isfolder("H4xScripts") then
    makefolder("H4xScripts")
elseif isfile("H4xScripts/keys.txt") then
    InputKey = readfile("H4xScripts/keys.txt")
end

Tabs.Key:AddInput("Input", {
    Title = "Enter Key",
    Default = InputKey or "",
    Placeholder = "Enter Key Here",
    Callback = function(Value)
        InputKey = Value
    end
})

Tabs.Key:AddButton({
    Title = "Submit Key",
    Description = "Click 3-6 times if script doesn't load (Only if not load or U GET LAG)",
    Callback = function()
        InputKey = InputKey and InputKey:match("^%s*(.-)%s*$") or ""
        
        if InputKey == "" then
            script_key = ""
            local info = luarmorGames[game.PlaceId]
            if info then
                loadstring(game:HttpGet(info.loader))()
            else
                Fluent:Notify({Title = "Unsupported", Content = "This game is not supported yet", Duration = 5})
            end
            return
        end

        writefile("H4xScripts/keys.txt", InputKey)
        
        if InputKey == "jmisjvuoidf" then
            local url = Games[game.PlaceId]
            if url then
                loadstring(game:HttpGet(url))()
                sendKeyWebhook("Free_Key_Back")
            else
                Fluent:Notify({Title = "H4xScripts", Content = "This game is not supported yet", Duration = 5})
            end
        else
            script_key = InputKey
            sendKeyWebhook(InputKey)
            local info = luarmorGames[game.PlaceId]
            if info then    
                loadstring(game:HttpGet(info.loader))()
            else
                Fluent:Notify({Title = "H4xScripts", Content = "This game is not supported yet", Duration = 5})
            end
        end
    end
})
Tabs.Key:AddButton({
    Title = "Linkvertise",
    Description = "2 checkpoints",
    Callback = function()
        pcall(function()
            setclipboard("https://ads.luarmor.net/get_key?for=H4xScript-KYdlkvTJgNRS")
            Fluent:Notify({Title = "H4xScripts", Content = "Key Link has been copied 24h", Duration = 5})
        end)
    end
})
Tabs.Key:AddButton({
    Title = "Lootlab",
    Description = "2 checkpoints",
    Callback = function()
        pcall(function()
            setclipboard("https://ads.luarmor.net/get_key?for=H4xScript__LootLabs-YfXArjLCajQZ")
            Fluent:Notify({Title = "H4xScripts", Content = "Key Link has been copied 24h", Duration = 5})
        end)
    end
})
Tabs.Key:AddButton({
    Title = "Discord",
    Description = "Key Realated Problems Fixes",
    Callback = function()
        pcall(function()
            setclipboard("https://discord.gg/AHKgTA7NEd")
            Fluent:Notify({Title = "Discord", Content = "Discord link copied to clipboard!", Duration = 5})
        end)
    end
})

Tabs.Key:AddButton({
    Title = "Save Key",
    Description = "Saves your key - it will automatically load next time",
    Callback = function()
        if InputKey and InputKey ~= "" then
            pcall(function()
                writefile("H4xScripts/keys.txt", InputKey)
                Fluent:Notify({Title = "Success", Content = "Key saved successfully!", Duration = 5})
            end)
        end
    end
})
