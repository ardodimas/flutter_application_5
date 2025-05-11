import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  String _username = '';
  String _nim = '2315091001';
  String _email = 'ardodimas@gmail.com';
  String _phone = '081234567890';
  String _address = 'Jalan Raya Singaraja';

  // Getter untuk mengakses data
  String get username => _username;
  String get nim => _nim;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;

  // Method untuk memuat data profil
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    notifyListeners();
  }

  // Method untuk mengupdate data profil
  Future<void> updateProfile({
    String? nim,
    String? email,
    String? phone,
    String? address,
  }) async {
    if (nim != null) _nim = nim;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (address != null) _address = address;
    notifyListeners();
  }
}
