import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/errors/failures.dart';
import 'package:smart_access_security/core/widgets/confirm_dialog.dart';
import 'package:smart_access_security/features/tracking/domain/services/session_exporter.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/history_export_controller.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';

enum _HistoryAction { exportCsv, exportJson, clear }

/// Overflow menu of the history screen: export and clear.
class HistoryActions extends ConsumerWidget {
  const HistoryActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_HistoryAction>(
      onSelected: (action) => switch (action) {
        _HistoryAction.exportCsv => _export(context, ref, ExportFormat.csv),
        _HistoryAction.exportJson => _export(context, ref, ExportFormat.json),
        _HistoryAction.clear => confirmClearHistory(context, ref),
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _HistoryAction.exportCsv,
          child: ListTile(
            leading: Icon(Icons.table_chart_outlined),
            title: Text('Export as CSV'),
          ),
        ),
        PopupMenuItem(
          value: _HistoryAction.exportJson,
          child: ListTile(
            leading: Icon(Icons.data_object),
            title: Text('Export as JSON'),
          ),
        ),
        PopupMenuDivider(),
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

  Future<void> _export(
    BuildContext context,
    WidgetRef ref,
    ExportFormat format,
  ) async {
    // The share popover on iPad is anchored to the menu button.
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    try {
      await ref
          .read(historyExportControllerProvider)
          .export(format, origin: origin);
    } on Failure catch (failure) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
    }
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
