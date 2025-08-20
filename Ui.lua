-- Stealth UI Library - Undetectable Roblox GUI Framework
-- Designed to avoid common detection methods

local StealthLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Utility functions for stealth
local function randomString(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. string.sub(chars, rand, rand)
    end
    return result
end

local function createStealthFrame(parent, props)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Name = randomString(8)
    
    for prop, value in pairs(props or {}) do
        frame[prop] = value
    end
    
    return frame
end

local function createStealthTextLabel(parent, props)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Name = randomString(6)
    
    for prop, value in pairs(props or {}) do
        label[prop] = value
    end
    
    return label
end

local function createStealthTextButton(parent, props)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Name = randomString(7)
    
    for prop, value in pairs(props or {}) do
        button[prop] = value
    end
    
    return button
end

local function createStealthTextBox(parent, props)
    local textbox = Instance.new("TextBox")
    textbox.Parent = parent
    textbox.Name = randomString(9)
    
    for prop, value in pairs(props or {}) do
        textbox[prop] = value
    end
    
    return textbox
end

-- Main UI Library
function StealthLib:Window(title, color)
    local windowData = {
        Title = title or "Window",
        Color = color or Color3.fromRGB(50, 50, 50),
        Tabs = {},
        MainGui = nil,
        MainFrame = nil,
        TabContainer = nil,
        ContentContainer = nil,
        CurrentTab = nil
    }
    
    -- Create main GUI with random name
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = randomString(12)
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    windowData.MainGui = screenGui
    
    -- Main window frame
    local mainFrame = createStealthFrame(screenGui, {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    
    windowData.MainFrame = mainFrame
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Title bar
    local titleBar = createStealthFrame(mainFrame, {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = windowData.Color,
        BorderSizePixel = 0
    })
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Title text
    local titleLabel = createStealthTextLabel(titleBar, {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = windowData.Title,
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        Font = Enum.Font.GothamBold
    })
    
    -- Close button
    local closeButton = createStealthTextButton(titleBar, {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundColor3 = Color3.new(0.8, 0.2, 0.2),
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        Font = Enum.Font.GothamBold
    })
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab container
    local tabContainer = createStealthFrame(mainFrame, {
        Size = UDim2.new(0, 120, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Color3.new(0.08, 0.08, 0.08),
        BorderSizePixel = 0
    })
    
    windowData.TabContainer = tabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabContainer
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    
    -- Content container
    local contentContainer = createStealthFrame(mainFrame, {
        Size = UDim2.new(1, -120, 1, -30),
        Position = UDim2.new(0, 120, 0, 30),
        BackgroundColor3 = Color3.new(0.12, 0.12, 0.12),
        BorderSizePixel = 0
    })
    
    windowData.ContentContainer = contentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = contentContainer
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 5)
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.Parent = contentContainer
    
    -- Window methods
    function windowData:Tab(name)
        local tabData = {
            Name = name,
            Button = nil,
            Content = nil,
            Elements = {},
            Window = windowData
        }
        
        -- Create tab button
        local tabButton = createStealthTextButton(windowData.TabContainer, {
            Size = UDim2.new(1, -4, 0, 30),
            BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
            Text = name,
            TextColor3 = Color3.new(0.8, 0.8, 0.8),
            TextScaled = true,
            Font = Enum.Font.Gotham
        })
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4)
        tabCorner.Parent = tabButton
        
        tabData.Button = tabButton
        
        -- Create tab content
        local tabContent = createStealthFrame(windowData.ContentContainer, {
            Size = UDim2.new(1, -20, 1, -20),
            BackgroundTransparency = 1,
            Visible = false
        })
        
        tabData.Content = tabContent
        
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = randomString(10)
        scrollFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.Parent = tabContent
        
        local scrollLayout = Instance.new("UIListLayout")
        scrollLayout.Parent = scrollFrame
        scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
        scrollLayout.Padding = UDim.new(0, 5)
        
        -- Auto-resize scrolling frame
        scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab button click
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(windowData.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
            end
            
            -- Show this tab
            tabContent.Visible = true
            tabButton.BackgroundColor3 = windowData.Color
            windowData.CurrentTab = tabData
        end)
        
        -- Tab methods
        function tabData:Button(text, callback)
            local button = createStealthTextButton(scrollFrame, {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = windowData.Color,
                Text = text,
                TextColor3 = Color3.new(1, 1, 1),
                TextScaled = true,
                Font = Enum.Font.Gotham
            })
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = button
            
            button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
            
            table.insert(tabData.Elements, button)
            return button
        end
        
        function tabData:Toggle(text, callback)
            local toggleFrame = createStealthFrame(scrollFrame, {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
                BorderSizePixel = 0
            })
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 4)
            toggleCorner.Parent = toggleFrame
            
            local toggleLabel = createStealthTextLabel(toggleFrame, {
                Size = UDim2.new(1, -40, 1, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.new(1, 1, 1),
                TextScaled = true,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local toggleButton = createStealthTextButton(toggleFrame, {
                Size = UDim2.new(0, 30, 0, 20),
                Position = UDim2.new(1, -35, 0.5, -10),
                BackgroundColor3 = Color3.new(0.8, 0.2, 0.2),
                Text = "",
                BorderSizePixel = 0
            })
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 10)
            buttonCorner.Parent = toggleButton
            
            local isToggled = false
            
            toggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                toggleButton.BackgroundColor3 = isToggled and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.2, 0.2)
                
                if callback then
                    callback(isToggled)
                end
            end)
            
            table.insert(tabData.Elements, toggleFrame)
            return toggleFrame
        end
        
        function tabData:Slider(text, min, max, default, callback)
            local sliderFrame = createStealthFrame(scrollFrame, {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
                BorderSizePixel = 0
            })
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 4)
            sliderCorner.Parent = sliderFrame
            
            local sliderLabel = createStealthTextLabel(sliderFrame, {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = text .. ": " .. tostring(default),
                TextColor3 = Color3.new(1, 1, 1),
                TextScaled = true,
                Font = Enum.Font.Gotham
            })
            
            local sliderBackground = createStealthFrame(sliderFrame, {
                Size = UDim2.new(1, -20, 0, 10),
                Position = UDim2.new(0, 10, 0, 30),
                BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
                BorderSizePixel = 0
            })
            
            local sliderBgCorner = Instance.new("UICorner")
            sliderBgCorner.CornerRadius = UDim.new(0, 5)
            sliderBgCorner.Parent = sliderBackground
            
            local sliderFill = createStealthFrame(sliderBackground, {
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = windowData.Color,
                BorderSizePixel = 0
            })
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(0, 5)
            sliderFillCorner.Parent = sliderFill
            
            local currentValue = default
            local dragging = false
            
            local function updateSlider(input)
                local relativeX = math.clamp((input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
                currentValue = min + (relativeX * (max - min))
                currentValue = math.floor(currentValue + 0.5)
                
                sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                sliderLabel.Text = text .. ": " .. tostring(currentValue)
                
                if callback then
                    callback(currentValue)
                end
            end
            
            sliderBackground.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            table.insert(tabData.Elements, sliderFrame)
            return sliderFrame
        end
        
        function tabData:Dropdown(text, options, callback)
            local dropdownFrame = createStealthFrame(scrollFrame, {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
                BorderSizePixel = 0
            })
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 4)
            dropdownCorner.Parent = dropdownFrame
            
            local dropdownButton = createStealthTextButton(dropdownFrame, {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = text .. ": " .. (options[1] or "None"),
                TextColor3 = Color3.new(1, 1, 1),
                TextScaled = true,
                Font = Enum.Font.Gotham
            })
            
            local dropdownList = createStealthFrame(scrollFrame, {
                Size = UDim2.new(1, 0, 0, #options * 25),
                Position = UDim2.new(0, 0, 0, 35),
                BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 10
            })
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 4)
            listCorner.Parent = dropdownList
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Parent = dropdownList
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local currentOption = options[1]
            
            for _, option in pairs(options) do
                local optionButton = createStealthTextButton(dropdownList, {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = Color3.new(0.18, 0.18, 0.18),
                    Text = option,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextScaled = true,
                    Font = Enum.Font.Gotham
                })
                
                optionButton.MouseButton1Click:Connect(function()
                    currentOption = option
                    dropdownButton.Text = text .. ": " .. option
                    dropdownList.Visible = false
                    
                    if callback then
                        callback(option)
                    end
                end)
            end
            
            dropdownButton.MouseButton1Click:Connect(function()
                dropdownList.Visible = not dropdownList.Visible
            end)
            
            table.insert(tabData.Elements, dropdownFrame)
            return dropdownFrame
        end
        
        function tabData:Textbox(placeholder, multiline, callback)
            local textboxFrame = createStealthFrame(scrollFrame, {
                Size = UDim2.new(1, 0, 0, multiline and 60 or 30),
                BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
                BorderSizePixel = 0
            })
            
            local textboxCorner = Instance.new("UICorner")
            textboxCorner.CornerRadius = UDim.new(0, 4)
            textboxCorner.Parent = textboxFrame
            
            local textbox = createStealthTextBox(textboxFrame, {
                Size = UDim2.new(1, -10, 1, -10),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundTransparency = 1,
                Text = "",
                PlaceholderText = placeholder,
                TextColor3 = Color3.new(1, 1, 1),
                PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7),
                TextScaled = not multiline,
                TextWrapped = multiline,
                MultiLine = multiline,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
            })
            
            textbox.FocusLost:Connect(function(enterPressed)
                if callback then
                    callback(textbox.Text)
                end
            end)
            
            table.insert(tabData.Elements, textboxFrame)
            return textboxFrame
        end
        
        table.insert(windowData.Tabs, tabData)
        
        -- Auto-select first tab
        if #windowData.Tabs == 1 then
            tabButton.MouseButton1Click()
        end
        
        return tabData
    end
    
    return windowData
end

-- Essential functions for the script to work
local function noclip()
    for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

-- Teleport function
function urbantp2(position, speed)
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local distance = (hrp.Position - position).Magnitude
    
    if distance < 5 then
        hrp.CFrame = CFrame.new(position)
        return
    end
    
    local tweenInfo = TweenInfo.new(
        distance / (speed or 100),
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut
    )
    
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(position)})
    tween:Play()
end

-- Look at function
_G.urbantplookat = nil
task.spawn(function()
    while true do
        if _G.urbantplookat then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local lookDirection = (_G.urbantplookat - hrp.Position).Unit
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + Vector3.new(lookDirection.X, 0, lookDirection.Z))
            end
        end
        task.wait(0.1)
    end
end)

-- Mouse click function
function Mouse11()
    local VirtualUser = game:service('VirtualUser')
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(100000, 100000))
end

-- Proximity prompt fire function
function fireproximityprompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration or 0)
        prompt:InputHoldEnd()
    end
end

-- Anti-AFK system
task.spawn(function()
    local vu = game:GetService('VirtualUser')
    game:GetService('Players').LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Speed monitoring system
task.spawn(function()
    local PlrSpeed = 16
    while true do
        pcall(function()
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                local currentSpeed = character.Humanoid.WalkSpeed
                if currentSpeed ~= PlrSpeed and PlrSpeed > 16 then
                    character.Humanoid.WalkSpeed = PlrSpeed
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- Camera improvements
task.spawn(function()
    pcall(function()
        -- Max Zoom fix
        game.Players.LocalPlayer.CameraMaxZoomDistance = 1000
        
        -- Noclip camera
        local Players = game:GetService('Players')
        local LocalPlayer = Players.LocalPlayer
        local PopperClient = LocalPlayer:WaitForChild('PlayerScripts').PlayerModule.CameraModule.ZoomController.Popper
        
        for i, v in next, getgc() do
            if getfenv(v).script == PopperClient and typeof(v) == 'function' then
                for i2, v2 in next, debug.getconstants(v) do
                    if tonumber(v2) == 0.25 then
                        debug.setconstant(v, i2, 0)
                    elseif tonumber(v2) == 0 then
                        debug.setconstant(v, i2, 0.25)
                    end
                end
            end
        end
        
        -- Initial noclip
        for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v.ClassName == 'Part' or v.ClassName == 'MeshPart' then
                v.CanCollide = false
            end
        end
    end)
end)

-- Infinite Jump system
local InfJump = false
local InfJumpStarted = nil

-- Speed control system  
local PlrSpeed = 16
task.spawn(function()
    while true do
        pcall(function()
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                if character.Humanoid.WalkSpeed ~= PlrSpeed then
                    character.Humanoid.WalkSpeed = PlrSpeed
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- Make it globally accessible
getgenv().Lib = StealthLib
getgenv().noclip = noclip
getgenv().urbantp2 = urbantp2
getgenv().Mouse11 = Mouse11
getgenv().fireproximityprompt = fireproximityprompt

return StealthLib
