import 'package:flutter/material.dart';
import 'package:service_tak_mobile/model/worker/qr_bracelet_model.dart';
import 'package:service_tak_mobile/model/worker/qr_card_model.dart';

class SecurityProductDetailViewModel extends ChangeNotifier {
  SecurityProductDetailViewModel(
      QrBracelet? qrBracelet, QrCard? qrCard, bool isBracelet) {
    debugPrint("Security Product Detail VM Called");
    setQrBracelet = qrBracelet;
    setQrCard = qrCard;
    onInitialize(isBracelet);
  }

  // Setters
  QrBracelet? _qrBracelet;
  QrCard? _qrCard;
  String _roomNumber = "";
  String _entryDate = "";
  String _releaseDate = "";
  String _imageUrl = "";

  // Getters
  QrBracelet? get qrBracelet => _qrBracelet;
  QrCard? get qrCard => _qrCard;
  String get roomNumber => _roomNumber;
  String get entryDate => _entryDate;
  String get releaseDate => _releaseDate;
  String get imageUrl => _imageUrl;

  // Methods
  set setQrBracelet(QrBracelet? value) {
    _qrBracelet = value;
    notifyListeners();
  }

  set setQrCard(QrCard? value) {
    _qrCard = value;
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

  void onInitialize(bool isBracelet) {
    if (isBracelet) {
      if (_qrBracelet != null) {
        setRoomNumber = _qrBracelet!.guest?.room?.roomNumber ?? "";
        setEntryDate = _qrBracelet!.guest?.room?.startDate ?? "";
        setReleaseDate = _qrBracelet!.guest?.room?.endDate ?? "";
        setImageUrl = _qrBracelet!.guest?.passport ?? "";
      }
    } else {
      if (_qrCard != null) {
        setRoomNumber = _qrCard!.roomQr?.room?.roomNumber ?? "";
        setEntryDate = _qrCard!.roomQr?.room?.startDate ?? "";
        setReleaseDate = _qrCard!.roomQr?.room?.endDate ?? "";
        setImageUrl = _qrCard!.roomQr?.room?.guests.first.passport ?? "";
      }
    }
  }
}
