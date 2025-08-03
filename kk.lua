local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local Backpack = player.Backpack

-- GUI referanslarını kendi GUI yapına göre düzenle
local ScreenGui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local Button = ScreenGui:WaitForChild("Button")
local TextBox = ScreenGui:WaitForChild("TextBox")

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
    -- İstersen buraya kendi spam kontrolünü ekle
    print("Spam Click Detector started with count: ".. tostring(count))
end

local function fireToolSound()
    -- İstersen buraya kendi ses oynatma kodunu ekle
    print("Tool sound fired")
end

local function constantlyUpdateGripPos()
    RunService.Heartbeat:Connect(function()
        if not targetHead then return end
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                local handle = tool.Handle
                -- targetHead'a göre grip pozisyonunu güncelle
                -- tool.Grip CFrame olarak ayarlanmalı
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
