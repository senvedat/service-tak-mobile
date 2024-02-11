import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:service_tak_mobile/model/auth/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:service_tak_mobile/model/helper/helper_model.dart';

class LoginService {
  Future userLogin(String email, String password) async {
    try {
      final apiUrl = Uri.parse('https://service-tak.com/api/login');

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
