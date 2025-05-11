import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pinjaman_provider.dart';
import 'saldo_provider.dart';

class Pinjaman extends StatefulWidget {
  const Pinjaman({super.key});

  @override
  State<Pinjaman> createState() => _PinjamanState();
}

class _PinjamanState extends State<Pinjaman> {
  final TextEditingController _nominalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Memuat data pinjaman menggunakan Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PinjamanProvider>().loadPinjaman();
    });
  }

  Future<void> _ajukanPinjaman() async {
    try {
      await context.read<PinjamanProvider>().ajukanPinjaman(
        _nominalController.text,
      );
      _showDialog('Berhasil', 'Pengajuan pinjaman berhasil!');
      _nominalController.clear();

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
        title: const Text('Pinjaman'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jumlah Pinjaman',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Consumer<PinjamanProvider>(
                      builder: (context, pinjamanProvider, child) {
                        return Text(
                          'Rp. ${int.parse(pinjamanProvider.jumlahPinjaman).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
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
            const Text(
              'Ajukan Pinjaman',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal Pinjaman',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _ajukanPinjaman,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Ajukan',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
