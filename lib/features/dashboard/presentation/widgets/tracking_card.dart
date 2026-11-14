import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/status_card.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_controller.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';

/// Whether a tracking session is running, and how many are saved.
class TrackingCard extends ConsumerWidget {
  const TrackingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(
      trackingControllerProvider.select((state) => state.session),
    );
    final savedCount = ref.watch(trackingHistoryProvider).value?.length;

    return StatusCard(
      icon: Icons.route_outlined,
      title: 'Tracking',
      value: session == null ? 'Not tracking' : 'Tracking now',
      detail: session == null
          ? switch (savedCount) {
              null => null,
              1 => '1 saved session',
              _ => '$savedCount saved sessions',
            }
          : '${Formatters.distance(session.distanceMeters)} so far',
      tone: session == null ? StatusTone.neutral : StatusTone.good,
      onTap: () => context.go(Routes.tracking),
    );
  }
}
