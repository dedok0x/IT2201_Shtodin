import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фотогалерея',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  void _loadPhotos() {
    setState(() {
      futurePhotos = fetchPhotos();
    });
  }

  Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(
      Uri.parse(
          'https://api.unsplash.com/photos/random/?client_id=FSaLSkgom3iH_1NbEwBFvwyI8cpeFV-5Cja7iGU1SyI&count=30'),
    );
    if (response.statusCode == 200) {
      return parsePhotos(json.decode(response.body));
    } else {
      throw Exception('Failed to load photos');
    }
  }

  List<Photo> parsePhotos(List<dynamic> json) {
    return json.map((photo) => Photo.fromJson(photo)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Фотогалерея'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadPhotos,
            tooltip: 'Обновить изображения',
          ),
        ],
      ),
      body: FutureBuilder<List<Photo>>(
        future: futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Нет данных'));
          } else {
            return PhotoList(photos: snapshot.data!);
          }
        },
      ),
    );
  }
}

class Photo {
  final String id;
  final String url;

  Photo({required this.id, required this.url});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      url: json['urls']['thumb'],
    );
  }
}

class PhotoList extends StatelessWidget {
  final List<Photo> photos;

  const PhotoList({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: Image.network(photos[index].url, fit: BoxFit.cover),
        );
      },
    );
  }
}