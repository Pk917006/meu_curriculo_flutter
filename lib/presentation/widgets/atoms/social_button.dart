// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String url;
  final Color? color;

  const SocialButton({
    required this.icon, required this.url, super.key,
    this.color,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(final BuildContext context) {
    return IconButton(
          onPressed: _launchUrl,
          icon: FaIcon(icon, size: 28),
          style: IconButton.styleFrom(
            foregroundColor: color ?? Theme.of(context).colorScheme.primary,
            hoverColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
          ),
        )
        .animate(onPlay: (final controller) => controller.repeat(reverse: true))
        .scaleXY(
          end: 1.1,
          duration: 1.seconds,
          curve: Curves.easeInOut,
        ) // Efeito "respirando" suave
        .animate(target: 1) // Reinicia animação para interação
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.2, 1.2),
          duration: 200.ms,
        ); // Efeito ao clicar/hover (simulado)
  }
}
