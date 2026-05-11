import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лента новостей КубГАУ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<NewsItem>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лента новостей КубГАУ'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Ошибка: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureNews = fetchNews();
                      });
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Новостей пока нет'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return NewsCard(news: snapshot.data![index]);
              },
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Загрузка новостей...'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Future<List<NewsItem>> fetchNews() async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://kubsau.ru/api/getNews.php?key=6df2f5d38d4e16b5a923a6d4873e2ee295d0ac90'),
    ).timeout(const Duration(seconds: 15));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      print('Parsed ${jsonData.length} items');
      
      return jsonData.map((item) {
        print('Item keys: ${item.keys}');
        return NewsItem.fromJson(item);
      }).toList();
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Ошибка загрузки новостей: $e');
  }
}

class NewsItem {
  final String title;
  final String date;
  final String description;
  final String? imageUrl;

  NewsItem({
    required this.title,
    required this.date,
    required this.description,
    this.imageUrl,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    print('Raw JSON: $json');
    
    // Пробуем разные возможные названия полей
    String rawTitle = '';
    if (json.containsKey('title')) {
      rawTitle = json['title']?.toString() ?? '';
    } else if (json.containsKey('name')) {
      rawTitle = json['name']?.toString() ?? '';
    } else if (json.containsKey('header')) {
      rawTitle = json['header']?.toString() ?? '';
    } else {
      rawTitle = json.keys.firstWhere(
        (k) => k.toLowerCase().contains('title') || k.toLowerCase().contains('name'),
        orElse: () => '',
      );
      if (rawTitle.isNotEmpty) {
        rawTitle = json[rawTitle]?.toString() ?? '';
      }
    }

    // Очищаем от HTML тегов
    String cleanTitle = rawTitle
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .trim();

    if (cleanTitle.isEmpty) {
      cleanTitle = 'Новость';
    }

    String rawDate = json['date']?.toString() ?? json['pubDate']?.toString() ?? json['created']?.toString() ?? '';
    String formattedDate = rawDate;
    if (rawDate.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(rawDate);
        formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
      } catch (e) {
        formattedDate = rawDate;
      }
    } else {
      formattedDate = 'Дата не указана';
    }

    String rawDescription = json['description']?.toString() ?? json['text']?.toString() ?? json['content']?.toString() ?? '';
    String cleanDescription = rawDescription
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .trim();

    if (cleanDescription.length > 200) {
      cleanDescription = cleanDescription.substring(0, 200) + '...';
    }

    String? imageUrl = json['image']?.toString() ?? json['img']?.toString() ?? json['picture']?.toString();

    return NewsItem(
      title: cleanTitle,
      date: formattedDate,
      description: cleanDescription,
      imageUrl: imageUrl,
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.news});

  final NewsItem news;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl != null && news.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  news.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 48),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            Text(
              news.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              news.date,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              news.description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}