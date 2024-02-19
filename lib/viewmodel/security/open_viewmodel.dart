import 'package:flutter/material.dart';
import 'package:service_tak_mobile/model/worker/current_worker_model.dart';
import 'package:service_tak_mobile/model/worker/qr_card_model.dart';

class OpenViewModel extends ChangeNotifier {
  OpenViewModel(QrCard? qrCard, Worker? worker) {
    debugPrint("Product Detail VM Called");
    setQrCard = qrCard;
    setWorker = worker;
    onInitialize();
  }

  // Setters
  QrCard? _qrCard;
  Worker? _worker;
  List<Guest> _guests = [];

  // Getters
  QrCard? get qrCard => _qrCard;
  Worker? get worker => _worker;
  List<Guest> get guests => _guests;

  // Methods
  set setQrCard(QrCard? value) {
    _qrCard = value;
    notifyListeners();
  }

  set setWorker(Worker? value) {
    _worker = value;
    notifyListeners();
  }

  set setGuests(List<Guest> value) {
    _guests = value;
    notifyListeners();
  }

  void onInitialize() {
    if (qrCard != null) {
      setGuests = qrCard!.roomQr!.room!.guests;
    }
  }
}
