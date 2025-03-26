import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DormitoryPage());
  }
}

class DormitoryPage extends StatefulWidget {
  @override
  _DormitoryPageState createState() => _DormitoryPageState();
}

class _DormitoryPageState extends State<DormitoryPage> {
  int _likeCount = 0; // Начальное значение счетчика

  void _incrementLikeCount() {
    setState(() {
      _likeCount++;
    });
  }

  Future<void> _launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Общежитие КГАУ'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://sun9-40.userapi.com/s/v1/ig2/m8wRvQ70t4diy--ngylsjzqPH0Q0zKd_zXn2MDsAG7jW6_HqWtmFZS9vQ-jA2h6Ybe842VvvBt7WkXUWPvdXymqG.jpg?quality=95&as=32x23,48x34,72x51,108x77,160x114,240x171,360x257,480x343,540x385,640x457,720x514,1080x771,1280x913,1435x1024&from=bu&u=vkdmz6YeWjWtphWD_EJyCAmvnI8spNDZd83OvRNVUpU&cs=604x431', // Замените на URL изображения
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ListTile(
              title: Text('Общежитие №20'),
              subtitle: Text('Краснодар, ул. Калинина, 13'),
              textColor: Colors.black,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: _incrementLikeCount,
                  ),
                  Text('$_likeCount'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.phone, color: Colors.green, size: 30),
                      onPressed: () {
                        _launchURL('https://yandex.ru/maps/org/obshchezhitiye_20/87985623421/?ll=38.920741%2C45.050329&z=7');
                        _launchURL('https://yandex.ru/maps/org/obshchezhitiye_20/87985623421/?ll=38.920741%2C45.050329&z=7');
                      },
                    ),
                    Text('Позвонить'),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.navigation, color: Colors.green, size: 30),
                      onPressed: () {
                      },
                    ),
                    Text('Маршрут'),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share, color: Colors.green, size: 30),
                      onPressed: () {
                        _launchURL('https://yandex.ru/maps/org/obshchezhitiye_20/87985623421/?ll=38.920741%2C45.050329&z=7');
                      },
                    ),
                    Text('Поделиться'),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Студенческий городок или так называемый кампус Кубанского ГАУ состоит из двадцати общежитий, в которых проживает более 8000 студентов, что составляет 96% от всех нуждающихся. Студенты первого курса обеспечены местами в общежитии полностью. В соответствии с Положением о студенческих общежитиях университета, при поселении между администрацией и студентами заключается договор найма жилого помещения. Воспитательная работа в общежитиях направлена на улучшение быта, соблюдение правил внутреннего распорядка, отсутствия асоциальных явлений в молодежной среде. Условия проживания в общежитиях университетского кампуса полностью отвечают санитарным нормам и требованиям: наличие оборудованных кухонь, душевых комнат, прачечных, читальных залов, комнат самоподготовки, помещений для заседаний студенческих советов и наглядной агитации. С целью улучшения условий быта студентов активно работает система студенческого самоуправления - студенческие советы организуют всю работу по самообслуживанию.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}