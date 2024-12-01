import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class FinanceProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  double _total = 0;

  List<Transaction> get transactions => _transactions;
  double get total => _total;

  Future<void> fetchSummary(String token) async {
    final url = Uri.parse('http://localhost:5000/api/finance/summary');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _total = data['total'];
      _transactions = (data['transactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Erro ao buscar resumo financeiro');
    }
  }

  Future<void> addTransaction(String token, String type, double amount) async {
    final url = Uri.parse('http://localhost:5000/api/finance/add');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'type': type, 'amount': amount}),
    );

    if (response.statusCode == 201) {
      fetchSummary(token);
    } else {
      throw Exception('Erro ao adicionar transação');
    }
  }
}
