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

  /// Buttons shown in one row at the bottom of the card.
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: CapsLabel('Current location', color: scheme.primary),
              ),
              AccuracyChip(level: fix.accuracyLevel),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            address.when(
              data: (value) => value ?? 'Address not available',
              loading: () => 'Looking up address…',
              error: (_, _) => 'Address not available',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${Formatters.accuracy(fix.accuracy)} · '
            'Updated ${Formatters.dateTime(fix.timestamp)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          InsetPanel(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _Field(
                    label: 'Latitude',
                    value: Formatters.coordinate(fix.latitude),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Field(
                    label: 'Longitude',
                    value: Formatters.coordinate(fix.longitude),
                  ),
                ),
              ],
            ),
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                for (final (index, action) in actions.indexed) ...[
                  if (index > 0) const SizedBox(width: 10),
                  Expanded(child: action),
                ],
              ],
            ),
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
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CapsLabel(label),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}
