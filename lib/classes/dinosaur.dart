class Dinosaur {
  String id;
  String name;
  String image;
  String description;
  String period;
  String weight;
  String curiosity;
  Quiz quiz;
  bool isLocked;

  Dinosaur({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.period,
    required this.weight,
    required this.curiosity,
    required this.quiz,
    this.isLocked = true,
  });

  factory Dinosaur.fromJson(Map<String, dynamic> json) {
    return Dinosaur(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      period: json['period'],
      weight: json['weight'],
      curiosity: json['curiosity'],
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
