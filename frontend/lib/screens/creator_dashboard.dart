import 'package:flutter/material.dart';

class CreatorDashboard extends StatelessWidget {
  const CreatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Creator Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to Creator World", style: TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            // यहाँ आगे चलकर आपके वो 4 ऑप्शन्स आएंगे
            ElevatedButton(onPressed: () {}, child: const Text("Tool 1")),
            ElevatedButton(onPressed: () {}, child: const Text("Tool 2")),
          ],
        ),
      ),
    );
  }
}
