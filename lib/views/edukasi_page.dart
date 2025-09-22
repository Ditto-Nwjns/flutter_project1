import 'package:flutter/material.dart';

class EdukasiPage extends StatelessWidget {
  const EdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Mengenal Bentuk Kekerasan', 'Pelajari jenis-jenis kekerasan dan cara mengenalinya.'),
      ('Cara Mendukung Korban', 'Langkah praktis menjadi pendengar yang baik.'),
      ('Keamanan Digital Dasar', 'Lindungi privasi dan akun daring Anda.'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Edukasi')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final it = items[i];
          return Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: Text(it.$1),
              subtitle: Text(it.$2),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Buka materi: ${it.$1}'))),
            ),
          );
        },
      ),
    );
  }
}