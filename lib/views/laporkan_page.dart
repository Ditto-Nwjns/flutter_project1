import 'package:flutter/material.dart';

enum JenisLaporan { verbal, fisik, sosial }

class ReportResult {
  final String judul;
  final JenisLaporan jenis;
  final DateTime waktu;
  final String deskripsi;
  ReportResult({required this.judul, required this.jenis, required this.waktu, required this.deskripsi});
}

class LaporkanPage extends StatefulWidget {
  const LaporkanPage({super.key});
  @override
  State<LaporkanPage> createState() => _LaporkanPageState();
}

class _LaporkanPageState extends State<LaporkanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  JenisLaporan _jenis = JenisLaporan.verbal;
  DateTime? _tanggal;
  TimeOfDay? _waktu;

  @override
  void dispose() {
    _judulCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTanggal() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  Future<void> _pickWaktu() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _waktu ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _waktu = picked);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_tanggal == null || _waktu == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih tanggal & waktu kejadian')));
      return;
    }
    final dt = DateTime(_tanggal!.year, _tanggal!.month, _tanggal!.day, _waktu!.hour, _waktu!.minute);
    final result = ReportResult(
      judul: _judulCtrl.text.trim(),
      jenis: _jenis,
      waktu: dt,
      deskripsi: _descCtrl.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laporan terkirim')));
    Navigator.pop(context, result);
  }

  String _jenisText(JenisLaporan j) {
    switch (j) {
      case JenisLaporan.verbal: return 'Verbal';
      case JenisLaporan.fisik: return 'Fisik';
      case JenisLaporan.sosial: return 'Sosial';
    }
  }

  @override
  Widget build(BuildContext context) {
    final waktuStr = (_tanggal == null || _waktu == null)
        ? 'Belum dipilih'
        : '${_tanggal!.day}/${_tanggal!.month}/${_tanggal!.year}  ${_waktu!.format(context)}';

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

            // Jenis (Radio)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Jenis Perundungan', style: TextStyle(fontWeight: FontWeight.w600)),
                RadioListTile<JenisLaporan>(
                  value: JenisLaporan.verbal,
                  groupValue: _jenis,
                  onChanged: (v) => setState(() => _jenis = v!),
                  title: const Text('Verbal'),
                ),
                RadioListTile<JenisLaporan>(
                  value: JenisLaporan.fisik,
                  groupValue: _jenis,
                  onChanged: (v) => setState(() => _jenis = v!),
                  title: const Text('Fisik'),
                ),
                RadioListTile<JenisLaporan>(
                  value: JenisLaporan.sosial,
                  groupValue: _jenis,
                  onChanged: (v) => setState(() => _jenis = v!),
                  title: const Text('Sosial'),
                ),
              ]),
            ),
            const SizedBox(height: 12),

            // Tanggal & Waktu
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickTanggal,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: const Text('Pilih Tanggal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickWaktu,
                  icon: const Icon(Icons.access_time),
                  label: const Text('Pilih Waktu'),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Text('Waktu kejadian: $waktuStr'),

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