import 'package:shared_preferences/shared_preferences.dart';

/// Mémorise l'utilisateur connecté entre les ouvertures de l'application
/// via shared_preferences (cf. cahier des charges, section stockage).
class SessionService {
  SessionService._internal();
  static final SessionService instance = SessionService._internal();

  static const _cleUtilisateurId = 'utilisateur_id_connecte';

  Future<void> ouvrirSession(int utilisateurId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cleUtilisateurId, utilisateurId);
  }

  Future<int?> getUtilisateurConnecteId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cleUtilisateurId);
  }

  Future<void> fermerSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cleUtilisateurId);
  }
}
