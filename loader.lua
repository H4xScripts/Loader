repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local folderPath = "H4xScripts/"
local keyFilePath = folderPath .. "key.txt"
local validKey = "Free_OKZclAawJHQ9gPx"

if not isfolder(folderPath) then
    makefolder(folderPath)
end

local function checkSavedKey()
    if isfile(keyFilePath) then
        local savedKey = readfile(keyFilePath)
        if string.lower(savedKey) == string.lower(validKey) then
            return true
        else
            delfile(keyFilePath)
        end
    end
    return false
end

if checkSavedKey() then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader2.lua"))()
    return
end

local Window = Fluent:CreateWindow({
    Title = "H4xScripts",
    SubTitle = "Universal Key",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 270),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Universal-KeySystem", Icon = "key" }),
    Update = Window:AddTab({ Title = "Update", Icon = "plus" }),
    Games = Window:AddTab({ Title = "Games", Icon = "plus" }),
}

local Input = Tabs.Main:AddInput("Input", {
    Title = "Enter Key",
    Default = "",
    Placeholder = "Paste your key here",
    Numeric = false,
    Finished = false
})

if isfile(keyFilePath) then
    Input:SetValue(readfile(keyFilePath))
end

local function verifyKey(inputKey)
    inputKey = inputKey:gsub("%s+", "")
    if string.lower(inputKey) == string.lower(validKey) then
        writefile(keyFilePath, validKey)
        return true
    end
    return false
end

Tabs.Main:AddButton({
    Title = "Validate Key",
    Description = "Check if your key is valid",
    Callback = function()
        if verifyKey(Input.Value) then
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader2.lua"))()
        else
            Fluent:Notify({
                Title = "Invalid Key",
                Content = "The key you entered is incorrect",
                Duration = 5
            })
        end
    end
})

Tabs.Main:AddButton({
    Title = "Copy Key",
    Description = "Copy the valid key to clipboard",
    Callback = function()
        setclipboard(validKey)
        Fluent:Notify({
            Title = "Key Copied",
            Content = "The key has been copied to your clipboard",
            Duration = 3
        })
    end
})

Tabs.Update:AddParagraph({
    Title = "Update v0.1",
    Content = "🔰Hospital Tycoon🔰\n - ✅Auto Collect\n - ✅Auto Purchase\n - ✅Fixed Auto Purchase"
})

Tabs.Games:AddParagraph({
    Title = "New Games Added",
    Content = "+ Hospital Tycoon\n +Legends Of Speed ⚡"
})
