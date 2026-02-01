# 🎮 Système de Ramassage de Couteau Roblox
# 🎮 Roblox Knife Pickup System

## 📌 Résumé du Projet / Project Summary

Ce dépôt contient un système complet pour permettre aux joueurs de ramasser et équiper un couteau dans Roblox en appuyant sur la touche 'E'.

This repository contains a complete system to allow players to pick up and equip a knife in Roblox by pressing the 'E' key.

---

## 🎯 Réponse à la Demande / Response to Request

**Demande originale:** "crée moi un code roblox qui me permet de prendre mon couteau avec la touche e"

**Solution fournie:** Système complet avec 3 scripts et documentation détaillée.

---

## 📦 Contenu du Dépôt / Repository Contents

### Scripts Lua

1. **`KnifePickup.lua`** (4.2 KB)
   - Script principal avec toutes les fonctionnalités
   - Ramassage depuis le sol, backpack et ReplicatedStorage
   - Système de distance configurable
   - Messages bilingues

2. **`KnifePickupGUI.lua`** (3.3 KB)
   - Version simplifiée pour placement dans GUI
   - Plus léger et plus facile à implémenter
   - Parfait pour les débutants

3. **`KnifeToolScript.lua`** (2.8 KB)
   - Script exemple pour l'outil couteau
   - Système de dégâts
   - Sons et animations
   - Cooldown entre attaques

### Documentation

4. **`ROBLOX_README.md`** (5.4 KB)
   - Documentation complète du système
   - Instructions d'installation détaillées
   - Guide de configuration
   - Section de dépannage

5. **`GUIDE_INSTALLATION.md`** (6.2 KB)
   - Guide visuel étape par étape
   - Checklist d'installation
   - Idées d'amélioration
   - Conseils de sécurité

---

## 🚀 Démarrage Rapide / Quick Start

### En 3 Étapes / In 3 Steps

```
1️⃣ Créer le couteau dans ReplicatedStorage
   Create knife in ReplicatedStorage

2️⃣ Copier KnifePickup.lua dans StarterCharacterScripts
   Copy KnifePickup.lua to StarterCharacterScripts

3️⃣ Appuyer sur Play et tester avec la touche 'E'
   Press Play and test with 'E' key
```

---

## ✨ Fonctionnalités Clés / Key Features

| Fonctionnalité | Description |
|----------------|-------------|
| 🔑 Touche 'E' | Équiper/Déséquiper le couteau |
| 📍 Ramassage au sol | Détecte automatiquement les couteaux proches |
| 🎒 Support Backpack | Intégration complète avec l'inventaire |
| 🌍 Bilingue | Messages en français et anglais |
| ⚙️ Configurable | Distance, touche, nom personnalisables |
| 💥 Système de dégâts | Script de couteau avec dégâts et cooldown |

---

## 🎬 Utilisation / Usage

### Dans Roblox Studio

1. Ouvrir le projet dans Roblox Studio
2. Suivre le guide dans `GUIDE_INSTALLATION.md`
3. Tester avec le bouton Play ▶️

### Dans le Jeu

- **Équiper:** Appuyez sur `E`
- **Déséquiper:** Appuyez à nouveau sur `E`
- **Ramasser:** Approchez-vous d'un couteau et appuyez sur `E`

---

## 🔧 Configuration

### Changer la Touche / Change the Key

Dans `KnifePickup.lua` ou `KnifePickupGUI.lua`:

```lua
local PICKUP_KEY = Enum.KeyCode.E  -- Changez en F, Q, R, etc.
```

### Changer le Nom du Couteau / Change Knife Name

```lua
local KNIFE_NAME = "Knife"  -- Changez en "Dagger", "Sword", etc.
```

### Ajuster la Distance / Adjust Distance

```lua
local PICKUP_DISTANCE = 10  -- Distance en studs
```

---

## 📚 Structure du Projet / Project Structure

```
ultra-vpn/
├── KnifePickup.lua           # Script principal / Main script
├── KnifePickupGUI.lua        # Version GUI / GUI version
├── KnifeToolScript.lua       # Script de l'outil / Tool script
├── ROBLOX_README.md          # Documentation / Documentation
├── GUIDE_INSTALLATION.md     # Guide d'installation / Installation guide
└── SUMMARY.md                # Ce fichier / This file
```

---

## 🎓 Pour les Débutants / For Beginners

### Qu'est-ce qu'un LocalScript?

Un LocalScript s'exécute côté client (sur l'ordinateur du joueur). Il est utilisé pour les interactions utilisateur comme les touches du clavier.

A LocalScript runs on the client-side (on the player's computer). It's used for user interactions like keyboard inputs.

### Qu'est-ce qu'un Tool?

Un Tool est un objet que le joueur peut équiper et utiliser. Il doit contenir un "Handle" (poignée) pour fonctionner.

A Tool is an object that the player can equip and use. It must contain a "Handle" to work.

### Pourquoi ReplicatedStorage?

ReplicatedStorage est accessible à la fois par le client et le serveur, parfait pour stocker des templates d'objets.

ReplicatedStorage is accessible by both client and server, perfect for storing object templates.

---

## ⚠️ Notes Importantes / Important Notes

### Sécurité / Security

- Les scripts actuels sont côté client (pour simplicité)
- Pour un jeu public, ajoutez une validation serveur
- Utilisez RemoteEvents pour empêcher la triche

### Performance

- Le script vérifie la distance toutes les fois que 'E' est pressé
- Pour de nombreux joueurs, optimisez avec des RegionChecks
- Limitez le nombre d'objets ramassables

### Compatibilité

- ✅ Fonctionne avec tous les jeux Roblox
- ✅ Compatible avec le système de backpack par défaut
- ✅ Supporte les téléphones (peut être adapté pour le tactile)

---

## 🐛 Dépannage Commun / Common Troubleshooting

| Problème | Solution |
|----------|----------|
| Couteau n'apparaît pas | Vérifier ReplicatedStorage et nom exact |
| Touche ne répond pas | Vérifier que c'est un LocalScript |
| Erreurs dans Output | Vérifier les noms et chemins exacts |
| Couteau disparaît | Normal à la mort, reprendre avec 'E' |

---

## 🎯 Prochaines Étapes / Next Steps

### Améliorations Possibles / Possible Improvements

1. ✨ Ajouter une interface graphique
2. 🎨 Créer des effets visuels
3. 🎵 Ajouter des sons personnalisés
4. 🏆 Système d'achievements
5. 💎 Différentes qualités de couteaux
6. 🔒 Système de déverrouillage

---

## 📞 Support et Aide / Support and Help

### Ressources

- **Documentation Roblox:** https://create.roblox.com/docs
- **DevForum:** https://devforum.roblox.com
- **Tutoriels YouTube:** Recherchez "Roblox scripting tutorials"

### Fichiers de Référence

- Pour l'installation: `GUIDE_INSTALLATION.md`
- Pour la configuration: `ROBLOX_README.md`
- Pour le code: Les fichiers `.lua`

---

## ✅ Checklist de Vérification / Verification Checklist

Avant de signaler un problème, vérifiez:

- [ ] Le Tool "Knife" existe dans ReplicatedStorage
- [ ] Le Tool a un "Handle" (Part)
- [ ] Le script est un LocalScript
- [ ] Le script est dans StarterCharacterScripts ou StarterGui
- [ ] Vous avez testé en mode Play
- [ ] La console Output ne montre pas d'erreurs

---

## 📄 Licence / License

Code fourni à des fins éducatives. Libre d'utilisation dans vos projets Roblox.

Code provided for educational purposes. Free to use in your Roblox projects.

---

## 🎉 Conclusion

Vous avez maintenant tout le nécessaire pour créer un système de ramassage de couteau fonctionnel dans Roblox!

You now have everything needed to create a functional knife pickup system in Roblox!

**Amusez-vous bien! / Have fun!** 🎮

---

**Créé le:** 1er Février 2026  
**Version:** 1.0  
**Langage:** Lua (Roblox)  
**Compatibilité:** Tous les jeux Roblox
