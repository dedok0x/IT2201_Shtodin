import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'Меню',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Colors.green),
            title: const Text('Простой список'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/simple');
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.infinite, color: Colors.green),
            title: const Text('Бесконечный список'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/infinity');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate, color: Colors.green),
            title: const Text('Математический список'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/math');
            },
          ),
        ],
      ),
    );
  }
}