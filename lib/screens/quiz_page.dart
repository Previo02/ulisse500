import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:ulisse500/classes/dinosaur.dart';

class QuizPage extends StatefulWidget {
  final VoidCallback onUnlock;
  final Dinosaur dinosaur;

  const QuizPage({super.key, required this.onUnlock, required this.dinosaur});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final String question = "Qual è il dinosauro più famoso?";
  final List<String> answers = [
    "Tyrannosaurus Rex",
    "Stegosaurus",
    "Velociraptor",
    "Brachiosaurus"
  ];
  final int correctAnswerIndex = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(int index) {
    if (index == correctAnswerIndex) {
      _showResultPopup(true);
    } else {
      _showResultPopup(false);
    }
  }

  void _showResultPopup(bool isCorrect) {
    if (isCorrect) {
      _confettiController.play();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Risposta Corretta!' : 'Risposta Errata!'),
          content: isCorrect
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Complimenti, hai risposto correttamente!'),
                    SizedBox(height: 20),
                    Icon(Icons.emoji_events, color: Colors.amber, size: 80),
                    SizedBox(height: 20),
                    Text('Hai sbloccato il dinosauro!'),
                  ],
                )
              : const Text(
                  'Purtroppo hai sbagliato. Riprova la prossima volta!'),
          actions: [
            TextButton(
              child: const Text('Torna alla Home'),
              onPressed: () {
                if (isCorrect) {
                  widget.onUnlock();
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Dinosauri'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  question,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(answers.length, (index) {
                      return _buildAnswerButton(index);
                    }),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.orange
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(int index) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        padding: const EdgeInsets.all(16),
      ),
      child: Text(
        answers[index],
        textAlign: TextAlign.center,
      ),
    );
  }
}
