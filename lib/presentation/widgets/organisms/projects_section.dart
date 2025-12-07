// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';

// Project imports:
import '../../../data/models/project_model.dart';
import '../molecules/project_card.dart';

class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PROJETOS EM DESTAQUE",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Ver todos no GitHub"),
            ),
          ],
        ),
        const SizedBox(height: 24),

        LayoutBuilder(
          builder: (context, constraints) {
            // Lógica responsiva para o Grid
            int crossAxisCount = 1;
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
              itemBuilder: (context, index) {
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
