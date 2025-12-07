import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/tech_suggestions.dart';
import '../../../data/models/project_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/portfolio_controller.dart';

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
                      _buildTextField(
                        controller: _titleCtrl,
                        label: 'Título',
                        icon: Icons.title,
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
                            children: _selectedTechs.map((tech) {
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
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<String>.empty();
                                      }
                                      return kTechSuggestions.where((
                                        String option,
                                      ) {
                                        return option.toLowerCase().contains(
                                              textEditingValue.text
                                                  .toLowerCase(),
                                            ) &&
                                            !_selectedTechs.contains(option);
                                      });
                                    },
                                onSelected: (String selection) {
                                  setState(() {
                                    _selectedTechs.add(selection);
                                  });
                                },
                                fieldViewBuilder:
                                    (
                                      BuildContext context,
                                      TextEditingController
                                      fieldTextEditingController,
                                      FocusNode fieldFocusNode,
                                      VoidCallback onFieldSubmitted,
                                    ) {
                                      return TextFormField(
                                        controller: fieldTextEditingController,
                                        focusNode: fieldFocusNode,
                                        decoration: InputDecoration(
                                          labelText: 'Adicionar Tecnologia',
                                          prefixIcon: const Icon(Icons.code),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              if (fieldTextEditingController
                                                  .text
                                                  .isNotEmpty) {
                                                setState(() {
                                                  _selectedTechs.add(
                                                    fieldTextEditingController
                                                        .text,
                                                  );
                                                  fieldTextEditingController
                                                      .clear();
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        onFieldSubmitted: (value) {
                                          if (value.isNotEmpty) {
                                            setState(() {
                                              _selectedTechs.add(value);
                                              fieldTextEditingController
                                                  .clear();
                                            });
                                          }
                                        },
                                      );
                                    },
                                optionsViewBuilder:
                                    (
                                      BuildContext context,
                                      AutocompleteOnSelected<String> onSelected,
                                      Iterable<String> options,
                                    ) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 4.0,
                                          child: SizedBox(
                                            width: constraints.maxWidth,
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: options.length,
                                              itemBuilder:
                                                  (
                                                    BuildContext context,
                                                    int index,
                                                  ) {
                                                    final String option =
                                                        options.elementAt(
                                                          index,
                                                        );
                                                    return ListTile(
                                                      title: Text(option),
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                    );
                                                  },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _repoCtrl,
                        label: 'URL do Repositório',
                        icon: Icons.link,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _liveCtrl,
                              label: 'URL do Deploy',
                              icon: Icons.web,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
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
