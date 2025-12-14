// flutter_riverpod dan shared_preferences digunakan untuk menyimpan status login secara permanen.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>(
  (ref) => AuthNotifier(),
);

// mengkontrol state login
class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    load();
  }

// fungsi user tetap login setelah aplikasi ditutup
  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final loggedIn = sp.getBool('loggedIn') ?? false;
    state = loggedIn;
  }

  // Saat login berhasil, status disimpan secara permanen dan state diperbarui agar UI bereaksi otomatis.
  Future<void> login(String username, String password) async {
    // For UAS -> simple stub: accept any non-empty
    if (username.isNotEmpty && password.isNotEmpty) {
      final sp = await SharedPreferences.getInstance();
      await sp.setBool('loggedIn', true);
      state = true;
    }
  }

  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('loggedIn');
    state = false;
  }
}
