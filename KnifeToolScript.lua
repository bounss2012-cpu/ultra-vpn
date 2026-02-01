--[[
	Exemple de Script de Couteau pour Roblox
	Example Knife Script for Roblox
	
	Instructions:
	1. Créez un Tool nommé "Knife" dans ReplicatedStorage
	2. Créez une Part nommée "Handle" dans le Tool
	3. Placez ce script dans le Tool (Script serveur, pas LocalScript)
	
	Instructions:
	1. Create a Tool named "Knife" in ReplicatedStorage
	2. Create a Part named "Handle" in the Tool
	3. Place this script in the Tool (Server Script, not LocalScript)
]]

local tool = script.Parent
local handle = tool:WaitForChild("Handle")

-- Configuration
local DAMAGE = 25 -- Dégâts par coup
local COOLDOWN = 0.5 -- Temps entre chaque attaque (secondes)
local ATTACK_RANGE = 5 -- Portée de l'attaque

-- Variables
local canAttack = true
local equipped = false

-- Son d'attaque (optionnel)
local attackSound = Instance.new("Sound")
attackSound.SoundId = "rbxasset://sounds/swordslash.wav"
attackSound.Volume = 0.5
attackSound.Parent = handle

-- Animation d'attaque (optionnel)
local slashAnimation = Instance.new("Animation")
slashAnimation.AnimationId = "rbxassetid://522635514" -- Animation de slash par défaut

-- Fonction pour infliger des dégâts
local function onHit(hit)
	if not canAttack then return end
	
	-- Vérifier si on a touché un personnage
	local humanoid = hit.Parent:FindFirstChild("Humanoid")
	if humanoid then
		-- Vérifier que ce n'est pas le joueur qui utilise le couteau
		local player = tool.Parent
		if player and player:IsA("Model") then
			local myHumanoid = player:FindFirstChild("Humanoid")
			if myHumanoid and humanoid ~= myHumanoid then
				-- Infliger des dégâts
				humanoid:TakeDamage(DAMAGE)
				print("Dégâts infligés: " .. DAMAGE .. " / Damage dealt: " .. DAMAGE)
				
				-- Cooldown
				canAttack = false
				wait(COOLDOWN)
				canAttack = true
			end
		end
	end
end

-- Fonction d'activation (clic)
local function onActivated()
	if not canAttack or not equipped then return end
	
	-- Jouer le son
	if attackSound then
		attackSound:Play()
	end
	
	-- Jouer l'animation si le joueur a un Humanoid
	local character = tool.Parent
	if character and character:IsA("Model") then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			local animator = humanoid:FindFirstChild("Animator")
			if animator and slashAnimation then
				local track = animator:LoadAnimation(slashAnimation)
				track:Play()
			end
		end
	end
	
	print("Attaque! / Attack!")
end

-- Événements
tool.Activated:Connect(onActivated)
handle.Touched:Connect(onHit)

tool.Equipped:Connect(function()
	equipped = true
	print("Couteau équipé! / Knife equipped!")
end)

tool.Unequipped:Connect(function()
	equipped = false
	print("Couteau déséquipé! / Knife unequipped!")
end)

print("Script de couteau chargé! / Knife script loaded!")
