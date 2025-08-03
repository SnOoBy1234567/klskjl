local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local UIS = game:GetService("UserInputService")

-- Titreşim efekti (shaky)
local function randomOffset(mag)
	return Vector3.new(
		math.random(-mag, mag),
		math.random(-mag, mag),
		math.random(-mag, mag)
	) * 0.1
end

-- Sadece eldeki Tool'un Handle'ı alınır
local function getHeldToolHandle()
	for _, tool in ipairs(LP.Character:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
			return tool.Handle
		end
	end
	return nil
end

-- Tool'un Handle'ını hedef oyuncunun önüne titreşimli şekilde yerleştir
local function sendToolToFrontOfPlayer(targetPlayer)
	local targetChar = targetPlayer.Character
	if not targetChar then return end

	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	local frontCFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
	local handle = getHeldToolHandle()

	if handle then
		task.spawn(function()
			for i = 1, 15 do
				handle.CFrame = frontCFrame + randomOffset(5)
				task.wait(0.05)
			end
		end)
	end
end

-- PC: Oyuncuya tıklanırsa
Mouse.Button1Down:Connect(function()
	local target = Mouse.Target
	if target then
		local model = target:FindFirstAncestorOfClass("Model")
		local player = Players:GetPlayerFromCharacter(model)
		if player and player ~= LP then
			sendToolToFrontOfPlayer(player)
		end
	end
end)

-- Mobil: Oyuncuya dokunulursa
UIS.TouchTap:Connect(function(touches)
	local touch = touches[1]
	if not touch then return end

	local cam = workspace.CurrentCamera
	local ray = cam:ViewportPointToRay(touch.Position.X, touch.Position.Y)
	local result = workspace:Raycast(ray.Origin, ray.Direction * 500)

	if result then
		local model = result.Instance:FindFirstAncestorOfClass("Model")
		local player = Players:GetPlayerFromCharacter(model)
		if player and player ~= LP then
			sendToolToFrontOfPlayer(player)
		end
	end
end)
