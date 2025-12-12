import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int total;
  final int done;

  const SummaryCard({
    super.key,
    required this.total,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Laporan', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('$total', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Selesai', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('$done', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
