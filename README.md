# mini_cadastro_tarefas

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 👨‍💻 Mini Cadastro de Tarefas Profissionais - Versão Final

## Aluno

Leonardo Trevisan Jantim 202310137
Kaique Freitas Melloto 202310216

---

## 🎯 Requisitos da Prova Cumpridos

### 1. Campo Personalizado

| Detalhe | Especificação |
| :--- | :--- |
| **Nome do Campo no Modelo** | `analistaDesignado` |
| **Tipo de Dado** | `TEXT` (String) |
| **Implementação** | Implementado no Modelo (`Task.dart`), na Tabela do Banco (`_onCreate` em `DatabaseHelper.dart`) e com validação obrigatória na UI (`TaskFormPage`). |

### 2. Banco de Dados

* O arquivo do banco de dados foi criado com sucesso com o nome: `mini_tasks_202310137.db`.
* A tabela `tasks` foi criada contendo o campo extra `analistaDesignado`.
* O CRUD completo (Create, Read, Update, Delete) foi implementado na classe `DatabaseHelper`.

### 3. Commit History (Histórico de Commits)

A entrega final foi registrada em 4 commits sequenciais, conforme exigido:

1.  `commit 1: criacao do projeto`
2.  `commit 2: criacao do banco`
3.  `commit 3: implementacao do CRUD`
4.  `commit 4: versao final`

---

## 💡 Dificuldades Encontradas (Superadas)

A parte mais desafiadora do projeto foi a integração do Git e a comunicação com o ambiente Android, o que exigiu as seguintes correções:

1.  **Conflitos de Merge:** Ocorreu um conflito no `README.md` ao tentar sincronizar o histórico do GitHub, que foi resolvido manualmente com **`git rebase --continue`**.
2.  **Erro de Compilação do Tema:** A propriedade `primaryColorDark` estava obsoleta na definição do `ColorScheme`, sendo corrigida para usar `primary` e `secondary` para aplicar o **Tema Aurora** corretamente.
3.  **Acesso ao Banco de Dados:** Houve problemas de `PATH` para o comando `adb`, dificultando a cóllpia do arquivo `.db` do emulador para o computador para fins de documentação.

---

## 📸 Arquivos de Prova

Todos os prints obrigatórios, incluindo a estrutura do banco (`analistaDesignado`) e o nome do arquivo (`mini_tasks_RA_...`) foram salvos na pasta **`prints/`** e anexados ao `commit 4`.
