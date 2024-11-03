import 'package:flutter/foundation.dart';

class CharacterModel extends ChangeNotifier {
  final String id;
  final String name;
  final String image;
  final int price;
  bool _isPurchased;

  CharacterModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    bool isPurchased = false,
  }) : _isPurchased = isPurchased;

  bool get isPurchased => _isPurchased;

  void purchase() {
    _isPurchased = true;
    notifyListeners(); // Notify only this instance’s listeners
  }
}
