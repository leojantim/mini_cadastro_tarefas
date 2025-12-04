class Task {
  int? id;
  String titulo;
  String descricao;
  int prioridade;
  DateTime criadoEm;
  
  // 📌 CAMPO EXTRA PERSONALIZADO
  String analistaDesignado; // Nome do Analista Responsável

  Task({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    required this.criadoEm,
    required this.analistaDesignado, // Seu campo extra
  });

  // Converte um objeto Task em um Map (JSON) para o Sqflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade,
      'criadoEm': criadoEm.millisecondsSinceEpoch, // Salva como timestamp
      'analistaDesignado': analistaDesignado, // Mapeia o campo extra
    };
  }

  // Cria um objeto Task a partir de um Map (JSON) do Sqflite
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      prioridade: map['prioridade'],
      criadoEm: DateTime.fromMillisecondsSinceEpoch(map['criadoEm']),
      analistaDesignado: map['analistaDesignado'], // Mapeia o campo extra
    );
  }
}