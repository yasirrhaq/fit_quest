import 'package:flutter/material.dart';
import 'hero_model.dart';
import 'character_model.dart';

List<CharacterModel> initialCharacters = [
  CharacterModel(id: "1", name: "Gon", price: 100, image: 'assets/images/gon.png'),
  CharacterModel(
      id: "2", name: "Sukuna", price: 150, image: 'assets/images/sukuna.png'),
  CharacterModel(
      id: "3",
      name: "Sukuna 4 Arms",
      price: 200,
      image: 'assets/images/sukuna2.png'),
  CharacterModel(id: "4", name: "Asta", image: 'assets/images/asta-thiccsnail.jpg', price: 99999),
];

class ShopModel extends ChangeNotifier {
  HeroModel heroModel;
  List<CharacterModel> characters;

  ShopModel(this.heroModel) : characters = initialCharacters;

  void updateHeroModel(HeroModel newHeroModel) {
    heroModel = newHeroModel;
    notifyListeners(); // Notify listeners if needed, e.g., if the UI depends on heroModel changes
  }

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

  void attemptPurchase(CharacterModel character) {
    // Check if the hero can afford the character and the character is not already purchased
    if (heroModel.canAfford(character.price) && !character.isPurchased) {
      // Deduct gold and add character to hero's owned characters
      heroModel.purchaseCharacter(character);

      // Update the character's purchase status
      character.purchase(); // This will notify listeners specifically for this character

      // Notify listeners to update the hero's gold display
      heroModel.notifyListeners();

      print("After purchase: ${character.name} isPurchased = ${character.isPurchased}");
    } else if (!heroModel.canAfford(character.price)) {
      print("Not enough gold to purchase ${character.name}.");
    } else {
      print("${character.name} has already been purchased.");
    }
  }

  void _showCharacterPreview(BuildContext context, ShopModel shopModel, CharacterModel character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(character.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(character.image, height: 150, width: 150),
              SizedBox(height: 16),
              Text('Price: ${character.price} gold'),
              SizedBox(height: 8),
              Text(
                "Are you sure you want to buy ${character.name}?",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close preview dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close preview dialog
                _showPurchaseConfirmationDialog(context, shopModel, character); // Show confirmation dialog
              },
              child: const Text('Proceed to Buy'),
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseConfirmationDialog(BuildContext context, ShopModel shopModel, CharacterModel character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Purchase'),
          content: Text('Do you want to purchase ${character.name} for ${character.price} gold?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close confirmation dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                shopModel.attemptPurchase(character);
                Navigator.of(context).pop(); // Close confirmation dialog
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
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
