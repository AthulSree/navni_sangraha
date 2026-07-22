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
      duration: const Duration(milliseconds: 2600), // Perfect duration for sewing flow
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
    double rightShoulderX,
    double endX,
    double baseNeedleY,
    double currentNeedleY,
    double amplitude,
    double h,
  ) {
    if (x < needleX) {
      // Left side: spool to bouncing needle eye
      double ratio = (x - startX) / (needleX - startX);
      double wavePhase = (x - startX) * 0.09 - progress * 2 * pi;
      double waveAmp = amplitude * sin(ratio * pi);
      return baseNeedleY + (currentNeedleY - baseNeedleY) * ratio + waveAmp * sin(wavePhase);
    } else if (x < rightShoulderX) {
      // Neckline: needle eye to right shoulder of gown
      double ratio = (x - needleX) / (rightShoulderX - needleX);
      double neckDip = h * 0.04 * sin(ratio * pi); // Neck curve dip
      double baseLine = currentNeedleY + (baseNeedleY - currentNeedleY) * ratio;
      double wavePhase = (x - needleX) * 0.09 - progress * 2 * pi;
      double waveAmp = amplitude * 0.3 * sin(ratio * pi); // Subtle ripple along neckline
      return baseLine + neckDip + waveAmp * sin(wavePhase);
    } else {
      // Tail: hanging off right shoulder
      double ratio = (x - rightShoulderX) / (endX - rightShoulderX);
      double rightShoulderY = baseNeedleY;
      double endY = baseNeedleY + h * 0.16; // hangs down at the end
      double baseLine = rightShoulderY + (endY - rightShoulderY) * ratio;
      double wavePhase = (x - rightShoulderX) * 0.09 - progress * 2 * pi;
      double waveAmp = amplitude * 0.6 * sin((1.0 - ratio) * pi) * (1.0 - ratio * 0.5);
      return baseLine + waveAmp * sin(wavePhase);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Layout coordinates
    final double baseNeedleY = h * 0.38; // Stationary baseline eye height
    
    // Sewing machine bounce effect (needle moves up and down rapidly)
    final double needleOffset = h * 0.03 * sin(progress * 2 * pi * 4); 
    final double currentNeedleY = baseNeedleY + needleOffset;

    final double needleX = w * 0.52; // Needle positioned exactly on the left shoulder of the gown
    final double rightShoulderX = w * 0.74; // Right shoulder of the gown
    final double gownCenterX = (needleX + rightShoulderX) / 2;

    final double spoolX = w * 0.15;
    final double spoolWidth = w * 0.14; 
    final double spoolTopY = baseNeedleY - h * 0.16;
    final double spoolBottomY = baseNeedleY + h * 0.16;
    final double startX = spoolX + spoolWidth * 0.45; // Spool exit point
    final double endX = w * 0.92; // Thread tail end

    final double amplitude = h * 0.06; // Thread wave amplitude

    // 1. Draw the Gown Silhouette in the background (Fashion Sketch)
    final Path gownPath = Path();
    gownPath.moveTo(needleX, baseNeedleY); // Left shoulder
    gownPath.quadraticBezierTo(gownCenterX, baseNeedleY + h * 0.045, rightShoulderX, baseNeedleY); // Collar/Neckline
    
    // Right shoulder sleeve and armhole
    gownPath.lineTo(rightShoulderX + w * 0.025, baseNeedleY + h * 0.02);
    gownPath.quadraticBezierTo(
      rightShoulderX + w * 0.01, baseNeedleY + h * 0.12,
      rightShoulderX - w * 0.01, baseNeedleY + h * 0.20, // Waist right
    );
    
    // Skirt right side
    gownPath.quadraticBezierTo(
      rightShoulderX + w * 0.05, h * 0.65,
      rightShoulderX + w * 0.10, h * 0.85, // Hem right
    );
    
    // Curved hemline
    gownPath.quadraticBezierTo(
      gownCenterX, h * 0.88,
      needleX - w * 0.06, h * 0.85, // Hem left
    );
    
    // Skirt left side
    gownPath.quadraticBezierTo(
      needleX - w * 0.01, h * 0.65,
      needleX + w * 0.01, baseNeedleY + h * 0.20, // Waist left
    );
    
    // Left armhole and sleeve cap
    gownPath.quadraticBezierTo(
      needleX - w * 0.01, baseNeedleY + h * 0.12,
      needleX - w * 0.025, baseNeedleY + h * 0.02,
    );
    gownPath.close();
    
    // Waistband
    gownPath.moveTo(needleX + w * 0.01, baseNeedleY + h * 0.20);
    gownPath.lineTo(rightShoulderX - w * 0.01, baseNeedleY + h * 0.20);
    gownPath.moveTo(needleX + w * 0.01, baseNeedleY + h * 0.22);
    gownPath.lineTo(rightShoulderX - w * 0.01, baseNeedleY + h * 0.22);
    
    // Skirt folds / pleats
    gownPath.moveTo(gownCenterX - w * 0.03, baseNeedleY + h * 0.22);
    gownPath.quadraticBezierTo(gownCenterX - w * 0.05, h * 0.65, gownCenterX - w * 0.06, h * 0.865);
    
    gownPath.moveTo(gownCenterX, baseNeedleY + h * 0.22);
    gownPath.quadraticBezierTo(gownCenterX, h * 0.65, gownCenterX, h * 0.87);
    
    gownPath.moveTo(gownCenterX + w * 0.03, baseNeedleY + h * 0.22);
    gownPath.quadraticBezierTo(gownCenterX + w * 0.05, h * 0.65, gownCenterX + w * 0.06, h * 0.865);

    final Paint gownPaint = Paint()
      ..color = const Color(0xFFC084FC).withOpacity(0.20) // Stylized sketch lines
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(gownPath, gownPaint);

    // 2. Generate Left and Right Thread Paths
    final Path leftThreadPath = Path();
    const int leftPoints = 50;
    for (int i = 0; i <= leftPoints; i++) {
      double ratio = i / leftPoints;
      double currX = startX + (needleX - startX) * ratio;
      double currY = getThreadY(currX, startX, needleX, rightShoulderX, endX, baseNeedleY, currentNeedleY, amplitude, h);
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
      double currY = getThreadY(currX, startX, needleX, rightShoulderX, endX, baseNeedleY, currentNeedleY, amplitude, h);
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
      double sparkleY = getThreadY(sparkleX, startX, needleX, rightShoulderX, endX, baseNeedleY, currentNeedleY, amplitude, h);
      
      double fadeRatio = sin(sparkleT * pi);
      
      final Paint sparklePaint = Paint()
        ..color = Colors.white.withOpacity(fadeRatio)
        ..style = PaintingStyle.fill;
        
      final Paint sparkleGlowPaint = Paint()
        ..color = const Color(0xFFC084FC).withOpacity(0.55 * fadeRatio)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

      canvas.drawCircle(Offset(sparkleX, sparkleY), w * 0.032, sparkleGlowPaint);
      canvas.drawCircle(Offset(sparkleX, sparkleY), w * 0.013, sparklePaint);
    }

    // 3. Draw Behind Needle elements
    // - Right thread (collar + tail)
    canvas.drawPath(rightThreadPath, threadGlowPaint);
    canvas.drawPath(rightThreadPath, threadPaint);
    
    // - Behind-needle sparkles
    for (double spT in sparkleProgresses) {
      double spX = startX + (endX - startX) * spT;
      if (spX >= needleX) {
        drawSparkle(spT);
      }
    }

    // 4. Draw the Needle (bouncing vertically)
    final double needleTop = h * 0.12 + needleOffset;
    final double needleBottom = h * 0.88 + needleOffset;
    final double eyeHeight = h * 0.14;
    final double eyeWidth = w * 0.024;

    final Path needleBodyPath = Path();
    needleBodyPath.moveTo(needleX, needleBottom);
    needleBodyPath.lineTo(needleX - w * 0.008, currentNeedleY + h * 0.27);
    needleBodyPath.lineTo(needleX - w * 0.014, currentNeedleY + eyeHeight * 0.85);
    needleBodyPath.quadraticBezierTo(
      needleX - w * 0.032, currentNeedleY,
      needleX - w * 0.032, currentNeedleY - h * 0.01,
    );
    needleBodyPath.quadraticBezierTo(
      needleX - w * 0.032, needleTop,
      needleX, needleTop,
    );
    needleBodyPath.quadraticBezierTo(
      needleX + w * 0.032, needleTop,
      needleX + w * 0.032, currentNeedleY - h * 0.01,
    );
    needleBodyPath.quadraticBezierTo(
      needleX + w * 0.032, currentNeedleY,
      needleX + w * 0.014, currentNeedleY + eyeHeight * 0.85,
    );
    needleBodyPath.lineTo(needleX + w * 0.008, currentNeedleY + h * 0.27);
    needleBodyPath.close();

    final Path eyePath = Path();
    eyePath.addOval(Rect.fromCenter(
      center: Offset(needleX, currentNeedleY),
      width: eyeWidth,
      height: eyeHeight,
    ));

    final Path needleCombined = Path.combine(
      PathOperation.difference,
      needleBodyPath,
      eyePath,
    );

    // Needle drop shadow
    final needleShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(needleCombined, needleShadowPaint);

    // Needle metallic gradient
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

    // 5. Draw In Front of Needle elements
    // - Left thread (spool to needle eye)
    canvas.drawPath(leftThreadPath, threadGlowPaint);
    canvas.drawPath(leftThreadPath, threadPaint);

    // - In-front-of-needle sparkles
    for (double spT in sparkleProgresses) {
      double spX = startX + (endX - startX) * spT;
      if (spX < needleX) {
        drawSparkle(spT);
      }
    }

    // 6. Draw the Thread Spool / Roll on the left
    // Spool drop shadow
    final Paint spoolShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawRect(
      Rect.fromLTRB(spoolX - spoolWidth * 0.7, spoolTopY - h * 0.01, spoolX + spoolWidth * 0.7, spoolBottomY + h * 0.01),
      spoolShadowPaint,
    );

    // Spool axle
    final Paint spindlePaint = Paint()
      ..color = const Color(0xFFD7CCC8)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(spoolX - w * 0.015, spoolTopY - h * 0.025, spoolX + w * 0.015, spoolBottomY + h * 0.025),
      spindlePaint,
    );

    // Wooden Caps
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

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(spoolX - spoolWidth * 0.6, spoolTopY, spoolX + spoolWidth * 0.6, spoolTopY + h * 0.035),
        Radius.circular(w * 0.01),
      ),
      spoolCapPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(spoolX - spoolWidth * 0.6, spoolBottomY - h * 0.035, spoolX + spoolWidth * 0.6, spoolBottomY),
        Radius.circular(w * 0.01),
      ),
      spoolCapPaint,
    );

    // Spool Thread core
    final threadRollRect = Rect.fromLTRB(
      spoolX - spoolWidth * 0.45,
      spoolTopY + h * 0.035,
      spoolX + spoolWidth * 0.45,
      spoolBottomY - h * 0.035,
    );

    final Paint spoolThreadPaint = Paint()
      ..color = threadColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(threadRollRect, Radius.circular(w * 0.005)),
      spoolThreadPaint,
    );

    // Scrolling cross-hatch spool wraps (rotation)
    final double coreLeft = spoolX - spoolWidth * 0.45;
    final double coreRight = spoolX + spoolWidth * 0.45;
    final double coreWidth = coreRight - coreLeft;
    
    final double step = coreWidth / 5.0; 
    final double scrollOffset = progress * step * 4.0; // Fast rotation matching unwind
    
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

    final double tY = spoolTopY + h * 0.035;
    final double bY = spoolBottomY - h * 0.035;
    final double slantX = coreWidth * 0.3;

    for (int i = -3; i <= 8; i++) {
      double x = coreLeft + i * step + scrollOffset;
      
      canvas.drawLine(
        Offset(x, tY),
        Offset(x + slantX, bY),
        wrapDarkPaint,
      );
      
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