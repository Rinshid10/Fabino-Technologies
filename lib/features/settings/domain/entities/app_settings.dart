import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Which theme the app uses.
enum AppThemeMode { system, light, dark }

/// How long the app may stay in the background (or idle) before it locks.
enum AutoLockDuration {
  immediately(Duration.zero),
  seconds30(Duration(seconds: 30)),
  minute1(Duration(minutes: 1)),
  minutes5(Duration(minutes: 5)),
  never(null)
  ;

  const AutoLockDuration(this.timeout);

  /// `null` means the app never locks automatically.
  final Duration? timeout;
}

/// User preferences persisted on the device.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(AutoLockDuration.immediately) AutoLockDuration autoLockDuration,
    @Default(false) bool biometricsEnabled,
    @Default(false) bool screenshotProtection,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
