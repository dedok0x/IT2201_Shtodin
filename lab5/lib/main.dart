import 'package:flutter/material.dart';
import 'screens/simple_list.dart';
import 'screens/infinity_list.dart';
import 'screens/infinity_math_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список элементов',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
      ),
      home: const SimpleListScreen(),
      routes: {
        '/simple': (context) => const SimpleListScreen(),
        '/infinity': (context) => const InfinityListScreen(),
        '/math': (context) => const InfinityMathListScreen(),
      },
    );
  }
}