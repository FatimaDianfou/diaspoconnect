import 'package:flutter/material.dart';

import '../models/utilisateur.dart';
import '../services/db_helper.dart';
import '../services/session_service.dart';
import 'main_nav_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _identifiantCtrl = TextEditingController();
  final _paysCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _motDePasseCtrl = TextEditingController();

  bool _enCours = false;
  String? _erreur;

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _identifiantCtrl.dispose();
    _paysCtrl.dispose();
    _villeCtrl.dispose();
    _motDePasseCtrl.dispose();
    super.dispose();
  }

  Future<void> _creerCompte() async {
    setState(() => _erreur = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enCours = true);
    final existeDeja =
        await DbHelper.instance.emailExiste(_identifiantCtrl.text.trim());
    if (existeDeja) {
      setState(() {
        _enCours = false;
        _erreur = 'Ce nom d\'utilisateur est déjà utilisé.';
      });
      return;
    }

    final id = await DbHelper.instance.insertUtilisateur(Utilisateur(
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      email: _identifiantCtrl.text.trim(),
      motDePasse: _motDePasseCtrl.text,
      pays: _paysCtrl.text.trim(),
      ville: _villeCtrl.text.trim(),
    ));

    await SessionService.instance.ouvrirSession(id);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => MainNavScreen(utilisateurId: id)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _prenomCtrl,
                        decoration: const InputDecoration(labelText: 'Prénom'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _nomCtrl,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requis' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _identifiantCtrl,
                  decoration: const InputDecoration(
                    labelText: "Nom d'utilisateur",
                    hintText: 'ex: fatima.diallo',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requis' : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _paysCtrl,
                        decoration:
                            const InputDecoration(labelText: "Pays d'origine"),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _villeCtrl,
                        decoration:
                            const InputDecoration(labelText: "Ville d'accueil"),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requis' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _motDePasseCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  validator: (v) => (v == null || v.length < 4)
                      ? 'Au moins 4 caractères'
                      : null,
                ),
                if (_erreur != null) ...[
                  const SizedBox(height: 12),
                  Text(_erreur!,
                      style: const TextStyle(color: Colors.red, fontSize: 13)),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _enCours ? null : _creerCompte,
                  child: _enCours
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Créer mon compte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
