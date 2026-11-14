import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/widgets/section_header.dart';
import 'package:smart_access_security/features/geofence/presentation/controllers/geofence_list_controller.dart';
import 'package:smart_access_security/features/geofence/presentation/widgets/geofence_actions.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';
import 'package:smart_access_security/features/tracking/presentation/widgets/history_actions.dart';

/// Destructive actions on locally stored data.
class DataSection extends ConsumerWidget {
  const DataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionCount = ref.watch(trackingHistoryProvider).value?.length ?? 0;
    final geofenceCount =
        ref.watch(geofenceListControllerProvider).value?.length ?? 0;

    return SectionCard(
      title: 'Data on this device',
      children: [
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Clear history'),
          subtitle: Text(_count(sessionCount, 'saved session')),
          enabled: sessionCount > 0,
          onTap: () => confirmClearHistory(context, ref),
        ),
        ListTile(
          leading: const Icon(Icons.radar_outlined),
          title: const Text('Clear geofences'),
          subtitle: Text(_count(geofenceCount, 'geofence')),
          enabled: geofenceCount > 0,
          onTap: () => confirmClearGeofences(context, ref),
        ),
      ],
    );
  }

  static String _count(int count, String noun) {
    return count == 1 ? '1 $noun' : '$count ${noun}s';
  }
}
