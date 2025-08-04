-- Ayarlar
local config = {
    Select_Color = Color3.fromRGB(255, 0, 0), -- Seçim kutusu rengi
    Prediction_Enable = true -- Hareket tahmini aktif
}

-- Servisler
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Oyuncu ve karakter bilgileri
local player = Players.LocalPlayer
local character = player.Character
local mouse = player:GetMouse()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Seçim kutusu oluştur
local selectionBox = Instance.new("SelectionBox", script)
selectionBox.Color3 = config.Select_Color
selectionBox.LineThickness = 0.02

-- Durum değişkenleri
local selectedTool = nil
local isToolEquipped = false
local isFlinging = false

-- Araç seçildiğinde
local function onToolEquipped(tool)
    selectedTool = tool
    isToolEquipped = true
end

-- Araç bırakıldığında
local function onToolUnequipped()
    selectedTool = nil
    isToolEquipped = false
    selectionBox.Adornee = nil
end

-- Oyuncuya fling aracı ver
local function createFlingTool()
    local tool = Instance.new("Tool")
    tool.Name = "Fling"
    tool.RequiresHandle = true

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.BrickColor = BrickColor.new("Royal blue")
    handle.Anchored = false
    handle.CanCollide = true
    handle.Parent = tool

    tool.Parent = player.Backpack

    tool.Equipped:Connect(function()
        onToolEquipped(tool)
    end)

    tool.Unequipped:Connect(function()
        onToolUnequipped()
    end)
end

-- Karakter yeniden spawn olduğunda araçlara tekrar bağlan
player.CharacterAdded:Connect(function(newCharacter)
    newCharacter.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            child.Equipped:Connect(function()
                onToolEquipped(child)
            end)
            child.Unequipped:Connect(function()
                onToolUnequipped()
            end)
        end
    end)
end)

-- Hedef seçme (mouse üzerinde Humanoid kontrolü)
mouse.Move:Connect(function()
    if isToolEquipped then
        local target = mouse.Target
        if target and target.Parent:FindFirstChildOfClass("Humanoid") then
            selectionBox.Adornee = target.Parent
        else
            selectionBox.Adornee = nil
        end
    end
end)

-- Fling başlatma (Mouse sol tuş)
mouse.Button1Down:Connect(function()
    if isToolEquipped and not isFlinging then
        local target = selectionBox.Adornee
        if target then
            isFlinging = true

            -- Sıfırla velocityleri
            rootPart.AssemblyLinearVelocity = Vector3.new()
            rootPart.AssemblyAngularVelocity = Vector3.new()

            -- Döndürme: BodyAngularVelocity (çok güçlü)
            local bav = Instance.new("BodyAngularVelocity")
            bav.AngularVelocity = Vector3.new(0, 500, 0) -- Hızlı dönüş
            bav.MaxTorque = Vector3.new(0, math.huge, 0)
            bav.P = 88888888888888888888
            bav.Name = "UltraSpin"
            bav.Parent = rootPart

            -- Yukarı itme: BodyForce (çok güçlü)
            local force = Instance.new("BodyForce")
            force.Force = Vector3.new(0, 999999999, 0) + Vector3.new(0, rootPart.AssemblyMass * workspace.Gravity, 0)
            force.Name = "UltraLift"
            force.Parent = rootPart

            local savedCFrame = rootPart.CFrame

            -- Hedef takip döngüsü
            while rootPart and target:FindFirstChild("HumanoidRootPart") do
                RunService.Heartbeat:Wait()

                local targetHRP = target.HumanoidRootPart
                local targetHumanoid = target:FindFirstChildOfClass("Humanoid")

                if targetHRP.Velocity.Magnitude <= 20 then
                    local predictedPosition = targetHRP.Position

                    if config.Prediction_Enable then
                        predictedPosition += (targetHumanoid.MoveDirection * targetHumanoid.WalkSpeed) / 2
                        predictedPosition += Vector3.new(0, targetHRP.Velocity.Y / 10, 0)
                    end

                    rootPart.CFrame = CFrame.new(predictedPosition) * rootPart.CFrame.Rotation
                    rootPart.Velocity = Vector3.new()
                else
                    break
                end
            end

            -- Temizleme
            if bav and bav.Parent then bav:Destroy() end
            if force and force.Parent then force:Destroy() end
            rootPart.CFrame = savedCFrame
            humanoid:ChangeState(Enum.HumanoidStateType.Landed)

            isFlinging = false
        end
    end
end)

-- Script başlatılırken aracı oluştur
createFlingTool()
