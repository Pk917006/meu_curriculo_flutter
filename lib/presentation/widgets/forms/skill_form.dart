// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/utils/app_logger.dart';
import 'package:meu_curriculo_flutter/data/models/skill_model.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/auth_controller.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/portfolio_controller.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/custom_text_field.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/tech_autocomplete_field.dart';

class SkillForm extends StatefulWidget {
  final SkillModel? skill;
  const SkillForm({super.key, this.skill});

  @override
  State<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends State<SkillForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _iconCtrl;
  SkillType _type = SkillType.tools;
  bool _isHighlight = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.skill?.name ?? '');
    _iconCtrl = TextEditingController(text: widget.skill?.iconAsset ?? '');
    _type = widget.skill?.type ?? SkillType.tools;
    _isHighlight = widget.skill?.isHighlight ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final model = SkillModel(
      id: widget.skill?.id,
      name: _nameCtrl.text,
      iconAsset: _iconCtrl.text.isEmpty ? null : _iconCtrl.text,
      type: _type,
      isHighlight: _isHighlight,
    );

    try {
      final auth = context.read<AuthController>();
      final portfolio = context.read<PortfolioController>();

      if (widget.skill == null) {
        await auth.repository.createItem('skills', model.toMap());
      } else {
        await auth.repository.updateItem(
          'skills',
          widget.skill!.id!,
          model.toMap(),
        );
      }

      if (mounted) {
        portfolio.loadAllData();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Skill salva com sucesso!')),
        );
      }
    } catch (e, stack) {
      await AppLogger.log(
        level: 'error',
        message: e.toString(),
        stack: stack.toString(),
      );
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
  Widget build(final BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.skill == null ? 'Nova Skill' : 'Editar Skill',
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
                      TechAutocompleteField(
                        controller: _nameCtrl,
                        label: 'Nome',
                        icon: Icons.label,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _iconCtrl,
                        label: 'Caminho do Ícone (Asset)',
                        icon: Icons.image,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<SkillType>(
                        initialValue: _type,
                        decoration: InputDecoration(
                          labelText: 'Tipo',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        items: SkillType.values.map((final t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Text(t.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (final val) {
                          if (val != null) setState(() => _type = val);
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Destaque?'),
                        secondary: const Icon(Icons.star),
                        value: _isHighlight,
                        onChanged: (final val) => setState(() => _isHighlight = val),
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
}
