import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/async_value_view.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/core/widgets/state_views.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';
import 'package:smart_access_security/features/tracking/presentation/widgets/history_actions.dart';

/// All saved tracking sessions, newest first.
class TrackingHistoryScreen extends ConsumerWidget {
  const TrackingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(trackingHistoryProvider);
    final hasSessions = history.value?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking history'),
        actions: [if (hasSessions) const HistoryActions()],
      ),
      body: AsyncValueView(
        value: history,
        onRetry: () => ref.invalidate(trackingHistoryProvider),
        data: (sessions) => sessions.isEmpty
            ? const EmptyView(
                icon: Icons.route_outlined,
                title: 'No sessions yet',
                message: 'Finished tracking sessions appear here.',
              )
            : ContentWidth(
                child: ListView.separated(
                  itemCount: sessions.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) =>
                      SessionListTile(session: sessions[index]),
                ),
              ),
      ),
    );
  }
}

/// One row of the history list.
class SessionListTile extends StatelessWidget {
  const SessionListTile({required this.session, super.key});

  final TrackingSession session;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: const Icon(Icons.route_outlined),
      title: Text(Formatters.dateTime(session.startedAt)),
      subtitle: Text(
        '${Formatters.distance(session.distanceMeters)} · '
        '${Formatters.duration(session.duration)}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (session.hadMockedLocation)
            Tooltip(
              message: 'Mock location was detected',
              child: Icon(Icons.warning_amber_rounded, color: scheme.error),
            ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => context.push(Routes.sessionDetail(session.id)),
    );
  }
}
