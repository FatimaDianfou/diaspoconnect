import 'package:flutter/material.dart';

import 'annonces/annonces_screen.dart';
import 'evenements/evenements_screen.dart';
import 'membres/membres_screen.dart';
import 'profil/profil_screen.dart';

/// Coquille de navigation principale : 4 onglets (Membres, Événements,
/// Annonces, Profil) via BottomNavigationBar, conformément aux wireframes.
class MainNavScreen extends StatefulWidget {
  final int utilisateurId;

  const MainNavScreen({super.key, required this.utilisateurId});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final ecrans = [
      const MembresScreen(),
      const EvenementsScreen(),
      const AnnoncesScreen(),
      ProfilScreen(utilisateurId: widget.utilisateurId),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: ecrans),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Membres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Événements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign_outlined),
            activeIcon: Icon(Icons.campaign),
            label: 'Annonces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
