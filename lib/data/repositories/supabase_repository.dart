import 'package:supabase_flutter/supabase_flutter.dart';
import 'portfolio_repository.dart';
import '../models/project_model.dart';
import '../models/experience_model.dart';
import '../models/skill_model.dart';
import '../models/certificate_model.dart';
import 'dart:developer';

class SupabaseRepository implements IPortfolioRepository {
  final SupabaseClient _client = Supabase.instance.client;

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
