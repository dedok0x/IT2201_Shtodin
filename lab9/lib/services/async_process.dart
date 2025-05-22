import 'dart:async';
import '../models/coffee_type.dart';
import '../models/icoffee.dart';

class AsyncProcess {
  static Future<void> heatWater(Function(String) callback) async {
    callback('Нагрев воды...');
    await Future.delayed(Duration(seconds: 3));
  }

  static Future<void> brewCoffee(Function(String) callback) async {
    callback('Приготовление эспрессо...');
    await Future.delayed(Duration(seconds: 5));
  }

  static Future<void> frothMilk(Function(String) callback) async {
    callback('Взбивание молока...');
    await Future.delayed(Duration(seconds: 5));
  }

  static Future<void> prepareCoffee(ICoffee coffee, Function(String) callback) async {
    callback('Начинаем приготовление ${coffee.name}...');

    await heatWater(callback);
    await brewCoffee(callback);

    if (coffee.type != CoffeeType.espresso) {
      await frothMilk(callback);
      callback('Смешивание компонентов для ${coffee.name}...');
      await Future.delayed(Duration(seconds: 3));
    }

    callback('${coffee.name} почти готов!');
    await Future.delayed(Duration(seconds: 1));
  }
}