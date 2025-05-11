import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mutasi_helper.dart';

class DepositoProvider extends ChangeNotifier {
  String _saldoDeposito = '0';

  String get saldoDeposito => _saldoDeposito;

  Future<void> loadSaldoDeposito() async {
    final prefs = await SharedPreferences.getInstance();
    _saldoDeposito = prefs.getString('saldo_deposito') ?? '0';
    notifyListeners();
  }

  Future<void> tambahDeposito(String jumlah) async {
    final prefs = await SharedPreferences.getInstance();
    final saldoSaatIni = int.parse(prefs.getString('saldo') ?? '1200000');
    final jumlahDeposito = int.tryParse(jumlah) ?? 0;

    if (jumlahDeposito <= 0) {
      throw Exception('Jumlah deposito harus lebih dari 0');
    }

    if (jumlahDeposito > saldoSaatIni) {
      throw Exception('Saldo tidak mencukupi');
    }

    // Proses tambah deposito
    final saldoBaru = saldoSaatIni - jumlahDeposito;
    final saldoDepositoBaru = int.parse(_saldoDeposito) + jumlahDeposito;

    await prefs.setString('saldo', saldoBaru.toString());
    await prefs.setString('saldo_deposito', saldoDepositoBaru.toString());

    _saldoDeposito = saldoDepositoBaru.toString();

    final now = DateTime.now();
    final tanggal =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await MutasiHelper.addMutasi(
      tanggal: tanggal,
      keterangan: 'Deposito',
      nominal: -jumlahDeposito,
    );

    notifyListeners();
  }
}
