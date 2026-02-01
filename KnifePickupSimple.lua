--[[
    VERSION SIMPLIFIÉE - Script Roblox pour ramasser un couteau avec E
    
    INSTALLATION ULTRA SIMPLE:
    1. Ouvrez Roblox Studio
    2. Créez un LocalScript dans StarterPlayer > StarterCharacterScripts
    3. Copiez-collez ce code
    4. Créez un Tool nommé "Knife" avec un Handle dans le Workspace
    5. Jouez et appuyez sur E près du couteau!
]]

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = script.Parent

-- Fonction principale
UserInputService.InputBegan:Connect(function(input, typing)
    -- Si le joueur tape dans le chat, ne rien faire
    if typing then return end
    
    -- Si la touche E est pressée
    if input.KeyCode == Enum.KeyCode.E then
        -- Chercher un couteau proche
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Tool") and obj.Name == "Knife" then
                local knifePos = obj.Handle.Position
                local playerPos = character.HumanoidRootPart.Position
                local distance = (playerPos - knifePos).Magnitude
                
                -- Si le couteau est à moins de 10 studs
                if distance < 10 then
                    -- Ramasser le couteau
                    obj.Parent = player.Backpack
                    
                    -- Équiper le couteau
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:EquipTool(obj)
                    end
                    
                    print("Couteau ramassé!")
                    break
                end
            end
        end
    end
end)

print("Script chargé! Appuyez sur E pour ramasser un couteau.")
