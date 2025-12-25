-- Optional: Configure before loading (this is completely optional)
getgenv().MelatoninUIConfig = {
    LibraryName = "Melatonin",
    Theme = {
        PrimaryBG = Color3.fromRGB(31, 33, 41),
        SecondaryBG = Color3.fromRGB(25, 25, 30),
        Accent = Color3.fromRGB(158, 150, 222),
        Text = Color3.fromRGB(190, 190, 195),
        TextHover = Color3.fromRGB(205, 206, 212),
        Stroke = Color3.fromRGB(40, 40, 45),
        GameName = Color3.fromRGB(133, 127, 187)
    },
    Logos = {
        MelaLogo = "rbxassetid://137737556913730",
        LoadingLogo = "rbxassetid://137737556913730"
    }
}

-- Load the module
local Melatonin, MelatoninUI, MelatoninGameFrame = loadstring(game:HttpGet("https://raw.githubusercontent.com/Urbanstormm/Project-Stark/main/Melatonin.lua"))()

-- Get LocalPlayer
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Run the loader
Melatonin.LoadingEffect(3, LocalPlayer, {
    {
        GameName = "CS:2 External",
        Image = "rbxassetid://108227353249963",
        SubTime = "30 days",
        Status = "Undetected",
        Url = "",
        Callback = function(frame, ui)
            print("Selected:", frame.Name)
            Melatonin.CloseGuiEffect(ui) -- 'ui' is the correct parameter here
        end
    },
    {
        GameName = "Roblox External",
        Image = "rbxassetid://127821495684337",
        SubTime = "30 days",
        Status = "Updated 11/23/2025",
        Url = "https://api.luarmor.net/files/v3/loaders/a7bf1d042a5757c984086fc4efa90c79.lua"
    },
    {
        GameName = "CS:S External",
        Image = "rbxassetid://96680069022364",
        SubTime = "30 days",
        Status = "Updated 11/23/2025",
        Url = "https://api.luarmor.net/files/v3/loaders/a7bf1d042a5757c984086fc4efa90c79.lua",
        Properties = {
            ImageLabel = {
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            },
            UpdateStatus = {
                TextSize = 12
            }
        }
    }
}, MelatoninUI, MelatoninGameFrame)
