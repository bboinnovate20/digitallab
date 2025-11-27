import 'dart:io';

import 'package:digitallab/core/ui/primary_btn.dart';
import 'package:digitallab/features/home/view_model/photolab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PassportLab extends StatefulWidget {
  const PassportLab({super.key});

  @override
  State<PassportLab> createState() => _PassportLabState();
}

class _PassportLabState extends State<PassportLab> {
  final PhotolabViewModel _photolabModel = PhotolabViewModel();

  File? _imageFile;
  final bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passport Photo Lab')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Passport Photo Lab\n\nHere users will crop photos to passport sizes and prepare print layouts.\n(Placeholder screen)',
                  textAlign: TextAlign.center,
                ),
              ),
              if (_imageFile != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Image.file(
                    _imageFile!,
                    width: 260,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: PrimaryButton(
                  label: _imageFile == null
                      ? 'Upload Passport'
                      : 'Replace Passport',
                  onPressed: _loading ? null : _photolabModel.pickImage(),
                  leading: const Icon(Icons.upload_file),
                  loading: _loading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
