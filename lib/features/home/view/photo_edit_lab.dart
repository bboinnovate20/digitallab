import 'package:flutter/material.dart';

class PhotoEditLab extends StatelessWidget {
  const PhotoEditLab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Editing Lab')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Photo Editing Lab\n\nHere users will be able to edit photos and remove backgrounds.\n(Placeholder screen)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
