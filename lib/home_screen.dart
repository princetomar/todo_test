import 'package:flutter/material.dart';
import 'package:todo_app/animals_kingdom/animals_view_page.dart';
import 'package:todo_app/constants/navigation_constants.dart';
import 'package:todo_app/todo_form.dart';
import 'package:todo_app/todo_list_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select one of them".toUpperCase()),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                nextScreen(context, TodoListPage());
              },
              child: Text("Todo List Page"),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                nextScreen(context, TodoForm());
              },
              child: Text("Todo Form Page"),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                nextScreen(context, AnimalListScreen());
              },
              child: Text("Animal Kingdom"),
            )
          ],
        ),
      ),
    );
  }
}
