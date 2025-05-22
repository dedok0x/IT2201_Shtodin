import 'icoffee.dart';
import 'coffee_resources.dart';
import 'coffee_type.dart';
import '../services/async_process.dart';

class Latte implements ICoffee {
  @override
  CoffeeType get type => CoffeeType.latte;

  @override
  String get name => 'Латте';

  @override
  double get price => 150;

  @override
  CoffeeResources get resources => CoffeeResources(
    coffeeBeans: 50,
    milk: 100,
    water: 100,
  );

  @override
  Future<void> prepare(Function(String) callback) async {
    await AsyncProcess.brewCoffee(callback);
  }
}