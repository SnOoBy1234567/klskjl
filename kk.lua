local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local Backpack = player.Backpack

local ScreenGui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")

-- GUI içeriğini yazdır, isimleri kontrol et
print("ScreenGui içeriği:")
for _, child in pairs(ScreenGui:GetChildren()) do
    print(child.Name, child.ClassName)
end

-- Button ve TextBox arama fonksiyonu
local function findChildByClassName(parent, className)
    for _, child in pairs(parent:GetChildren()) do
        if child.ClassName == className then
            return child
        end
    end
    return nil
end

-- Button ve TextBox'u bul
local Button = ScreenGui:FindFirstChild("Button") or findChildByClassName(ScreenGui, "TextButton")
local TextBox = ScreenGui:FindFirstChild("TextBox") or findChildByClassName(ScreenGui, "TextBox")

if not Button then
    warn("Button bulunamadı. Lütfen GUI içinde 'Button' veya 'TextButton' isimli bir nesne olduğundan emin ol.")
    return
end
if not TextBox then
    warn("TextBox bulunamadı. Lütfen GUI içinde 'TextBox' isimli bir nesne olduğundan emin ol.")
    return
end

local targetPlayer = nil
local targetHead = nil
local toolsEquipped = false

local function findBestMatchPlayer(namePart)
    namePart = namePart:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(namePart) then
            return plr
        end
    end
    return nil
end

local function spamClickDetector(count)
    print("Spam Click Detector started with count: ".. tostring(count))
end

local function fireToolSound()
    print("Tool sound fired")
end

local function constantlyUpdateGripPos()
    RunService.Heartbeat:Connect(function()
        if not targetHead then return end
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                local handle = tool.Handle
                local relativeCFrame = targetHead.CFrame:ToObjectSpace(handle.CFrame)
                tool.Grip = relativeCFrame
            end
        end
    end)
end

Button.Activated:Connect(function()
    local inputText = TextBox.Text
    if inputText == "" then
        warn("Lütfen hedef oyuncu adının bir kısmını yaz.")
        return
    end

    targetPlayer = findBestMatchPlayer(inputText)
    if not targetPlayer then
        warn("Hedef oyuncu bulunamadı.")
        return
    end

    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then
        warn("Hedef oyuncunun karakteri veya kafası yok.")
        return
    end

    targetHead = targetPlayer.Character.Head

    if not toolsEquipped then
        for _, tool in pairs(Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = Character
                local humanoid = Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(tool)
                end
            end
        end
        toolsEquipped = true
    end

    spamClickDetector(10)
    fireToolSound()
    constantlyUpdateGripPos()

    print("İşlem başlatıldı. Hedef oyuncu:", targetPlayer.Name)

    ScreenGui.Enabled = false
end)
