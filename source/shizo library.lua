local library = {flags = {}, windows = {}, open = true}
local inputService = game:GetService("UserInputService")
local ui = Enum.UserInputType.MouseButton1
local dragging, dragInput, dragStart, startPos, dragObject

local function update(input)
	local delta = input.Position - dragStart
	local yPos = (startPos.Y.Offset + delta.Y) < -36 and -36 or startPos.Y.Offset + delta.Y
	dragObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, yPos)
end

function library:Create(class, properties)
	properties = typeof(properties) == "table" and properties or {}
	local inst = Instance.new(class)
	for property, value in next, properties do
		inst[property] = value
	end
	return inst
end

local function createOptionHolder(holderTitle, parent, parentTable, subHolder)
	local size = subHolder and 34 or 40
	
	parentTable.main = library:Create("Frame", {
		LayoutOrder = subHolder and parentTable.position or 0,
		Position = UDim2.new(0, 20 + (180 * (parentTable.position or 0)), 0, 20),
		Size = UDim2.new(0, 170, 0, size),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 1,
		ClipsDescendants = true,
		Parent = parent
	})
	
	local title = library:Create("TextLabel", {
		Size = UDim2.new(1, 0, 0, size),
		BackgroundColor3 = subHolder and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(15, 15, 15),
		BorderSizePixel = 0,
		Text = holderTitle,
		TextSize = subHolder and 14 or 15,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = parentTable.main
	})
	
	local closeHolder = library:Create("TextButton", {
		Position = UDim2.new(1, -25, 0, 0),
		Size = UDim2.new(0, 25, 0, size),
		BackgroundTransparency = 1,
		Text = parentTable.open and "v" or ">",
		TextSize = 12,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = title
	})
	
	parentTable.content = library:Create("Frame", {
		Position = UDim2.new(0, 0, 0, size),
		Size = UDim2.new(1, 0, 1, -size),
		BackgroundTransparency = 1,
		Parent = parentTable.main
	})
	
	local layout = library:Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parentTable.content
	})
	
	layout.Changed:connect(function()
		parentTable.content.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
		parentTable.main.Size = #parentTable.options > 0 and parentTable.open and UDim2.new(0, 170, 0, layout.AbsoluteContentSize.Y + size) or UDim2.new(0, 170, 0, size)
	end)
	
	if not subHolder then
		title.InputBegan:connect(function(input)
			if input.UserInputType == ui then
				dragObject = parentTable.main
				dragging = true
				dragStart = input.Position
				startPos = dragObject.Position
			elseif input.UserInputType == Enum.UserInputType.Touch then
				dragObject = parentTable.main
				dragging = true
				dragStart = input.Position
				startPos = dragObject.Position
			end
		end)
		
		title.InputChanged:connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			elseif dragging and input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		
		title.InputEnded:connect(function(input)
			if input.UserInputType == ui then
				dragging = false
			elseif input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end
	
	closeHolder.MouseButton1Click:connect(function()
		parentTable.open = not parentTable.open
		closeHolder.Text = parentTable.open and "v" or ">"
		parentTable.main.Size = #parentTable.options > 0 and parentTable.open and UDim2.new(0, 170, 0, layout.AbsoluteContentSize.Y + size) or UDim2.new(0, 170, 0, size)
	end)

	function parentTable:SetTitle(newTitle)
		title.Text = tostring(newTitle)
	end
	
	return parentTable
end

local function createLabel(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 25),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 1,
		Text = " " .. option.text,
		TextSize = 13,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	function option:SetText(text)
		main.Text = " " .. tostring(text)
	end
end

local function createSlider(option, parent)
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 45),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 1,
		Parent = parent.content
	})
	
	local label = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 2),
		Size = UDim2.new(1, -30, 0, 15),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 12,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = main
	})
	
	local value = library:Create("TextLabel", {
		Position = UDim2.new(1, -25, 0, 2),
		Size = UDim2.new(0, 20, 0, 15),
		BackgroundTransparency = 1,
		Text = tostring(option.value),
		TextSize = 12,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = main
	})
	
	local slider = library:Create("Frame", {
		Position = UDim2.new(0, 5, 0, 22),
		Size = UDim2.new(1, -10, 0, 18),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 1,
		Parent = main
	})
	
	local fill = library:Create("Frame", {
		Size = UDim2.new((option.value - option.min) / (option.max - option.min), 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 0,
		Parent = slider
	})
	
	local sliding = false
	
	slider.InputBegan:connect(function(input)
		if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
			sliding = true
			local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
			option:SetValue(option.min + (option.max - option.min) * x)
		end
	end)
	
	slider.InputEnded:connect(function(input)
		if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
			sliding = false
		end
	end)
	
	inputService.InputChanged:connect(function(input)
		if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
			local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
			option:SetValue(option.min + (option.max - option.min) * x)
		end
	end)
	
	function option:SetValue(val)
		val = math.clamp(math.floor(val), self.min, self.max)
		self.value = val
		value.Text = tostring(val)
		fill.Size = UDim2.new((val - self.min) / (self.max - self.min), 0, 1, 0)
		library.flags[self.flag] = val
		self.callback(val)
	end
end

local function createButton(option, parent)
	local main = library:Create("TextButton", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 1,
		Text = option.text,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = parent.content
	})
	
	main.MouseButton1Click:connect(function()
		library.flags[option.flag] = true
		option.callback()
	end)
end

local function createToggle(option, parent)
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 1,
		Parent = parent.content
	})
	
	local label = library:Create("TextLabel", {
		Size = UDim2.new(1, -35, 1, 0),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = main
	})
	
	local toggle = library:Create("TextButton", {
		Position = UDim2.new(1, -30, 0, 5),
		Size = UDim2.new(0, 20, 0, 20),
		BackgroundColor3 = option.state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 1,
		Text = "",
		Parent = main
	})
	
	toggle.MouseButton1Click:connect(function()
		option.state = not option.state
		toggle.BackgroundColor3 = option.state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
		library.flags[option.flag] = option.state
		option.callback(option.state)
	end)
	
	function option:SetState(state)
		self.state = state
		toggle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
		library.flags[self.flag] = state
		self.callback(state)
	end
end

local function createBox(option, parent)
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 1,
		Parent = parent.content
	})
	
	local label = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 2),
		Size = UDim2.new(1, -10, 0, 15),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 12,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(150, 150, 150),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = main
	})
	
	local box = library:Create("TextBox", {
		Position = UDim2.new(0, 5, 0, 20),
		Size = UDim2.new(1, -10, 0, 25),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 1,
		Text = option.value,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		PlaceholderText = option.text,
		Parent = main
	})
	
	box.FocusLost:connect(function(enter)
		option.value = box.Text
		library.flags[option.flag] = box.Text
		option.callback(box.Text, enter)
	end)
	
	function option:SetValue(value)
		self.value = tostring(value)
		box.Text = self.value
		library.flags[self.flag] = self.value
		self.callback(value)
	end
end

local function loadOptions(option, parent)
	for _, newOption in next, option.options do
		if newOption.type == "label" then
			createLabel(newOption, option)
		elseif newOption.type == "slider" then
			createSlider(newOption, option)
		elseif newOption.type == "button" then
			createButton(newOption, option)
		elseif newOption.type == "toggle" then
			createToggle(newOption, option)
		elseif newOption.type == "box" then
			createBox(newOption, option)
		elseif newOption.type == "folder" then
			newOption:init()
		end
	end
end

local function getFunctions(parent)
	function parent:AddLabel(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.type = "label"
		option.position = #self.options
		table.insert(self.options, option)
		return option
	end
	
	function parent:AddSlider(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.min = typeof(option.min) == "number" and option.min or 0
		option.max = typeof(option.max) == "number" and option.max or 100
		option.value = math.clamp(typeof(option.value) == "number" and option.value or option.min, option.min, option.max)
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "slider"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.value
		table.insert(self.options, option)
		return option
	end
	
	function parent:AddButton(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "button"
		option.position = #self.options
		option.flag = option.flag or option.text
		table.insert(self.options, option)
		return option
	end
	
	function parent:AddToggle(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.state = typeof(option.state) == "boolean" and option.state or false
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "toggle"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.state
		table.insert(self.options, option)
		return option
	end
	
	function parent:AddBox(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.value = tostring(option.value or "")
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "box"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.value
		table.insert(self.options, option)
		return option
	end
	
	function parent:AddFolder(title)
		local option = {}
		option.title = tostring(title)
		option.options = {}
		option.open = false
		option.type = "folder"
		option.position = #self.options
		table.insert(self.options, option)
		
		getFunctions(option)
		
		function option:init()
			createOptionHolder(self.title, parent.content, self, true)
			loadOptions(self, parent)
		end
		
		return option
	end
end

function library:CreateWindow(title)
	local window = {
		title = tostring(title), 
		options = {}, 
		open = true, 
		canInit = true, 
		init = false, 
		position = #self.windows
	}
	getFunctions(window)
	table.insert(library.windows, window)
	return window
end

function library:Init()
	self.base = self.base or self:Create("ScreenGui")
	if syn and syn.protect_gui then
		syn.protect_gui(self.base)
	elseif get_hidden_gui then
		get_hidden_gui(self.base)
	elseif gethui then
		gethui(self.base)
	end
	self.base.Parent = game:GetService("CoreGui")
	self.base.ResetOnSpawn = false
	self.base.Name = "Library"
	for _, window in next, self.windows do
		if window.canInit and not window.init then
			window.init = true
			createOptionHolder(window.title, self.base, window)
			loadOptions(window, window)
		end
	end
	return self.base
end

function library:Close()
	if typeof(self.base) ~= "Instance" then return end
	self.open = not self.open
	for _, window in next, self.windows do
		if window.main then
			window.main.Visible = self.open
		end
	end
end

inputService.InputChanged:connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

return library
