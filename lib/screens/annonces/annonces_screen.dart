import 'package:flutter/material.dart';

import '../../models/annonce.dart';
import '../../models/utilisateur.dart';
import '../../services/db_helper.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/annonce_card.dart';
import 'add_annonce_screen.dart';

class AnnoncesScreen extends StatefulWidget {
  const AnnoncesScreen({super.key});

  @override
  State<AnnoncesScreen> createState() => _AnnoncesScreenState();
}

class _AnnoncesScreenState extends State<AnnoncesScreen> {
  List<Annonce> _annonces = [];
  Map<int, Utilisateur> _auteurs = {};
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _chargement = true);
    final annonces = await DbHelper.instance.getAllAnnonces();
    final utilisateurs = await DbHelper.instance.getAllUtilisateurs();
    if (!mounted) return;
    setState(() {
      _annonces = annonces;
      _auteurs = {for (final u in utilisateurs) u.id!: u};
      _chargement = false;
    });
  }

  Future<void> _supprimer(Annonce a) async {
    await DbHelper.instance.deleteAnnonce(a.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Annonce supprimée.')),
    );
    _charger();
  }

  Future<void> _ouvrirFormulaireAjout() async {
    final utilisateurId = await SessionService.instance.getUtilisateurConnecteId();
    if (utilisateurId == null || !mounted) return;

    final cree = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddAnnonceScreen(auteurId: utilisateurId),
      ),
    );

    if (cree == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Annonce publiée avec succès.')),
      );
      _charger();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Annonces'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.campaign_outlined),
          ),
        ],
      ),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
          : _annonces.isEmpty
              ? const _AucuneAnnonce()
              : RefreshIndicator(
                  onRefresh: _charger,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _annonces.length,
                    itemBuilder: (context, i) {
                      final a = _annonces[i];
                      return AnnonceCard(
                        annonce: a,
                        auteur: _auteurs[a.auteurId],
                        onDelete: () => _supprimer(a),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ouvrirFormulaireAjout,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AucuneAnnonce extends StatelessWidget {
  const _AucuneAnnonce();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          "Aucune annonce pour le moment.\nPubliez la première annonce !",
          textAlign: TextAlign.center,
          style: AppTextStyles.sousTitre,
        ),
      ),
    );
  }
}
