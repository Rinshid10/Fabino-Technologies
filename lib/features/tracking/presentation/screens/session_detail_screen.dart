import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/app_map.dart';
import 'package:smart_access_security/core/widgets/async_value_view.dart';
import 'package:smart_access_security/core/widgets/confirm_dialog.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';
import 'package:smart_access_security/core/widgets/state_views.dart';
import 'package:smart_access_security/features/location/presentation/widgets/mock_location_banner.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';
import 'package:smart_access_security/features/tracking/presentation/tracking_labels.dart';
import 'package:smart_access_security/features/tracking/presentation/widgets/session_stats.dart';

/// One saved session: its route on the map and its numbers.
class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({required this.sessionId, super.key});

  final String sessionId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete session?',
      message: 'This tracking session will be deleted permanently.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed) return;
    await ref.read(trackingHistoryProvider.notifier).delete(sessionId);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionDetailProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
        actions: [
          if (session.value != null)
            IconButton(
              tooltip: 'Delete session',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(context, ref),
            ),
        ],
      ),
      body: AsyncValueView(
        value: session,
        onRetry: () => ref.invalidate(sessionDetailProvider(sessionId)),
        data: (session) => session == null
            ? const EmptyView(
                icon: Icons.search_off,
                title: 'Session not found',
                message: 'It may have been deleted.',
              )
            : _SessionView(session: session),
      ),
    );
  }
}

class _SessionView extends StatelessWidget {
  const _SessionView({required this.session});

  final TrackingSession session;

  @override
  Widget build(BuildContext context) {
    final route = session.route;
    final map = route.isEmpty
        ? const EmptyView(
            icon: Icons.location_off_outlined,
            title: 'No route recorded',
            message: 'No accurate positions arrived during this session.',
          )
        : _RouteMap(route: route);
    final summary = Padding(
      padding: const EdgeInsets.all(12),
      child: _SummaryCard(session: session),
    );

    return Column(
      children: [
        if (session.hadMockedLocation) const MockLocationBanner(),
        Expanded(
          child: context.isWide
              ? Row(
                  children: [
                    Expanded(child: map),
                    SizedBox(
                      width: 340,
                      child: SingleChildScrollView(child: summary),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: map),
                    summary,
                  ],
                ),
        ),
      ],
    );
  }
}

/// The whole route, zoomed to fit, with start and end pins.
class _RouteMap extends StatelessWidget {
  const _RouteMap({required this.route});

  final List<LatLng> route;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppMap(
      initialCenter: route.first,
      initialZoom: 17,
      // Bounds need two different points; a single point just centres.
      initialFit: route.toSet().length > 1
          ? CameraFit.coordinates(
              coordinates: route,
              padding: const EdgeInsets.all(48),
              maxZoom: 18,
            )
          : null,
      layers: [
        RouteLayer(routes: [route]),
        PinLayer(
          pins: [
            (point: route.first, icon: Icons.play_arrow, color: scheme.success),
            (point: route.last, icon: Icons.flag, color: scheme.error),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.session});

  final TrackingSession session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final endedAt = session.endedAt;

    return SoftSurface(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SessionStats(session: session),
            const Divider(height: 28),
            Text(
              'Started ${Formatters.dateTime(session.startedAt)}',
              style: theme.textTheme.bodyMedium,
            ),
            if (endedAt != null)
              Text(
                'Ended ${Formatters.dateTime(endedAt)}',
                style: theme.textTheme.bodyMedium,
              ),
            Text(
              'Top speed ${Formatters.speed(session.maxSpeed)} · '
              '${session.points.length} points',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
