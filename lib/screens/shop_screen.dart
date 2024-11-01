import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hero_model.dart';
import '../models/shop_model.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shopModel = Provider.of<ShopModel>(context, listen: false);
    final heroModel = Provider.of<HeroModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Shop'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/gold.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  '${heroModel.gold}',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: shopModel.characters.length,
        itemBuilder: (context, index) {
          final character = shopModel.characters[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: GestureDetector(
                onTap: () => _showCharacterDialog(
                    context, character, shopModel, heroModel),
                child: Image.asset(
                  character['image'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(character['name']),
              subtitle: Text('Price: ${character['price']} Gold'),
              trailing: ElevatedButton(
                onPressed: () {
                  _showPurchaseConfirmation(
                      context, character, shopModel, heroModel);
                },
                child: const Text('Buy'),
              ),
            ),
          );
        },
      ),
    );
  }

  // Show character pop-up with larger image and "Buy" button
  void _showCharacterDialog(
      BuildContext context,
      Map<String, dynamic> character,
      ShopModel shopModel,
      HeroModel heroModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(character['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(character['image'], height: 100, width: 100),
              const SizedBox(height: 20),
              Text('Price: ${character['price']} Gold'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close image dialog
                  _showPurchaseConfirmation(
                      context, character, shopModel, heroModel);
                },
                child: const Text('Buy'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show confirmation dialog before purchase
  void _showPurchaseConfirmation(
      BuildContext context,
      Map<String, dynamic> character,
      ShopModel shopModel,
      HeroModel heroModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Purchase"),
          content: Text(
              "Are you sure you want to buy ${character['name']} for ${character['price']} Gold?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (heroModel.gold >= character['price']) {
                  heroModel.purchaseCharacter(
                      character['image'], character['price']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${character['name']} purchased!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not enough gold!')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
