import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите вариант'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, 'Да!'),
                child: const Text('Да!'),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, 'Нет.'),
                child: const Text('Нет.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}