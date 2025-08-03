local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local Backpack = player.Backpack

-- GUI elemanlarını güvenli şekilde alıyoruz
local function getGuiElements()
    local screenGui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
    local button = screenGui:FindFirstChild("Button")
    local textBox = screenGui:FindFirstChild("TextBox")

    if not button then
        warn("Button bulunamadı!")
        return nil, nil, screenGui
    end

    if not textBox then
        warn("TextBox bulunamadı!")
        return nil, nil, screenGui
    end

    return button, textBox, screenGui
end

local Button, TextBox, ScreenGui = getGuiElements()
if not Button or not TextBox then
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
