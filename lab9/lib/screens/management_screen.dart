import 'package:flutter/material.dart';
import '../classes/machine.dart';

class ManagementScreen extends StatefulWidget {
  final Machine machine;

  const ManagementScreen({required this.machine, super.key});

  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _coffeeBeansController = TextEditingController();
  final TextEditingController _milkController = TextEditingController();
  String _message = '';

  @override
  void dispose() {
    _waterController.dispose();
    _coffeeBeansController.dispose();
    _milkController.dispose();
    super.dispose();
  }

  void _refillResources() {
    double water = double.tryParse(_waterController.text) ?? 0;
    double coffeeBeans = double.tryParse(_coffeeBeansController.text) ?? 0;
    double milk = double.tryParse(_milkController.text) ?? 0;

    setState(() {
      widget.machine.water += water;
      widget.machine.coffeeBeans += coffeeBeans;
      widget.machine.milk += milk;
      _message = 'Ресурсы пополнены';
      _waterController.clear();
      _coffeeBeansController.clear();
      _milkController.clear();
    });
  }

  void _resetCash() {
    setState(() {
      widget.machine.resetCash();
      _message = 'Касса обнулена';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildResourcesCard(colorScheme),
          const SizedBox(height: 20),
          _buildRefillCard(colorScheme),
          const SizedBox(height: 20),
          _buildCashControlCard(colorScheme),
          if (_message.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _message,
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResourcesCard(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ресурсы',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildResourceItem(
              Icons.water_drop,
              'Вода',
              '${widget.machine.water} мл',
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildResourceItem(
              Icons.coffee,
              'Кофейные зерна',
              '${widget.machine.coffeeBeans} г',
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildResourceItem(
              Icons.local_drink,
              'Молоко',
              '${widget.machine.milk} мл',
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildResourceItem(
              Icons.money,
              'Наличные',
              '${widget.machine.cash} руб.',
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(IconData icon, String label, String value, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRefillCard(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Пополнение ресурсов',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildResourceInputField(
              _waterController,
              'Вода (мл)',
              Icons.water_drop,
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildResourceInputField(
              _coffeeBeansController,
              'Кофейные зерна (г)',
              Icons.coffee,
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildResourceInputField(
              _milkController,
              'Молоко (мл)',
              Icons.local_drink,
              colorScheme,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _refillResources,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('Пополнить ресурсы'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceInputField(
      TextEditingController controller,
      String label,
      IconData icon,
      ColorScheme colorScheme,
      ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: colorScheme.primary),
        filled: true,
        fillColor: colorScheme.surfaceVariant,
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCashControlCard(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Управление кассой',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _resetCash,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: colorScheme.errorContainer,
                foregroundColor: colorScheme.onErrorContainer,
              ),
              child: const Text('Обнулить кассу'),
            ),
          ],
        ),
      ),
    );
  }
}