class Museum {
  String id;
  String name;
  String image;
  String description;
  String indirizzo;
  String curiosity;
  String category;
  Quiz quiz;
  bool isLocked;

  Museum({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.indirizzo,
    required this.curiosity,
    required this.category,
    required this.quiz,
    this.isLocked = true,
  });

  factory Museum.fromJson(Map<String, dynamic> json) {
    return Museum(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      indirizzo: json['indirizzo'],
      curiosity: json['curiosity'],
      category: json['category'],
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
