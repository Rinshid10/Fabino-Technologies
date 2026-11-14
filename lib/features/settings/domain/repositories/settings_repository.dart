import 'package:smart_access_security/features/settings/domain/entities/app_settings.dart';

/// Reads and writes the user's [AppSettings].
abstract interface class SettingsRepository {
  /// Returns the saved settings, or the defaults when nothing is saved.
  AppSettings load();

  Future<void> save(AppSettings settings);
}
