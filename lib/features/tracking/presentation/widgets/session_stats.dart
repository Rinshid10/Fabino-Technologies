import 'package:flutter/material.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/elapsed_text.dart';
import 'package:smart_access_security/core/widgets/stat_tile.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';

/// Distance, speed and duration of a session.
///
/// For a running session pass [liveSpeed]: the row then shows the current
/// speed and a ticking duration. For a finished one it shows the average
/// speed and the final duration.
class SessionStats extends StatelessWidget {
  const SessionStats({required this.session, this.liveSpeed, super.key});

  final TrackingSession session;

  /// Current speed in metres per second, for a running session.
  final double? liveSpeed;

  @override
  Widget build(BuildContext context) {
    final liveSpeed = this.liveSpeed;
    final isLive = liveSpeed != null;

    return StatRow(
      children: [
        StatTile(
          icon: Icons.straighten,
          label: 'Distance',
          value: StatValue(Formatters.distance(session.distanceMeters)),
        ),
        StatTile(
          icon: Icons.speed,
          label: isLive ? 'Speed' : 'Avg speed',
          isAccent: true,
          value: StatValue(
            Formatters.speed(liveSpeed ?? session.averageSpeed),
          ),
        ),
        StatTile(
          icon: Icons.timer_outlined,
          label: 'Duration',
          value: isLive
              ? ElapsedText(since: session.startedAt)
              : Text(Formatters.duration(session.duration)),
        ),
      ],
    );
  }
}
