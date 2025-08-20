--========================================================
-- 🔒 Stealth UI Library (Obfuscated Paths & Names)
--========================================================
local StealthUI = {}
StealthUI.__index = StealthUI

-- random string generator
local function randomString(len)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local str = ""
    for i = 1, len do
        str = str .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
    end
    return str
end

-- Create root ScreenGui in CoreGui
local CoreGui = game:GetService("CoreGui")
local rootGui = Instance.new("ScreenGui")
rootGui.Name = randomString(16)
rootGui.Parent = CoreGui
rootGui.ResetOnSpawn = false

--========================================================
-- Window
--========================================================
function StealthUI:Window(title, size)
    local win = {}
    win._internalName = randomString(16)

    local frame = Instance.new("Frame")
    frame.Name = randomString(16)
    frame.Size = UDim2.new(0, size.X, 0, size.Y)
    frame.Position = UDim2.new(0.5, -size.X/2, 0.5, -size.Y/2)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.Parent = rootGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = randomString(16)
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    titleLabel.Size = UDim2.new(1,0,0,30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = frame

    win.Frame = frame
    win.Tabs = {}

    --====================================================
    -- Tab Creation
    --====================================================
    function win:Tab(tabName)
        local tab = {}
        tab._internalName = randomString(16)

        local tabFrame = Instance.new("Frame")
        tabFrame.Name = randomString(16)
        tabFrame.Size = UDim2.new(1,0,1,-30)
        tabFrame.Position = UDim2.new(0,0,0,30)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = frame

        tab.Frame = tabFrame
        tab.Elements = {}

        -- Button
        function tab:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Name = randomString(16)
            btn.Text = text
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 16
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Size = UDim2.new(1,-10,0,30)
            btn.Position = UDim2.new(0,5,0,#tab.Elements*35)
            btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
            btn.Parent = tabFrame

            btn.MouseButton1Click:Connect(function()
                if callback then
                    pcall(callback)
                end
            end)

            table.insert(tab.Elements, btn)
        end

        -- Toggle
        function tab:Toggle(text, callback)
            local toggle = Instance.new("TextButton")
            toggle.Name = randomString(16)
            toggle.Text = "[ ] " .. text
            toggle.Font = Enum.Font.SourceSans
            toggle.TextSize = 16
            toggle.TextColor3 = Color3.new(1,1,1)
            toggle.Size = UDim2.new(1,-10,0,30)
            toggle.Position = UDim2.new(0,5,0,#tab.Elements*35)
            toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
            toggle.Parent = tabFrame

            local state = false
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = (state and "[✔] " or "[ ] ") .. text
                if callback then
                    pcall(callback,state)
                end
            end)

            table.insert(tab.Elements, toggle)
        end

        table.insert(win.Tabs, tab)
        return tab
    end

    -- Switch tabs
    function win:ShowTab(tab)
        for _,t in pairs(win.Tabs) do
            t.Frame.Visible = false
        end
        tab.Frame.Visible = true
    end

    return win
end

--========================================================
-- Example Usage
--========================================================
local UI = setmetatable({}, StealthUI)

local win = UI:Window("Main Window", Vector2.new(300,300))

local tab1 = win:Tab("Main")
tab1:Button("Auto Equip", function()
    print("Auto Equip pressed!")
end)

tab1:Toggle("God Mode", function(state)
    print("God Mode:", state)
end)

local tab2 = win:Tab("Extra")
tab2:Button("Kill All", function()
    print("Kill All pressed!")
end)

win:ShowTab(tab1)
