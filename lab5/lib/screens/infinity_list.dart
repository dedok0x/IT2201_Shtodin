import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class InfinityListScreen extends StatelessWidget {
  const InfinityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бесконечный список'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Строка ${index + 1}'),
          );
        },
      ),
    );
  }
}