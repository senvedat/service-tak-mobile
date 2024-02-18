import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:http/http.dart' as http;

class HotelGuestService {
  Future updateTowel(String authToken, num id) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/guest/$id/towel');

      final response = await http.get(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        debugPrint("hotel/summary Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future createGuest(String authToken, String roomNumber, String startDate,
      String endDate) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/guest');

      final response = await http.post(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken'
        },
        body: jsonEncode(<String, String>{
          "room_number": roomNumber,
          "start_date": startDate,
          "end_date": endDate
        }),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        debugPrint("hotel/summary Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future updatePassport(String authToken, num id, File imageUrl) async {
    Dio dio = Dio();
    print("guest id: $id");
    print(imageUrl.length);
    print(imageUrl);
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/guest/update/passport');

      final response = await dio.post(
        '$kBaseUrl/api/hotel/guest/update/passport',
        data: FormData.fromMap({
          "id": id,
          "image": await MultipartFile.fromFile(imageUrl.path,
              filename: imageUrl.path.split('/').last)
        }),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": 'Bearer $authToken'
          },
        ),
      );

      // final response = await http.post(
      //   apiUrl,
      //   headers: {
      //     "Content-Type": "application/json",
      //     "Authorization": 'Bearer $authToken'
      //   },
      //   body: jsonEncode(<String, dynamic>{"id": id, "image": }),
      // );
      print("jsonDecode response: ${response.data}");
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return response;
      } else {
        debugPrint("hotel/guest/update/passport Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint("Dived into catch $e");
      return [];
    }
  }

  Future deletePassport(String authToken, String id) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/guest/$id/passport');

      final response = await http.delete(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        debugPrint("hotel/summary Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future deleteGuest(String authToken, String id) async {
    print("id: $id");
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/guest/$id');

      final response = await http.delete(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken'
        },
      );
      print("rseponse: ${response.body}");
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        debugPrint("hotel/deleteGuest Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future braceletUpdateQr(String authToken, num id, String qrUrl) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/guest/update/qr');

      final response = await http.post(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken'
        },
        body:
            jsonEncode(<String, dynamic>{"id": id, "url": "$kBaseUrl/$qrUrl"}),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        debugPrint("hotel/summary Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future braceletDeleteQr(String authToken, num id) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/guest/$id/qr');

      final response = await http.delete(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        debugPrint("hotel/summary Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
