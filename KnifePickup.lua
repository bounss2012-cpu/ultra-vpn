--[[
	Script Roblox - Prendre le couteau avec la touche 'E'
	Roblox Script - Knife Pickup with 'E' key
	
	Instructions:
	1. Placez ce script dans StarterPlayer > StarterCharacterScripts (LocalScript)
	2. Assurez-vous d'avoir un outil nommé "Knife" dans ReplicatedStorage
	
	Instructions:
	1. Place this script in StarterPlayer > StarterCharacterScripts (LocalScript)
	2. Make sure you have a tool named "Knife" in ReplicatedStorage
]]

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

-- Configuration
local PICKUP_KEY = Enum.KeyCode.E
local KNIFE_NAME = "Knife"
local PICKUP_DISTANCE = 10 -- Distance maximale pour ramasser le couteau

-- Variable pour suivre si le couteau est équipé
local knifeEquipped = false
local currentKnife = nil

-- Fonction pour équiper le couteau
local function equipKnife()
	-- Vérifier si le joueur a déjà le couteau
	local backpack = player:WaitForChild("Backpack")
	local existingKnife = backpack:FindFirstChild(KNIFE_NAME)
	
	if existingKnife then
		-- Le couteau est dans le backpack, on l'équipe
		humanoid:EquipTool(existingKnife)
		knifeEquipped = true
		currentKnife = existingKnife
		print("Couteau équipé! / Knife equipped!")
	else
		-- Chercher le couteau dans ReplicatedStorage
		local knifeTemplate = ReplicatedStorage:FindFirstChild(KNIFE_NAME)
		
		if knifeTemplate then
			-- Cloner le couteau et l'ajouter au backpack
			local newKnife = knifeTemplate:Clone()
			newKnife.Parent = backpack
			
			-- Équiper le couteau
			humanoid:EquipTool(newKnife)
			knifeEquipped = true
			currentKnife = newKnife
			print("Couteau ramassé et équipé! / Knife picked up and equipped!")
		else
			warn("Couteau non trouvé dans ReplicatedStorage! / Knife not found in ReplicatedStorage!")
		end
	end
end

-- Fonction pour déséquiper le couteau
local function unequipKnife()
	if currentKnife and currentKnife.Parent == character then
		humanoid:UnequipTools()
		knifeEquipped = false
		print("Couteau déséquipé! / Knife unequipped!")
	end
end

-- Fonction pour chercher un couteau proche dans le workspace
local function findNearbyKnife()
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return nil end
	
	-- Utiliser Region3 pour une recherche plus performante
	local searchRadius = PICKUP_DISTANCE
	local region = Region3.new(
		rootPart.Position - Vector3.new(searchRadius, searchRadius, searchRadius),
		rootPart.Position + Vector3.new(searchRadius, searchRadius, searchRadius)
	)
	region = region:ExpandToGrid(4)
	
	-- Chercher uniquement dans la région définie
	local partsInRegion = workspace:FindPartsInRegion3(region, character, 100)
	
	for _, part in pairs(partsInRegion) do
		local tool = part.Parent
		if tool and tool:IsA("Tool") and tool.Name == KNIFE_NAME then
			local handle = tool:FindFirstChild("Handle")
			if handle and handle == part then
				local distance = (handle.Position - rootPart.Position).Magnitude
				if distance <= PICKUP_DISTANCE then
					return tool
				end
			end
		end
	end
	
	return nil
end

-- Fonction pour ramasser un couteau du workspace
local function pickupNearbyKnife()
	local nearbyKnife = findNearbyKnife()
	
	if nearbyKnife then
		local backpack = player:WaitForChild("Backpack")
		nearbyKnife.Parent = backpack
		humanoid:EquipTool(nearbyKnife)
		knifeEquipped = true
		currentKnife = nearbyKnife
		print("Couteau ramassé du sol! / Knife picked up from ground!")
		return true
	end
	
	return false
end

-- Gestionnaire d'input pour la touche 'E'
local function onInputBegan(input, gameProcessed)
	-- Ignorer si le joueur tape dans un chat ou menu
	if gameProcessed then return end
	
	-- Vérifier si c'est la touche 'E'
	if input.KeyCode == PICKUP_KEY then
		-- Alterner entre équiper et déséquiper
		if knifeEquipped then
			unequipKnife()
		else
			-- D'abord essayer de ramasser un couteau à proximité
			local pickedUp = pickupNearbyKnife()
			
			-- Si aucun couteau proche, équiper depuis le backpack ou ReplicatedStorage
			if not pickedUp then
				equipKnife()
			end
		end
	end
end

-- Connecter l'événement d'input
UserInputService.InputBegan:Connect(onInputBegan)

-- Nettoyer quand le personnage meurt
humanoid.Died:Connect(function()
	knifeEquipped = false
	currentKnife = nil
end)

print("Script de ramassage de couteau chargé! / Knife pickup script loaded!")
print("Appuyez sur 'E' pour équiper/déséquiper le couteau / Press 'E' to equip/unequip the knife")
