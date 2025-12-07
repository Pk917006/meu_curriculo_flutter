// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../models/certificate_model.dart';
import '../models/experience_model.dart';
import '../models/project_model.dart';
import '../models/skill_model.dart';
import 'portfolio_repository.dart';

class SupabaseRepository implements IPortfolioRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // --- AUTH ---
  Future<bool> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      log('Erro login: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  bool get isAuthenticated => _client.auth.currentUser != null;

  // --- CRUD GENÉRICO (Para evitar repetição) ---

  // Create
  Future<void> createItem(String table, Map<String, dynamic> data) async {
    await _client.from(table).insert(data);
  }

  // Update
  Future<void> updateItem(
    String table,
    int id,
    Map<String, dynamic> data,
  ) async {
    await _client.from(table).update(data).eq('id', id);
  }

  // Delete
  Future<void> deleteItem(String table, int id) async {
    await _client.from(table).delete().eq('id', id);
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    try {
      final response = await _client
          .from('projects')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map(
            (e) => ProjectModel.fromMap(e),
          ) // Certifique-se que ProjectModel tem o método fromMap
          .toList();
    } catch (e) {
      // Em caso de erro, retorna lista vazia ou lança exceção
      log('Erro ao buscar projetos: $e');
      return [];
    }
  }

  @override
  Future<List<ExperienceModel>> getExperiences() async {
    try {
      final response = await _client
          .from('experiences')
          .select()
          .order('start_date', ascending: false);

      return (response as List)
          .map(
            (e) => ExperienceModel.fromMap(e),
          ) // Certifique-se que ExperienceModel tem fromMap
          .toList();
    } catch (e) {
      log('Erro ao buscar experiências: $e');
      return [];
    }
  }

  @override
  Future<List<SkillModel>> getSkills() async {
    try {
      final response = await _client
          .from('skills')
          .select()
          .order('created_at', ascending: true);

      return (response as List)
          .map(
            (e) => SkillModel.fromMap(e),
          ) // Certifique-se que SkillModel tem fromMap
          .toList();
    } catch (e) {
      log('Erro ao buscar skills: $e');
      return [];
    }
  }

  @override
  Future<List<CertificateModel>> getCertificates() async {
    try {
      final response = await _client
          .from('certificates') // Nome da tabela que criamos
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => CertificateModel.fromMap(e))
          .toList();
    } catch (e) {
      // Log de erro para ajudar no debug
      log('Erro ao buscar certificados: $e');
      return [];
    }
  }
}
