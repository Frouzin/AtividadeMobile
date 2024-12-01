import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<void> login(String username, String password) async {
    final url = Uri.parse('http://localhost:5000/api/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      notifyListeners();
    } else {
      throw Exception('Falha no login');
    }
  }

  Future<void> register(String username, String password) async {
    final url = Uri.parse('http://localhost:5000/api/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha no cadastro');
    }
  }

  bool isAuthenticated() => _token != null;
}
