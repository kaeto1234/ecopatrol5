import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// add these imports
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite FFI for desktop platforms:
  // This sets the global databaseFactory used by openDatabase(...)
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    sqfliteFfiInit(); // initialize ffi
    databaseFactory = databaseFactoryFfi; // set global factory
  }

  runApp(const ProviderScope(child: EcoPatrolApp()));
}

class EcoPatrolApp extends ConsumerWidget {
  const EcoPatrolApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(authProvider);

    return MaterialApp(
      title: 'EcoPatrol',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: loggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}
