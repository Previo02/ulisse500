import 'package:flutter/material.dart';
import 'package:ulisse500/classes/dinosaur.dart';

class QuizPage extends StatefulWidget {
  final Dinosaur dinosaur;
  final VoidCallback onUnlock;

  const QuizPage({super.key, required this.dinosaur, required this.onUnlock});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz: ${widget.dinosaur.name}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Domanda del Quiz:"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onUnlock();
                Navigator.pop(context);
              },
              child: const Text("Risposta Corretta"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Risposta Sbagliata"),
            ),
          ],
        ),
      ),
    );
  }
}
