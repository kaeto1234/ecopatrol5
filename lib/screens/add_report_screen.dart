import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/report_model.dart';
import '../providers/report_provider.dart';

class AddReportScreen extends ConsumerStatefulWidget {
  const AddReportScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends ConsumerState<AddReportScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  File? _image;
  double? _lat;
  double? _lng;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource src) async {
    final XFile? picked = await _picker.pickImage(source: src, maxWidth: 1200, imageQuality: 80);
    if (picked == null) return;

    // copy to app dir
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(picked.path);
    final saved = await File(picked.path).copy('${appDir.path}/$fileName');

    setState(() => _image = saved);
  }

  Future<void> _tagLocation() async {
    final loc = Location();
    bool serviceEnabled = await loc.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await loc.requestService();
    PermissionStatus permissionGranted = await loc.hasPermission();
    if (permissionGranted == PermissionStatus.denied) permissionGranted = await loc.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak')));
      return;
    }
    final pos = await loc.getLocation();
    setState(() {
      _lat = pos.latitude;
      _lng = pos.longitude;
    });
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty || _descCtrl.text.trim().isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi judul, deskripsi, dan foto')));
      return;
    }

    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final report = ReportModel(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      imagePath: _image!.path,
      latitude: _lat,
      longitude: _lng,
      createdAt: now,
    );

    await ref.read(reportListProvider.notifier).addReport(report);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Laporan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul')),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Deskripsi'), maxLines: 3),
            const SizedBox(height: 12),
            Row(children: [
              ElevatedButton.icon(onPressed: () => _pickImage(ImageSource.camera), icon: const Icon(Icons.camera_alt), label: const Text('Kamera')),
              const SizedBox(width: 8),
              ElevatedButton.icon(onPressed: () => _pickImage(ImageSource.gallery), icon: const Icon(Icons.photo), label: const Text('Galeri')),
            ]),
            const SizedBox(height: 12),
            if (_image != null) Image.file(_image!, width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 12),
            ElevatedButton.icon(onPressed: _tagLocation, icon: const Icon(Icons.my_location), label: const Text('Tag Lokasi Terkini')),
            if (_lat != null && _lng != null) Padding(padding: const EdgeInsets.only(top:8.0), child: Text('Lat: $_lat, Lng: $_lng')),
            const SizedBox(height: 20),
            Center(child: ElevatedButton(onPressed: _submit, child: const Text('Submit'))),
          ],
        ),
      ),
    );
  }
}
