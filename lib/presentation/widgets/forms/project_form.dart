// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/utils/app_logger.dart';
import 'package:meu_curriculo_flutter/data/models/project_model.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/auth_controller.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/portfolio_controller.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/custom_text_field.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/atoms/tech_autocomplete_field.dart';

class ProjectForm extends StatefulWidget {
  final ProjectModel? project;
  const ProjectForm({super.key, this.project});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _repoCtrl;
  late TextEditingController _liveCtrl;
  late TextEditingController _imgCtrl;
  final TextEditingController _techInputCtrl = TextEditingController();

  List<String> _selectedTechs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.project?.title ?? '');
    _descCtrl = TextEditingController(text: widget.project?.description ?? '');
    _repoCtrl = TextEditingController(text: widget.project?.repoUrl ?? '');
    _liveCtrl = TextEditingController(text: widget.project?.liveUrl ?? '');
    _imgCtrl = TextEditingController(text: widget.project?.imageUrl ?? '');
    _selectedTechs = List.from(widget.project?.techStack ?? []);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _repoCtrl.dispose();
    _liveCtrl.dispose();
    _imgCtrl.dispose();
    _techInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final model = ProjectModel(
      id: widget.project?.id,
      title: _titleCtrl.text,
      description: _descCtrl.text,
      repoUrl: _repoCtrl.text,
      liveUrl: _liveCtrl.text.isEmpty ? null : _liveCtrl.text,
      imageUrl: _imgCtrl.text.isEmpty ? null : _imgCtrl.text,
      techStack: _selectedTechs,
    );

    try {
      final auth = context.read<AuthController>();
      final portfolio = context.read<PortfolioController>();

      if (widget.project == null) {
        await auth.repository.createItem('projects', model.toMap());
      } else {
        await auth.repository.updateItem(
          'projects',
          widget.project!.id!,
          model.toMap(),
        );
      }

      if (mounted) {
        portfolio.loadAllData();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Projeto salvo com sucesso!')),
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
                  widget.project == null ? 'Novo Projeto' : 'Editar Projeto',
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
                      CustomTextField(
                        controller: _titleCtrl,
                        label: 'Título',
                        icon: Icons.title,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _descCtrl,
                        label: 'Descrição',
                        icon: Icons.description,
                        maxLines: 3,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tecnologias *',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedTechs.map((final tech) {
                              return Chip(
                                label: Text(tech),
                                onDeleted: () {
                                  setState(() {
                                    _selectedTechs.remove(tech);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          TechAutocompleteField(
                            controller: _techInputCtrl,
                            label: 'Adicionar Tecnologia',
                            icon: Icons.code,
                            excludeItems: _selectedTechs,
                            onSelected: (final val) {
                              setState(() {
                                _selectedTechs.add(val);
                                _techInputCtrl.clear();
                              });
                            },
                            onFieldSubmitted: (final val) {
                              if (val.isNotEmpty) {
                                setState(() {
                                  _selectedTechs.add(val);
                                  _techInputCtrl.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _repoCtrl,
                        label: 'URL do Repositório',
                        icon: Icons.link,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _liveCtrl,
                              label: 'URL do Deploy',
                              icon: Icons.web,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: _imgCtrl,
                              label: 'URL da Imagem',
                              icon: Icons.image,
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
