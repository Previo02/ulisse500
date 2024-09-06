import 'package:easy_quiz_game/easy_quiz_game.dart';
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
  final List<QuizCategory> data = [
    QuizCategory(
      name: 'Dinosauri',
      description: 'Questo quiz riguarda i dinosauri',
      iconImage: 'assets/images/trex.png',
      difficulty: QuizDifficulty.beginner,
      quizzes: [
        Quiz(
          question: 'Qual è il dinosauro più famoso?',
          options: ['Tyrannosaurus Rex', 'Stegosaurus', 'Velociraptor'],
          correctIndex: 0,
          hint: 'È uno dei predatori più grandi della storia.',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.medium,
        ),
        Quiz(
          question: 'Quale dinosauro aveva tre corna?',
          options: ['Triceratops', 'Brachiosaurus', 'Spinosaurus'],
          correctIndex: 0,
          hint: 'Ha tre corna sul muso.',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.medium,
        ),
        Quiz(
          question: 'Quale dinosauro era noto per la sua velocità?',
          options: ['Velociraptor', 'Ankylosaurus', 'Allosaurus'],
          correctIndex: 0,
          hint: 'Un cacciatore piccolo ma molto rapido.',
          questionType: QuizQuestionType.text,
          difficulty: QuizDifficulty.medium,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getGameWidget(context),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedStandalone,
        tooltip: 'Launch standalone',
        child: const Icon(Icons.launch),
      ),
    );
  }

  void onPressedStandalone() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(body: getGameWidget(context)),
      ),
    );
  }

  Widget getGameWidget(BuildContext context) {
    return EasyQuizGameApp(
      quizCategories: data,
      primaryColor: Colors.orange.shade300,
      menuLogoPath: 'assets/images/trex.png',
      buttonPath: 'assets/images/button.png',
      labelPath: 'assets/images/trex.png',
      bgImagePath: 'assets/images/background.jpg',
      gradient: LinearGradient(
        stops: const [0, 1],
        begin: const Alignment(1, -1),
        end: const Alignment(0, 1),
        colors: [Theme.of(context).primaryColor, const Color(0xff753bc6)],
      ),
      secondaryColor: const Color(0xff753bc6),
    );
  }
}
