import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/annonce.dart';
import '../models/evenement.dart';
import '../models/utilisateur.dart';

/// Accès unique à la base SQLite locale de DiaspoConnect.
/// Toutes les données (membres, événements, annonces) sont stockées hors
/// ligne : aucune synchronisation cloud n'est prévue (cf. cahier des charges).
class DbHelper {
  DbHelper._internal();
  static final DbHelper instance = DbHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'diaspoconnect.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        motDePasse TEXT NOT NULL,
        pays TEXT NOT NULL,
        ville TEXT NOT NULL,
        photo TEXT,
        bio TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE evenements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        date TEXT NOT NULL,
        lieu TEXT NOT NULL,
        description TEXT NOT NULL,
        organisateurId INTEGER NOT NULL,
        categorie TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE annonces (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        contenu TEXT NOT NULL,
        auteurId INTEGER NOT NULL,
        datePublication TEXT NOT NULL,
        categorie TEXT NOT NULL
      )
    ''');

    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    final fatima = await db.insert('utilisateurs', {
      'nom': 'Diallo',
      'prenom': 'Fatima',
      'email': 'fatima.diallo',
      'motDePasse': 'diaspo123',
      'pays': 'Guinée',
      'ville': 'New York',
      'photo': null,
      'bio': 'Membre fondatrice de la communauté DiaspoConnect à New York.',
    });

    final amadou = await db.insert('utilisateurs', {
      'nom': 'Camara',
      'prenom': 'Amadou',
      'email': 'amadou.camara',
      'motDePasse': 'diaspo123',
      'pays': 'Sénégal',
      'ville': 'Paris',
      'photo': null,
      'bio': "Organisateur d'événements culturels sénégalais à Paris.",
    });

    await db.insert('utilisateurs', {
      'nom': 'Sokona',
      'prenom': 'Marie',
      'email': 'marie.sokona',
      'motDePasse': 'diaspo123',
      'pays': 'Mali',
      'ville': 'Montréal',
      'photo': null,
      'bio': 'Nouvelle arrivante à Montréal, à la recherche de repères.',
    });

    await db.insert('evenements', {
      'titre': 'Soirée culturelle guinéenne',
      'date': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      'lieu': 'Bronx Community Center, NY',
      'description': 'Musique, danse et cuisine traditionnelle guinéenne.',
      'organisateurId': fatima,
      'categorie': 'Culture',
    });

    await db.insert('evenements', {
      'titre': 'Festival afrobeats NYC',
      'date': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
      'lieu': 'Harlem, New York',
      'description': 'Festival de musique afrobeats en plein air.',
      'organisateurId': fatima,
      'categorie': 'Musique',
    });

    await db.insert('evenements', {
      'titre': 'Rencontre réseau diaspora',
      'date': DateTime.now().add(const Duration(days: 16)).toIso8601String(),
      'lieu': 'Manhattan, New York',
      'description': 'Rencontre networking pour les entrepreneurs de la diaspora.',
      'organisateurId': amadou,
      'categorie': 'Réseautage',
    });

    await db.insert('annonces', {
      'titre': "Cours d'anglais gratuit",
      'contenu':
          'Offre des cours chaque samedi matin au Bronx pour nouveaux arrivants.',
      'auteurId': fatima,
      'datePublication':
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'categorie': 'Éducation',
    });

    await db.insert('annonces', {
      'titre': 'Recherche colocataire',
      'contenu': 'Chambre disponible à Brooklyn, 800\$/mois charges comprises.',
      'auteurId': amadou,
      'datePublication':
          DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'categorie': 'Logement',
    });

    await db.insert('annonces', {
      'titre': 'Traducteur disponible',
      'contenu':
          'Pular / Français / Anglais pour rendez-vous médicaux ou administratifs.',
      'auteurId': fatima,
      'datePublication':
          DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      'categorie': 'Services',
    });
  }

  // ---------- Utilisateurs ----------

  Future<int> insertUtilisateur(Utilisateur u) async {
    final db = await database;
    return db.insert('utilisateurs', u.toMap()..remove('id'));
  }

  Future<Utilisateur?> getUtilisateurByIdentifiants(
      String email, String motDePasse) async {
    final db = await database;
    final rows = await db.query(
      'utilisateurs',
      where: 'email = ? AND motDePasse = ?',
      whereArgs: [email, motDePasse],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Utilisateur.fromMap(rows.first);
  }

  Future<bool> emailExiste(String email) async {
    final db = await database;
    final rows = await db.query(
      'utilisateurs',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<Utilisateur?> getUtilisateurById(int id) async {
    final db = await database;
    final rows = await db.query(
      'utilisateurs',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Utilisateur.fromMap(rows.first);
  }

  Future<List<Utilisateur>> getAllUtilisateurs({String? recherche}) async {
    final db = await database;
    List<Map<String, dynamic>> rows;
    if (recherche != null && recherche.trim().isNotEmpty) {
      final q = '%${recherche.trim()}%';
      rows = await db.query(
        'utilisateurs',
        where: 'nom LIKE ? OR prenom LIKE ? OR pays LIKE ? OR ville LIKE ?',
        whereArgs: [q, q, q, q],
        orderBy: 'prenom ASC',
      );
    } else {
      rows = await db.query('utilisateurs', orderBy: 'prenom ASC');
    }
    return rows.map(Utilisateur.fromMap).toList();
  }

  Future<int> updateUtilisateur(Utilisateur u) async {
    final db = await database;
    return db.update(
      'utilisateurs',
      u.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [u.id],
    );
  }

  // ---------- Evenements ----------

  Future<int> insertEvenement(Evenement e) async {
    final db = await database;
    return db.insert('evenements', e.toMap()..remove('id'));
  }

  Future<List<Evenement>> getAllEvenements() async {
    final db = await database;
    final rows = await db.query('evenements', orderBy: 'date ASC');
    return rows.map(Evenement.fromMap).toList();
  }

  Future<int> deleteEvenement(int id) async {
    final db = await database;
    return db.delete('evenements', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- Annonces ----------

  Future<int> insertAnnonce(Annonce a) async {
    final db = await database;
    return db.insert('annonces', a.toMap()..remove('id'));
  }

  Future<List<Annonce>> getAllAnnonces() async {
    final db = await database;
    final rows = await db.query('annonces', orderBy: 'datePublication DESC');
    return rows.map(Annonce.fromMap).toList();
  }

  Future<int> deleteAnnonce(int id) async {
    final db = await database;
    return db.delete('annonces', where: 'id = ?', whereArgs: [id]);
  }
}
