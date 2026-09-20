import 'package:flutter/material.dart';

import '../services/db_helper.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import 'main_nav_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifiantCtrl = TextEditingController();
  final _motDePasseCtrl = TextEditingController();

  bool _motDePasseVisible = false;
  bool _enCours = false;
  String? _erreur;

  @override
  void dispose() {
    _identifiantCtrl.dispose();
    _motDePasseCtrl.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    setState(() => _erreur = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enCours = true);
    final utilisateur = await DbHelper.instance.getUtilisateurByIdentifiants(
      _identifiantCtrl.text.trim(),
      _motDePasseCtrl.text,
    );
    if (!mounted) return;
    setState(() => _enCours = false);

    if (utilisateur == null) {
      setState(() => _erreur = "Nom d'utilisateur ou mot de passe incorrect.");
      return;
    }

    await SessionService.instance.ouvrirSession(utilisateur.id!);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainNavScreen(utilisateurId: utilisateur.id!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.primaire,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.public, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DiaspoConnect',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaire,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Votre communauté partout',
                    style: AppTextStyles.sousTitre,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _identifiantCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Nom d'utilisateur",
                      hintText: 'ex: fatima.diallo',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? "Le nom d'utilisateur est requis"
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _motDePasseCtrl,
                    obscureText: !_motDePasseVisible,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _seConnecter(),
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_motDePasseVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _motDePasseVisible = !_motDePasseVisible),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Le mot de passe est requis'
                        : null,
                  ),
                  if (_erreur != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _erreur!,
                      style: const TextStyle(color: AppColors.erreur, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _enCours ? null : _seConnecter,
                    child: _enCours
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Se connecter'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaire,
                      side: const BorderSide(color: AppColors.primaire),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Créer un compte'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
