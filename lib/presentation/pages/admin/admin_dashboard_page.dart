// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/utils/app_logger.dart';
import 'package:meu_curriculo_flutter/data/models/certificate_model.dart';
import 'package:meu_curriculo_flutter/data/models/experience_model.dart';
import 'package:meu_curriculo_flutter/data/models/project_model.dart';
import 'package:meu_curriculo_flutter/data/models/skill_model.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/auth_controller.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/portfolio_controller.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/forms/certificate_form.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/forms/experience_form.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/forms/project_form.dart';
import 'package:meu_curriculo_flutter/presentation/widgets/forms/skill_form.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _deleteItem(final String table, final int? id) async {
    if (id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (final ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja remover este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final auth = context.read<AuthController>();
      final portfolio = context.read<PortfolioController>();

      try {
        await auth.repository.deleteItem(table, id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item removido com sucesso!')),
          );
          portfolio.loadAllData();
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
          ).showSnackBar(SnackBar(content: Text('Erro ao remover: $e')));
        }
      }
    }
  }

  void _showAddDialog(final BuildContext context, final int index) {
    Widget? dialog;

    switch (index) {
      case 0:
        dialog = const ProjectForm();
        break;
      case 1:
        dialog = const ExperienceForm();
        break;
      case 2:
        dialog = const SkillForm();
        break;
      case 3:
        dialog = const CertificateForm();
        break;
    }

    if (dialog != null) {
      showDialog(context: context, builder: (_) => dialog!);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final controller = context.watch<PortfolioController>();
    final authController = context.read<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadAllData(),
            tooltip: 'Recarregar Dados',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
              Navigator.pop(context);
            },
            tooltip: 'Sair',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.work_outline), text: 'Projetos'),
            Tab(icon: Icon(Icons.business), text: 'Experiência'),
            Tab(icon: Icon(Icons.code), text: 'Skills'),
            Tab(icon: Icon(Icons.school_outlined), text: 'Certificados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProjectList(controller.projects),
          _buildExperienceList(controller.experiences),
          _buildSkillList(controller.skills),
          _buildCertificateList(controller.certificates),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, _tabController.index),
        label: const Text('Adicionar Novo'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectList(final List<ProjectModel> items) {
    if (items.isEmpty) return _buildEmptyState('Nenhum projeto encontrado.');
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (final context, final index) {
        final item = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.work, color: Colors.blue),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: item.techStack
                      .map(
                        (final t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 10)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => ProjectForm(project: item),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteItem('projects', item.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExperienceList(final List<ExperienceModel> items) {
    if (items.isEmpty) {
      return _buildEmptyState('Nenhuma experiência encontrada.');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (final context, final index) {
        final item = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.orange.shade100,
              child: const Icon(Icons.business_center, color: Colors.orange),
            ),
            title: Text(
              item.role,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item.company} • ${item.period}'),
                if (item.isCurrent)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Atual',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => ExperienceForm(experience: item),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteItem('experiences', item.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillList(final List<SkillModel> items) {
    if (items.isEmpty) return _buildEmptyState('Nenhuma skill encontrada.');
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (final context, final index) {
        final item = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.purple.shade100,
              child: const Icon(Icons.code, color: Colors.purple),
            ),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Tipo: ${item.type.name.toUpperCase()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => SkillForm(skill: item),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteItem('skills', item.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCertificateList(final List<CertificateModel> items) {
    if (items.isEmpty) {
      return _buildEmptyState('Nenhum certificado encontrado.');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (final context, final index) {
        final item = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: const Icon(Icons.verified, color: Colors.teal),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emissor: ${item.issuer}'),
                Text('Data: ${item.date}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => CertificateForm(certificate: item),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteItem('certificates', item.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(final String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
