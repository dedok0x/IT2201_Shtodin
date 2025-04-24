import 'package:flutter/material.dart';

class AreaCalculator extends StatefulWidget {
  const AreaCalculator({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AreaCalculatorState();
}

class _AreaCalculatorState extends State<AreaCalculator> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ширина:'),
                      TextFormField(
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Высота:'),
                      TextFormField(
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Вычислить',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор площади'),
        backgroundColor: Colors.green,
      ),
      body: const AreaCalculator(),
    ),
  ),
);