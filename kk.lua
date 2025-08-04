local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local args = {[1] = 17615158624}
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local wearRemote = remotes:WaitForChild("Wear")

local toolName = "Ban Hammer"
local lastEquipped = false

while true do
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local tool = humanoid and humanoid:FindFirstChildOfClass("Tool")
    
    if tool and tool.Name == toolName then
        lastEquipped = true
    else
        if lastEquipped == true then
            -- Tool bırakıldıysa remote çağr
            wearRemote:InvokeServer(unpack(args))
            lastEquipped = false
        end
    end
    wait(0.2)
end
