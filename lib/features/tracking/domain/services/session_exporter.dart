import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';

/// File formats the tracking history can be exported to.
enum ExportFormat {
  csv(extension: 'csv', mimeType: 'text/csv'),
  json(extension: 'json', mimeType: 'application/json')
  ;

  const ExportFormat({required this.extension, required this.mimeType});

  final String extension;
  final String mimeType;
}

/// Turns tracking sessions into CSV or JSON text. Pure: no file access.
class SessionExporter {
  const SessionExporter();

  static const csvHeader = [
    'session_id',
    'session_started_at',
    'session_ended_at',
    'session_distance_m',
    'session_max_speed_mps',
    'mock_location_detected',
    'point_index',
    'latitude',
    'longitude',
    'accuracy_m',
    'speed_mps',
    'timestamp',
  ];

  String export(
    List<TrackingSession> sessions,
    ExportFormat format, {
    required DateTime exportedAt,
  }) {
    return switch (format) {
      ExportFormat.csv => toCsv(sessions),
      ExportFormat.json => toJson(sessions, exportedAt: exportedAt),
    };
  }

  /// One row per recorded point. A session without points still gets one
  /// row, so it is not silently missing from the file.
  String toCsv(List<TrackingSession> sessions) {
    final rows = <List<Object?>>[csvHeader];
    for (final session in sessions) {
      final summary = <Object?>[
        session.id,
        session.startedAt.toIso8601String(),
        session.endedAt?.toIso8601String() ?? '',
        session.distanceMeters.toStringAsFixed(1),
        session.maxSpeed.toStringAsFixed(2),
        session.hadMockedLocation,
      ];
      if (session.points.isEmpty) {
        rows.add([...summary, '', '', '', '', '', '']);
        continue;
      }
      for (final (index, point) in session.points.indexed) {
        rows.add([
          ...summary,
          index,
          point.latitude,
          point.longitude,
          point.accuracy.toStringAsFixed(1),
          point.speed.toStringAsFixed(2),
          point.timestamp.toIso8601String(),
        ]);
      }
    }
    return Csv(lineDelimiter: '\n').encode(rows);
  }

  String toJson(
    List<TrackingSession> sessions, {
    required DateTime exportedAt,
  }) {
    return const JsonEncoder.withIndent('  ').convert({
      'exportedAt': exportedAt.toIso8601String(),
      'sessionCount': sessions.length,
      'sessions': [for (final session in sessions) session.toJson()],
    });
  }
}
