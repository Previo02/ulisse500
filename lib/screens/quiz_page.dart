import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:ulisse500/classes/museum.dart';
import 'package:ulisse500/provider/element_provider.dart';

class QuizPage extends StatefulWidget {
  final VoidCallback onUnlock;
  final Museum museum;
  final MuseumService museumService;

  const QuizPage(
      {super.key,
      required this.onUnlock,
      required this.museum,
      required this.museumService});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(int index) {
    if (index == widget.museum.quiz.correctAnswerIndex) {
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
          title: Text(
            isCorrect ? 'Risposta Corretta!' : 'Risposta Errata!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isCorrect ? Colors.green : Colors.red,
            ),
          ),
          content: isCorrect
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Complimenti, hai risposto correttamente!',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Icon(Icons.emoji_events, color: Colors.amber, size: 80),
                    SizedBox(height: 20),
                    Text(
                      'Hai sbloccato il museo!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
              : const Text(
                  'Purtroppo hai sbagliato. Riprova la prossima volta!',
                  style: TextStyle(fontSize: 18),
                ),
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
        title: const Text('Quiz'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.museum.quiz.question,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.builder(
                    itemCount: widget.museum.quiz.answers.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return _buildAnswerButton(index);
                    },
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
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(int index) {
    final List<Color> buttonColors = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.orangeAccent,
    ];

    return ElevatedButton(
      onPressed: () => _checkAnswer(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColors[index],
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Text(
        widget.museum.quiz.answers[index],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
