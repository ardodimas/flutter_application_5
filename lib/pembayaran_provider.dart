import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mutasi_helper.dart';

class PembayaranProvider extends ChangeNotifier {
  String _selectedPayment = '';

  String get selectedPayment => _selectedPayment;

  void setSelectedPayment(String payment) {
    _selectedPayment = payment;
    notifyListeners();
  }

  Future<void> processPayment(String nomorPelanggan, String jumlah) async {
    final prefs = await SharedPreferences.getInstance();
    final saldoSaatIni = int.parse(prefs.getString('saldo') ?? '1200000');
    final jumlahPembayaran = int.tryParse(jumlah) ?? 0;

    if (jumlahPembayaran <= 0) {
      throw Exception('Jumlah pembayaran harus lebih dari 0');
    }

    if (jumlahPembayaran > saldoSaatIni) {
      throw Exception('Saldo tidak mencukupi');
    }

    final saldoBaru = saldoSaatIni - jumlahPembayaran;
    await prefs.setString('saldo', saldoBaru.toString());

    final now = DateTime.now();
    final tanggal =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await MutasiHelper.addMutasi(
      tanggal: tanggal,
      keterangan: 'Pembayaran $_selectedPayment',
      nominal: -jumlahPembayaran,
    );

    notifyListeners();
  }
}
