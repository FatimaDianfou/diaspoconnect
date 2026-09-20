import 'package:flutter/material.dart';

import '../../models/annonce.dart';
import '../../services/db_helper.dart';

class AddAnnonceScreen extends StatefulWidget {
  final int auteurId;

  const AddAnnonceScreen({super.key, required this.auteurId});

  @override
  State<AddAnnonceScreen> createState() => _AddAnnonceScreenState();
}

class _AddAnnonceScreenState extends State<AddAnnonceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreCtrl = TextEditingController();
  final _contenuCtrl = TextEditingController();
  String _categorie = 'Entraide';
  bool _enCours = false;

  static const _categories = ['Entraide', 'Emploi', 'Logement', 'Éducation', 'Services'];

  @override
  void dispose() {
    _titreCtrl.dispose();
    _contenuCtrl.dispose();
    super.dispose();
  }

  Future<void> _publier() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enCours = true);
    await DbHelper.instance.insertAnnonce(Annonce(
      titre: _titreCtrl.text.trim(),
      contenu: _contenuCtrl.text.trim(),
      auteurId: widget.auteurId,
      datePublication: DateTime.now(),
      categorie: _categorie,
    ));

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle annonce'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titreCtrl,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Le titre est requis' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _categorie,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categorie = v ?? _categorie),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _contenuCtrl,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Contenu',
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Le contenu est requis' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _enCours ? null : _publier,
                child: _enCours
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Publier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
