import 'package:flutter/material.dart';
import 'package:todo_app/modals/animal_modal.dart';

class AnimalDetailsScreen extends StatelessWidget {
  final Animal animal;

  const AnimalDetailsScreen({Key? key, required this.animal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(animal.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              animal.imagePath,
              height: 400,
              width: 400,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${animal.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${animal.description}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
