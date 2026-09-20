import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/evenement.dart';
import '../theme/app_theme.dart';

class EventCard extends StatelessWidget {
  final Evenement evenement;
  final VoidCallback? onDelete;

  const EventCard({super.key, required this.evenement, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final formatteurDate = DateFormat('d MMM yyyy', 'fr_FR');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaire,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                formatteurDate.format(evenement.date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(evenement.titre, style: AppTextStyles.titreCarte),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: AppColors.texteSecondaire),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(evenement.lieu,
                            style: AppTextStyles.sousTitre,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
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
