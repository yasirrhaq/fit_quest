class Character {
  final String id;
  final String name;
  final int price;
  final String image;
  bool isPurchased;

  Character({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.isPurchased = false,
  });
}
