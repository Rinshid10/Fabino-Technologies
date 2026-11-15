import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/widgets/pills.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';
import 'package:smart_access_security/features/location/domain/entities/location_status.dart';
import 'package:smart_access_security/features/location/presentation/controllers/location_status_controller.dart';

/// Explains why location is needed BEFORE the system dialog is shown, so
/// the user understands the request and is more likely to make an
/// informed choice.
class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  ConsumerState<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends ConsumerState<LocationPermissionScreen> {
  bool _isRequesting = false;
  bool _isBlocked = false;

  Future<void> _request() async {
    setState(() => _isRequesting = true);
    final controller = ref.read(locationStatusControllerProvider.notifier);
    final permission = await controller.requestPermission();
    if (!mounted) return;

    if (permission.isGranted) {
      context.pop();
      return;
    }
    setState(() {
      _isRequesting = false;
      _isBlocked = permission == LocationPermissionStatus.deniedForever;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ref.read(locationStatusControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Location access')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Hero(),
                  const SizedBox(height: 16),
                  Text(
                    'Allow location access',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 26,
                      height: 32 / 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.65,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your location is used on this device only. Nothing is '
                    'uploaded.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const _Reason(
                    icon: Icons.map_outlined,
                    title: 'See where you are',
                    text: 'Show your position and address on the map.',
                  ),
                  const _Reason(
                    icon: Icons.route_outlined,
                    title: 'Record your routes',
                    text: 'Track distance, speed and path during a session.',
                  ),
                  const _Reason(
                    icon: Icons.radar_outlined,
                    title: 'Geofence alerts',
                    text: 'Get notified when you enter or leave your zones.',
                  ),
                  const _Reason(
                    icon: Icons.phonelink_lock_outlined,
                    title: 'Stays on this device',
                    text: 'Your location is never uploaded anywhere.',
                  ),
                  const SizedBox(height: 24),
                  if (_isBlocked) ...[
                    Text(
                      'Location was permanently denied. Allow it from the '
                      'app settings, then come back.',
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: controller.openAppSettings,
                      child: const Text('Open app settings'),
                    ),
                  ] else
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryDeep,
                      ),
                      onPressed: _isRequesting ? null : _request,
                      icon: const Icon(Icons.location_on_outlined),
                      label: const Text('Allow location access'),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Not now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Reason extends StatelessWidget {
  const _Reason({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SoftSurface(
        radius: 12,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            SoftIconWell(icon: icon),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    text,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The picture at the top: a shield inside two soft rings.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget ring(double size, double alpha, {Widget? child}) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.primary.withValues(alpha: alpha),
        ),
        child: child,
      );
    }

    return SoftSurface(
      radius: 12,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ring(
            176,
            0.05,
            child: ring(
              152,
              0.1,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.primary, scheme.primaryDeep],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primaryDeep.withValues(alpha: 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                      spreadRadius: -3,
                    ),
                  ],
                ),
                child: Icon(Icons.shield, size: 30, color: scheme.onPrimary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          StatusPill(label: 'Works 100% offline', color: scheme.success),
        ],
      ),
    );
  }
}
