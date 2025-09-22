import 'package:flutter/material.dart';

class LaporkanPage extends StatefulWidget {
  const LaporkanPage({super.key});
  @override
  State<LaporkanPage> createState() => _LaporkanPageState();
}

class _LaporkanPageState extends State<LaporkanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _kategori = 'Kekerasan';

  @override
  void dispose() {
    _judulCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laporan terkirim')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporkan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: InputDecoration(
                labelText: 'Judul Laporan',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: 'Kekerasan', child: Text('Kekerasan')),
                DropdownMenuItem(value: 'Perundungan', child: Text('Perundungan')),
                DropdownMenuItem(value: 'Pelecehan', child: Text('Pelecehan')),
              ],
              onChanged: (v) => setState(() => _kategori = v ?? _kategori),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                alignLabelWithHint: true,
                hintText: 'Ceritakan kronologi dengan jelas...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => (v == null || v.trim().length < 20) ? 'Minimal 20 karakter' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send),
              label: const Text('Kirim Laporan'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ],
        ),
      ),
    );
  }
}