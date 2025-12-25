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

-- Font Definitions
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
Config.TweenTime = 0.3

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
    if not instance or not instance.Parent then return nil end
    local info = TweenInfo.new(
        duration or Config.TweenTime, 
        style or Enum.EasingStyle.Quart, 
        direction or Enum.EasingDirection.Out
    )
    local tween = Services.Tween:Create(instance, info, props)
    tween:Play()
    return tween
end

local function SmoothTween(instance, props, duration)
    return Tween(instance, props, duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
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
    
    -- Top Bar (Drag Handle)
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
            Text = "×",
            TextColor3 = Config.Theme.Text,
            TextSize = 18,
            TextTransparency = 0.4,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -30, 0, 0),
            Size = UDim2.fromOffset(30, 34)
        })
    })
    
    -- Games List
    Create("ScrollingFrame", {
        Name = "GamesHolder",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Config.Theme.Accent,
        ScrollBarImageTransparency = 0.3,
        TopImage = "",
        BottomImage = "",
        MidImage = "rbxassetid://7445543667",
        BackgroundColor3 = Config.Theme.SecondaryBG,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(7, 41),
        Size = UDim2.fromOffset(344, 213),
        ClipsDescendants = true,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = mainFrame
    }, {
        Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2)}),
        Create("UIStroke", {Color = Config.Theme.Stroke, Thickness = 1})
    })
    
    -- Load Button Frame
    Create("Frame", {
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
        Size = UDim2.fromOffset(160, 145),
        Parent = loadingGui
    })
    
    -- Top Bar (Drag Handle)
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
        })
    })
    
    -- Logo
    Create("ImageLabel", {
        Name = "MelaLogo",
        Image = Config.Logos.MelaLogo,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.45, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(60, 50),
        Parent = window
    })
    
    -- Loading Bar at Bottom
    Create("Frame", {
        Name = "LoadBarContainer",
        BackgroundColor3 = Config.Theme.SecondaryBG,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 1, -18),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0.8, 0, 0, 4),
        Parent = window
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Create("Frame", {
            Name = "LoadingLine",
            BackgroundColor3 = Config.Theme.Accent,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0)
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.3),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 0.3)
                })
            })
        })
    })
    
    -- Loading Text
    Create("TextLabel", {
        Name = "LoadingText",
        FontFace = Fonts.Ubuntu,
        Text = "Loading...",
        TextColor3 = Config.Theme.Text,
        TextSize = 11,
        TextTransparency = 0.5,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 1, -32),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0.8, 0, 0, 14),
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
    
    -- Selection indicator (left accent bar)
    Create("Frame", {
        Name = "SelectionIndicator",
        BackgroundColor3 = Config.Theme.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.1, 0),
        Size = UDim2.new(0, 3, 0.8, 0),
        Parent = frame
    }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    
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
local DragConnections = {}

-- Hover Styles
local Styles = {
    Enter = {
        Frame = {BackgroundTransparency = 0.1},
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
    },
    Selected = {
        Frame = {BackgroundTransparency = 0},
        GameName = {TextTransparency = 0, TextColor3 = Config.Theme.GameName},
        UpdateStatus = {TextTransparency = 0.1},
        SubTime = {TextTransparency = 0.1, BackgroundTransparency = 0.2},
        ImageLabel = {ImageTransparency = 0},
        SelectionIndicator = {BackgroundTransparency = 0}
    }
}

function Melatonin.ApplyStyle(targets, style, duration)
    for name, props in pairs(style) do
        local instance = targets[name]
        if instance and instance.Parent then
            SmoothTween(instance, props, duration or 0.2)
        end
    end
end

function Melatonin.SetupFrameInteraction(frame)
    local targets = {
        Frame = frame,
        GameName = frame:FindFirstChild("GameName"),
        UpdateStatus = frame:FindFirstChild("UpdateStatus"),
        SubTime = frame:FindFirstChild("SubTime"),
        ImageLabel = frame:FindFirstChild("ImageLabel"),
        SelectionIndicator = frame:FindFirstChild("SelectionIndicator")
    }
    
    local isHovering = false
    
    frame.MouseEnter:Connect(function()
        isHovering = true
        if getgenv().ActiveFrame ~= frame then
            Melatonin.ApplyStyle(targets, Styles.Enter, 0.15)
        end
    end)
    
    frame.MouseLeave:Connect(function()
        isHovering = false
        if getgenv().ActiveFrame ~= frame then
            Melatonin.ApplyStyle(targets, Styles.Leave, 0.25)
        end
    end)
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Deselect previous frame
            if getgenv().ActiveFrame and getgenv().ActiveFrame ~= frame and ActiveTargets then
                local prevIndicator = ActiveTargets.SelectionIndicator
                if prevIndicator then
                    SmoothTween(prevIndicator, {BackgroundTransparency = 1}, 0.2)
                end
                Melatonin.ApplyStyle(ActiveTargets, Styles.Leave, 0.2)
            end
            
            -- Select new frame
            getgenv().ActiveFrame = frame
            ActiveTargets = targets
            
            -- Apply selected style with smooth animation
            Melatonin.ApplyStyle(targets, Styles.Selected, 0.15)
            
            -- Scale animation for feedback
            local originalSize = frame.Size
            SmoothTween(frame, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 4, originalSize.Y.Scale, originalSize.Y.Offset)}, 0.08)
            task.delay(0.08, function()
                if frame and frame.Parent then
                    SmoothTween(frame, {Size = originalSize}, 0.15)
                end
            end)
        end
    end)
end

function Melatonin.SetupButtonHover(button, hoverProps, normalProps)
    if not button then return end
    
    button.MouseEnter:Connect(function()
        SmoothTween(button, hoverProps, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        SmoothTween(button, normalProps, 0.2)
    end)
end

function Melatonin.CloseGuiEffect(screenGui)
    if not screenGui or not screenGui.Parent then return end
    
    -- Find main frame for scale animation
    local mainFrame = screenGui:FindFirstChild("Main") or screenGui:FindFirstChild("LoadingWindow")
    
    if mainFrame then
        -- Smooth scale down and fade
        Tween(mainFrame, {
            Size = UDim2.new(mainFrame.Size.X.Scale * 0.95, mainFrame.Size.X.Offset * 0.95, mainFrame.Size.Y.Scale * 0.95, mainFrame.Size.Y.Offset * 0.95),
            BackgroundTransparency = 1
        }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    end
    
    local descendants = screenGui:GetDescendants()
    
    for _, obj in ipairs(descendants) do
        if obj:IsA("GuiObject") then
            local props = {BackgroundTransparency = 1}
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                props.TextTransparency = 1
            end
            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                props.ImageTransparency = 1
            end
            SmoothTween(obj, props, 0.3)
        elseif obj:IsA("UIStroke") then
            SmoothTween(obj, {Transparency = 1}, 0.3)
        end
    end
    
    task.delay(0.4, function()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
    end)
end

-- Fixed draggable function - only drags from the top bar
function Melatonin.MakeDraggable(mainFrame, dragHandle)
    if not mainFrame or not dragHandle then return end
    
    local dragging = false
    local dragStart = nil
    local frameStart = nil
    
    -- Only start drag from the handle (top bar)
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = Services.UserInput:GetMouseLocation()
            frameStart = mainFrame.AbsolutePosition
        end
    end)
    
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Services.UserInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    local connection = Services.RunService.RenderStepped:Connect(function(dt)
        if dragging and frameStart and dragStart then
            local mouse = Services.UserInput:GetMouseLocation()
            local delta = mouse - dragStart
            
            local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
            local size = mainFrame.AbsoluteSize
            local anchor = mainFrame.AnchorPoint
            
            local targetX = frameStart.X + delta.X + (size.X * anchor.X)
            local targetY = frameStart.Y + delta.Y + (size.Y * anchor.Y)
            
            -- Clamp to screen bounds
            targetX = math.clamp(targetX, size.X * anchor.X, viewport.X - size.X * (1 - anchor.X))
            targetY = math.clamp(targetY, size.Y * anchor.Y, viewport.Y - size.Y * (1 - anchor.Y))
            
            -- Smooth lerp for fluid movement
            local currentPos = mainFrame.Position
            local targetPos = UDim2.new(0, targetX, 0, targetY)
            
            local lerpSpeed = math.min(1, dt * 18)
            local newX = currentPos.X.Offset + (targetPos.X.Offset - currentPos.X.Offset) * lerpSpeed
            local newY = currentPos.Y.Offset + (targetPos.Y.Offset - currentPos.Y.Offset) * lerpSpeed
            
            mainFrame.Position = UDim2.fromOffset(newX, newY)
        end
    end)
    
    table.insert(DragConnections, connection)
    return connection
end

function Melatonin.LoadingEffect(duration, player, frameConfigs, mainTemplate, gameFrameTemplate, callback)
    if not player or not player:IsA("Player") then 
        warn("[Melatonin] Invalid player provided")
        return 
    end
    
    mainTemplate = mainTemplate or MainUI
    gameFrameTemplate = gameFrameTemplate or GameFrameTemplate
    
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Cleanup existing
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui.Name == "Melatonin" or gui.Name == "MelatoninLoading" then
            gui:Destroy()
        end
    end
    
    -- Disconnect old drag connections
    for _, conn in ipairs(DragConnections) do
        if conn then conn:Disconnect() end
    end
    DragConnections = {}
    
    local loadingClone = LoadingUI:Clone()
    loadingClone.Parent = playerGui
    loadingClone.Enabled = true
    
    local window = loadingClone:FindFirstChild("LoadingWindow")
    if not window then 
        warn("[Melatonin] LoadingWindow not found")
        return 
    end
    
    local topLabels = window:FindFirstChild("TopLabels")
    local loadBarContainer = window:FindFirstChild("LoadBarContainer")
    local loadBar = loadBarContainer and loadBarContainer:FindFirstChild("LoadingLine")
    local logo = window:FindFirstChild("MelaLogo")
    local loadingText = window:FindFirstChild("LoadingText")
    
    -- Make draggable from top bar only
    Melatonin.MakeDraggable(window, topLabels)
    
    -- Initial state - invisible
    window.BackgroundTransparency = 1
    if logo then logo.ImageTransparency = 1 end
    if loadingText then loadingText.TextTransparency = 1 end
    if loadBarContainer then loadBarContainer.BackgroundTransparency = 1 end
    
    -- Entrance animation
    window.Size = UDim2.fromOffset(140, 125)
    Tween(window, {BackgroundTransparency = 0, Size = UDim2.fromOffset(160, 145)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    task.delay(0.15, function()
        if logo then 
            Tween(logo, {ImageTransparency = 0}, 0.4, Enum.EasingStyle.Quart) 
        end
    end)
    
    task.delay(0.25, function()
        if loadingText then 
            Tween(loadingText, {TextTransparency = 0.5}, 0.3, Enum.EasingStyle.Quart) 
        end
        if loadBarContainer then
            Tween(loadBarContainer, {BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Quart)
        end
    end)
    
    -- Pulsing logo animation
    local pulseConnection
    if logo then
        local baseSize = UDim2.fromOffset(60, 50)
        pulseConnection = Services.RunService.RenderStepped:Connect(function()
            if logo and logo.Parent then
                local pulse = 1 + math.sin(tick() * 2.5) * 0.04
                logo.Size = UDim2.fromOffset(baseSize.X.Offset * pulse, baseSize.Y.Offset * pulse)
            end
        end)
    end
    
    -- Loading bar animation with smooth easing
    if loadBar then
        task.delay(0.4, function()
            Tween(loadBar, {Size = UDim2.new(1, 0, 1, 0)}, duration - 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        end)
    end
    
    -- Update loading text
    if loadingText then
        local dots = 0
        local textConnection
        textConnection = Services.RunService.Heartbeat:Connect(function()
            if loadingText and loadingText.Parent then
                dots = (dots % 3) + 1
                loadingText.Text = "Loading" .. string.rep(".", dots)
            else
                textConnection:Disconnect()
            end
        end)
        
        task.delay(duration, function()
            textConnection:Disconnect()
        end)
    end
    
    task.delay(duration, function()
        if pulseConnection then pulseConnection:Disconnect() end
        Melatonin.CloseGuiEffect(loadingClone)
        
        task.delay(0.5, function()
            -- Reset state
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
            
            -- Make draggable from top bar only
            Melatonin.MakeDraggable(mainFrame, topLabelsMain)
            
            -- Entrance animation
            mainFrame.Position = UDim2.fromScale(0.5, 0.5)
            mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            mainFrame.Size = UDim2.fromOffset(340, 280)
            mainFrame.BackgroundTransparency = 1
            
            Tween(mainFrame, {
                Size = UDim2.fromOffset(358, 297), 
                BackgroundTransparency = 0
            }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            
            -- Fade in children
            for _, child in ipairs(mainFrame:GetDescendants()) do
                if child:IsA("GuiObject") then
                    local originalBG = child.BackgroundTransparency
                    if originalBG < 1 then
                        child.BackgroundTransparency = 1
                        task.delay(0.1, function()
                            SmoothTween(child, {BackgroundTransparency = originalBG}, 0.35)
                        end)
                    end
                    
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        local originalText = child.TextTransparency
                        child.TextTransparency = 1
                        task.delay(0.15, function()
                            SmoothTween(child, {TextTransparency = originalText}, 0.3)
                        end)
                    end
                    
                    if child:IsA("ImageLabel") then
                        local originalImg = child.ImageTransparency
                        child.ImageTransparency = 1
                        task.delay(0.15, function()
                            SmoothTween(child, {ImageTransparency = originalImg}, 0.3)
                        end)
                    end
                end
            end
            
            -- Button hover effects
            if loadBtn then
                Melatonin.SetupButtonHover(loadBtn, 
                    {TextTransparency = 0, TextColor3 = Config.Theme.Accent},
                    {TextTransparency = 0.4, TextColor3 = Config.Theme.Text}
                )
                
                loadBtn.MouseButton1Click:Connect(function()
                    local active = getgenv().ActiveFrame
                    if not active then return end
                    
                    -- Button press animation
                    SmoothTween(loadBtn, {TextTransparency = 0.2}, 0.05)
                    task.delay(0.05, function()
                        SmoothTween(loadBtn, {TextTransparency = 0}, 0.1)
                    end)
                    
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
                    {TextTransparency = 0, TextColor3 = Color3.fromRGB(255, 100, 100), Rotation = 90},
                    {TextTransparency = 0.4, TextColor3 = Config.Theme.Text, Rotation = 0}
                )
                
                closeBtn.MouseButton1Click:Connect(function()
                    Melatonin.CloseGuiEffect(mainClone)
                end)
            end
            
            -- Create game frames with staggered animation
            if gamesHolder then
                for i, config in ipairs(frameConfigs or {}) do
                    task.delay(0.1 + (i * 0.1), function()
                        local frame = gameFrameTemplate:Clone()
                        frame.Name = "GameFrame_" .. i
                        frame.Parent = gamesHolder
                        
                        -- Initial hidden state
                        frame.BackgroundTransparency = 1
                        frame.Position = UDim2.new(-0.15, 0, 0, 0)
                        
                        local icon = frame:FindFirstChild("ImageLabel")
                        local gameName = frame:FindFirstChild("GameName")
                        local status = frame:FindFirstChild("UpdateStatus")
                        local subTime = frame:FindFirstChild("SubTime")
                        local indicator = frame:FindFirstChild("SelectionIndicator")
                        
                        -- Hide children initially
                        if icon then icon.ImageTransparency = 1 end
                        if gameName then gameName.TextTransparency = 1 end
                        if status then status.TextTransparency = 1 end
                        if subTime then 
                            subTime.TextTransparency = 1 
                            subTime.BackgroundTransparency = 1
                        end
                        if indicator then indicator.BackgroundTransparency = 1 end
                        
                        -- Set content
                        if icon then icon.Image = config.Image or "" end
                        if gameName then gameName.Text = config.GameName or "Game" end
                        if status then status.Text = config.Status or "Unknown" end
                        if subTime then subTime.Text = config.SubTime or "N/A" end
                        
                        -- Apply custom properties
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
                        
                        -- Legacy property support
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
                        
                        -- Store frame data
                        if config.Url then
                            LoaderHandler.FramesUrl[frame] = config.Url
                        end
                        if typeof(config.Callback) == "function" then
                            LoaderHandler.FrameCallbacks[frame] = config.Callback
                        end
                        LoaderHandler.FrameData[frame] = config
                        
                        Melatonin.SetupFrameInteraction(frame)
                        
                        -- Slide in animation
                        Tween(frame, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.25}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        
                        -- Fade in children with stagger
                        task.delay(0.1, function()
                            if icon then SmoothTween(icon, {ImageTransparency = 0.4}, 0.25) end
                            if gameName then SmoothTween(gameName, {TextTransparency = 0.4}, 0.25) end
                        end)
                        
                        task.delay(0.15, function()
                            if status then SmoothTween(status, {TextTransparency = 0.5}, 0.25) end
                            if subTime then 
                                SmoothTween(subTime, {TextTransparency = 0.5, BackgroundTransparency = 0.5}, 0.25) 
                            end
                        end)
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
