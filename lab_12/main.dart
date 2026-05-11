import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      home: const CoffeeMachineScreen(),
    );
  }
}

class CoffeeMachineScreen extends StatefulWidget {
  const CoffeeMachineScreen({super.key});

  @override
  State<CoffeeMachineScreen> createState() => _CoffeeMachineScreenState();
}

class _CoffeeMachineScreenState extends State<CoffeeMachineScreen> {
  final CoffeeMachine _machine = CoffeeMachine();
  bool _isMaking = false;
  String _message = 'Выберите напиток';

  void _makeCoffee(CoffeeType type, String name, int price) async {
    if (_isMaking) {
      _showMessage('Подождите, кофе уже готовится');
      return;
    }

    setState(() {
      _isMaking = true;
      _message = 'Приготовление $name...';
    });

    bool success = await _machine.makeCoffee(type);
    
    setState(() {
      _isMaking = false;
      if (success) {
        _message = '$name готов! С вас $price руб.';
      } else {
        _message = 'Недостаточно ресурсов для $name';
      }
    });
    
    _showMessage(_message);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  void _addIngredient(String type) {
    setState(() {
      switch (type) {
        case 'coffee':
          _machine.addCoffeeBeans(50);
          _showMessage('Добавлено 50 г кофе. Теперь: ${_machine.coffeeBeans} г');
          break;
        case 'water':
          _machine.addWater(500);
          _showMessage('Добавлено 500 мл воды. Теперь: ${_machine.water} мл');
          break;
        case 'milk':
          _machine.addMilk(300);
          _showMessage('Добавлено 300 мл молока. Теперь: ${_machine.milk} мл');
          break;
      }
    });
  }

  void _takeCash() {
    setState(() {
      int cash = _machine.takeCash();
      _showMessage('Вы забрали $cash руб. из кассы');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Кофемашина'),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.coffee), text: 'Приготовление'),
              Tab(icon: Icon(Icons.settings), text: 'Управление'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderTab(),
            _buildManagementTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Дисплей с ресурсами (как на рисунке 26)
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Ресурсы кофемашины',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildResourceDisplay(Icons.coffee, 'Кофе', '${_machine.coffeeBeans} г'),
                      _buildResourceDisplay(Icons.water_drop, 'Вода', '${_machine.water} мл'),
                      _buildResourceDisplay(Icons.emoji_food_beverage, 'Молоко', '${_machine.milk} мл'),
                      _buildResourceDisplay(Icons.monetization_on, 'Касса', '${_machine.cash} руб'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Информационное поле
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          // Кнопки заказа
          if (_isMaking)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                _buildCoffeeButton('Эспрессо', 100, CoffeeType.espresso),
                const SizedBox(height: 12),
                _buildCoffeeButton('Капучино', 150, CoffeeType.cappuccino),
                const SizedBox(height: 12),
                _buildCoffeeButton('Латте', 180, CoffeeType.latte),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildResourceDisplay(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.brown),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCoffeeButton(String name, int price, CoffeeType type) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _makeCoffee(type, name, price),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text('$name - $price руб', style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildManagementTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Пополнение ресурсов',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildIngredientButton('Добавить кофе (50 г)', Icons.coffee, 'coffee', Colors.brown),
          const SizedBox(height: 12),
          _buildIngredientButton('Добавить воду (500 мл)', Icons.water_drop, 'water', Colors.brown),
          const SizedBox(height: 12),
          _buildIngredientButton('Добавить молоко (300 мл)', Icons.emoji_food_beverage, 'milk', Colors.brown),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _takeCash,
            icon: const Icon(Icons.money_off),
            label: const Text('Забрать деньги из кассы'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientButton(String text, IconData icon, String type, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _addIngredient(type),
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

// ========== БИЗНЕС-ЛОГИКА (вся на русском) ==========

enum CoffeeType { espresso, cappuccino, latte }

abstract class ICoffee {
  int coffee();
  int water();
  int milk();
  int price();
  String name();
}

class Espresso implements ICoffee {
  @override int coffee() => 50;
  @override int water() => 100;
  @override int milk() => 0;
  @override int price() => 100;
  @override String name() => 'Эспрессо';
}

class Cappuccino implements ICoffee {
  @override int coffee() => 50;
  @override int water() => 100;
  @override int milk() => 100;
  @override int price() => 150;
  @override String name() => 'Капучино';
}

class Latte implements ICoffee {
  @override int coffee() => 50;
  @override int water() => 100;
  @override int milk() => 200;
  @override int price() => 180;
  @override String name() => 'Латте';
}

ICoffee createCoffee(CoffeeType type) {
  switch (type) {
    case CoffeeType.espresso: return Espresso();
    case CoffeeType.cappuccino: return Cappuccino();
    case CoffeeType.latte: return Latte();
  }
}

class CoffeeMachine {
  int _coffeeBeans = 250;
  int _milk = 250;
  int _water = 250;
  int _cash = 0;
  
  int get coffeeBeans => _coffeeBeans;
  int get milk => _milk;
  int get water => _water;
  int get cash => _cash;
  
  void addCoffeeBeans(int amount) { _coffeeBeans += amount; }
  void addWater(int amount) { _water += amount; }
  void addMilk(int amount) { _milk += amount; }
  
  int takeCash() {
    int money = _cash;
    _cash = 0;
    return money;
  }
  
  Future<void> _heatWater() async {
    await Future.delayed(const Duration(seconds: 2));
  }
  
  Future<void> _brewCoffee() async {
    await Future.delayed(const Duration(seconds: 3));
  }
  
  Future<void> _frothMilk() async {
    await Future.delayed(const Duration(seconds: 3));
  }
  
  Future<void> _mix() async {
    await Future.delayed(const Duration(seconds: 2));
  }
  
  bool _checkResources(ICoffee coffee) {
    if (_coffeeBeans < coffee.coffee()) return false;
    if (_water < coffee.water()) return false;
    if (_milk < coffee.milk()) return false;
    return true;
  }
  
  void _useResources(ICoffee coffee) {
    _coffeeBeans -= coffee.coffee();
    _water -= coffee.water();
    _milk -= coffee.milk();
    _cash += coffee.price();
  }
  
  Future<bool> makeCoffee(CoffeeType type) async {
    ICoffee coffee = createCoffee(type);
    
    if (!_checkResources(coffee)) {
      return false;
    }
    
    await _heatWater();
    
    if (coffee.milk() > 0) {
      await Future.wait([_brewCoffee(), _frothMilk()]);
      await _mix();
    } else {
      await _brewCoffee();
    }
    
    _useResources(coffee);
    return true;
  }
}