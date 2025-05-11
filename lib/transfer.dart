import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';
import 'mutasi_helper.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final TextEditingController _nomorRekeningController =
      TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Memuat saldo menggunakan Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SaldoProvider>().loadSaldo();
    });
  }

  Future<void> _transfer() async {
    final jumlah = int.tryParse(_jumlahController.text) ?? 0;
    final saldoProvider = context.read<SaldoProvider>();
    final saldoSaatIni = int.parse(saldoProvider.saldo);

    if (jumlah <= 0) {
      _showDialog('Gagal', 'Jumlah transfer harus lebih dari 0');
      return;
    }

    if (jumlah > saldoSaatIni) {
      _showDialog('Gagal', 'Saldo tidak mencukupi');
      return;
    }

    // Proses transfer
    final saldoBaru = saldoSaatIni - jumlah;
    await saldoProvider.setSaldo(saldoBaru.toString());

    _showDialog('Berhasil', 'Transfer berhasil dilakukan');
    _nomorRekeningController.clear();
    _jumlahController.clear();

    // Kembali ke halaman beranda
    if (mounted) {
      Navigator.pop(context);
    }

    // Setelah transfer berhasil:
    final now = DateTime.now();
    final tanggal =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await MutasiHelper.addMutasi(
      tanggal: tanggal,
      keterangan: 'Transfer',
      nominal: -jumlah,
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1A237E),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transfer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saldo Anda',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Consumer<SaldoProvider>(
                          builder: (context, saldoProvider, child) {
                            return Text(
                              'Rp. ${int.parse(saldoProvider.saldo).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nomorRekeningController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nomor Rekening Tujuan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Jumlah Transfer',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _transfer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Transfer',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
