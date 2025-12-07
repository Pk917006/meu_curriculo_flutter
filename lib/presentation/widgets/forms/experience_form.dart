// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
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
                  widget.experience == null
                      ? 'Nova Experiência'
                      : 'Editar Experiência',
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
                            child: _buildTextField(
                              controller: _roleCtrl,
                              label: 'Cargo',
                              icon: Icons.work,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _companyCtrl,
                              label: 'Empresa',
                              icon: Icons.business,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _periodCtrl,
                        label: 'Período',
                        hint: 'Ex: Jan 2023 - Atual',
                        icon: Icons.date_range,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descCtrl,
                        label: 'Descrição',
                        icon: Icons.description,
                        maxLines: 3,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Trabalho Atual?'),
                        secondary: const Icon(Icons.check_circle_outline),
                        value: _isCurrent,
                        onChanged: (val) => setState(() => _isCurrent = val),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: required
          ? (v) => v?.isEmpty == true ? 'Campo obrigatório' : null
          : null,
    );
  }
}
