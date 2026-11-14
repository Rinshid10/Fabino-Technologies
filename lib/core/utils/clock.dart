import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// Returns the current time. Injected so tests can control time.
typedef Clock = DateTime Function();

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => DateTime.now;
