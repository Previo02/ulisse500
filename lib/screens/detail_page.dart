import 'package:flutter/material.dart';
import 'package:ulisse500/classes/dinosaur.dart';
import 'package:ulisse500/screens/ar_view.dart';

class DinosaurDetailPage extends StatelessWidget {
  final Dinosaur dinosaur;

  const DinosaurDetailPage({super.key, required this.dinosaur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dinosaur.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(dinosaur.imageUrl),
            const SizedBox(height: 16.0),
            Text(
              dinosaur.description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ARViewPage(dinosaur: dinosaur),
                    ),
                  );
                },
                child: const Text('Mostra in AR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
