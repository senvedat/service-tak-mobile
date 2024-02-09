import 'package:flutter/material.dart';

class SpaProductDetailViewModel extends ChangeNotifier {
  SpaProductDetailViewModel() {
    print("Product Detail VM Called");
  }

  // Setters
  bool _isSwitched = false;
  // Getters
  bool get isSwitched => _isSwitched;
  // Methods

  void toggleSwitch(bool value) {
    _isSwitched = value;
    notifyListeners();
  }
}
