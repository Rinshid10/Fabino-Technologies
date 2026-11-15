import 'package:flutter/material.dart';
import 'package:smart_access_security/core/widgets/pills.dart';

/// App bar title of the main tabs: the app mark, "SMART ACCESS" and the
/// name of the screen.
class BrandTitle extends StatelessWidget {
  const BrandTitle(this.title, {super.key});

  final String title;

  /// Height an `AppBar` needs to fit this title.
  static const toolbarHeight = 68.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.shield, size: 22, color: scheme.onPrimary),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: CapsLabel('Smart Access', color: scheme.primary),
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
