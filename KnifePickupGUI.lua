--[[
	Version GUI du Script - Prendre le couteau avec la touche 'E'
	GUI Version Script - Knife Pickup with 'E' key
	
	Instructions:
	1. Placez ce script dans StarterGui > ScreenGui (LocalScript)
	2. Assurez-vous d'avoir un outil nommé "Knife" dans ReplicatedStorage
	
	Instructions:
	1. Place this script in StarterGui > ScreenGui (LocalScript)
	2. Make sure you have a tool named "Knife" in ReplicatedStorage
]]

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Configuration
local PICKUP_KEY = Enum.KeyCode.E
local KNIFE_NAME = "Knife"

-- Fonction principale pour équiper/déséquiper le couteau
local function toggleKnife()
	-- Attendre que le personnage soit chargé
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local backpack = player:WaitForChild("Backpack")
	
	-- Vérifier si le couteau est déjà équipé
	local equippedKnife = character:FindFirstChild(KNIFE_NAME)
	
	if equippedKnife and equippedKnife:IsA("Tool") then
		-- Le couteau est équipé, on le déséquipe
		humanoid:UnequipTools()
		print("Couteau déséquipé! / Knife unequipped!")
	else
		-- Chercher le couteau dans le backpack
		local knifeInBackpack = backpack:FindFirstChild(KNIFE_NAME)
		
		if knifeInBackpack then
			-- Le couteau est dans le backpack, on l'équipe
			humanoid:EquipTool(knifeInBackpack)
			print("Couteau équipé! / Knife equipped!")
		else
			-- Le couteau n'est pas dans le backpack, on le clone depuis ReplicatedStorage
			local knifeTemplate = ReplicatedStorage:FindFirstChild(KNIFE_NAME)
			
			if knifeTemplate and knifeTemplate:IsA("Tool") then
				local newKnife = knifeTemplate:Clone()
				newKnife.Parent = backpack
				humanoid:EquipTool(newKnife)
				print("Couteau créé et équipé! / Knife created and equipped!")
			else
				warn("ERREUR: Couteau non trouvé dans ReplicatedStorage!")
				warn("ERROR: Knife not found in ReplicatedStorage!")
				warn("Assurez-vous qu'un Tool nommé 'Knife' existe dans ReplicatedStorage")
				warn("Make sure a Tool named 'Knife' exists in ReplicatedStorage")
			end
		end
	end
end

-- Gestionnaire d'input
local function onInputBegan(input, gameProcessed)
	-- Ignorer si le joueur tape dans un chat ou menu
	if gameProcessed then return end
	
	-- Vérifier si c'est la touche configurée
	if input.KeyCode == PICKUP_KEY then
		toggleKnife()
	end
end

-- Connecter l'événement d'input
UserInputService.InputBegan:Connect(onInputBegan)

-- Message de démarrage
print("═══════════════════════════════════════")
print("Script de ramassage de couteau chargé!")
print("Knife pickup script loaded!")
print("Appuyez sur 'E' pour équiper/déséquiper")
print("Press 'E' to equip/unequip")
print("═══════════════════════════════════════")

-- Gérer le rechargement du personnage
player.CharacterAdded:Connect(function()
	print("Personnage rechargé - Appuyez sur 'E' pour le couteau")
	print("Character reloaded - Press 'E' for knife")
end)
