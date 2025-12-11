// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AppLogger {
  static Future<void> log({
    required final String level,
    required final String message,
    final String? stack,
    final String? userId,
  }) async {
    try {
      // Se não passar userId, tenta pegar o usuário autenticado
      final currentUserId = userId ?? supabase.auth.currentUser?.id;

      await supabase.from('app_logs').insert({
        'level': level,
        'message': message,
        'stack': stack,
        'user_id': currentUserId,
      });
    } catch (e) {
      // evita que falha no logging quebre o app
      // Use apenas print em dev, em produção considere remover ou usar serviço externo
      print('⚠️ Erro ao gravar log no Supabase: $e');
    }
  }

  // Métodos auxiliares para facilitar o uso
  static Future<void> info(final String message, {final String? stack}) async {
    await log(level: 'info', message: message, stack: stack);
  }

  static Future<void> debug(final String message, {final String? stack}) async {
    await log(level: 'debug', message: message, stack: stack);
  }

  static Future<void> error(final String message, {final String? stack}) async {
    await log(level: 'error', message: message, stack: stack);
  }

  static Future<void> warning(final String message, {final String? stack}) async {
    await log(level: 'warning', message: message, stack: stack);
  }
}
