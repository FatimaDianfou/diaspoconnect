import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/evenement.dart';
import '../../services/db_helper.dart';

class AddEventScreen extends StatefulWidget {
  final int organisateurId;

  const AddEventScreen({super.key, required this.organisateurId});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreCtrl = TextEditingController();
  final _lieuCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  DateTime? _date;
  String _categorie = 'Culture';
  bool _enCours = false;

  static const _categories = ['Culture', 'Musique', 'Réseautage', 'Sport', 'Autre'];

  @override
  void dispose() {
    _titreCtrl.dispose();
    _lieuCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) setState(() => _date = date);
  }

  Future<void> _publier() async {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir une date.')),
      );
      return;
    }

    setState(() => _enCours = true);
    await DbHelper.instance.insertEvenement(Evenement(
      titre: _titreCtrl.text.trim(),
      date: _date!,
      lieu: _lieuCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      organisateurId: widget.organisateurId,
      categorie: _categorie,
    ));

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvel événement'),
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
              InkWell(
                onTap: _choisirDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date'),
                  child: Text(
                    _date == null
                        ? 'Choisir une date'
                        : DateFormat('d MMMM yyyy', 'fr_FR').format(_date!),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _lieuCtrl,
                decoration: const InputDecoration(labelText: 'Lieu'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Le lieu est requis' : null,
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
                controller: _descriptionCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description (optionnel)',
                  alignLabelWithHint: true,
                ),
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
