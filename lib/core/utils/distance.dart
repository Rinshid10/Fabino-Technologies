import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'distance.g.dart';

/// Returns the distance in metres between two coordinates.
///
/// Domain code depends on this function type instead of on the location
/// plugin, which keeps it pure and easy to test.
typedef DistanceCalculator =
    double Function(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
    );

@Riverpod(keepAlive: true)
DistanceCalculator distanceCalculator(Ref ref) => Geolocator.distanceBetween;
