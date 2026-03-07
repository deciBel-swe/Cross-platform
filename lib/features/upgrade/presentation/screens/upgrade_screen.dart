import 'package:flutter/material.dart';

/// Empty Upgrade page – placeholder.
class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Upgrade', style: TextStyle(fontSize: 24))),
    );
  }
}
