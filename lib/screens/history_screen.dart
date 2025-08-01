import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Ambil data history dan urutkan berdasarkan timestamp terbaru
    final historyRef = FirebaseFirestore.instance
        .collection('history')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Riwayat Pembelian', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: historyRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat pembelian',
                  style: TextStyle(color: Colors.white70)),
            );
          }

          final historyDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {
              final data = historyDocs[index].data() as Map<String, dynamic>;

              final name = data['name'] ?? 'Produk';
              final price = data['price'] ?? 0;
              final imageUrl = data['imageUrl'] ?? '';
              final quantity = data['quantity'] ?? 1;

              // ✅ format tanggal jika ada timestamp
              DateTime? dateTime;
              String formattedDate = 'Tanggal tidak diketahui';
              if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
                dateTime = (data['timestamp'] as Timestamp).toDate();
                formattedDate = DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(dateTime);
              }

              return Card(
                color: Colors.grey[850],
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported, color: Colors.white70),
                  title: Text(name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Rp ${price.toString()} x $quantity\nTanggal: $formattedDate',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
