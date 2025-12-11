class CertificateModel {
  final int? id;
  final String title;
  final String description;
  final String credentialUrl;
  final String language;
  final String framework;
  final String issuer; // Novo
  final String date; // Novo

  const CertificateModel({
    required this.title, required this.description, required this.credentialUrl, required this.language, required this.framework, required this.issuer, required this.date, this.id,
  });

  factory CertificateModel.fromMap(final Map<String, dynamic> map) {
    return CertificateModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      credentialUrl: map['credential_url'] ?? '',
      language: map['language'] ?? '',
      framework: map['framework'] ?? '',
      // Mapeando os novos campos do banco
      issuer: map['issuer'] ?? '',
      date:
          map['date_issued'] ?? '', // Note que no banco chamei de 'date_issued'
    );
  }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'credential_url': credentialUrl,
      'language': language,
      'framework': framework,
      'issuer': issuer,
      'date_issued': date,
    };
  }
}
