import 'package:flutter/material.dart';
import 'mutasi_helper.dart';

class MutasiProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _mutasiList = [];

  List<Map<String, dynamic>> get mutasiList => _mutasiList;

  Future<void> loadMutasi() async {
    _mutasiList = await MutasiHelper.getMutasiList();
    notifyListeners();
  }

  Future<void> addMutasi({
    required String tanggal,
    required String keterangan,
    required int nominal,
  }) async {
    await MutasiHelper.addMutasi(
      tanggal: tanggal,
      keterangan: keterangan,
      nominal: nominal,
    );
    await loadMutasi(); // Reload data setelah menambah mutasi
  }

  // Method untuk mendapatkan total pemasukan
  int getTotalPemasukan() {
    return _mutasiList
        .where((mutasi) => int.parse(mutasi['nominal'].toString()) > 0)
        .fold(
          0,
          (sum, mutasi) => sum + int.parse(mutasi['nominal'].toString()),
        );
  }

  // Method untuk mendapatkan total pengeluaran
  int getTotalPengeluaran() {
    return _mutasiList
        .where((mutasi) => int.parse(mutasi['nominal'].toString()) < 0)
        .fold(
          0,
          (sum, mutasi) => sum + int.parse(mutasi['nominal'].toString()),
        );
  }

  // Method untuk mendapatkan saldo saat ini
  int getSaldoSaatIni() {
    return _mutasiList.fold(
      0,
      (sum, mutasi) => sum + int.parse(mutasi['nominal'].toString()),
    );
  }
}
