enum SkillType { mobile, web, tools }

class SkillModel {
  final String name;
  final String? iconAsset;
  final bool isHighlight;
  final SkillType type; // Nova propriedade

  const SkillModel({
    required this.name,
    this.iconAsset,
    this.isHighlight = false,
    required this.type, // Obrigatório agora
  });

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      name: map['name'] ?? '',
      iconAsset: map['icon_asset'],
      isHighlight: map['is_highlight'] ?? false,
      type: SkillType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => SkillType.tools,
      ),
    );
  }
}
