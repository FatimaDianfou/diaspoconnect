import 'package:flutter_test/flutter_test.dart';

import 'package:diaspoconnect/models/annonce.dart';
import 'package:diaspoconnect/models/evenement.dart';
import 'package:diaspoconnect/models/utilisateur.dart';

void main() {
  group('Utilisateur', () {
    test('toMap/fromMap conserve toutes les données', () {
      const u = Utilisateur(
        id: 1,
        nom: 'Diallo',
        prenom: 'Fatima',
        email: 'fatima.diallo',
        motDePasse: 'diaspo123',
        pays: 'Guinée',
        ville: 'New York',
        photo: null,
        bio: 'Membre fondatrice',
      );

      final restaure = Utilisateur.fromMap(u.toMap());

      expect(restaure.nom, u.nom);
      expect(restaure.prenom, u.prenom);
      expect(restaure.email, u.email);
      expect(restaure.pays, u.pays);
      expect(restaure.ville, u.ville);
      expect(restaure.bio, u.bio);
    });

    test('initiales retourne la première lettre du prénom et du nom', () {
      const u = Utilisateur(
        nom: 'Camara',
        prenom: 'Amadou',
        email: 'amadou.camara',
        motDePasse: 'x',
        pays: 'Sénégal',
        ville: 'Paris',
      );

      expect(u.initiales, 'AC');
      expect(u.nomComplet, 'Amadou Camara');
    });

    test('copyWith ne modifie que les champs fournis', () {
      const u = Utilisateur(
        id: 2,
        nom: 'Sokona',
        prenom: 'Marie',
        email: 'marie.sokona',
        motDePasse: 'x',
        pays: 'Mali',
        ville: 'Montréal',
      );

      final modifie = u.copyWith(ville: 'Toronto');

      expect(modifie.ville, 'Toronto');
      expect(modifie.nom, u.nom);
      expect(modifie.prenom, u.prenom);
    });
  });

  group('Evenement', () {
    test('toMap/fromMap conserve la date', () {
      final date = DateTime(2026, 8, 15);
      final e = Evenement(
        id: 5,
        titre: 'Festival afrobeats NYC',
        date: date,
        lieu: 'Harlem, New York',
        description: 'Festival en plein air',
        organisateurId: 1,
        categorie: 'Musique',
      );

      final restaure = Evenement.fromMap(e.toMap());

      expect(restaure.titre, e.titre);
      expect(restaure.date, date);
      expect(restaure.lieu, e.lieu);
      expect(restaure.categorie, e.categorie);
    });
  });

  group('Annonce', () {
    test('toMap/fromMap conserve le contenu et la date de publication', () {
      final date = DateTime(2026, 7, 1, 10, 30);
      final a = Annonce(
        id: 3,
        titre: "Cours d'anglais gratuit",
        contenu: 'Offre des cours chaque samedi matin.',
        auteurId: 1,
        datePublication: date,
        categorie: 'Éducation',
      );

      final restaure = Annonce.fromMap(a.toMap());

      expect(restaure.titre, a.titre);
      expect(restaure.contenu, a.contenu);
      expect(restaure.auteurId, a.auteurId);
      expect(restaure.datePublication, date);
    });
  });
}
