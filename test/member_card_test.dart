import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diaspoconnect/models/utilisateur.dart';
import 'package:diaspoconnect/widgets/member_card.dart';

void main() {
  const membre = Utilisateur(
    id: 1,
    nom: 'Diallo',
    prenom: 'Fatima',
    email: 'fatima.diallo',
    motDePasse: 'x',
    pays: 'Guinée',
    ville: 'New York',
  );

  testWidgets('affiche le nom complet, la ville et le pays du membre',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MemberCard(membre: membre, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Fatima Diallo'), findsOneWidget);
    expect(find.text('New York'), findsOneWidget);
    expect(find.text('Guinée'), findsOneWidget);
  });

  testWidgets('déclenche onTap au tap sur la carte',
      (WidgetTester tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MemberCard(membre: membre, onTap: () => tapped = true),
        ),
      ),
    );

    await tester.tap(find.byType(MemberCard));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
