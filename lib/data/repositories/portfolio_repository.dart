// Project imports:
import '../mocks/mock_data.dart';
import '../models/certificate_model.dart';
import '../models/experience_model.dart';
import '../models/project_model.dart';
import '../models/skill_model.dart';

abstract class IPortfolioRepository {
  Future<List<ProjectModel>> getProjects();
  Future<List<ExperienceModel>> getExperiences();
  Future<List<SkillModel>> getSkills();
  Future<List<CertificateModel>> getCertificates();
}

class PortfolioRepository implements IPortfolioRepository {
  @override
  Future<List<ProjectModel>> getProjects() async {
    // Simula um delay pequeno para dar um "charme" de carregamento na UI
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.projects;
  }

  @override
  Future<List<ExperienceModel>> getExperiences() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.experiences;
  }

  @override
  Future<List<SkillModel>> getSkills() async {
    // Skills carregam rápido
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.skills;
  }

  @override
  Future<List<CertificateModel>> getCertificates() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.certificates;
  }
}
