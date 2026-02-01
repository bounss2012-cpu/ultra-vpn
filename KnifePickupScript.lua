--[[
    Script Roblox: Ramassage de Couteau avec la touche E
    
    Instructions d'installation:
    1. Placez ce script en tant que LocalScript dans StarterPlayer > StarterCharacterScripts
    2. Assurez-vous que votre couteau est un Tool dans ReplicatedStorage ou Workspace
    3. Le couteau doit avoir un nom (par exemple "Knife" ou "Couteau")
    
    Fonctionnalités:
    - Appuyez sur E pour ramasser le couteau le plus proche
    - Distance de détection configurable
    - Affichage d'une notification quand le couteau est ramassé
]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuration
local PICKUP_KEY = Enum.KeyCode.E
local MAX_PICKUP_DISTANCE = 10 -- Distance maximale pour ramasser le couteau
local KNIFE_NAME = "Knife" -- Nom du couteau dans le jeu

-- Variables locales
local player = Players.LocalPlayer
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

-- Fonction pour trouver le couteau le plus proche
local function findNearestKnife()
    local nearestKnife = nil
    local nearestDistance = MAX_PICKUP_DISTANCE
    
    -- Chercher dans le Workspace
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Tool") and (obj.Name == KNIFE_NAME or obj.Name:lower():find("knife") or obj.Name:lower():find("couteau")) then
            if obj.Parent ~= player.Backpack and obj.Parent ~= character then
                local knifePosition
                
                -- Obtenir la position du couteau
                if obj:FindFirstChild("Handle") then
                    knifePosition = obj.Handle.Position
                elseif obj.PrimaryPart then
                    knifePosition = obj.PrimaryPart.Position
                end
                
                if knifePosition then
                    local distance = (character.HumanoidRootPart.Position - knifePosition).Magnitude
                    
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestKnife = obj
                    end
                end
            end
        end
    end
    
    return nearestKnife, nearestDistance
end

-- Fonction pour ramasser le couteau
local function pickupKnife()
    local knife, distance = findNearestKnife()
    
    if knife then
        -- Cloner le couteau et le placer dans le Backpack du joueur
        local knifeCopy = knife:Clone()
        knifeCopy.Parent = player.Backpack
        
        -- Supprimer l'original du Workspace
        knife:Destroy()
        
        -- Équiper automatiquement le couteau
        humanoid:EquipTool(knifeCopy)
        
        -- Notification (optionnel)
        print("Couteau ramassé! Distance: " .. math.floor(distance) .. " studs")
        
        return true
    else
        print("Aucun couteau à proximité (distance max: " .. MAX_PICKUP_DISTANCE .. " studs)")
        return false
    end
end

-- Gérer l'input utilisateur
local function onInputBegan(input, gameProcessed)
    -- Ne pas traiter si le joueur tape dans le chat ou un GUI
    if gameProcessed then
        return
    end
    
    -- Vérifier si la touche E est pressée
    if input.KeyCode == PICKUP_KEY then
        pickupKnife()
    end
end

-- Connecter l'événement d'input
UserInputService.InputBegan:Connect(onInputBegan)

-- Message de démarrage
print("Script de ramassage de couteau chargé! Appuyez sur E pour ramasser un couteau.")
