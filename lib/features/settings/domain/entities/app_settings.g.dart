// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  themeMode:
      $enumDecodeNullable(_$AppThemeModeEnumMap, json['themeMode']) ??
      AppThemeMode.system,
  autoLockDuration:
      $enumDecodeNullable(
        _$AutoLockDurationEnumMap,
        json['autoLockDuration'],
      ) ??
      AutoLockDuration.immediately,
  biometricsEnabled: json['biometricsEnabled'] as bool? ?? false,
  screenshotProtection: json['screenshotProtection'] as bool? ?? false,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'themeMode': _$AppThemeModeEnumMap[instance.themeMode]!,
      'autoLockDuration': _$AutoLockDurationEnumMap[instance.autoLockDuration]!,
      'biometricsEnabled': instance.biometricsEnabled,
      'screenshotProtection': instance.screenshotProtection,
    };

const _$AppThemeModeEnumMap = {
  AppThemeMode.system: 'system',
  AppThemeMode.light: 'light',
  AppThemeMode.dark: 'dark',
};

const _$AutoLockDurationEnumMap = {
  AutoLockDuration.immediately: 'immediately',
  AutoLockDuration.seconds30: 'seconds30',
  AutoLockDuration.minute1: 'minute1',
  AutoLockDuration.minutes5: 'minutes5',
  AutoLockDuration.never: 'never',
};
