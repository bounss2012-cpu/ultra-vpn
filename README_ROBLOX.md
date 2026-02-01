# Script Roblox - Ramassage de Couteau avec la touche E

Ce projet contient plusieurs scripts Lua pour Roblox qui permettent de ramasser un couteau en appuyant sur la touche E.

## 📁 Fichiers inclus

### 1. `KnifePickupScript.lua` (Méthode LocalScript)
Script client qui détecte les couteaux à proximité et permet de les ramasser avec la touche E.

**Avantages:**
- Simple à implémenter
- Détection automatique des couteaux
- Distance de ramassage configurable

**Installation:**
1. Ouvrez Roblox Studio
2. Dans l'explorateur, naviguez vers `StarterPlayer > StarterCharacterScripts`
3. Créez un nouveau LocalScript
4. Copiez le contenu de `KnifePickupScript.lua` dans ce script
5. Configurez les variables si nécessaire (distance, nom du couteau, etc.)

### 2. `KnifePickupProximityPrompt.lua` (Méthode ProximityPrompt)
Script serveur qui utilise le système ProximityPrompt de Roblox pour un ramassage plus moderne.

**Avantages:**
- Interface utilisateur intégrée
- Compatible tous appareils (PC, Mobile, Console)
- Affichage automatique de la touche à presser
- Plus professionnel

**Installation:**
1. Ouvrez Roblox Studio
2. Dans l'explorateur, naviguez vers `ServerScriptService`
3. Créez un nouveau Script
4. Copiez le contenu de `KnifePickupProximityPrompt.lua` dans ce script
5. Le script détectera automatiquement les couteaux dans le Workspace

### 3. `CreateKnifeTool.lua` (Création de couteau)
Script serveur qui crée automatiquement un couteau dans le jeu.

**Installation:**
1. Ouvrez Roblox Studio
2. Dans l'explorateur, naviguez vers `ServerScriptService`
3. Créez un nouveau Script
4. Copiez le contenu de `CreateKnifeTool.lua` dans ce script
5. Exécutez le jeu pour voir le couteau apparaître

## 🎮 Guide d'utilisation

### Configuration Rapide (Recommandé)

Pour une configuration simple et moderne, utilisez la méthode ProximityPrompt:

1. **Installer le script de ramassage:**
   - Copiez `KnifePickupProximityPrompt.lua` dans `ServerScriptService`

2. **Créer un couteau:**
   - Méthode A: Utilisez `CreateKnifeTool.lua` pour créer un couteau automatiquement
   - Méthode B: Créez manuellement un Tool nommé "Knife" avec un Handle dans le Workspace

3. **Tester:**
   - Lancez le jeu
   - Approchez-vous du couteau
   - Vous verrez apparaître "Ramasser le couteau [E]"
   - Appuyez sur E pour ramasser le couteau

### Configuration Avancée (LocalScript)

Si vous préférez plus de contrôle:

1. **Installer le script de ramassage:**
   - Copiez `KnifePickupScript.lua` dans `StarterPlayer > StarterCharacterScripts`

2. **Créer un couteau:**
   - Utilisez `CreateKnifeTool.lua` ou créez votre propre couteau

3. **Personnaliser:**
   ```lua
   local PICKUP_KEY = Enum.KeyCode.E  -- Changer la touche
   local MAX_PICKUP_DISTANCE = 10     -- Changer la distance
   local KNIFE_NAME = "Knife"         -- Changer le nom du couteau
   ```

## ⚙️ Configuration

### Variables configurables dans KnifePickupScript.lua:
- `PICKUP_KEY`: La touche pour ramasser (par défaut: E)
- `MAX_PICKUP_DISTANCE`: Distance maximale en studs (par défaut: 10)
- `KNIFE_NAME`: Nom exact du couteau à chercher (par défaut: "Knife")

### Variables configurables dans KnifePickupProximityPrompt.lua:
- `KNIFE_NAME`: Nom du couteau (par défaut: "Knife")
- `PROMPT_TEXT`: Texte affiché au joueur (par défaut: "Ramasser le couteau")
- `MAX_DISTANCE`: Distance maximale d'activation (par défaut: 10)

## 🔧 Personnalisation du Couteau

Pour personnaliser votre couteau, éditez `CreateKnifeTool.lua`:

```lua
-- Changer la taille
handle.Size = Vector3.new(0.4, 0.2, 2)

-- Changer la couleur
handle.BrickColor = BrickColor.new("Really red")

-- Changer le matériau
handle.Material = Enum.Material.Neon

-- Changer les dégâts
local damage = 20  -- Dans le script d'attaque
```

## 📝 Fonctionnalités

### KnifePickupScript.lua:
- ✅ Détection automatique des couteaux à proximité
- ✅ Ramassage avec la touche E
- ✅ Distance configurable
- ✅ Équipement automatique après ramassage
- ✅ Messages de débogage dans la console

### KnifePickupProximityPrompt.lua:
- ✅ Interface utilisateur intégrée
- ✅ Affichage visuel de l'interaction possible
- ✅ Compatible multiplateforme
- ✅ Détection automatique de nouveaux couteaux
- ✅ Équipement automatique après ramassage

### CreateKnifeTool.lua:
- ✅ Création automatique d'un couteau
- ✅ Système de dégâts intégré
- ✅ Son d'attaque (optionnel)
- ✅ Animation de tranchage
- ✅ Cooldown configurable

## 🐛 Dépannage

**Le couteau ne se ramasse pas:**
- Vérifiez que le couteau a bien un objet "Handle"
- Vérifiez que la distance entre le joueur et le couteau est inférieure à MAX_PICKUP_DISTANCE
- Assurez-vous que le nom du couteau correspond à KNIFE_NAME

**L'indicateur ProximityPrompt n'apparaît pas:**
- Vérifiez que le script est dans ServerScriptService
- Vérifiez que le couteau est dans le Workspace
- Assurez-vous que le couteau a un Handle

**Le script ne fonctionne pas:**
- Vérifiez la console Output pour les erreurs
- Assurez-vous que les scripts sont dans les bons emplacements
- Vérifiez que FilteringEnabled est activé (par défaut dans Roblox)

## 📚 Ressources Supplémentaires

- [Documentation Roblox sur les Tools](https://developer.roblox.com/en-us/api-reference/class/Tool)
- [Documentation sur ProximityPrompt](https://developer.roblox.com/en-us/api-reference/class/ProximityPrompt)
- [Documentation sur UserInputService](https://developer.roblox.com/en-us/api-reference/class/UserInputService)

## 🤝 Contribution

N'hésitez pas à modifier et améliorer ces scripts selon vos besoins!

## 📄 Licence

Ces scripts sont fournis à titre éducatif et peuvent être utilisés librement dans vos projets Roblox.
