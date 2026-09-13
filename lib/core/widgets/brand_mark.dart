import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ScreenPadding extends StatelessWidget {
  const ScreenPadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: child,
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false, this.showSubtitle = false});

  final bool compact;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 42.0 : 68.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.parchment,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.line, width: 1.4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x122C2623),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.explore_rounded,
            color: AppColors.terracottaDark,
            size: compact ? 23 : 35,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 12),
          const Text(
            'Roam',
            style: TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              fontFamily: 'serif',
            ),
          ),
        ] else if (showSubtitle) ...[
          const SizedBox(width: 9),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Roam',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              Text(
                'Hub',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class RoamWordmark extends StatelessWidget {
  const RoamWordmark({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) => Text(
    'ROAM',
    style: TextStyle(
      color: AppColors.ink,
      fontSize: size,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.2,
    ),
  );
}
