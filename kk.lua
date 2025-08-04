local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local args = {[1] = 17615158624}
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local wearRemote = remotes:WaitForChild("Wear")

local toolName = "Ban Hammer"

local function onUnequipped(tool)
    if tool.Name == toolName then
        wearRemote:InvokeServer(unpack(args))
    end
end

-- Karakter ve araç hazır olduğunda
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.ToolUnequipped:Connect(onUnequipped)
end

-- Mevcut karakter için setup
if player.Character then
    setupCharacter(player.Character)
end

-- Karakter değiştiğinde setup yap
player.CharacterAdded:Connect(setupCharacter)
