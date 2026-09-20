class Annonce {
  final int? id;
  final String titre;
  final String contenu;
  final int auteurId;
  final DateTime datePublication;
  final String categorie;

  const Annonce({
    this.id,
    required this.titre,
    required this.contenu,
    required this.auteurId,
    required this.datePublication,
    required this.categorie,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'auteurId': auteurId,
      'datePublication': datePublication.toIso8601String(),
      'categorie': categorie,
    };
  }

  factory Annonce.fromMap(Map<String, dynamic> map) {
    return Annonce(
      id: map['id'] as int?,
      titre: map['titre'] as String,
      contenu: map['contenu'] as String,
      auteurId: map['auteurId'] as int,
      datePublication: DateTime.parse(map['datePublication'] as String),
      categorie: map['categorie'] as String,
    );
  }
}
