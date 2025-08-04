local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local backpack = player:WaitForChild("Backpack")

local toolName = "Ban Hammer"
local args = {
    [1] = 17615158624;
}

local remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local wearRemote = remotes:WaitForChild("Wear", 9e9)

local function runRemote()
    wearRemote:InvokeServer(unpack(args))
end

local function onEquipped()
    runRemote()
end

local function onUnequipped()
    runRemote()
end

local function setupTool(tool)
    if tool.Name == toolName then
        tool.Equipped:Connect(onEquipped)
        tool.Unequipped:Connect(onUnequipped)
    end
end

-- Mevcut araçlara bağlan
for _, tool in pairs(backpack:GetChildren()) do
    if tool:IsA("Tool") and tool.Name == toolName then
        setupTool(tool)
    end
end

-- Yeni eklenen araçlara bağlan
backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and child.Name == toolName then
        setupTool(child)
    end
end)

-- Karakter spawn olduğunda araçları tekrar bağla
player.CharacterAdded:Connect(function(char)
    character = char
    backpack = player:WaitForChild("Backpack")
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolName then
            setupTool(tool)
        end
    end
end)
