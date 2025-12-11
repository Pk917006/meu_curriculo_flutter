// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:meu_curriculo_flutter/data/repositories/supabase_repository.dart';

class AuthController extends ChangeNotifier {
  final SupabaseRepository repository;

  AuthController(this.repository) {
    // Verifica se já existe uma sessão ativa ao inicializar
    _checkSession();
  }

  bool get isLogged => repository.isAuthenticated;

  // Verifica a sessão existente
  void _checkSession() {
    // O Supabase automaticamente restaura a sessão se houver uma válida
    if (repository.isAuthenticated) {
      notifyListeners();
    }
  }

  Future<bool> login(final String email, final String pass) async {
    final success = await repository.signIn(email, pass);
    if (success) notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await repository.signOut();
    notifyListeners();
  }
}
