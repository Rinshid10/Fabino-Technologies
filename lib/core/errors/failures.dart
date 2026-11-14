/// Base type for errors that are expected and can be shown to the user.
sealed class Failure implements Exception {
  const Failure(this.message);

  /// A short, user-readable description of what went wrong.
  final String message;

  @override
  String toString() => message;
}

/// Reading from or writing to local storage failed.
final class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Could not access local storage.']);
}

/// The device location service (GPS) is switched off.
final class LocationServiceDisabledFailure extends Failure {
  const LocationServiceDisabledFailure()
    : super('Location services are turned off.');
}

/// The user has not granted location permission.
final class LocationPermissionFailure extends Failure {
  const LocationPermissionFailure({this.permanent = false})
    : super(
        permanent
            ? 'Location permission is permanently denied.'
            : 'Location permission is denied.',
      );

  /// Whether the system will no longer show the permission dialog.
  final bool permanent;
}

/// A position could not be obtained (timeout, no signal, ...).
final class LocationUnavailableFailure extends Failure {
  const LocationUnavailableFailure([
    super.message = 'Could not determine your location. Try again outdoors.',
  ]);
}

/// Exporting or sharing a file failed.
final class ExportFailure extends Failure {
  const ExportFailure([super.message = 'Could not export the data.']);
}

/// Returns a user-readable message for any error object.
String describeError(Object error) => switch (error) {
  Failure(:final message) => message,
  _ => 'Something went wrong. Please try again.',
};
