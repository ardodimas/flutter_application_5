import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mutasi_helper.dart';
import 'saldo_provider.dart';

class PinjamanProvider extends ChangeNotifier {
  String _jumlahPinjaman = '0';

  String get jumlahPinjaman => _jumlahPinjaman;

  Future<void> loadPinjaman() async {
    final prefs = await SharedPreferences.getInstance();
    _jumlahPinjaman = prefs.getString('pinjaman') ?? '0';
    notifyListeners();
  }

  Future<void> ajukanPinjaman(String nominal) async {
    final jumlahPinjamanBaru = int.tryParse(nominal) ?? 0;

    if (jumlahPinjamanBaru <= 0) {
      throw Exception('Nominal pinjaman harus lebih dari 0');
    }

    final prefs = await SharedPreferences.getInstance();
    final totalPinjaman = int.parse(_jumlahPinjaman) + jumlahPinjamanBaru;
    final saldoSaatIni = int.parse(prefs.getString('saldo') ?? '1200000');
    final saldoBaru = saldoSaatIni + jumlahPinjamanBaru;

    // Update saldo
    await prefs.setString('saldo', saldoBaru.toString());
    _jumlahPinjaman = totalPinjaman.toString();

    final now = DateTime.now();
    final tanggal =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await MutasiHelper.addMutasi(
      tanggal: tanggal,
      keterangan: 'Pinjaman',
      nominal: jumlahPinjamanBaru,
    );

    notifyListeners();
  }
}
