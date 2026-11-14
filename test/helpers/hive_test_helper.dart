import 'dart:io';

import 'package:hive_ce/hive.dart';

/// Points Hive at a fresh temporary directory for the current test.
///
/// Returns the directory so the caller can pass it to [tearDownHive].
Future<Directory> setUpHive() async {
  final directory = await Directory.systemTemp.createTemp('hive_test_');
  Hive.init(directory.path);
  return directory;
}

/// Closes every box and removes the temporary directory.
Future<void> tearDownHive(Directory directory) async {
  await Hive.close();
  if (directory.existsSync()) {
    await directory.delete(recursive: true);
  }
}
