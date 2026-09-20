# Rapport – Semaine 6 : Réalisation, tests et déploiement de DiaspoConnect

**Projet :** DiaspoConnect
**Auteur :** Fatoumata Diallo
**Date :** 20/09/2026

---

## 1. Continuité avec la semaine 5

L'application développée reprend directement les choix de conception établis en semaine 5 : une application locale (SQLite) pour l'entraide et le lien social entre membres d'une diaspora, avec quatre pôles fonctionnels (membres, annonces, événements, profil) accessibles depuis une navigation principale après authentification.

## 2. État du développement

| Élément | État |
|---|---|
| Écrans principaux (connexion, inscription, membres, annonces, événements, profil) | Réalisés |
| Navigation entre écrans | Réalisée (navigation par onglets + push de détail) |
| Classes métier (`Utilisateur`, `Annonce`, `Evenement`) | Réalisées avec `toMap`/`fromMap` |
| Stockage local SQLite (`DbHelper`) | Réalisé, CRUD sur les 3 entités |
| Gestion d'état (`setState`) | Réalisée |
| Validations de formulaires | Réalisées (connexion, inscription, ajout annonce/événement, édition profil) |
| Messages de confirmation/erreur | Réalisés (SnackBar de confirmation, messages d'erreur de connexion) |
| États visuels (chargement) | Réalisé sur l'écran de démarrage et la connexion |

## 3. Vérifications effectuées

```bash
flutter analyze
# Analyzing diaspoconnect... No issues found! (ran in 2.4s)

flutter test
# 11 tests, tous passés (tests unitaires + tests de widgets)
```

- **Tests unitaires** : `test/models_test.dart` — vérifie la sérialisation (`toMap`/`fromMap`) des trois modèles, le calcul des initiales et `copyWith` sur `Utilisateur`.
- **Tests de widgets** : `test/login_screen_test.dart` — vérifie que les erreurs de validation s'affichent sur un formulaire vide et que le mot de passe est masqué par défaut ; `test/member_card_test.dart` — vérifie l'affichage des informations d'un membre et le déclenchement du callback `onTap`.
- **Débogage** : `flutter analyze` en premier réflexe, puis observation des logs console lors des interactions SQLite (insert/update/delete) et inspection de l'arbre de widgets via Flutter DevTools pendant l'exécution sur macOS.
- **Test manuel des parcours** : connexion avec le compte de démonstration (`fatima.diallo` / `diaspo123`), navigation entre les quatre onglets, ajout puis suppression d'une annonce et d'un événement, modification du profil, déconnexion/reconnexion.

## 4. Build et déploiement

- `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk` (51,5 Mo), généré sans erreur.
- Application testée sur macOS desktop (`flutter run -d macos`) : lancement et affichage corrects.

## 5. Performance et écoconception

- Widgets statiques déclarés `const` pour limiter les reconstructions inutiles.
- Une seule connexion SQLite ouverte pour toute la durée de vie de l'application (singleton `DbHelper`).
- Aucune image lourde embarquée ; icônes vectorielles Material par défaut.

## 6. Difficultés rencontrées

- Choix du stockage 100 % local plutôt que Firebase, pour un usage cohérent avec le contexte réel (accès internet parfois limité pour les membres de la diaspora).
- Cohérence des clés étrangères (`organisateurId`, `auteurId`) entre les tables lors des suppressions.

## 7. Suite possible

- Ajout d'un test d'intégration bout-en-bout (`integration_test/`) couvrant le parcours connexion → ajout d'annonce → déconnexion.
- Ajout de captures d'écran et d'une capture DevTools dans `captures/` avant la démonstration finale.
