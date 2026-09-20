import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/utilisateur.dart';
import '../../services/db_helper.dart';
import '../../theme/app_theme.dart';

class EditProfilScreen extends StatefulWidget {
  final Utilisateur utilisateur;

  const EditProfilScreen({super.key, required this.utilisateur});

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _prenomCtrl;
  late final TextEditingController _nomCtrl;
  late final TextEditingController _paysCtrl;
  late final TextEditingController _villeCtrl;
  late final TextEditingController _bioCtrl;
  String? _photoPath;
  bool _enCours = false;

  @override
  void initState() {
    super.initState();
    final u = widget.utilisateur;
    _prenomCtrl = TextEditingController(text: u.prenom);
    _nomCtrl = TextEditingController(text: u.nom);
    _paysCtrl = TextEditingController(text: u.pays);
    _villeCtrl = TextEditingController(text: u.ville);
    _bioCtrl = TextEditingController(text: u.bio ?? '');
    _photoPath = u.photo;
  }

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _paysCtrl.dispose();
    _villeCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );
    if (image != null) setState(() => _photoPath = image.path);
  }

  Future<void> _sauvegarder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enCours = true);
    final miseAJour = widget.utilisateur.copyWith(
      prenom: _prenomCtrl.text.trim(),
      nom: _nomCtrl.text.trim(),
      pays: _paysCtrl.text.trim(),
      ville: _villeCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      photo: _photoPath,
    );
    await DbHelper.instance.updateUtilisateur(miseAJour);

    if (!mounted) return;
    Navigator.of(context).pop(miseAJour);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _choisirPhoto,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.fondClair,
                        backgroundImage: _photoPath != null
                            ? FileImage(File(_photoPath!))
                            : null,
                        child: _photoPath == null
                            ? Text(
                                widget.utilisateur.initiales,
                                style: const TextStyle(
                                    color: AppColors.primaire,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                      decoration: const InputDecoration(labelText: 'Ville'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Requis' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _bioCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio (optionnel)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _enCours ? null : _sauvegarder,
                child: _enCours
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Sauvegarder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
