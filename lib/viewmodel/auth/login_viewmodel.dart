import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel() {
    print("Login VM Called");
  }

  //Setters
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;

  //Getters
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get isChecked => _isChecked;

  //Functions

  void toggleCheckbox() {
    _isChecked = !_isChecked;
    notifyListeners();
  }
}
