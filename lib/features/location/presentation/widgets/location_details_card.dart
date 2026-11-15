import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/pills.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/location/presentation/location_labels.dart';

/// Address, latitude, longitude and accuracy of one [LocationFix], with
/// optional [actions] underneath.
class LocationDetailsCard extends ConsumerWidget {
  const LocationDetailsCard({
    required this.fix,
    this.actions = const [],
    super.key,
  });

  final LocationFix fix;

  /// Buttons stacked at the bottom of the card.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final address = ref.watch(
      addressProvider(
        latitude: roundForAddress(fix.latitude),
        longitude: roundForAddress(fix.longitude),
      ),
    );

    return SoftSurface(
      radius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CapsLabel('Current location', color: scheme.primaryDeep),
                    Text(
                      address.when(
                        data: (value) => value ?? 'Address not available',
                        loading: () => 'Looking up address…',
                        error: (_, _) => 'Address not available',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                        height: 22 / 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.085,
                      ),
                    ),
                    Text(
                      '${Formatters.accuracy(fix.accuracy)} · '
                      'Updated ${Formatters.dateTime(fix.timestamp)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AccuracyChip(level: fix.accuracyLevel),
            ],
          ),
          const SizedBox(height: 8),
          InsetPanel(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: _Field(
                    icon: Icons.swap_vert,
                    label: 'Latitude',
                    value: Formatters.coordinate(fix.latitude),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Field(
                    icon: Icons.swap_horiz,
                    label: 'Longitude',
                    value: Formatters.coordinate(fix.longitude),
                  ),
                ),
              ],
            ),
          ),
          for (final action in actions) ...[
            const SizedBox(height: 8),
            action,
          ],
        ],
      ),
    );
  }
}

/// Coloured good / fair / poor label for a position's accuracy.
class AccuracyChip extends StatelessWidget {
  const AccuracyChip({required this.level, super.key});

  final AccuracyLevel level;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return StatusPill(
      label: '${level.label} accuracy',
      uppercase: false,
      color: switch (level) {
        AccuracyLevel.good => scheme.success,
        AccuracyLevel.fair => scheme.warning,
        AccuracyLevel.poor => scheme.error,
      },
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: context.depth.card,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: scheme.primaryDeep),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontSize: 10,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.24,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
