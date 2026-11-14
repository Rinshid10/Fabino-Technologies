import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/widgets/confirm_dialog.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/geofence/presentation/controllers/geofence_list_controller.dart';

/// Asks for confirmation, then deletes [geofence].
/// Returns whether it was deleted.
Future<bool> confirmDeleteGeofence(
  BuildContext context,
  WidgetRef ref,
  Geofence geofence,
) async {
  final confirmed = await showConfirmDialog(
    context,
    title: 'Delete geofence?',
    message: '"${geofence.name}" will be deleted permanently.',
    confirmLabel: 'Delete',
    destructive: true,
  );
  if (!confirmed) return false;
  await ref.read(geofenceListControllerProvider.notifier).delete(geofence.id);
  return true;
}

/// Asks for confirmation, then deletes every geofence.
Future<void> confirmClearGeofences(BuildContext context, WidgetRef ref) async {
  final confirmed = await showConfirmDialog(
    context,
    title: 'Clear geofences?',
    message: 'All geofences will be deleted permanently.',
    confirmLabel: 'Clear',
    destructive: true,
  );
  if (!confirmed) return;
  await ref.read(geofenceListControllerProvider.notifier).clear();
  if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Geofences cleared.')));
  }
}
