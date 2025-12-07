import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late TextEditingController _techCtrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.project?.title ?? '');
    _descCtrl = TextEditingController(text: widget.project?.description ?? '');
    _repoCtrl = TextEditingController(text: widget.project?.repoUrl ?? '');
    _liveCtrl = TextEditingController(text: widget.project?.liveUrl ?? '');
    _imgCtrl = TextEditingController(text: widget.project?.imageUrl ?? '');
    _techCtrl = TextEditingController(
      text: widget.project?.techStack.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _repoCtrl.dispose();
    _liveCtrl.dispose();
    _imgCtrl.dispose();
    _techCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final techStack = _techCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final model = ProjectModel(
      id: widget.project?.id,
      title: _titleCtrl.text,
      description: _descCtrl.text,
      repoUrl: _repoCtrl.text,
      liveUrl: _liveCtrl.text.isEmpty ? null : _liveCtrl.text,
      imageUrl: _imgCtrl.text.isEmpty ? null : _imgCtrl.text,
      techStack: techStack,
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
    return AlertDialog(
      title: Text(widget.project == null ? 'Novo Projeto' : 'Editar Projeto'),
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
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição *'),
                maxLines: 3,
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _techCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tecnologias (separadas por vírgula) *',
                  hintText: 'Flutter, Dart, Firebase',
                ),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _repoCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL do Repositório *',
                ),
                validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _liveCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL do Deploy (Opcional)',
                ),
              ),
              TextFormField(
                controller: _imgCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem (Opcional)',
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
