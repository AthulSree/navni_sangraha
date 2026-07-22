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
      duration: const Duration(milliseconds: 3200),
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

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    
    // Layout coordinates
    final double needleX = w * 0.58; // Shifted right to balance spool on left
    final double needleY = h * 0.38; // Eye of the needle
    
    final double spoolX = w * 0.15;
    final double spoolTopY = needleY - h * 0.16;
    final double spoolBottomY = needleY + h * 0.16;
    final double startX = spoolX + w * 0.045; // Point where thread exits spool
    
    double endX = w * 0.92;
    double tipX = startX;
    
    double threadOpacity = 1.0;
    
    // Map progress (0.0 to 1.0) into phases:
    // Phase 1 (0.0 -> 0.15): Thread enters from spool, tipX goes from startX to startX + (needleX - startX) * 0.4.
    // Phase 2 (0.15 -> 0.50): Aiming / wiggling, tipX goes from startX + (needleX - startX) * 0.4 to needleX - w * 0.03. Tip shakes up/down.
    // Phase 3 (0.50 -> 0.70): Threading through, tipX goes from needleX - w * 0.03 to needleX + w * 0.20.
    // Phase 4 (0.70 -> 0.90): Pulling thread through, tipX goes from needleX + w * 0.20 to endX.
    // Phase 5 (0.90 -> 1.00): Fade out.
    
    final double startToAimThreshold = startX + (needleX - startX) * 0.4;
    final double aimToNeedleThreshold = needleX - w * 0.03;
    final double throughNeedleThreshold = needleX + w * 0.20;
    
    if (progress < 0.15) {
      double t = progress / 0.15;
      tipX = startX + (startToAimThreshold - startX) * t;
      threadOpacity = 1.0;
    } else if (progress < 0.50) {
      double t = (progress - 0.15) / 0.35;
      tipX = startToAimThreshold + (aimToNeedleThreshold - startToAimThreshold) * t;
      threadOpacity = 1.0;
    } else if (progress < 0.70) {
      double t = (progress - 0.50) / 0.20;
      tipX = aimToNeedleThreshold + (throughNeedleThreshold - aimToNeedleThreshold) * t;
      threadOpacity = 1.0;
    } else if (progress < 0.90) {
      double t = (progress - 0.70) / 0.20;
      tipX = throughNeedleThreshold + (endX - throughNeedleThreshold) * t;
      threadOpacity = 1.0;
    } else {
      double t = (progress - 0.90) / 0.10;
      threadOpacity = 1.0 - t;
      tipX = endX;
    }
    
    final Path leftThreadPath = Path();
    final Path rightThreadPath = Path();
    
    final double amplitude = h * 0.06; // Wave amplitude (height)
    
    if (tipX < needleX) {
      // Tip hasn't reached the needle eye yet.
      double tipY = needleY;
      if (progress >= 0.15 && progress < 0.50) {
        // Aiming / wiggling phase
        double wiggleFreq = 5.0; // number of cycles
        double wigglePhase = (progress - 0.15) / 0.35 * wiggleFreq * 2 * pi;
        tipY = needleY + (h * 0.07) * sin(wigglePhase);
      } else if (progress < 0.15) {
        // Entering phase
        double wiggleFreq = 1.5;
        double wigglePhase = (progress / 0.15) * wiggleFreq * 2 * pi;
        tipY = needleY + (h * 0.04) * sin(wigglePhase);
      }
      
      int pointsCount = 45;
      for (int i = 0; i <= pointsCount; i++) {
        double ratio = i / pointsCount;
        double currX = startX + (tipX - startX) * ratio;
        
        // Propagating wave that clamps to 0 amplitude at startX, and goes to tipY at tipX
        double wavePhase = (currX - startX) * 0.08 - progress * 2 * pi * 3;
        double waveAmp = amplitude * sin(ratio * pi / 2); // Damp at start
        double currY = startX == tipX 
            ? needleY 
            : needleY + (tipY - needleY) * ratio + waveAmp * sin(wavePhase) * (1.0 - ratio);
        
        if (i == 0) {
          leftThreadPath.moveTo(currX, currY);
        } else {
          leftThreadPath.lineTo(currX, currY);
        }
      }
    } else {
      // Thread has entered/passed the needle eye (tipX >= needleX).
      // Left path from startX to needleX
      int leftPoints = 45;
      for (int i = 0; i <= leftPoints; i++) {
        double ratio = i / leftPoints;
        double currX = startX + (needleX - startX) * ratio;
        
        // Propagating wave that is 0 at both startX and needleX
        double wavePhase = (currX - startX) * 0.08 - progress * 2 * pi * 3;
        double waveAmp = amplitude * sin(ratio * pi); // 0 at both ends
        double currY = needleY + waveAmp * sin(wavePhase);
        
        if (i == 0) {
          leftThreadPath.moveTo(currX, currY);
        } else {
          leftThreadPath.lineTo(currX, currY);
        }
      }
      
      // Right path from needleX to tipX
      double tipY = needleY + (h * 0.025) * sin(progress * 2 * pi * 2);
      int rightPoints = 45;
      for (int i = 0; i <= rightPoints; i++) {
        double ratio = i / rightPoints;
        double currX = needleX + (tipX - needleX) * ratio;
        
        // Propagating wave starting from 0 amplitude at needleX and damping towards tipY
        double wavePhase = (currX - needleX) * 0.08 - progress * 2 * pi * 3;
        double waveAmp = amplitude * sin((1.0 - ratio) * pi) * ratio;
        double currY = tipX == needleX
            ? needleY
            : needleY + (tipY - needleY) * ratio + waveAmp * sin(wavePhase);
        
        if (i == 0) {
          rightThreadPath.moveTo(currX, currY);
        } else {
          rightThreadPath.lineTo(currX, currY);
        }
      }
    }
    
    // Define Paint objects for the thread
    final threadColor = const Color(0xFF8B5CF6).withOpacity(threadOpacity);
    
    final threadGlowPaint = Paint()
      ..color = threadColor.withOpacity(0.22 * threadOpacity)
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
      
    // 1. Draw Right Thread Path (Behind the needle)
    if (tipX >= needleX) {
      canvas.drawPath(rightThreadPath, threadGlowPaint);
      canvas.drawPath(rightThreadPath, threadPaint);
    }
    
    // 2. Draw the Needle
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
    
    // Subtle shadow behind the needle
    final needleShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawPath(needleCombined, needleShadowPaint);
    
    // Metallic shader for needle
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
    
    // 3. Draw Left Thread Path (In front of the needle)
    canvas.drawPath(leftThreadPath, threadGlowPaint);
    canvas.drawPath(leftThreadPath, threadPaint);
    
    // 4. Draw the Thread Spool / Roll on the left
    final double spoolWidth = w * 0.10;
    
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
      ..color = const Color(0xFF8B5CF6)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(threadRollRect, Radius.circular(w * 0.005)),
      spoolThreadPaint,
    );

    // Draw horizontal wraps texture
    final wrapDarkPaint = Paint()
      ..color = const Color(0xFF7C3AED).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    final wrapLightPaint = Paint()
      ..color = const Color(0xFFA78BFA).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      
    final double textureStartY = spoolTopY + h * 0.035 + 2.0;
    final double textureEndY = spoolBottomY - h * 0.035 - 2.0;
    final int linesCount = 12;
    final double step = (textureEndY - textureStartY) / linesCount;
    for (int i = 0; i <= linesCount; i++) {
      double y = textureStartY + i * step;
      canvas.drawLine(
        Offset(spoolX - spoolWidth * 0.45, y),
        Offset(spoolX + spoolWidth * 0.45, y),
        i % 2 == 0 ? wrapDarkPaint : wrapLightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NeedleThreadPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}