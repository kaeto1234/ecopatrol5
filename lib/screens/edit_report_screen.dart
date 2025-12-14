import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/report_model.dart';
import '../providers/report_provider.dart';

// Halaman edit laporan
// Stateful karena memiliki form dan image picker
class EditReportScreen extends ConsumerStatefulWidget {
  final ReportModel report;

  const EditReportScreen({Key? key, required this.report}) : super(key: key);

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  // Foto hasil pengerjaan
  File? _doneImage;

  // Catatan hasil pekerjaan
  TextEditingController _doneNoteCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Inisialisasi form dengan data lama
    _titleCtrl = TextEditingController(text: widget.report.title);
    _descCtrl = TextEditingController(text: widget.report.description);
    _doneNoteCtrl =
        TextEditingController(text: widget.report.doneNote ?? '');
  }

  // Ambil foto hasil pengerjaan dari kamera
  Future<void> _pickDoneImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    // Simpan foto ke direktori aplikasi
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(picked.path);
    final saved =
        await File(picked.path).copy('${appDir.path}/$fileName');

    setState(() => _doneImage = saved);
  }

  // Simpan perubahan laporan
  Future<void> _save() async {
    final r = widget.report;

    // Update data laporan
    r.title = _titleCtrl.text.trim();
    r.description = _descCtrl.text.trim();

    if (_doneNoteCtrl.text.trim().isNotEmpty) {
      r.doneNote = _doneNoteCtrl.text.trim();
    }

    if (_doneImage != null) {
      r.doneImagePath = _doneImage!.path;
    }

    // Update melalui provider agar tersimpan di database
    await ref.read(reportListProvider.notifier).updateReport(r);

    // Kembali ke detail screen dengan status berhasil
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 8),

            // Ambil foto bukti pengerjaan
            ElevatedButton.icon(
              onPressed: _pickDoneImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Foto Hasil Pengerjaan'),
            ),

            // Preview foto hasil
            if (_doneImage != null)
              Image.file(
                _doneImage!,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
              ),

            // Catatan hasil pengerjaan
            TextField(
              controller: _doneNoteCtrl,
              decoration:
                  const InputDecoration(labelText: 'Deskripsi Pekerjaan'),
            ),

            const SizedBox(height: 12),

            // Simpan perubahan
            ElevatedButton(
              onPressed: _save,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
