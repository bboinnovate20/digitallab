import 'dart:io';

import 'package:digitallab/core/ui/primary_btn.dart';
import 'package:digitallab/features/home/view_model/photolab_view_model.dart';
import 'package:flutter/material.dart';

class PassportLab extends StatefulWidget {
  const PassportLab({super.key});

  @override
  State<PassportLab> createState() => _PassportLabState();
}

class _PassportLabState extends State<PassportLab> {
  final PhotolabViewModel _photolabModel = PhotolabViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _photolabModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passport Photo Lab ')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Passport Photo Lab', textAlign: TextAlign.center),
                    Text(
                      'Here users will crop photos to passport sizes and prepare print layouts.\n(Placeholder screen)',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _photolabModel,
                builder: (context, child) {
                  final file = _photolabModel.currentImage;
                  if (file == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Image.file(
                      file.file,
                      width: 260,
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: AnimatedBuilder(
                      animation: _photolabModel,
                      builder: (context, child) {
                        return PrimaryButton(
                          label: _photolabModel.currentImage == null
                              ? 'Upload Passport'
                              : 'Replace Passport',
                          onPressed: _photolabModel.isLoading
                              ? null
                              : _photolabModel.pickImage,
                          leading: const Icon(Icons.upload_file),
                          loading: _photolabModel.isLoading,
                        );
                      },
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _photolabModel,
                    builder: (context, child) {
                      if (_photolabModel.currentImage == null)
                        return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: PrimaryButton(
                          label: 'Process / Upload',
                          onPressed: _photolabModel.isLoading ? null : () => {},
                          leading: const Icon(Icons.cloud_upload),
                          loading: _photolabModel.isLoading,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
