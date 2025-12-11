// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';

// Project imports:
import 'package:meu_curriculo_flutter/data/models/experience_model.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/molecules/experience_card.dart';

class ExperienceSection extends StatelessWidget {
  final List<ExperienceModel> experiences;

  const ExperienceSection({required this.experiences, super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPERIÊNCIA PROFISSIONAL',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 32),
        Stack(
          children: [
            // Linha do Tempo Animada
            Positioned(
              left: 0,
              top: 10,
              bottom: 0,
              child:
                  Container(
                    width: 2,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                  ).animate().scaleY(
                    begin: 0,
                    end: 1,
                    duration: 1.5.seconds,
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                  ),
            ),

            // Lista de Experiências
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: experiences.length,
              itemBuilder: (final context, final index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 32),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Bolinha na linha do tempo
                      Positioned(
                        left: -29,
                        top: 0,
                        child:
                            Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                )
                                .animate(delay: (index * 200 + 500).ms)
                                .scale(
                                  duration: 300.ms,
                                  curve: Curves.easeOutBack,
                                ),
                      ),

                      // Card
                      ExperienceCard(experience: experiences[index])
                          .animate()
                          .fadeIn(delay: (index * 200).ms, duration: 600.ms)
                          .slideX(begin: 0.1, end: 0),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
