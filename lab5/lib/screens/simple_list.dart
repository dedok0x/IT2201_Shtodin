import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class SimpleListScreen extends StatelessWidget {
  const SimpleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Простой список'),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        children: const [
          ListTile(title: Text('0000')),
          ListTile(title: Text('0001')),
          ListTile(title: Text('0010')),
        ],
      ),
    );
  }
}