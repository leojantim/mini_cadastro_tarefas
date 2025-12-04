// lib/database/database_helper.dart
import 'package:mini_cadastro_tarefas/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const String _dbName = 'mini_tasks_202310137.db'; 
  static const int _dbVersion = 1;
  static const String _tableName = 'tasks';

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      descricao TEXT,
      prioridade INTEGER NOT NULL,
      criadoEm INTEGER NOT NULL, 
      analistaDesignado TEXT
    )
  ''');
  }

  // 1. C (Create) - Inserir Tarefa
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(
      _tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 2. R (Read) - Listar Todas as Tarefas
  Future<List<Task>> getTasks() async {
    final db = await database;
    // Ordena por Prioridade (1=Alta) e mais recente
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'prioridade ASC, criadoEm DESC', 
    );
  
  // Converte List<Map> em List<Task>
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // 3. U (Update) - Editar Tarefa
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // 4. D (Delete) - Excluir Tarefa
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 5. Método auxiliar para o Print JSON
  Future<Map<String, dynamic>?> getLastInsertedTaskMap() async {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'id DESC',
        limit: 1,
      );
      return maps.isNotEmpty ? maps.first : null;
  }
}