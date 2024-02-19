import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:http/http.dart' as http;

class WorkerService {
  Future getCurrentWorker(String authToken) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/worker/current');

      final response = await http.get(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken',
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

  Future getQr(String authToken, String barcode) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/worker/qr');

      final response = await http.post(
        apiUrl,
        headers: {
          'Accept': 'application/json',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(<String, String>{"url": '$kBaseUrl/$barcode'}),
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

  Future updateTowel(String authToken, num guestId) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/worker/guest/$guestId/towel');

      final response = await http.get(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken',
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
}
