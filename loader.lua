repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Define the folder path for saving the key
local folderPath = "H4xScripts/"
local keyFilePath = folderPath .. "key.txt"

-- Create the folder if it doesn't exist
if not isfolder(folderPath) then
    makefolder(folderPath)
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
    Games = Window:AddTab({ Title = "Games", Icon = "plus" }),
    Main = Window:AddTab({ Title = "Univsersal-KeySystem", Icon = "key" }),
}

Window:SelectTab(Tabs.Main) -- Ensure "Key" tab is selected first

local Input = Tabs.Main:AddInput("Input", {
    Title = "Put Key",           
    Default = "",                 
    Placeholder = "Enter the Key",  
    Numeric = false,             
    Finished = false,           
    Callback = function(Value) end
})

local savedKey = ""
if pcall(function() savedKey = readfile(keyFilePath) end) and savedKey ~= "" then
    Input:SetValue(savedKey)  -- Set saved key if it exists
end

local function checkKeyValidity(enteredKey)
    local validKey = "Free_OKZclAawJHQ9gPxa"
    enteredKey = enteredKey:match("^%s*(.-)%s*$")
    validKey = validKey:match("^%s*(.-)%s*$")

    if enteredKey == "" then
        Fluent:Notify({ Title = "Error", Content = "Please enter a key.", Duration = 5 })
        return false
    end
    
    if string.lower(enteredKey) == string.lower(validKey) then
        Input:SetValue(validKey)
        writefile(keyFilePath, validKey)
        return true
    else
        Fluent:Notify({ Title = "Key Invalid", Content = "The entered key is invalid.", Duration = 5 })
        Input:SetValue("")  -- Clear input field
        pcall(function() delfile(keyFilePath) end)
        return false
    end
end

Tabs.Main:AddButton({
    Title = "Check Key",
    Description = "Check if the key is valid.",
    Callback = function()
        local enteredKey = Input.Value
        if checkKeyValidity(enteredKey) then
            Window:Destroy()  -- Hide the key UI immediately
            
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader2.lua"))()
            end)
            
            if success then
                Fluent:Notify({ Title = "Script Loaded", Content = "loader2.lua was loaded successfully.", Duration = 5 })
            else
                Fluent:Notify({ Title = "Error", Content = "Failed to load script: " .. err, Duration = 5 })
            end
        end
    end
})

Tabs.Main:AddButton({
    Title = "Copy Key",
    Description = "Copy the key to clipboard.",
    Callback = function()
        setclipboard("Free_OKZclAawJHQ9gPxa")
        Fluent:Notify({ Title = "Key Copied", Content = "The key has been copied to clipboard.", Duration = 5 })
    end
})

Tabs.Games:AddParagraph({
    Title = "New Games Added",
    Content = " + Hospital Tycoon\n + Legends Of Speed ⚡\n + Strongest Punch Simulator \n + Find The Auras"
})
