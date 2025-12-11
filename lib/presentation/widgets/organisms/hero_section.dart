// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/constants/app_constants.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/magnetic_element.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/social_button.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/typewriter_text.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return SizedBox(
      height: isMobile ? 750 : 700,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // === FUNDO COM ELEMENTOS FLUTUANTES (GRAVIDADE) ===
          if (!isMobile) ...[
            // --- GRUPO 1: MOBILE (Esquerda Superior) ---
            const Positioned(
              top: 40,
              left: 100,
              child: MagneticElement(
                strength: 1.5,
                child: FaIcon(
                  FontAwesomeIcons.flutter,
                  size: 45,
                  color: Colors.blue,
                ),
              ),
            ),
            const Positioned(
              top: 180,
              left: 80,
              child: MagneticElement(
                strength: 1.3,
                child: FaIcon(
                  FontAwesomeIcons.android,
                  size: 40,
                  color: Colors.green,
                ), // Android/Kotlin
              ),
            ),
            const Positioned(
              top: 260,
              left: 150,
              child: MagneticElement(
                strength: 1.3,
                child: FaIcon(
                  FontAwesomeIcons.swift,
                  size: 40,
                  color: Colors.orange,
                ), // Android/Kotlin
              ),
            ),
            // --- GRUPO 2: WEB & JS (Direita Superior) ---
            const Positioned(
              top: 60,
              right: 120,
              child: MagneticElement(
                strength: 2,
                child: FaIcon(
                  FontAwesomeIcons.react,
                  size: 50,
                  color: Colors.cyan,
                ),
              ),
            ),
            const Positioned(
              top: 140,
              right: 250,
              child: MagneticElement(
                strength: 0.9,
                child: FaIcon(
                  FontAwesomeIcons.apple,
                  size: 40,
                  color: Colors.black54,
                ), // iOS
              ),
            ),

            // --- GRUPO 3: BACKEND & DADOS (Meio/Baixo) ---
            const Positioned(
              bottom: 150,
              left: 150,
              child: MagneticElement(
                strength: 1.2,
                child: FaIcon(
                  FontAwesomeIcons.java,
                  size: 45,
                  color: Colors.orange,
                ),
              ),
            ),
            const Positioned(
              bottom: 180,
              left: 40,
              child: MagneticElement(
                strength: 1.2,
                child: FaIcon(
                  FontAwesomeIcons.windows,
                  size: 45,
                  color: Color.fromARGB(255, 0, 173, 253),
                ),
              ),
            ),
            const Positioned(
              bottom: 80,
              left: 300,
              child: MagneticElement(
                strength: 1.7,
                child: FaIcon(
                  FontAwesomeIcons.database,
                  size: 35,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const Positioned(
              top: 280,
              right: 100,
              child: MagneticElement(
                strength: 0.8,
                child: FaIcon(
                  FontAwesomeIcons.bolt,
                  size: 30,
                  color: Colors.amber,
                ),
              ),
            ),

            // --- GRUPO 4: DEVOPS & TOOLS (Direita Inferior) ---
            const Positioned(
              bottom: 60,
              right: 150,
              child: MagneticElement(
                strength: 1.8,
                child: FaIcon(
                  FontAwesomeIcons.docker,
                  size: 40,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const Positioned(
              bottom: 130,
              right: 280,
              child: MagneticElement(
                strength: 1,
                child: FaIcon(
                  FontAwesomeIcons.gitAlt,
                  size: 35,
                  color: Colors.deepOrangeAccent,
                ), // Git
              ),
            ),
            const Positioned(
              top: 350,
              left: 60,
              child: MagneticElement(
                strength: 1.2,
                child: FaIcon(
                  FontAwesomeIcons.nodeJs,
                  size: 38,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            const Positioned(
              bottom: 40,
              left: 200,
              child: MagneticElement(
                strength: 1.1,
                child: FaIcon(
                  FontAwesomeIcons.python,
                  size: 38,
                  color: Colors.yellow,
                ),
              ),
            ),
            const Positioned(
              top: 40,
              right: 600,
              child: MagneticElement(
                strength: 0.7,
                child: FaIcon(
                  FontAwesomeIcons.js,
                  size: 36,
                  color: Colors.yellow,
                ),
              ),
            ),
            const Positioned(
              top: 200,
              right: 700,
              child: MagneticElement(
                strength: 0.7,
                child: FaIcon(
                  FontAwesomeIcons.dartLang,
                  size: 36,
                  color: Colors.blue,
                ),
              ),
            ),
            const Positioned(
              top: 50,
              right: 320,
              child: MagneticElement(
                strength: 0.9,
                child: FaIcon(
                  FontAwesomeIcons.html5,
                  size: 40,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
            const Positioned(
              bottom: 220,
              right: 60,
              child: MagneticElement(
                strength: 1,
                child: FaIcon(
                  FontAwesomeIcons.linux,
                  size: 34,
                  color: Colors.black,
                ),
              ),
            ),
            const Positioned(
              top: 370,
              right: 90,
              child: MagneticElement(
                strength: 1.1,
                child: FaIcon(
                  FontAwesomeIcons.css3,
                  size: 32,
                  color: Colors.indigo,
                ),
              ),
            ),
          ],

          // === CONTEÚDO CENTRAL (FOTO E TEXTOS) ===
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar com Borda e Efeito Magnético
              MagneticElement(
                strength: 0.5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(AppColors.primary), Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          AppColors.primary,
                        ).withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage(AppAssets.profileImage),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Nome com Efeito de Cor e Glitch
              Text(
                    AppStrings.portfolioTitle.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: isMobile ? 40 : 72,
                      height: 0.9,
                      letterSpacing: -2,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.2, end: 0)
                  .then()
                  .shimmer(
                    duration: 2.seconds,
                    color: const Color(
                      AppColors.primary,
                    ).withValues(alpha: 0.3),
                  )
                  .animate(
                    onPlay: (final controller) =>
                        controller.repeat(period: 5.seconds),
                  )
                  .tint(
                    color: const Color(
                      AppColors.primary,
                    ).withValues(alpha: 0.5),
                    duration: 200.ms,
                  )
                  .shake(hz: 3, curve: Curves.easeInOut, duration: 300.ms),

              const SizedBox(height: 10),

              // Typewriter Effect for Role
              TypewriterText(
                texts: const [
                  'MOBILE DEVELOPER (FLUTTER)',
                  'FULLSTACK ENGINEER',
                  'CREATIVE CODER',
                  'TECH ENTHUSIAST',
                ],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 30),

              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  AppStrings.aboutMe,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 40),

              // Botões Sociais
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                    icon: FontAwesomeIcons.linkedin,
                    url: AppStrings.linkedInUrl,
                  ),
                  SizedBox(width: 20),
                  SocialButton(
                    icon: FontAwesomeIcons.github,
                    url: AppStrings.gitHubUrl,
                  ),
                  SizedBox(width: 20),
                  SocialButton(
                    icon: FontAwesomeIcons.whatsapp,
                    url: AppStrings.whatsappUrl,
                  ),
                  SizedBox(width: 20),
                  SocialButton(
                    icon: FontAwesomeIcons.envelope,
                    url: AppStrings.emailUrl,
                  ),
                ],
              ).animate().scale(delay: 700.ms, curve: Curves.elasticOut),
            ],
          ),
        ],
      ),
    );
  }
}
