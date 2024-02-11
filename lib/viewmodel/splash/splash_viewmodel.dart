import 'package:flutter/material.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/auth/login_screen.dart';
import 'package:service_tak_mobile/view/security/scan_barcode_screen.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel(BuildContext context) {
    debugPrint("Splash VM Called");
    wait(context);
  }

  // Setters

  // Getters

  // Methods

  Future<void> wait(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3)).then((value) {
      navigatorPushReplacement(context, const LoginScreen(), "");
    });
  }
}
