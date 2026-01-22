import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/presentation/pages/login_page.dart';

class EchionApp extends ConsumerStatefulWidget {
  const EchionApp({super.key});

  @override
  ConsumerState<EchionApp> createState() => _EchionAppState();
}

class _EchionAppState extends ConsumerState<EchionApp> {
  @override
  void initState() {
    super.initState();
    // Cek status auth
    Future.microtask(() => ref.read(authProvider.notifier).checkAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Echion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: LoginPage(),
    );
  }
}