import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/todo_form.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<dynamic> _todos = [];
  List<dynamic> _filteredTodos = [];
  int _currentPage = 1;
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by Title',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterTodos('');
                        },
                      ),
                    ),
                    onChanged: (value) {
                      _filterTodos(value);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredTodos.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _filteredTodos.length) {
                        return _buildLoadMoreButton();
                      }
                      final todo = _filteredTodos[index];
                      var tileColor = generateRandomLightColor();
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black45),
                        ),
                        child: ListTile(
                          title: Text(todo['title']),
                          subtitle: Text('Completed: ${todo['completed']}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLoadMoreButton() {
    return _isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : GestureDetector(
            onTap: () => _loadMore(),
            child: Container(
              height: 50,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'Load More',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
  }

  // Function to fetch the todo's from api
  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
    });

    final Uri url = Uri.parse(
        'https://jsonplaceholder.typicode.com/todos?_page=$_currentPage&_limit=50');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _todos = json.decode(response.body);
        _filteredTodos = _todos;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // Function to load more todo's for pagination
  Future<void> _loadMore() async {
    setState(() {
      _currentPage++;
    });
    await _loadTodos();
  }

  // Function to search a todo based on Title of todo
  void _filterTodos(String query) {
    List<dynamic> filteredList = _todos.where((todo) {
      return todo['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredTodos = filteredList;
    });
  }

  // Function to generate random color for tile colors
  Color generateRandomLightColor() {
    Random random = Random();
    int red = 180 + random.nextInt(55);
    int green = 180 + random.nextInt(55);
    int blue = 180 + random.nextInt(55);
    return Color.fromRGBO(red, green, blue, 1.0);
  }
}
