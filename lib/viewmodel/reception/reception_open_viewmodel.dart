import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:service_tak_mobile/locator.dart';
import 'package:service_tak_mobile/model/helper/helper_model.dart';
import 'package:service_tak_mobile/model/hotel/current_hotel_model.dart';
import 'package:service_tak_mobile/service/hotel/hotel_room_service.dart';
import 'package:service_tak_mobile/service/hotel/hotel_service.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/reception/room_screen.dart';

class ReceptionOpenViewModel extends ChangeNotifier {
  final HotelService _hotelService = locator<HotelService>();
  final HotelRoomService _hotelRoomService = locator<HotelRoomService>();
  ReceptionOpenViewModel() {
    debugPrint("Reception Open VM Called");

    _getCurrentHotel().then((value) {});
  }

  // Setters
  final TextEditingController _roomNumberController = TextEditingController();
  final FocusNode _roomNumberFocusNode = FocusNode();
  Hotel? _hotel;
  bool _isPageLoaded = false;
  ErrorResponse? _errorResponse;

  // Getters
  TextEditingController get roomNumberController => _roomNumberController;
  FocusNode get roomNumberFocusNode => _roomNumberFocusNode;
  Hotel? get hotel => _hotel;
  bool get isPageLoaded => _isPageLoaded;
  ErrorResponse? get errorResponse => _errorResponse;

  // Methods
  set setHotel(Hotel value) {
    _hotel = value;
    notifyListeners();
  }

  set setIsPageLoaded(bool value) {
    _isPageLoaded = value;
    notifyListeners();
  }

  set setErrorResponse(ErrorResponse? value) {
    _errorResponse = value;
    notifyListeners();
  }

  Future<void> _getCurrentHotel() async {
    String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    var response = await _hotelService.getCurrentHotel(authToken);

    if (response.statusCode == 200) {
      debugPrint("Hotel Found");
      debugPrint("body: ${jsonDecode(response.body)}");
      CurrentHotel currenHotel =
          CurrentHotel.fromJson(jsonDecode(response.body));

      setHotel = currenHotel.hotel!;
      await LocalStorageService.instance
          .setString(LocalStorageKeys.qrType, _hotel!.type);

      setIsPageLoaded = true;
    } else {
      setErrorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      debugPrint("Worker Not Found");
      setIsPageLoaded = true;
    }
    notifyListeners();
  }

  Future<void> checkExistRoom(String roomNumber, BuildContext context) async {
    String authToken =
        LocalStorageService.instance.getString(LocalStorageKeys.userAuthToken);
    await _hotelRoomService.existRoom(authToken, roomNumber).then(
      (response) async {
        if (response.statusCode == 200) {
          var responseString = jsonDecode(response.body)['status'];
          if (responseString == "is_exist") {
            await LocalStorageService.instance
                .setString(LocalStorageKeys.roomNumber, roomNumber);
            setErrorResponse = null;
            if (!context.mounted) return;
            await navigatorPush(
                context,
                RoomScreen(
                  type: _hotel!.type,
                  hotel: _hotel!,
                ));
          } else {
            setErrorResponse = ErrorResponse(message: "Room Not Found");
          }
        } else {
          setErrorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
          debugPrint("Room Not Found");
        }
      },
    );

    _roomNumberController.clear();
    notifyListeners();
  }
}
