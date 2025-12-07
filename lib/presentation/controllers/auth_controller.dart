// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../data/repositories/supabase_repository.dart';

class AuthController extends ChangeNotifier {
  final SupabaseRepository repository;

  AuthController(this.repository);

  bool get isLogged => repository.isAuthenticated;

  Future<bool> login(String email, String pass) async {
    final success = await repository.signIn(email, pass);
    if (success) notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await repository.signOut();
    notifyListeners();
  }
}
