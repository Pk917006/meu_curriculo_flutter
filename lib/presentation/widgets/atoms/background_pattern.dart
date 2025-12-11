// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';

class BackgroundPattern extends StatefulWidget {
  final Widget child;

  const BackgroundPattern({required this.child, super.key});

  @override
  State<BackgroundPattern> createState() => _BackgroundPatternState();
}

class _BackgroundPatternState extends State<BackgroundPattern> {
  final ValueNotifier<Offset> _mousePos = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _mousePos.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onHover: (final details) {
        _mousePos.value = details.position;
      },
      child: Stack(
        children: [
          // Animated Blobs com Parallax
          ValueListenableBuilder<Offset>(
            valueListenable: _mousePos,
            builder: (final context, final mouse, _) {
              // Fator de movimento (quanto menor, mais sutil)
              final moveX = (mouse.dx / MediaQuery.of(context).size.width) * 50;
              final moveY =
                  (mouse.dy / MediaQuery.of(context).size.height) * 50;

              return Stack(
                children: [
                  // Blob 1 (Roxo)
                  Positioned(
                    top: -100 - moveY,
                    left: -100 - moveX,
                    child:
                        ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 80,
                                sigmaY: 80,
                              ),
                              child: Container(
                                width: 400,
                                height: 400,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.purple.withValues(alpha: 0.15),
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (final controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.5, 1.5),
                              duration: 4.seconds,
                            ),
                  ),

                  // Blob 2 (Azul)
                  Positioned(
                    bottom: -50 + moveY,
                    right: -50 + moveX,
                    child:
                        ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 80,
                                sigmaY: 80,
                              ),
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withValues(alpha: 0.15),
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (final controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.2, 1.2),
                              duration: 3.seconds,
                            ),
                  ),
                ],
              );
            },
          ),

          // Padrão de Pontos Customizado
          Positioned.fill(
            child: CustomPaint(
              painter: DotGridPainter(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
                spacing: 40,
              ),
            ),
          ),
          // O conteúdo da página vai por cima
          widget.child,
        ],
      ),
    );
  }
}

class DotGridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  DotGridPainter({required this.color, required this.spacing});

  @override
  void paint(final Canvas canvas, final Size size) {
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
  bool shouldRepaint(covariant final CustomPainter oldDelegate) => false;
}
