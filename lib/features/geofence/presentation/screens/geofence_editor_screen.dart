import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';
import 'package:smart_access_security/core/notifications/notification_service.dart';
import 'package:smart_access_security/core/utils/clock.dart';
import 'package:smart_access_security/core/utils/formatters.dart';
import 'package:smart_access_security/core/widgets/app_map.dart';
import 'package:smart_access_security/core/widgets/async_value_view.dart';
import 'package:smart_access_security/core/widgets/responsive.dart';
import 'package:smart_access_security/core/widgets/state_views.dart';
import 'package:smart_access_security/features/geofence/domain/entities/geofence.dart';
import 'package:smart_access_security/features/geofence/presentation/controllers/geofence_list_controller.dart';
import 'package:smart_access_security/features/geofence/presentation/geofence_labels.dart';
import 'package:smart_access_security/features/geofence/presentation/widgets/geofence_layer.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_providers.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_status_controller.dart';
import 'package:smart_access_security/features/location/presentation/location_labels.dart';
import 'package:uuid/uuid.dart';

/// Create a geofence, or edit the one with [geofenceId].
class GeofenceEditorScreen extends ConsumerWidget {
  const GeofenceEditorScreen({this.geofenceId, super.key});

  /// `null` when creating a new geofence.
  final String? geofenceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = geofenceId;
    return Scaffold(
      appBar: AppBar(
        title: Text(id == null ? 'New geofence' : 'Edit geofence'),
      ),
      body: id == null
          ? const _GeofenceForm()
          : AsyncValueView(
              value: ref.watch(geofenceListControllerProvider),
              onRetry: () => ref.invalidate(geofenceListControllerProvider),
              data: (geofences) {
                final existing = geofences.where((g) => g.id == id).firstOrNull;
                return existing == null
                    ? const EmptyView(
                        icon: Icons.search_off,
                        title: 'Geofence not found',
                        message: 'It may have been deleted.',
                      )
                    : _GeofenceForm(existing: existing);
              },
            ),
    );
  }
}

class _GeofenceForm extends ConsumerStatefulWidget {
  const _GeofenceForm({this.existing});

  final Geofence? existing;

  @override
  ConsumerState<_GeofenceForm> createState() => _GeofenceFormState();
}

class _GeofenceFormState extends ConsumerState<_GeofenceForm> {
  /// Shown until the user's position is known or a centre is picked.
  static const _worldCenter = LatLng(20, 0);

  final _formKey = GlobalKey<FormState>();
  final _mapController = MapController();
  late final TextEditingController _name;
  late double _radius;
  LatLng? _center;
  LatLng? _userPosition;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _name = TextEditingController(text: existing?.name);
    _radius = existing?.radiusMeters ?? GeofenceLimits.defaultRadius;
    _center = existing?.center;
    if (existing == null) unawaited(_showUserPosition());
  }

  @override
  void dispose() {
    _name.dispose();
    _mapController.dispose();
    super.dispose();
  }

  /// For a new geofence, start the map at the user's position when it can
  /// be read without asking for anything.
  Future<void> _showUserPosition() async {
    try {
      final status = await ref.read(locationStatusControllerProvider.future);
      if (!status.isReady) return;
      final fix = await ref.read(currentLocationProvider.future);
      if (!mounted) return;
      setState(() => _userPosition = fix.latLng);
      if (_center == null) _mapController.move(fix.latLng, 16);
    } on Exception {
      // Without a position the user simply pans the map by hand.
    }
  }

  Future<void> _save() async {
    final center = _center;
    if (!(_formKey.currentState?.validate() ?? false) || center == null) {
      return;
    }
    setState(() => _isSaving = true);

    final existing = widget.existing;
    final geofence = Geofence(
      id: existing?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      latitude: center.latitude,
      longitude: center.longitude,
      radiusMeters: _radius,
      createdAt: existing?.createdAt ?? ref.read(clockProvider)(),
      // Presence starts over: the shape may have changed.
    );
    await ref.read(geofenceListControllerProvider.notifier).save(geofence);
    // Entry / exit alerts need notification permission; ask in context.
    await ref.read(notificationServiceProvider).requestPermission();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final center = _center;
    final userPosition = _userPosition;

    final map = Stack(
      children: [
        AppMap(
          controller: _mapController,
          initialCenter: center ?? _worldCenter,
          initialZoom: center == null ? 2 : 15,
          onTap: (point) => setState(() => _center = point),
          onLongPress: (point) => setState(() => _center = point),
          layers: [
            if (center != null)
              GeofenceLayer(
                circles: [
                  (center: center, radiusMeters: _radius, label: null),
                ],
              ),
            if (userPosition != null) PositionLayer(point: userPosition),
          ],
        ),
        if (center == null)
          const Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: _MapHint('Tap or long-press the map to place the geofence'),
          ),
      ],
    );

    final form = Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _name,
              maxLength: 40,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Home, Office, School…',
                counterText: '',
              ),
              validator: (value) => (value ?? '').trim().isEmpty
                  ? 'Give the geofence a name.'
                  : null,
            ),
            const SizedBox(height: 16),
            Text('Radius: ${Formatters.distance(_radius)}'),
            Slider(
              value: _radius,
              min: GeofenceLimits.minRadius,
              max: GeofenceLimits.maxRadius,
              // 50 m steps.
              divisions:
                  (GeofenceLimits.maxRadius - GeofenceLimits.minRadius) ~/ 50,
              label: Formatters.distance(_radius),
              onChanged: (value) => setState(() => _radius = value),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: center == null || _isSaving ? null : _save,
              child: Text(
                center == null ? 'Pick a place on the map' : 'Save geofence',
              ),
            ),
          ],
        ),
      ),
    );

    if (context.isWide) {
      return Row(
        children: [
          Expanded(child: map),
          SizedBox(width: 360, child: SingleChildScrollView(child: form)),
        ],
      );
    }
    return Column(
      children: [
        Expanded(child: map),
        SafeArea(top: false, child: form),
      ],
    );
  }
}

class _MapHint extends StatelessWidget {
  const _MapHint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.inverseSurface,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onInverseSurface),
        ),
      ),
    );
  }
}
