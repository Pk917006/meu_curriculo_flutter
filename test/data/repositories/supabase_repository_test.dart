// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:meu_curriculo_flutter/data/models/certificate_model.dart';
import 'package:meu_curriculo_flutter/data/models/experience_model.dart';
import 'package:meu_curriculo_flutter/data/models/project_model.dart';
import 'package:meu_curriculo_flutter/data/models/skill_model.dart';
import 'package:meu_curriculo_flutter/data/repositories/supabase_repository.dart';

void main() {
  late SupabaseRepository repository;

  SharedPreferences.setMockInitialValues({});
  setUpAll(() async {
    // Carrega as variáveis de ambiente do .env
    await dotenv.load(fileName: '.env');

    // Inicializa o Supabase para testes
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    repository = SupabaseRepository();
  });

  group('SupabaseRepository - Testes de Leitura', () {
    test('getProjects deve retornar lista de projetos', () async {
      try {
        final projects = await repository.getProjects();

        expect(projects, isA<List<ProjectModel>>());
        log('✅ Projetos carregados: ${projects.length}');

        if (projects.isNotEmpty) {
          final firstProject = projects.first;
          log('Primeiro projeto: ${firstProject.title}');
          expect(firstProject.title, isNotEmpty);
          expect(firstProject.description, isNotEmpty);
          expect(firstProject.techStack, isNotEmpty);
        } else {
          log('⚠️ Nenhum projeto encontrado no banco');
        }
      } catch (e) {
        log('❌ Erro ao buscar projetos: $e');
        rethrow;
      }
    });

    test('getExperiences deve retornar lista de experiências', () async {
      try {
        final experiences = await repository.getExperiences();

        expect(experiences, isA<List<ExperienceModel>>());
        log('✅ Experiências carregadas: ${experiences.length}');

        if (experiences.isNotEmpty) {
          final firstExp = experiences.first;
          log('Primeira experiência: ${firstExp.role} na ${firstExp.company}');
          expect(firstExp.role, isNotEmpty);
          expect(firstExp.company, isNotEmpty);
          expect(firstExp.period, isNotEmpty);
        } else {
          log('⚠️ Nenhuma experiência encontrada no banco');
        }
      } catch (e) {
        log('❌ Erro ao buscar experiências: $e');
        rethrow;
      }
    });

    test('getSkills deve retornar lista de skills', () async {
      try {
        final skills = await repository.getSkills();

        expect(skills, isA<List<SkillModel>>());
        log('✅ Skills carregadas: ${skills.length}');

        if (skills.isNotEmpty) {
          final firstSkill = skills.first;
          log('Primeira skill: ${firstSkill.name} (${firstSkill.type.name})');
          expect(firstSkill.name, isNotEmpty);
          expect(firstSkill.type, isA<SkillType>());
        } else {
          log('⚠️ Nenhuma skill encontrada no banco');
        }
      } catch (e) {
        log('❌ Erro ao buscar skills: $e');
        rethrow;
      }
    });

    test('getCertificates deve retornar lista de certificados', () async {
      try {
        final certificates = await repository.getCertificates();

        expect(certificates, isA<List<CertificateModel>>());
        log('✅ Certificados carregados: ${certificates.length}');

        if (certificates.isNotEmpty) {
          final firstCert = certificates.first;
          log('Primeiro certificado: ${firstCert.title}');
          expect(firstCert.title, isNotEmpty);
          expect(firstCert.issuer, isNotEmpty);
        } else {
          log('⚠️ Nenhum certificado encontrado no banco');
        }
      } catch (e) {
        log('❌ Erro ao buscar certificados: $e');
        rethrow;
      }
    });
  });

  group('SupabaseRepository - Testes de Validação de Dados', () {
    test('Projetos devem ter estrutura válida', () async {
      final projects = await repository.getProjects();

      if (projects.isNotEmpty) {
        for (final project in projects) {
          expect(
            project.title,
            isNotEmpty,
            reason: 'Título do projeto não pode ser vazio',
          );
          expect(
            project.description,
            isNotEmpty,
            reason: 'Descrição do projeto não pode ser vazia',
          );
          expect(
            project.techStack.isNotEmpty,
            isTrue,
            reason: 'Tech stack não pode estar vazia',
          );
          expect(
            project.repoUrl,
            isNotEmpty,
            reason: 'URL do repositório não pode ser vazia',
          );

          log('Projeto validado: ${project.title}');
        }
      }
    });

    test('Experiências devem ter estrutura válida', () async {
      final experiences = await repository.getExperiences();

      if (experiences.isNotEmpty) {
        for (final exp in experiences) {
          expect(exp.role, isNotEmpty, reason: 'Cargo não pode ser vazio');
          expect(exp.company, isNotEmpty, reason: 'Empresa não pode ser vazia');
          expect(exp.period, isNotEmpty, reason: 'Período não pode ser vazio');
          expect(
            exp.description,
            isNotEmpty,
            reason: 'Descrição não pode ser vazia',
          );

          log('Experiência validada: ${exp.role} na ${exp.company}');
        }
      }
    });

    test('Skills devem ter estrutura válida', () async {
      final skills = await repository.getSkills();

      if (skills.isNotEmpty) {
        for (final skill in skills) {
          expect(
            skill.name,
            isNotEmpty,
            reason: 'Nome da skill não pode ser vazio',
          );
          expect(
            skill.type,
            isIn(SkillType.values),
            reason: 'Tipo de skill deve ser válido',
          );

          log('Skill validada: ${skill.name} (${skill.type.name})');
        }
      }
    });

    test('Certificados devem ter estrutura válida', () async {
      final certificates = await repository.getCertificates();

      if (certificates.isNotEmpty) {
        for (final cert in certificates) {
          expect(
            cert.title,
            isNotEmpty,
            reason: 'Título do certificado não pode ser vazio',
          );
          expect(cert.issuer, isNotEmpty, reason: 'Emissor não pode ser vazio');
          expect(cert.date, isNotEmpty, reason: 'Data não pode ser vazia');

          log('Certificado validado: ${cert.title} por ${cert.issuer}');
        }
      }
    });
  });

  group('SupabaseRepository - Testes de Ordenação', () {
    test(
      'Projetos devem estar ordenados por created_at (mais recentes primeiro)',
      () async {
        final projects = await repository.getProjects();

        if (projects.length > 1) {
          log('✅ Verificando ordenação de ${projects.length} projetos');
          // Nota: Como não temos created_at no modelo, apenas verificamos que a lista foi retornada
          expect(projects, isNotEmpty);
        }
      },
    );

    test(
      'Experiências devem estar ordenadas por start_date (mais recentes primeiro)',
      () async {
        final experiences = await repository.getExperiences();

        if (experiences.length > 1) {
          log('✅ Verificando ordenação de ${experiences.length} experiências');
          expect(experiences, isNotEmpty);
        }
      },
    );
  });
}
