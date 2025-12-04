// lib/pages/task_form_page.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../database/database_helper.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task; // Tarefa a ser editada (null para novo cadastro)

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para os TextFields
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _analystController; // Controller do Campo Extra

  // Variável para a prioridade (default 3 - Baixa)
  int _selectedPriority = 3;

  @override
  void initState() {
    super.initState();
    // Inicializa os controllers com os dados da tarefa, se for edição
    _titleController = TextEditingController(text: widget.task?.titulo ?? '');
    _descriptionController = TextEditingController(text: widget.task?.descricao ?? '');
    _analystController = TextEditingController(text: widget.task?.analistaDesignado ?? ''); // Campo Extra

    if (widget.task != null) {
      _selectedPriority = widget.task!.prioridade;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _analystController.dispose();
    super.dispose();
  }

  // Método de salvar (CRUD - C e U)
  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      final newTask = Task(
        id: widget.task?.id, // Manter o ID para edição
        titulo: _titleController.text,
        descricao: _descriptionController.text,
        prioridade: _selectedPriority,
        criadoEm: widget.task?.criadoEm ?? now, // Mantém data original na edição
        analistaDesignado: _analystController.text, // Campo Extra
      );

      if (newTask.id == null) {
        // Novo cadastro (C - Create)
        await DatabaseHelper().insertTask(newTask);
      } else {
        // Edição (U - Update)
        await DatabaseHelper().updateTask(newTask);
      }
      
      // Retorna para a tela anterior
      Navigator.of(context).pop(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. TÍTULO (Obrigatório)
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título da Tarefa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                // ⚠️ VALIDAÇÃO OBRIGATÓRIA
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 2. DESCRIÇÃO
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              // 3. CAMPO EXTRA (Obrigatório)
              TextFormField(
                controller: _analystController,
                decoration: const InputDecoration(
                  labelText: 'Analista Designado (Obrigatório)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                // ⚠️ VALIDAÇÃO OBRIGATÓRIA
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O Analista Designado é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // 4. PRIORIDADE (Dropdown)
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedPriority,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1 - Alta (Urgente)', style: TextStyle(color: Colors.red))),
                      DropdownMenuItem(value: 2, child: Text('2 - Média', style: TextStyle(color: Colors.orange))),
                      DropdownMenuItem(value: 3, child: Text('3 - Baixa', style: TextStyle(color: Colors.green))),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPriority = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botão de Salvar
              ElevatedButton.icon(
                onPressed: _saveTask,
                icon: const Icon(Icons.save),
                label: Text(widget.task == null ? 'Salvar Tarefa' : 'Atualizar Tarefa'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black, // Cor do texto no botão
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}