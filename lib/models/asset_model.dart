import 'package:flutter/foundation.dart';

class AssetModel extends ChangeNotifier {
  final String id;
  final String name;
  final String image;
  final String category;
  final int price;
  bool _isPurchased;

  AssetModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    bool isPurchased = false,
  }) : _isPurchased = isPurchased;

  bool get isPurchased => _isPurchased;

  // Convert AssetModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'category': category,
    };
  }

  // Create AssetModel from JSON
  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      category: json['category'],
    );
  }

  void purchase() {
    _isPurchased = true;
    notifyListeners(); // Notify only this instance’s listeners
  }
}
