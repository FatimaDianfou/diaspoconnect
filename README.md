# DiaspoConnect

Application mobile Flutter destinée aux membres de la diaspora d'une même communauté (ex : communauté guinéenne/ouest-africaine) vivant à l'étranger. Elle permet de retrouver les membres de la communauté autour de soi, de consulter et publier des annonces d'entraide (logement, services, cours…) et de découvrir les événements culturels et de réseautage à venir.

## Objectif

Faciliter le lien social et l'entraide entre membres d'une diaspora dispersée dans plusieurs villes : se repérer entre membres, s'informer des événements communautaires, s'entraider via des annonces, sans dépendre d'une connexion internet permanente (toutes les données sont stockées en local sur l'appareil).

## Fonctionnalités principales

- **Authentification** : connexion et création de compte (nom, prénom, email, mot de passe, pays, ville), session conservée entre les lancements de l'application (`shared_preferences`).
- **Annuaire des membres** : liste des membres de la communauté avec recherche (nom, prénom, pays, ville) et fiche détail par membre.
- **Annonces** : consultation, publication et suppression d'annonces (catégorie, contenu, date de publication).
- **Événements** : consultation, création et suppression d'événements (titre, date, lieu, description, catégorie, organisateur).
- **Profil** : consultation et modification des informations personnelles, déconnexion.
- **États visuels** : indicateurs de chargement, messages d'erreur de validation sur les formulaires, messages de confirmation (SnackBar) après ajout/suppression.

## Technologies et packages utilisés

- **Flutter / Dart** (SDK ^3.12.0)
- **sqflite** — stockage local relationnel (SQLite) pour les membres, annonces et événements
- **shared_preferences** — persistance de la session utilisateur
- **image_picker** — sélection d'une photo de profil
- **intl** — formatage des dates en français
- **flutter_test** — tests unitaires et tests de widgets

### Gestion d'état

`StatefulWidget` / `setState`, avec un accès aux données centralisé dans `DbHelper` (singleton), pour rester simple et adapté à la taille de l'application.

### Architecture du projet

```
lib/
  main.dart              Point d'entrée, vérifie la session au démarrage
  models/                Classes métier (Utilisateur, Annonce, Evenement)
  screens/                Écrans de l'application, un sous-dossier par fonctionnalité
  widgets/                Widgets réutilisables (cartes membre/annonce/événement)
  services/               Accès aux données (DbHelper) et à la session (SessionService)
  theme/                  Thème visuel de l'application
```

## Installation

Prérequis : [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel stable), un émulateur Android/iOS ou un navigateur Chrome.

```bash
git clone <url-du-depot>
cd diaspoconnect
flutter pub get
```

## Lancement de l'application

```bash
flutter run
```

Un compte de démonstration est créé automatiquement au premier lancement (base de données pré-remplie) :

- Identifiant : `fatima.diallo`
- Mot de passe : `diaspo123`

## Tests réalisés

```bash
flutter analyze   # aucune erreur ni avertissement
flutter test      # tests unitaires et tests de widgets
```

- **Tests unitaires** (`test/models_test.dart`) : conversion `toMap`/`fromMap` des modèles `Utilisateur`, `Evenement`, `Annonce`, calcul des initiales, `copyWith`.
- **Tests de widgets** (`test/login_screen_test.dart`) : validation des champs du formulaire de connexion, masquage du mot de passe par défaut.
- **Tests de widgets** (`test/member_card_test.dart`) : affichage correct des informations d'un membre sur sa carte, déclenchement de l'action au tap.
- Débogage réalisé avec `flutter analyze`, les logs de la console et Flutter DevTools (inspection de l'arbre de widgets et des performances de rendu).

## Captures d'écran

_Voir le dossier [`captures/`](captures/)._

## Difficultés rencontrées

- Choix d'un stockage entièrement local (SQLite) plutôt que Firebase, pour permettre une utilisation hors ligne cohérente avec l'usage réel visé (membres de la diaspora avec un accès internet parfois limité).
- Maintien de la cohérence des identifiants entre les tables (`organisateurId`, `auteurId`) lors des opérations de création/suppression en SQLite.

## Auteur

Fatoumata Diallo
