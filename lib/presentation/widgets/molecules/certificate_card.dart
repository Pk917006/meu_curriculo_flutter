// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/utils/app_utils.dart';
import 'package:meu_curriculo_flutter/data/models/certificate_model.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/tech_chip.dart';

class CertificateCard extends StatefulWidget {
  final CertificateModel certificate;

  const CertificateCard({required this.certificate, super.key});

  @override
  State<CertificateCard> createState() => _CertificateCardState();
}

class _CertificateCardState extends State<CertificateCard> {
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
              width: 320, // Largura fixa ideal para carrossel
              margin: const EdgeInsets.only(right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white10
                      : Colors.grey.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: hovered
                        ? theme.colorScheme.primary.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: hovered ? 20 : 10,
                    offset: hovered ? const Offset(0, 10) : const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- CABEÇALHO ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Ícone estilizado
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.workspace_premium,
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            // Botão de Download/Link
                            if (widget.certificate.credentialUrl.isNotEmpty)
                              IconButton(
                                onPressed: () => AppUtils.launchURL(
                                  widget.certificate.credentialUrl,
                                  context: context,
                                ),
                                icon: const Icon(
                                  Icons.open_in_new_rounded,
                                  size: 20,
                                ),
                                tooltip: 'Ver Certificado',
                                style: IconButton.styleFrom(
                                  foregroundColor: theme.colorScheme.primary,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // --- TÍTULO ---
                        Text(
                          widget.certificate.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 6),

                        // --- EMISSOR • DATA ---
                        Row(
                          children: [
                            Text(
                              widget.certificate.issuer,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Text(
                                '•',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              widget.certificate.date,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // --- DESCRIÇÃO ---
                        Expanded(
                          child: Text(
                            widget.certificate.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // --- TAGS (CHIPS) ---
                        if (widget.certificate.language.isNotEmpty ||
                            widget.certificate.framework.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (widget.certificate.language.isNotEmpty)
                                TechChip(
                                  label: widget.certificate.language,
                                  isHighlight: false,
                                ),
                              if (widget.certificate.framework.isNotEmpty)
                                TechChip(
                                  label: widget.certificate.framework,
                                  isHighlight: true,
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // Efeito de Brilho (Gradient Overlay) ao passar o mouse
                  if (hovered)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
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

                  // Link Clicável
                  if (widget.certificate.credentialUrl.isNotEmpty)
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => AppUtils.launchURL(
                            widget.certificate.credentialUrl,
                            context: context,
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
