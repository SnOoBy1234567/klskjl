local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function resolveHRP(char)
    return char:FindFirstChild("HumanoidRootPart") 
        or char:FindFirstChild("UpperTorso") 
        or char:FindFirstChild("Torso")
end

local hrp = resolveHRP(character)
local chipsPart = workspace.WorkspaceCom["001_GiveTools"].Chips
local clickDetector = chipsPart:FindFirstChildOfClass("ClickDetector")

if not clickDetector then
    warn("ClickDetector bulunamadı!")
    return
end

-- Sol altta büyük image oluşturma
local imageGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
imageGui.Name = "BigImageGui"

local imageLabel = Instance.new("ImageLabel", imageGui)
imageLabel.Size = UDim2.new(0, 280, 0, 250) -- Büyük boyut
imageLabel.Position = UDim2.new(0, 10, 1, -310) -- Sol alt
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://75927467572889"

-- GUI oluştur
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ToggleAutoClickGui"
ScreenGui.Enabled = false -- Başlangıçta kapalı

local button = Instance.new("TextButton", ScreenGui)
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.TextColor3 = Color3.new(1,1,1)
button.Text = "Auto Click: OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.AutoButtonColor = true

local autoClickEnabled = false

button.MouseButton1Click:Connect(function()
    autoClickEnabled = not autoClickEnabled
    button.Text = autoClickEnabled and "Auto Click: ON" or "Auto Click: OFF"
    button.BackgroundColor3 = autoClickEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

-- Karakteri ışınlama fonksiyonu
local function teleportToChips()
    if not hrp or not hrp.Parent then
        character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        hrp = resolveHRP(character)
    end
    if hrp then
        hrp.CFrame = chipsPart.CFrame + Vector3.new(0, 3, 0)
    end
end

-- ClickDetector tetikleme fonksiyonu
local function fireClick(cd)
    pcall(function()
        fireclickdetector(cd, LocalPlayer)
    end)
end

-- Toggle ile GUI açıp kapama için örnek tuş (RightControl)
local TOGGLE_KEY = Enum.KeyCode.RightControl

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TOGGLE_KEY then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Ana döngü
while true do
    if autoClickEnabled then
        teleportToChips()
        wait(0)
        fireClick(clickDetector)
    end
    wait(0)
end
