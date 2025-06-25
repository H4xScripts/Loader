-- credits: dawid
local HttpService = game:GetService("HttpService")

local ConfigManager
ConfigManager = {
    Window = nil,
    Folder = nil,
    Path = nil,
    Configs = {},
    Parser = {
        Colorpicker = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Default:ToHex(),
                    transparency = obj.Transparency or nil,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Update(Color3.fromHex(data.value), data.transparency or nil)
                end
            end
        },
        Dropdown = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Select(data.value)
                end
            end
        },
        Input = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        },
        Keybind = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        },
        Slider = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value.Default,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                end
            end
        },
        Toggle = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element then
                    element:Set(data.value)
                    if element.Callback then
                        element.Callback(data.value)
                    end
                end
            end
        },
    }
}

function ConfigManager:Init(Window)
    if Window.Folder then
        ConfigManager.Window = Window
        ConfigManager.Folder = Window.Folder
        
        ConfigManager.Path = "WindUI/" .. ConfigManager.Folder .. "/config/"
        
        return ConfigManager
    end
    return false
end

function ConfigManager:CreateConfig(configFilename)
    local ConfigModule = {
        Path = ConfigManager.Path .. configFilename .. ".json",
        
        Elements = {}
    }
    
    if not configFilename then
        return false, "No config file is selected"
    end

    function ConfigModule:Register(Name, Element)
        ConfigModule.Elements[Name] = Element
    end
    
    function ConfigModule:Save()
        local saveData = {
            Elements = {}
        }
        
        for name,i in next, ConfigModule.Elements do
            if ConfigManager.Parser[i.__type] then
                saveData.Elements[tostring(name)] = ConfigManager.Parser[i.__type].Save(i)
            end
        end
        
        print(HttpService:JSONEncode(saveData))
        
        writefile(ConfigModule.Path, HttpService:JSONEncode(saveData))
    end
    
    function ConfigModule:Load()
        if not isfile(ConfigModule.Path) then return false, "Invalid file" end
        
        local loadData = HttpService:JSONDecode(readfile(ConfigModule.Path))
        
        for name, data in next, loadData.Elements do
            if ConfigModule.Elements[name] and ConfigManager.Parser[data.__type] then
                task.spawn(function()
                    ConfigManager.Parser[data.__type].Load(ConfigModule.Elements[name], data)
                end)
            end
        end
        
    end
    
    
    ConfigManager.Configs[configFilename] = ConfigModule
    
    return ConfigModule
end

function ConfigManager:AllConfigs()
    if listfiles then
        local files = {}
        for _, file in next, listfiles(ConfigManager.Path) do
            local name = file:match("([^\\/]+)%.json$")
            if name then
                table.insert(files, name)
            end
        end
        
        return files
    end
    return false
end

return ConfigManager
