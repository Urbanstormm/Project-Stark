local toggle = true;
function onKeyPress(actionName, userInputState, inputObject)
	if (userInputState == Enum.UserInputState.Begin) then
		if (toggle == false) then
			toggle = true;
			game:service("CoreGui"):FindFirstChild("Library").Enabled = true;
		else
			toggle = false;
			game:service("CoreGui"):FindFirstChild("Library").Enabled = false;
		end
	end
end
game.ContextActionService:BindAction("keyPress", onKeyPress, false, Enum.KeyCode.RightAlt);
function removegui()
	if game:service("CoreGui"):FindFirstChild("Library") then
		game:service("CoreGui"):FindFirstChild("Library"):Destroy();
	end
end
removegui();
local Lib = {RainbowColorValue=0,HueSelectionPosition=0};
local Accent = Color3.fromRGB(138, 80, 255);
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
coroutine.wrap(function()
	while wait() do
		Lib.RainbowColorValue = Lib.RainbowColorValue + (1 / 255);
		Lib.HueSelectionPosition = Lib.HueSelectionPosition + 1;
		if (Lib.RainbowColorValue >= 1) then
			Lib.RainbowColorValue = 0;
		end
		if (Lib.HueSelectionPosition == 80) then
			Lib.HueSelectionPosition = 0;
		end
	end
end)();
function Ripple(obj)
	spawn(function()
		local Mouse = game.Players.LocalPlayer:GetMouse();
		local Circle = Instance.new("ImageLabel");
		Circle.Name = "Circle";
		Circle.Parent = obj;
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		Circle.BackgroundTransparency = 1;
		Circle.ZIndex = 10;
		Circle.Image = "rbxassetid://266543268";
		Circle.ImageColor3 = Color3.fromRGB(211, 211, 211);
		Circle.ImageTransparency = 0.6;
		local NewX, NewY = Mouse.X - Circle.AbsolutePosition.X, Mouse.Y - Circle.AbsolutePosition.Y;
		Circle.Position = UDim2.new(0, NewX, 0, NewY);
		local Size = 0;
		if (obj.AbsoluteSize.X > obj.AbsoluteSize.Y) then
			Size = obj.AbsoluteSize.X * 1;
		elseif (obj.AbsoluteSize.X < obj.AbsoluteSize.Y) then
			Size = obj.AbsoluteSize.Y * 1;
		elseif (obj.AbsoluteSize.X == obj.AbsoluteSize.Y) then
			Size = obj.AbsoluteSize.X * 1;
		end
		Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), "Out", "Quad", 0.2, false);
		for i = 1, 15 do
			Circle.ImageTransparency = Circle.ImageTransparency + 0.05;
			wait();
		end
		Circle:Destroy();
	end);
end
local function MakeDraggable(topbarobject, object)
	local Dragging = nil;
	local DragInput = nil;
	local DragStart = nil;
	local StartPosition = nil;
	local function Update(input)
		local Delta = input.Position - DragStart;
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y);
		local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position=pos});
		Tween:Play();
	end
	topbarobject.InputBegan:Connect(function(input)
		if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
			Dragging = true;
			DragStart = input.Position;
			StartPosition = object.Position;
			input.Changed:Connect(function()
				if (input.UserInputState == Enum.UserInputState.End) then
					Dragging = false;
				end
			end);
		end
	end);
	topbarobject.InputChanged:Connect(function(input)
		if ((input.UserInputType == Enum.UserInputType.MouseMovement) or (input.UserInputType == Enum.UserInputType.Touch)) then
			DragInput = input;
		end
	end);
	UserInputService.InputChanged:Connect(function(input)
		if ((input == DragInput) and Dragging) then
			Update(input);
		end
	end);
end
Lib.Window = function(self, text, accent)
	local FirstTab = false;
	Accent = accent;
	local Library = Instance.new("ScreenGui");
	local MainFrame = Instance.new("Frame");
	local MainCorner = Instance.new("UICorner");
	local GlowMain = Instance.new("ImageLabel");
	local LeftFrame = Instance.new("Frame");
	local Title = Instance.new("TextLabel");
	local Line = Instance.new("Frame");
	local LineCorner = Instance.new("UICorner");
	local TabFrame = Instance.new("Frame");
	local TabList = Instance.new("UIListLayout");
	local ContainersFolder = Instance.new("Folder");
	local DraggableFrame = Instance.new("Frame");
	Library.Name = "Library";
	Library.Parent = game.CoreGui;
	Library.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
	MainFrame.Name = "MainFrame";
	MainFrame.Parent = Library;
	MainFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 27);
	MainFrame.Position = UDim2.new(0.330208331, 0, 0.304824561, 0);
	MainFrame.Size = UDim2.new(0, 652, 0, 355);
	MainCorner.CornerRadius = UDim.new(0, 9);
	MainCorner.Name = "MainCorner";
	MainCorner.Parent = MainFrame;
	GlowMain.Name = "GlowMain";
	GlowMain.Parent = MainFrame;
	GlowMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	GlowMain.BackgroundTransparency = 1;
	GlowMain.BorderSizePixel = 0;
	GlowMain.Position = UDim2.new(0, -15, 0, -15);
	GlowMain.Size = UDim2.new(1, 30, 1, 30);
	GlowMain.ZIndex = 0;
	GlowMain.Image = "rbxassetid://4996891970";
	GlowMain.ImageColor3 = Color3.fromRGB(15, 15, 15);
	GlowMain.ScaleType = Enum.ScaleType.Slice;
	GlowMain.SliceCenter = Rect.new(20, 20, 280, 280);
	LeftFrame.Name = "LeftFrame";
	LeftFrame.Parent = MainFrame;
	LeftFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	LeftFrame.BackgroundTransparency = 1;
	LeftFrame.Position = UDim2.new(0.0230061356, 0, 0.0366197191, 0);
	LeftFrame.Size = UDim2.new(0, 139, 0, 328);
	Title.Name = "Title";
	Title.Parent = LeftFrame;
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	Title.BackgroundTransparency = 1;
	Title.Size = UDim2.new(0, 139, 0, 50);
	Title.Font = Enum.Font.Gotham;
	Title.Text = text;
	Title.TextColor3 = Accent;
	Title.TextSize = 21;
	Line.Name = "Line";
	Line.Parent = LeftFrame;
	Line.BackgroundColor3 = Accent;
	Line.Position = UDim2.new(0, 0, 0.14199996, 0);
	Line.Size = UDim2.new(0, 139, 0, 2);
	LineCorner.CornerRadius = UDim.new(0, 9);
	LineCorner.Name = "LineCorner";
	LineCorner.Parent = Line;
	TabFrame.Name = "TabFrame";
	TabFrame.Parent = LeftFrame;
	TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	TabFrame.BackgroundTransparency = 1;
	TabFrame.Position = UDim2.new(0, 0, 0.189024389, 0);
	TabFrame.Size = UDim2.new(0, 139, 0, 266);
	TabList.Name = "TabList";
	TabList.Parent = TabFrame;
	TabList.SortOrder = Enum.SortOrder.LayoutOrder;
	TabList.Padding = UDim.new(0, 8);
	ContainersFolder.Name = "ContainersFolder";
	ContainersFolder.Parent = MainFrame;
	DraggableFrame.Name = "DraggableFrame";
	DraggableFrame.Parent = MainFrame;
	DraggableFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	DraggableFrame.BackgroundTransparency = 1;
	DraggableFrame.Position = UDim2.new(0.259202451, 0, 0.00563380262, 0);
	DraggableFrame.Size = UDim2.new(0, 483, 0, 57);
	MakeDraggable(DraggableFrame, MainFrame);
	local WindowTabs = {};
	WindowTabs.Tab = function(self, title)
		local Tab = Instance.new("TextButton");
		local UICorner = Instance.new("UICorner");
		local GlowTab = Instance.new("ImageLabel");
		local LabelAccent = Instance.new("TextLabel");
		local Container = Instance.new("Frame");
		local ContainerGlow = Instance.new("ImageLabel");
		local ContainerCorner = Instance.new("UICorner");
		local ContainerItemHolder = Instance.new("ScrollingFrame");
		local ItemHolderList = Instance.new("UIListLayout");
		Tab.Name = "Tab";
		Tab.Parent = TabFrame;
		Tab.BackgroundColor3 = Accent;
		Tab.BorderSizePixel = 0;
		Tab.Size = UDim2.new(0, 139, 0, 27);
		Tab.AutoButtonColor = false;
		Tab.Font = Enum.Font.Gotham;
		Tab.Text = title;
		Tab.TextColor3 = Color3.fromRGB(255, 255, 255);
		Tab.TextSize = 14;
		Tab.BackgroundTransparency = 1;
		UICorner.CornerRadius = UDim.new(0, 6);
		UICorner.Parent = Tab;
		GlowTab.Name = "GlowTab";
		GlowTab.Parent = Tab;
		GlowTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		GlowTab.BackgroundTransparency = 1;
		GlowTab.BorderSizePixel = 0;
		GlowTab.Position = UDim2.new(0, -15, 0, -15);
		GlowTab.Size = UDim2.new(1, 30, 1, 30);
		GlowTab.ZIndex = 0;
		GlowTab.Image = "rbxassetid://4996891970";
		GlowTab.ImageColor3 = Accent;
		GlowTab.ScaleType = Enum.ScaleType.Slice;
		GlowTab.SliceCenter = Rect.new(20, 20, 280, 280);
		GlowTab.ImageTransparency = 1;
		LabelAccent.Name = "LabelAccent";
		LabelAccent.Parent = Tab;
		LabelAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		LabelAccent.BackgroundTransparency = 1;
		LabelAccent.Size = UDim2.new(0, 139, 0, 27);
		LabelAccent.Font = Enum.Font.Gotham;
		LabelAccent.Text = title;
		LabelAccent.TextColor3 = Accent;
		LabelAccent.TextSize = 14;
		LabelAccent.TextTransparency = 0;
		Container.Name = "Container";
		Container.Parent = ContainersFolder;
		Container.BackgroundColor3 = Color3.fromRGB(31, 31, 31);
		Container.Position = UDim2.new(0.259, 0, 0.169, 0);
		Container.Size = UDim2.new(0, 471, 0, 281);
		Container.Visible = false;
		ContainerGlow.Name = "ContainerGlow";
		ContainerGlow.Parent = Container;
		ContainerGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		ContainerGlow.BackgroundTransparency = 1;
		ContainerGlow.BorderSizePixel = 0;
		ContainerGlow.Position = UDim2.new(0, -15, 0, -15);
		ContainerGlow.Size = UDim2.new(1, 30, 1, 30);
		ContainerGlow.ZIndex = 0;
		ContainerGlow.Image = "rbxassetid://4996891970";
		ContainerGlow.ImageColor3 = Color3.fromRGB(15, 15, 15);
		ContainerGlow.ScaleType = Enum.ScaleType.Slice;
		ContainerGlow.SliceCenter = Rect.new(20, 20, 280, 280);
		ContainerCorner.CornerRadius = UDim.new(0, 9);
		ContainerCorner.Name = "ContainerCorner";
		ContainerCorner.Parent = Container;
		ContainerItemHolder.Name = "ContainerItemHolder";
		ContainerItemHolder.Parent = Container;
		ContainerItemHolder.Active = true;
		ContainerItemHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		ContainerItemHolder.BackgroundTransparency = 1;
		ContainerItemHolder.BorderSizePixel = 0;
		ContainerItemHolder.Position = UDim2.new(0.0254777074, 0, 0.0365853645, 0);
		ContainerItemHolder.Size = UDim2.new(0, 455, 0, 262);
		ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0);
		ContainerItemHolder.ScrollBarThickness = 2;
		ItemHolderList.Name = "ItemHolderList";
		ItemHolderList.Parent = ContainerItemHolder;
		ItemHolderList.SortOrder = Enum.SortOrder.LayoutOrder;
		ItemHolderList.Padding = UDim.new(0, 5);
		if (FirstTab == false) then
			FirstTab = true;
			LabelAccent.TextTransparency = 1;
			GlowTab.ImageTransparency = 0;
			Tab.BackgroundTransparency = 0;
			Container.Visible = true;
		end
		Tab.MouseButton1Click:Connect(function()
			for i, v in next, ContainersFolder:GetChildren() do
				if (v.Name == "Container") then
					v.Visible = false;
				end
			end
			for i, v in next, TabFrame:GetChildren() do
				if (v.ClassName == "TextButton") then
					TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency=1}):Play();
					TweenService:Create(v.GlowTab, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency=1}):Play();
					TweenService:Create(v.LabelAccent, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency=0}):Play();
					TweenService:Create(Tab, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency=0}):Play();
					TweenService:Create(GlowTab, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency=0}):Play();
					TweenService:Create(LabelAccent, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency=1}):Play();
				end
			end
			Container.Visible = true;
		end);
		local TabItems = {};
		TabItems.Button = function(self, text, callback)
			local Button = Instance.new("TextButton");
			local ButtonCorner = Instance.new("UICorner");
			Button.Name = "Button";
			Button.Parent = ContainerItemHolder;
			Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			Button.Size = UDim2.new(0, 448, 0, 28);
			Button.AutoButtonColor = false;
			Button.Font = Enum.Font.Gotham;
			Button.TextColor3 = Color3.fromRGB(255, 255, 255);
			Button.TextSize = 14;
			Button.Text = text;
			Button.ClipsDescendants = true;
			ButtonCorner.CornerRadius = UDim.new(0, 6);
			ButtonCorner.Name = "ButtonCorner";
			ButtonCorner.Parent = Button;
			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(45, 45, 45)}):Play();
			end);
			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play();
			end);
			Button.MouseButton1Click:Connect(function()
				Ripple(Button);
				pcall(callback);
			end);
			ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
		end;
		TabItems.Toggle = function(self, text, callback)
			local Toggled = false;
			local Toggle = Instance.new("TextButton");
			local ToggleCorner = Instance.new("UICorner");
			local Title = Instance.new("TextLabel");
			local BoxStatus = Instance.new("Frame");
			local BoxCorner = Instance.new("UICorner");
			local Dot = Instance.new("Frame");
			local DotCorner = Instance.new("UICorner");
			Toggle.Name = "Toggle";
			Toggle.Parent = ContainerItemHolder;
			Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			Toggle.Position = UDim2.new(0.245398775, 0, 0.630985916, 0);
			Toggle.Size = UDim2.new(0, 448, 0, 28);
			Toggle.AutoButtonColor = false;
			Toggle.Font = Enum.Font.Gotham;
			Toggle.Text = "";
			Toggle.TextColor3 = Color3.fromRGB(255, 255, 255);
			Toggle.TextSize = 14;
			Toggle.ClipsDescendants = true;
			ToggleCorner.CornerRadius = UDim.new(0, 6);
			ToggleCorner.Name = "ToggleCorner";
			ToggleCorner.Parent = Toggle;
			Title.Name = "Title";
			Title.Parent = Toggle;
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Title.BackgroundTransparency = 1;
			Title.Position = UDim2.new(0.0200892854, 0, 0, 0);
			Title.Size = UDim2.new(0, 0, 0, 28);
			Title.Font = Enum.Font.Gotham;
			Title.TextColor3 = Color3.fromRGB(255, 255, 255);
			Title.TextSize = 14;
			Title.TextXAlignment = Enum.TextXAlignment.Left;
			Title.Text = text;
			BoxStatus.Name = "BoxStatus";
			BoxStatus.Parent = Toggle;
			BoxStatus.BackgroundColor3 = Color3.fromRGB(36, 36, 36);
			BoxStatus.Position = UDim2.new(0.908482134, 0, 0.142857149, 0);
			BoxStatus.Size = UDim2.new(0, 35, 0, 19);
			BoxCorner.CornerRadius = UDim.new(1, 0);
			BoxCorner.Name = "BoxCorner";
			BoxCorner.Parent = BoxStatus;
			Dot.Name = "Dot";
			Dot.Parent = BoxStatus;
			Dot.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			Dot.Position = UDim2.new(0.0799999982, 0, 0.126000002, 0);
			Dot.Size = UDim2.new(0, 14, 0, 14);
			DotCorner.CornerRadius = UDim.new(1, 0);
			DotCorner.Name = "DotCorner";
			DotCorner.Parent = Dot;
			Toggle.MouseEnter:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(45, 45, 45)}):Play();
			end);
			Toggle.MouseLeave:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play();
			end);
			Toggle.MouseButton1Click:Connect(function()
				if (Toggled == false) then
					Toggled = not Toggled;
					TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Accent}):Play();
					TweenService:Create(Dot, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position=UDim2.new(0.48, 0, 0.126, 0)}):Play();
				else
					Toggled = not Toggled;
					TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play();
					TweenService:Create(Dot, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position=UDim2.new(0.0799999982, 0, 0.126000002, 0)}):Play();
				end
				pcall(callback, Toggled);
				Ripple(Toggle);
			end);
			ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
		end;
		TabItems.Slider = function(self, text, min, max, start, callback)
			local dragging = false;
			local Slider = Instance.new("TextButton");
			local SliderCorner = Instance.new("UICorner");
			local Title = Instance.new("TextLabel");
			local SliderFrame = Instance.new("Frame");
			local SliderFrameCorner = Instance.new("UICorner");
			local Indicator = Instance.new("Frame");
			local IndicatorCorner = Instance.new("UICorner");
			local Value = Instance.new("TextLabel");
			Slider.Name = "Slider";
			Slider.Parent = ContainerItemHolder;
			Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			Slider.Position = UDim2.new(0.245398775, 0, 0.630985916, 0);
			Slider.Size = UDim2.new(0, 448, 0, 28);
			Slider.AutoButtonColor = false;
			Slider.Font = Enum.Font.Gotham;
			Slider.Text = "";
			Slider.TextColor3 = Color3.fromRGB(255, 255, 255);
			Slider.TextSize = 14;
			SliderCorner.CornerRadius = UDim.new(0, 6);
			SliderCorner.Name = "SliderCorner";
			SliderCorner.Parent = Slider;
			Title.Name = "Title";
			Title.Parent = Slider;
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Title.BackgroundTransparency = 1;
			Title.Position = UDim2.new(0.0200892854, 0, 0, 0);
			Title.Size = UDim2.new(0, 0, 0, 28);
			Title.Font = Enum.Font.Gotham;
			Title.Text = text;
			Title.TextColor3 = Color3.fromRGB(255, 255, 255);
			Title.TextSize = 14;
			Title.TextXAlignment = Enum.TextXAlignment.Left;
			Value.Name = "Value";
			Value.Parent = Slider;
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Value.BackgroundTransparency = 1;
			Value.Position = UDim2.new(0.392857134, 0, 0, 0);
			Value.Size = UDim2.new(0, 38, 0, 28);
			Value.Font = Enum.Font.Gotham;
			Value.Text = tostring((start and math.floor(((start / max) * (max - min)) + min)) or 0);
			Value.TextColor3 = Color3.fromRGB(255, 255, 255);
			Value.TextSize = 13;
			Value.TextXAlignment = Enum.TextXAlignment.Right;
			SliderFrame.Name = "SliderFrame";
			SliderFrame.Parent = Slider;
			SliderFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36);
			SliderFrame.Position = UDim2.new(0.495535702, 0, 0.285714298, 0);
			SliderFrame.Size = UDim2.new(0, 217, 0, 12);
			SliderFrameCorner.CornerRadius = UDim.new(1, 0);
			SliderFrameCorner.Name = "SliderFrameCorner";
			SliderFrameCorner.Parent = SliderFrame;
			Indicator.Name = "Indicator";
			Indicator.Parent = SliderFrame;
			Indicator.BackgroundColor3 = Accent;
			Indicator.BorderSizePixel = 0;
			Indicator.Position = UDim2.new(-0.00216013822, 0, -0.0476175956, 0);
			Indicator.Size = UDim2.new((start or 0) / max, 0, 0, 12);
			IndicatorCorner.CornerRadius = UDim.new(1, 0);
			IndicatorCorner.Name = "IndicatorCorner";
			IndicatorCorner.Parent = Indicator;
			local function slide(input)
				local pos = UDim2.new(math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1), 0, 0, 12);
				Indicator:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true);
				local s = math.floor((((pos.X.Scale * max) / max) * (max - min)) + min);
				Value.Text = tostring(s);
				pcall(callback, s);
			end
			SliderFrame.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1) then
					slide(input);
					dragging = true;
				end
			end);
			SliderFrame.InputEnded:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1) then
					dragging = false;
				end
			end);
			UserInputService.InputChanged:Connect(function(input)
				if (dragging and (input.UserInputType == Enum.UserInputType.MouseMovement)) then
					slide(input);
				end
			end);
			ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
		end;
		TabItems.Dropdown = function(self, text, list, callback)
			local ItemCount = 0;
			local FrameSize = 9;
			local DropToggled = false;
			local Dropdown = Instance.new("TextButton");
			local DropdownCorner = Instance.new("UICorner");
			local Title = Instance.new("TextLabel");
			local Icon = Instance.new("ImageButton");
			Dropdown.Name = "Dropdown";
			Dropdown.Parent = ContainerItemHolder;
			Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			Dropdown.Position = UDim2.new(0.259202451, 0, 0.594366193, 0);
			Dropdown.Size = UDim2.new(0, 448, 0, 28);
			Dropdown.AutoButtonColor = false;
			Dropdown.Font = Enum.Font.Gotham;
			Dropdown.Text = "";
			Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255);
			Dropdown.TextSize = 14;
			Dropdown.BorderSizePixel = 0;
			Dropdown.ClipsDescendants = true;
			DropdownCorner.CornerRadius = UDim.new(0, 6);
			DropdownCorner.Name = "DropdownCorner";
			DropdownCorner.Parent = Dropdown;
			Title.Name = "Title";
			Title.Parent = Dropdown;
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Title.BackgroundTransparency = 1;
			Title.Position = UDim2.new(0.0200892854, 0, 0, 0);
			Title.Size = UDim2.new(0, 0, 0, 28);
			Title.Font = Enum.Font.Gotham;
			Title.Text = text;
			Title.TextColor3 = Color3.fromRGB(255, 255, 255);
			Title.TextSize = 14;
			Title.TextXAlignment = Enum.TextXAlignment.Left;
			Icon.Name = "Icon";
			Icon.Parent = Dropdown;
			Icon.BackgroundTransparency = 1;
			Icon.Position = UDim2.new(0.930803597, 0, 0.0357142873, 0);
			Icon.Size = UDim2.new(0, 25, 0, 25);
			Icon.ZIndex = 2;
			Icon.Image = "rbxassetid://3926305904";
			Icon.ImageRectOffset = Vector2.new(44, 404);
			Icon.ImageRectSize = Vector2.new(36, 36);
			local DropdownFrame = Instance.new("Frame");
			local DropdownFrameCorner = Instance.new("UICorner");
			local DropdownItemHolder = Instance.new("ScrollingFrame");
			local DropdownItemHolderList = Instance.new("UIListLayout");
			local DropdownFramePadding = Instance.new("UIPadding");
			DropdownFrame.Name = "DropdownFrame";
			DropdownFrame.Parent = ContainerItemHolder;
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			DropdownFrame.Position = UDim2.new(0.0828220844, 0, 1.04184508, 0);
			DropdownFrame.Size = UDim2.new(0, 448, 0, 0);
			DropdownFrame.ClipsDescendants = true;
			DropdownFrame.BorderSizePixel = 0;
			DropdownFrame.Visible = false;
			DropdownFrameCorner.CornerRadius = UDim.new(0, 6);
			DropdownFrameCorner.Name = "DropdownFrameCorner";
			DropdownFrameCorner.Parent = DropdownFrame;
			DropdownItemHolder.Name = "DropdownItemHolder";
			DropdownItemHolder.Parent = DropdownFrame;
			DropdownItemHolder.Active = true;
			DropdownItemHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			DropdownItemHolder.BackgroundTransparency = 1;
			DropdownItemHolder.BorderSizePixel = 0;
			DropdownItemHolder.Position = UDim2.new(0.0254776813, 0, 0, 0);
			DropdownItemHolder.Size = UDim2.new(0, 431, 0, 0);
			DropdownItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0);
			DropdownItemHolder.ScrollBarThickness = 2;
			DropdownItemHolderList.Name = "DropdownItemHolderList";
			DropdownItemHolderList.Parent = DropdownItemHolder;
			DropdownItemHolderList.SortOrder = Enum.SortOrder.LayoutOrder;
			DropdownItemHolderList.Padding = UDim.new(0, 5);
			DropdownFramePadding.Name = "DropdownFramePadding";
			DropdownFramePadding.Parent = DropdownItemHolder;
			DropdownFramePadding.PaddingBottom = UDim.new(0, 8);
			DropdownFramePadding.PaddingTop = UDim.new(0, 8);
			Dropdown.MouseEnter:Connect(function()
				TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(45, 45, 45)}):Play();
			end);
			Dropdown.MouseLeave:Connect(function()
				TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play();
			end);
			Dropdown.MouseButton1Click:Connect(function()
				Ripple(Dropdown);
				if (DropToggled == false) then
					DropdownFrame.Visible = true;
					DropdownFrame:TweenSize(UDim2.new(0, 448, 0, FrameSize), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true);
					DropdownItemHolder:TweenSize(UDim2.new(0, 431, 0, FrameSize), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true);
					TweenService:Create(Icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation=180}):Play();
					repeat
						wait();
					until DropdownFrame.Size == UDim2.new(0, 448, 0, FrameSize) 
					ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
				else
					DropdownFrame:TweenSize(UDim2.new(0, 448, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true);
					DropdownItemHolder:TweenSize(UDim2.new(0, 431, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true);
					TweenService:Create(Icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation=0}):Play();
					repeat
						wait();
					until DropdownFrame.Size == UDim2.new(0, 448, 0, 0) 
					DropdownFrame.Visible = false;
					ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
				end
				DropToggled = not DropToggled;
			end);
			for i, v in next, list do
				ItemCount = ItemCount + 1;
				if (ItemCount <= 2) then
					FrameSize = FrameSize + 30;
				elseif (ItemCount >= 3) then
					FrameSize = 100;
				end
				local Item = Instance.new("TextButton");
				local ItemCorner = Instance.new("UICorner");
				Item.Name = "Item";
				Item.Parent = DropdownItemHolder;
				Item.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
				Item.Position = UDim2.new(0.0255220421, 0, -0.0595238097, 0);
				Item.Size = UDim2.new(0, 425, 0, 24);
				Item.AutoButtonColor = false;
				Item.Font = Enum.Font.Gotham;
				Item.TextColor3 = Color3.fromRGB(255, 255, 255);
				Item.TextSize = 14;
				Item.Text = v;
				ItemCorner.CornerRadius = UDim.new(0, 6);
				ItemCorner.Name = "ItemCorner";
				ItemCorner.Parent = Item;
				Item.MouseEnter:Connect(function()
					TweenService:Create(Item, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(45, 45, 45)}):Play();
				end);
				Item.MouseLeave:Connect(function()
					TweenService:Create(Item, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play();
				end);
				Item.MouseButton1Click:Connect(function()
					pcall(callback, v);
					Title.Text = text .. " : " .. v;
					DropdownFrame:TweenSize(UDim2.new(0, 448, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true);
					DropdownItemHolder:TweenSize(UDim2.new(0, 431, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true);
					TweenService:Create(Icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation=0}):Play();
					repeat
						wait();
					until DropdownFrame.Size == UDim2.new(0, 448, 0, 0) 
					DropdownFrame.Visible = false;
					ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
					DropToggled = not DropToggled;
				end);
				DropdownItemHolder.CanvasSize = UDim2.new(0, 0, 0, DropdownItemHolderList.AbsoluteContentSize.Y + 15);
			end
			ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
		end;
		TabItems.Colorpicker = function(self, text, preset, callback)
			local ColorPickerToggled = false;
			local OldToggleColor = Color3.fromRGB(0, 0, 0);
			local OldColor = Color3.fromRGB(0, 0, 0);
			local OldColorSelectionPosition = nil;
			local OldHueSelectionPosition = nil;
			local ColorH, ColorS, ColorV = 1, 1, 1;
			local RainbowColorPicker = false;
			local ColorPickerInput = nil;
			local ColorInput = nil;
			local HueInput = nil;
			local Colorpicker = Instance.new("TextButton");
			local ColorpickerCorner = Instance.new("UICorner");
			local Title = Instance.new("TextLabel");
			local BoxColor = Instance.new("Frame");
			local BoxCorner = Instance.new("UICorner");
			Colorpicker.Name = "Colorpicker";
			Colorpicker.Parent = ContainerItemHolder;
			Colorpicker.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			Colorpicker.Position = UDim2.new(0.245398775, 0, 0.630985916, 0);
			Colorpicker.Size = UDim2.new(0, 448, 0, 28);
			Colorpicker.AutoButtonColor = false;
			Colorpicker.Font = Enum.Font.Gotham;
			Colorpicker.Text = "";
			Colorpicker.TextColor3 = Color3.fromRGB(255, 255, 255);
			Colorpicker.TextSize = 14;
			Colorpicker.ClipsDescendants = true;
			ColorpickerCorner.CornerRadius = UDim.new(0, 6);
			ColorpickerCorner.Name = "ColorpickerCorner";
			ColorpickerCorner.Parent = Colorpicker;
			Title.Name = "Title";
			Title.Parent = Colorpicker;
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Title.BackgroundTransparency = 1;
			Title.Position = UDim2.new(0.0200892854, 0, 0, 0);
			Title.Size = UDim2.new(0, 0, 0, 28);
			Title.Font = Enum.Font.Gotham;
			Title.Text = text;
			Title.TextColor3 = Color3.fromRGB(255, 255, 255);
			Title.TextSize = 14;
			Title.TextXAlignment = Enum.TextXAlignment.Left;
			BoxColor.Name = "BoxColor";
			BoxColor.Parent = Colorpicker;
			BoxColor.BackgroundColor3 = preset;
			BoxColor.Position = UDim2.new(0.866071403, 0, 0.142857149, 0);
			BoxColor.Size = UDim2.new(0, 54, 0, 19);
			BoxCorner.CornerRadius = UDim.new(0, 6);
			BoxCorner.Name = "BoxCorner";
			BoxCorner.Parent = BoxColor;
			local ColorpickerFrame = Instance.new("Frame");
			local ColorpickerFrameCorner = Instance.new("UICorner");
			local Color = Instance.new("ImageLabel");
			local ColorCorner = Instance.new("UICorner");
			local ColorSelection = Instance.new("ImageLabel");
			local Hue = Instance.new("ImageLabel");
			local HueCorner = Instance.new("UICorner");
			local HueGradient = Instance.new("UIGradient");
			local HueSelection = Instance.new("ImageLabel");
			local Confirm = Instance.new("TextButton");
			local ConfirmCorner = Instance.new("UICorner");
			local RainbowToggle = Instance.new("TextButton");
			local RainbowToggleCorner = Instance.new("UICorner");
			local RainbowTitle = Instance.new("TextLabel");
			local RainbowBoxStatus = Instance.new("Frame");
			local RainbowBoxCorner = Instance.new("UICorner");
			local RainbowDot = Instance.new("Frame");
			local RainbowDotCorner = Instance.new("UICorner");
			ColorpickerFrame.Name = "ColorpickerFrame";
			ColorpickerFrame.Parent = ContainerItemHolder;
			ColorpickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			ColorpickerFrame.Position = UDim2.new(-0.345092028, 0, 0.816492796, 0);
			ColorpickerFrame.Size = UDim2.new(0, 448, 0, 0);
			ColorpickerFrame.Visible = false;
			ColorpickerFrame.ClipsDescendants = true;
			ColorpickerFrame.BorderSizePixel = 0;
			ColorpickerFrameCorner.CornerRadius = UDim.new(0, 6);
			ColorpickerFrameCorner.Name = "ColorpickerFrameCorner";
			ColorpickerFrameCorner.Parent = ColorpickerFrame;
			Color.Name = "Color";
			Color.Parent = ColorpickerFrame;
			Color.BackgroundColor3 = preset;
			Color.Position = UDim2.new(0, 9, 0, 9);
			Color.Size = UDim2.new(0, 212, 0, 80);
			Color.ZIndex = 10;
			Color.Image = "rbxassetid://4155801252";
			ColorCorner.CornerRadius = UDim.new(0, 3);
			ColorCorner.Name = "ColorCorner";
			ColorCorner.Parent = Color;
			ColorSelection.Name = "ColorSelection";
			ColorSelection.Parent = Color;
			ColorSelection.AnchorPoint = Vector2.new(0.5, 0.5);
			ColorSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			ColorSelection.BackgroundTransparency = 1;
			ColorSelection.Position = UDim2.new(preset and select(3, Color3.toHSV(preset)));
			ColorSelection.Size = UDim2.new(0, 18, 0, 18);
			ColorSelection.Image = "http://www.roblox.com/asset/?id=4805639000";
			ColorSelection.ScaleType = Enum.ScaleType.Fit;
			Hue.Name = "Hue";
			Hue.Parent = ColorpickerFrame;
			Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Hue.Position = UDim2.new(0, 233, 0, 9);
			Hue.Size = UDim2.new(0, 25, 0, 80);
			HueCorner.CornerRadius = UDim.new(0, 3);
			HueCorner.Name = "HueCorner";
			HueCorner.Parent = Hue;
			HueGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)),ColorSequenceKeypoint.new(0.2, Color3.fromRGB(234, 255, 0)),ColorSequenceKeypoint.new(0.4, Color3.fromRGB(21, 255, 0)),ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 17, 255)),ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255, 0, 251)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 4))});
			HueGradient.Rotation = 270;
			HueGradient.Name = "HueGradient";
			HueGradient.Parent = Hue;
			HueSelection.Name = "HueSelection";
			HueSelection.Parent = Hue;
			HueSelection.AnchorPoint = Vector2.new(0.5, 0.5);
			HueSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			HueSelection.BackgroundTransparency = 1;
			HueSelection.Position = UDim2.new(0.48, 0, 1 - select(1, Color3.toHSV(preset)));
			HueSelection.Size = UDim2.new(0, 18, 0, 18);
			HueSelection.Image = "http://www.roblox.com/asset/?id=4805639000";
			Confirm.Name = "Confirm";
			Confirm.Parent = ColorpickerFrame;
			Confirm.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			Confirm.Position = UDim2.new(0.611607134, 0, 0.183673471, 0);
			Confirm.Size = UDim2.new(0, 162, 0, 28);
			Confirm.AutoButtonColor = false;
			Confirm.Font = Enum.Font.Gotham;
			Confirm.Text = "Confirm";
			Confirm.TextColor3 = Color3.fromRGB(255, 255, 255);
			Confirm.TextSize = 14;
			ConfirmCorner.CornerRadius = UDim.new(0, 6);
			ConfirmCorner.Name = "ConfirmCorner";
			ConfirmCorner.Parent = Confirm;
			RainbowToggle.Name = "RainbowToggle";
			RainbowToggle.Parent = ColorpickerFrame;
			RainbowToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			RainbowToggle.Position = UDim2.new(0.611607134, 0, 0.528944969, 0);
			RainbowToggle.Size = UDim2.new(0, 162, 0, 28);
			RainbowToggle.AutoButtonColor = false;
			RainbowToggle.Font = Enum.Font.Gotham;
			RainbowToggle.Text = "";
			RainbowToggle.TextColor3 = Color3.fromRGB(255, 255, 255);
			RainbowToggle.TextSize = 14;
			RainbowToggleCorner.CornerRadius = UDim.new(0, 6);
			RainbowToggleCorner.Name = "RainbowToggleCorner";
			RainbowToggleCorner.Parent = RainbowToggle;
			RainbowTitle.Name = "RainbowTitle";
			RainbowTitle.Parent = RainbowToggle;
			RainbowTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			RainbowTitle.BackgroundTransparency = 1;
			RainbowTitle.Position = UDim2.new(0.0400892854, 0, 0, 0);
			RainbowTitle.Size = UDim2.new(0, 0, 0, 28);
			RainbowTitle.Font = Enum.Font.Gotham;
			RainbowTitle.Text = "Rainbow";
			RainbowTitle.TextColor3 = Color3.fromRGB(255, 255, 255);
			RainbowTitle.TextSize = 14;
			RainbowTitle.TextXAlignment = Enum.TextXAlignment.Left;
			RainbowBoxStatus.Name = "RainbowBoxStatus";
			RainbowBoxStatus.Parent = RainbowToggle;
			RainbowBoxStatus.BackgroundColor3 = Color3.fromRGB(36, 36, 36);
			RainbowBoxStatus.Position = UDim2.new(0.749000013, 0, 0.143000007, 0);
			RainbowBoxStatus.Size = UDim2.new(0, 35, 0, 19);
			RainbowBoxCorner.CornerRadius = UDim.new(1, 0);
			RainbowBoxCorner.Name = "RainbowBoxCorner";
			RainbowBoxCorner.Parent = RainbowBoxStatus;
			RainbowDot.Name = "RainbowDot";
			RainbowDot.Parent = RainbowBoxStatus;
			RainbowDot.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			RainbowDot.Position = UDim2.new(0.0799999982, 0, 0.126000002, 0);
			RainbowDot.Size = UDim2.new(0, 14, 0, 14);
			RainbowDotCorner.CornerRadius = UDim.new(1, 0);
			RainbowDotCorner.Name = "RainbowDotCorner";
			RainbowDotCorner.Parent = RainbowDot;
			Colorpicker.MouseEnter:Connect(function()
				TweenService:Create(Colorpicker, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(44, 44, 44)}):Play();
			end);
			Colorpicker.MouseLeave:Connect(function()
				TweenService:Create(Colorpicker, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(39, 39, 39)}):Play();
			end);
			local function UpdateColorPicker(nope)
				BoxColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV);
				Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1);
				pcall(callback, BoxColor.BackgroundColor3);
			end
			ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y);
			ColorS = math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X;
			ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y);
			BoxColor.BackgroundColor3 = preset;
			Color.BackgroundColor3 = preset;
			pcall(callback, BoxColor.BackgroundColor3);
			Color.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1) then
					if RainbowColorPicker then
						return;
					end
					if ColorInput then
						ColorInput:Disconnect();
					end
					ColorInput = RunService.RenderStepped:Connect(function()
						local ColorX = math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X;
						local ColorY = math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y;
						ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0);
						ColorS = ColorX;
						ColorV = 1 - ColorY;
						UpdateColorPicker(true);
					end);
				end
			end);
			Color.InputEnded:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1) then
					if ColorInput then
						ColorInput:Disconnect();
					end
				end
			end);
			Hue.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1) then
					if RainbowColorPicker then
						return;
					end
					if HueInput then
						HueInput:Disconnect();
					end
					HueInput = RunService.RenderStepped:Connect(function()
						local HueY = math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y;
						HueSelection.Position = UDim2.new(0.48, 0, HueY, 0);
						ColorH = 1 - HueY;
						UpdateColorPicker(true);
					end);
				end
			end);
			Hue.InputEnded:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1) then
					if HueInput then
						HueInput:Disconnect();
					end
				end
			end);
			RainbowToggle.MouseEnter:Connect(function()
				TweenService:Create(RainbowToggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(45, 45, 45)}):Play();
			end);
			RainbowToggle.MouseLeave:Connect(function()
				TweenService:Create(RainbowToggle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play();
			end);
			Confirm.MouseEnter:Connect(function()
				TweenService:Create(Confirm, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(45, 45, 45)}):Play();
			end);
			Confirm.MouseLeave:Connect(function()
				TweenService:Create(Confirm, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play();
			end);
			RainbowToggle.MouseButton1Down:Connect(function()
				RainbowColorPicker = not RainbowColorPicker;
				if ColorInput then
					ColorInput:Disconnect();
				end
				if HueInput then
					HueInput:Disconnect();
				end
				if RainbowColorPicker then
					TweenService:Create(RainbowDot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Accent}):Play();
					TweenService:Create(RainbowDot, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position=UDim2.new(0.48, 0, 0.126, 0)}):Play();
					OldToggleColor = BoxColor.BackgroundColor3;
					OldColor = Color.BackgroundColor3;
					OldColorSelectionPosition = ColorSelection.Position;
					OldHueSelectionPosition = HueSelection.Position;
					while RainbowColorPicker do
						BoxColor.BackgroundColor3 = Color3.fromHSV(Lib.RainbowColorValue, 1, 1);
						Color.BackgroundColor3 = Color3.fromHSV(Lib.RainbowColorValue, 1, 1);
						ColorSelection.Position = UDim2.new(1, 0, 0, 0);
						HueSelection.Position = UDim2.new(0.48, 0, 0, Lib.HueSelectionPosition);
						pcall(callback, BoxColor.BackgroundColor3);
						wait();
					end
				elseif not RainbowColorPicker then
					TweenService:Create(RainbowDot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play();
					TweenService:Create(RainbowDot, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position=UDim2.new(0.0799999982, 0, 0.126000002, 0)}):Play();
					BoxColor.BackgroundColor3 = OldToggleColor;
					Color.BackgroundColor3 = OldColor;
					ColorSelection.Position = OldColorSelectionPosition;
					HueSelection.Position = OldHueSelectionPosition;
					pcall(callback, BoxColor.BackgroundColor3);
				end
			end);
			Colorpicker.MouseButton1Click:Connect(function()
				Ripple(Colorpicker);
				if (ColorPickerToggled == false) then
					ColorPickerToggled = not ColorPickerToggled;
					ColorpickerFrame.Visible = true;
					ColorpickerFrame:TweenSize(UDim2.new(0, 448, 0, 98), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true);
					repeat
						wait();
					until ColorpickerFrame.Size == UDim2.new(0, 448, 0, 98) 
					ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
				else
					ColorPickerToggled = not ColorPickerToggled;
					ColorpickerFrame:TweenSize(UDim2.new(0, 448, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true);
					repeat
						wait();
					until ColorpickerFrame.Size == UDim2.new(0, 448, 0, 0) 
					ColorpickerFrame.Visible = false;
					ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
				end
			end);
			Confirm.MouseButton1Click:Connect(function()
				ColorPickerToggled = not ColorPickerToggled;
				ColorpickerFrame:TweenSize(UDim2.new(0, 448, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true);
				repeat
					wait();
				until ColorpickerFrame.Size == UDim2.new(0, 491, 0, 0) 
				ColorpickerFrame.Visible = false;
				ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
			end);
			ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
		end;
		TabItems.Textbox = function(self, text, disapper, callback)
			local Textbox = Instance.new("TextButton");
			local TextboxCorner = Instance.new("UICorner");
			local TextBox = Instance.new("TextBox");
			local TextBoxCorner = Instance.new("UICorner");
			Textbox.Name = "Textbox";
			Textbox.Parent = ContainerItemHolder;
			Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			Textbox.Position = UDim2.new(-0.230061352, 0, 0.856338024, 0);
			Textbox.Size = UDim2.new(0, 448, 0, 28);
			Textbox.AutoButtonColor = false;
			Textbox.Font = Enum.Font.Gotham;
			Textbox.Text = "";
			Textbox.TextColor3 = Color3.fromRGB(255, 255, 255);
			Textbox.TextSize = 14;
			TextboxCorner.CornerRadius = UDim.new(0, 6);
			TextboxCorner.Name = "TextboxCorner";
			TextboxCorner.Parent = Textbox;
			TextBox.Parent = Textbox;
			TextBox.AnchorPoint = Vector2.new(0.5, 0.5);
			TextBox.BackgroundColor3 = Color3.fromRGB(36, 36, 36);
			TextBox.Position = UDim2.new(0.5, 0, 0.5, 0);
			TextBox.Size = UDim2.new(0, 349, 0, 20);
			TextBox.Font = Enum.Font.Gotham;
			TextBox.PlaceholderColor3 = Color3.fromRGB(216, 216, 216);
			TextBox.PlaceholderText = text;
			TextBox.Text = "";
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
			TextBox.TextSize = 14;
			TextBoxCorner.CornerRadius = UDim.new(0, 6);
			TextBoxCorner.Name = "TextBoxCorner";
			TextBoxCorner.Parent = TextBox;
			TextBox.Focused:Connect(function()
				TextBox:TweenSize(UDim2.new(0, 399, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true);
			end);
			TextBox.FocusLost:Connect(function(ep)
				if ep then
					if (#TextBox.Text > 0) then
						pcall(callback, TextBox.Text);
						TextBox:TweenSize(UDim2.new(0, 349, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true);
						if disapper then
							TextBox.Text = "";
						end
					end
				end
			end);
			ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
		end;
		TabItems.Label = function(self, text)
			local Label = Instance.new("TextButton");
			local LabelCorner = Instance.new("UICorner");
			Label.Name = "Button";
			Label.Parent = ContainerItemHolder;
			Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			Label.Size = UDim2.new(0, 448, 0, 28);
			Label.AutoButtonColor = false;
			Label.Font = Enum.Font.Gotham;
			Label.TextColor3 = Color3.fromRGB(255, 255, 255);
			Label.TextSize = 14;
			Label.Text = text;
			Label.ClipsDescendants = true;
			LabelCorner.CornerRadius = UDim.new(0, 6);
			LabelCorner.Name = "ButtonCorner";
			LabelCorner.Parent = Label;
			ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
		end;
		TabItems.Keybind = function(self, text, presetbind, callback)
			local Key = presetbind.Name;
			local KeyBind = Instance.new("TextButton");
			local KeyBindCorner = Instance.new("UICorner");
			local Title = Instance.new("TextLabel");
			local BoxBind = Instance.new("Frame");
			local BoxCorner = Instance.new("UICorner");
			local CurrentBind = Instance.new("TextLabel");
			KeyBind.Name = "KeyBind";
			KeyBind.Parent = ContainerItemHolder;
			KeyBind.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			KeyBind.Position = UDim2.new(0.156441718, 0, 0.816901445, 0);
			KeyBind.Size = UDim2.new(0, 448, 0, 28);
			KeyBind.AutoButtonColor = false;
			KeyBind.Font = Enum.Font.Gotham;
			KeyBind.Text = "";
			KeyBind.TextColor3 = Color3.fromRGB(255, 255, 255);
			KeyBind.TextSize = 14;
			KeyBind.ClipsDescendants = true;
			KeyBindCorner.CornerRadius = UDim.new(0, 6);
			KeyBindCorner.Name = "KeyBindCorner";
			KeyBindCorner.Parent = KeyBind;
			Title.Name = "Title";
			Title.Parent = KeyBind;
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Title.BackgroundTransparency = 1;
			Title.Position = UDim2.new(0.0200892854, 0, 0, 0);
			Title.Size = UDim2.new(0, 0, 0, 28);
			Title.Font = Enum.Font.Gotham;
			Title.Text = text;
			Title.TextColor3 = Color3.fromRGB(255, 255, 255);
			Title.TextSize = 14;
			Title.TextXAlignment = Enum.TextXAlignment.Left;
			BoxBind.Name = "BoxBind";
			BoxBind.Parent = KeyBind;
			BoxBind.BackgroundColor3 = Color3.fromRGB(36, 36, 36);
			BoxBind.Position = UDim2.new(0.770089269, 0, 0.142857149, 0);
			BoxBind.Size = UDim2.new(0, 97, 0, 19);
			BoxCorner.CornerRadius = UDim.new(0, 6);
			BoxCorner.Name = "BoxCorner";
			BoxCorner.Parent = BoxBind;
			CurrentBind.Name = "CurrentBind";
			CurrentBind.Parent = BoxBind;
			CurrentBind.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			CurrentBind.BackgroundTransparency = 1;
			CurrentBind.Position = UDim2.new(0.247, 0, -0.210526317, 0);
			CurrentBind.Size = UDim2.new(0, 49, 0, 28);
			CurrentBind.Font = Enum.Font.Gotham;
			CurrentBind.Text = Key;
			CurrentBind.TextColor3 = Color3.fromRGB(255, 255, 255);
			CurrentBind.TextSize = 14;
			KeyBind.MouseEnter:Connect(function()
				TweenService:Create(KeyBind, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(45, 45, 45)}):Play();
			end);
			KeyBind.MouseLeave:Connect(function()
				TweenService:Create(KeyBind, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3=Color3.fromRGB(40, 40, 40)}):Play();
			end);
			KeyBind.MouseButton1Click:connect(function(e)
				Ripple(KeyBind);
				CurrentBind.Text = "...";
				local a, b = game:GetService("UserInputService").InputBegan:wait();
				if (a.KeyCode.Name ~= "Unknown") then
					CurrentBind.Text = a.KeyCode.Name;
					Key = a.KeyCode.Name;
				end
			end);
			game:GetService("UserInputService").InputBegan:connect(function(current, pressed)
				if not pressed then
					if (current.KeyCode.Name == Key) then
						pcall(callback);
					end
				end
			end);
			ContainerItemHolder.CanvasSize = UDim2.new(0, 0, 0, ItemHolderList.AbsoluteContentSize.Y);
		end;
		return TabItems;
	end;
	return WindowTabs;
end;
local function urbantp(goal, step, waitime)
	local jaw = game:GetService("Players").LocalPlayer.Character;
	step = step or 1;
	waitime = waitime or 0.3;
	local antifall = Instance.new("BodyVelocity");
	antifall.Parent = jaw.HumanoidRootPart;
	antifall.Velocity = Vector3.new(0, 0, 0);
	local pointerfol = Instance.new("Folder");
	pointerfol.Parent = game.Workspace;
	local nextx, nexty, nextz;
	local pos = jaw.HumanoidRootPart.Position;
	local rotationdata;
	goalpoint = Instance.new("Part");
	goalpoint.Parent = pointerfol;
	goalpoint.Size = Vector3.new(0.5, 0.5, 0.5);
	goalpoint.Position = goal;
	goalpoint.CanCollide = false;
	goalpoint.Anchored = true;
	goalpoint.Color = Color3.new(0, 0, 96);
	goalpoint.Transparency = 0;
	goalpoint.Material = Enum.Material.Neon;
	while true and wait(waitime) do
		jaw.Humanoid:ChangeState(11);
		pos = jaw.HumanoidRootPart.Position;
		local nextx, nexty, nextz;
		if (math.abs(pos.X - goal.X) > step) then
			if ((pos.X - goal.X) >= step) then
				nextx = -step;
			else
				nextx = step;
			end
		elseif (math.abs(pos.X - goal.X) <= step) then
			nextx = goal.x;
		end
		if (math.abs(pos.Y - goal.Y) > step) then
			if ((pos.Y - goal.Y) >= step) then
				nexty = -step;
			else
				nexty = step;
			end
		elseif (math.abs(pos.Y - goal.Y) <= step) then
			nexty = goal.y;
		end
		if (math.abs(pos.Z - goal.Z) > step) then
			if ((pos.Z - goal.Z) >= step) then
				nextz = -step;
			else
				nextz = step;
			end
		elseif (math.abs(pos.Z - goal.Z) <= step) then
			nextz = goal.z;
		end
		if (nextx ~= goal.x) then
			nextx = pos.x + nextx;
		end
		if (nexty ~= goal.y) then
			nexty = pos.y + nexty;
		end
		if (nextz ~= goal.z) then
			nextz = pos.z + nextz;
		end
		if (_G.urbantplookat ~= nil) then
			rotationdata = CFrame.new(jaw.HumanoidRootPart.CFrame.Position, _G.urbantplookat) - jaw.HumanoidRootPart.CFrame.Position;
		else
			rotationdata = jaw.HumanoidRootPart.CFrame - jaw.HumanoidRootPart.CFrame.Position;
		end
		jaw.HumanoidRootPart.CFrame = CFrame.new(nextx, nexty, nextz) * rotationdata;
		if ((nextx == goal.x) and (nexty == goal.y) and (nextz == goal.z)) then
			antifall:Destroy();
			goalpoint:Destroy();
			pcall(function()
				pointerfol:Destory();
			end);
			break;
		end
	end
end
function Move(place, stud, tw)
	local studs = stud;
	_G.move1 = true;
	while place.X < game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X do
		Wait(tw);
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X - studs, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z));
	end
	while place.Z < game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z do
		Wait(tw);
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z - studs));
	end
	while place.X > game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X do
		Wait(tw);
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X + studs, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z));
	end
	while place.Z > game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z do
		Wait(tw);
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z + studs));
	end
	while place.Y < game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y do
		Wait(tw);
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y - studs, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z));
	end
	while place.Y > game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y do
		Wait(tw);
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y + studs, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z));
	end
	_G.move1 = false;
end
spawn(function()
	game:GetService("RunService").Stepped:Connect(function()
		if _G.move1 then
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(11);
		end
	end);
end);
local TweenService = game:GetService("TweenService");
local noclipE = true;
local antifall = true;
local function noclip()
	for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		if (v:IsA("BasePart") and (v.CanCollide == true)) then
			v.CanCollide = false;
			game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0);
		end
	end
end
local function moveto(obj, speed)
	local info = TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude / speed, Enum.EasingStyle.Linear);
	local tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, info, {CFrame=obj});
	if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
		antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart);
		antifall.Velocity = Vector3.new(0, 0, 0);
		noclipE = game:GetService("RunService").Stepped:Connect(noclip);
		tween:Play();
	end
	tween.Completed:Connect(function()
		antifall:Destroy();
		noclipE:Disconnect();
	end);
end
function Mouse11()
	local VirtualUser = game:service("VirtualUser");
	VirtualUser:CaptureController();
	VirtualUser:ClickButton1(Vector2.new(100000, 100000));
end
print("Urban was here")
