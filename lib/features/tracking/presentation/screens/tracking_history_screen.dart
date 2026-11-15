import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/router/routes.dart';
import 'package:smart_access_security/core/widgets/async_value_view.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/core/widgets/section_header.dart';
import 'package:smart_access_security/core/widgets/state_views.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';
import 'package:smart_access_security/features/tracking/presentation/widgets/history_actions.dart';
import 'package:smart_access_security/features/tracking/presentation/widgets/history_summary_card.dart';

/// A summary of everything recorded, then all saved sessions, newest
/// first.
class TrackingHistoryScreen extends ConsumerWidget {
  const TrackingHistoryScreen({super.key});

  static const _gutter = EdgeInsets.symmetric(horizontal: 20);

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
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  // The summary and the heading come before the sessions.
                  itemCount: sessions.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: _gutter,
                        child: HistorySummaryCard(sessions: sessions),
                      );
                    }
                    if (index == 1) {
                      return const SectionHeader('Recorded sessions');
                    }
                    final session = sessions[index - 2];
                    return Padding(
                      padding: _gutter.add(const EdgeInsets.only(bottom: 14)),
                      child: SessionCard(
                        session: session,
                        onTap: () =>
                            context.push(Routes.sessionDetail(session.id)),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
