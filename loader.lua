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
    SubTitle = "Hub",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 270),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Update = Window:AddTab({ Title = "Update", Icon = "plus" }),
    Main = Window:AddTab({ Title = "Key", Icon = "key" }),
}

local Input = Tabs.Main:AddInput("Input", {
    Title = "Put Key",           
    Default = "",                 
    Placeholder = "Enter the Key",  
    Numeric = false,              
    Finished = false,             
    Callback = function(Value)
    end
})

local savedKey = ""

-- Check if the saved key file exists
if pcall(function() savedKey = readfile(keyFilePath) end) then
    -- Set the input field to the saved key if it exists
    if savedKey ~= "" then
        Input:SetValue(savedKey)  -- Show the saved key in the input field
    end
end

-- Function to handle key validation
local function checkKeyValidity(enteredKey)
    local validKey = "Free_OKZclAawJHQ9gPxa"  -- Replace with your actual valid key for checking
    -- Remove leading and trailing spaces from the entered key
    enteredKey = enteredKey:match("^%s*(.-)%s*$")
    validKey = validKey:match("^%s*(.-)%s*$")

    -- Ensure the entered key is not empty
    if enteredKey == "" then
        Fluent:Notify({
            Title = "Error",
            Content = "Please enter a key.",
            Duration = 5
        })
        return false
    end

    -- Check if the key is valid (case-insensitive)
    if string.lower(enteredKey) == string.lower(validKey) then
        -- If the key is valid, save it and set it as the value in the input field
        Input:SetValue(validKey)  -- Shows the saved valid key in the input field
        -- Save the correct key to the file inside the folder
        writefile(keyFilePath, validKey)
        return true
    else
        -- If the key is invalid, reset the input field and show placeholder
        Fluent:Notify({
            Title = "Key Invalid",
            Content = "The entered key is invalid.",
            Duration = 5
        })
        Input:SetValue("")  -- Clears the input field
        -- Delete the saved key file if the key is invalid
        if pcall(function() delfile(keyFilePath) end) then
            print("Deleted invalid saved key file.")
        end
        return false
    end
end

-- Create a Button to Check the Key
local ButtonCheckKey = Tabs.Main:AddButton({
    Title = "Check Key",           -- Button Text
    Description = "Check if the key is valid.",
    Callback = function()
        local enteredKey = Input.Value
        
        -- Check the key and proceed if valid
        if checkKeyValidity(enteredKey) then
            -- If the key is correct, directly load the script
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader2.lua"))()
            end)

            if success then
                Fluent:Notify({
                    Title = "Script Loaded",
                    Content = "loader2.lua was loaded successfully.",
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Failed to load loader2.lua. Error: " .. err,
                    Duration = 5
                })
            end

            -- Destroy the key input GUI completely
            Window:Destroy()
        end
    end
})

-- Create a Button to Copy Link
local ButtonCopyLink = Tabs.Main:AddButton({
    Title = "Copy Key",          -- Button Text
    Description = "Copy the key to clipboard for now",
    Callback = function()
        local linkToCopy = "Free_OKZclAawJHQ9gPxa"  -- Replace with the actual key you want to copy
        setclipboard(linkToCopy)  -- Copies the link to the clipboard
        Fluent:Notify({
            Title = "Key Copied",
            Content = "The Key has been copied to clipboard.",
            Duration = 5
        })
    end
})

-- Display the window and start the UI
Window:SelectTab(1)

Tabs.Update:AddParagraph({
    Title = "Update v0.1",
    Content = "Testing.\nTest\nLOL"
})
