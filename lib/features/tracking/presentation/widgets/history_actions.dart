import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/widgets/confirm_dialog.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';

enum _HistoryAction { clear }

/// Overflow menu of the history screen.
class HistoryActions extends ConsumerWidget {
  const HistoryActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_HistoryAction>(
      onSelected: (action) => switch (action) {
        _HistoryAction.clear => confirmClearHistory(context, ref),
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _HistoryAction.clear,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Clear history'),
          ),
        ),
      ],
    );
  }
}

/// Asks for confirmation, then deletes every saved session.
Future<void> confirmClearHistory(BuildContext context, WidgetRef ref) async {
  final confirmed = await showConfirmDialog(
    context,
    title: 'Clear history?',
    message: 'All saved tracking sessions will be deleted permanently.',
    confirmLabel: 'Clear',
    destructive: true,
  );
  if (!confirmed) return;
  await ref.read(trackingHistoryProvider.notifier).clear();
  if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tracking history cleared.')));
  }
}
