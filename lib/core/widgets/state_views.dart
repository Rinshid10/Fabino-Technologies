import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/soft_surface.dart';

/// Centred progress indicator with an optional label.
class LoadingView extends StatelessWidget {
  const LoadingView({this.label, super.key});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (label != null) ...[
            const SizedBox(height: 16),
            Text(label!, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

/// Icon, title, message and an optional action. Base for empty and error
/// states so they look the same on every screen.
class MessageView extends StatelessWidget {
  const MessageView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: 96,
                child: SoftSurface(
                  isCircle: true,
                  child: Icon(
                    icon,
                    size: 40,
                    color: iconColor ?? theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 20),
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown when a list or screen has nothing to display yet.
class EmptyView extends StatelessWidget {
  const EmptyView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: icon,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

/// Shown when loading data failed.
class ErrorView extends StatelessWidget {
  const ErrorView({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: Icons.error_outline,
      iconColor: Theme.of(context).colorScheme.error,
      title: 'Something went wrong',
      message: message,
      actionLabel: 'Try again',
      onAction: onRetry,
    );
  }
}
