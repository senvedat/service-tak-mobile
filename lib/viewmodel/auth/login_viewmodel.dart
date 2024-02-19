import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:service_tak_mobile/locator.dart';
import 'package:service_tak_mobile/model/auth/login_model.dart';
import 'package:service_tak_mobile/model/helper/helper_model.dart';
import 'package:service_tak_mobile/service/auth/login_service.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/reception/reception_open_screen.dart';
import 'package:service_tak_mobile/view/worker/scan_barcode_screen.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginService _loginService = locator.get<LoginService>();

  LoginViewModel() {
    debugPrint("Login VM Called");
  }

  //Setters
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = "";
  bool _isPasswordObscure = true;

  //Getters
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get isChecked => _isChecked;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get isPasswordObscure => _isPasswordObscure;

  //Functions

  void toggleCheckbox() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  set setHasError(bool value) {
    _hasError = value;
    notifyListeners();
  }

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set setErrorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  set setPasswordObscure(bool value) {
    _isPasswordObscure = value;
    notifyListeners();
  }

  Future<void> userLogin(BuildContext context) async {
    var response = await _loginService.userLogin(
        _emailController.text, passwordController.text);
    setIsLoading = false;

    if (response.statusCode == 200) {
      if (_isChecked) {
        await LocalStorageService.instance
            .setBool(LocalStorageKeys.isUserLoggedIn, true);
      }

      LoginResponseModel responseData =
          LoginResponseModel.fromJson(json.decode(response.body));
      await LocalStorageService.instance
          .setString(LocalStorageKeys.userType, responseData.type!);
      await LocalStorageService.instance
          .setString(LocalStorageKeys.userAuthToken, responseData.token!);

      if (responseData.type == "reception") {
        debugPrint("---- Reception LOGIN -----");
        if (!context.mounted) return;
        await navigatorPush(context, const ReceptionOpenScreen());
      } else if (responseData.type == "spa") {
        debugPrint("---- Spa LOGIN  -----");
        if (!context.mounted) return;
        await navigatorPush(context, const ScanBarcodeScreen());
      } else if (responseData.type == "security") {
        debugPrint("---- Security LOGIN -----");
        if (!context.mounted) return;
        await navigatorPush(context, const ScanBarcodeScreen());
      } else {
        setHasError = true;
        setErrorMessage = "Problem with login! Please try again.";
      }
    } else {
      setHasError = true;

      ErrorResponse responseData =
          ErrorResponse.fromJson(json.decode(response.body));

      setErrorMessage = responseData.message!;
    }
  }
}
