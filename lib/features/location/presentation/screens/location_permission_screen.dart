import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_access_security/core/widgets/section_header.dart';
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
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: SizedBox.square(
                      dimension: 96,
                      child: SoftSurface(
                        isCircle: true,
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Allow location access',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
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
                    FilledButton(
                      onPressed: _isRequesting ? null : _request,
                      child: const Text('Allow location access'),
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
    return SoftPanel(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: SoftIconWell(icon: icon),
        title: Text(title),
        subtitle: Text(text),
      ),
    );
  }
}
