import 'dart:io';
import 'dart:async';

void main() async {
  CoffeeMachine machine = CoffeeMachine();
  
  print('Добро пожаловать в кофемашину КубГАУ!');
  print('=' * 40);
  
  bool exit = false;
  
  while (!exit) {
    print('\nЧто вы хотите сделать?');
    print('1. Эспрессо - 100 руб');
    print('2. Капучино - 150 руб');
    print('3. Латте - 180 руб');
    print('4. Добавить ингредиенты');
    print('5. Забрать деньги');
    print('6. Показать состояние');
    print('7. Выйти');
    print('-' * 40);
    
    stdout.write('Ваш выбор: ');
    String? choice = stdin.readLineSync();
    
    switch (choice) {
      case '1':
        await machine.makeCoffee(CoffeeType.espresso);
        break;
      case '2':
        await machine.makeCoffee(CoffeeType.cappuccino);
        break;
      case '3':
        await machine.makeCoffee(CoffeeType.latte);
        break;
      case '4':
        _addIngredients(machine);
        break;
      case '5':
        machine.takeCash();
        break;
      case '6':
        machine.printStatus();
        break;
      case '7':
        exit = true;
        print('До свидания!');
        break;
      default:
        print('Неверный выбор! Попробуйте снова.');
    }
  }
}

void _addIngredients(CoffeeMachine machine) {
  print('\nЧто добавить?');
  print('1. Кофейные зёрна (50 г)');
  print('2. Воду (500 мл)');
  print('3. Молоко (300 мл)');
  stdout.write('Ваш выбор: ');
  String? addChoice = stdin.readLineSync();
  
  switch (addChoice) {
    case '1':
      machine.addCoffeeBeans(50);
      break;
    case '2':
      machine.addWater(500);
      break;
    case '3':
      machine.addMilk(300);
      break;
    default:
      print('Неверный выбор!');
  }
}

enum CoffeeType {
  espresso,
  cappuccino,
  latte,
}

abstract class ICoffee {
  int coffee();
  int water();
  int milk();
  int price();
  String name();
}

class Espresso implements ICoffee {
  @override
  int coffee() => 50;
  @override
  int water() => 100;
  @override
  int milk() => 0;
  @override
  int price() => 100;
  @override
  String name() => 'Эспрессо';
}

class Cappuccino implements ICoffee {
  @override
  int coffee() => 50;
  @override
  int water() => 100;
  @override
  int milk() => 100;
  @override
  int price() => 150;
  @override
  String name() => 'Капучино';
}

class Latte implements ICoffee {
  @override
  int coffee() => 50;
  @override
  int water() => 100;
  @override
  int milk() => 200;
  @override
  int price() => 180;
  @override
  String name() => 'Латте';
}

ICoffee createCoffee(CoffeeType type) {
  switch (type) {
    case CoffeeType.espresso:
      return Espresso();
    case CoffeeType.cappuccino:
      return Cappuccino();
    case CoffeeType.latte:
      return Latte();
  }
}

class CoffeeMachine {
  int _coffeeBeans = 200;
  int _milk = 500;
  int _water = 1000;
  int _cash = 0;
  
  int get coffeeBeans => _coffeeBeans;
  int get milk => _milk;
  int get water => _water;
  int get cash => _cash;
  
  void addCoffeeBeans(int amount) {
    _coffeeBeans += amount;
    print('Добавлено $amount г кофейных зёрен. Теперь: $_coffeeBeans г');
  }
  
  void addWater(int amount) {
    _water += amount;
    print('Добавлено $amount мл воды. Теперь: $_water мл');
  }
  
  void addMilk(int amount) {
    _milk += amount;
    print('Добавлено $amount мл молока. Теперь: $_milk мл');
  }
  
  void takeCash() {
    if (_cash > 0) {
      print('Вы забрали $_cash рублей из кассы');
      _cash = 0;
    } else {
      print('В кассе нет денег');
    }
  }
  
  Future<void> _heatWater() async {
    print('Нагрев воды...');
    await Future.delayed(Duration(seconds: 3));
    print('Вода нагрета!');
  }
  
  Future<void> _brewCoffee() async {
    print('Заваривание кофе...');
    await Future.delayed(Duration(seconds: 5));
    print('Кофе заварен!');
  }
  
  Future<void> _frothMilk() async {
    print('Взбивание молока...');
    await Future.delayed(Duration(seconds: 5));
    print('Молоко взбито!');
  }
  
  Future<void> _mix() async {
    print('Смешивание ингредиентов...');
    await Future.delayed(Duration(seconds: 3));
    print('Ингредиенты смешаны!');
  }
  
  bool _checkResources(ICoffee coffee) {
    if (_coffeeBeans < coffee.coffee()) {
      print('Недостаточно кофейных зёрен! Нужно ${coffee.coffee()} г, осталось $_coffeeBeans г');
      return false;
    }
    if (_water < coffee.water()) {
      print('Недостаточно воды! Нужно ${coffee.water()} мл, осталось $_water мл');
      return false;
    }
    if (_milk < coffee.milk()) {
      print('Недостаточно молока! Нужно ${coffee.milk()} мл, осталось $_milk мл');
      return false;
    }
    return true;
  }
  
  void _useResources(ICoffee coffee) {
    _coffeeBeans -= coffee.coffee();
    _water -= coffee.water();
    _milk -= coffee.milk();
    _cash += coffee.price();
  }
  
  Future<void> makeCoffee(CoffeeType type) async {
    ICoffee coffee = createCoffee(type);
    
    if (!_checkResources(coffee)) {
      print('Невозможно приготовить ${coffee.name()}. Пополните запасы!');
      return;
    }
    
    print('\nПриготовление ${coffee.name()}...');
    print('-' * 30);
    
    await _heatWater();
    
    if (coffee.milk() > 0) {
      await Future.wait([_brewCoffee(), _frothMilk()]);
      await _mix();
    } else {
      await _brewCoffee();
    }
    
    _useResources(coffee);
    
    print('-' * 30);
    print('${coffee.name()} готов! Приятного аппетита!');
    print('Добавлено ${coffee.price()} рублей в кассу');
  }
  
  void printStatus() {
    print('\n' + '=' * 40);
    print('СОСТОЯНИЕ КОФЕМАШИНЫ');
    print('=' * 40);
    print('Кофейные зёрна: $_coffeeBeans г');
    print('Вода: $_water мл');
    print('Молоко: $_milk мл');
    print('Деньги в кассе: $_cash руб');
    print('=' * 40);
  }
}