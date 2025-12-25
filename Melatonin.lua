-- Obfuscation Shim (Simplified)
if not LPH_OBFUSCATED then
    local passthrough = function(...) return ... end
    LPH_JIT, LPH_JIT_MAX, LPH_NO_VIRTUALIZE, LPH_ENCSTR, LPH_ENCNUM = passthrough, passthrough, passthrough, passthrough, passthrough
    LPH_NO_UPVALUES = function(f) return function(...) return f(...) end end
    LPH_CRASH = function() end
    
    LRM_SecondsLeft, LRM_ScriptVersion, LRM_UserNote = "-1", "1.0.1", "You are so sigma"
    LRM_LinkedDiscordID, LRM_TotalExecutions, LRM_IsUserPremium, Type = "Nil", 99, true, "[Developer]"
end

if not game:IsLoaded() then game.Loaded:Wait() end

-- Services
local Services = {
    UserInput = cloneref(game:GetService("UserInputService")),
    RunService = cloneref(game:GetService("RunService")),
    Tween = cloneref(game:GetService("TweenService")),
    Players = cloneref(game:GetService("Players"))
}
local LocalPlayer = Services.Players.LocalPlayer

-- Configuration
local Config = {
    Name = "Melatonin",
    TweenTime = 0.25,
    Theme = {
        Primary = Color3.fromRGB(31, 33, 41),
        Secondary = Color3.fromRGB(25, 25, 30),
        Tertiary = Color3.fromRGB(23, 26, 31),
        Accent = Color3.fromRGB(158, 150, 222),
        Text = Color3.fromRGB(190, 190, 195),
        TextHover = Color3.fromRGB(205, 206, 212),
        Stroke = Color3.fromRGB(40, 40, 45),
        GameName = Color3.fromRGB(133, 127, 187)
    },
    Logo = "rbxassetid://137737556913730"
}

-- Utility Functions
local function Create(class, props, children)
    local instance = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then instance[k] = v end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    if props and props.Parent then instance.Parent = props.Parent end
    return instance
end

local function Tween(instance, props, duration, style, direction)
    local info = TweenInfo.new(duration or Config.TweenTime, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local tween = Services.Tween:Create(instance, info, props)
    tween:Play()
    return tween
end

-- UI Container Setup
local MelatoninFolder = Create("Folder", {Name = "MelatoninFolder", Parent = game.CoreGui})
local ModuleContainer = Create("ModuleScript", {Name = "Melatonin", Parent = MelatoninFolder})

-- Main UI Creation
local function CreateMainUI()
    local mainGui = Create("ScreenGui", {
        Name = "Melatonin",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = ModuleContainer,
        Enabled = false
    })
    
    local mainFrame = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Config.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(358, 297),
        Parent = mainGui
    })
    
    -- Top Bar
    local topBar = Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Config.Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        Parent = mainFrame
    }, {
        Create("Frame", {
            Name = "AccentLine",
            BackgroundColor3 = Config.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2)
        }),
        Create("TextLabel", {
            Name = "Title",
            Font = Enum.Font.Ubuntu,
            Text = Config.Name,
            TextColor3 = Config.Theme.Text,
            TextSize = 15,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(0, 80, 1, 0)
        }),
        Create("TextButton", {
            Name = "Close",
            Font = Enum.Font.Ubuntu,
            Text = "×",
            TextColor3 = Config.Theme.Text,
            TextSize = 20,
            TextTransparency = 0.4,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -30, 0, 0),
            Size = UDim2.fromOffset(30, 34)
        })
    })
    
    -- Games List
    local gamesHolder = Create("ScrollingFrame", {
        Name = "GamesHolder",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Config.Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        TopImage = "",
        BottomImage = "",
        MidImage = "rbxassetid://7445543667",
        BackgroundColor3 = Config.Theme.Tertiary,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(7, 41),
        Size = UDim2.fromOffset(344, 213),
        ClipsDescendants = true,
        Parent = mainFrame
    }, {
        Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2)}),
        Create("UIStroke", {Color = Config.Theme.Stroke, Thickness = 1})
    })
    
    -- Load Button
    local loadFrame = Create("Frame", {
        Name = "LoadFrame",
        BackgroundColor3 = Config.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(7, 262),
        Size = UDim2.fromOffset(344, 28),
        Parent = mainFrame
    }, {
        Create("UIStroke", {Color = Config.Theme.Stroke}),
        Create("TextButton", {
            Name = "Load",
            Font = Enum.Font.Ubuntu,
            Text = "Load",
            TextColor3 = Config.Theme.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0)
        })
    })
    
    return mainGui
end

-- Loading UI Creation
local function CreateLoadingUI()
    local loadingGui = Create("ScreenGui", {
        Name = "MelatoninLoading",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = ModuleContainer,
        Enabled = false
    })
    
    local window = Create("Frame", {
        Name = "LoadingWindow",
        BackgroundColor3 = Config.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(148, 133),
        Parent = loadingGui
    })
    
    -- Top Bar
    Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Config.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 27),
        Parent = window
    }, {
        Create("TextLabel", {
            Font = Enum.Font.Ubuntu,
            Text = Config.Name,
            TextColor3 = Config.Theme.Text,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(0, 80, 1, 0)
        }),
        Create("Frame", {
            Name = "AccentLine",
            BackgroundColor3 = Config.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2)
        }),
        Create("Frame", {
            Name = "LoadBarBG",
            BackgroundColor3 = Config.Theme.Secondary,
            BorderSizePixel = 0,
            Position = UDim2.new(0.12, 0, 1, 8),
            Size = UDim2.new(0.76, 0, 0, 3)
        }, {
            Create("Frame", {
                Name = "LoadBar",
                BackgroundColor3 = Config.Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 0, 1, 0)
            }, {
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
        })
    })
    
    -- Logo
    Create("ImageLabel", {
        Name = "Logo",
        Image = Config.Logo,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(65, 55),
        Parent = window
    })
    
    return loadingGui
end

-- Game Frame Template
local function CreateGameFrameTemplate()
    local frame = Create("Frame", {
        Name = "GameFrame",
        BackgroundColor3 = Config.Theme.Tertiary,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -4, 0, 49),
        ClipsDescendants = true
    })
    
    Create("ImageLabel", {
        Name = "Icon",
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(6, 4),
        Size = UDim2.fromOffset(40, 41),
        Parent = frame
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
    
    Create("TextLabel", {
        Name = "GameName",
        Font = Enum.Font.UbuntuBold,
        RichText = true,
        TextColor3 = Config.Theme.GameName,
        TextSize = 14,
        TextTransparency = 0.4,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(54, 4),
        Size = UDim2.new(1, -120, 0, 22),
        Parent = frame
    })
    
    Create("TextLabel", {
        Name = "Status",
        Font = Enum.Font.Ubuntu,
        RichText = true,
        TextColor3 = Config.Theme.Text,
        TextSize = 13,
        TextTransparency = 0.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(54, 24),
        Size = UDim2.new(1, -120, 0, 18),
        Parent = frame
    })
    
    Create("TextLabel", {
        Name = "SubTime",
        Font = Enum.Font.SourceSans,
        TextColor3 = Config.Theme.TextHover,
        TextSize = 13,
        TextTransparency = 0.5,
        BackgroundColor3 = Config.Theme.Primary,
        BackgroundTransparency = 0.5,
        Position = UDim2.new(1, -68, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(62, 24),
        Parent = frame
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 3)})})
    
    return frame
end

-- Initialize UI Elements
local MainUI = CreateMainUI()
local LoadingUI = CreateLoadingUI()
local GameFrameTemplate = CreateGameFrameTemplate()

-- Melatonin Library
local Melatonin = {}
local LoaderHandler = {
    MainUI = MainUI,
    LoadingUI = LoadingUI,
    GameFrame = GameFrameTemplate,
    FrameData = {}
}

local ActiveFrame, ActiveTargets = nil, nil

-- Hover Styles
local Styles = {
    Enter = {
        Frame = {BackgroundTransparency = 0},
        GameName = {TextTransparency = 0, TextColor3 = Config.Theme.GameName},
        Status = {TextTransparency = 0.2},
        SubTime = {TextTransparency = 0.2, BackgroundTransparency = 0.3},
        Icon = {ImageTransparency = 0}
    },
    Leave = {
        Frame = {BackgroundTransparency = 0.25},
        GameName = {TextTransparency = 0.4, TextColor3 = Config.Theme.Text},
        Status = {TextTransparency = 0.5},
        SubTime = {TextTransparency = 0.5, BackgroundTransparency = 0.5},
        Icon = {ImageTransparency = 0.4}
    }
}

function Melatonin.ApplyStyle(targets, style, duration)
    for name, props in pairs(style) do
        local instance = targets[name]
        if instance then
            Tween(instance, props, duration)
        end
    end
end

function Melatonin.SetupFrameInteraction(frame)
    local targets = {
        Frame = frame,
        GameName = frame:FindFirstChild("GameName"),
        Status = frame:FindFirstChild("Status"),
        SubTime = frame:FindFirstChild("SubTime"),
        Icon = frame:FindFirstChild("Icon")
    }
    
    frame.MouseEnter:Connect(function()
        if ActiveFrame ~= frame then
            Melatonin.ApplyStyle(targets, Styles.Enter, 0.15)
        end
    end)
    
    frame.MouseLeave:Connect(function()
        if ActiveFrame ~= frame then
            Melatonin.ApplyStyle(targets, Styles.Leave, 0.2)
        end
    end)
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if ActiveFrame and ActiveFrame ~= frame then
                Melatonin.ApplyStyle(ActiveTargets, Styles.Leave, 0.15)
            end
            ActiveFrame, ActiveTargets = frame, targets
            Melatonin.ApplyStyle(targets, Styles.Enter, 0.1)
            
            -- Click ripple effect
            local ripple = Create("Frame", {
                BackgroundColor3 = Config.Theme.Accent,
                BackgroundTransparency = 0.7,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 3, 0.8, 0),
                Parent = frame
            }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            
            Tween(ripple, {Size = UDim2.new(0, 5, 1, 0), BackgroundTransparency = 0.5}, 0.15)
            task.delay(0.15, function()
                Tween(ripple, {BackgroundTransparency = 1}, 0.3).Completed:Once(function()
                    ripple:Destroy()
                end)
            end)
        end
    end)
end

function Melatonin.SetupButtonHover(button, hoverProps, normalProps)
    button.MouseEnter:Connect(function()
        Tween(button, hoverProps, 0.12)
    end)
    button.MouseLeave:Connect(function()
        Tween(button, normalProps, 0.15)
    end)
end

function Melatonin.CloseUI(screenGui)
    if not screenGui then return end
    
    local descendants = screenGui:GetDescendants()
    local tweens = {}
    
    -- Staggered fade out
    for i, obj in ipairs(descendants) do
        local delay = i * 0.008
        task.delay(delay, function()
            if obj:IsA("GuiObject") then
                local props = {BackgroundTransparency = 1}
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    props.TextTransparency = 1
                end
                if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    props.ImageTransparency = 1
                end
                table.insert(tweens, Tween(obj, props, 0.3, Enum.EasingStyle.Quad))
            elseif obj:IsA("UIStroke") then
                table.insert(tweens, Tween(obj, {Transparency = 1}, 0.3))
            end
        end)
    end
    
    task.delay(#descendants * 0.008 + 0.35, function()
        screenGui:Destroy()
    end)
end

function Melatonin.MakeDraggable(frame)
    if not frame then return end
    
    local dragging, dragStart, startPos = false, nil, nil
    local dragConnection
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = Services.UserInput:GetMouseLocation()
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragConnection = Services.RunService.RenderStepped:Connect(function(dt)
        if dragging and startPos then
            local mouse = Services.UserInput:GetMouseLocation()
            local delta = mouse - dragStart
            local viewport = workspace.CurrentCamera.ViewportSize
            local size = frame.AbsoluteSize
            
            local newX = math.clamp(startPos.X.Offset + delta.X, 0, viewport.X - size.X)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, viewport.Y - size.Y)
            
            -- Smooth interpolation
            local currentPos = frame.Position
            local targetPos = UDim2.fromOffset(newX, newY)
            frame.Position = currentPos:Lerp(targetPos, math.min(1, dt * 25))
        end
    end)
end

function Melatonin.Load(duration, frameConfigs, callback)
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Clone and show loading UI
    local loadingClone = LoadingUI:Clone()
    loadingClone.Parent = playerGui
    loadingClone.Enabled = true
    
    local window = loadingClone.LoadingWindow
    local loadBar = window.TopBar.LoadBarBG.LoadBar
    local logo = window.Logo
    
    Melatonin.MakeDraggable(window)
    
    -- Initial animation
    window.BackgroundTransparency = 1
    logo.ImageTransparency = 1
    
    Tween(window, {BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Quint)
    Tween(logo, {ImageTransparency = 0}, 0.5, Enum.EasingStyle.Quint)
    
    -- Pulsing logo animation
    local pulseConnection
    pulseConnection = Services.RunService.RenderStepped:Connect(function(dt)
        if logo and logo.Parent then
            local pulse = 1 + math.sin(tick() * 3) * 0.03
            logo.Size = UDim2.fromOffset(65 * pulse, 55 * pulse)
        end
    end)
    
    -- Loading bar animation with easing
    task.delay(0.2, function()
        Tween(loadBar, {Size = UDim2.new(1, 0, 1, 0)}, duration - 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    end)
    
    task.delay(duration, function()
        pulseConnection:Disconnect()
        Melatonin.CloseUI(loadingClone)
        
        task.delay(0.4, function()
            -- Clone and show main UI
            local mainClone = MainUI:Clone()
            mainClone.Parent = playerGui
            mainClone.Enabled = true
            
            local mainFrame = mainClone.Main
            local gamesHolder = mainFrame.GamesHolder
            local loadBtn = mainFrame.LoadFrame.Load
            local closeBtn = mainFrame.TopBar.Close
            
            Melatonin.MakeDraggable(mainFrame)
            
            -- Entrance animation
            mainFrame.Position = UDim2.fromScale(0.5, 0.55)
            mainFrame.BackgroundTransparency = 1
            Tween(mainFrame, {Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0}, 0.5, Enum.EasingStyle.Back)
            
            -- Button hover effects
            Melatonin.SetupButtonHover(loadBtn, 
                {TextTransparency = 0, TextColor3 = Config.Theme.Accent},
                {TextTransparency = 0.4, TextColor3 = Config.Theme.Text}
            )
            
            Melatonin.SetupButtonHover(closeBtn,
                {TextTransparency = 0, TextColor3 = Color3.fromRGB(255, 100, 100)},
                {TextTransparency = 0.4, TextColor3 = Config.Theme.Text}
            )
            
            -- Close button
            closeBtn.MouseButton1Click:Connect(function()
                Melatonin.CloseUI(mainClone)
            end)
            
            -- Load button
            loadBtn.MouseButton1Click:Connect(function()
                if not ActiveFrame then return end
                local data = LoaderHandler.FrameData[ActiveFrame]
                if not data then return end
                
                if data.Callback then
                    data.Callback(ActiveFrame, mainClone)
                elseif data.Url then
                    Melatonin.CloseUI(mainClone)
                    task.delay(0.5, function()
                        loadstring(game:HttpGet(data.Url))()
                    end)
                end
            end)
            
            -- Create game frames with staggered animation
            for i, config in ipairs(frameConfigs or {}) do
                task.delay(i * 0.08, function()
                    local frame = GameFrameTemplate:Clone()
                    frame.Name = "Game_" .. i
                    frame.Parent = gamesHolder
                    frame.BackgroundTransparency = 1
                    
                    local icon = frame:FindFirstChild("Icon")
                    local gameName = frame:FindFirstChild("GameName")
                    local status = frame:FindFirstChild("Status")
                    local subTime = frame:FindFirstChild("SubTime")
                    
                    if icon then icon.Image = config.Image or "" end
                    if gameName then gameName.Text = config.GameName or "Game" end
                    if status then status.Text = config.Status or "Unknown" end
                    if subTime then subTime.Text = config.SubTime or "N/A" end
                    
                    LoaderHandler.FrameData[frame] = {
                        Url = config.Url,
                        Callback = config.Callback
                    }
                    
                    Melatonin.SetupFrameInteraction(frame)
                    
                    -- Slide in animation
                    frame.Position = UDim2.new(-0.1, 0, 0, 0)
                    Tween(frame, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.25}, 0.35, Enum.EasingStyle.Back)
                end)
            end
            
            if callback then callback(mainClone) end
        end)
    end)
end

getgenv().MelatoninUI = Melatonin
return Melatonin, MainUI, GameFrameTemplate
