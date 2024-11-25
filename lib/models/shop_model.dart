import 'package:flutter/material.dart';
import 'hero_model.dart';
import 'asset_model.dart';

List<AssetModel> initialAssets = [
  AssetModel(id: "1", name: "Alamy", price: 100, image: 'assets/images/alamy.png', category: "Character"),
  AssetModel(id: "2", name: "Arnold", price: 120, image: 'assets/images/arnold.png', category: "Character"),
  AssetModel(id: "3", name: "Asta Cool", price: 150, image: 'assets/images/asta-cool.png', category: "Character"),
  AssetModel(id: "5", name: "Asta Devil", price: 180, image: 'assets/images/asta-devil.png', category: "Character"),
  AssetModel(id: "6", name: "Asta Epic", price: 220, image: 'assets/images/asta-epic.png', category: "Character"),
  AssetModel(id: "7", name: "Asta Thiccsnail", price: 170, image: 'assets/images/asta-thiccsnail.png', category: "Character"),
  AssetModel(id: "9", name: "New Gym Background", price: 50, image: 'assets/images/background.png', category: "Background"),
  AssetModel(id: "10", name: "Black", price: 50, image: 'assets/images/black.png', category: "Character"),
  AssetModel(id: "12", name: "Cbum", price: 300, image: 'assets/images/cbum.png', category: "Character"),
  AssetModel(id: "15", name: "Escanor", price: 250, image: 'assets/images/escanor.png', category: "Character"),
  AssetModel(id: "16", name: "Escanor Sun", price: 260, image: 'assets/images/escanor-sun.png', category: "Character"),
  AssetModel(id: "17", name: "Geto Thiccsnail", price: 200, image: 'assets/images/geto-thiccsnail.png', category: "Character"),
  AssetModel(id: "18", name: "Gojo", price: 220, image: 'assets/images/gojo.png', category: "Character"),
  AssetModel(id: "19", name: "Goku", price: 250, image: 'assets/images/goku.png', category: "Character"),
  AssetModel(id: "22", name: "Late Afternoon", price: 90, image: 'assets/images/late-afternoon.jpeg', category: "Background"),
  AssetModel(id: "25", name: "Mirko Thiccsnail", price: 210, image: 'assets/images/mirko-thiccsnail.png', category: "Character"),
  AssetModel(id: "26", name: "Moon", price: 80, image: 'assets/images/moon.jpg', category: "Background"),
  AssetModel(id: "27", name: "Picolo", price: 150, image: 'assets/images/picolo.png', category: "Character"),
  AssetModel(id: "28", name: "Picolo 2", price: 160, image: 'assets/images/picolo2.png', category: "Character"),
  AssetModel(id: "29", name: "Sukuna Domain", price: 400, image: 'assets/images/sukuna domain bg.jpeg', category: "Background"),
  AssetModel(id: "30", name: "Sukuna", price: 420, image: 'assets/images/sukuna.png', category: "Character"),
  AssetModel(id: "31", name: "Sukuna 2", price: 430, image: 'assets/images/sukuna2.png', category: "Character"),
  AssetModel(id: "32", name: "Sukuna 3", price: 440, image: 'assets/images/sukuna3.png', category: "Character"),
  AssetModel(id: "33", name: "Sukuna 4", price: 450, image: 'assets/images/sukuna4.jpeg', category: "Character"),
  AssetModel(id: "34", name: "Toji Thiccsnail", price: 200, image: 'assets/images/toji-thiccsnail.png', category: "Character"),
  AssetModel(id: "35", name: "Toji", price: 220, image: 'assets/images/toji.png', category: "Character"),
  AssetModel(id: "36", name: "Toji 2", price: 225, image: 'assets/images/toji2.png', category: "Character"),
  AssetModel(id: "37", name: "Yuuji", price: 180, image: 'assets/images/yuji.jpeg', category: "Character"),
];



class ShopModel extends ChangeNotifier {
  HeroModel heroModel;
  List<AssetModel> assets;

  ShopModel(this.heroModel) : assets = initialAssets;

  void updateHeroModel(HeroModel newHeroModel) {
    heroModel = newHeroModel;
    notifyListeners(); // Notify listeners if needed, e.g., if the UI depends on heroModel changes
  }

  void attemptPurchase(AssetModel asset) {
    // Check if the hero can afford the asset and the asset is not already purchased
    if (heroModel.canAfford(asset.price) && !asset.isPurchased) {
      // Deduct gold and add asset to hero's owned assets
      heroModel.purchaseAsset(asset);

      // Update the asset's purchase status
      asset.purchase(); // This will notify listeners specifically for this asset

      // Notify listeners to update the hero's gold display
      heroModel.notifyListeners();

      print("After purchase: ${asset.name} isPurchased = ${asset.isPurchased}");
    } else if (!heroModel.canAfford(asset.price)) {
      print("Not enough gold to purchase ${asset.name}.");
    } else {
      print("${asset.name} has already been purchased.");
    }
  }

  void _showAssetPreview(BuildContext context, ShopModel shopModel, AssetModel asset) {
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
              Text(
                "Are you sure you want to buy ${asset.name}?",
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
                _showPurchaseConfirmationDialog(context, shopModel, asset); // Show confirmation dialog
              },
              child: const Text('Proceed to Buy'),
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseConfirmationDialog(BuildContext context, ShopModel shopModel, AssetModel asset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Purchase'),
          content: Text('Do you want to purchase ${asset.name} for ${asset.price} gold?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close confirmation dialog
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
}