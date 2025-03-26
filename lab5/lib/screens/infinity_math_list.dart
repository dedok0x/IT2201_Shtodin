import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class InfinityMathListScreen extends StatelessWidget {
  const InfinityMathListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Математический список'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final power = index + 1;
          final result = BigInt.from(2).pow(power);
          return ListTile(
            title: Text('2^$power = $result'),
          );
        },
      ),
    );
  }
}