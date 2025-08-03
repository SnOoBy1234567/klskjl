local toolsEquipped = false  -- global flag, sadece 1 kere equip etmek için

-- Tool grip pos sürekli güncelleme (sadece grip pos, tool.Parent değiştirme yok artık)
local function constantlyUpdateGripPos()
    RunService.Heartbeat:Connect(function()
        if not targetHead then return end
        for _, tool in pairs(Character:GetChildren()) do  -- sadece karakterdeki tool'lar
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                local handle = tool.Handle
                local gripCFrame = handle.CFrame:ToObjectSpace(targetHead.CFrame)
                tool.GripPos = gripCFrame.Position
            end
        end
    end)
end

-- Button click eventi
Button.MouseButton1Click:Connect(function()
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

    -- Sadece bir kere tool'ları karaktere geçir ve equip et
    if not toolsEquipped then
        for _, tool in pairs(Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = Character
                -- Equip etmek için:
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
