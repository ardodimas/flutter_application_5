import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MutasiHelper {
  static const String key = 'mutasi_list';

  static Future<void> addMutasi({
    required String tanggal,
    required String keterangan,
    required int nominal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mutasiStringList = prefs.getStringList(key) ?? [];
    final mutasi = {
      'tanggal': tanggal,
      'keterangan': keterangan,
      'nominal': nominal.toString(),
    };
    mutasiStringList.insert(0, jsonEncode(mutasi)); // terbaru di atas
    await prefs.setStringList(key, mutasiStringList);
  }

  static Future<List<Map<String, dynamic>>> getMutasiList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mutasiStringList = prefs.getStringList(key) ?? [];
    return mutasiStringList
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }
}
