import 'package:flutter/material.dart';
import 'dart:math';

class NeedleThreadLoader extends StatefulWidget {
  const NeedleThreadLoader({super.key});

  @override
  State<NeedleThreadLoader> createState() => _NeedleThreadLoaderState();
}

class _NeedleThreadLoaderState extends State<NeedleThreadLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400), // Fluid animation duration
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(150, 150),
          painter: NeedleThreadPainter(progress: _controller.value),
        );
      },
    );
  }
}

class NeedleThreadPainter extends CustomPainter {
  final double progress;
  NeedleThreadPainter({required this.progress});

  // Returns the y-coordinate of the thread path at any x-position
  double getThreadY(
    double x,
    double startX,
    double needleX,
    double endX,
    double needleY,
    double amplitude,
  ) {
    // A propagating wave travelling left-to-right (controlled by -progress * 2 * pi)
    if (x < needleX) {
      double ratio = (x - startX) / (needleX - startX);
      double wavePhase = (x - startX) * 0.09 - progress * 2 * pi;
      // Clamped to 0 amplitude at the spool (startX) and at the needle eye (needleX)
      double waveAmp = amplitude * sin(ratio * pi);
      return needleY + waveAmp * sin(wavePhase);
    } else {
      double ratio = (x - needleX) / (endX - needleX);
      double wavePhase = (x - needleX) * 0.09 - progress * 2 * pi;
      // Clamped to 0 amplitude at the needle eye (needleX) and at the end of the line (endX)
      double waveAmp = (amplitude * 0.7) * sin(ratio * pi);
      return needleY + waveAmp * sin(wavePhase);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Layout coordinates
    final double needleX = w * 0.58; // Shifted right to balance spool on left
    final double needleY = h * 0.38; // Eye of the needle

    final double spoolX = w * 0.15;
    final double spoolWidth = w * 0.14; // Wider spool for better rotation visibility
    final double spoolTopY = needleY - h * 0.16;
    final double spoolBottomY = needleY + h * 0.16;
    final double startX = spoolX + spoolWidth * 0.45; // Point where thread exits spool
    final double endX = w * 0.92;

    final double amplitude = h * 0.06; // Wave amplitude

    // 1. Generate Left and Right Thread Paths (Always fully extended)
    final Path leftThreadPath = Path();
    const int leftPoints = 50;
    for (int i = 0; i <= leftPoints; i++) {
      double ratio = i / leftPoints;
      double currX = startX + (needleX - startX) * ratio;
      double currY = getThreadY(currX, startX, needleX, endX, needleY, amplitude);
      if (i == 0) {
        leftThreadPath.moveTo(currX, currY);
      } else {
        leftThreadPath.lineTo(currX, currY);
      }
    }

    final Path rightThreadPath = Path();
    const int rightPoints = 50;
    for (int i = 0; i <= rightPoints; i++) {
      double ratio = i / rightPoints;
      double currX = needleX + (endX - needleX) * ratio;
      double currY = getThreadY(currX, startX, needleX, endX, needleY, amplitude);
      if (i == 0) {
        rightThreadPath.moveTo(currX, currY);
      } else {
        rightThreadPath.lineTo(currX, currY);
      }
    }

    // Paint configuration for the thread
    final threadColor = const Color(0xFF8B5CF6);
    
    final threadGlowPaint = Paint()
      ..color = threadColor.withOpacity(0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);

    final threadPaint = Paint()
      ..color = threadColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.014
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Sparkle pulse positions
    final List<double> sparkleProgresses = [
      progress,
      (progress + 0.5) % 1.0,
    ];

    void drawSparkle(double sparkleT) {
      double sparkleX = startX + (endX - startX) * sparkleT;
      double sparkleY = getThreadY(sparkleX, startX, needleX, endX, needleY, amplitude);
      
      // Sparkle fades in near the spool, reaches full brightness in the middle, and fades out near the end
      double fadeRatio = sin(sparkleT * pi);
      
      final Paint sparklePaint = Paint()
        ..color = Colors.white.withOpacity(fadeRatio)
        ..style = PaintingStyle.fill;
        
      final Paint sparkleGlowPaint = Paint()
        ..color = const Color(0xFFC084FC).withOpacity(0.55 * fadeRatio) // Light purple accent glow
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

      canvas.drawCircle(Offset(sparkleX, sparkleY), w * 0.032, sparkleGlowPaint);
      canvas.drawCircle(Offset(sparkleX, sparkleY), w * 0.013, sparklePaint);
    }

    // 2. Draw Behind Needle elements
    // - Draw the right segment of the thread
    canvas.drawPath(rightThreadPath, threadGlowPaint);
    canvas.drawPath(rightThreadPath, threadPaint);
    
    // - Draw sparkles that are past the needle eye (placed behind the needle)
    for (double spT in sparkleProgresses) {
      double spX = startX + (endX - startX) * spT;
      if (spX >= needleX) {
        drawSparkle(spT);
      }
    }

    // 3. Draw the Needle
    final double needleTop = h * 0.12;
    final double needleBottom = h * 0.88;
    final double eyeHeight = h * 0.14;
    final double eyeWidth = w * 0.024;

    final Path needleBodyPath = Path();
    needleBodyPath.moveTo(needleX, needleBottom); // Bottom tip
    // Stem left
    needleBodyPath.lineTo(needleX - w * 0.008, h * 0.65);
    // Neck left
    needleBodyPath.lineTo(needleX - w * 0.014, needleY + eyeHeight * 0.85);
    // Head left bulge
    needleBodyPath.quadraticBezierTo(
      needleX - w * 0.032, needleY,
      needleX - w * 0.032, needleY - h * 0.01,
    );
    // Head left top to top rounded cap
    needleBodyPath.quadraticBezierTo(
      needleX - w * 0.032, needleTop,
      needleX, needleTop,
    );
    // Head right top from top tip
    needleBodyPath.quadraticBezierTo(
      needleX + w * 0.032, needleTop,
      needleX + w * 0.032, needleY - h * 0.01,
    );
    // Head right bulge to neck right
    needleBodyPath.quadraticBezierTo(
      needleX + w * 0.032, needleY,
      needleX + w * 0.014, needleY + eyeHeight * 0.85,
    );
    // Stem right
    needleBodyPath.lineTo(needleX + w * 0.008, h * 0.65);
    needleBodyPath.close();

    final Path eyePath = Path();
    eyePath.addOval(Rect.fromCenter(
      center: Offset(needleX, needleY),
      width: eyeWidth,
      height: eyeHeight,
    ));

    final Path needleCombined = Path.combine(
      PathOperation.difference,
      needleBodyPath,
      eyePath,
    );

    // Subtle drop shadow behind the needle
    final needleShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(needleCombined, needleShadowPaint);

    // Metallic gradient shader for needle
    final needleShader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.95),
        Colors.grey.shade400,
        Colors.grey.shade600,
        Colors.grey.shade300,
      ],
      stops: const [0.0, 0.35, 0.7, 1.0],
    ).createShader(Rect.fromLTWH(needleX - w * 0.032, needleTop, w * 0.064, needleBottom - needleTop));

    final needlePaint = Paint()
      ..shader = needleShader
      ..style = PaintingStyle.fill;

    canvas.drawPath(needleCombined, needlePaint);

    // 4. Draw In Front of Needle elements
    // - Draw the left segment of the thread
    canvas.drawPath(leftThreadPath, threadGlowPaint);
    canvas.drawPath(leftThreadPath, threadPaint);

    // - Draw sparkles that are before the needle eye (placed in front of the needle)
    for (double spT in sparkleProgresses) {
      double spX = startX + (endX - startX) * spT;
      if (spX < needleX) {
        drawSparkle(spT);
      }
    }

    // 5. Draw the Thread Spool / Roll on the left
    
    // Spool drop shadow
    final Paint spoolShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawRect(
      Rect.fromLTRB(spoolX - spoolWidth * 0.7, spoolTopY - h * 0.01, spoolX + spoolWidth * 0.7, spoolBottomY + h * 0.01),
      spoolShadowPaint,
    );

    // Spool wooden axle / spindle in the center
    final Paint spindlePaint = Paint()
      ..color = const Color(0xFFD7CCC8)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(spoolX - w * 0.015, spoolTopY - h * 0.025, spoolX + w * 0.015, spoolBottomY + h * 0.025),
      spindlePaint,
    );

    // Wooden caps (Top and Bottom)
    final spoolCapShader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFFD7CCC8),
        const Color(0xFFA1887F),
        const Color(0xFF8D6E63),
        const Color(0xFF5D4037),
      ],
      stops: const [0.0, 0.35, 0.7, 1.0],
    ).createShader(Rect.fromLTRB(spoolX - spoolWidth * 0.6, spoolTopY - h * 0.03, spoolX + spoolWidth * 0.6, spoolBottomY + h * 0.03));

    final Paint spoolCapPaint = Paint()
      ..shader = spoolCapShader
      ..style = PaintingStyle.fill;

    // Top cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(spoolX - spoolWidth * 0.6, spoolTopY, spoolX + spoolWidth * 0.6, spoolTopY + h * 0.035),
        Radius.circular(w * 0.01),
      ),
      spoolCapPaint,
    );

    // Bottom cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(spoolX - spoolWidth * 0.6, spoolBottomY - h * 0.035, spoolX + spoolWidth * 0.6, spoolBottomY),
        Radius.circular(w * 0.01),
      ),
      spoolCapPaint,
    );

    // Thread roll (core body filled with wrapped thread)
    final threadRollRect = Rect.fromLTRB(
      spoolX - spoolWidth * 0.45,
      spoolTopY + h * 0.035,
      spoolX + spoolWidth * 0.45,
      spoolBottomY - h * 0.035,
    );

    // Draw the solid purple thread core on the spool
    final Paint spoolThreadPaint = Paint()
      ..color = threadColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(threadRollRect, Radius.circular(w * 0.005)),
      spoolThreadPaint,
    );

    // Draw slanted wraps texture that scrolls horizontally to simulate 3D rotation
    final double coreLeft = spoolX - spoolWidth * 0.45;
    final double coreRight = spoolX + spoolWidth * 0.45;
    final double coreWidth = coreRight - coreLeft;
    
    // Step between diagonal lines
    final double step = coreWidth / 5.0; // 5 lines visible at a time
    final double scrollOffset = progress * step * 4.0; // Doubled rotation speed
    
    final wrapDarkPaint = Paint()
      ..color = const Color(0xFF7C3AED).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final wrapLightPaint = Paint()
      ..color = const Color(0xFFA78BFA).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(threadRollRect, Radius.circular(w * 0.005)));

    // We draw diagonal wraps slanting forward and backward (cross-wound spool)
    // Scrolling them horizontally to the right creates the 3D spinning effect
    final double tY = spoolTopY + h * 0.035;
    final double bY = spoolBottomY - h * 0.035;
    final double slantX = coreWidth * 0.3; // horizontal displacement of the slant

    for (int i = -3; i <= 8; i++) {
      double x = coreLeft + i * step + scrollOffset;
      
      // Slanting right-downwards lines
      canvas.drawLine(
        Offset(x, tY),
        Offset(x + slantX, bY),
        wrapDarkPaint,
      );
      
      // Slanting left-downwards lines (intersecting to make a cross-hatch spool)
      canvas.drawLine(
        Offset(x + slantX, tY),
        Offset(x, bY),
        wrapLightPaint,
      );
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant NeedleThreadPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}