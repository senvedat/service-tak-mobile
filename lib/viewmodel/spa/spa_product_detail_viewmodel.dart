import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:service_tak_mobile/locator.dart';
import 'package:service_tak_mobile/model/worker/qr_bracelet_model.dart';
import 'package:service_tak_mobile/model/worker/qr_card_model.dart';
import 'package:service_tak_mobile/model/worker/update_towel_response_model.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/service/worker/worker_service.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';

class SpaProductDetailViewModel extends ChangeNotifier {
  final WorkerService _workerService = locator<WorkerService>();
  SpaProductDetailViewModel(
      QrBracelet? qrBracelet, QrCard? qrCard, bool isBracelet, int? index) {
    debugPrint("Spa Product Detail VM Called");
    setIsBracelet = isBracelet;
    setQrBracelet = qrBracelet;
    setQrCard = qrCard;
    onInitialize();
  }

  // Setters
  bool _isSwitched = false;
  bool _isBracelet = true;
  QrBracelet? _qrBracelet;
  QrCard? _qrCard;
  List<TowelHistory> _towelHistories = [];
  String _roomNumber = "";
  String _entryDate = "";
  String _releaseDate = "";
  String _imageUrl = "";
  String _barcodeUrl = "";
  int _guestIndex = 0;
  num _guestId = 0;

  // Getters
  bool get isSwitched => _isSwitched;
  bool get isBracelet => _isBracelet;
  QrBracelet? get qrBracelet => _qrBracelet;
  QrCard? get qrCard => _qrCard;
  List<TowelHistory> get towelHistories => _towelHistories;
  String get roomNumber => _roomNumber;
  String get entryDate => _entryDate;
  String get releaseDate => _releaseDate;
  String get imageUrl => _imageUrl;
  String get barcodeUrl => _barcodeUrl;
  int get guestIndex => _guestIndex;
  num get guestId => _guestId;

  // Methods

  set setIsBracelet(bool value) {
    _isBracelet = value;
    notifyListeners();
  }

  set setQrBracelet(QrBracelet? value) {
    _qrBracelet = value;
    notifyListeners();
  }

  set setQrCard(QrCard? value) {
    _qrCard = value;
    notifyListeners();
  }

  set setTowelHistories(List<TowelHistory> value) {
    _towelHistories = value;
    notifyListeners();
  }

  set setRoomNumber(String value) {
    _roomNumber = value;
    notifyListeners();
  }

  set setEntryDate(String value) {
    _entryDate = value;
    notifyListeners();
  }

  set setReleaseDate(String value) {
    _releaseDate = value;
    notifyListeners();
  }

  set setImageUrl(String value) {
    _imageUrl = value;
    notifyListeners();
  }

  set setBarcodeUrl(String value) {
    _barcodeUrl = value;
    notifyListeners();
  }

  set setIsSwitched(bool value) {
    _isSwitched = value;
    notifyListeners();
  }

  set setGuestIndex(int value) {
    _guestIndex = value;
    notifyListeners();
  }

  set setGuestId(num value) {
    _guestId = value;
    notifyListeners();
  }

  void onInitialize() {
    if (isBracelet) {
      if (_qrBracelet != null) {
        setRoomNumber = _qrBracelet!.guest?.room?.roomNumber ?? "";
        setEntryDate = _qrBracelet!.guest?.room?.startDate ?? "";
        setReleaseDate = _qrBracelet!.guest?.room?.endDate ?? "";
        setImageUrl = _qrBracelet!.guest?.passport ?? "";
        setBarcodeUrl = _qrBracelet!.url ?? "";
        setIsSwitched = _qrBracelet!.guest?.towel ?? false;
        setGuestId = _qrBracelet!.guest!.id!;
        setTowelHistories = _qrBracelet!.guest?.towelHistories ?? [];
      }
    } else {
      if (_qrCard != null) {
        setRoomNumber = _qrCard!.roomQr!.room?.roomNumber ?? "";
        setEntryDate = _qrCard!.roomQr!.room?.startDate ?? "";
        setReleaseDate = _qrCard!.roomQr!.room?.endDate ?? "";
        setImageUrl = _qrCard!.roomQr!.room?.guests[_guestIndex].passport ?? "";
        setBarcodeUrl = _qrCard!.url ?? "";
        setIsSwitched = _qrCard!.roomQr!.room?.guests[_guestIndex].towel ?? false;
        setGuestId = _qrCard!.roomQr!.room!.guests[_guestIndex].id!;
        setTowelHistories =
            _qrCard!.roomQr?.room?.guests[_guestIndex].towelHistories ?? [];
      }
    }
  }

  String type(String type) {
    if (type == "WORKER_SPA_ROLE") {
      return "Spa";
    } else {
      return "Hotel";
    }
  }

  String status(String status) {
    if (status == "towel_taken") {
      return "Towel Taken";
    } else {
      return "Towel Returned";
    }
  }

  String date(String date) {
    DateTime dateTime = DateTime.parse(date);
    return dateFormatterYearMonthDay(dateTime);
  }

  Future<void> toggleSwitch() async {
    _isSwitched = !_isSwitched;
    await _updateTowel();
    notifyListeners();
  }

  Future<void> _updateTowel() async {
    final String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    await _workerService
        .updateTowel(authToken, _guestId)
        .then((response) async {
      UpdateTowelResponse towelResponse =
          UpdateTowelResponse.fromJson(jsonDecode(response.body));

      if (towelResponse.status == "success") {
        debugPrint("Towel Updated");
        await _getQrFromService(authToken);
      } else {
        debugPrint("Towel Not Updated ${towelResponse.message}");
      }
    });
    notifyListeners();
  }

  Future<void> _getQrFromService(String authToken) async {
    await _workerService
        .getQr(
      authToken,
      _barcodeUrl,
    )
        .then((response) {
      if (isBracelet) {
        QrBracelet qrBracelet = QrBracelet.fromJson(jsonDecode(response.body));
        setQrBracelet = qrBracelet;
        setIsSwitched = _qrBracelet!.guest!.towel!;
        setTowelHistories = _qrBracelet!.guest!.towelHistories;
      } else {
        QrCard qrCard = QrCard.fromJson(jsonDecode(response.body));
        setQrCard = qrCard;
        setIsSwitched = _qrCard!.roomQr!.room!.guests[_guestIndex].towel!;
        setTowelHistories =
            _qrCard!.roomQr!.room!.guests[_guestIndex].towelHistories;
      }
    });
    notifyListeners();
  }
}
