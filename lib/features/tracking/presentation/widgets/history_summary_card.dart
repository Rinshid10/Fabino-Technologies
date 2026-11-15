import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/pills.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';
import 'package:smart_access_security/features/tracking/domain/entities/tracking_session.dart';

/// Total recorded distance and a bar for each of the last seven days.
class HistorySummaryCard extends StatelessWidget {
  const HistorySummaryCard({required this.sessions, this.now, super.key});

  final List<TrackingSession> sessions;

  /// The current time; only tests need to set it.
  final DateTime? now;

  static const _dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  /// Metres recorded on each of the seven days that end on [today],
  /// oldest first.
  static List<double> distancePerDay(
    List<TrackingSession> sessions,
    DateTime today,
  ) {
    final lastDay = DateUtils.dateOnly(today);
    final totals = List<double>.filled(7, 0);
    for (final session in sessions) {
      final day = DateUtils.dateOnly(session.startedAt.toLocal());
      final daysAgo = lastDay.difference(day).inHours ~/ 24;
      if (daysAgo >= 0 && daysAgo < 7) {
        totals[6 - daysAgo] += session.distanceMeters;
      }
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final today = now ?? DateTime.now();
    final perDay = distancePerDay(sessions, today);
    final longestDay = perDay.reduce((a, b) => a > b ? a : b);
    final total = sessions.fold<double>(
      0,
      (sum, session) => sum + session.distanceMeters,
    );
    final count = sessions.length;

    return SoftSurface(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(child: CapsLabel('Total recorded distance')),
              StatusPill(
                label: count == 1 ? '1 session' : '$count sessions',
                color: scheme.success,
                uppercase: false,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.distance(total),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 14),
          InsetPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CapsLabel('Last 7 days'),
                const SizedBox(height: 12),
                Semantics(
                  label:
                      '${Formatters.distance(perDay.fold(0, (a, b) => a + b))} '
                      'in the last 7 days',
                  child: ExcludeSemantics(
                    child: SizedBox(
                      height: 78,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (final (index, meters) in perDay.indexed)
                            Expanded(
                              child: _DayBar(
                                // Monday is weekday 1.
                                letter:
                                    _dayLetters[(today.weekday + index) % 7],
                                fraction: longestDay == 0
                                    ? 0
                                    : meters / longestDay,
                                isToday: index == 6,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayBar extends StatelessWidget {
  const _DayBar({
    required this.letter,
    required this.fraction,
    required this.isToday,
  });

  final String letter;

  /// Height of the bar from 0 (nothing recorded) to 1 (the longest day).
  final double fraction;
  final bool isToday;

  static const _maxHeight = 52.0;
  static const _minHeight = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 10,
          height: _minHeight + (_maxHeight - _minHeight) * fraction,
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: fraction == 0
                ? scheme.primary.withValues(alpha: 0.18)
                : scheme.primary.withValues(alpha: isToday ? 1 : 0.75),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          letter,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isToday ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// One saved session: when it was, its numbers and a sketch of the route.
class SessionCard extends StatelessWidget {
  const SessionCard({required this.session, required this.onTap, super.key});

  final TrackingSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SoftPressable(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: session.hadMockedLocation
                      ? scheme.error
                      : scheme.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  Formatters.dateTime(session.startedAt),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (session.hadMockedLocation)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Tooltip(
                    message: 'Mock location was detected',
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 20,
                      color: scheme.error,
                    ),
                  ),
                ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Number(
                  label: 'Distance',
                  value: Formatters.distance(session.distanceMeters),
                ),
              ),
              Expanded(
                child: _Number(
                  label: 'Duration',
                  value: Formatters.duration(session.duration),
                ),
              ),
              Expanded(
                child: _Number(
                  label: 'Avg speed',
                  value: Formatters.speed(session.averageSpeed),
                ),
              ),
              const SizedBox(width: 8),
              InsetPanel(
                padding: const EdgeInsets.all(8),
                radius: 14,
                child: SizedBox.square(
                  dimension: 38,
                  child: CustomPaint(
                    painter: _RouteSketchPainter(
                      points: [
                        for (final point in session.points)
                          Offset(point.longitude, -point.latitude),
                      ],
                      line: scheme.primary,
                      start: scheme.success,
                      end: scheme.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Number extends StatelessWidget {
  const _Number({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

/// Draws a route scaled to fit the box, with a dot at each end.
class _RouteSketchPainter extends CustomPainter {
  const _RouteSketchPainter({
    required this.points,
    required this.line,
    required this.start,
    required this.end,
  });

  /// Route points with x to the east and y to the south, in any unit.
  final List<Offset> points;
  final Color line;
  final Color start;
  final Color end;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    var bounds = Rect.fromPoints(points.first, points.first);
    for (final point in points) {
      bounds = bounds.expandToInclude(Rect.fromPoints(point, point));
    }
    const inset = 4.0;
    final longestSide = bounds.longestSide;
    final scale = longestSide == 0
        ? 0.0
        : (size.shortestSide - inset * 2) / longestSide;
    Offset place(Offset point) =>
        size.center(Offset.zero) + (point - bounds.center) * scale;

    final path = Path()..moveTo(place(points.first).dx, place(points.first).dy);
    for (final point in points.skip(1)) {
      path.lineTo(place(point).dx, place(point).dy);
    }
    canvas
      ..drawPath(
        path,
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawCircle(place(points.first), 3, Paint()..color = start)
      ..drawCircle(place(points.last), 3, Paint()..color = end);
  }

  @override
  bool shouldRepaint(_RouteSketchPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.line != line ||
        oldDelegate.start != start ||
        oldDelegate.end != end;
  }
}
