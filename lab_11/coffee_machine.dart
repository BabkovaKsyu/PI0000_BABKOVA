import 'dart:async';

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
  
  // ========== АСИНХРОННЫЕ МЕТОДЫ ==========
  Future<void> heatWater() async {
    print('Нагрев воды...');
    await Future.delayed(Duration(seconds: 3));
    print('Вода нагрета!');
  }
  
  Future<void> brewCoffee() async {
    print('Заваривание кофе...');
    await Future.delayed(Duration(seconds: 5));
    print('Кофе заварен!');
  }
  
  Future<void> frothMilk() async {
    print('Взбивание молока...');
    await Future.delayed(Duration(seconds: 5));
    print('Молоко взбито!');
  }
  
  Future<void> mix() async {
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
  
  Future<bool> makeCoffee(CoffeeType type) async {
    ICoffee coffee = createCoffee(type);
    
    if (!_checkResources(coffee)) {
      print('Невозможно приготовить ${coffee.name()}. Пополните запасы!');
      return false;
    }
    
    print('\nПриготовление ${coffee.name()}...');
    print('-' * 30);
    
    await heatWater();
    
    if (coffee.milk() > 0) {
      await Future.wait([brewCoffee(), frothMilk()]);
      await mix();
    } else {
      await brewCoffee();
    }
    
    _useResources(coffee);
    
    print('-' * 30);
    print('${coffee.name()} готов! Приятного аппетита!');
    print('Добавлено ${coffee.price()} рублей в кассу');
    
    return true;
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