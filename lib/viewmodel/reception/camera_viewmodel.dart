import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:service_tak_mobile/locator.dart';
import 'package:service_tak_mobile/model/helper/helper_model.dart';
import 'package:service_tak_mobile/model/hotel/current_hotel_model.dart';
import 'package:service_tak_mobile/model/hotel/new_guest_model.dart';
import 'package:service_tak_mobile/service/hotel/hotel_guest_service.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/reception/recception_scan_barcode_screen.dart';

class CameraViewModel extends ChangeNotifier with WidgetsBindingObserver {
  final HotelGuestService _guestService = locator.get<HotelGuestService>();
  final ImagePicker _imagePicker = ImagePicker();
  CameraViewModel(NewGuest? guest, Hotel? hotel, bool isEdit) {
    debugPrint("Camera View Model Called");
    setGuest = guest;
    setHotel = hotel;
    setIsEdit = isEdit;
    _getCameraPermission();
  }

  // Setters
  PermissionStatus? _status;
  final GlobalKey _myWidgetKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  File? _image;
  Hotel? _hotel;
  NewGuest? _guest;
  String _localImage = "";
  String _navigatorResult = "null";
  bool _isImageInProgress = false;
  bool? _isEdit;
  bool _isButtonLoading = false;
  ErrorResponse? _errorResponse;

  // Getters
  PermissionStatus? get status => _status;
  GlobalKey? get myWidgetKey => _myWidgetKey;
  ScrollController get scrollController => _scrollController;
  File? get image => _image;
  Hotel? get hotel => _hotel;
  NewGuest? get guest => _guest;
  String get localImage => _localImage;
  String get navigatorResult => _navigatorResult;
  bool get isImageInProgress => _isImageInProgress;
  bool? get isEdit => _isEdit;
  bool get isButtonLoading => _isButtonLoading;
  ErrorResponse? get errorResponse => _errorResponse;

  // Methods
  set setStatus(PermissionStatus? value) {
    _status = value;
    notifyListeners();
  }

  set setImage(File? value) {
    _image = value;
    notifyListeners();
  }

  set setHotel(Hotel? value) {
    _hotel = value;
    notifyListeners();
  }

  set setGuest(NewGuest? value) {
    _guest = value;
    notifyListeners();
  }

  set setLocalImage(String value) {
    _localImage = value;
    notifyListeners();
  }

  set setNavigatorResult(String value) {
    _navigatorResult = value;
    notifyListeners();
  }

  set setIsImageInProgress(bool value) {
    _isImageInProgress = value;
    notifyListeners();
  }

  set setIsEdit(bool? value) {
    _isEdit = value;
    notifyListeners();
  }

  set setIsButtonLoading(bool value) {
    _isButtonLoading = value;
    notifyListeners();
  }

  set setErrorResponse(ErrorResponse? value) {
    _errorResponse = value;
    notifyListeners();
  }

  Future<void> appBarOnBack() async {
    if (_navigatorResult == "resume") {
      bool result1 = await _deletePassport();
      // bool result2 = await _deleteGuest();

      if (result1) {
        navigatorPop(_myWidgetKey.currentContext!, "refresh");
      }
    } else {
      navigatorPop(_myWidgetKey.currentContext!, "refresh");
    }
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

  void pickImage(BuildContext context, ImageSource source) async {
    setIsImageInProgress = true;
    XFile? selectedImage =
        await _imagePicker.pickImage(source: source, imageQuality: 50);
    if (selectedImage != null) {
      String base64EncodedImage =
          base64Encode(File(selectedImage.path).readAsBytesSync());
      setImage = File(selectedImage.path);
      setLocalImage = base64EncodedImage;
    } else {
      debugPrint("No image selected");
    }
    setIsImageInProgress = false;
    notifyListeners();
  }

  Future<bool> updatePassport() async {
    setIsButtonLoading = true;
    final String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    var response =
        await _guestService.updatePassport(authToken, _guest!.id!, _image!);

    if (response.statusCode == 200) {
      if (_isEdit!) {
        await LocalStorageService.instance
            .deleteItem(LocalStorageKeys.localImage);
        navigatorPop(_myWidgetKey.currentContext!, "refresh");
      } else {
        await LocalStorageService.instance
            .setString(LocalStorageKeys.localImage, _localImage);
        final result = await navigatorPush(
            _myWidgetKey.currentContext!,
            ReceptionScanBarcodeScreen(
              hotel: _hotel,
              guest: _guest,
              roomId: _guest!.roomId,
            ));
        if (result == "resume") {
          final String image = LocalStorageService.instance
              .getString(LocalStorageKeys.localImage);
          setLocalImage = image;
          setNavigatorResult = result;
          notifyListeners();
        }
      }
      setIsButtonLoading = false;
      return true;
    } else {
      setErrorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      debugPrint("Failed to update passport");
      setIsButtonLoading = false;
      return false;
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
