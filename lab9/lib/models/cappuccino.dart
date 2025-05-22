// cappuccino.dart
import 'icoffee.dart';
import 'coffee_resources.dart';
import 'coffee_type.dart';

class Cappuccino implements ICoffee {
  @override
  CoffeeType get type => CoffeeType.cappuccino;

  @override
  String get name => 'Капучино';

  @override
  double get price => 130;

  @override
  CoffeeResources get resources => CoffeeResources(
    coffeeBeans: 50,
    milk: 50,
    water: 100,
  );

  @override
  Future<void> prepare(Function(String p1) statusCallback) {
    throw UnimplementedError();
  }
}