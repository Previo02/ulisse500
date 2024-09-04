class Dinosaur {
  final String name;
  final String image;
  final String description;
  bool isLocked;

  Dinosaur({
    required this.name,
    required this.image,
    required this.description,
    this.isLocked = true,
  });
}
