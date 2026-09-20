class Evenement {
  final int? id;
  final String titre;
  final DateTime date;
  final String lieu;
  final String description;
  final int organisateurId;
  final String categorie;

  const Evenement({
    this.id,
    required this.titre,
    required this.date,
    required this.lieu,
    required this.description,
    required this.organisateurId,
    required this.categorie,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'date': date.toIso8601String(),
      'lieu': lieu,
      'description': description,
      'organisateurId': organisateurId,
      'categorie': categorie,
    };
  }

  factory Evenement.fromMap(Map<String, dynamic> map) {
    return Evenement(
      id: map['id'] as int?,
      titre: map['titre'] as String,
      date: DateTime.parse(map['date'] as String),
      lieu: map['lieu'] as String,
      description: map['description'] as String,
      organisateurId: map['organisateurId'] as int,
      categorie: map['categorie'] as String,
    );
  }
}
