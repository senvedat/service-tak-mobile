import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:service_tak_mobile/locator.dart';
import 'package:service_tak_mobile/model/helper/helper_model.dart';
import 'package:service_tak_mobile/model/worker/current_worker_model.dart';
import 'package:service_tak_mobile/model/worker/qr_bracelet_model.dart';
import 'package:service_tak_mobile/model/worker/qr_card_model.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/service/worker/worker_service.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/worker/open_screen.dart';
import 'package:service_tak_mobile/view/worker/security/security_product_detail_screen.dart';
import 'package:service_tak_mobile/view/worker/spa/spa_product_detail_screen.dart';

class ScanBarcodeViewModel extends ChangeNotifier {
  final WorkerService _workerService = locator.get<WorkerService>();
  ScanBarcodeViewModel() {
    debugPrint("Scan Barcode VM Called");
    _getCurrentWorker().then((value) {
      debugPrint("Worker Found");

      _getCameraPermission();
    });
  }

  //Setters
  PermissionStatus? _status;
  QRViewController? _controller1;
  Barcode? _barcode;
  final GlobalKey _key = GlobalKey();
  Worker? _worker;
  bool _isPageLoaded = false;
  bool _isUpdating = false;
  ErrorResponse? _errorResponse;

  //Getters
  PermissionStatus? get status => _status;
  QRViewController? get controller1 => _controller1;
  Barcode? get barcode => _barcode;
  GlobalKey get key => _key;
  Worker? get worker => _worker;
  bool get isPageLoaded => _isPageLoaded;
  bool get isUpdating => _isUpdating;
  ErrorResponse? get errorResponse => _errorResponse;

  //Functions

  set setStatus(PermissionStatus? value) {
    _status = value;
    notifyListeners();
  }

  set setController1(QRViewController? value) {
    _controller1 = value;
    notifyListeners();
  }

  set setBarcode(Barcode? value) {
    _barcode = value;
    notifyListeners();
  }

  set setWorker(Worker? value) {
    _worker = value;
    notifyListeners();
  }

  set setIsPageLoaded(bool value) {
    _isPageLoaded = value;
    notifyListeners();
  }

  set setIsUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }

  set setErrorResponse(ErrorResponse? value) {
    _errorResponse = value;
    notifyListeners();
  }

  Future<void> _getCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();

      setStatus = result;
    } else {
      setStatus = status;
    }
    notifyListeners();
  }

  Future<void> scanQr1(
      QRViewController controller, BuildContext context) async {
    setController1 = controller;
    controller.scannedDataStream.listen((barcode) async {
      setBarcode = barcode;
      if (barcode.code != null && barcode.code!.isNotEmpty) {
        controller.pauseCamera();
        await _getQrFromService(context);
      }
    });

    controller.getCameraInfo().then((camera) {
      debugPrint(camera.toString());
      if (camera == CameraFacing.front) {
        controller.flipCamera();
      }
    });
  }

  Future<void> scanQr2(BuildContext context) async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.QR)!
        .listen((barcode) async {
      debugPrint(barcode);
      setBarcode = barcode;
      if (barcode.code != null && barcode.code!.isNotEmpty) {
        await _getQrFromService(context);
      }
    });
  }

  Future<bool> _getQrFromService(BuildContext context) async {
    String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    var response = await _workerService.getQr(authToken, _barcode!.code!);
    if (response.statusCode == 200) {
      debugPrint("QR Found");
      String type = _worker?.hotel?.type ?? "";
      String role = _worker?.role ?? "";
      if (type == "bracelet") {
        QrBracelet qrBracelet = QrBracelet.fromJson(jsonDecode(response.body));
        if (role == "spa") {
          if (!context.mounted) return true;
          var result = await navigatorPush(
              context, SpaProductDetailScreen(qrBracelet: qrBracelet));
          if (result == "resume") {
            _controller1?.resumeCamera();
            notifyListeners();
          }
        } else if (role == "security") {
          if (!context.mounted) return true;
          var result = await navigatorPush(
              context, SecurityProductDetailScreen(qrBracelet: qrBracelet));
          if (result == "resume") {
            _controller1?.resumeCamera();
            notifyListeners();
          }
        }
      } else if (type == "card") {
        QrCard qrCard = QrCard.fromJson(jsonDecode(response.body));
        if (!context.mounted) return true;
        await navigatorPush(
            context, OpenScreen(qrCard: qrCard, worker: _worker));
      }
      return true;
    } else {
      return false;
    }
  }

  Future<void> _getCurrentWorker() async {
    String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    debugPrint("authToken: $authToken");
    var response = await _workerService.getCurrentWorker(authToken);

    if (response.statusCode == 200) {
      debugPrint("Worker Found");
      // debugPrint("body: ${jsonDecode(response.body)}");
      CurrentWorker currentWorker =
          CurrentWorker.fromJson(jsonDecode(response.body));

      setWorker = currentWorker.worker;
      setIsPageLoaded = true;
    } else {
      setErrorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      debugPrint("Worker Not Found");
    }
    notifyListeners();
  }
}
