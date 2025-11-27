import 'package:flutter/material.dart';

class PassportLab extends StatelessWidget {
  const PassportLab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passport Photo Lab')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Passport Photo Lab\n\nHere users will crop photos to passport sizes and prepare print layouts.\n(Placeholder screen)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
