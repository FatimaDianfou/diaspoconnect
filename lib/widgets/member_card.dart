import 'package:flutter/material.dart';

import '../models/utilisateur.dart';
import '../theme/app_theme.dart';

class MemberCard extends StatelessWidget {
  final Utilisateur membre;
  final VoidCallback onTap;

  const MemberCard({super.key, required this.membre, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.fondClair,
                child: Text(
                  membre.initiales,
                  style: const TextStyle(
                    color: AppColors.primaire,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(membre.nomComplet, style: AppTextStyles.titreCarte),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(membre.ville, style: AppTextStyles.sousTitre),
                        const SizedBox(width: 6),
                        _Badge(texte: membre.pays),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.texteSecondaire),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String texte;
  const _Badge({required this.texte});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.fondClair,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(texte, style: AppTextStyles.badge),
    );
  }
}
