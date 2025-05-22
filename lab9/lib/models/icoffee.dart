import 'coffee_resources.dart';
import 'coffee_type.dart';

abstract class ICoffee {
  CoffeeType get type;
  String get name;
  double get price;
  CoffeeResources get resources;
  Future<void> prepare(Function(String) statusCallback);
}