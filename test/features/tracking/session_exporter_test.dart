import 'dart:convert';
import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_access_security/core/errors/failures.dart';
import 'package:smart_access_security/core/utils/clock.dart';
import 'package:smart_access_security/core/utils/file_sharer.dart';
import 'package:smart_access_security/features/tracking/data/tracking_repository_impl.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';
import 'package:smart_access_security/features/tracking/domain/repositories/tracking_repository.dart';
import 'package:smart_access_security/features/tracking/domain/services/session_exporter.dart';
import 'package:smart_access_security/features/tracking/presentation/controllers/history_export_controller.dart';

class _FakeFileSharer implements FileSharer {
  String? fileName;
  String? content;
  String? mimeType;

  @override
  Future<void> shareText({
    required String fileName,
    required String content,
    required String mimeType,
    Rect? origin,
  }) async {
    this.fileName = fileName;
    this.content = content;
    this.mimeType = mimeType;
  }
}

class _FixedTrackingRepository implements TrackingRepository {
  _FixedTrackingRepository(this.sessions);

  final List<TrackingSession> sessions;

  @override
  Future<List<TrackingSession>> getAll() async => sessions;

  @override
  Future<TrackingSession?> getById(String id) async => null;

  @override
  Future<void> save(TrackingSession session) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> clear() async {}
}

void main() {
  const exporter = SessionExporter();
  final start = DateTime.utc(2026, 11, 14, 10);

  final walk = TrackingSession(
    id: 'walk',
    startedAt: start,
    endedAt: start.add(const Duration(minutes: 5)),
    distanceMeters: 321.44,
    maxSpeed: 2.5,
    hadMockedLocation: true,
    points: [
      TrackPoint(
        latitude: 12.5,
        longitude: 77.25,
        accuracy: 6,
        speed: 1.25,
        timestamp: start,
      ),
      TrackPoint(
        latitude: 12.75,
        longitude: 77.5,
        accuracy: 8,
        speed: 2.5,
        timestamp: start.add(const Duration(minutes: 5)),
      ),
    ],
  );
  final empty = TrackingSession(
    id: 'empty',
    startedAt: start,
    endedAt: start.add(const Duration(minutes: 1)),
  );

  group('CSV', () {
    test('has a header and one row per point', () {
      final rows = Csv(lineDelimiter: '\n').decode(exporter.toCsv([walk]));

      expect(rows.first, SessionExporter.csvHeader);
      expect(rows, hasLength(3));
      expect(rows[1].take(2), ['walk', '2026-11-14T10:00:00.000Z']);
      expect(rows[1][3].toString(), '321.4');
      expect(rows[1][5].toString(), 'true');
      expect(rows[2][6].toString(), '1');
      expect(rows[2][7].toString(), '12.75');
    });

    test('a session without points still gets a row', () {
      final rows = Csv(lineDelimiter: '\n').decode(exporter.toCsv([empty]));

      expect(rows, hasLength(2));
      expect(rows[1].first, 'empty');
    });

    test('no sessions gives only the header', () {
      final rows = Csv(lineDelimiter: '\n').decode(exporter.toCsv([]));

      expect(rows, [SessionExporter.csvHeader]);
    });
  });

  test('JSON round-trips back to the same sessions', () {
    final text = exporter.toJson([walk, empty], exportedAt: start);
    final json = jsonDecode(text) as Map<String, dynamic>;

    expect(json['exportedAt'], '2026-11-14T10:00:00.000Z');
    expect(json['sessionCount'], 2);
    final sessions = (json['sessions'] as List)
        .cast<Map<String, dynamic>>()
        .map(TrackingSession.fromJson);
    expect(sessions, [walk, empty]);
  });

  group('HistoryExportController', () {
    ProviderContainer containerWith(
      List<TrackingSession> sessions,
      _FakeFileSharer sharer,
    ) {
      final container = ProviderContainer(
        overrides: [
          trackingRepositoryProvider.overrideWithValue(
            _FixedTrackingRepository(sessions),
          ),
          fileSharerProvider.overrideWithValue(sharer),
          clockProvider.overrideWithValue(() => DateTime(2026, 11, 14, 9, 5)),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('shares a timestamped file in the chosen format', () async {
      final sharer = _FakeFileSharer();
      final container = containerWith([walk], sharer);

      await container
          .read(historyExportControllerProvider)
          .export(ExportFormat.json);

      expect(sharer.fileName, 'tracking_history_20261114_090500.json');
      expect(sharer.mimeType, 'application/json');
      expect(sharer.content, contains('"id": "walk"'));
    });

    test('refuses to export an empty history', () async {
      final sharer = _FakeFileSharer();
      final container = containerWith([], sharer);

      await expectLater(
        container
            .read(historyExportControllerProvider)
            .export(ExportFormat.csv),
        throwsA(isA<ExportFailure>()),
      );
      expect(sharer.fileName, isNull);
    });
  });
}
