import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanBarcodeViewModel extends ChangeNotifier {
  ScanBarcodeViewModel() {
    debugPrint("Scan Barcode VM Called");

    _getCameraPermission();
  }

  //Setters
  PermissionStatus? _status;
  QRViewController? _controller1;
  Barcode? _barcode;
  final GlobalKey _key = GlobalKey();
  //Getters
  PermissionStatus? get status => _status;
  QRViewController? get controller1 => _controller1;
  Barcode? get barcode => _barcode;
  GlobalKey get key => _key;
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

  Future<void> scanQr1(QRViewController controller) async {
    setController1 = controller;
    controller.scannedDataStream.listen((barcode) {
        setBarcode = barcode;
    });
    controller.getCameraInfo().then((camera) {
      debugPrint(camera.toString());
      if (camera == CameraFacing.front) {
        controller.flipCamera();
      }
    });
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
