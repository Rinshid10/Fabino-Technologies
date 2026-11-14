import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/app.dart';
import 'package:smart_access_security/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final overrides = await bootstrap();
  runApp(
    ProviderScope(
      overrides: overrides,
      // Failures are shown with an explicit "Try again" action instead of
      // being retried silently in the background.
      retry: (retryCount, error) => null,
      child: const SmartAccessApp(),
    ),
  );
}
