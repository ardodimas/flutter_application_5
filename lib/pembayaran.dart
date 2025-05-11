import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';
import 'pembayaran_provider.dart';

class Pembayaran extends StatefulWidget {
  const Pembayaran({super.key});

  @override
  State<Pembayaran> createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Memuat saldo menggunakan Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SaldoProvider>().loadSaldo();
    });
  }

  Future<void> _bayar() async {
    try {
      final pembayaranProvider = context.read<PembayaranProvider>();
      await pembayaranProvider.processPayment(
        _nomorController.text,
        _jumlahController.text,
      );

      _showDialog(
        'Berhasil',
        'Pembayaran ${pembayaranProvider.selectedPayment} berhasil',
      );
      _nomorController.clear();
      _jumlahController.clear();
      pembayaranProvider.setSelectedPayment('');

      // Refresh saldo
      context.read<SaldoProvider>().loadSaldo();
    } catch (e) {
      _showDialog('Gagal', e.toString());
    }
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
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saldo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Jenis Pembayaran
            const Text(
              'Pilih Jenis Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<PembayaranProvider>(
              builder: (context, pembayaranProvider, child) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPaymentOption(
                      'Listrik',
                      Icons.electric_bolt,
                      pembayaranProvider,
                    ),
                    _buildPaymentOption(
                      'Air',
                      Icons.water_drop,
                      pembayaranProvider,
                    ),
                    _buildPaymentOption(
                      'Internet',
                      Icons.wifi,
                      pembayaranProvider,
                    ),
                    _buildPaymentOption(
                      'TV Kabel',
                      Icons.tv,
                      pembayaranProvider,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Form Pembayaran
            TextField(
              controller: _nomorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nomor Pelanggan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Pembayaran',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _bayar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Bayar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    String title,
    IconData icon,
    PembayaranProvider provider,
  ) {
    final isSelected = provider.selectedPayment == title;
    return GestureDetector(
      onTap: () {
        provider.setSelectedPayment(title);
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 40) / 2,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A237E) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF1A237E),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
