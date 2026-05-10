import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лаба 5: Списки',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторная работа №5'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SimpleListScreen()),
                );
              },
              child: const Text('Простой список'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfiniteListScreen()),
                );
              },
              child: const Text('Бесконечный список'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PowerListScreen()),
                );
              },
              child: const Text('Бесконечный список (степени)'),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleListScreen extends StatelessWidget {
  const SimpleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Простой список'),
      ),
      body: ListView(
        children: const [
          ListTile(title: Text('0000')),
          Divider(),
          ListTile(title: Text('0001')),
          Divider(),
          ListTile(title: Text('0010')),
        ],
      ),
    );
  }
}

class InfiniteListScreen extends StatelessWidget {
  const InfiniteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бесконечный список'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index % 2 == 0) {
            int lineNumber = index ~/ 2;
            return ListTile(title: Text('строка $lineNumber'));
          } else {
            return const Divider();
          }
        },
      ),
    );
  }
}

class PowerListScreen extends StatelessWidget {
  const PowerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Степени числа 2'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index % 2 == 0) {
            int powerIndex = index ~/ 2;
            int result = 1;
            for (int i = 0; i < powerIndex; i++) {
              result = result * 2;
            }
            return ListTile(title: Text('2^$powerIndex = $result'));
          } else {
            return const Divider();
          }
        },
      ),
    );
  }
}