import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable HireHub logo — briefcase with a subtle checkmark spark.
/// [size] controls the container dimension; everything scales from it.
class HireHubLogo extends StatelessWidget {
  final double size;
  final bool showLabel;

  const HireHubLogo({super.key, this.size = 72, this.showLabel = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(size * 0.26),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: 0.45),
                blurRadius: size * 0.5,
                offset: Offset(0, size * 0.12),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _BriefcasePainter(size: size),
          ),
        ),
        if (showLabel) ...[
          SizedBox(height: size * 0.18),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Hire',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: size * 0.28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                TextSpan(
                  text: 'Hub',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: size * 0.28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _BriefcasePainter extends CustomPainter {
  final double size;
  const _BriefcasePainter({required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final w = canvasSize.width;
    final h = canvasSize.height;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.072
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ── Briefcase body ────────────────────────────────
    final bodyL = w * 0.17;
    final bodyT = h * 0.36;
    final bodyR = w * 0.83;
    final bodyB = h * 0.78;
    final r = w * 0.08;

    final bodyPath = Path()
      ..addRRect(RRect.fromLTRBR(bodyL, bodyT, bodyR, bodyB, Radius.circular(r)));
    canvas.drawPath(bodyPath, paint);

    // ── Handle / top clasp ────────────────────────────
    final handleL = w * 0.36;
    final handleR = w * 0.64;
    final handleT = h * 0.22;
    final handleB = h * 0.36;
    final handlePath = Path()
      ..moveTo(handleL, handleB)
      ..lineTo(handleL, handleT + w * 0.06)
      ..arcToPoint(
        Offset(handleL + w * 0.06, handleT),
        radius: Radius.circular(w * 0.06),
      )
      ..lineTo(handleR - w * 0.06, handleT)
      ..arcToPoint(
        Offset(handleR, handleT + w * 0.06),
        radius: Radius.circular(w * 0.06),
      )
      ..lineTo(handleR, handleB);
    canvas.drawPath(handlePath, paint);

    // ── Center divider line ───────────────────────────
    canvas.drawLine(
      Offset(bodyL, h * 0.56),
      Offset(bodyR, h * 0.56),
      paint..strokeWidth = w * 0.055,
    );

    // ── Checkmark spark (top-right corner) ────────────
    final sparkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.068
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final ckPath = Path()
      ..moveTo(w * 0.60, h * 0.60)
      ..lineTo(w * 0.67, h * 0.68)
      ..lineTo(w * 0.78, h * 0.52);
    canvas.drawPath(ckPath, sparkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
