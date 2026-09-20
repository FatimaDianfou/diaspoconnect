import 'package:flutter/material.dart';

import '../../models/utilisateur.dart';
import '../../services/db_helper.dart';
import '../../theme/app_theme.dart';
import '../../widgets/member_card.dart';
import 'membre_detail_screen.dart';

class MembresScreen extends StatefulWidget {
  const MembresScreen({super.key});

  @override
  State<MembresScreen> createState() => _MembresScreenState();
}

class _MembresScreenState extends State<MembresScreen> {
  List<Utilisateur> _membres = [];
  bool _chargement = true;
  String _recherche = '';

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _chargement = true);
    final membres =
        await DbHelper.instance.getAllUtilisateurs(recherche: _recherche);
    if (!mounted) return;
    setState(() {
      _membres = membres;
      _chargement = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Membres')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher par nom, pays, ville...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) {
                _recherche = v;
                _charger();
              },
            ),
          ),
          Expanded(
            child: _chargement
                ? const Center(child: CircularProgressIndicator())
                : _membres.isEmpty
                    ? const _AucunMembre()
                    : RefreshIndicator(
                        onRefresh: _charger,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: _membres.length,
                          itemBuilder: (context, i) {
                            final membre = _membres[i];
                            return MemberCard(
                              membre: membre,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MembreDetailScreen(membre: membre),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _AucunMembre extends StatelessWidget {
  const _AucunMembre();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Aucun membre ne correspond à votre recherche.',
          textAlign: TextAlign.center,
          style: AppTextStyles.sousTitre,
        ),
      ),
    );
  }
}
