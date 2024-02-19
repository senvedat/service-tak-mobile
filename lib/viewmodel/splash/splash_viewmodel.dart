import 'package:flutter/material.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/auth/login_screen.dart';
import 'package:service_tak_mobile/view/reception/reception_open_screen.dart';
import 'package:service_tak_mobile/view/worker/scan_barcode_screen.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel(BuildContext context) {
    debugPrint("Splash VM Called");

    wait(context);
  }

  // Setters

  // Getters

  // Methods

  Future<void> wait(BuildContext context) async {
    bool isUserLoggedIn =
        LocalStorageService.instance.getBool(LocalStorageKeys.isUserLoggedIn);
    String userType =
        LocalStorageService.instance.getString(LocalStorageKeys.userType);
    await Future.delayed(const Duration(seconds: 3)).then((value) {
      if (isUserLoggedIn) {
        switch (userType) {
          case "reception":
            navigatorPushReplacement(context, const ReceptionOpenScreen(), "");
            break;
          case "spa":
            navigatorPushReplacement(context, const ScanBarcodeScreen(), "");
            break;
          case "security":
            navigatorPushReplacement(context, const ScanBarcodeScreen(), "");
            break;
          default:
            navigatorPushReplacement(context, const LoginScreen(), "");
            break;
        }
      } else {
        navigatorPushReplacement(context, const LoginScreen(), "");
      }
    });
  }
}
