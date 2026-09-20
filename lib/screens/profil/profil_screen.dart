import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/utilisateur.dart';
import '../../services/db_helper.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';
import '../login_screen.dart';
import 'edit_profil_screen.dart';

class ProfilScreen extends StatefulWidget {
  final int utilisateurId;

  const ProfilScreen({super.key, required this.utilisateurId});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Utilisateur? _utilisateur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final u = await DbHelper.instance.getUtilisateurById(widget.utilisateurId);
    if (!mounted) return;
    setState(() => _utilisateur = u);
  }

  Future<void> _modifier() async {
    final u = _utilisateur;
    if (u == null) return;
    final miseAJour = await Navigator.of(context).push<Utilisateur>(
      MaterialPageRoute(builder: (_) => EditProfilScreen(utilisateur: u)),
    );
    if (miseAJour != null) setState(() => _utilisateur = miseAJour);
  }

  Future<void> _seDeconnecter() async {
    await SessionService.instance.fermerSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = _utilisateur;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: u == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  width: double.infinity,
                  color: AppColors.primaire,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.accent,
                        backgroundImage: (u.photo != null && u.photo!.isNotEmpty)
                            ? FileImage(File(u.photo!))
                            : null,
                        child: (u.photo == null || u.photo!.isEmpty)
                            ? Text(
                                u.initiales,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        u.nomComplet,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        u.ville,
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
                      _ligneInfo("Pays d'origine", u.pays),
                      _ligneInfo('Ville', u.ville),
                      _ligneInfo("Nom d'utilisateur", u.email),
                      if (u.bio != null && u.bio!.isNotEmpty)
                        _ligneInfo('Bio', u.bio!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _modifier,
                        child: const Text('Modifier mon profil'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _seDeconnecter,
                        child: const Text('Se déconnecter'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _ligneInfo(String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.sousTitre),
          const SizedBox(height: 2),
          Text(valeur, style: AppTextStyles.corps),
        ],
      ),
    );
  }
}
