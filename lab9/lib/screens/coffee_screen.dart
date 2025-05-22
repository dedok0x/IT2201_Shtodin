import 'package:flutter/material.dart';
import '../classes/machine.dart';
import '../models/coffee_type.dart';
import '../models/icoffee.dart';
import '../models/espresso.dart';
import '../models/latte.dart';
import '../models/cappuccino.dart';

class CoffeeScreen extends StatefulWidget {
  final Machine machine;

  const CoffeeScreen({required this.machine, super.key});

  @override
  _CoffeeScreenState createState() => _CoffeeScreenState();
}

class _CoffeeScreenState extends State<CoffeeScreen> {
  String _message = 'Выберите ваш кофе';
  double _moneyEntered = 0.0;
  double _change = 0.0;
  bool _isBrewing = false;
  String _currentCoffee = '';
  final List<BrewingStep> _brewingSteps = [];
  final Map<CoffeeType, bool> _completedSteps = {
    CoffeeType.espresso: false,
    CoffeeType.latte: false,
    CoffeeType.cappuccino: false,
  };

  void _selectCoffee(String type) {
    setState(() {
      _currentCoffee = type;
      _message = 'Выбрано: $type';
      _change = 0.0;
      _brewingSteps.clear();
      _completedSteps.updateAll((_, __) => false);
    });
  }

  Future<void> _processPayment() async {
    if (_currentCoffee.isEmpty) {
      setState(() => _message = 'Пожалуйста, выберите кофе');
      return;
    }

    ICoffee coffee;
    switch (_currentCoffee) {
      case 'эспрессо':
        coffee = Espresso();
        break;
      case 'латте':
        coffee = Latte();
        break;
      case 'капучино':
        coffee = Cappuccino();
        break;
      default:
        return;
    }

    if (_moneyEntered < coffee.price) {
      setState(() {
        _message = 'Недостаточно средств. Требуется ${coffee.price} руб.';
        _change = 0.0;
      });
      return;
    }

    if (!widget.machine.isAvailable(coffee)) {
      setState(() => _message = 'Недостаточно ресурсов для $_currentCoffee');
      return;
    }

    setState(() {
      _change = _moneyEntered - coffee.price;
      widget.machine.addCash(coffee.price);
      _isBrewing = true;
      _brewingSteps.clear();
      _completedSteps.updateAll((_, __) => false);
      _message = 'Готовим $_currentCoffee...';
    });

    final result = await widget.machine.makingCoffee(coffee, (status) {
      setState(() {
        if (_brewingSteps.isNotEmpty) {
          _brewingSteps.removeLast();
        }
        _brewingSteps.add(BrewingStep(description: status, completed: true));
      });
    });

    setState(() {
      _isBrewing = false;
      _message = result;
      _completedSteps[coffee.type] = true;
      _brewingSteps.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCoffeeSelectionCard(colorScheme),
          const SizedBox(height: 20),
          _buildPaymentCard(colorScheme),
          const SizedBox(height: 20),
          _buildStatusCard(colorScheme),
        ],
      ),
    );
  }

  Widget _buildCoffeeSelectionCard(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Выберите кофе',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
              children: [
                _buildCoffeeOption(
                  'эспрессо',
                  '100 руб',
                  Icons.coffee_maker,
                  colorScheme,
                ),
                _buildCoffeeOption(
                  'латте',
                  '150 руб',
                  Icons.coffee,
                  colorScheme,
                ),
                _buildCoffeeOption(
                  'капучино',
                  '130 руб',
                  Icons.coffee,
                  colorScheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeOption(
      String type,
      String price,
      IconData icon,
      ColorScheme colorScheme,
      ) {
    final isSelected = _currentCoffee == type;

    return GestureDetector(
      onTap: () => _selectCoffee(type),
      child: Column(
        children: [
      Container(
      decoration: BoxDecoration(
      color: isSelected
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          size: 32,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
      ),
      Text(
        type,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: colorScheme.onSurface,
        ),
      ),
      Text(
        price,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 12,
        ),
      ),
      ],
    ),
    );
  }

  Widget _buildPaymentCard(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Оплата',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Введите сумму',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money, color: colorScheme.primary),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _moneyEntered = double.tryParse(value) ?? 0.0,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _processPayment,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('Оплатить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Статус',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _message,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
            if (_isBrewing) ...[
              const SizedBox(height: 16),
              ..._brewingSteps.map((step) => _buildBrewingStep(step, colorScheme)),
            ],
            if (_change > 0) ...[
              const SizedBox(height: 12),
              Text(
                'Сдача: ${_change.toStringAsFixed(2)} руб.',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (_completedSteps.values.any((completed) => completed)) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.check_circle, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Готово!',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBrewingStep(BrewingStep step, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircularProgressIndicator(),
          const SizedBox(width: 12),
          Text(
            step.description,
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class BrewingStep {
  final String description;
  final bool completed;

  BrewingStep({
    required this.description,
    this.completed = false,
  });
}