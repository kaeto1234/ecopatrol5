import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';
import 'edit_report_screen.dart';

class DetailReportScreen extends ConsumerWidget {
  final ReportModel report;
  const DetailReportScreen({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Laporan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.imagePath.isNotEmpty) Image.file(File(report.imagePath), width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(report.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(report.description),
            const SizedBox(height: 6),
            if (report.latitude != null) Text('Lokasi: ${report.latitude}, ${report.longitude}'),
            const SizedBox(height: 12),
            if (report.doneImagePath != null && report.doneImagePath!.isNotEmpty) ...[
              const Text('Foto Hasil Pengerjaan:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Image.file(File(report.doneImagePath!)),
            ],
            if (report.doneNote != null && report.doneNote!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Deskripsi Pekerjaan: ' + report.doneNote!),
            ],
            const SizedBox(height: 12),
            Row(children: [
              ElevatedButton(onPressed: () async {
                // open edit screen
                final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditReportScreen(report: report)));
                if (updated == true) {
                  await ref.read(reportListProvider.notifier).load();
                }
              }, child: const Text('Edit')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () async {
                final edited = report;
                edited.status = 'done';
                await ref.read(reportListProvider.notifier).updateReport(edited);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditandai selesai')));
                await ref.read(reportListProvider.notifier).load();
              }, child: const Text('Tandai Selesai')),
              const SizedBox(width: 8),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () async {
                if (report.id != null) {
                  await ref.read(reportListProvider.notifier).deleteReport(report.id!);
                  Navigator.pop(context);
                }
              }, child: const Text('Hapus')),
            ])
          ],
        ),
      ),
    );
  }
}
