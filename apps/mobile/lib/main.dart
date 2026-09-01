import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'design_system/theme.dart';

void main() {
  runApp(const ProviderScope(child: DeNestApp()));
}

class DeNestApp extends ConsumerWidget {
  const DeNestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'De Nest',
      debugShowCheckedModeBanner: false,
      theme: buildDnTheme(),
      routerConfig: router,
    );
  }
}
