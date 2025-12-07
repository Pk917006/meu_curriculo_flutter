import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/certificate_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/portfolio_controller.dart';

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
    return AlertDialog(
      title: Text(
        widget.certificate == null ? 'Novo Certificado' : 'Editar Certificado',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Título *'),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _issuerCtrl,
                decoration: const InputDecoration(labelText: 'Emissor *'),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _dateCtrl,
                decoration: const InputDecoration(
                  labelText: 'Data de Emissão *',
                ),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição *'),
                maxLines: 2,
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _credUrlCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL da Credencial *',
                ),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _langCtrl,
                decoration: const InputDecoration(
                  labelText: 'Linguagem (Opcional)',
                ),
              ),
              TextFormField(
                controller: _frameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Framework (Opcional)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(onPressed: _save, child: const Text('Salvar')),
      ],
    );
  }
}
