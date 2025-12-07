import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/experience_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/portfolio_controller.dart';

class ExperienceForm extends StatefulWidget {
  final ExperienceModel? experience;
  const ExperienceForm({super.key, this.experience});

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _roleCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _periodCtrl;
  late TextEditingController _descCtrl;
  bool _isCurrent = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _roleCtrl = TextEditingController(text: widget.experience?.role ?? '');
    _companyCtrl = TextEditingController(
      text: widget.experience?.company ?? '',
    );
    _periodCtrl = TextEditingController(text: widget.experience?.period ?? '');
    _descCtrl = TextEditingController(
      text: widget.experience?.description ?? '',
    );
    _isCurrent = widget.experience?.isCurrent ?? false;
  }

  @override
  void dispose() {
    _roleCtrl.dispose();
    _companyCtrl.dispose();
    _periodCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final model = ExperienceModel(
      id: widget.experience?.id,
      role: _roleCtrl.text,
      company: _companyCtrl.text,
      period: _periodCtrl.text,
      description: _descCtrl.text,
      isCurrent: _isCurrent,
    );

    try {
      final auth = context.read<AuthController>();
      final portfolio = context.read<PortfolioController>();

      if (widget.experience == null) {
        await auth.repository.createItem('experiences', model.toMap());
      } else {
        await auth.repository.updateItem(
          'experiences',
          widget.experience!.id!,
          model.toMap(),
        );
      }

      if (mounted) {
        portfolio.loadAllData();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Experiência salva com sucesso!')),
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
        widget.experience == null ? 'Nova Experiência' : 'Editar Experiência',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _roleCtrl,
                decoration: const InputDecoration(labelText: 'Cargo *'),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _companyCtrl,
                decoration: const InputDecoration(labelText: 'Empresa *'),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _periodCtrl,
                decoration: const InputDecoration(
                  labelText: 'Período (Ex: Jan 2023 - Atual) *',
                ),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição *'),
                maxLines: 3,
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              SwitchListTile(
                title: const Text('Trabalho Atual?'),
                value: _isCurrent,
                onChanged: (val) => setState(() => _isCurrent = val),
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
