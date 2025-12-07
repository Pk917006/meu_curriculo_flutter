// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroOverlay extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onFinished;

  const IntroOverlay({
    super.key,
    required this.isLoading,
    required this.onFinished,
  });

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay> {
  final List<String> _logs = [];
  final List<String> _allLogs = [
    "Carregando módulos do sistema...",
    "Conectando ao servidor neural...",
    "Otimizando shaders...",
    "Compilando experiência...",
    "Carregando portfólio...",
    "Verificando integridade...",
    "Acesso autorizado.",
  ];

  Timer? _logTimer;
  bool _isExiting = false;
  bool _showAccessGranted = false;

  @override
  void initState() {
    super.initState();
    _startLogs();
  }

  @override
  void didUpdateWidget(covariant IntroOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se terminou de carregar e não estamos saindo ainda, iniciar saída
    if (oldWidget.isLoading && !widget.isLoading && !_isExiting) {
      _startExitSequence();
    }
  }

  @override
  void dispose() {
    _logTimer?.cancel();
    super.dispose();
  }

  void _startLogs() {
    int index = 0;
    _logTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (index < _allLogs.length) {
        setState(() {
          _logs.add(_allLogs[index]);
          // Manter apenas os últimos 5 logs
          if (_logs.length > 5) _logs.removeAt(0);
        });
        index++;
      } else {
        timer.cancel();
        // Se os logs acabaram e já carregou, sair.
        if (!widget.isLoading && !_isExiting) {
          _startExitSequence();
        }
      }
    });
  }

  void _startExitSequence() async {
    if (_isExiting) return;

    // Aguarda um pouco para mostrar "Acesso Autorizado" ou similar se quiser
    setState(() {
      _showAccessGranted = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isExiting = true;
      });

      // Tempo da animação de saída (slide das cortinas)
      await Future.delayed(const Duration(milliseconds: 1000));
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        // === CORTINA SUPERIOR ===
        AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutExpo,
          top: _isExiting ? -size.height / 2 : 0,
          left: 0,
          right: 0,
          height: size.height / 2,
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                // Grid decorativo
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPainter(
                      color: primaryColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                // Conteúdo Central (Parte de Cima)
                if (!_isExiting)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                                FontAwesomeIcons.code,
                                size: 60,
                                color: primaryColor,
                              )
                              .animate(onPlay: (c) => c.repeat())
                              .shimmer(duration: 2.seconds, color: Colors.white)
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.1, 1.1),
                                duration: 1.seconds,
                                curve: Curves.easeInOut,
                              )
                              .then()
                              .scale(
                                begin: const Offset(1.1, 1.1),
                                end: const Offset(1, 1),
                                duration: 1.seconds,
                              ),
                          const SizedBox(height: 20),
                          Text(
                            "SYSTEM INITIALIZATION",
                            style: TextStyle(
                              fontFamily: 'Code',
                              color: primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // === CORTINA INFERIOR ===
        AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutExpo,
          bottom: _isExiting ? -size.height / 2 : 0,
          left: 0,
          right: 0,
          height: size.height / 2,
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                // Grid decorativo
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPainter(
                      color: primaryColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                // Conteúdo Central (Parte de Baixo)
                if (!_isExiting)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Barra de Progresso
                          if (!_showAccessGranted)
                            SizedBox(
                              width: 200,
                              child: LinearProgressIndicator(
                                backgroundColor: primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                                color: primaryColor,
                              ),
                            )
                          else
                            Text(
                              "ACCESS GRANTED",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.green.withValues(alpha: 0.8),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ).animate().fadeIn().scale(
                              duration: 400.ms,
                              curve: Curves.easeOutBack,
                            ),

                          const SizedBox(height: 30),

                          // Logs do Terminal
                          SizedBox(
                            height: 120,
                            child: Column(
                              children: _logs.map((log) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    "> $log",
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      color: primaryColor.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                ).animate().fadeIn().slideX(
                                  begin: -0.1,
                                  end: 0,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Linha divisória central (some ao abrir)
        if (!_isExiting)
          Center(
            child: Container(
              height: 2,
              width: double.infinity,
              color: primaryColor.withValues(alpha: 0.5),
            ).animate().scaleX(duration: 1.seconds, curve: Curves.easeOut),
          ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;

  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
