// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_export_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(historyExportController)
final historyExportControllerProvider = HistoryExportControllerProvider._();

final class HistoryExportControllerProvider
    extends
        $FunctionalProvider<
          HistoryExportController,
          HistoryExportController,
          HistoryExportController
        >
    with $Provider<HistoryExportController> {
  HistoryExportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyExportControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyExportControllerHash();

  @$internal
  @override
  $ProviderElement<HistoryExportController> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HistoryExportController create(Ref ref) {
    return historyExportController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HistoryExportController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HistoryExportController>(value),
    );
  }
}

String _$historyExportControllerHash() =>
    r'51982b5a180575a2322020d00b249a7e01a04e94';
