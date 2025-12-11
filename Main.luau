local Library = {Windows = {}}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local function Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do obj[k] = v end
	return obj
end

local function Tween(obj, props, duration, style, direction)
	return TweenService:Create(obj, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props)
end

function Library:CreateWindow(config)
	if type(config) ~= "table" then return warn("Config must be a table") end

	local Window = {
		Tabs = {},
		CurrentTab = nil,
		Connections = {},
		Title = tostring(config.Title or "UI Library"),
		Description = tostring(config.Description or ""),
		Image = config.Image or nil,
		ImageTransparency = type(config.ImageTransparency) == "number" and config.ImageTransparency or 0.42
	}

	local windowOffset = #Library.Windows * 0.05

	local gui = Create("ScreenGui", {
		Name = "LibraryUI_" .. (#Library.Windows + 1),
		Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	})

	local main = Create("Frame", {
		Name = "Main",
		Parent = gui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5 + windowOffset, 0, 0.5, 0),
		Size = UDim2.new(0, 652, 0, 400),
		BackgroundColor3 = Color3.fromRGB(7, 7, 7),
		BorderSizePixel = 0,
		ClipsDescendants = true
	})

	Create("UICorner", {CornerRadius = UDim.new(0.02, 0), Parent = main})
	Create("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = main})

	if Window.Image then
		local bgImage = Create("ImageLabel", {
			Parent = main,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = Window.Image,
			ImageTransparency = Window.ImageTransparency,
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 0
		})

		Create("UICorner", {CornerRadius = UDim.new(0.02, 0), Parent = bgImage})
	end

	local titleBar = Create("Frame", {
		Name = "TitleBar",
		Parent = main,
		Size = UDim2.new(1, 0, 0, 46),
		BackgroundTransparency = 1
	})

	Create("TextLabel", {
		Parent = titleBar,
		Position = UDim2.new(0, 20, 0, 12),
		Size = UDim2.new(1, -40, 0, 18),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = Window.Title,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	if Window.Description ~= "" then
		Create("TextLabel", {
			Parent = titleBar,
			Position = UDim2.new(0, 20, 0, 28),
			Size = UDim2.new(1, -40, 0, 14),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			Text = Window.Description,
			TextColor3 = Color3.fromRGB(150, 150, 150),
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	end

	local contentBg = Create("Frame", {
		Parent = main,
		Position = UDim2.new(0.238, 0, 0.115, 0),
		Size = UDim2.new(0, 497, 0, 354),
		BackgroundColor3 = Color3.fromRGB(15, 15, 15),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0
	})

	Create("UICorner", {CornerRadius = UDim.new(0.01, 0), Parent = contentBg})
	Create("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = contentBg})

	local tabContainer = Create("Frame", {
		Parent = main,
		Position = UDim2.new(0.019, 0, 0.141, 0),
		Size = UDim2.new(0, 135, 0, 324),
		BackgroundTransparency = 1
	})

	Create("UIListLayout", {Parent = tabContainer, Padding = UDim.new(0, 8)})

	local contentScroll = Create("ScrollingFrame", {
		Parent = main,
		Position = UDim2.new(0.237, 0, 0.116, 0),
		Size = UDim2.new(0.763, 0, 0.883, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})

	Create("UIPadding", {
		Parent = contentScroll,
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10)
	})

	local dragging, dragStart, startPos

	table.insert(Window.Connections, titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end))

	table.insert(Window.Connections, UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end))

	table.insert(Window.Connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))

	function Window:CreateTab(name)
		if type(name) ~= "string" or name == "" then return warn("Tab name required") end

		local Tab = {Elements = {}, Name = name}
		local isFirst = #Window.Tabs == 0

		local btn = Create("TextButton", {
			Parent = tabContainer,
			Size = UDim2.new(0.98, 0, 0, 35),
			BackgroundColor3 = Color3.fromRGB(15, 15, 15),
			BackgroundTransparency = isFirst and 0 or 1,
			BorderSizePixel = 0,
			Font = Enum.Font.Gotham,
			Text = name,
			TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false
		})

		Create("UIPadding", {Parent = btn, PaddingLeft = UDim.new(0, 5)})
		Create("UICorner", {CornerRadius = UDim.new(0.1, 0), Parent = btn})

		local stroke = Create("UIStroke", {
			Color = Color3.fromRGB(116, 116, 116),
			Thickness = 1,
			Transparency = isFirst and 0.8 or 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = btn
		})

		local content = Create("Frame", {
			Parent = contentScroll,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = isFirst
		})

		local layout = Create("UIListLayout", {Parent = content, Padding = UDim.new(0, 8)})

		table.insert(Window.Connections, layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			contentScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
		end))

		table.insert(Window.Connections, btn.MouseButton1Click:Connect(function()
			if Window.CurrentTab == Tab then return end

			for _, tab in ipairs(Window.Tabs) do
				Tween(tab.Button, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
				Tween(tab.Stroke, {Transparency = 1}):Play()
				tab.Content.Visible = false
			end

			Tween(btn, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			Tween(stroke, {Transparency = 0.8}):Play()
			content.Visible = true
			Window.CurrentTab = Tab
		end))

		Tab.Button = btn
		Tab.Stroke = stroke
		Tab.Content = content

		table.insert(Window.Tabs, Tab)
		if isFirst then Window.CurrentTab = Tab end

		function Tab:AddParagraph(title, text)
			local elem = {Type = "Paragraph", Title = tostring(title or ""), Text = tostring(text or ""), Visible = true}
			table.insert(Tab.Elements, elem)
			Tab:Render()
			return {
				Hide = function() elem.Visible = false Tab:Render() end,
				Show = function() elem.Visible = true Tab:Render() end
			}
		end

		function Tab:AddButton(text, callback)
			local elem = {Type = "Button", Text = tostring(text or "Button"), Callback = callback or function() end, Visible = true}
			table.insert(Tab.Elements, elem)
			Tab:Render()
			return {
				Hide = function() elem.Visible = false Tab:Render() end,
				Show = function() elem.Visible = true Tab:Render() end
			}
		end

		function Tab:AddToggle(text, default, callback)
			local elem = {
				Type = "Toggle",
				Text = tostring(text or "Toggle"),
				Value = type(default) == "boolean" and default or false,
				Callback = callback or function() end,
				Visible = true
			}
			table.insert(Tab.Elements, elem)
			Tab:Render()
			return {
				Set = function(_, val) if type(val) == "boolean" then elem.Value = val Tab:Render() end end,
				Hide = function() elem.Visible = false Tab:Render() end,
				Show = function() elem.Visible = true Tab:Render() end
			}
		end

		function Tab:AddTextBox(text, placeholder, callback)
			local elem = {
				Type = "TextBox",
				Text = tostring(text or "TextBox"),
				Placeholder = tostring(placeholder or ""),
				Value = "",
				Callback = callback or function() end,
				Visible = true
			}
			table.insert(Tab.Elements, elem)
			Tab:Render()
			return {
				SetValue = function(_, val) elem.Value = tostring(val) Tab:Render() end,
				Hide = function() elem.Visible = false Tab:Render() end,
				Show = function() elem.Visible = true Tab:Render() end
			}
		end

		function Tab:Render()
			for _, child in ipairs(content:GetChildren()) do
				if child:IsA("Frame") then child:Destroy() end
			end

			for _, elem in ipairs(Tab.Elements) do
				if not elem.Visible then continue end

				if elem.Type == "Paragraph" then
					local frame = Create("Frame", {
						Parent = content,
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundColor3 = Color3.fromRGB(20, 20, 20),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y
					})

					Create("UICorner", {CornerRadius = UDim.new(0.05, 0), Parent = frame})
					Create("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = frame})
					Create("UIPadding", {Parent = frame, PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12)})

					local container = Create("Frame", {Parent = frame, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y})
					Create("UIListLayout", {Parent = container, Padding = UDim.new(0, 4)})

					Create("TextLabel", {
						Parent = container,
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.Gotham,
						Text = elem.Title,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y
					})

					Create("TextLabel", {
						Parent = container,
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.Gotham,
						Text = elem.Text,
						TextColor3 = Color3.fromRGB(150, 150, 150),
						TextSize = 13,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y
					})

				elseif elem.Type == "Button" then
					local frame = Create("Frame", {
						Parent = content,
						Size = UDim2.new(1, 0, 0, 42),
						BackgroundColor3 = Color3.fromRGB(20, 20, 20),
						BorderSizePixel = 0
					})

					Create("UICorner", {CornerRadius = UDim.new(0.1, 0), Parent = frame})
					Create("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = frame})

					Create("TextLabel", {
						Parent = frame,
						Position = UDim2.new(0.026, 0, 0, 0),
						Size = UDim2.new(0.95, 0, 1, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.Gotham,
						Text = elem.Text,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					})

					local btn = Create("TextButton", {
						Parent = frame,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false
					})

					btn.MouseButton1Click:Connect(function()
						pcall(function()
							Tween(frame, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.1):Play()
							task.delay(0.1, function() Tween(frame, {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}, 0.1):Play() end)
							elem.Callback()
						end)
					end)

				elseif elem.Type == "Toggle" then
					local frame = Create("Frame", {
						Parent = content,
						Size = UDim2.new(1, 0, 0, 42),
						BackgroundColor3 = Color3.fromRGB(20, 20, 20),
						BorderSizePixel = 0
					})

					Create("UICorner", {CornerRadius = UDim.new(0.1, 0), Parent = frame})
					Create("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = frame})

					Create("TextLabel", {
						Parent = frame,
						Position = UDim2.new(0.026, 0, 0, 0),
						Size = UDim2.new(0.85, 0, 1, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.Gotham,
						Text = elem.Text,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					})

					local indicator = Create("Frame", {
						Parent = frame,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(0.975, 0, 0.5, 0),
						Size = UDim2.new(0, 20, 0, 20),
						BackgroundColor3 = elem.Value and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(30, 30, 30),
						BorderSizePixel = 0
					})

					Create("UICorner", {CornerRadius = UDim.new(0.2, 0), Parent = indicator})
					Create("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = indicator})

					local btn = Create("TextButton", {
						Parent = frame,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false
					})

					btn.MouseButton1Click:Connect(function()
						pcall(function()
							elem.Value = not elem.Value
							Tween(indicator, {BackgroundColor3 = elem.Value and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(30, 30, 30)}):Play()
							elem.Callback(elem.Value)
						end)
					end)

				elseif elem.Type == "TextBox" then
					local frame = Create("Frame", {
						Parent = content,
						Size = UDim2.new(1, 0, 0, 70),
						BackgroundColor3 = Color3.fromRGB(20, 20, 20),
						BorderSizePixel = 0
					})

					Create("UICorner", {CornerRadius = UDim.new(0.1, 0), Parent = frame})
					Create("UIStroke", {Color = Color3.fromRGB(25, 25, 25), Thickness = 1, Parent = frame})

					Create("TextLabel", {
						Parent = frame,
						Position = UDim2.new(0.026, 0, 0, 8),
						Size = UDim2.new(0.95, 0, 0, 18),
						BackgroundTransparency = 1,
						Font = Enum.Font.Gotham,
						Text = elem.Text,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					})

					local inputFrame = Create("Frame", {
						Parent = frame,
						Position = UDim2.new(0.026, 0, 0, 34),
						Size = UDim2.new(0.948, 0, 0, 28),
						BackgroundColor3 = Color3.fromRGB(15, 15, 15),
						BorderSizePixel = 0
					})

					Create("UICorner", {CornerRadius = UDim.new(0.15, 0), Parent = inputFrame})
					Create("UIStroke", {Color = Color3.fromRGB(40, 40, 40), Thickness = 1, Parent = inputFrame})

					local input = Create("TextBox", {
						Parent = inputFrame,
						Position = UDim2.new(0, 10, 0, 0),
						Size = UDim2.new(1, -20, 1, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.Gotham,
						PlaceholderText = elem.Placeholder,
						PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
						Text = elem.Value,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						ClearTextOnFocus = false
					})

					input.FocusLost:Connect(function()
						pcall(function()
							elem.Value = input.Text
							elem.Callback(input.Text)
						end)
					end)
				end
			end
		end

		return Tab
	end

	function Window:Destroy()
		pcall(function()
			for _, conn in ipairs(Window.Connections) do
				if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
			end
			gui:Destroy()
			for i, win in ipairs(Library.Windows) do
				if win == Window then table.remove(Library.Windows, i) break end
			end
		end)
	end

	table.insert(Library.Windows, Window)
	return Window
end

return Library
