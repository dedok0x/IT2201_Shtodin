import 'dart:async';
import '../models/coffee_type.dart';
import '../models/icoffee.dart';

class AsyncProcess {
  static Future<void> heatWater(Function(String) callback) async {
    callback('Нагрев воды...');
    await Future.delayed(const Duration(seconds: 3));
  }

  static Future<void> brewCoffee(Function(String) callback) async {
    callback('Приготовление эспрессо...');
    await Future.delayed(const Duration(seconds: 5));
  }

  static Future<void> frothMilk(Function(String) callback) async {
    callback('Взбивание молока...');
    await Future.delayed(const Duration(seconds: 5));
  }

  static Future<void> mixIngredients(Function(String) callback) async {
    callback('Смешивание компонентов...');
    await Future.delayed(const Duration(seconds: 2));
  }

  static Future<void> finishing(Function(String) callback) async {
    callback('Смешивание компонентов...');
    await Future.delayed(const Duration(seconds: 1));
  }
}