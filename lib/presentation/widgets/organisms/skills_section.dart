// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';

// Project imports:
import 'package:meu_curriculo_flutter/data/models/skill_model.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/tech_chip.dart';

class SkillsSection extends StatelessWidget {
  final List<SkillModel> skills;

  const SkillsSection({required this.skills, super.key});

  @override
  Widget build(final BuildContext context) {
    // Filtra as listas
    final mobileSkills = skills
        .where((final s) => s.type == SkillType.mobile)
        .toList();
    final webSkills = skills.where((final s) => s.type == SkillType.web).toList();
    final toolsSkills = skills.where((final s) => s.type == SkillType.tools).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategory(context, '📱 MOBILE (CORE)', mobileSkills, 0),
        const SizedBox(height: 40),
        _buildCategory(context, '💻 WEB, BACKEND & DATA', webSkills, 200),
        const SizedBox(height: 40),
        _buildCategory(context, '⚙️ TOOLS & DEVOPS', toolsSkills, 400),
      ],
    );
  }

  Widget _buildCategory(
    final BuildContext context,
    final String title,
    final List<SkillModel> items,
    final int delayMs,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 1.1,
          ),
        ).animate().fadeIn(delay: delayMs.ms).slideX(),

        const SizedBox(height: 16),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((final skill) {
            return TechChip(label: skill.name, isHighlight: skill.isHighlight);
          }).toList(),
        ).animate(delay: delayMs.ms).fadeIn(duration: 500.ms),
      ],
    );
  }
}
