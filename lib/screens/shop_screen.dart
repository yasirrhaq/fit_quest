import 'package:fit_quest/models/character_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shop_model.dart';
import '../models/hero_model.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shopModel = Provider.of<ShopModel>(context);
    final heroModel = Provider.of<HeroModel>(context);

    return Scaffold(
      body: Column(
        children: [
          // Gold display at the top of the body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/gold.png', // Path to your gold icon
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 8),
                Text(
                  '${heroModel.gold}', // Display the gold amount
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          // Character list below the gold display
          Expanded(
            child: ListView.builder(
              itemCount: shopModel.characters.length,
              itemBuilder: (context, index) {
                final character = shopModel.characters[index];
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      // _showCharacterPreview(context, shopModel, character);
                    },
                    child: Image.asset(
                      character.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(character.name),
                  subtitle: Row(
                    children: [
                      Text("${character.price}"),
                      SizedBox(width: 4),
                      Image.asset(
                        'assets/images/gold.png', // Path to your gold icon
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: character.isPurchased
                        ? null
                        : () {
                            _showCharacterPreview(
                                context, shopModel, character);
                          },
                    child: Text(character.isPurchased ? "Purchased" : "Buy"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }

  void _showCharacterPreview(
      BuildContext context, ShopModel shopModel, CharacterModel character) {
    final heroModel = shopModel.heroModel; // Access HeroModel through ShopModel

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
              if (heroModel.gold < character.price)
                Text(
                  "You don't have enough gold to purchase ${character.name}.",
                  style: TextStyle(color: Colors.red),
                )
              else
                Text("Are you sure you want to buy ${character.name}?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            if (heroModel.gold >=
                character
                    .price) // Show "Proceed to Buy" only if user has enough gold
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close preview dialog
                  shopModel.attemptPurchase(character);
                },
                child: const Text('Proceed to Buy'),
              )
            else
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close preview dialog
                  _showInsufficientFundsDialog(
                      context); // Show insufficient funds warning
                },
                child: const Text('Get More Gold'),
              ),
          ],
        );
      },
    );
  }

  void _showPurchaseConfirmationDialog(
      BuildContext context, ShopModel shopModel, CharacterModel character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Purchase'),
          content: Text(
              'Do you want to purchase ${character.name} for ${character.price} gold?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

  void _showInsufficientFundsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insufficient Gold'),
          content: const Text(
              "You don't have enough gold to complete this purchase. Earn more gold to proceed."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  // Assuming '/home' is the named route for the home screen
                  (Route<dynamic> route) =>
                      false, // Remove all routes until home
                );
              },
              child: const Text('Go Do Quest!'),
            ),
          ],
        );
      },
    );
  }
}
