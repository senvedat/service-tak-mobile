import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:service_tak_mobile/utils/constants.dart';

class LoginService {
  Future userLogin(String email, String password) async {
    try {
      final apiUrl = Uri.parse('$kBaseUrl/api/login');

      final response = await http.post(apiUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        debugPrint("Login Endpoint Error");
        return response;
      }
    } catch (e) {
      debugPrint("$e");
      return [];
    }
  }
}
