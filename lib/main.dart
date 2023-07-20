import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  void _addTodoItem(String task) {
    setState(() {
      _todoItems.add(task);
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void _toggleTodoItem(int index) {
    setState(() {
      _todoItems[index] = _todoItems[index].startsWith('✓ ')
          ? _todoItems[index].substring(2)
          : '✓ ' + _todoItems[index];
    });
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover tarefa'),
          content: Text('Deseja remover esta tarefa?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
              child: Text('Remover'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return ListTile(
      title: Text(todoText),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _promptRemoveTodoItem(index),
      ),
      leading: Checkbox(
        value: todoText.startsWith('✓ '),
        onChanged: (bool? value) {
          _toggleTodoItem(index);
        },
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return _buildTodoItem(_todoItems[index], index);
      },
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Adicionar Tarefa'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  return _buildTodoItem(_todoItems[index], index);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _showAddDialog();
                },
                child: Text('Postar'),
              ),
            ),
          ],
        ),
      );
    }));
  }

void _showAddDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String newTask = '';
      return AlertDialog(
        title: Text('Adicionar Tarefa'),
        content: TextField(
          autofocus: true,
          onChanged: (value) {
            newTask = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (newTask.trim().isNotEmpty) {
                _addTodoItem(newTask);
                Navigator.of(context).pop(); // Fecha o diálogo
                _pushAddTodoScreen(); // Navega de volta para a tela principal
              }
            },
            child: Text('Adicionar'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Adicionar tarefa',
        child: Icon(Icons.add),
      ),
    );
  }
}
