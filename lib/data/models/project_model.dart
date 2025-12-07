class ProjectModel {
  final int? id;
  final String title;
  final String description;
  final List<String> techStack; // Ex: ["Flutter", "Dart", "Firebase"]
  final String repoUrl;
  final String? liveUrl; // Opcional, pois nem todo projeto tem deploy
  final String? imageUrl; // Caminho do asset ou URL

  const ProjectModel({
    required this.title,
    required this.description,
    required this.techStack,
    required this.repoUrl,
    this.liveUrl,
    this.imageUrl,
    this.id,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      techStack: List<String>.from(map['tech_stack'] ?? []),
      repoUrl: map['repo_url'] ?? '',
      liveUrl: map['live_url'],
      imageUrl: map['image_url'],
    );
  }

  Map<String, dynamic> toJson() => toMap();

  // Método para Enviar ao Banco
  Map<String, dynamic> toMap() {
    return {
      // Não mandamos ID na criação (o banco gera)
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'tech_stack': techStack,
      'repo_url': repoUrl,
      'live_url': liveUrl,
      'image_url': imageUrl,
    };
  }
}
