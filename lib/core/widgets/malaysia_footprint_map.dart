import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Static, locally drawn map used by the frontend prototype.
/// It makes the footprint feature tangible without a map SDK or network data.
class MalaysiaFootprintMap extends StatelessWidget {
  const MalaysiaFootprintMap({super.key, this.showLabels = true});

  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MalaysiaFootprintPainter(showLabels: showLabels),
      child: const SizedBox.expand(),
    );
  }
}

class _MalaysiaFootprintPainter extends CustomPainter {
  const _MalaysiaFootprintPainter({required this.showLabels});

  final bool showLabels;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFB8DFE2),
    );

    final terrain = Paint()..color = const Color(0xFFDDE8CE);
    final peninsula = Path()
      ..moveTo(size.width * .31, size.height * .06)
      ..cubicTo(
        size.width * .48,
        size.height * .03,
        size.width * .60,
        size.height * .19,
        size.width * .55,
        size.height * .32,
      )
      ..cubicTo(
        size.width * .51,
        size.height * .43,
        size.width * .65,
        size.height * .53,
        size.width * .53,
        size.height * .72,
      )
      ..cubicTo(
        size.width * .47,
        size.height * .83,
        size.width * .36,
        size.height * .91,
        size.width * .26,
        size.height * .83,
      )
      ..cubicTo(
        size.width * .15,
        size.height * .67,
        size.width * .17,
        size.height * .44,
        size.width * .20,
        size.height * .31,
      )
      ..cubicTo(
        size.width * .21,
        size.height * .19,
        size.width * .23,
        size.height * .10,
        size.width * .31,
        size.height * .06,
      )
      ..close();
    canvas.drawPath(peninsula, terrain);

    final borneo = Path()
      ..moveTo(size.width * .71, size.height * .43)
      ..cubicTo(
        size.width * .87,
        size.height * .34,
        size.width * .98,
        size.height * .48,
        size.width * .92,
        size.height * .67,
      )
      ..cubicTo(
        size.width * .88,
        size.height * .79,
        size.width * .70,
        size.height * .83,
        size.width * .66,
        size.height * .67,
      )
      ..cubicTo(
        size.width * .62,
        size.height * .57,
        size.width * .65,
        size.height * .48,
        size.width * .71,
        size.height * .43,
      )
      ..close();
    canvas.drawPath(borneo, terrain);

    final hills = Paint()
      ..color = const Color(0xFFB8D0B1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .31, size.height * .15)
        ..cubicTo(
          size.width * .42,
          size.height * .30,
          size.width * .26,
          size.height * .45,
          size.width * .43,
          size.height * .71,
        ),
      hills,
    );

    final road = Paint()
      ..color = const Color(0xAAFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (final path in _roadPaths(size)) {
      canvas.drawPath(path, road);
    }

    _marker(
      canvas,
      Offset(size.width * .19, size.height * .15),
      'Langkawi',
      AppColors.amber,
    );
    _marker(
      canvas,
      Offset(size.width * .29, size.height * .27),
      'Penang',
      AppColors.terracotta,
    );
    _marker(
      canvas,
      Offset(size.width * .42, size.height * .51),
      'Kuala Lumpur',
      AppColors.sage,
    );
    _marker(
      canvas,
      Offset(size.width * .40, size.height * .68),
      'Melaka',
      AppColors.terracotta,
    );
    _marker(
      canvas,
      Offset(size.width * .78, size.height * .59),
      'Sabah',
      AppColors.sage,
    );
  }

  List<Path> _roadPaths(Size size) => [
    Path()
      ..moveTo(size.width * .24, size.height * .22)
      ..cubicTo(
        size.width * .35,
        size.height * .32,
        size.width * .35,
        size.height * .46,
        size.width * .42,
        size.height * .68,
      ),
    Path()
      ..moveTo(size.width * .19, size.height * .29)
      ..cubicTo(
        size.width * .37,
        size.height * .30,
        size.width * .48,
        size.height * .33,
        size.width * .55,
        size.height * .41,
      ),
    Path()
      ..moveTo(size.width * .71, size.height * .49)
      ..cubicTo(
        size.width * .78,
        size.height * .58,
        size.width * .87,
        size.height * .64,
        size.width * .93,
        size.height * .70,
      ),
  ];

  void _marker(Canvas canvas, Offset point, String label, Color color) {
    canvas.drawCircle(
      point,
      11,
      Paint()..color = AppColors.parchment.withValues(alpha: .92),
    );
    canvas.drawCircle(point, 7, Paint()..color = color);
    canvas.drawCircle(point, 2.5, Paint()..color = Colors.white);
    if (showLabels) {
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Color(0xFF355A60),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      painter.paint(canvas, point + const Offset(12, -5));
    }
  }

  @override
  bool shouldRepaint(covariant _MalaysiaFootprintPainter oldDelegate) =>
      oldDelegate.showLabels != showLabels;
}
