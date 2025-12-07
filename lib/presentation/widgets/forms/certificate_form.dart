// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import '../../../data/models/certificate_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/portfolio_controller.dart';
import '../atoms/custom_text_field.dart';
import '../atoms/tech_autocomplete_field.dart';

class CertificateForm extends StatefulWidget {
  final CertificateModel? certificate;
  const CertificateForm({super.key, this.certificate});

  @override
  State<CertificateForm> createState() => _CertificateFormState();
}

class _CertificateFormState extends State<CertificateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _credUrlCtrl;
  late TextEditingController _langCtrl;
  late TextEditingController _frameCtrl;
  late TextEditingController _issuerCtrl;
  late TextEditingController _dateCtrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.certificate?.title ?? '');
    _descCtrl = TextEditingController(
      text: widget.certificate?.description ?? '',
    );
    _credUrlCtrl = TextEditingController(
      text: widget.certificate?.credentialUrl ?? '',
    );
    _langCtrl = TextEditingController(text: widget.certificate?.language ?? '');
    _frameCtrl = TextEditingController(
      text: widget.certificate?.framework ?? '',
    );
    _issuerCtrl = TextEditingController(text: widget.certificate?.issuer ?? '');
    _dateCtrl = TextEditingController(text: widget.certificate?.date ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _credUrlCtrl.dispose();
    _langCtrl.dispose();
    _frameCtrl.dispose();
    _issuerCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final model = CertificateModel(
      id: widget.certificate?.id,
      title: _titleCtrl.text,
      description: _descCtrl.text,
      credentialUrl: _credUrlCtrl.text,
      language: _langCtrl.text,
      framework: _frameCtrl.text,
      issuer: _issuerCtrl.text,
      date: _dateCtrl.text,
    );

    try {
      final auth = context.read<AuthController>();
      final portfolio = context.read<PortfolioController>();

      if (widget.certificate == null) {
        await auth.repository.createItem('certificates', model.toMap());
      } else {
        await auth.repository.updateItem(
          'certificates',
          widget.certificate!.id!,
          model.toMap(),
        );
      }

      if (mounted) {
        portfolio.loadAllData();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Certificado salvo com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.certificate == null
                      ? 'Novo Certificado'
                      : 'Editar Certificado',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _titleCtrl,
                              label: 'Título',
                              icon: Icons.workspace_premium,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: _issuerCtrl,
                              label: 'Emissor',
                              icon: Icons.school,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _dateCtrl,
                        label: 'Data de Emissão',
                        icon: Icons.calendar_today,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _descCtrl,
                        label: 'Descrição',
                        icon: Icons.description,
                        maxLines: 2,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _credUrlCtrl,
                        label: 'URL da Credencial',
                        icon: Icons.link,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TechAutocompleteField(
                              controller: _langCtrl,
                              label: 'Linguagem',
                              icon: Icons.code,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TechAutocompleteField(
                              controller: _frameCtrl,
                              label: 'Framework',
                              icon: Icons.layers,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _save,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
