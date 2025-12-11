enum SkillType { mobile, web, tools }

class SkillModel {
  final int? id;
  final String name;
  final String? iconAsset;
  final bool isHighlight;
  final SkillType type; // Nova propriedade

  const SkillModel({
    required this.name,
    required this.type,
    this.id,
    this.iconAsset,
    this.isHighlight = false,
  });

  factory SkillModel.fromMap(final Map<String, dynamic> map) {
    return SkillModel(
      id: map['id'],
      name: map['name'] ?? '',
      iconAsset: map['icon_asset'],
      isHighlight: map['is_highlight'] ?? false,
      type: SkillType.values.firstWhere(
        (final e) => e.name == map['type'],
        orElse: () => SkillType.tools,
      ),
    );
  }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'icon_asset': iconAsset,
      'is_highlight': isHighlight,
      'type': type.name,
    };
  }
}
