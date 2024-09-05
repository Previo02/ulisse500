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
}
