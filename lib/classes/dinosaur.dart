class Dinosaur {
  String id; 
  String name;
  String image;
  String description;
  bool isLocked;

  Dinosaur({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    this.isLocked = true,
  });

  factory Dinosaur.fromJson(Map<String, dynamic> json) {
    return Dinosaur(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
    );
  }
}
