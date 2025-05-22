import '../models/icoffee.dart';

class Machine {
  double _coffeeBeans = 500;
  double _milk = 1000;
  double _water = 2000;
  double _cash = 0;

  double get coffeeBeans => _coffeeBeans;
  double get milk => _milk;
  double get water => _water;
  double get cash => _cash;

  set coffeeBeans(double value) => _coffeeBeans = value;
  set milk(double value) => _milk = value;
  set water(double value) => _water = value;

  void addCash(double amount) => _cash += amount;
  void spendCash(double amount) => _cash -= amount;
  void resetCash() => _cash = 0;

  bool isAvailable(ICoffee coffee) {
    final res = coffee.resources;
    return _coffeeBeans >= res.coffeeBeans &&
        _milk >= res.milk &&
        _water >= res.water;
  }

  Future<String> makingCoffee(ICoffee coffee, Function(String) callback) async {
    final res = coffee.resources;
    _coffeeBeans -= res.coffeeBeans;
    _milk -= res.milk;
    _water -= res.water;

    await coffee.prepare(callback);
    return '${coffee.name} готов!';
  }
}