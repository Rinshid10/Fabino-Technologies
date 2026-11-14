import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_access_security/core/errors/failures.dart';
import 'package:smart_access_security/core/utils/clock.dart';
import 'package:smart_access_security/core/utils/file_sharer.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/features/tracking/domain/services/session_exporter.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/tracking_history_controller.dart';

part 'history_export_controller.g.dart';

@riverpod
HistoryExportController historyExportController(Ref ref) {
  return HistoryExportController(ref);
}

/// Exports the tracking history to a file and shares it.
class HistoryExportController {
  const HistoryExportController(this._ref);

  final Ref _ref;

  /// Throws an [ExportFailure] when there is nothing to export or the
  /// file cannot be shared.
  Future<void> export(ExportFormat format, {Rect? origin}) async {
    final sessions = await _ref.read(trackingHistoryProvider.future);
    if (sessions.isEmpty) {
      throw const ExportFailure('There are no sessions to export.');
    }

    final now = _ref.read(clockProvider)();
    final content = const SessionExporter().export(
      sessions,
      format,
      exportedAt: now,
    );
    await _ref
        .read(fileSharerProvider)
        .shareText(
          fileName:
              'tracking_history_${Formatters.fileStamp(now)}'
              '.${format.extension}',
          content: content,
          mimeType: format.mimeType,
          origin: origin,
        );
  }
}
