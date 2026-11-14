import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';

part 'hive_boxes.g.dart';

/// The opened Hive boxes. Every box stores JSON strings keyed by id.
class HiveBoxes {
  const HiveBoxes({
    required this.settings,
    required this.geofences,
    required this.sessions,
  });

  final Box<String> settings;
  final Box<String> geofences;
  final Box<String> sessions;

  /// Initialises Hive in the app documents directory and opens the boxes.
  static Future<HiveBoxes> initAndOpen() async {
    await Hive.initFlutter();
    return open();
  }

  /// Opens the boxes. Hive must already be initialised.
  static Future<HiveBoxes> open() async {
    return HiveBoxes(
      settings: await Hive.openBox<String>(HiveBoxNames.settings),
      geofences: await Hive.openBox<String>(HiveBoxNames.geofences),
      sessions: await Hive.openBox<String>(HiveBoxNames.sessions),
    );
  }
}

/// Overridden in `main()` with the boxes opened during bootstrap.
@Riverpod(keepAlive: true)
HiveBoxes hiveBoxes(Ref ref) {
  throw UnimplementedError('hiveBoxesProvider must be overridden.');
}
