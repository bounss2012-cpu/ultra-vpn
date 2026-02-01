# 🎮 Guide de Démarrage Rapide - Roblox Knife Pickup

## ⚡ Installation en 3 minutes

### Étape 1: Choisir votre méthode

Vous avez le choix entre 3 méthodes. Pour les débutants, nous recommandons **Méthode 1 (Simple)**.

---

### 🌟 Méthode 1: VERSION SIMPLE (Recommandée pour débutants)

**Temps: 2 minutes**

1. Ouvrez **Roblox Studio**
2. Ouvrez ou créez un jeu
3. Dans l'explorateur (à droite), trouvez:
   - `StarterPlayer` → `StarterCharacterScripts`
4. Faites un clic droit sur `StarterCharacterScripts` → `Insert Object` → `LocalScript`
5. Double-cliquez sur le nouveau LocalScript
6. Supprimez le contenu et copiez-collez le code de `KnifePickupSimple.lua`
7. Créez un couteau:
   - Dans le Workspace, cliquez sur le `+`
   - Sélectionnez `Tool`
   - Nommez-le **"Knife"**
   - Cliquez sur le `+` à côté de Knife
   - Ajoutez une `Part` et nommez-la **"Handle"**
8. Appuyez sur **Play** (F5)
9. Approchez-vous du couteau et appuyez sur **E**

✅ **C'est fait!** Le couteau est maintenant dans votre inventaire!

---

### 🚀 Méthode 2: VERSION MODERNE (ProximityPrompt)

**Temps: 3 minutes**

Cette méthode affiche une interface utilisateur quand vous vous approchez du couteau.

1. Ouvrez **Roblox Studio**
2. Dans l'explorateur, trouvez `ServerScriptService`
3. Faites un clic droit → `Insert Object` → `Script`
4. Double-cliquez sur le nouveau Script
5. Copiez-collez le code de `KnifePickupProximityPrompt.lua`
6. Créez un couteau (même méthode que Méthode 1, étapes 7)
7. Appuyez sur **Play** (F5)
8. Approchez-vous du couteau → vous verrez "Ramasser le couteau [E]"
9. Appuyez sur **E**

✅ **Avantage:** Interface visuelle professionnelle!

---

### 💪 Méthode 3: VERSION AVANCÉE

**Temps: 5 minutes**

Pour un contrôle total et des fonctionnalités avancées.

1. Suivez les étapes de la Méthode 1, mais utilisez `KnifePickupScript.lua`
2. Vous pouvez personnaliser:
   - La touche de ramassage
   - La distance de détection
   - Le nom du couteau recherché

---

## 🎁 BONUS: Créer un vrai couteau avec dégâts

Utilisez `CreateKnifeTool.lua` pour créer automatiquement un couteau avec:
- ✨ Apparence métallique
- ⚔️ Système de dégâts
- 🔊 Sons d'attaque
- 🎯 Détection d'ennemis

1. Dans `ServerScriptService`, créez un nouveau Script
2. Copiez-collez le code de `CreateKnifeTool.lua`
3. Appuyez sur Play
4. Un couteau apparaîtra automatiquement dans le jeu!

---

## 🔧 Personnalisation Rapide

### Changer la touche de ramassage:
Dans le script, trouvez:
```lua
local PICKUP_KEY = Enum.KeyCode.E
```

Changez `E` par une autre touche:
- `Enum.KeyCode.F` pour la touche F
- `Enum.KeyCode.Q` pour la touche Q
- `Enum.KeyCode.R` pour la touche R

### Changer la distance de ramassage:
Trouvez:
```lua
local MAX_PICKUP_DISTANCE = 10
```

Changez `10` par un autre nombre (en studs):
- `5` = très proche
- `15` = distance moyenne
- `25` = très loin

### Changer le nom du couteau:
Trouvez:
```lua
local KNIFE_NAME = "Knife"
```

Changez `"Knife"` par le nom de votre outil:
- `"Sword"` pour une épée
- `"Dagger"` pour un poignard
- `"MyCoolKnife"` pour votre couteau personnalisé

---

## ❓ Problèmes Courants

### "Le couteau ne se ramasse pas"
- ✅ Vérifiez que le Tool s'appelle bien "Knife"
- ✅ Vérifiez qu'il y a bien un "Handle" dans le Tool
- ✅ Assurez-vous d'être assez proche (moins de 10 studs)

### "Le script ne fonctionne pas"
- ✅ Vérifiez que le script est dans le bon emplacement:
  - LocalScript → `StarterPlayer > StarterCharacterScripts`
  - Script → `ServerScriptService`
- ✅ Regardez la fenêtre "Output" pour voir les erreurs
- ✅ Appuyez sur F5 pour relancer le jeu

### "Je ne vois pas l'indicateur ProximityPrompt"
- ✅ Utilisez la Méthode 2 (ProximityPrompt)
- ✅ Le script doit être dans `ServerScriptService`
- ✅ Le couteau doit avoir un Handle

---

## 📚 Fichiers Disponibles

| Fichier | Difficulté | Usage |
|---------|-----------|-------|
| `KnifePickupSimple.lua` | ⭐ Facile | Version simplifiée pour débuter |
| `KnifePickupProximityPrompt.lua` | ⭐⭐ Moyen | Version moderne avec UI |
| `KnifePickupScript.lua` | ⭐⭐⭐ Avancé | Version complète et configurable |
| `CreateKnifeTool.lua` | ⭐⭐ Moyen | Créer un couteau automatiquement |
| `README_ROBLOX.md` | 📖 Doc | Documentation complète |

---

## 🎉 Et voilà!

Vous avez maintenant un système de ramassage de couteau fonctionnel!

**Prochaines étapes:**
1. Personnalisez l'apparence du couteau
2. Ajoutez des effets sonores
3. Créez un système d'inventaire
4. Ajoutez des animations d'attaque

**Besoin d'aide?** Consultez `README_ROBLOX.md` pour la documentation complète!

---

**Bon jeu! 🎮**
