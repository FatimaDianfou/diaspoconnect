import 'package:flutter/material.dart';

import '../../models/utilisateur.dart';
import '../../theme/app_theme.dart';

class MembreDetailScreen extends StatelessWidget {
  final Utilisateur membre;

  const MembreDetailScreen({super.key, required this.membre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(membre.nomComplet)),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primaire,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    membre.initiales,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  membre.nomComplet,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  membre.ville,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ligneInfo(Icons.public, "Pays d'origine", membre.pays),
                _ligneInfo(Icons.location_city, 'Ville', membre.ville),
                if (membre.bio != null && membre.bio!.isNotEmpty)
                  _ligneInfo(Icons.info_outline, 'Bio', membre.bio!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ligneInfo(IconData icone, String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: AppColors.primaire, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.sousTitre),
                const SizedBox(height: 2),
                Text(valeur, style: AppTextStyles.corps),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
