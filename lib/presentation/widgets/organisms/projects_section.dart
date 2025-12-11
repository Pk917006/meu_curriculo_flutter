// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/constants/app_constants.dart';
import 'package:meu_curriculo_flutter/data/models/project_model.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/molecules/project_card.dart';

class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;

  const ProjectsSection({required this.projects, super.key});

  Future<void> _launchGitHub() async {
    final url = Uri.parse(AppStrings.gitHubRepositoriesUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROJETOS EM DESTAQUE',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextButton.icon(
              onPressed: _launchGitHub,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Ver todos no GitHub'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        LayoutBuilder(
          builder: (final context, final constraints) {
            // Lógica responsiva para o Grid
            var crossAxisCount = 1;
            if (constraints.maxWidth > 1100) {
              crossAxisCount = 3;
            } else if (constraints.maxWidth > 700) {
              crossAxisCount = 2;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.3,
              ),
              itemCount: projects.length,
              itemBuilder: (final context, final index) {
                return ProjectCard(project: projects[index])
                    .animate()
                    .fadeIn(delay: (index * 100).ms)
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      curve: Curves.easeOut,
                    );
              },
            );
          },
        ),
      ],
    );
  }
}
