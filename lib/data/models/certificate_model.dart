class CertificateModel {
  final String title;
  final String issuer;
  final String date;
  final String? credentialUrl;

  const CertificateModel({
    required this.title,
    required this.issuer,
    required this.date,
    this.credentialUrl,
  });

  factory CertificateModel.fromMap(Map<String, dynamic> map) {
    return CertificateModel(
      title: map['title'] ?? '',
      issuer: map['issuer'] ?? '',
      date: map['date'] ?? '',
      credentialUrl: map['credential_url'],
    );
  }
}
