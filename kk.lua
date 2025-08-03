local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Mouse = LP:GetMouse()

-- Titreşim efekti için rastgele küçük pozisyon kaydırması
local function randomOffset(magnitude)
	return Vector3.new(
		math.random(-magnitude, magnitude),
		math.random(-magnitude, magnitude),
		math.random(-magnitude, magnitude)
	) * 0.1
end

-- Tool'ları bul
local function getHeldTools()
	local tools = {}
	for _, tool in ipairs(LP.Character:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
			table.insert(tools, tool)
		end
	end
	return tools
end

-- Tool'ların Handle'larını hedef oyuncunun önüne titreşimli yerleştir
local function placeToolsInFrontOfPlayer(targetPlayer)
	local targetChar = targetPlayer.Character
	if not targetChar then return end

	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	local frontPos = targetHRP.CFrame * CFrame.new(0, 0, -3)

	local tools = getHeldTools()
	for _, tool in ipairs(tools) do
		local handle = tool:FindFirstChild("Handle")
		if handle then
			task.spawn(function()
				for i = 1, 15 do
					handle.CFrame = frontPos + randomOffset(5)
					task.wait(0.05)
				end
			end)
		end
	end
end

-- PC Tıklama
Mouse.Button1Down:Connect(function()
	local target = Mouse.Target
	if target then
		local model = target:FindFirstAncestorOfClass("Model")
		local player = Players:GetPlayerFromCharacter(model)
		if player and player ~= LP then
			placeToolsInFrontOfPlayer(player)
		end
	end
end)

-- Mobil Dokunma
UIS.TouchTap:Connect(function(touches)
	local touch = touches[1]
	if not touch then return end

	local cam = workspace.CurrentCamera
	local ray = cam:ViewportPointToRay(touch.Position.X, touch.Position.Y)
	local raycast = workspace:Raycast(ray.Origin, ray.Direction * 500)

	if raycast then
		local target = raycast.Instance
		if target then
			local model = target:FindFirstAncestorOfClass("Model")
			local player = Players:GetPlayerFromCharacter(model)
			if player and player ~= LP then
				placeToolsInFrontOfPlayer(player)
			end
		end
	end
end)
