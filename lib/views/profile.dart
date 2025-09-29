import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final ValueChanged<String>? onNameChanged;

  const ProfilePage({
    super.key,
    required this.username,
    this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        automaticallyImplyLeading: canPop,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            const CircleAvatar(radius: 36, backgroundImage: AssetImage('assets/img/Pak_Datuk.jpeg')),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('sandi.arta@gmail.com', style: TextStyle(color: Colors.white.withOpacity(.8))),
              ]),
            ),
            OutlinedButton(
              onPressed: () async {
                final newName = await _showEditNameDialog(context, username);
                if (newName != null && newName.trim().isNotEmpty) {
                  onNameChanged?.call(newName.trim());
                  if (canPop) Navigator.pop(context);
                }
              },
              child: const Text('Edit Profil'),
            ),
          ]),
          const SizedBox(height: 16),

          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Column(children: [
              ListTile(leading: Icon(Icons.badge_outlined), title: Text('ID Pengguna'), subtitle: Text('USR-000123')),
              Divider(height: 1),
              ListTile(leading: Icon(Icons.phone_iphone), title: Text('No. HP'), subtitle: Text('+62 812-3456-7890')),
              Divider(height: 1),
              ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Lokasi'), subtitle: Text('Makassar, ID')),
            ]),
          ),
          const SizedBox(height: 16),

          Card(
            color: const Color(0xFF19202A),
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

  Future<String?> _showEditNameDialog(BuildContext context, String current) async {
    final ctrl = TextEditingController(text: current);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ubah Nama'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Masukkan nama baru'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text('Simpan')),
        ],
      ),
    );
  }
}