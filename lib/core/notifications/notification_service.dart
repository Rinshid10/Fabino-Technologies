import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

/// The kinds of notification the app sends. Each maps to one Android
/// notification channel the user can mute separately.
enum NotificationChannel {
  tracking(
    id: 'tracking',
    name: 'Tracking',
    description: 'Tracking session started and stopped.',
  ),
  geofence(
    id: 'geofence',
    name: 'Geofence alerts',
    description: 'Entering or leaving a geofence.',
  ),
  security(
    id: 'security',
    name: 'Security alerts',
    description: 'Mock locations and other security warnings.',
  )
  ;

  const NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;
}

/// Fixed ids for notifications that replace their previous version.
abstract final class NotificationIds {
  static const tracking = 1;
  static const mockLocation = 2;
}

/// Shows local notifications. Nothing is ever sent over the network.
abstract interface class NotificationService {
  /// Asks the user to allow notifications. Returns whether they are
  /// allowed.
  Future<bool> requestPermission();

  /// Shows a notification. Reusing an [id] replaces the earlier one.
  Future<void> show({
    required int id,
    required NotificationChannel channel,
    required String title,
    required String body,
  });
}

/// [NotificationService] backed by `flutter_local_notifications`.
///
/// A failed notification must never break tracking or geofencing, so
/// plugin errors are swallowed here.
class LocalNotificationService implements NotificationService {
  LocalNotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialization;

  /// Initialises the plugin once, on first use.
  Future<void> _ensureInitialized() {
    return _initialization ??= _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is requested in context, not at start-up.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    try {
      await _ensureInitialized();
      return (await Permission.notification.request()).isGranted;
    } on Exception {
      return false;
    }
  }

  @override
  Future<void> show({
    required int id,
    required NotificationChannel channel,
    required String title,
    required String body,
  }) async {
    try {
      await _ensureInitialized();
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    } on Exception {
      // Ignored on purpose, see the class comment.
    }
  }
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return LocalNotificationService(FlutterLocalNotificationsPlugin());
}
