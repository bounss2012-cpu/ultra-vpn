# Guide Complet - Installation du Script de Couteau Roblox
# Complete Guide - Roblox Knife Script Installation

## 🎮 Vue d'ensemble / Overview

Ce projet contient tout le nécessaire pour créer un système de ramassage de couteau avec la touche 'E' dans Roblox.

This project contains everything needed to create a knife pickup system with the 'E' key in Roblox.

---

## 📁 Fichiers Inclus / Included Files

1. **KnifePickup.lua** - Script principal avec toutes les fonctionnalités
   - Main script with all features
   
2. **KnifePickupGUI.lua** - Version simplifiée pour GUI
   - Simplified GUI version
   
3. **KnifeToolScript.lua** - Exemple de script pour l'outil couteau
   - Example script for the knife tool
   
4. **ROBLOX_README.md** - Documentation détaillée
   - Detailed documentation

---

## 🚀 Installation Rapide / Quick Setup

### Étape 1 : Créer le Couteau / Step 1: Create the Knife

```
ReplicatedStorage
└── Knife (Tool)
    ├── Handle (Part)
    │   └── Propriétés recommandées:
    │       - Size: (0.4, 0.2, 2)
    │       - Material: Metal
    │       - Color: Grey
    └── KnifeToolScript (Script) [OPTIONNEL]
```

### Étape 2 : Installer le Script de Ramassage / Step 2: Install Pickup Script

**OPTION A - Script de Personnage (Recommandé)**

```
StarterPlayer
└── StarterCharacterScripts
    └── KnifePickup (LocalScript)
        └── [Coller le code de KnifePickup.lua]
```

**OPTION B - Script GUI**

```
StarterGui
└── ScreenGui
    └── KnifePickupScript (LocalScript)
        └── [Coller le code de KnifePickupGUI.lua]
```

### Étape 3 : Tester / Step 3: Test

1. Cliquez sur ▶️ "Play" dans Roblox Studio
2. Appuyez sur `E` pour équiper le couteau
3. Appuyez à nouveau sur `E` pour le déséquiper

---

## 🎯 Fonctionnalités / Features

### ✅ Fonctionnalités Principales / Main Features

- **Touche 'E' pour équiper/déséquiper** - Press 'E' to equip/unequip
- **Ramassage automatique du sol** - Automatic pickup from ground
- **Support du backpack** - Backpack support
- **Distance de ramassage configurable** - Configurable pickup distance
- **Messages bilingues FR/EN** - Bilingual messages FR/EN

### 🔧 Options Configurables / Configurable Options

```lua
-- Dans le script / In the script:
local PICKUP_KEY = Enum.KeyCode.E        -- Touche / Key
local KNIFE_NAME = "Knife"               -- Nom / Name
local PICKUP_DISTANCE = 10               -- Distance (studs)
local DAMAGE = 25                        -- Dégâts / Damage
```

---

## 🎨 Personnalisation du Couteau / Knife Customization

### Apparence Basique / Basic Appearance

```lua
-- Propriétés du Handle
Handle.Size = Vector3.new(0.4, 0.2, 2)
Handle.Material = Enum.Material.Metal
Handle.BrickColor = BrickColor.new("Medium stone grey")
```

### Utiliser un Mesh / Using a Mesh

1. Trouvez un modèle 3D de couteau (fichier .obj ou .fbx)
2. Importez-le dans Roblox Studio (Asset Manager > Import 3D)
3. Remplacez le Handle par un MeshPart
4. Assignez le mesh importé

### Ajouter des Effets Visuels / Adding Visual Effects

```lua
-- Exemple: Particules de sang
local particles = Instance.new("ParticleEmitter")
particles.Parent = handle
particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
particles.Color = ColorSequence.new(Color3.new(1, 0, 0)) -- Rouge
particles.Enabled = false

-- Activer lors d'un coup
particles.Enabled = true
wait(0.1)
particles.Enabled = false
```

---

## 🐛 Dépannage / Troubleshooting

### Problème: Le couteau n'apparaît pas
**Solution:**
1. Vérifiez que le Tool s'appelle exactement "Knife"
2. Vérifiez qu'il est dans ReplicatedStorage
3. Vérifiez qu'il a un "Handle"

### Problème: La touche 'E' ne répond pas
**Solution:**
1. Vérifiez que c'est un LocalScript (pas un Script)
2. Vérifiez l'emplacement du script
3. Ouvrez la console de sortie (View > Output)

### Problème: Erreur "Handle not found"
**Solution:**
1. Le Tool doit avoir une Part nommée "Handle"
2. Le Handle doit être un enfant direct du Tool

---

## 📋 Checklist d'Installation / Installation Checklist

- [ ] Tool "Knife" créé dans ReplicatedStorage
- [ ] Part "Handle" ajoutée au Tool
- [ ] LocalScript ajouté dans StarterCharacterScripts ou StarterGui
- [ ] Code copié dans le LocalScript
- [ ] Testé en mode Play
- [ ] Touche 'E' fonctionne pour équiper
- [ ] Touche 'E' fonctionne pour déséquiper

---

## 🔐 Sécurité et Anti-Cheat / Security and Anti-Cheat

### Important pour les jeux publics / Important for public games

Le script actuel est côté client (LocalScript). Pour éviter l'exploitation :

Current script is client-side (LocalScript). To prevent exploitation:

1. **Utilisez RemoteEvents** pour valider côté serveur
   Use RemoteEvents for server-side validation
   
2. **Vérifiez la distance** côté serveur
   Verify distance server-side
   
3. **Limitez le nombre** de couteaux par joueur
   Limit the number of knives per player

Exemple de RemoteEvent:
```lua
-- Dans le LocalScript
local RemoteEvent = ReplicatedStorage:WaitForChild("RequestKnife")
RemoteEvent:FireServer()

-- Dans un ServerScript
RemoteEvent.OnServerEvent:Connect(function(player)
    -- Vérifications serveur
    -- Server checks
    local backpack = player:WaitForChild("Backpack")
    if not backpack:FindFirstChild("Knife") then
        local knife = ReplicatedStorage.Knife:Clone()
        knife.Parent = backpack
    end
end)
```

---

## 💡 Idées d'Amélioration / Improvement Ideas

1. **Animation personnalisée** - Custom animation
2. **Effets sonores** - Sound effects
3. **Effets de particules** - Particle effects
4. **Système de durabilité** - Durability system
5. **Différents types de couteaux** - Different knife types
6. **Interface utilisateur** - User interface
7. **Indicateur de distance** - Distance indicator

---

## 📞 Support

Pour plus d'aide / For more help:
- Consultez le ROBLOX_README.md
- Vérifiez la console Output dans Roblox Studio
- Testez dans un lieu vide d'abord

---

## 📝 Licence / License

Ce code est fourni comme exemple éducatif. Utilisez-le librement dans vos projets Roblox.

This code is provided as an educational example. Use it freely in your Roblox projects.

---

**Bon jeu! / Have fun!** 🎮
