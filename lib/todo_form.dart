import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TodoForm extends StatefulWidget {
  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final TextEditingController _titleController = TextEditingController();
  List<Map<String, dynamic>> _todos = [];

  @override
  void initState() {
    super.initState();
    _readTodosFromFile();
  }

  void _readTodosFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/todos.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        setState(() {
          _todos = List<Map<String, dynamic>>.from(json.decode(contents));
        });
      }
    } catch (e) {
      print("Error reading todos from file: $e");
    }
  }

  void _saveTodosToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/todos.json');
      await file.writeAsString(json.encode(_todos));
    } catch (e) {
      print("Error saving todos to file: $e");
    }
  }

  void _addTodo() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enter Todo first"),
        backgroundColor: Colors.red,
      ));
    } else {
      final newTodo = {
        'title': _titleController.text,
        'completed': false,
      };
      setState(() {
        _todos.add(newTodo);
      });
      _saveTodosToFile();
      _titleController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Todo Added"),
        backgroundColor: Colors.green,
      ));
    }
  }

  void _toggleTodoCompletion(int index) {
    setState(() {
      _todos[index]['completed'] = !_todos[index]['completed'];
    });
    _saveTodosToFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'TODO Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addTodo();
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  var tileColor = generateRandomLightColor();
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black45),
                    ),
                    child: ListTile(
                      title: Text(todo['title']),
                      leading: Checkbox(
                        value: todo['completed'],
                        onChanged: (bool? value) {
                          _toggleTodoCompletion(index);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteTodo(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to generate random color for tile colors
  Color generateRandomLightColor() {
    Random random = Random();
    int red = 180 + random.nextInt(55);
    int green = 180 + random.nextInt(55);
    int blue = 180 + random.nextInt(55);
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _saveTodosToFile();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Todo Removed Successfully!"),
      backgroundColor: Colors.green,
    ));
  }
}
