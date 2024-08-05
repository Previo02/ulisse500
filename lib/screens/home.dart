import 'package:flutter/material.dart';
import 'package:ulisse500/provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ulisse500"),
        actions: [
          InkWell(
              child: const Icon(Icons.logout),
              onTap: () => AuthProvider().signOut()),
        ],
      ),
      body: const Center(
        child: Text("Home Page"),
      ),
    );
  }
}
