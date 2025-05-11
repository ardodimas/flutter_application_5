import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaldoProvider extends ChangeNotifier {
  String _saldo = '0';

  String get saldo => _saldo;

  Future<void> loadSaldo() async {
    final prefs = await SharedPreferences.getInstance();
    _saldo = prefs.getString('saldo') ?? '1200000';
    notifyListeners();
  }

  Future<void> setSaldo(String newSaldo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saldo', newSaldo);
    _saldo = newSaldo;
    notifyListeners();
  }
}
