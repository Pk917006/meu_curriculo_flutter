import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/skill_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/portfolio_controller.dart';

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
      title: Text(widget.skill == null ? 'Nova Skill' : 'Editar Skill'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome *'),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _iconCtrl,
                decoration: const InputDecoration(
                  labelText: 'Caminho do Ícone (Asset)',
                ),
              ),
              DropdownButtonFormField<SkillType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: SkillType.values.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _type = val);
                },
              ),
              SwitchListTile(
                title: const Text('Destaque?'),
                value: _isHighlight,
                onChanged: (val) => setState(() => _isHighlight = val),
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
