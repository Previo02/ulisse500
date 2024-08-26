import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulisse500/classes/dinosaur.dart';
import 'package:ulisse500/provider/private_provider.dart';
import 'package:ulisse500/screens/detail_page.dart';
import 'package:ulisse500/screens/login.dart';

class HomePage extends StatelessWidget {
  final List<Dinosaur> dinosaurs = [
    Dinosaur(
      name: 'Tyrannosaurus Rex',
      image: 'asset/images/trex.png',
      description: 'Il Tyrannosaurus Rex è uno dei dinosauri più famosi...',
    ),
    Dinosaur(
      name: 'Triceratops',
      image: 'asset/images/triceratops.png',
      description: 'Il Triceratops è conosciuto per le sue tre corna...',
    ),
  ];

  HomePage({super.key});

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
            onTap: () async {
              await Provider.of<PrivateProvider>(context, listen: false)
                  .signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: dinosaurs.length,
        itemBuilder: (context, index) {
          final dinosaur = dinosaurs[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DinosaurDetailPage(dinosaur: dinosaur),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        dinosaur.image,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dinosaur.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
