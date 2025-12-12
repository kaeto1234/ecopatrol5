import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/report_provider.dart';
import 'add_report_screen.dart';
import 'detail_report_screen.dart';
import 'settings_screen.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoPatrol - Dashboard'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            icon: const Icon(Icons.settings)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddReportScreen())),
        child: const Icon(Icons.add),
      ),
      body: reportsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (reports) {
          final total = reports.length;
          final done = reports.where((r) => r.status == 'done').length;

          return Column(
            children: [
              SummaryCard(total: total, done: done),
              Expanded(
                child: reports.isEmpty
                    ? const Center(child: Text('Belum ada laporan'))
                    : ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, idx) {
                          final r = reports[idx];
                          return ListTile(
                            leading: r.imagePath.isNotEmpty
                                ? Image.file(File(r.imagePath), width: 56, height: 56, fit: BoxFit.cover)
                                : const Icon(Icons.image_not_supported),
                            title: Text(r.title),
                            subtitle: Text(r.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: r.status == 'pending' ? Colors.red : Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(r.status == 'pending' ? 'Pending' : 'Selesai',
                                  style: const TextStyle(color: Colors.white)),
                            ),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailReportScreen(report: r))),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
