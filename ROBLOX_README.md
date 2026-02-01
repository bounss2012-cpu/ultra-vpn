# Script Roblox - Prendre le Couteau avec la Touche 'E'

## Description
Ce script permet à un joueur de prendre/équiper un couteau en appuyant sur la touche 'E' dans Roblox.

## Fonctionnalités
- ✅ Appuyez sur 'E' pour équiper le couteau
- ✅ Appuyez à nouveau sur 'E' pour le déséquiper
- ✅ Ramasse automatiquement les couteaux au sol à proximité
- ✅ Support du backpack et de ReplicatedStorage

## Installation

### Méthode 1 : Script de Personnage (Recommandé)
1. Ouvrez Roblox Studio
2. Dans l'Explorateur, naviguez vers `StarterPlayer` > `StarterCharacterScripts`
3. Insérez un nouveau `LocalScript`
4. Copiez le contenu de `KnifePickup.lua` dans ce script
5. Assurez-vous d'avoir un outil (Tool) nommé "Knife" dans `ReplicatedStorage`

### Méthode 2 : Script GUI
1. Ouvrez Roblox Studio
2. Dans l'Explorateur, naviguez vers `StarterGui`
3. Insérez un nouveau `ScreenGui`
4. Dans le ScreenGui, insérez un `LocalScript`
5. Copiez le contenu de `KnifePickupGUI.lua` dans ce script

## Configuration du Couteau

Pour que le script fonctionne, vous devez créer un outil "Knife" :

1. Créez un nouveau `Tool` dans `ReplicatedStorage`
2. Renommez-le "Knife"
3. Ajoutez une `Part` nommée "Handle" dans le Tool
4. Configurez le Handle avec une forme de couteau (MeshPart recommandé)
5. Ajoutez un `Script` au Tool pour gérer les dégâts (optionnel)

### Exemple de configuration du Handle
```
Handle:
- Size: (0.4, 0.2, 2) ou utilisez un MeshPart
- Color: BrickColor.new("Medium stone grey")
- Material: Enum.Material.Metal
```

## Utilisation

Une fois le script installé et le couteau configuré :

1. **Équiper le couteau** : Appuyez sur `E`
2. **Déséquiper le couteau** : Appuyez à nouveau sur `E`
3. **Ramasser du sol** : Approchez-vous d'un couteau au sol et appuyez sur `E`

## Configuration

Vous pouvez modifier ces paramètres dans le script :

```lua
local PICKUP_KEY = Enum.KeyCode.E        -- Touche pour ramasser/équiper
local KNIFE_NAME = "Knife"               -- Nom de l'outil
local PICKUP_DISTANCE = 10               -- Distance maximale de ramassage
```

### Changer la touche

Pour utiliser une autre touche que 'E', modifiez `PICKUP_KEY` :
- `Enum.KeyCode.F` pour la touche F
- `Enum.KeyCode.Q` pour la touche Q
- `Enum.KeyCode.R` pour la touche R

## Dépannage

### Le couteau n'apparaît pas
- Vérifiez que le Tool "Knife" existe dans ReplicatedStorage
- Vérifiez que le Tool a bien un "Handle"

### La touche 'E' ne fonctionne pas
- Assurez-vous que le script est dans StarterCharacterScripts ou StarterGui
- Vérifiez que c'est bien un LocalScript
- Vérifiez la console de sortie pour les messages d'erreur

### Le couteau disparaît quand je meurs
- C'est le comportement normal de Roblox
- Le script vous permettra de le récupérer en appuyant à nouveau sur 'E'

## Support Multilingue

Le script inclut des messages en français et en anglais pour faciliter la compréhension.

---

# Roblox Script - Knife Pickup with 'E' Key

## Description
This script allows a player to pick up/equip a knife by pressing the 'E' key in Roblox.

## Features
- ✅ Press 'E' to equip the knife
- ✅ Press 'E' again to unequip
- ✅ Automatically picks up nearby knives from the ground
- ✅ Support for backpack and ReplicatedStorage

## Installation

### Method 1: Character Script (Recommended)
1. Open Roblox Studio
2. In Explorer, navigate to `StarterPlayer` > `StarterCharacterScripts`
3. Insert a new `LocalScript`
4. Copy the contents of `KnifePickup.lua` into this script
5. Make sure you have a Tool named "Knife" in `ReplicatedStorage`

### Method 2: GUI Script
1. Open Roblox Studio
2. In Explorer, navigate to `StarterGui`
3. Insert a new `ScreenGui`
4. In the ScreenGui, insert a `LocalScript`
5. Copy the contents of `KnifePickupGUI.lua` into this script

## Knife Configuration

For the script to work, you must create a "Knife" tool:

1. Create a new `Tool` in `ReplicatedStorage`
2. Rename it to "Knife"
3. Add a `Part` named "Handle" in the Tool
4. Configure the Handle with a knife shape (MeshPart recommended)
5. Add a `Script` to the Tool to handle damage (optional)

### Example Handle Configuration
```
Handle:
- Size: (0.4, 0.2, 2) or use a MeshPart
- Color: BrickColor.new("Medium stone grey")
- Material: Enum.Material.Metal
```

## Usage

Once the script is installed and the knife is configured:

1. **Equip the knife**: Press `E`
2. **Unequip the knife**: Press `E` again
3. **Pick up from ground**: Approach a knife on the ground and press `E`

## Configuration

You can modify these parameters in the script:

```lua
local PICKUP_KEY = Enum.KeyCode.E        -- Key to pickup/equip
local KNIFE_NAME = "Knife"               -- Tool name
local PICKUP_DISTANCE = 10               -- Maximum pickup distance
```

### Changing the Key

To use a different key than 'E', modify `PICKUP_KEY`:
- `Enum.KeyCode.F` for F key
- `Enum.KeyCode.Q` for Q key
- `Enum.KeyCode.R` for R key

## Troubleshooting

### The knife doesn't appear
- Check that the Tool "Knife" exists in ReplicatedStorage
- Check that the Tool has a "Handle"

### The 'E' key doesn't work
- Make sure the script is in StarterCharacterScripts or StarterGui
- Verify it's a LocalScript
- Check the output console for error messages

### The knife disappears when I die
- This is normal Roblox behavior
- The script will allow you to get it back by pressing 'E' again

## Multilingual Support

The script includes messages in both French and English for easier understanding.
