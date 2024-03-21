import 'package:flutter/material.dart';
import 'package:todo_app/animals_kingdom/animals_details_screen.dart';
import 'package:todo_app/animals_kingdom/animals_list.dart';
import 'package:todo_app/constants/navigation_constants.dart';

class AnimalListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animal List')),
      body: ListView.builder(
        itemCount: animals.length,
        itemBuilder: (context, index) {
          final animal = animals[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black45),
            ),
            child: ListTile(
              title: Text(animal.name),
              onTap: () {
                nextScreen(context, AnimalDetailsScreen(animal: animal));
              },
            ),
          );
        },
      ),
    );
  }
}
