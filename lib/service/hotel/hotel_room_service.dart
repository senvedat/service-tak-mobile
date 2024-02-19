import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:http/http.dart' as http;

class HotelRoomService {
  Future getRoom(String authToken, String roomNumber) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/room/$roomNumber');

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
        debugPrint("hotel/room Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future existRoom(String authToken, String roomNumber) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/room/$roomNumber/exist');

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

  Future clearRoom(String authToken, String roomNumber) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/room/$roomNumber');

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

  Future cardCreateQr(String authToken, num roomNumber) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/room/$roomNumber/qr');

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

  Future cardUpdateQr(String authToken, num id, String qrUrl) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/room/qr');

      final response = await http.post(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken'
        },
        body: jsonEncode(<String, dynamic>{"id": id, "url": qrUrl}),
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

  Future cardDeleteQr(String authToken, num id) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/room/qr/$id');

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
