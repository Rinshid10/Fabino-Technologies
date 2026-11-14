import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/features/location/domain/entities/location_fix.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/location/presentation/location_labels.dart';

/// Latitude, longitude, accuracy and address of one [LocationFix].
class LocationDetailsCard extends ConsumerWidget {
  const LocationDetailsCard({required this.fix, super.key});

  final LocationFix fix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final address = ref.watch(
      addressProvider(
        latitude: roundForAddress(fix.latitude),
        longitude: roundForAddress(fix.longitude),
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: 'Latitude',
                    value: Formatters.coordinate(fix.latitude),
                  ),
                ),
                Expanded(
                  child: _Field(
                    label: 'Longitude',
                    value: Formatters.coordinate(fix.longitude),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: 'Accuracy',
                    value: Formatters.accuracy(fix.accuracy),
                  ),
                ),
                AccuracyChip(level: fix.accuracyLevel),
              ],
            ),
            const SizedBox(height: 12),
            _Field(
              label: 'Address',
              value: address.when(
                data: (value) => value ?? 'Address not available',
                loading: () => 'Looking up address…',
                error: (_, _) => 'Address not available',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Updated ${Formatters.dateTime(fix.timestamp)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
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
    final color = switch (level) {
      AccuracyLevel.good => scheme.success,
      AccuracyLevel.fair => scheme.warning,
      AccuracyLevel.poor => scheme.error,
    };
    return Chip(
      avatar: Icon(Icons.gps_fixed, size: 16, color: color),
      label: Text(level.label),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      side: BorderSide(color: color),
      visualDensity: VisualDensity.compact,
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
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
