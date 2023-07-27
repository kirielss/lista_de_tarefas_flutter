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
      theme: ThemeData.light(), // Defina o tema claro padrão.
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.white, // Cor da barra de navegação e AppBar no modo escuro.
        scaffoldBackgroundColor: Colors.grey[900], // Cor de fundo do Scaffold no modo escuro.
        textTheme: ThemeData.dark().textTheme.copyWith(  
        ),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoTask> _todoItems = [];
  ThemeMode _currentTheme = ThemeMode.light;
  int _completedTasksCount = 0;

  void _addTodoItem(String task, String? time, String? date) {
    setState(() {
      _todoItems.add(TodoTask(task, time, date));
    });
    Navigator.of(context).pop(); // Fecha o diálogo após adicionar a tarefa
  }

  void _removeTodoItem(int index) {
    setState(() {
      if (_todoItems[index].isCompleted) {
        _completedTasksCount--;
      }
      _todoItems.removeAt(index);
    });
  }

  void _toggleTodoItem(int index) {
    setState(() {
      _todoItems[index].isCompleted = !_todoItems[index].isCompleted;
      if (_todoItems[index].isCompleted) {
        _completedTasksCount++;
      } else {
        _completedTasksCount--;
      }
    });
  }

  void _editTodoItem(int index) {
    String editedTask = _todoItems[index].text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: TextEditingController(text: editedTask),
                onChanged: (value) {
                  editedTask = value;
                },
              ),
            ],
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
                if (editedTask.trim().isNotEmpty) {
                  setState(() {
                    _todoItems[index].text = editedTask;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
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

  Widget _buildTodoItem(TodoTask task, int index) {
    bool isCompleted = task.isCompleted;

    return ListTile(
      leading: isCompleted
          ? Icon(Icons.check, color: Colors.green) // Ícone de verificado
          : Icon(Icons.check_box_outline_blank), // Ícone de não verificado
      title: RichText(
        text: TextSpan(
          text: isCompleted ? '✓ ' : '',
          style: TextStyle(color: Colors.green),
          children: [
            TextSpan(
              text: task.text,
              style: TextStyle(
                color: isCompleted ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCompleted && task.time != null)
            Text('Hora prevista: ${task.time}'),
          if (!isCompleted && task.date != null)
            Text('Data do dia: ${task.date}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editTodoItem(index),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _promptRemoveTodoItem(index),
          ),
        ],
      ),
      onTap: () => _toggleTodoItem(index),
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
    String newTask = '';
    TimeOfDay? selectedTime;
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Adicionar Tarefa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    onChanged: (value) {
                      newTask = value;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        setState(() {});
                      }
                    },
                    child: Text(
                      selectedTime != null
                          ? 'Hora: ${selectedTime!.format(context)}'
                          : 'Selecionar hora',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (selectedDate != null) {
                        setState(() {});
                      }
                    },
                    child: Text(
                      selectedDate != null
                          ? 'Data: ${selectedDate!.toString().substring(0, 10)}'
                          : 'Selecionar data',
                    ),
                  ),
                ],
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
                      _addTodoItem(
                        newTask,
                        selectedTime?.format(context),
                        selectedDate?.toString().substring(0, 10),
                      );
                    }
                  },
                  child: Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Método para alternar entre o tema claro e escuro.
  void _toggleTheme() {
    setState(() {
      _currentTheme =
          _currentTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData.light(), // Defina o tema claro padrão.
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.black, // Cor da barra de navegação e AppBar no modo escuro.
        scaffoldBackgroundColor: Colors.grey[900], // Cor de fundo do Scaffold no modo escuro.
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white, // Cor do texto do corpo no modo escuro.
              displayColor: Colors.white, // Cor do texto de títulos e legendas no modo escuro.
            ),
      ),
      themeMode: _currentTheme, // Defina o tema atual com base na variável _currentTheme.
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefas'),
          actions: [ // Adicione o botão do dark mode na AppBar.
            IconButton(
              icon: Icon(Icons.dark_mode),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: _buildTodoList(),
        floatingActionButton: FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Adicionar tarefa',
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: _completedTasksCount > 0
            ? BottomAppBar(
                shape: CircularNotchedRectangle(),
                child: Container(
                  height: 50.0,
                  child: Center(
                    child: Text('$_completedTasksCount tarefa(s) já feita(s)'),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class TodoTask {
  String text;
  String? time;
  String? date;
  bool isCompleted;

  TodoTask(this.text, this.time, this.date) : isCompleted = false; // Inicialmente, a tarefa não está concluída.
}
