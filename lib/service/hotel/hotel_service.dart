import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_tak_mobile/utils/constants.dart';

class HotelService {
  Future getSummary(String authToken) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/summary');

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
      debugPrint("$e");
      return [];
    }
  }

  Future getCurrentHotel(String authToken) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/current');

      final response = await http.get(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        debugPrint("hotel/current Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint("$e");
      return [];
    }
  }

  Future getQr(String authToken, String qrUrl) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/hotel/qr');

      final response = await http.post(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $authToken'
        },
        body: jsonEncode(
          <String, String>{"url": qrUrl},
        ),
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

  Future qrGenerate(String url) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/qr-generate?data=https://servicetak.com/$url');

      final response = await http.get(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        debugPrint("hotel/qr/qrGenerate Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
