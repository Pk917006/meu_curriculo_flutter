// Flutter imports:
import 'package:flutter/material.dart';

class TechChip extends StatelessWidget {
  final String label;
  final bool isHighlight;

  const TechChip({required this.label, super.key, this.isHighlight = false});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isHighlight ? theme.colorScheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlight
              ? Colors.transparent
              : theme.colorScheme.outlineVariant,
        ),
        boxShadow: [
          if (isHighlight)
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isHighlight
              ? Colors.white
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
