// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../data/models/certificate_model.dart';
import '../../data/models/experience_model.dart';
import '../../data/models/project_model.dart';
import '../../data/models/skill_model.dart';
import '../../data/repositories/portfolio_repository.dart';

class PortfolioController extends ChangeNotifier {
  final IPortfolioRepository repository;

  PortfolioController(this.repository);

  // --- DADOS ---
  List<ProjectModel> projects = [];
  List<ExperienceModel> experiences = [];
  List<SkillModel> skills = [];
  List<CertificateModel> certificates = [];
  bool isLoading = true;
  String? errorMessage;

  // --- TEMA (Dark/Light) ---
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  // --- NAVEGAÇÃO (Scroll) ---
  final ScrollController scrollController = ScrollController();
  final heroKey = GlobalKey();
  final skillsKey = GlobalKey();
  final experienceKey = GlobalKey();
  final projectsKey = GlobalKey();
  final certificatesKey = GlobalKey();

  Future<void> scrollToSection(GlobalKey key) async {
    final context = key.currentContext;
    if (context != null) {
      await Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // --- INICIALIZAÇÃO ---
  Future<void> loadAllData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadProjects(),
        _loadExperiences(),
        _loadSkills(),
        _loadCertificates(),
      ]);
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
      errorMessage = 'Falha ao carregar dados. Verifique sua conexão.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadProjects() async =>
      projects = await repository.getProjects();
  Future<void> _loadExperiences() async =>
      experiences = await repository.getExperiences();
  Future<void> _loadSkills() async => skills = await repository.getSkills();
  Future<void> _loadCertificates() async =>
      certificates = await repository.getCertificates();
}
