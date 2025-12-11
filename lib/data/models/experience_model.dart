class ExperienceModel {
  final int? id;
  final String role; // Cargo (Ex: Desenvolvedor Fullstack)
  final String company;
  final String period; // Ex: Jul 2023 - Dez 2023
  final String description;
  final bool isCurrent; // Para destacar se é o emprego atual

  const ExperienceModel({
    required this.role, required this.company, required this.period, required this.description, this.id,
    this.isCurrent = false,
  });

  factory ExperienceModel.fromMap(final Map<String, dynamic> map) {
    return ExperienceModel(
      id: map['id'],
      role: map['role'] ?? '',
      company: map['company'] ?? '',
      period: map['period'] ?? '',
      description: map['description'] ?? '',
      isCurrent: map['is_current'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'role': role,
      'company': company,
      'period': period,
      'description': description,
      'is_current': isCurrent,
    };
  }
}
