// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meu_curriculo_flutter/presentation/pages/admin/login_page.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import '../../../core/constants/app_constants.dart';
import '../controllers/portfolio_controller.dart';
import '../widgets/organisms/experience_section.dart';
import '../widgets/organisms/glass_header.dart';
import '../widgets/organisms/hero_section.dart';
import '../widgets/organisms/projects_section.dart';
import '../widgets/organisms/skills_section.dart';
import '../widgets/organisms/certificates_section.dart';

import '../widgets/atoms/background_pattern.dart'; // Importe a textura
import '../widgets/organisms/intro_overlay.dart'; // Importe o IntroOverlay

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showIntro = true;
  int _secretTapCount = 0;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PortfolioController>().loadAllData();
    });
  }

  void _handleEasterEgg() {
    setState(() => _secretTapCount++);

    // Cancela o timer anterior se houver
    _resetTimer?.cancel();

    // Se o usuário parar de clicar por 1.5 segundos, zera a contagem
    _resetTimer = Timer(const Duration(milliseconds: 1500), () {
      setState(() => _secretTapCount = 0);
    });

    // Se atingir 10 cliques
    if (_secretTapCount >= 10) {
      _secretTapCount = 0;
      _resetTimer?.cancel();

      // Feedback visual (opcional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🕵️ Modo Admin Detectado!')),
      );

      // Navega para o Login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PortfolioController>();

    return Scaffold(
      // BackgroundPattern envolve todo o corpo
      body: Stack(
        children: [
          // Conteúdo Principal (Renderizado atrás do IntroOverlay)
          BackgroundPattern(
            child: controller.errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => controller.loadAllData(),
                          icon: const Icon(Icons.refresh),
                          label: const Text("Tentar Novamente"),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      SingleChildScrollView(
                        controller:
                            controller.scrollController, // Conecta o controller
                        padding: const EdgeInsets.only(top: 100, bottom: 60),
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                HeroSection(
                                  key: controller.heroKey,
                                ), // Key aqui
                                const SizedBox(height: 100),

                                const Divider(height: 1, thickness: 0.5),
                                const SizedBox(height: 80),

                                SkillsSection(
                                  key: controller.skillsKey,
                                  skills: controller.skills,
                                ), // Key aqui
                                const SizedBox(height: 100),

                                ExperienceSection(
                                  key: controller.experienceKey,
                                  experiences: controller.experiences,
                                ), // Key aqui
                                const SizedBox(height: 100),

                                ProjectsSection(
                                  key: controller.projectsKey,
                                  projects: controller.projects,
                                ), // Key aqui
                                const SizedBox(height: 100),

                                CertificatesSection(
                                  key: controller.certificatesKey,
                                  certificates: controller.certificates,
                                ),
                                const SizedBox(height: 150),

                                // Footer com Copyright
                                GestureDetector(
                                  onTap:
                                      _handleEasterEgg, // Chama a função aqui
                                  behavior: HitTestBehavior
                                      .translucent, // Garante que o toque funcione bem
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      8.0,
                                    ), // Aumenta a área de toque
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Feito com Flutter 3.27 & 💙",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "© ${DateTime.now().year} Franklyn Roberto",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Header Flutuante
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: GlassHeader(),
                      ),
                    ],
                  ),
          ),

          // Intro Overlay (Fica por cima de tudo)
          if (_showIntro)
            IntroOverlay(
              isLoading: controller.isLoading,
              onFinished: () => setState(() => _showIntro = false),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => launchUrl(Uri.parse(AppAssets.cvPtBr)),
        label: const Text("Baixar CV"),
        icon: const Icon(Icons.download_rounded),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
