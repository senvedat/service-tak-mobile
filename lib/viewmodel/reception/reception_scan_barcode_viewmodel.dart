import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:service_tak_mobile/locator.dart';
import 'package:service_tak_mobile/model/helper/helper_model.dart';
import 'package:service_tak_mobile/model/hotel/current_hotel_model.dart';
import 'package:service_tak_mobile/model/hotel/new_guest_model.dart';
import 'package:service_tak_mobile/service/hotel/hotel_guest_service.dart';
import 'package:service_tak_mobile/service/hotel/hotel_room_service.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/reception/room_screen.dart';
import 'package:service_tak_mobile/view/widget/qr_not_found_dialog.dart';

class ReceptionScanBarcodeViewModel extends ChangeNotifier
    with WidgetsBindingObserver {
  final HotelGuestService _guestService = locator.get<HotelGuestService>();
  final HotelRoomService _roomService = locator.get<HotelRoomService>();
  ReceptionScanBarcodeViewModel(
      NewGuest? guest, Hotel? hotel, int? roomId, bool isEdit) {
    debugPrint("Scan Barcode VM Called");
    debugPrint("Worker Found");
    setGuest = guest;
    setHotel = hotel;
    setRoomId = roomId ?? -1;
    setIsEdit = isEdit;
    initialize();
    _getCameraPermission();
  }

  //Setters
  PermissionStatus? _status;
  QRViewController? _controller1;
  Barcode? _barcode;
  String? _secondBarcode;
  final GlobalKey _key = GlobalKey();
  NewGuest? _guest;
  Hotel? _hotel;
  bool _isPageLoaded = false;
  bool _isUpdating = false;
  bool? _isEdit;
  bool _isSecondBarcodeActive = false;
  ErrorResponse? _errorResponse;
  int? _roomId;
  String? _qrType;

  //Getters
  PermissionStatus? get status => _status;
  QRViewController? get controller1 => _controller1;
  Barcode? get barcode => _barcode;
  String? get secondBarcode => _secondBarcode;
  GlobalKey get key => _key;
  NewGuest? get guest => _guest;
  Hotel? get hotel => _hotel;
  bool get isPageLoaded => _isPageLoaded;
  bool get isUpdating => _isUpdating;
  bool? get isEdit => _isEdit;
  bool get isSecondBarcodeActive => _isSecondBarcodeActive;
  ErrorResponse? get errorResponse => _errorResponse;
  int get roomId => _roomId!;
  String? get qrType => _qrType;

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

  set setSecondBarcode(String? value) {
    _secondBarcode = value;
    notifyListeners();
  }

  set setGuest(NewGuest? value) {
    _guest = value;
    notifyListeners();
  }

  set setHotel(Hotel? value) {
    _hotel = value;
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

  set setIsEdit(bool? value) {
    _isEdit = value;
    notifyListeners();
  }

  set setIsSecondBarcodeActive(bool value) {
    _isSecondBarcodeActive = value;
    notifyListeners();
  }

  set setErrorResponse(ErrorResponse? value) {
    _errorResponse = value;
    notifyListeners();
  }

  set setRoomId(int value) {
    _roomId = value;
    notifyListeners();
  }

  set setQrType(String? value) {
    _qrType = value;
    notifyListeners();
  }

  void initialize() {
    final String qrType = LocalStorageService.instance.getString(
      LocalStorageKeys.qrType,
    );
    setQrType = qrType;
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
    setIsPageLoaded = true;
    notifyListeners();
  }

  Future<void> scanQr1(
      QRViewController controller, BuildContext context) async {
    setController1 = controller;
    controller.scannedDataStream.listen((barcode) async {
      setBarcode = barcode;
      if (barcode.code != null && barcode.code!.isNotEmpty) {
        controller.pauseCamera();
        if (_qrType == "card") {
          if (_isEdit!) {
            await _updateCardQr(context);
          } else {
            await _createCardQr(context);
          }
        } else {
          await _updateBraceletQr(context);
        }
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
    String barcodeScanRes = "";
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#00000000", 'Cancel', true, ScanMode.QR);
      setSecondBarcode = barcodeScanRes == "-1" ? null : barcodeScanRes;
      if (_secondBarcode != null && _secondBarcode!.isNotEmpty) {
        if (_qrType == "card") {
          if (_isEdit!) {
            await _updateCardQr(context);
          } else {
            await _createCardQr(context);
          }
        } else {
          await _updateBraceletQr(context);
        }
      }
    } catch (e) {
      debugPrint("Error can barcode 2: $e");
    }
  }

  Future<void> _updateBraceletQr(BuildContext context) async {
    final String authToken = LocalStorageService.instance.getString(
      LocalStorageKeys.userAuthToken,
    );

    var response = await _guestService.braceletUpdateQr(
        authToken, _guest!.id!, _secondBarcode ?? _barcode!.code!);
    if (jsonDecode(response.body)['title'] == "Success") {
      navigatorPushReplacement(
          context,
          RoomScreen(
            hotel: _hotel,
            type: _qrType,
          ),
          "");
      await LocalStorageService.instance
          .deleteItem(LocalStorageKeys.localImage);
    } else if (jsonDecode(response.body)['title'] == "Warning") {
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (context) => QrNotFoundDialog(
          onPressed: () {
            Navigator.pop(context);
            _controller1?.resumeCamera();
          },
        ),
      );
    } else {
      setErrorResponse = ErrorResponse.fromJson(json.decode(response.body));
      notifyListeners();
    }
  }

  Future<void> _createCardQr(BuildContext context) async {
    final String authToken = LocalStorageService.instance.getString(
      LocalStorageKeys.userAuthToken,
    );

    var response = await _roomService.cardCreateQr(authToken, _roomId!);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == "warning") {
        if (!context.mounted) return;
        await showDialog(
          context: context,
          builder: (context) => QrNotFoundDialog(
            onPressed: () {
              Navigator.pop(context);
              _controller1?.resumeCamera();
            },
          ),
        );
      } else {
        await navigatorPushReplacement(
            context,
            RoomScreen(
              hotel: _hotel,
              type: _qrType,
            ),
            "");
      }
    } else {
      setErrorResponse = ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<void> _updateCardQr(BuildContext context) async {
    final String authToken = LocalStorageService.instance.getString(
      LocalStorageKeys.userAuthToken,
    );

    var response =
        await _roomService.cardUpdateQr(authToken, _roomId!, _barcode!.code!);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == "warning") {
        if (!context.mounted) return;
        await showDialog(
          context: context,
          builder: (context) => QrNotFoundDialog(
            onPressed: () {
              Navigator.pop(context);
              _controller1?.resumeCamera();
            },
          ),
        );
      } else {
        await navigatorPushReplacement(
            context,
            RoomScreen(
              hotel: _hotel,
              type: _qrType,
            ),
            "");
      }
    } else {
      setErrorResponse = ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<bool> _deletePassport() async {
    final String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    var response =
        await _guestService.deletePassport(authToken, _guest!.id!.toString());
    if (response.statusCode == 200) {
      await LocalStorageService.instance
          .setString(LocalStorageKeys.localImage, "");
      return true;
    } else {
      debugPrint("Failed to delete passport");
      return false;
    }
  }

  Future<bool> _deleteGuest() async {
    final String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    var response =
        await _guestService.deleteGuest(authToken, _guest!.id!.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint("Failed to delete guest");
      return false;
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        await _deletePassport();
        await _deleteGuest();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
