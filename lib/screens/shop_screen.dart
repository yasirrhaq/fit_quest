import 'package:fit_quest/models/asset_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shop_model.dart';
import '../models/hero_model.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shopModel = Provider.of<ShopModel>(context);
    final heroModel = Provider.of<HeroModel>(context);

    final characterAssets =
    initialAssets.where((asset) => asset.category == "Character").toList();
    final backgroundAssets =
    initialAssets.where((asset) => asset.category == "Background").toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            // Title and Gold Display Row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Character Shop",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/gold.png',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 6),
                        Consumer<HeroModel>(
                          builder: (context, hero, child) {
                            return Text(
                              '${hero.gold}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tabs for Characters and Backgrounds
            TabBar(
              tabs: [
                Tab(text: "Characters"),
                Tab(text: "Backgrounds"),
              ],
              labelColor: Colors.purple,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.purple,
            ),
            // TabBarView with Content
            Expanded(
              child: TabBarView(
                children: [
                  _buildAssetGrid(characterAssets, context, shopModel),
                  _buildAssetGrid(backgroundAssets, context, shopModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a grid for each asset category
  Widget _buildAssetGrid(List<AssetModel> assets, BuildContext context, ShopModel shopModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        itemCount: assets.length,
        itemBuilder: (context, index) {
          final asset = assets[index];
          return _buildAssetCard(context, asset, shopModel);
        },
      ),
    );
  }

  // Helper method to build a card for each asset
  Widget _buildAssetCard(BuildContext context, AssetModel asset, ShopModel shopModel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              asset.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              asset.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${asset.price}"),
                SizedBox(width: 4),
                Image.asset(
                  'assets/images/gold.png',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: asset.isPurchased
                  ? null // Disable button if already purchased
                  : () {
                _showAssetPreview(context, shopModel, asset);
              },
              child: Text(asset.isPurchased ? "Purchased" : "Buy"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAssetPreview(BuildContext context, ShopModel shopModel,
      AssetModel asset) {
    final heroModel = shopModel.heroModel; // Access HeroModel through ShopModel

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(asset.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(asset.image, height: 150, width: 150),
              SizedBox(height: 16),
              Text('Price: ${asset.price} gold'),
              SizedBox(height: 8),
              if (heroModel.gold < asset.price)
                Text(
                  "You don't have enough gold to purchase ${asset.name}.",
                  style: TextStyle(color: Colors.red),
                )
              else
                Text("Are you sure you want to buy ${asset.name}?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            if (heroModel.gold >=
                asset
                    .price) // Show "Proceed to Buy" if enough gold
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  shopModel.attemptPurchase(asset);
                },
                child: const Text('Proceed to Buy'),
              )
            else
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showInsufficientFundsDialog(
                      context); // Show insufficient gold warning
                },
                child: const Text('Get More Gold'),
              ),
          ],
        );
      },
    );
  }

  void _showPurchaseConfirmationDialog(BuildContext context,
      ShopModel shopModel, AssetModel asset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Purchase'),
          content: Text(
              'Do you want to purchase ${asset.name} for ${asset.price} gold?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                shopModel.attemptPurchase(asset);
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
