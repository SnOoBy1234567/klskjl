local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Mouse = Players.LocalPlayer:GetMouse()
local LP = Players.LocalPlayer

-- Titreşim efekti
local function randomOffset(mag)
	return Vector3.new(
		math.random(-mag, mag),
		math.random(-mag, mag),
		math.random(-mag, mag)
	) * 0.1
end

-- Elde aktif olan Tool'un Handle'ı
local function getHeldToolHandle()
	for _, tool in ipairs(LP.Character:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
			return tool.Handle
		end
	end
	return nil
end

-- Tool'u hedef oyuncunun önüne gönder
local function sendToolToFrontOf(player)
	local targetChar = player.Character
	if not targetChar then return end

	local hrp = targetChar:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local handle = getHeldToolHandle()
	if not handle then return end

	local frontCFrame = hrp.CFrame * CFrame.new(0, 0, -3)

	task.spawn(function()
		for i = 1, 15 do
			handle.CFrame = frontCFrame + randomOffset(5)
			task.wait(0.05)
		end
	end)
end

-- PC Kullanıcıları: Mouse tıklaması
Mouse.Button1Down:Connect(function()
	local target = Mouse.Target
	if not target then return end

	local model = target:FindFirstAncestorOfClass("Model")
	local player = Players:GetPlayerFromCharacter(model)

	if player and player ~= LP then
		sendToolToFrontOf(player)
	end
end)

-- Mobil kullanıcılar: Dokunma
UIS.TouchTap:Connect(function(touches)
	local touch = touches[1]
	if not touch then return end

	local camera = workspace.CurrentCamera
	local ray = camera:ViewportPointToRay(touch.Position.X, touch.Position.Y)
	local result = workspace:Raycast(ray.Origin, ray.Direction * 500)

	if result then
		local model = result.Instance:FindFirstAncestorOfClass("Model")
		local player = Players:GetPlayerFromCharacter(model)

		if player and player ~= LP then
			sendToolToFrontOf(player)
		end
	end
end)
