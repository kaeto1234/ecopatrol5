import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);
// Halaman Settings hanya berfungsi sebagai kontrol sesi
// Menggunakan ConsumerWidget karena:
// - Tidak punya state lokal
// - Hanya memanggil Provider (logout)
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
          // Menu logout
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.exit_to_app),
              // Saat logout ditekan:
              // 1. SharedPreferences dibersihkan
              // 2. State auth berubah menjadi false
              // 3. UI akan otomatis kembali ke Login Screen
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
              }
            ),
          ],
        ),
      ),
    );
  }
}
