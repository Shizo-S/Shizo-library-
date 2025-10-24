-- FaDhenGaming GUI Script - Clean & Compact Design (20% Larger)
-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Hapus GUI lama
pcall(function()
    if CoreGui:FindFirstChild("FaDhenGui") then
        CoreGui.FaDhenGui:Destroy()
    end
end)

-- Settings untuk menyimpan toggle states
local Settings = {
    toggles = {}
}

-- Fungsi untuk save settings
local function SaveSettings()
    pcall(function()
        writefile("FaDhenGaming_Settings.json2", game:GetService("HttpService"):JSONEncode(Settings))
    end)
end

-- Fungsi untuk load settings
local function LoadSettings()
    pcall(function()
        if isfile("FaDhenGaming_Settings.json2") then
            local success, result = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile("FaDhenGaming_Settings.json2"))
            end)
            if success then
                Settings = result
            end
        end
    end)
end

-- Load settings saat startup
LoadSettings()

-- ScreenGui utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FaDhenGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame dengan ukuran yang diminta (20% lebih besar)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 198, 0, 41) -- Ukuran diperbesar 20%
mainFrame.Position = UDim2.new(0, 10, 0, 10) -- Kiri atas, geser 10px dari tepi
mainFrame.BackgroundColor3 = Color3.new(25/255, 25/255, 35/255)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui
mainFrame.ClipsDescendants = false -- PENTING: Biar toggle tidak terpotong

-- Corner untuk main frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 4) -- 20% lebih besar (3*1.2≈4)
mainCorner.Parent = mainFrame

-- Subtle border
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.new(35/255, 35/255, 45/255)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Header Frame (fill main frame)
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 1, 0)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundTransparency = 1 -- Transparent, color comes from mainFrame
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -36, 1, 0) -- Diperbesar 20% (30*1.2=36)
titleLabel.Position = UDim2.new(0, 10, 0, 0) -- Diperbesar 20% (8*1.2≈10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "FaDhenGaming"
titleLabel.TextColor3 = Color3.new(1, 1, 1) -- Pure white
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextSize = 14 -- Diperbesar 20% (12*1.2≈14)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Parent = headerFrame

-- Toggle Button (V / -)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 24, 0, 24) -- Diperbesar 20% (20*1.2=24)
toggleButton.Position = UDim2.new(1, -30, 0.5, -12) -- Adjusted for new size (25*1.2=30, 10*1.2=12)
toggleButton.BackgroundColor3 = Color3.new(35/255, 35/255, 45/255)
toggleButton.TextColor3 = Color3.new(0.9, 0.9, 0.9)
toggleButton.Text = "v"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 12 -- Diperbesar 20% (10*1.2=12)
toggleButton.Parent = headerFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5) -- Diperbesar 20% (4*1.2≈5)
toggleCorner.Parent = toggleButton

-- Content Frame - PENTING: Di luar mainFrame agar tidak terpotong
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(0, 198, 0, 0) -- Start with 0 height, width 20% lebih besar
contentFrame.Position = UDim2.new(0, 0, 0.9, 2)  -- Just below mainFrame
contentFrame.BackgroundColor3 = Color3.new(25/255, 25/255, 35/255) -- Same color
contentFrame.BorderSizePixel = 0
contentFrame.Visible = false
contentFrame.Parent = mainFrame -- Parent to mainFrame but positioned outside
contentFrame.ClipsDescendants = true

-- Content corner
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 4) -- Diperbesar 20% (3*1.2≈4)
contentCorner.Parent = contentFrame

-- Content border
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.new(35/255, 35/255, 45/255)
contentStroke.Thickness = 1
contentStroke.Parent = contentFrame

-- Scrolling Frame untuk toggle items
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -7, 1, -7) -- Diperbesar 20% (6*1.2≈7)
scrollFrame.Position = UDim2.new(0, 4, 0, 4) -- Diperbesar 20% (3*1.2≈4)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4 -- Diperbesar 20% (3*1.2≈4)
scrollFrame.ScrollBarImageColor3 = Color3.new(0.4, 0.4, 0.5)
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.Parent = contentFrame

-- Layout untuk toggle items
local layout = Instance.new("UIListLayout")
layout.Name = "Layout"
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4) -- Diperbesar 20% (3*1.2≈4)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Update canvas size
local function updateCanvasSize()
    local contentSize = layout.AbsoluteContentSize.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize + 7) -- Diperbesar 20% (6*1.2≈7)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

-- Variables
local isExpanded = false
local toggleItems = {}

-- Fungsi untuk membuat toggle item yang compact
local function CreateToggleItem(name, initialState)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = name .. "Item"
    itemFrame.Size = UDim2.new(1, -7, 0, 34) -- Compact height diperbesar 20% (6*1.2≈7, 28*1.2≈34)
    itemFrame.BackgroundColor3 = Color3.new(30/255, 30/255, 40/255) -- Slightly lighter
    itemFrame.BorderSizePixel = 0
    itemFrame.LayoutOrder = #toggleItems + 1
    itemFrame.Parent = scrollFrame

    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 7) -- Diperbesar 20% (6*1.2≈7)
    itemCorner.Parent = itemFrame

    -- Subtle item border
    local itemStroke = Instance.new("UIStroke")
    itemStroke.Color = Color3.new(40/255, 40/255, 50/255)
    itemStroke.Thickness = 1
    itemStroke.Parent = itemFrame

    -- Label untuk nama toggle
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0) -- Diperbesar 20% (50*1.2=60)
    label.Position = UDim2.new(0, 10, 0, 0) -- Diperbesar 20% (8*1.2≈10)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(0.95, 0.95, 0.95)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13 -- Diperbesar 20% (11*1.2≈13)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = itemFrame

    -- Slider background - compact size diperbesar 20%
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBg"
    sliderBg.Size = UDim2.new(0, 43, 0, 22) -- Diperbesar 20% (36*1.2≈43, 18*1.2≈22)
    sliderBg.Position = UDim2.new(1, -50, 0.5, -11) -- Diperbesar 20% (42*1.2≈50, 9*1.2≈11)
    sliderBg.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = itemFrame

    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0.5, 0)
    sliderBgCorner.Parent = sliderBg

    -- Slider circle - compact size diperbesar 20%
    local sliderCircle = Instance.new("Frame")
    sliderCircle.Name = "SliderCircle"
    sliderCircle.Size = UDim2.new(0, 17, 0, 17) -- Diperbesar 20% (14*1.2≈17)
    sliderCircle.Position = UDim2.new(0, 2, 0.5, -8) -- Diperbesar 20% (7*1.2≈8)
    sliderCircle.BackgroundColor3 = Color3.new(0.8, 0.8, 0.85)
    sliderCircle.BorderSizePixel = 0
    sliderCircle.Parent = sliderBg

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0.5, 0)
    circleCorner.Parent = sliderCircle

    -- Click button
    local clickButton = Instance.new("TextButton")
    clickButton.Name = "ClickButton"
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.Position = UDim2.new(0, 0, 0, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = itemFrame

    -- State
    local currentState = initialState or false

    -- Update visual function
    local function UpdateVisual(state)
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if state then
            -- ON state
            TweenService:Create(sliderCircle, tweenInfo, {
                Position = UDim2.new(0, 24, 0.5, -8), -- Diperbesar 20% (20*1.2=24, 7*1.2≈8)
                BackgroundColor3 = Color3.new(1, 1, 1)
            }):Play()
            TweenService:Create(sliderBg, tweenInfo, {
                BackgroundColor3 = Color3.new(0.2, 0.7, 0.4)
            }):Play()
        else
            -- OFF state
            TweenService:Create(sliderCircle, tweenInfo, {
                Position = UDim2.new(0, 2, 0.5, -8), -- Diperbesar 20% (7*1.2≈8)
                BackgroundColor3 = Color3.new(0.8, 0.8, 0.85)
            }):Play()
            TweenService:Create(sliderBg, tweenInfo, {
                BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
            }):Play()
        end
    end

    -- Set initial state
    UpdateVisual(currentState)

    return itemFrame, clickButton, UpdateVisual, currentState
end

-- Fungsi expand/collapse
local function ToggleExpansion()
    isExpanded = not isExpanded
    
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if isExpanded then
        -- Expand
        toggleButton.Text = "-"
        contentFrame.Visible = true
        
        -- Calculate height based on items
        local itemCount = #toggleItems
        local maxHeight = 180 -- Max height untuk scroll diperbesar 20% (150*1.2=180)
        local calculatedHeight = math.min(itemCount * 37 + 7, maxHeight) -- Diperbesar 20% (31*1.2≈37, 6*1.2≈7)
        
        contentFrame.Size = UDim2.new(0, 198, 0, 0)
        TweenService:Create(contentFrame, tweenInfo, {
            Size = UDim2.new(0, 198, 0, calculatedHeight)
        }):Play()
    else
        -- Collapse
        toggleButton.Text = "v"
        
        TweenService:Create(contentFrame, tweenInfo, {
            Size = UDim2.new(0, 198, 0, 0)
        }):Play()
        
        -- REMOVED THE WAIT STATEMENT HERE
        contentFrame.Visible = false
    end
    
    updateCanvasSize()
end

-- Connect toggle button
toggleButton.MouseButton1Click:Connect(ToggleExpansion)

-- Global variables
_G.FaDhenToggles = {}

-- AddToggle function
function _G.FaDhenAddToggle(name, props)
    props = props or {}
    local callback = props.Callback or function() end
    
    -- Check saved state
    local savedState = Settings.toggles[name] or false
    
    -- Create toggle item
    local itemFrame, clickButton, updateVisual, currentState = CreateToggleItem(name, savedState)
    currentState = savedState
    
    -- Add to toggleItems
    table.insert(toggleItems, {
        name = name,
        frame = itemFrame,
        state = currentState
    })
    
    -- Click functionality
    clickButton.MouseButton1Click:Connect(function()
        currentState = not currentState
        updateVisual(currentState)
        
        -- Save state
        Settings.toggles[name] = currentState
        SaveSettings()
        
        -- Update table
        for i, item in pairs(toggleItems) do
            if item.name == name then
                item.state = currentState
                break
            end
        end
        
        -- Callback
        pcall(function()
            callback(currentState)
        end)
    end)
    
    -- Store reference
    _G.FaDhenToggles[name] = {
        frame = itemFrame,
        button = clickButton,
        update = updateVisual,
        getValue = function() return currentState end,
        setValue = function(value) 
            currentState = value
            updateVisual(currentState)
            Settings.toggles[name] = currentState
            SaveSettings()
            
            for i, item in pairs(toggleItems) do
                if item.name == name then
                    item.state = currentState
                    break
                end
            end
        end
    }
    
    updateCanvasSize()
    
    -- Initial callback
    if savedState then
        pcall(function()
            callback(savedState)
        end)
    end
end

-- Hover effects
toggleButton.MouseEnter:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.new(40/255, 40/255, 50/255)
    }):Play()
end)

toggleButton.MouseLeave:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.new(35/255, 35/255, 45/255)
    }):Play()
end)

-- Drag functionality
local dragging = false
local dragStart = nil
local startPos = nil

headerFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Welcome message
wait(0.2)
print("✅ FaDhenGaming GUI - Clean & Compact (20% Larger)")
print("📐 Size: 198x41 | Color: RGB(25,25,35)")
print("🔧 Usage: _G.FaDhenAddToggle('Name', {Callback = function(state) end})")
