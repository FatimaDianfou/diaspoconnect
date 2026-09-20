import 'package:flutter/material.dart';

import '../../models/evenement.dart';
import '../../services/db_helper.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/event_card.dart';
import 'add_event_screen.dart';

class EvenementsScreen extends StatefulWidget {
  const EvenementsScreen({super.key});

  @override
  State<EvenementsScreen> createState() => _EvenementsScreenState();
}

class _EvenementsScreenState extends State<EvenementsScreen> {
  List<Evenement> _evenements = [];
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _chargement = true);
    final evenements = await DbHelper.instance.getAllEvenements();
    if (!mounted) return;
    setState(() {
      _evenements = evenements;
      _chargement = false;
    });
  }

  Future<void> _supprimer(Evenement e) async {
    await DbHelper.instance.deleteEvenement(e.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Événement supprimé.')),
    );
    _charger();
  }

  Future<void> _ouvrirFormulaireAjout() async {
    final utilisateurId = await SessionService.instance.getUtilisateurConnecteId();
    if (utilisateurId == null || !mounted) return;

    final cree = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddEventScreen(organisateurId: utilisateurId),
      ),
    );

    if (cree == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Événement ajouté avec succès.')),
      );
      _charger();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Événements'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.calendar_today_outlined),
          ),
        ],
      ),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
          : _evenements.isEmpty
              ? const _AucunEvenement()
              : RefreshIndicator(
                  onRefresh: _charger,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _evenements.length,
                    itemBuilder: (context, i) {
                      final e = _evenements[i];
                      return EventCard(
                        evenement: e,
                        onDelete: () => _supprimer(e),
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

class _AucunEvenement extends StatelessWidget {
  const _AucunEvenement();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          "Aucun événement pour le moment.\nSoyez le premier à en ajouter un !",
          textAlign: TextAlign.center,
          style: AppTextStyles.sousTitre,
        ),
      ),
    );
  }
}
