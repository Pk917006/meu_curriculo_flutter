// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

class MagneticElement extends StatefulWidget {
  final Widget child;
  final double strength; // Força da repulsão

  const MagneticElement({required this.child, super.key, this.strength = 1.0});

  @override
  State<MagneticElement> createState() => _MagneticElementState();
}

class _MagneticElementState extends State<MagneticElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _targetPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    // Animação contínua para "flutuar" suavemente quando o mouse não está perto
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePosition(final PointerEvent details, final Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final mousePos = details.localPosition;
    final distance = (mousePos - center).distance;

    // Física de Repulsão: Quanto mais perto o mouse, mais longe o elemento vai
    if (distance < 150) {
      final direction = (center - mousePos).direction;
      final moveDistance = (150 - distance) * widget.strength * 0.5;
      setState(() {
        _targetPosition = Offset(
          math.cos(direction) * moveDistance,
          math.sin(direction) * moveDistance,
        );
      });
    } else {
      setState(() {
        _targetPosition = Offset.zero;
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    // Interpolação suave (Lerp) para o movimento não ser travado
    _currentPosition =
        Offset.lerp(_currentPosition, _targetPosition, 0.1) ?? Offset.zero;

    return MouseRegion(
      onHover: (final details) => _updatePosition(details, context.size ?? Size.zero),
      onExit: (_) => setState(() => _targetPosition = Offset.zero),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (final context, final child) {
          // Adiciona um movimento de "respiração" (flutuar) aleatório
          final floatY = math.sin(_controller.value * 2 * math.pi) * 5;

          return Transform.translate(
            offset: _currentPosition + Offset(0, floatY),
            child: widget.child,
          );
        },
      ),
    );
  }
}
