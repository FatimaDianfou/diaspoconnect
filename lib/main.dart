import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/login_screen.dart';
import 'screens/main_nav_screen.dart';
import 'services/session_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  runApp(const DiaspoConnectApp());
}

class DiaspoConnectApp extends StatelessWidget {
  const DiaspoConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiaspoConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const _EcranDemarrage(),
    );
  }
}

/// Vérifie si un utilisateur est déjà connecté (shared_preferences) pour
/// retrouver directement l'application principale, sinon affiche le login.
class _EcranDemarrage extends StatefulWidget {
  const _EcranDemarrage();

  @override
  State<_EcranDemarrage> createState() => _EcranDemarrageState();
}

class _EcranDemarrageState extends State<_EcranDemarrage> {
  int? _utilisateurId;
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _verifierSession();
  }

  Future<void> _verifierSession() async {
    final id = await SessionService.instance.getUtilisateurConnecteId();
    if (!mounted) return;
    setState(() {
      _utilisateurId = id;
      _chargement = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_utilisateurId != null) {
      return MainNavScreen(utilisateurId: _utilisateurId!);
    }
    return const LoginScreen();
  }
}
