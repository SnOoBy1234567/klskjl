local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local args = {[1] = 17615158624}
local remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local wearRemote = remotes:WaitForChild("Wear", 9e9)

-- Ban Hammer tool adı
local toolName = "Ban Hammer"

-- Remote fonksiyonunu çağıran fonksiyon
local function invokeRemote()
    wearRemote:InvokeServer(unpack(args))
end

-- Tool kontrolü ve eventleri bağlama
local function setupTool(tool)
    if tool.Name == toolName then
        tool.Equipped:Connect(function()
            invokeRemote()
        end)
        tool.Unequipped:Connect(function()
            invokeRemote()
        end)
    end
end

-- Envanterdeki mevcut araçlara bağlan
for _, tool in pairs(player.Backpack:GetChildren()) do
    if tool:IsA("Tool") then
        setupTool(tool)
    end
end

-- Yeni eklenen araçlara bağlan
player.Backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        setupTool(tool)
    end
end)

-- Karakter spawn olduğunda aracları bağla
player.CharacterAdded:Connect(function(char)
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            setupTool(tool)
        end
    end
end)
