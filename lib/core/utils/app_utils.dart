// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/utils/app_logger.dart';

class AppUtils {
  /// Abre uma URL no navegador externo.
  /// Retorna false se não conseguir abrir.
  static Future<void> launchURL(final String url, {final BuildContext? context}) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e, stack) {
      await AppLogger.log(
        level: 'error',
        message: e.toString(),
        stack: stack.toString(),
      );
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir o link: $e')),
        );
      }
      debugPrint('Erro ao abrir URL: $e');
    }
  }
}
