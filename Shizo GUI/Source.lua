-- ========================================
-- ROBLOX GUI TEMPLATE
-- my GUI template
-- ========================================

-- CONFIGURATION
local CONFIG = {
	GUI_NAME = "SmallBlackGUI",
	WINDOW_TITLE = "GUI",
	WINDOW_SIZE = {Width = 150, MinHeight = 140},
	CREDITS_TEXT = "YouTube: ShizoScript",
	
	-- Element Spacing
	SPACING = {
		ElementHeight = 25,
		ElementSpacing = 5,
		HeaderHeight = 25,
		CreditsHeight = 15,
		ContainerPadding = 5
	},
	
	-- Colors
	COLORS = {
		MainBackground = Color3.fromRGB(10, 10, 10),
		HeaderBackground = Color3.fromRGB(15, 15, 15),
		ButtonBackground = Color3.fromRGB(20, 20, 20),
		TextColor = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(0, 255, 0),
		ToggleOff = Color3.fromRGB(50, 50, 50),
		CreditsText = Color3.fromRGB(150, 150, 150)
	}
}


-- SETUP SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = CONFIG.GUI_NAME
ScreenGui.ResetOnSpawn = false

pcall(function()
	ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
	ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end


-- AUTO-RESIZE FUNCTION
local Elements = {}

local function UpdateGUISize()
	local elementCount = #Elements
	local totalHeight = CONFIG.SPACING.HeaderHeight + 
	                   CONFIG.SPACING.ContainerPadding * 2 + 
	                   CONFIG.SPACING.CreditsHeight +
	                   (elementCount * CONFIG.SPACING.ElementHeight) +
	                   ((elementCount - 1) * CONFIG.SPACING.ElementSpacing)
	
	totalHeight = math.max(totalHeight, CONFIG.WINDOW_SIZE.MinHeight)
	
	MainFrame.Size = UDim2.new(0, CONFIG.WINDOW_SIZE.Width, 0, totalHeight)
	MainFrame.Position = UDim2.new(0.5, -CONFIG.WINDOW_SIZE.Width/2, 0.5, -totalHeight/2)
	
	Container.Size = UDim2.new(1, -10, 1, -(CONFIG.SPACING.HeaderHeight + CONFIG.SPACING.CreditsHeight + 10))
end


-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, CONFIG.WINDOW_SIZE.Width, 0, CONFIG.WINDOW_SIZE.MinHeight)
MainFrame.Position = UDim2.new(0.5, -CONFIG.WINDOW_SIZE.Width/2, 0.5, -CONFIG.WINDOW_SIZE.MinHeight/2)
MainFrame.BackgroundColor3 = CONFIG.COLORS.MainBackground
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = ScreenGui


-- HEADER
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 25)
Header.BackgroundColor3 = CONFIG.COLORS.HeaderBackground
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -25, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = CONFIG.WINDOW_TITLE
Title.TextColor3 = CONFIG.COLORS.TextColor
Title.TextSize = 14
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.BackgroundColor3 = CONFIG.COLORS.ButtonBackground
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = CONFIG.COLORS.TextColor
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.Code
CloseButton.Parent = Header

CloseButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)


-- CONTAINER
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Position = UDim2.new(0, 5, 0, 30)
Container.Size = UDim2.new(1, -10, 1, -50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Add UIListLayout for automatic positioning
local ListLayout = Instance.new("UIListLayout")
ListLayout.Name = "ListLayout"
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, CONFIG.SPACING.ElementSpacing)
ListLayout.Parent = Container


-- BUTTON 
local Button1 = Instance.new("TextButton")
Button1.Name = "Button1"
Button1.Size = UDim2.new(1, 0, 0, CONFIG.SPACING.ElementHeight)
Button1.BackgroundColor3 = CONFIG.COLORS.ButtonBackground
Button1.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button1.BorderSizePixel = 1
Button1.Text = "Button 1"
Button1.TextColor3 = CONFIG.COLORS.TextColor
Button1.TextSize = 12
Button1.Font = Enum.Font.Code
Button1.LayoutOrder = 1
Button1.Parent = Container

table.insert(Elements, Button1)

Button1.MouseButton1Click:Connect(function()
	-- ADD YOUR BUTTON 1 CODE HERE
	print("Button 1 clicked")
end)


-- BUTTON
local Button2 = Instance.new("TextButton")
Button2.Name = "Button2"
Button2.Size = UDim2.new(1, 0, 0, CONFIG.SPACING.ElementHeight)
Button2.BackgroundColor3 = CONFIG.COLORS.ButtonBackground
Button2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button2.BorderSizePixel = 1
Button2.Text = "Button 2"
Button2.TextColor3 = CONFIG.COLORS.TextColor
Button2.TextSize = 12
Button2.Font = Enum.Font.Code
Button2.LayoutOrder = 2
Button2.Parent = Container

table.insert(Elements, Button2)

Button2.MouseButton1Click:Connect(function()
	-- ADD YOUR BUTTON 2 CODE HERE
	print("Button 2 clicked")
end)


-- TOGGLE 
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Name = "ToggleFrame"
ToggleFrame.Size = UDim2.new(1, 0, 0, CONFIG.SPACING.ElementHeight)
ToggleFrame.BackgroundColor3 = CONFIG.COLORS.ButtonBackground
ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleFrame.BorderSizePixel = 1
ToggleFrame.LayoutOrder = 3
ToggleFrame.Parent = Container

table.insert(Elements, ToggleFrame)

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Name = "ToggleLabel"
ToggleLabel.Size = UDim2.new(1, -30, 1, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = " Toggle"
ToggleLabel.TextColor3 = CONFIG.COLORS.TextColor
ToggleLabel.TextSize = 12
ToggleLabel.Font = Enum.Font.Code
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ToggleFrame

local ToggleState = false
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Position = UDim2.new(1, -22, 0, 3)
ToggleButton.Size = UDim2.new(0, 18, 0, 18)
ToggleButton.BackgroundColor3 = CONFIG.COLORS.ToggleOff
ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BorderSizePixel = 1
ToggleButton.Text = ""
ToggleButton.Parent = ToggleFrame

ToggleButton.MouseButton1Click:Connect(function()
	ToggleState = not ToggleState
	ToggleButton.BackgroundColor3 = ToggleState and CONFIG.COLORS.ToggleOn or CONFIG.COLORS.ToggleOff
	
	-- ADD YOUR TOGGLE CODE HERE
	print("Toggle:", ToggleState)
end)


-- CREDITS
local Credits = Instance.new("TextLabel")
Credits.Name = "Credits"
Credits.Position = UDim2.new(0, 0, 1, -15)
Credits.Size = UDim2.new(1, 0, 0, 15)
Credits.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Credits.BorderSizePixel = 0
Credits.Text = CONFIG.CREDITS_TEXT
Credits.TextColor3 = CONFIG.COLORS.CreditsText
Credits.TextSize = 10
Credits.Font = Enum.Font.Code
Credits.Parent = MainFrame


-- FLOATING BUTTON
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Position = UDim2.new(1, -90, 0, 10)
FloatingButton.Size = UDim2.new(0, 80, 0, 30)
FloatingButton.BackgroundColor3 = CONFIG.COLORS.HeaderBackground
FloatingButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
FloatingButton.BorderSizePixel = 2
FloatingButton.Text = "Hide GUI"
FloatingButton.TextColor3 = CONFIG.COLORS.TextColor
FloatingButton.TextSize = 11
FloatingButton.Font = Enum.Font.Code
FloatingButton.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = FloatingButton

FloatingButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
	FloatingButton.Text = MainFrame.Visible and "Hide GUI" or "Show GUI"
end)


-- DRAGGING FUNCTIONALITY THIS STILL HAVE BUGS HARD MAKING THIS HEHE
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- FINALIZE GUI SIZE
UpdateGUISize()
