import 'package:flutter_riverpod/misc.dart';
import 'package:smart_access_security/core/storage/hive_boxes.dart';

/// Prepares everything that must exist before the first frame and returns
/// the provider overrides that expose it to the app.
Future<List<Override>> bootstrap() async {
  final boxes = await HiveBoxes.initAndOpen();
  return [hiveBoxesProvider.overrideWithValue(boxes)];
}
