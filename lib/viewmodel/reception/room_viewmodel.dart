import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:service_tak_mobile/locator.dart';
import 'package:service_tak_mobile/model/helper/helper_model.dart';
import 'package:service_tak_mobile/model/hotel/current_hotel_model.dart';
import 'package:service_tak_mobile/model/hotel/new_guest_model.dart';
import 'package:service_tak_mobile/model/hotel/qr_model.dart';
import 'package:service_tak_mobile/service/hotel/hotel_guest_service.dart';
import 'package:service_tak_mobile/service/hotel/hotel_room_service.dart';
import 'package:service_tak_mobile/service/hotel/hotel_service.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/reception/camera_screen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../model/hotel/hotel_room_model.dart';

class RoomViewModel extends ChangeNotifier {
  final HotelRoomService _hotelRoomService = locator.get<HotelRoomService>();
  final HotelGuestService _guestService = locator.get<HotelGuestService>();
  final HotelService _hotelService = locator.get<HotelService>();
  RoomViewModel(String? qrType, Hotel? hotel) {
    debugPrint("Room View Model Called");
    setQrType = qrType;
    setHotel = hotel;
    getRoom().then((value) {
      initialize();
    });
  }

  // Setters
  final GlobalKey _myWidgetKey = GlobalKey();
  Room? _room;
  Hotel? _hotel;
  String? _qrType;
  final DateRangePickerController _entryDateRangePickerController =
      DateRangePickerController();
  final DateRangePickerController _releaseDateRangePickerController =
      DateRangePickerController();
  DateTime _entryDate = DateTime.now();
  DateTime _releaseDate = DateTime.now();
  DateTime? _chosenEntryDate;
  DateTime? _chosenReleaseDate;
  bool _isEntryDatePickerClicked = false;
  bool _isReleaseDatePickerClicked = false;
  bool _isPageLoaded = false;
  bool _isButtonLoading = false;
  final List<GeneratedQr> _qrList = [];
  ErrorResponse? _errorResponse;

  // Getters
  GlobalKey? get myWidgetKey => _myWidgetKey;
  String? get qrType => _qrType;
  Room? get room => _room;
  Hotel? get hotel => _hotel;
  DateRangePickerController get entryDateRangePickerController =>
      _entryDateRangePickerController;
  DateRangePickerController get releaseDateRangePickerController =>
      _releaseDateRangePickerController;

  DateTime get entryDate => _entryDate;
  DateTime get releaseDate => _releaseDate;
  DateTime? get chosenEntryDate => _chosenEntryDate;
  DateTime? get chosenReleaseDate => _chosenReleaseDate;
  bool get isEntryDatePickerClicked => _isEntryDatePickerClicked;
  bool get isReleaseDatePickerClicked => _isReleaseDatePickerClicked;
  bool get isPageLoaded => _isPageLoaded;
  bool get isButtonLoading => _isButtonLoading;
  List<GeneratedQr> get qrList => _qrList;
  ErrorResponse? get errorResponse => _errorResponse;

  // Methods

  set setRoom(Room? value) {
    _room = value;
    notifyListeners();
  }

  set setHotel(Hotel? value) {
    _hotel = value;
    notifyListeners();
  }

  set setQrType(String? value) {
    _qrType = value;
    notifyListeners();
  }

  set setEntryDate(DateTime date) {
    _entryDate = date;
    notifyListeners();
  }

  set setReleaseDate(DateTime date) {
    _releaseDate = date;
    notifyListeners();
  }

  set setChosenEntryDate(DateTime? date) {
    _chosenEntryDate = date;
    notifyListeners();
  }

  set setChosenReleaseDate(DateTime? date) {
    _chosenReleaseDate = date;
    notifyListeners();
  }

  set setIsPageLoaded(bool value) {
    _isPageLoaded = value;
    notifyListeners();
  }

  set setIsButtonLoading(bool value) {
    _isButtonLoading = value;
    notifyListeners();
  }

  set setQrList(GeneratedQr value) {
    _qrList.add(value);
    notifyListeners();
  }

  set setErrorResponse(ErrorResponse value) {
    _errorResponse = value;
    notifyListeners();
  }

  void initialize() {
    setChosenEntryDate = DateFormat("yyyy-MM-dd").parse(room!.startDate!);
    setChosenReleaseDate = DateFormat("yyyy-MM-dd").parse(room!.endDate!);
  }

  bool isButtonActive() {
    if (_chosenEntryDate != null && _chosenReleaseDate != null) {
      return true;
    }
    return false;
  }

  Future<void> getRoom() async {
    String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    String roomNumber =
        LocalStorageService.instance.getString(LocalStorageKeys.roomNumber);
    var response = await _hotelRoomService.getRoom(authToken, roomNumber);

    if (response.statusCode == 200) {
      Room room = Room.fromJson(jsonDecode(response.body)['room']);
      setRoom = room;
      await generateQr();
      setIsPageLoaded = true;
    } else {
      setErrorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      debugPrint("Room Data Not Found");
      setIsPageLoaded = true;
    }
    notifyListeners();
  }

  Future<void> generateQr() async {
    if (_room!.guests.isNotEmpty) {
      if (_qrType == "card") {
        if (_room!.guests.first.qr?.url != null) {
          var response =
              await _hotelService.qrGenerate(_room!.guests.first.qr!.url!);
          if (response.statusCode == 200) {
            GeneratedQr qr = GeneratedQr.fromJson(jsonDecode(response.body));
            setQrList = qr;
          }
        }
      } else {
        for (Guest guest in _room!.guests) {
          if (guest.qr?.url != null) {
            var response = await _hotelService.qrGenerate(guest.qr!.url!);
            if (response.statusCode == 200) {
              GeneratedQr qr = GeneratedQr.fromJson(jsonDecode(response.body));
              setQrList = qr;
            }
          }
        }
      }
    } else {
      debugPrint("No Guest Found");
    }
  }

  Future<void> createGuest() async {
    setIsButtonLoading = true;
    String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    var response = await _guestService.createGuest(
        authToken,
        _room!.roomNumber!,
        dateFormatterYearMonthDay(_chosenEntryDate!),
        dateFormatterYearMonthDay(_chosenReleaseDate!));

    if (response.statusCode == 200) {
      NewGuest newGuest = NewGuest.fromJson(jsonDecode(response.body)['guest']);
      setIsButtonLoading = false;
      var result = await navigatorPush(
          _myWidgetKey.currentContext!,
          CameraScreen(
            hotel: _hotel,
            guest: newGuest,
            imageUrl: _qrList.isNotEmpty ? _room!.guests.first.passport : null,
          ));
      if (result == "refresh") {
        await getRoom();
      }
    } else {
      setIsButtonLoading = false;
      setErrorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      debugPrint("Room Data Not Found");
    }
    notifyListeners();
  }

  Future<void> deleteGuest(String id) async {
    final String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    var response = await _guestService.deleteGuest(authToken, id);
    if (response.statusCode == 200) {
      await getRoom();
    } else {
      debugPrint("Failed to delete guest");
    }
    notifyListeners();
  }

  Future<void> clearRoom() async {
    final String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    var response =
        await _hotelRoomService.clearRoom(authToken, _room!.roomNumber!);
    if (response.statusCode == 200) {
      navigatorPop(_myWidgetKey.currentContext!, "");
    } else {
      debugPrint("Failed to clear room");
    }
    notifyListeners();
  }

  void datePickerOkButtonClicked(bool isPurchaseDate) {
    if (isPurchaseDate) {
      setChosenEntryDate = _entryDate;
      isEntryDatePickerClickedToggle();
    } else {
      setChosenReleaseDate = _releaseDate;
      isReleaseDatePickerClickedToggle();
    }
    notifyListeners();
  }

  void isEntryDatePickerClickedToggle() {
    _isEntryDatePickerClicked = !_isEntryDatePickerClicked;
    if (_isReleaseDatePickerClicked) {
      _isReleaseDatePickerClicked = false;
    }
    if (_chosenEntryDate == null) {
      _entryDateRangePickerController.selectedDate = DateTime.now();
    } else {
      _entryDateRangePickerController.selectedDate = _chosenEntryDate!;
    }
    notifyListeners();
  }

  void isReleaseDatePickerClickedToggle() {
    _isReleaseDatePickerClicked = !_isReleaseDatePickerClicked;
    if (_isEntryDatePickerClicked) {
      _isEntryDatePickerClicked = false;
    }
    if (_chosenReleaseDate == null) {
      _releaseDateRangePickerController.selectedDate = DateTime.now();
    } else {
      _releaseDateRangePickerController.selectedDate = _chosenReleaseDate!;
    }
    notifyListeners();
  }

  void datePickerResetButtonClicked(bool isPurchasedDate) {
    if (isPurchasedDate) {
      setEntryDate = DateTime.now();
      setChosenEntryDate = null;
      _entryDateRangePickerController.selectedDate = DateTime.now();
    } else {
      setReleaseDate = DateTime.now();
      setChosenReleaseDate = null;
      _releaseDateRangePickerController.selectedDate = DateTime.now();
    }
    notifyListeners();
  }
}
