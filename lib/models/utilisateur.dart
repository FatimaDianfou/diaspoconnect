class Utilisateur {
  final int? id;
  final String nom;
  final String prenom;
  final String email;
  final String motDePasse;
  final String pays;
  final String ville;
  final String? photo;
  final String? bio;

  const Utilisateur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.motDePasse,
    required this.pays,
    required this.ville,
    this.photo,
    this.bio,
  });

  String get nomComplet => '$prenom $nom';

  String get initiales {
    final p = prenom.isNotEmpty ? prenom[0] : '';
    final n = nom.isNotEmpty ? nom[0] : '';
    return '$p$n'.toUpperCase();
  }

  Utilisateur copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? email,
    String? motDePasse,
    String? pays,
    String? ville,
    String? photo,
    String? bio,
  }) {
    return Utilisateur(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      motDePasse: motDePasse ?? this.motDePasse,
      pays: pays ?? this.pays,
      ville: ville ?? this.ville,
      photo: photo ?? this.photo,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'motDePasse': motDePasse,
      'pays': pays,
      'ville': ville,
      'photo': photo,
      'bio': bio,
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
      motDePasse: map['motDePasse'] as String,
      pays: map['pays'] as String,
      ville: map['ville'] as String,
      photo: map['photo'] as String?,
      bio: map['bio'] as String?,
    );
  }
}
