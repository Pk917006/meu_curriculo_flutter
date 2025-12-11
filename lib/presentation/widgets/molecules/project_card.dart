// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/constants/app_constants.dart';
import 'package:meu_curriculo_flutter/data/models/project_model.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/tech_chip.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({required this.project, super.key});

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
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) {
        _isHovered.value = false;
        _mousePos.value = Offset.zero;
      },
      onHover: (final details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final center = Offset(size.width / 2, size.height / 2);
        _mousePos.value = details.localPosition - center;
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_mousePos, _isHovered]),
        builder: (final context, final child) {
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
                        ? const Color(AppColors.primary).withValues(alpha: 0.3)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.05)),
                    blurRadius: hovered ? 30 : 10,
                    offset: hovered ? const Offset(0, 15) : const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Conteúdo do Card
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.folderOpen,
                              size: 28,
                              color: Color(AppColors.primary),
                            ),
                            FaIcon(
                              FontAwesomeIcons.arrowUpRightFromSquare,
                              size: 14,
                              color:
                                  theme.iconTheme.color?.withValues(
                                    alpha: 0.5,
                                  ) ??
                                  Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.project.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            widget.project.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                              fontSize: 13,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.project.techStack
                              .take(3)
                              .map((final t) => TechChip(label: t))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // Efeito de Brilho (Gradient Overlay) ao passar o mouse
                  if (hovered)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(
                                  alpha: isDark ? 0.1 : 0.4,
                                ),
                                Colors.transparent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: const [0.0, 0.4],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Link Clicável para o GitHub (todo o card)
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

                  // Botão Live Demo (se existir) - Por último para ficar por cima
                  if (widget.project.liveUrl != null &&
                      widget.project.liveUrl!.isNotEmpty)
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: MouseRegion(
                        onEnter: (_) => _isHovered.value = false,
                        onExit: (_) {},
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              launchUrl(Uri.parse(widget.project.liveUrl!)),
                          icon: const FaIcon(
                            FontAwesomeIcons.arrowUpRightFromSquare,
                            size: 16,
                          ),
                          label: const Text('Ver Demo'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 3,
                          ),
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
