import 'package:flutter/material.dart';
import 'hero_model.dart';
import 'character_model.dart';

class ShopModel extends ChangeNotifier {
  final HeroModel heroModel; // Reference to HeroModel for accessing gold

  ShopModel(this.heroModel);

  List<Character> characters = [
    Character(id: "1", name: "Gon", price: 100, image: 'assets/images/gon.png'),
    Character(
        id: "2", name: "Sukuna", price: 150, image: 'assets/images/sukuna.png'),
    Character(
        id: "3",
        name: "Sukuna 4 Arms",
        price: 200,
        image: 'assets/images/sukuna2.png'),
  ];

  List<String> unlockedCharacters = [];


  // void attemptPurchase(Character character) {
  //   if (heroModel.gold >= character.price && !character.isPurchased) {
  //     heroModel.gold -= character.price; // Deduct the gold
  //     character.isPurchased = true; // Mark character as purchased
  //     unlockedCharacters.add(character.name); // Add to unlocked list
  //
  //     notifyListeners(); // Update UI for shop
  //     heroModel.notifyListeners(); // Update HeroModel’s UI (gold changes)
  //   }
  // }

  void attemptPurchase(Character character) {
    // Ensure sufficient gold and check if character is already purchased
    if (heroModel.canAfford(character.price) && !character.isPurchased) {

      // Locate the character in the list by id and update its purchase status
      int index = characters.indexWhere((c) => c.id == character.id);

      heroModel.purchaseCharacter(
          characters[index]); // Add to hero's owned characters

      characters[index].isPurchased = true;

      notifyListeners(); // Update shop UI
      heroModel.notifyListeners(); // Update hero's gold UI
    }
  }

// void reorderCharacters() {
//   characters.sort((a, b) {
//     if (a.isPurchased && !b.isPurchased) return 1;
//     if (!a.isPurchased && b.isPurchased) return -1;
//     return 0;
//   });
// }

// Show larger image preview with buy option

// void purchaseCharacter(String characterImage, int price) {
//   // Check if the hero has enough gold and the character is not already unlocked
//   if (heroModel.gold >= price && !unlockedCharacters.contains(characterImage)) {
//     // Deduct the price from hero's gold
//     heroModel.gold -= price;
//
//     // Add character to unlocked characters
//     unlockedCharacters.add(characterImage);
//
//     // Find the index of the character in the list
//     final characterIndex = characters.indexWhere((character) => character['image'] == characterImage);
//
//     if (characterIndex != -1) {
//       // Mark the character as purchased
//       characters[characterIndex].isPurchased = true;
//
//       // Move the purchased character to the end of the list
//       final purchasedCharacter = characters.removeAt(characterIndex);
//       characters.add(purchasedCharacter);
//     }
//
//     // Notify listeners to update the shop UI and hero's gold display
//     notifyListeners();
//     heroModel.notifyListeners(); // Ensure HeroModel updates the gold in the UI
//   }
// }
}
