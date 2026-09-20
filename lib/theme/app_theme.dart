import 'package:flutter/material.dart';

/// Palette et typographie définies dans le dossier de conception visuelle
/// DiaspoConnect (Semaine 5 — Conception).
class AppColors {
  AppColors._();

  static const Color primaire = Color(0xFF1A3A5C);
  static const Color accent = Color(0xFFF4A318);
  static const Color fondClair = Color(0xFFE8F4FD);
  static const Color fondPage = Color(0xFFF8F9FA);
  static const Color succes = Color(0xFF27AE60);
  static const Color erreur = Color(0xFFE74C3C);
  static const Color texteSecondaire = Color(0xFF7F8C8D);
  static const Color texteCorps = Color(0xFF2C3E50);
}

/// Tailles de police : la conception visuelle propose une hiérarchie allant
/// jusqu'à 8sp, mais les exigences non fonctionnelles du cahier des charges
/// imposent un minimum de 12sp pour toute lecture confortable sur mobile.
/// On applique donc la hiérarchie relative en remontant les paliers les plus
/// bas à ce plancher d'accessibilité.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle appBarTitre = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle titreCarte = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaire,
  );

  static const TextStyle sousTitre = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.texteSecondaire,
  );

  static const TextStyle corps = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.texteCorps,
  );

  static const TextStyle badge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.primaire,
  );

  static const TextStyle metadonnee = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.texteSecondaire,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaire,
        primary: AppColors.primaire,
        secondary: AppColors.accent,
        error: AppColors.erreur,
      ),
      scaffoldBackgroundColor: AppColors.fondPage,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaire,
        foregroundColor: Colors.white,
        centerTitle: false,
        titleTextStyle: AppTextStyles.appBarTitre,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaire,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          foregroundColor: AppColors.erreur,
          side: const BorderSide(color: AppColors.erreur),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaire),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFDDE3E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFDDE3E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.primaire, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.erreur),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE3E8EC)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaire,
        unselectedItemColor: AppColors.texteSecondaire,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
