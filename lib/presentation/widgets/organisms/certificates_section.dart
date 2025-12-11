// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:meu_curriculo_flutter/data/models/certificate_model.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/molecules/certificate_card.dart';

class CertificatesSection extends StatelessWidget {
  final List<CertificateModel> certificates;

  const CertificatesSection({required this.certificates, super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CERTIFICADOS',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 32),
        LayoutBuilder(
          builder: (final context, final constraints) {
            var crossAxisCount = 1;
            if (constraints.maxWidth > 1100) {
              crossAxisCount = 3;
            } else if (constraints.maxWidth > 700) {
              crossAxisCount = 2;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.5,
                mainAxisExtent:
                    280, // Aumentado de 200 para 280 para evitar overflow
              ),
              itemCount: certificates.length,
              itemBuilder: (final context, final index) {
                return CertificateCard(certificate: certificates[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
