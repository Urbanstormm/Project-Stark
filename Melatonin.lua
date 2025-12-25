-- Obfuscation Shim
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

-- Font Definitions (to avoid Enum.Font issues)
local Fonts = {
    Ubuntu = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    UbuntuBold = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
    SourceSans = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
}

-- Default Configuration
getgenv().MelatoninUIConfig = getgenv().MelatoninUIConfig or {
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

local Config = getgenv().MelatoninUIConfig
Config.TweenTime = 0.25

-- Utility Functions
local function Create(class, props, children)
    local instance = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then 
            pcall(function() instance[k] = v end)
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    if props and props.Parent then instance.Parent = props.Parent end
    return instance
end

local function Tween(instance, props, duration, style, direction)
    if not instance or not instance.Parent then return end
    local info = TweenInfo.new(duration or Config.TweenTime, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local tween = Services.Tween:Create(instance, info, props)
    tween:Play()
    return tween
end

-- Clean up old instances
local existing = game.CoreGui:FindFirstChild("MelatoninFolder")
if existing then existing:Destroy() end

-- UI Container Setup
local MelatoninFolder = Create("Folder", {Name = "MelatoninFolder", Parent = game.CoreGui})
local ModuleContainer = Create("ModuleScript", {Name = "Melatonin", Parent = MelatoninFolder})

-- Main UI Creation
local function CreateMainUI()
    local mainGui = Create("ScreenGui", {
        Name = "Melatonin",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = ModuleContainer,
        Enabled = false,
        ResetOnSpawn = false
    })
    
    local mainFrame = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Config.Theme.PrimaryBG,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(358, 297),
        Parent = mainGui
    })
    
    -- Top Bar
    local topBar = Create("Frame", {
        Name = "TopLabels",
        BackgroundColor3 = Config.Theme.SecondaryBG,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        Parent = mainFrame
    }, {
        Create("Frame", {
            Name = "PurpleLine",
            BackgroundColor3 = Config.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2)
        }),
        Create("TextLabel", {
            Name = "MelatoninLabel",
            FontFace = Fonts.Ubuntu,
            Text = Config.LibraryName,
            TextColor3 = Config.Theme.Text,
            TextSize = 15,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(0, 80, 1, 0)
        }),
        Create("TextButton", {
            Name = "Close",
            FontFace = Fonts.Ubuntu,
            Text = "X",
            TextColor3 = Config.Theme.Text,
            TextSize = 14,
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
        BackgroundColor3 = Config.Theme.SecondaryBG,
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
    
    -- Load Button Frame
    local loadFrame = Create("Frame", {
        Name = "LoadFrame",
        BackgroundColor3 = Config.Theme.PrimaryBG,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(7, 262),
        Size = UDim2.fromOffset(344, 28),
        Parent = mainFrame
    }, {
        Create("UIStroke", {Color = Config.Theme.Stroke}),
        Create("TextButton", {
            Name = "Load",
            FontFace = Fonts.Ubuntu,
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
        Enabled = false,
        ResetOnSpawn = false
    })
    
    local window = Create("Frame", {
        Name = "LoadingWindow",
        BackgroundColor3 = Config.Theme.PrimaryBG,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(148, 133),
        Parent = loadingGui
    })
    
    -- Top Bar
    Create("Frame", {
        Name = "TopLabels",
        BackgroundColor3 = Config.Theme.SecondaryBG,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 27),
        Parent = window
    }, {
        Create("TextLabel", {
            Name = "TextLabel",
            FontFace = Fonts.Ubuntu,
            Text = Config.LibraryName,
            TextColor3 = Config.Theme.Text,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(0, 80, 1, 0)
        }),
        Create("Frame", {
            Name = "PurpleLine",
            BackgroundColor3 = Config.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2)
        }),
        Create("Frame", {
            Name = "BackgroundLoadBar",
            BackgroundColor3 = Config.Theme.SecondaryBG,
            BorderSizePixel = 0,
            Position = UDim2.new(0.12, 0, 1, 8),
            Size = UDim2.new(0.76, 0, 0, 3)
        }, {
            Create("Frame", {
                Name = "LoadingLine",
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
        Name = "MelaLogo",
        Image = Config.Logos.MelaLogo,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(69, 56),
        Parent = window
    })
    
    return loadingGui
end

-- Game Frame Template
local function CreateGameFrameTemplate()
    local frame = Create("Frame", {
        Name = "GameFrame",
        BackgroundColor3 = Color3.fromRGB(19, 22, 27),
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -4, 0, 49),
        ClipsDescendants = true
    })
    
    Create("ImageLabel", {
        Name = "ImageLabel",
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(6, 4),
        Size = UDim2.fromOffset(40, 41),
        Parent = frame
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
    
    Create("TextLabel", {
        Name = "GameName",
        FontFace = Fonts.UbuntuBold,
        RichText = true,
        Text = "",
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
        Name = "UpdateStatus",
        FontFace = Fonts.Ubuntu,
        RichText = true,
        Text = "",
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
        FontFace = Fonts.SourceSans,
        Text = "",
        TextColor3 = Config.Theme.TextHover or Config.Theme.Text,
        TextSize = 13,
        TextTransparency = 0.5,
        BackgroundColor3 = Color3.fromRGB(42, 45, 56),
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
    Melatonin = MainUI,
    MelatoninLoading = LoadingUI,
    GameFrame = GameFrameTemplate,
    FrameData = {},
    FramesUrl = {},
    FrameCallbacks = {}
}

getgenv().ActiveFrame = nil
local ActiveTargets = nil

-- Hover Styles
local Styles = {
    Enter = {
        Frame = {BackgroundTransparency = 0},
        GameName = {TextTransparency = 0, TextColor3 = Config.Theme.GameName},
        UpdateStatus = {TextTransparency = 0.2},
        SubTime = {TextTransparency = 0.2, BackgroundTransparency = 0.3},
        ImageLabel = {ImageTransparency = 0}
    },
    Leave = {
        Frame = {BackgroundTransparency = 0.25},
        GameName = {TextTransparency = 0.4, TextColor3 = Config.Theme.Text},
        UpdateStatus = {TextTransparency = 0.5},
        SubTime = {TextTransparency = 0.5, BackgroundTransparency = 0.5},
        ImageLabel = {ImageTransparency = 0.4}
    }
}

function Melatonin.ApplyStyle(targets, style, duration)
    for name, props in pairs(style) do
        local instance = targets[name]
        if instance and instance.Parent then
            Tween(instance, props, duration)
        end
    end
end

function Melatonin.SetupFrameInteraction(frame)
    local targets = {
        Frame = frame,
        GameName = frame:FindFirstChild("GameName"),
        UpdateStatus = frame:FindFirstChild("UpdateStatus"),
        SubTime = frame:FindFirstChild("SubTime"),
        ImageLabel = frame:FindFirstChild("ImageLabel")
    }
    
    frame.MouseEnter:Connect(function()
        if getgenv().ActiveFrame ~= frame then
            Melatonin.ApplyStyle(targets, Styles.Enter, 0.15)
        end
    end)
    
    frame.MouseLeave:Connect(function()
        if getgenv().ActiveFrame ~= frame then
            Melatonin.ApplyStyle(targets, Styles.Leave, 0.2)
        end
    end)
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if getgenv().ActiveFrame and getgenv().ActiveFrame ~= frame and ActiveTargets then
                Melatonin.ApplyStyle(ActiveTargets, Styles.Leave, 0.15)
            end
            getgenv().ActiveFrame = frame
            ActiveTargets = targets
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
                local t = Tween(ripple, {BackgroundTransparency = 1}, 0.3)
                if t then
                    t.Completed:Once(function()
                        if ripple and ripple.Parent then ripple:Destroy() end
                    end)
                end
            end)
        end
    end)
end

function Melatonin.SetupButtonHover(button, hoverProps, normalProps)
    if not button then return end
    button.MouseEnter:Connect(function()
        Tween(button, hoverProps, 0.12)
    end)
    button.MouseLeave:Connect(function()
        Tween(button, normalProps, 0.15)
    end)
end

function Melatonin.CloseGuiEffect(screenGui)
    if not screenGui or not screenGui.Parent then return end
    
    local descendants = screenGui:GetDescendants()
    
    for i, obj in ipairs(descendants) do
        local delay = math.min(i * 0.006, 0.3)
        task.delay(delay, function()
            if not obj or not obj.Parent then return end
            if obj:IsA("GuiObject") then
                local props = {BackgroundTransparency = 1}
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    props.TextTransparency = 1
                end
                if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    props.ImageTransparency = 1
                end
                Tween(obj, props, 0.3, Enum.EasingStyle.Quad)
            elseif obj:IsA("UIStroke") then
                Tween(obj, {Transparency = 1}, 0.3)
            end
        end)
    end
    
    task.delay(0.5, function()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
    end)
end

function Melatonin.MakeDraggable(frame)
    if not frame then return end
    
    local dragging, dragStart, startPos = false, nil, nil
    
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
    
    Services.RunService.RenderStepped:Connect(function(dt)
        if dragging and startPos then
            local mouse = Services.UserInput:GetMouseLocation()
            local delta = mouse - dragStart
            local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
            local size = frame.AbsoluteSize
            local anchor = frame.AnchorPoint
            
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            
            newX = math.clamp(newX, -size.X * anchor.X, viewport.X - size.X * (1 - anchor.X))
            newY = math.clamp(newY, -size.Y * anchor.Y, viewport.Y - size.Y * (1 - anchor.Y))
            
            local currentPos = frame.Position
            local targetPos = UDim2.fromOffset(newX, newY)
            frame.Position = currentPos:Lerp(targetPos, math.min(1, dt * 20))
        end
    end)
end

function Melatonin.LoadingEffect(duration, player, frameConfigs, mainTemplate, gameFrameTemplate, callback)
    if not player or not player:IsA("Player") then 
        warn("[Melatonin] Invalid player provided")
        return 
    end
    
    mainTemplate = mainTemplate or MainUI
    gameFrameTemplate = gameFrameTemplate or GameFrameTemplate
    
    local playerGui = player:WaitForChild("PlayerGui")
    
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui.Name == "Melatonin" or gui.Name == "MelatoninLoading" then
            gui:Destroy()
        end
    end
    
    local loadingClone = LoadingUI:Clone()
    loadingClone.Parent = playerGui
    loadingClone.Enabled = true
    
    local window = loadingClone:FindFirstChild("LoadingWindow")
    if not window then 
        warn("[Melatonin] LoadingWindow not found")
        return 
    end
    
    local topLabels = window:FindFirstChild("TopLabels")
    local loadBarBG = topLabels and topLabels:FindFirstChild("BackgroundLoadBar")
    local loadBar = loadBarBG and loadBarBG:FindFirstChild("LoadingLine")
    local logo = window:FindFirstChild("MelaLogo")
    
    Melatonin.MakeDraggable(window)
    
    window.BackgroundTransparency = 1
    if logo then logo.ImageTransparency = 1 end
    
    Tween(window, {BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Quint)
    if logo then Tween(logo, {ImageTransparency = 0}, 0.5, Enum.EasingStyle.Quint) end
    
    local pulseConnection
    if logo then
        local originalSize = logo.Size
        pulseConnection = Services.RunService.RenderStepped:Connect(function()
            if logo and logo.Parent then
                local pulse = 1 + math.sin(tick() * 3) * 0.03
                logo.Size = UDim2.fromOffset(originalSize.X.Offset * pulse, originalSize.Y.Offset * pulse)
            end
        end)
    end
    
    if loadBar then
        task.delay(0.2, function()
            Tween(loadBar, {Size = UDim2.new(1, 0, 1, 0)}, duration - 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        end)
    end
    
    task.delay(duration, function()
        if pulseConnection then pulseConnection:Disconnect() end
        Melatonin.CloseGuiEffect(loadingClone)
        
        task.delay(0.5, function()
            getgenv().ActiveFrame = nil
            ActiveTargets = nil
            LoaderHandler.FrameData = {}
            LoaderHandler.FramesUrl = {}
            LoaderHandler.FrameCallbacks = {}
            
            local mainClone = mainTemplate:Clone()
            mainClone.Parent = playerGui
            mainClone.Enabled = true
            getgenv().newUI = mainClone
            
            local mainFrame = mainClone:FindFirstChild("Main")
            if not mainFrame then 
                warn("[Melatonin] Main frame not found")
                return 
            end
            
            local gamesHolder = mainFrame:FindFirstChild("GamesHolder")
            local loadFrame = mainFrame:FindFirstChild("LoadFrame")
            local topLabelsMain = mainFrame:FindFirstChild("TopLabels")
            
            local loadBtn = loadFrame and loadFrame:FindFirstChild("Load")
            local closeBtn = topLabelsMain and topLabelsMain:FindFirstChild("Close")
            
            Melatonin.MakeDraggable(mainFrame)
            
            mainFrame.Position = UDim2.fromScale(0.5, 0.55)
            mainFrame.BackgroundTransparency = 1
            Tween(mainFrame, {Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0}, 0.5, Enum.EasingStyle.Back)
            
            if loadBtn then
                Melatonin.SetupButtonHover(loadBtn, 
                    {TextTransparency = 0, TextColor3 = Config.Theme.Accent},
                    {TextTransparency = 0.4, TextColor3 = Config.Theme.Text}
                )
                
                loadBtn.MouseButton1Click:Connect(function()
                    local active = getgenv().ActiveFrame
                    if not active then return end
                    
                    local frameCallback = LoaderHandler.FrameCallbacks[active]
                    if typeof(frameCallback) == "function" then
                        frameCallback(active, mainClone)
                        return
                    end
                    
                    local url = LoaderHandler.FramesUrl[active]
                    if url and url ~= "" then
                        Melatonin.CloseGuiEffect(mainClone)
                        task.delay(0.5, function()
                            loadstring(game:HttpGet(url))()
                        end)
                    end
                end)
            end
            
            if closeBtn then
                Melatonin.SetupButtonHover(closeBtn,
                    {TextTransparency = 0, TextColor3 = Color3.fromRGB(255, 100, 100)},
                    {TextTransparency = 0.4, TextColor3 = Config.Theme.Text}
                )
                
                closeBtn.MouseButton1Click:Connect(function()
                    Melatonin.CloseGuiEffect(mainClone)
                end)
            end
            
            if gamesHolder then
                for i, config in ipairs(frameConfigs or {}) do
                    task.delay(i * 0.08, function()
                        local frame = gameFrameTemplate:Clone()
                        frame.Name = "GameFrame_" .. i
                        frame.Parent = gamesHolder
                        frame.BackgroundTransparency = 1
                        
                        local icon = frame:FindFirstChild("ImageLabel")
                        local gameName = frame:FindFirstChild("GameName")
                        local status = frame:FindFirstChild("UpdateStatus")
                        local subTime = frame:FindFirstChild("SubTime")
                        
                        if icon then icon.Image = config.Image or "" end
                        if gameName then gameName.Text = config.GameName or "Game" end
                        if status then status.Text = config.Status or "Unknown" end
                        if subTime then subTime.Text = config.SubTime or "N/A" end
                        
                        if config.Properties then
                            for childName, props in pairs(config.Properties) do
                                local child = frame:FindFirstChild(childName)
                                if child then
                                    for prop, val in pairs(props) do
                                        pcall(function() child[prop] = val end)
                                    end
                                end
                            end
                        end
                        
                        for key, val in pairs(config) do
                            if type(val) == "table" and key ~= "Properties" then
                                local child = frame:FindFirstChild(key)
                                if child then
                                    for prop, propVal in pairs(val) do
                                        pcall(function() child[prop] = propVal end)
                                    end
                                end
                            end
                        end
                        
                        if config.Url then
                            LoaderHandler.FramesUrl[frame] = config.Url
                        end
                        if typeof(config.Callback) == "function" then
                            LoaderHandler.FrameCallbacks[frame] = config.Callback
                        end
                        LoaderHandler.FrameData[frame] = config
                        
                        Melatonin.SetupFrameInteraction(frame)
                        
                        frame.Position = UDim2.new(-0.1, 0, 0, 0)
                        Tween(frame, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.25}, 0.35, Enum.EasingStyle.Back)
                    end)
                end
            end
            
            if callback then callback(mainClone) end
        end)
    end)
end

Melatonin.CloseUIEffect = Melatonin.CloseGuiEffect
Melatonin.Load = Melatonin.LoadingEffect

return Melatonin, MainUI, GameFrameTemplate
