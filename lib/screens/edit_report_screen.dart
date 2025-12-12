import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/report_model.dart';
import '../providers/report_provider.dart';

class EditReportScreen extends ConsumerStatefulWidget {
  final ReportModel report;
  const EditReportScreen({Key? key, required this.report}) : super(key: key);

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  File? _doneImage;
  TextEditingController _doneNoteCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.report.title);
    _descCtrl = TextEditingController(text: widget.report.description);
    _doneNoteCtrl = TextEditingController(text: widget.report.doneNote ?? '');
  }

  Future<void> _pickDoneImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(picked.path);
    final saved = await File(picked.path).copy('${appDir.path}/$fileName');
    setState(() => _doneImage = saved);
  }

  Future<void> _save() async {
    final r = widget.report;
    r.title = _titleCtrl.text.trim();
    r.description = _descCtrl.text.trim();
    if (_doneNoteCtrl.text.trim().isNotEmpty) {
      r.doneNote = _doneNoteCtrl.text.trim();
    }
    if (_doneImage != null) r.doneImagePath = _doneImage!.path;
    await ref.read(reportListProvider.notifier).updateReport(r);
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
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul')),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Deskripsi')),
            const SizedBox(height: 8),
            ElevatedButton.icon(onPressed: _pickDoneImage, icon: const Icon(Icons.camera_alt), label: const Text('Foto Hasil Pengerjaan')),
            if (_doneImage != null) Image.file(_doneImage!, width: 200, height: 150, fit: BoxFit.cover),
            TextField(controller: _doneNoteCtrl, decoration: const InputDecoration(labelText: 'Deskripsi Pekerjaan')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _save, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
