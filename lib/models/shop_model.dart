import 'package:flutter/material.dart';
import 'hero_model.dart';

class ShopModel extends ChangeNotifier {
  final HeroModel heroModel; // Reference to HeroModel for accessing gold

  ShopModel(this.heroModel);

  List<Map<String, dynamic>> characters = [
    {
      'name': 'Gon',
      'price': 100,
      'image': 'assets/images/gon.png',
    },
    {
      'name': 'Sukuna',
      'price': 150,
      'image': 'assets/images/sukuna.png',
    },
    {
      'name': 'Sukuna 4 Arms',
      'price': 120,
      'image': 'assets/images/sukuna2.png',
    },
    // Add more characters here
  ];

  List<String> unlockedCharacters = [];

  void purchaseCharacter(String characterName, int price) {
    if (heroModel.gold >= price && !unlockedCharacters.contains(characterName)) {
      heroModel.gold -= price;
      unlockedCharacters.add(characterName);
      notifyListeners();
      heroModel.notifyListeners(); // Update HeroModel’s listeners to reflect gold changes
    }
  }
}
