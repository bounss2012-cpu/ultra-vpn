--[[
    Script pour créer un couteau (Tool) dans Roblox
    
    Instructions:
    1. Placez ce script dans ServerScriptService
    2. Le script créera automatiquement un couteau dans le Workspace
    3. Utilisez KnifePickupScript.lua ou KnifePickupProximityPrompt.lua pour le ramasser
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fonction pour créer un couteau
local function createKnife()
    -- Créer le Tool
    local knife = Instance.new("Tool")
    knife.Name = "Knife"
    knife.RequiresHandle = true
    knife.CanBeDropped = true
    
    -- Créer le Handle (la partie physique du couteau)
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.4, 0.2, 2) -- Forme de couteau
    handle.BrickColor = BrickColor.new("Medium stone grey")
    handle.Material = Enum.Material.Metal
    handle.Parent = knife
    
    -- Ajouter une texture ou un design (optionnel)
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://121944778" -- ID de mesh de couteau (exemple)
    mesh.TextureId = "rbxassetid://121944805" -- ID de texture (exemple)
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = handle
    
    -- Script d'attaque pour le couteau (optionnel)
    local knifeScript = Instance.new("Script")
    knifeScript.Name = "KnifeScript"
    knifeScript.Source = [[
        local tool = script.Parent
        local handle = tool:WaitForChild("Handle")
        local damage = 20
        
        local canDamage = true
        local cooldown = 0.5
        
        -- Animation d'attaque
        tool.Activated:Connect(function()
            if not canDamage then return end
            canDamage = false
            
            -- Son d'attaque (optionnel)
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://12222216" -- Son de coup
            sound.Parent = handle
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 1)
            
            -- Détecter les ennemis touchés
            local character = tool.Parent
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local region = Region3.new(
                        humanoidRootPart.Position - Vector3.new(5, 5, 5),
                        humanoidRootPart.Position + Vector3.new(5, 5, 5)
                    )
                    
                    for _, part in pairs(workspace:FindPartsInRegion3(region, character, 100)) do
                        local enemyHumanoid = part.Parent:FindFirstChild("Humanoid")
                        if enemyHumanoid and enemyHumanoid.Parent ~= character then
                            enemyHumanoid:TakeDamage(damage)
                            print("Dégâts infligés: " .. damage)
                        end
                    end
                end
            end
            
            wait(cooldown)
            canDamage = true
        end)
    ]]
    knifeScript.Parent = knife
    
    return knife
end

-- Créer et placer le couteau dans le Workspace
local knife = createKnife()
knife.Parent = game.Workspace
knife.Handle.Position = Vector3.new(0, 5, 0) -- Position initiale

print("Couteau créé dans le Workspace!")
