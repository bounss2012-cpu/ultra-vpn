--[[
    Script Roblox: Ramassage de Couteau avec ProximityPrompt (touche E)
    
    Instructions d'installation:
    1. Placez ce script en tant que Script dans ServerScriptService
    2. Créez un couteau (Tool) avec un Handle dans le Workspace
    3. Ce script ajoutera automatiquement un ProximityPrompt au couteau
    
    Avantages de cette méthode:
    - Utilise le système ProximityPrompt de Roblox (plus moderne)
    - Affiche automatiquement un indicateur visuel
    - Gère automatiquement la touche E
    - Compatible avec tous les appareils (PC, Mobile, Console)
]]

local Players = game:GetService("Players")

-- Configuration
local KNIFE_NAME = "Knife" -- Nom du couteau dans le jeu
local PROMPT_TEXT = "Ramasser le couteau" -- Texte affiché
local PROMPT_KEY = "E" -- Touche à afficher
local MAX_DISTANCE = 10 -- Distance maximale d'activation

-- Fonction pour ajouter un ProximityPrompt à un couteau
local function addProximityPromptToKnife(knife)
    if not knife:IsA("Tool") then
        return
    end
    
    local handle = knife:FindFirstChild("Handle")
    if not handle then
        warn("Le couteau n'a pas de Handle!")
        return
    end
    
    -- Vérifier si un ProximityPrompt existe déjà
    if handle:FindFirstChild("PickupPrompt") then
        return
    end
    
    -- Créer le ProximityPrompt
    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = "PickupPrompt"
    prompt.ActionText = PROMPT_TEXT
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.MaxActivationDistance = MAX_DISTANCE
    prompt.RequiresLineOfSight = false
    prompt.HoldDuration = 0 -- Pas besoin de maintenir la touche
    prompt.Parent = handle
    
    -- Gérer l'activation du ProximityPrompt
    prompt.Triggered:Connect(function(player)
        if knife.Parent == game.Workspace or knife.Parent.Parent == game.Workspace then
            -- Donner le couteau au joueur
            local knifeCopy = knife:Clone()
            knifeCopy.Parent = player.Backpack
            
            -- Supprimer l'original
            knife:Destroy()
            
            -- Équiper automatiquement
            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(knifeCopy)
            end
            
            print(player.Name .. " a ramassé le couteau!")
        end
    end)
    
    print("ProximityPrompt ajouté au couteau: " .. knife.Name)
end

-- Fonction pour surveiller les nouveaux couteaux
local function monitorKnives()
    -- Parcourir tous les couteaux existants
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Tool") and (obj.Name == KNIFE_NAME or obj.Name:lower():find("knife") or obj.Name:lower():find("couteau")) then
            addProximityPromptToKnife(obj)
        end
    end
    
    -- Surveiller les nouveaux couteaux ajoutés
    game.Workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("Tool") and (obj.Name == KNIFE_NAME or obj.Name:lower():find("knife") or obj.Name:lower():find("couteau")) then
            task.wait(0.1) -- Attendre que le Handle soit chargé
            addProximityPromptToKnife(obj)
        end
    end)
end

-- Démarrer la surveillance
monitorKnives()

print("Script de ramassage de couteau avec ProximityPrompt chargé!")
