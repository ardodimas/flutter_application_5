import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mutasi_provider.dart';

class Mutasi extends StatefulWidget {
  const Mutasi({super.key});

  @override
  State<Mutasi> createState() => _MutasiState();
}

class _MutasiState extends State<Mutasi> {
  @override
  void initState() {
    super.initState();
    // Memuat data mutasi menggunakan Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MutasiProvider>().loadMutasi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutasi'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<MutasiProvider>(
        builder: (context, mutasiProvider, child) {
          if (mutasiProvider.mutasiList.isEmpty) {
            return const Center(child: Text('Belum ada mutasi'));
          }

          return Column(
            children: [
              // Ringkasan
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      'Total Pemasukan',
                      mutasiProvider.getTotalPemasukan(),
                      Colors.green,
                    ),
                    _buildSummaryItem(
                      'Total Pengeluaran',
                      mutasiProvider.getTotalPengeluaran(),
                      Colors.red,
                    ),
                  ],
                ),
              ),
              // Daftar Mutasi
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: mutasiProvider.mutasiList.length,
                  itemBuilder: (context, index) {
                    final mutasi = mutasiProvider.mutasiList[index];
                    final nominal =
                        int.tryParse(mutasi['nominal'].toString()) ?? 0;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mutasi['keterangan'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    mutasi['tanggal'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              (nominal > 0 ? '+' : '') +
                                  'Rp. ${nominal.abs().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                              style: TextStyle(
                                color: nominal < 0 ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String title, int amount, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          'Rp. ${amount.abs().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
