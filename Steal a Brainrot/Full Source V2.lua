loadstring(game:HttpGet("https://raw.githubusercontent.com/Shizo-S/Shizo-library-/refs/heads/main/Steal%20a%20Brainrot/GUI/source.lua"))()





_G.FaDhenAddToggle("Auto laser", {
    Callback = function(state)
        if state then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/NabaruBrainrot/Tempat-Penyimpanan-Roblox-Brainrot-/refs/heads/main/Laser%20Cape"))()
        end
    end
})







local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))

-- flag toggle
getgenv().FaDhenAutoAim = getgenv().FaDhenAutoAim or false

-- cari player terdekat
local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end

    local myPos = myChar.HumanoidRootPart.Position
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                nearestPlayer = player
            end
        end
    end
    return nearestPlayer
end

-- fungsi pasang auto aim ke tool
local function hookTool(tool)
    if tool:IsA("Tool") and not tool:FindFirstChild("FaDhenHooked") then
        local marker = Instance.new("BoolValue")
        marker.Name = "FaDhenHooked"
        marker.Parent = tool

        tool.Activated:Connect(function()
            if getgenv().FaDhenAutoAim then
                local nearest = getNearestPlayer()
                if nearest and nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = nearest.Character.HumanoidRootPart
                    Net:RemoteEvent("UseItem"):FireServer(hrp.Position, hrp)
                    return
                end
            end

            -- fallback: pakai mouse
            local PlayerMouse = require(ReplicatedStorage.Packages.PlayerMouse)
            Net:RemoteEvent("UseItem"):FireServer(PlayerMouse.Hit.Position, PlayerMouse.Target)
        end)
    end
end

-- pasang hook ke semua tool di backpack
local function hookBackpack()
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        hookTool(tool)
    end
    LocalPlayer.Backpack.ChildAdded:Connect(hookTool)
end

-- saat karakter respawn, pasang ulang
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1) -- beri delay kecil supaya Backpack terisi
    hookBackpack()
end)

-- pertama kali load
hookBackpack()

-- Toggle UI (baru)
_G.FaDhenAddToggle("Aimbot", {
    Callback = function(state)
        getgenv().FaDhenAutoAim = state
    end
})



local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ragdollConnection = nil

local function anchorCharacter(char, state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Anchored = state
        end
    end
end

local function handleRagdoll(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    ragdollConnection = humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics 
        or newState == Enum.HumanoidStateType.Ragdoll 
        or newState == Enum.HumanoidStateType.FallingDown then
            anchorCharacter(char, true)
            task.wait(0.01)
            anchorCharacter(char, false)
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function enableAntiRagdoll()
    if player.Character then
        handleRagdoll(player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        handleRagdoll(char)
    end)
end

local function disableAntiRagdoll()
    if ragdollConnection then
        ragdollConnection:Disconnect()
        ragdollConnection = nil
    end
end

--=== Toggle baru ===--
_G.FaDhenAddToggle("Anti Ragdoll", {
    Callback = function(state)
        if state then
            enableAntiRagdoll()
        else
            disableAntiRagdoll()
        end
    end
})








--=== ESP PLAYER (FaDhen Toggle) ===--
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- reuse global table supaya aman kalau script di-execute ulang
local FaESP = getgenv().FaDhenESP or {}
getgenv().FaDhenESP = FaESP

FaESP.Enabled = FaESP.Enabled or false
FaESP.Connections = FaESP.Connections or {}

local function destroyESPFromCharacter(character)
	if character:FindFirstChild("ESP_Highlight") then
		character.ESP_Highlight:Destroy()
	end
	local head = character:FindFirstChild("Head")
	if head and head:FindFirstChild("ESP_Name") then
		head.ESP_Name:Destroy()
	end
end

local function applyESPToCharacter(player, character)
	if player == localPlayer then return end
	if not character then return end

	local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
	if not head then return end

	destroyESPFromCharacter(character)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Name"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 1.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = player.DisplayName
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.5
	label.Font = Enum.Font.SourceSansBold
	label.TextScaled = true
	label.Parent = billboard

	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.Adornee = character
	highlight.FillColor = Color3.new(1, 0, 0)
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.new(0, 0, 0)
	highlight.OutlineTransparency = 0.2
	highlight.Parent = character
end

local function trackPlayer(player)
	if player == localPlayer then return end
	if player.Character then
		applyESPToCharacter(player, player.Character)
	end
	FaESP.Connections[player] = player.CharacterAdded:Connect(function(character)
		applyESPToCharacter(player, character)
	end)
end

local function untrackPlayer(player)
	if FaESP.Connections[player] then
		FaESP.Connections[player]:Disconnect()
		FaESP.Connections[player] = nil
	end
	if player ~= localPlayer and player.Character then
		destroyESPFromCharacter(player.Character)
	end
end

function FaESP:Enable()
	if self.Enabled then return end
	self.Enabled = true
	for _, plr in ipairs(Players:GetPlayers()) do
		trackPlayer(plr)
	end
	self.Connections._PlayerAdded = Players.PlayerAdded:Connect(function(plr)
		trackPlayer(plr)
	end)
	self.Connections._PlayerRemoving = Players.PlayerRemoving:Connect(function(plr)
		untrackPlayer(plr)
	end)
end

function FaESP:Disable()
	if not self.Enabled then return end
	self.Enabled = false
	for key, conn in pairs(self.Connections) do
		if conn and conn.Disconnect then
			conn:Disconnect()
		end
		self.Connections[key] = nil
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= localPlayer and plr.Character then
			destroyESPFromCharacter(plr.Character)
		end
	end
end

--=== Toggle baru pakai FaDhen ===--
_G.FaDhenAddToggle("ESP", {
    Callback = function(state)
        if state then
            FaESP:Enable()
        else
            FaESP:Disable()
        end
    end
})



_G.FaDhenAddToggle("Jump Boost", {
    Callback = function(state)
        if state then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/NabaruBrainrot/Tempat-Penyimpanan-Roblox-Brainrot-/refs/heads/main/BoostJump"))()
        end
    end
})








local DEBUG = false
local BATCH_SIZE = 250
local SEARCH_TRAPS_IN_GAME = false

local function dprint(...) if DEBUG then print(...) end end

local function processBillboardIfNeeded(obj)
	if not (obj:IsA("BasePart") and obj.Name == "Main") then return end
	if obj:GetAttribute("BillboardProcessed") then return end
	local parent = obj.Parent
	local ok = false
	while parent do
		if parent:IsA("Folder") and parent.Name == "Purchases" then ok = true break end
		parent = parent.Parent
	end
	if not ok then return end
	for _, child in ipairs(obj:GetChildren()) do
		if child:IsA("BillboardGui") then
			child.Size = UDim2.new(0, 180, 0, 150)
			child.MaxDistance = 90
			child.StudsOffset = Vector3.new(0, 5, 0)
			dprint("✅ BillboardGui diubah:", obj:GetFullName())
		end
	end
	obj:SetAttribute("BillboardProcessed", true)
end

task.defer(function()
	local all = workspace:GetDescendants()
	for i = 1, #all do
		processBillboardIfNeeded(all[i])
		if i % BATCH_SIZE == 0 then task.wait() end
	end
end)

workspace.DescendantAdded:Connect(processBillboardIfNeeded)












--CONFIG
getgenv().webhook = "https://discord.com/api/webhooks/1416301279050858496/TUqEhwR5npjT6-Vff_nG7bMlqzYhoD4FHbgTJAerBFqm1r0weSxe-1XSQffGShW2g3Ah"
getgenv().websiteEndpoint = nil

-- Allowed place IDs
local allowedPlaceIds = {
    [96342491571673] = true, -- New Players Server
    [109983668079237] = true -- Normal
}

getgenv().TargetPetNames = {
    "Graipuss Medussi",
    "La Grande Combinasion", "Garama and Madundung", "La Extinct Grande",
    "Pot Hotspot",
    "Nuclearo Dinossauro",  
    "Chicleteira Bicicleteira", "Los Combinasionas", "Dragon Cannelloni",
    "Unclito Samito",
   "Esok Sekolah"
}

-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- PRIVATE SERVER CHECK (works for VIP + Reserved)
local function isPrivateServer()
    return (game.PrivateServerId and game.PrivateServerId ~= "")
        or (game.VIPServerId and game.VIPServerId ~= "")
end

local function buildJoinLink(placeId, jobId)
    return string.format(
        "https://chillihub1.github.io/chillihub-joiner/?placeId=%d&gameInstanceId=%s",
        placeId,
        jobId
    )
end

-- KICK CHECKS
if isPrivateServer() then
    LocalPlayer:Kick("Kicked because in private server")
    return
elseif not allowedPlaceIds[game.PlaceId] then
    local joinLink = buildJoinLink(game.PlaceId, game.JobId)
    LocalPlayer:Kick("Kicked because wrong game\nClick to join server:\n" .. joinLink)
    return
end

-- WEBHOOK SEND
local function sendWebhook(foundPets, jobId)
    local petCounts = {}
    for _, pet in ipairs(foundPets) do
        petCounts[pet] = (petCounts[pet] or 0) + 1
    end

    local formattedPets = {}
    for petName, count in pairs(petCounts) do
        table.insert(formattedPets, petName .. (count > 1 and " x" .. count or ""))
    end

    local joinLink = buildJoinLink(game.PlaceId, jobId)

    local embedData = {
        username = "PetsFinder",
        embeds = { {
            title = "ðŸ¾ Pet(s) Found!",
            description = "**Pet(s):**\n" .. table.concat(formattedPets, "\n"),
            color = 65280,
            fields = {
                {
                    name = "Players",
                    value = string.format("%d/%d", #Players:GetPlayers(), Players.MaxPlayers),
                    inline = true
                },
                {
                    name = "Job ID",
                    value = jobId,
                    inline = true
                },
                {
                    name = "Join Link",
                    value = string.format("[Click to join server](%s)", joinLink),
                    inline = false
                }
            },
            footer = { text = "Leaked by collin gng" },
            timestamp = DateTime.now():ToIsoDate()
        } }
    }

    local jsonData = HttpService:JSONEncode(embedData)
    local req = http_request or request or (syn and syn.request)
    if req then
        local success, err = pcall(function()
            req({
                Url = getgenv().webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end)
        if success then
            print("âœ… Webhook sent")
        else
            warn("âŒ Webhook failed:", err)
        end
    else
        warn("âŒ No HTTP request function available")
    end
end

-- PET CHECK
local function checkForPets()
    local found = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local nameLower = string.lower(obj.Name)
            for _, target in pairs(getgenv().TargetPetNames) do
                if string.find(nameLower, string.lower(target)) then
                    table.insert(found, obj.Name)
                    break
                end
            end
        end
    end
    return found
end

-- MAIN LOOP
task.spawn(function()
    while true do
        local petsFound = checkForPets()
        if #petsFound > 0 then
            print("âœ… Pets found:", table.concat(petsFound, ", "))
            sendWebhook(petsFound, game.JobId)
        else
            print("ðŸ” No pets found")
        end
        task.wait(15)
    end
end)
