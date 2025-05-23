import 'package:flutter/material.dart';

class ChoreBoardScreen extends StatelessWidget {
  const ChoreBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chore Board')),
      body: const Center(child: Text('Chores coming soon')),
    );
  }
}
