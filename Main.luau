local Library = {}
Library.Windows = {}

local function New(ClassName, Properties)
	local Object = Instance.new(ClassName)
	if Properties then 
		for Property, Value in next, Properties do
			Object[Property] = Value
		end 
	end
	return Object
end

local TweenService = game:GetService("TweenService")

function Library:CreateWindow(config)
	if type(config) ~= "table" then
		warn("CreateWindow requires a table argument")
		return nil
	end

	local Window = {
		Tabs = {},
		CurrentTab = nil,
		Connections = {}
	}

	local windowIndex = #Library.Windows + 1
	local title = tostring(config.Title or "RCash Hub")
	local description = tostring(config.Description or "")

	local SeizureUI = New("ScreenGui", {
		Name = "SeizureUI_" .. windowIndex,
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	})

	local Background = New("Frame", {
		Name = "Background",
		Parent = SeizureUI,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(7, 7, 7),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.new(0.540589452 + (windowIndex - 1) * 0.05, 0, 0.453049481, 0),
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1
	})

	New("UICorner", {
		CornerRadius = UDim.new(0.0199999996, 0),
		Parent = Background
	})

	local BackgroundStroke = New("UIStroke", {
		Color = Color3.fromRGB(25, 25, 25),
		Thickness = 1,
		Transparency = 1,
		Parent = Background
	})

	TweenService:Create(Background, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 652, 0, 400),
		BackgroundTransparency = 0
	}):Play()

	task.spawn(function()
		task.wait(0.3)
		TweenService:Create(BackgroundStroke, TweenInfo.new(0.3), {
			Transparency = 0
		}):Play()
	end)

	New("TextLabel", {
		Name = "title",
		Parent = Background,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.0295828599, 0, 0.0304999929, 0),
		Size = UDim2.new(0, 548, 0, 21),
		Font = Enum.Font.GothamMedium,
		Text = title,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	if description ~= "" then
		New("TextLabel", {
			Name = "subtitle",
			Parent = Background,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.0295828599, 0, 0.0639999956, 0),
			Size = UDim2.new(0, 548, 0, 21),
			Font = Enum.Font.Gotham,
			Text = description,
			TextColor3 = Color3.fromRGB(150, 150, 150),
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	end

	local TitleBar = New("Frame", {
		Name = "TitleBar",
		Parent = Background,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 40)
	})

	local ContentBackground = New("Frame", {
		Name = "ContentBackground",
		Parent = Background,
		BackgroundColor3 = Color3.fromRGB(15, 15, 15),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Position = UDim2.new(0.237729788, 0, 0.115000002, 0),
		Size = UDim2.new(0, 497, 0, 354)
	})

	New("UICorner", {
		CornerRadius = UDim.new(0.00999999978, 0),
		Parent = ContentBackground
	})

	New("UIStroke", {
		Color = Color3.fromRGB(25, 25, 25),
		Thickness = 1,
		Parent = ContentBackground
	})

	local TabContainer = New("Frame", {
		Name = "TabContainer",
		Parent = Background,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.019, 0, 0.141499937, 0),
		Size = UDim2.new(0, 135, 0, 324)
	})

	New("UIListLayout", {
		Parent = TabContainer,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8)
	})

	local ContentContainer = New("ScrollingFrame", {
		Name = "ContentContainer",
		Parent = Background,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.236791313, 0, 0.116499938, 0),
		Size = UDim2.new(0.763208568, 0, 0.88350004, 0),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 4
	})

	New("UIPadding", {
		Parent = ContentContainer,
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10)
	})

	local dragging, dragInput, dragStart, startPos, dragTween

	local function startDrag(input)
		dragging = true
		dragStart = input.Position
		startPos = Background.Position
		if dragTween then dragTween:Cancel() end
	end

	local function endDrag()
		dragging = false
	end

	local function updateDrag(input)
		if not dragging then return end
		local delta = input.Position - dragStart
		local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		if dragTween then dragTween:Cancel() end
		dragTween = TweenService:Create(Background, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPosition})
		dragTween:Play()
	end

	table.insert(Window.Connections, TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			startDrag(input)
			table.insert(Window.Connections, input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then endDrag() end
			end))
		end
	end))

	table.insert(Window.Connections, TitleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end))

	table.insert(Window.Connections, game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput then updateDrag(input) end
	end))

	function Window:CreateTab(name)
		if type(name) ~= "string" or name == "" then
			warn("Tab name must be a non-empty string")
			return nil
		end

		local Tab = {Elements = {}}
		local isFirstTab = #Window.Tabs == 0

		local TabButton = New("TextButton", {
			Name = "Tab_" .. name,
			Parent = TabContainer,
			BackgroundColor3 = Color3.fromRGB(15, 15, 15),
			BackgroundTransparency = isFirstTab and 0 or 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0.982876241, 0, 0, 35),
			Font = Enum.Font.Gotham,
			Text = name,
			TextColor3 = isFirstTab and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false
		})

		New("UIPadding", {Parent = TabButton, PaddingLeft = UDim.new(0, 5)})
		New("UICorner", {CornerRadius = UDim.new(0.1, 0), Parent = TabButton})

		local TabStroke = New("UIStroke", {
			Color = Color3.fromRGB(116, 116, 116),
			Thickness = 1,
			Transparency = isFirstTab and 0.80 or 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = TabButton
		})

		local TabContent = New("Frame", {
			Name = "TabContent_" .. name,
			Parent = ContentContainer,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = isFirstTab
		})

		local TabLayout = New("UIListLayout", {
			Parent = TabContent,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		})

		table.insert(Window.Connections, TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ContentContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
		end))

		table.insert(Window.Connections, TabButton.MouseButton1Click:Connect(function()
			if Window.CurrentTab == Tab then return end

			for _, tab in pairs(Window.Tabs) do
				TweenService:Create(tab.Button, TweenInfo.new(0.2), {
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(150, 150, 150)
				}):Play()

				local stroke = tab.Button:FindFirstChildOfClass("UIStroke")
				if stroke then
					TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
				end

				if tab.Content then tab.Content.Visible = false end
			end

			TweenService:Create(TabButton, TweenInfo.new(0.2), {
				BackgroundTransparency = 0,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()

			TweenService:Create(TabStroke, TweenInfo.new(0.2), {Transparency = 0.80}):Play()

			Window.CurrentTab = Tab
			TabContent.Visible = true
		end))

		Tab.Button = TabButton
		Tab.Content = TabContent

		table.insert(Window.Tabs, Tab)
		if isFirstTab then Window.CurrentTab = Tab end

		function Tab:AddParagraph(titleText, contentText)
			titleText = tostring(titleText or "")
			contentText = tostring(contentText or "")

			local Paragraph = {Type = "Paragraph", Title = titleText, Content = contentText, Visible = true}
			table.insert(Tab.Elements, Paragraph)
			Tab:Render()

			return {
				Hide = function() Paragraph.Visible = false Tab:Render() end,
				Show = function() Paragraph.Visible = true Tab:Render() end
			}
		end

		function Tab:AddButton(text, callback)
			text = tostring(text or "Button")
			if type(callback) ~= "function" then callback = function() end end

			local Button = {Type = "Button", Text = text, Callback = callback, Visible = true}
			table.insert(Tab.Elements, Button)
			Tab:Render()

			return {
				Hide = function() Button.Visible = false Tab:Render() end,
				Show = function() Button.Visible = true Tab:Render() end
			}
		end

		function Tab:AddToggle(text, default, callback)
			text = tostring(text or "Toggle")
			if type(default) ~= "boolean" then default = false end
			if type(callback) ~= "function" then callback = function() end end

			local Toggle = {Type = "Toggle", Text = text, Value = default, Callback = callback, Visible = true}
			table.insert(Tab.Elements, Toggle)
			Tab:Render()

			return {
				Set = function(_, value)
					if type(value) == "boolean" then
						Toggle.Value = value
						Tab:Render()
					end
				end,
				Hide = function() Toggle.Visible = false Tab:Render() end,
				Show = function() Toggle.Visible = true Tab:Render() end
			}
		end

		function Tab:Render()
			for _, child in pairs(TabContent:GetChildren()) do
				if child:IsA("Frame") then child:Destroy() end
			end

			for _, element in pairs(Tab.Elements) do
				if not element.Visible then continue end

				if element.Type == "Paragraph" then
					local Paragraph = New("Frame", {
						Parent = TabContent,
						BackgroundColor3 = Color3.fromRGB(20, 20, 20),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})

					New("UICorner", {CornerRadius = UDim.new(0.05, 0), Parent = Paragraph})
					New("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = Paragraph})
					New("UIPadding", {
						Parent = Paragraph,
						PaddingBottom = UDim.new(0, 12),
						PaddingLeft = UDim.new(0, 12),
						PaddingRight = UDim.new(0, 12),
						PaddingTop = UDim.new(0, 12)
					})

					local Container = New("Frame", {
						Parent = Paragraph,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})

					New("UIListLayout", {
						Parent = Container,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					})

					New("TextLabel", {
						Parent = Container,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						Font = Enum.Font.GothamMedium,
						Text = element.Title,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 1
					})

					New("TextLabel", {
						Parent = Container,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						Font = Enum.Font.Gotham,
						Text = element.Content,
						TextColor3 = Color3.fromRGB(150, 150, 150),
						TextSize = 13,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 2
					})

				elseif element.Type == "Button" then
					local ButtonFrame = New("Frame", {
						Parent = TabContent,
						BackgroundColor3 = Color3.fromRGB(20, 20, 20),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 42)
					})

					New("UICorner", {CornerRadius = UDim.new(0.1, 0), Parent = ButtonFrame})
					New("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = ButtonFrame})

					New("TextLabel", {
						Parent = ButtonFrame,
						BackgroundTransparency = 1,
						Position = UDim2.new(0.026, 0, 0, 0),
						Size = UDim2.new(0.95, 0, 1, 0),
						Font = Enum.Font.GothamMedium,
						Text = element.Text,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					})

					local ClickButton = New("TextButton", {
						Parent = ButtonFrame,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						AutoButtonColor = false
					})

					ClickButton.MouseButton1Click:Connect(function()
						pcall(function()
							TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
							task.spawn(function()
								task.wait(0.1)
								TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
							end)
							element.Callback()
						end)
					end)

				elseif element.Type == "Toggle" then
					local ToggleFrame = New("Frame", {
						Parent = TabContent,
						BackgroundColor3 = Color3.fromRGB(20, 20, 20),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 42)
					})

					New("UICorner", {CornerRadius = UDim.new(0.1, 0), Parent = ToggleFrame})
					New("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = ToggleFrame})

					New("TextLabel", {
						Parent = ToggleFrame,
						BackgroundTransparency = 1,
						Position = UDim2.new(0.026, 0, 0, 0),
						Size = UDim2.new(0.85, 0, 1, 0),
						Font = Enum.Font.GothamMedium,
						Text = element.Text,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					})

					local Indicator = New("Frame", {
						Parent = ToggleFrame,
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundColor3 = element.Value and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(30, 30, 30),
						BorderSizePixel = 0,
						Position = UDim2.new(0.975, 0, 0.5, 0),
						Size = UDim2.new(0, 20, 0, 20)
					})

					New("UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = Indicator})
					New("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = Indicator})

					local ClickButton = New("TextButton", {
						Parent = ToggleFrame,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						AutoButtonColor = false
					})

					ClickButton.MouseButton1Click:Connect(function()
						pcall(function()
							element.Value = not element.Value
							TweenService:Create(Indicator, TweenInfo.new(0.2), {
								BackgroundColor3 = element.Value and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(30, 30, 30)
							}):Play()
							element.Callback(element.Value)
						end)
					end)
				end
			end
		end

		return Tab
	end

	function Window:Destroy()
		pcall(function()
			for _, connection in pairs(Window.Connections) do
				if typeof(connection) == "RBXScriptConnection" then
					connection:Disconnect()
				end
			end
			if dragTween then dragTween:Cancel() end
			SeizureUI:Destroy()
			for i, win in pairs(Library.Windows) do
				if win == Window then
					table.remove(Library.Windows, i)
					break
				end
			end
		end)
	end

	table.insert(Library.Windows, Window)
	return Window
end

return Library
