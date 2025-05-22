import 'package:flutter/material.dart';
import 'classes/machine.dart';
import 'models/icoffee.dart';
import 'models/espresso.dart';
import 'models/latte.dart';
import 'models/cappuccino.dart';
import 'services/async_process.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Color(0xFFF5F5DC),
      ),
      home: CoffeeHomePage(),
    );
  }
}

class CoffeeHomePage extends StatefulWidget {
  @override
  _CoffeeHomePageState createState() => _CoffeeHomePageState();
}

class _CoffeeHomePageState extends State<CoffeeHomePage> {
  final Machine _machine = Machine();
  String _message = 'Выберите кофе';
  double _moneyEntered = 0.0;
  double _change = 0.0;
  bool _isBrewing = false;
  String _currentCoffee = '';
  String _brewingStatus = '';
  int _currentIndex = 0;
  List<String> _statusMessages = [];

  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _coffeeBeansController = TextEditingController();
  final TextEditingController _milkController = TextEditingController();

  void _makeCoffee(String type) {
    setState(() {
      _currentCoffee = type;
      _message = 'Выбрано: $type. Внесите оплату.';
      _change = 0.0; // Очищаем сдачу при смене выбора
      _statusMessages.clear(); // Очищаем предыдущие статусы
    });
  }

  Future<void> _processPayment() async {
    if (_currentCoffee.isEmpty) {
      setState(() {
        _message = 'Сначала выберите кофе';
      });
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
        _message = 'Недостаточно средств. Нужно ${coffee.price} руб.';
        _change = 0.0;
      });
      return;
    }

    if (!_machine.isAvailable(coffee)) {
      setState(() {
        _message = 'Недостаточно ресурсов для $_currentCoffee.';
      });
      return;
    }

    setState(() {
      _change = _moneyEntered - coffee.price;
      _machine.addCash(coffee.price);
      _isBrewing = true;
      _statusMessages.clear();
    });

    await AsyncProcess.prepareCoffee(coffee, (status) {
      setState(() {
        _statusMessages.add(status);
        _brewingStatus = status;
      });
    });

    setState(() {
      _isBrewing = false;
      _message = '${coffee.name} готов!';
    });
  }

  void _refillResources() {
    double water = double.tryParse(_waterController.text) ?? 0;
    double coffeeBeans = double.tryParse(_coffeeBeansController.text) ?? 0;
    double milk = double.tryParse(_milkController.text) ?? 0;

    setState(() {
      _machine.water += water;
      _machine.coffeeBeans += coffeeBeans;
      _machine.milk += milk;
      _message = 'Ресурсы пополнены';
      _waterController.clear();
      _coffeeBeansController.clear();
      _milkController.clear();
    });
  }

  void _resetCash() {
    setState(() {
      _machine.resetCash();
      _message = 'Наличные сброшены';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кофемашина'),
      ),
      body: _currentIndex == 0 ? _buildCoffeeTab() : _buildManagementTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: 'Меню',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Управление',
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCoffeeSelectionCard(),
          SizedBox(height: 16),
          _buildPaymentCard(),
          SizedBox(height: 16),
          _buildStatusCard(),
        ],
      ),
    );
  }

  Widget _buildManagementTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildResourcesCard(),
          SizedBox(height: 16),
          _buildRefillCard(),
          SizedBox(height: 16),
          _buildCashControlCard(),
        ],
      ),
    );
  }

  Widget _buildCoffeeSelectionCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Выберите кофе:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCoffeeButton('эспрессо', '100 руб'),
                _buildCoffeeButton('латте', '150 руб'),
                _buildCoffeeButton('капучино', '130 руб'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeButton(String coffeeType, String price) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _makeCoffee(coffeeType),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            coffeeType,
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 4),
        Text(price, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPaymentCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Оплата:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Введите сумму',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _moneyEntered = double.tryParse(value) ?? 0.0;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Оплатить', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Статус:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(_message, style: TextStyle(fontSize: 16)),
            if (_isBrewing) ...[
              SizedBox(height: 8),
              ..._statusMessages.map((msg) => Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(msg, style: TextStyle(color: Colors.brown)),
              )).toList(),
            ],
            if (_change > 0)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Сдача: ${_change.toStringAsFixed(2)} руб.',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ресурсы:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildResourceInfo('Вода', '${_machine.water} мл', Icons.water_drop),
            SizedBox(height: 8),
            _buildResourceInfo('Кофейные зерна', '${_machine.coffeeBeans} г', Icons.coffee),
            SizedBox(height: 8),
            _buildResourceInfo('Молоко', '${_machine.milk} мл', Icons.local_drink),
            SizedBox(height: 8),
            _buildResourceInfo('Наличные', '${_machine.cash} руб.', Icons.money),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceInfo(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.brown),
        SizedBox(width: 8),
        Text('$title: ', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Widget _buildRefillCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Пополнить ресурсы:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildResourceInputField(_waterController, 'Вода (мл)', Icons.water_drop),
            SizedBox(height: 8),
            _buildResourceInputField(_coffeeBeansController, 'Кофейные зерна (г)', Icons.coffee),
            SizedBox(height: 8),
            _buildResourceInputField(_milkController, 'Молоко (мл)', Icons.local_drink),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refillResources,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Пополнить', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceInputField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCashControlCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Управление кассой:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetCash,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.red[400],
              ),
              child: Text('Обнулить кассу', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}