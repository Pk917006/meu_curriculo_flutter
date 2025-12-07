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
}
