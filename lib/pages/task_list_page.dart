// lib/pages/task_list_page.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../database/database_helper.dart';
import 'package:mini_cadastro_tarefas/pages/task_form_page.dart';
import 'package:intl/intl.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  // Lista de tarefas para a ListView.builder
  List<Task> _tasks = []; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Método para carregar a lista de tarefas (CRUD - R)
  Future<void> _loadTasks() async {
    final data = await DatabaseHelper().getTasks();
    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  // Método para excluir tarefa (CRUD - D) e recarregar a lista
  void _deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    _loadTasks(); // Atualiza a ListView.builder (Requisito obrigatório)
  }

  // Navega para o formulário para criar ou editar
  void _navigateAndRefresh(Task? task) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskFormPage(task: task),
      ),
    );
    // ⚠️ REQUISITO OBRIGATÓRIO: Atualizar a ListView.builder
    _loadTasks(); 
  }

  // Retorna a cor do item com base na prioridade
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red.shade100; // Alta
      case 2:
        return Colors.yellow.shade100; // Média
      case 3:
        return Colors.green.shade100; // Baixa
      default:
        return Colors.white;
    }
  }

  // Retorna o rótulo da prioridade
  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1: return 'Alta';
      case 2: return 'Média';
      case 3: return 'Baixa';
      default: return 'Desconhecida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Profissionais - Tema Aurora'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildTaskList(),
      
      // Botão para adicionar nova tarefa
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefresh(null), // Novo cadastro
        child: const Icon(Icons.add),
      ),
    );
  }

  // ⚠️ REQUISITO OBRIGATÓRIO: ListView.builder
  Widget _buildTaskList() {
    if (_tasks.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma tarefa cadastrada. Clique em "+" para adicionar.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: _getPriorityColor(task.prioridade),
          elevation: 4,
          child: ListTile(
            title: Text(
              task.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Descrição: ${task.descricao}'),
                Text('Prioridade: ${_getPriorityLabel(task.prioridade)}'),
                // 📌 EXIBIÇÃO DO CAMPO EXTRA
                Text('Analista Designado: ${task.analistaDesignado}', style: const TextStyle(fontStyle: FontStyle.italic)),
                Text('Criado em: ${DateFormat('dd/MM/yyyy HH:mm').format(task.criadoEm)}'),
              ],
            ),
            // Botões de ação (Editar e Excluir)
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                  onPressed: () => _navigateAndRefresh(task), // Edição
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(task.id!), // Exclusão
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}