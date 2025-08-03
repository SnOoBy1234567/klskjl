local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")

local tooldraw = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
tooldraw.Name = "tooldraw"
tooldraw.ResetOnSpawn = false

local canvas = Instance.new("Frame", tooldraw)
canvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
canvas.BorderColor3 = Color3.new(0,0,0)
canvas.BorderSizePixel = 3
canvas.Position = UDim2.new(0.1, 0, 0.35, 0)
canvas.Size = UDim2.new(0, 614, 0, 286)

local undo = Instance.new("TextButton", canvas)
undo.BackgroundColor3 = Color3.fromRGB(21,21,21)
undo.BackgroundTransparency = 0.4
undo.BorderSizePixel = 0
undo.Position = UDim2.new(0.86, 0, 0.86, 0)
undo.Size = UDim2.new(0, 65, 0, 31)
undo.Font = Enum.Font.SourceSans
undo.Text = "↩️"
undo.TextColor3 = Color3.new(0,0,0)
undo.TextSize = 21

local partCount = Instance.new("TextLabel", canvas)
partCount.BackgroundColor3 = Color3.fromRGB(57,57,57)
partCount.BorderSizePixel = 0
partCount.Position = UDim2.new(0,0,1,0)
partCount.Size = UDim2.new(0, 265, 0, 36)
partCount.Font = Enum.Font.SourceSansBold
partCount.Text = "PARTS: 0/0"
partCount.TextColor3 = Color3.fromRGB(0,255,0)
partCount.TextScaled = true
partCount.TextWrapped = true

local heading = Instance.new("TextLabel", tooldraw)
heading.BackgroundColor3 = Color3.fromRGB(40,40,40)
heading.BorderColor3 = Color3.fromRGB(67,67,67)
heading.BorderSizePixel = 3
heading.Position = UDim2.new(0.1, 0, 0.3, 0)
heading.Size = UDim2.new(0, 614, 0, 26)
heading.Font = Enum.Font.Unknown
heading.Text = "Affexter Utilities: ToolEditor"
heading.TextColor3 = Color3.fromRGB(47,255,0)
heading.TextSize = 14

local X = Instance.new("TextButton", heading)
X.BackgroundColor3 = Color3.fromRGB(0,255,42)
X.BorderSizePixel = 0
X.Position = UDim2.new(0.94, 0, 0.14, 0)
X.Size = UDim2.new(0, 33, 0, 17)
X.Font = Enum.Font.SourceSansBold
X.Text = "X"
X.TextColor3 = Color3.new(0,0,0)
X.TextScaled = true

local used = 0

local function updatePartCount()
	local backpack = player.Backpack:GetChildren()
	local total = #backpack
	for _, tool in ipairs(player.Character:GetChildren()) do
		if tool:IsA("Tool") then
			total = total + 1
		end
	end
	partCount.Text = "PARTS: "..used.."/"..total
	if used >= total then
		partCount.TextColor3 = Color3.new(1,0,0)
	else
		partCount.TextColor3 = Color3.new(0,1,0)
	end
end
RunService.RenderStepped:Connect(updatePartCount)

-- TOOL'U TIKLANAN OYUNCUNUN ÖNÜNE KOYMA FONKSİYONU
local function placeToolOnClickedPlayer()
	local target = mouse.Target
	if not target then return end

	local targetModel = target:FindFirstAncestorOfClass("Model")
	if not targetModel then return end

	local targetPlayer = game.Players:GetPlayerFromCharacter(targetModel)
	if not targetPlayer or targetPlayer == player then return end

	local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	local myCharacter = player.Character
	if not myCharacter then return end

	local tool = nil
	for _, item in ipairs(player.Backpack:GetChildren()) do
		if item:IsA("Tool") then
			tool = item
			break
		end
	end
	if not tool then return end

	-- Grip pozisyonunu oyuncunun önüne ayarlıyoruz, biraz ileri mesafe
	local gripCFrame = targetHRP.CFrame * CFrame.new(0, 0, -3) -- 3 studs önde

	-- Tool grip'i ayarla
	if tool:FindFirstChild("LocalScript") then
		tool.LocalScript:Destroy()
	end

	tool.Grip = tool.Handle.CFrame:ToObjectSpace(gripCFrame)
	tool.Parent = myCharacter

	used = used + 1
	updatePartCount()
end

-- Tıklama algılama
canvas.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		placeToolOnClickedPlayer()
	end
end)

-- Undo butonu
undo.MouseButton1Click:Connect(function()
	for _, tool in ipairs(player.Character:GetChildren()) do
		if tool:IsA("Tool") then
			tool.Parent = player.Backpack
		end
	end
	used = 0
	updatePartCount()
end)

-- GUI Taşıma
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos, canvasStartPos

heading.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = heading.Position
		canvasStartPos = canvas.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

heading.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		heading.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		canvas.Position = UDim2.new(canvasStartPos.X.Scale, canvasStartPos.X.Offset + delta.X, canvasStartPos.Y.Scale, canvasStartPos.Y.Offset + delta.Y)
	end
end)

-- GUI Kapat
X.MouseButton1Click:Connect(function()
	tooldraw:Destroy()
end)
