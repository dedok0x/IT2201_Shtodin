import 'icoffee.dart';
import 'coffee_resources.dart';
import 'coffee_type.dart';
import '../services/async_process.dart';

class Espresso implements ICoffee {
  @override
  CoffeeType get type => CoffeeType.espresso;

  @override
  String get name => 'Эспрессо';

  @override
  double get price => 100;

  @override
  CoffeeResources get resources => CoffeeResources(
    coffeeBeans: 50,
    milk: 0,
    water: 100,
  );

  @override
  Future<void> prepare(Function(String) callback) async {
    await AsyncProcess.brewCoffee(callback);
  }
}