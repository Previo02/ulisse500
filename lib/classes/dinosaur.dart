class Dinosaur {
  String id;
  String name;
  String image;
  String description;
  bool isLocked;
  Quiz quiz;

  Dinosaur({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.quiz,
    this.isLocked = true,
  });

  factory Dinosaur.fromJson(Map<String, dynamic> json) {
    return Dinosaur(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      quiz: Quiz.fromJson(json['quiz']),
    );
  }
}

class Quiz {
  String question;
  List<String> answers;
  int correctAnswerIndex;

  Quiz({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
      answers: List<String>.from(json['answers']),
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }
}
