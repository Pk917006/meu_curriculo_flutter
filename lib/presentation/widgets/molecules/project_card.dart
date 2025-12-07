import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/project_model.dart';
import '../../../core/constants/app_constants.dart';
import '../atoms/tech_chip.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  // Otimização: ValueNotifiers para evitar rebuilds de todo o widget
  final ValueNotifier<Offset> _mousePos = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void dispose() {
    _mousePos.dispose();
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) {
        _isHovered.value = false;
        _mousePos.value = Offset.zero;
      },
      onHover: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final center = Offset(size.width / 2, size.height / 2);
        _mousePos.value = details.localPosition - center;
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_mousePos, _isHovered]),
        builder: (context, child) {
          final hovered = _isHovered.value;
          final mouse = _mousePos.value;

          // Transformação Matrix4 para o efeito 3D
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspectiva
            ..rotateX(hovered ? 0.001 * mouse.dy : 0)
            ..rotateY(hovered ? -0.001 * mouse.dx : 0);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                // Correção Dark Mode: Usar cor do tema
                color: theme.cardTheme.color ?? theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: hovered
                        ? const Color(AppColors.primary).withOpacity(0.3)
                        : (isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.05)),
                    blurRadius: hovered ? 30 : 10,
                    offset: hovered ? const Offset(0, 15) : const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Conteúdo do Card
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.folderOpen,
                              size: 30,
                              color: Color(AppColors.primary),
                            ),
                            FaIcon(
                              FontAwesomeIcons.arrowUpRightFromSquare,
                              size: 16,
                              color:
                                  theme.iconTheme.color?.withOpacity(0.5) ??
                                  Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.project.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.project.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.8),
                          ),
                        ),
                        const Spacer(),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.project.techStack
                              .take(3)
                              .map((t) => TechChip(label: t))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  // Efeito de Brilho (Gradient Overlay) ao passar o mouse
                  if (hovered)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(isDark ? 0.1 : 0.4),
                              Colors.transparent,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.0, 0.4],
                          ),
                        ),
                      ),
                    ),

                  // Link Clicável
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () =>
                            launchUrl(Uri.parse(widget.project.repoUrl)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
