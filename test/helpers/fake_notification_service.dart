import 'package:smart_access_security/core/notifications/notification_service.dart';

/// [NotificationService] that records what would have been shown.
class FakeNotificationService implements NotificationService {
  final List<({int id, NotificationChannel channel, String title, String body})>
  shown = [];

  List<String> get titles => [for (final item in shown) item.title];

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> show({
    required int id,
    required NotificationChannel channel,
    required String title,
    required String body,
  }) async {
    shown.add((id: id, channel: channel, title: title, body: body));
  }
}
