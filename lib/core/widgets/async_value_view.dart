import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_access_security/core/errors/failures.dart';
import 'package:smart_access_security/core/widgets/state_views.dart';

/// Renders an [AsyncValue] with consistent loading and error states.
///
/// Screens only supply the [data] builder (and [onRetry] where a retry makes
/// sense), so loading / error handling is never forgotten or duplicated.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.onRetry,
    this.loadingLabel,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => LoadingView(label: loadingLabel),
      error: (error, _) =>
          ErrorView(message: describeError(error), onRetry: onRetry),
    );
  }
}
