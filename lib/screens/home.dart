import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ulisse500"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              child: const Icon(Icons.logout),
              onTap: () => Provider.of<AuthProvider>(context, listen: false).signOut()),
        ),
      ),
      body: const Center(
        child: Text("Home Page"),
      ),
    );
  }
}
