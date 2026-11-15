import 'package:flutter/material.dart';
import 'package:smart_access_security/core/theme/app_theme.dart';
import 'package:smart_access_security/core/widgets/pills.dart';

/// App bar title of the main tabs: the app mark, "SMART ACCESS" and the
/// name of the screen.
class BrandTitle extends StatelessWidget {
  const BrandTitle(this.title, {super.key});

  final String title;

  /// Height an `AppBar` needs to fit this title.
  static const toolbarHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: scheme.primaryDeep,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.shield, size: 16, color: scheme.onPrimary),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: CapsLabel('Smart Access', color: scheme.primaryDeep),
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.085,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
