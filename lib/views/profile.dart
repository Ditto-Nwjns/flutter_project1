// lib/views/profile.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        automaticallyImplyLeading: canPop, // why: tampilkan tombol back jika datang via push
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            const CircleAvatar(radius: 36, backgroundImage: AssetImage('assets/img/Pak_Datuk.jpeg')),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Sandi Arta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('sandi.arta@gmail.com', style: TextStyle(color: Colors.white.withOpacity(.8))),
              ]),
            ),
            OutlinedButton(onPressed: () {}, child: const Text('Edit Profil')),
          ]),
          const SizedBox(height: 16),

          // Info Akun
          Card(
            color: const Color.fromARGB(255, 12, 0, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(children: const [
              ListTile(leading: Icon(Icons.badge_outlined), title: Text('ID Pengguna'), subtitle: Text('MW01023')),
              Divider(height: 1),
              ListTile(leading: Icon(Icons.phone_iphone), title: Text('No. HP'), subtitle: Text('+62 812-3456-7890')),
              Divider(height: 1),
              ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Lokasi'), subtitle: Text('Bali, ID')),
            ]),
          ),
          const SizedBox(height: 16),

          // Keamanan (2FA DIHAPUS SESUAI PERMINTAAN)
          Card(
            color: const Color.fromARGB(255, 12, 0, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Column(children: [
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Ubah Kata Sandi'),
                subtitle: Text('Perbarui kata sandi akun Anda'),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // Aksi
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(.8))),
        ]),
      ),
    );
  }
}
