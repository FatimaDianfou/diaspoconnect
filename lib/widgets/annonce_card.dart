import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/annonce.dart';
import '../models/utilisateur.dart';
import '../theme/app_theme.dart';

class AnnonceCard extends StatelessWidget {
  final Annonce annonce;
  final Utilisateur? auteur;
  final VoidCallback? onDelete;

  const AnnonceCard({
    super.key,
    required this.annonce,
    required this.auteur,
    this.onDelete,
  });

  String _ilYA(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 7) {
      final semaines = (diff.inDays / 7).floor();
      return "il y a $semaines sem.";
    }
    if (diff.inDays >= 1) return "il y a ${diff.inDays} j";
    return "aujourd'hui";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: AppColors.accent, width: 4),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(annonce.titre, style: AppTextStyles.titreCarte),
                  const SizedBox(height: 4),
                  Text(
                    annonce.contenu,
                    style: AppTextStyles.corps,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${auteur?.prenom ?? "?"} ${auteur != null ? "${auteur!.nom[0]}." : ""} · ${_ilYA(annonce.datePublication)}',
                    style: AppTextStyles.metadonnee,
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.erreur),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}

// Formatteur conservé pour un usage éventuel de date complète (profil, détail).
final DateFormat dateCompleteFr = DateFormat('d MMMM yyyy', 'fr_FR');
