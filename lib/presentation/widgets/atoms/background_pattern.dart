import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BackgroundPattern extends StatelessWidget {
  final Widget child;

  const BackgroundPattern({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Animated Blobs
        Positioned(
          top: -100,
          left: -100,
          child:
              ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple.withOpacity(0.15),
                      ),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: Offset(1, 1),
                    end: Offset(1.5, 1.5),
                    duration: 4.seconds,
                  )
                  .move(
                    begin: Offset(0, 0),
                    end: Offset(50, 50),
                    duration: 5.seconds,
                  ),
        ),

        Positioned(
          bottom: -50,
          right: -50,
          child:
              ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.15),
                      ),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: Offset(1, 1),
                    end: Offset(1.2, 1.2),
                    duration: 3.seconds,
                  )
                  .move(
                    begin: Offset(0, 0),
                    end: Offset(-30, -30),
                    duration: 4.seconds,
                  ),
        ),

        // Padrão de Pontos Customizado
        Positioned.fill(
          child: CustomPaint(
            painter: DotGridPainter(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.03),
              spacing: 40,
            ),
          ),
        ),
        // O conteúdo da página vai por cima
        child,
      ],
    );
  }
}

class DotGridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  DotGridPainter({required this.color, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
