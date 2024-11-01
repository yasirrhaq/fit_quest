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
      appBar: AppBar(title: Text("Character Shop")),
      body: ListView.builder(
        itemCount: shopModel.characters.length,
        itemBuilder: (context, index) {
          final character = shopModel.characters[index];
          return ListTile(
            leading: GestureDetector(
              onTap: () {
                _showCharacterPreview(
                  context,
                  character,
                  character.isPurchased,
                  shopModel,
                );
              },
              child: Image.asset(
                character.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(character.name),
            subtitle: Text("Price: ${character.price} gold"),
            trailing: ElevatedButton(
              onPressed: character.isPurchased
                  ? null
                  : () {
                      _showPurchaseDialog(context, shopModel, character);
                    },
              child: Text(character.isPurchased ? "Purchased" : "Buy"),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Gold: ${heroModel.gold}", style: TextStyle(fontSize: 18)),
      ),
    );
  }

  void _showCharacterPreview(
    BuildContext context,
    Character character, // Use Character object directly
    bool isUnlocked,
    ShopModel shop,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              isUnlocked ? '${character.name} (Owned)' : 'Character Preview'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(character.image, height: 150, width: 150),
              if (!isUnlocked) Text('Price: ${character.price} gold'),
            ],
          ),
          actions: [
            if (!isUnlocked)
              TextButton(
                child: const Text('Buy'),
                onPressed: () {
                  shop.attemptPurchase(
                      character); // Pass Character object directly
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseDialog(
    BuildContext context,
    ShopModel shopModel,
    Character character, // Use Character object directly
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Purchase'),
          content: Text(
            'Are you sure you want to buy ${character.name} for ${character.price} gold?',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                shopModel.attemptPurchase(
                    character); // Pass Character object directly
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
