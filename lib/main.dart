// main.dart
import 'package:flutter/material.dart';
import 'pages/task_list_page.dart'; // Você criará esta tela a seguir

void main() {
  // Garante que o Flutter Binding esteja inicializado antes de acessar
  // recursos nativos como o banco de dados (path_provider)eu qeuro
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Cadastro de Tarefas Profissionais - Tema Aurora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema Aurora: Cores vibrantes
        primarySwatch: Colors.teal, // Cor base
        scaffoldBackgroundColor: Colors.grey[50],
        
        // Cores personalizadas
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          accentColor: Colors.cyanAccent
        ).copyWith(
          secondary: Colors.cyanAccent,
          primary: Colors.tealAccent,
        ),

        // Estilo da AppBar
        appBarTheme: AppBarTheme(
          color: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Estilo dos Floating Action Buttons
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.cyanAccent,
          foregroundColor: Colors.black,
        ),
      ),
      home: const TaskListPage(),
    );
  }
}