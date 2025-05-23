import 'package:flutter/material.dart';
import 'worksheet_printer.dart';

class LearningHubScreen extends StatelessWidget {
  const LearningHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Hub')),
      body: Center(
        child: ElevatedButton(
          onPressed: printSampleWorksheet,
          child: const Text('Print Sample Worksheet'),
        ),
      ),
    );
  }
}
