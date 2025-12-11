// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/constants/app_constants.dart';
import 'package:meu_curriculo_flutter/l10n/arb/app_localizations.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/auth_controller.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/portfolio_controller.dart';
import 'package:meu_curriculo_flutter/presentation/pages/admin/admin_dashboard_page.dart';
import 'package:meu_curriculo_flutter/presentation/pages/admin/login_page.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/organisms/certificates_section.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/organisms/experience_section.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/organisms/glass_header.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/organisms/hero_section.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/organisms/projects_section.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/organisms/skills_section.dart';

import 'package:meu_curriculo_flutter/presentation/widgets/atoms/background_pattern.dart'; // Importe a textura
import 'package:meu_curriculo_flutter/presentation/widgets/organisms/intro_overlay.dart'; // Importe o IntroOverlay

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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.adminModeDetected),
        ),
      );

      // Navega para o Login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (final context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
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
                          AppLocalizations.of(context)!.errorMessage,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => controller.loadAllData(),
                          icon: const Icon(Icons.refresh),
                          label: Text(AppLocalizations.of(context)!.retry),
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
                                      8,
                                    ), // Aumenta a área de toque
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Feito com Flutter 3.27 & 💙',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '© ${DateTime.now().year} Franklyn Roberto',
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
      floatingActionButton: _buildFloatingActionButtons(context),
    );
  }

  Widget _buildFloatingActionButtons(final BuildContext context) {
    final authController = context.watch<AuthController>();
    final isLoggedIn = authController.isLogged;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Botão de Admin (só aparece se estiver logado)
        if (isLoggedIn) ...[
          FloatingActionButton(
            heroTag: 'admin_fab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final context) => const AdminDashboardPage(),
                ),
              );
            },
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            child: const Icon(Icons.admin_panel_settings),
          ),
          const SizedBox(height: 12),
        ],
        // Botão de Download CV (sempre visível)
        FloatingActionButton.extended(
          heroTag: 'download_fab',
          onPressed: () => launchUrl(Uri.parse(AppAssets.cvPtBr)),
          label: const Text('Baixar CV'),
          icon: const Icon(Icons.download_rounded),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
      ],
    );
  }
}
