import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_access_security/core/constants/app_constants.dart';
import 'package:smart_access_security/core/storage/hive_boxes.dart';
import 'package:smart_access_security/core/storage/secure_store.dart';
import 'package:smart_access_security/features/auth/presentation/controllers/app_lock_controller.dart';

/// Prepares everything that must exist before the first frame and returns
/// the provider overrides that expose it to the app.
Future<List<Override>> bootstrap() async {
  final boxes = await HiveBoxes.initAndOpen();
  const secureStore = FlutterSecureStore(FlutterSecureStorage());

  await _resetSecureStoreOnFreshInstall(boxes.settings, secureStore);
  final hasPin = await secureStore.read(StorageKeys.pinCredential) != null;

  return [
    hiveBoxesProvider.overrideWithValue(boxes),
    secureStoreProvider.overrideWithValue(secureStore),
    pinConfiguredAtStartupProvider.overrideWithValue(hasPin),
  ];
}

/// The iOS keychain survives uninstalling the app, while app files do not.
/// Without this, a reinstall would start with an old PIN and no data.
Future<void> _resetSecureStoreOnFreshInstall(
  Box<String> settingsBox,
  SecureStore secureStore,
) async {
  if (settingsBox.containsKey(StorageKeys.installMarker)) return;
  await secureStore.delete(StorageKeys.pinCredential);
  await secureStore.delete(StorageKeys.authStatus);
  await settingsBox.put(StorageKeys.installMarker, 'installed');
}
