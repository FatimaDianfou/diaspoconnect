import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diaspoconnect/screens/login_screen.dart';

void main() {
  testWidgets('affiche des erreurs de validation si le formulaire est vide',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.text('Se connecter'));
    await tester.pump();

    expect(find.text("Le nom d'utilisateur est requis"), findsOneWidget);
    expect(find.text('Le mot de passe est requis'), findsOneWidget);
  });

  testWidgets('le mot de passe est masqué par défaut (obscureText)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    final champMotDePasse = tester.widget<TextField>(
      find.byType(TextField).at(1),
    );

    expect(champMotDePasse.obscureText, isTrue);
  });
}
