import 'dart:io';

void main() {
  Machine coffeeMachine = Machine();
  
  print('Добро пожаловать в кофемашину КубГАУ! ');
  print('═' * 40);
  
  bool exit = false;
  
  while (!exit) {
    print('\nЧто вы хотите сделать?');
    print('1.  Эспрессо (50 г кофе, 100 мл воды) - 100 руб');
    print('2.  Капучино (50 г кофе, 100 мл воды, 100 мл молока) - 150 руб');
    print('3.  Латте (50 г кофе, 100 мл воды, 200 мл молока) - 180 руб');
    print('4.  Добавить ингредиенты');
    print('5.  Забрать деньги');
    print('6.  Показать состояние');
    print('7.  Выйти');
    print('─' * 40);
    
    stdout.write('Ваш выбор: ');
    String? choice = stdin.readLineSync();
    
    switch (choice) {
      case '1':
        coffeeMachine.makeEspresso();
        break;
      case '2':
        coffeeMachine.makeCappuccino();
        break;
      case '3':
        coffeeMachine.makeLatte();
        break;
      case '4':
        _addIngredients(coffeeMachine);
        break;
      case '5':
        coffeeMachine.takeCash();
        break;
      case '6':
        coffeeMachine.printStatus();
        break;
      case '7':
        exit = true;
        print('До свидания! ');
        break;
      default:
        print(' Неверный выбор! Попробуйте снова.');
    }
  }
}

void _addIngredients(Machine machine) {
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
      print(' Неверный выбор!');
  }
}

class Machine {
  int _coffeeBeans = 200;  // грамм
  int _milk = 500;         // миллилитров
  int _water = 1000;       // миллилитров
  int _cash = 0;           // рублей
  
  // Геттеры
  int get coffeeBeans => _coffeeBeans;
  int get milk => _milk;
  int get water => _water;
  int get cash => _cash;
  
  // Сеттеры
  set coffeeBeans(int value) {
    if (value >= 0) _coffeeBeans = value;
  }
  
  set milk(int value) {
    if (value >= 0) _milk = value;
  }
  
  set water(int value) {
    if (value >= 0) _water = value;
  }
  
  set cash(int value) {
    if (value >= 0) _cash = value;
  }
  
  // Проверка ресурсов для эспрессо
  bool canMakeEspresso() {
    if (_coffeeBeans < 50) {
      print(' Недостаточно кофейных зёрен! Нужно 50 г, осталось $_coffeeBeans г');
      return false;
    }
    if (_water < 100) {
      print(' Недостаточно воды! Нужно 100 мл, осталось $_water мл');
      return false;
    }
    return true;
  }
  
  // Проверка ресурсов для капучино
  bool canMakeCappuccino() {
    if (_coffeeBeans < 50) {
      print(' Недостаточно кофейных зёрен! Нужно 50 г, осталось $_coffeeBeans г');
      return false;
    }
    if (_water < 100) {
      print(' Недостаточно воды! Нужно 100 мл, осталось $_water мл');
      return false;
    }
    if (_milk < 100) {
      print(' Недостаточно молока! Нужно 100 мл, осталось $_milk мл');
      return false;
    }
    return true;
  }
  
  // Проверка ресурсов для латте
  bool canMakeLatte() {
    if (_coffeeBeans < 50) {
      print(' Недостаточно кофейных зёрен! Нужно 50 г, осталось $_coffeeBeans г');
      return false;
    }
    if (_water < 100) {
      print(' Недостаточно воды! Нужно 100 мл, осталось $_water мл');
      return false;
    }
    if (_milk < 200) {
      print(' Недостаточно молока! Нужно 200 мл, осталось $_milk мл');
      return false;
    }
    return true;
  }
  
  // Приготовление эспрессо
  void makeEspresso() {
    if (canMakeEspresso()) {
      _coffeeBeans -= 50;
      _water -= 100;
      _cash += 100;
      print(' Эспрессо готов! Приятного аппетита! ☕');
      print(' Добавлено 100 рублей в кассу');
    } else {
      print(' Невозможно приготовить эспрессо. Пополните запасы!');
    }
  }
  
  // Приготовление капучино
  void makeCappuccino() {
    if (canMakeCappuccino()) {
      _coffeeBeans -= 50;
      _water -= 100;
      _milk -= 100;
      _cash += 150;
      print(' Капучино готов! Приятного аппетита! 🥛☕');
      print(' Добавлено 150 рублей в кассу');
    } else {
      print(' Невозможно приготовить капучино. Пополните запасы!');
    }
  }
  
  // Приготовление латте
  void makeLatte() {
    if (canMakeLatte()) {
      _coffeeBeans -= 50;
      _water -= 100;
      _milk -= 200;
      _cash += 180;
      print(' Латте готов! Приятного аппетита! 🥛☕');
      print(' Добавлено 180 рублей в кассу');
    } else {
      print(' Невозможно приготовить латте. Пополните запасы!');
    }
  }
  
  // Добавление кофейных зёрен
  void addCoffeeBeans(int amount) {
    _coffeeBeans += amount;
    print(' Добавлено $amount г кофейных зёрен. Теперь: $_coffeeBeans г');
  }
  
  // Добавление воды
  void addWater(int amount) {
    _water += amount;
    print(' Добавлено $amount мл воды. Теперь: $_water мл');
  }
  
  // Добавление молока
  void addMilk(int amount) {
    _milk += amount;
    print(' Добавлено $amount мл молока. Теперь: $_milk мл');
  }
  
  // Забрать деньги
  void takeCash() {
    if (_cash > 0) {
      print(' Вы забрали $_cash рублей из кассы');
      _cash = 0;
    } else {
      print(' В кассе нет денег');
    }
  }
  
  // Вывести состояние машины
  void printStatus() {
    print('\n' + '═' * 40);
    print('СОСТОЯНИЕ КОФЕМАШИНЫ');
    print('═' * 40);
    print('Кофейные зёрна: $_coffeeBeans г');
    print('Вода: $_water мл');
    print(' Молоко: $_milk мл');
    print('Деньги в кассе: $_cash руб');
    print('═' * 40);
    
    print(' Доступные напитки:');
    if (_coffeeBeans >= 50 && _water >= 100) {
      print('   Эспрессо');
    } else {
      print('   Эспрессо (не хватает ресурсов)');
    }
    if (_coffeeBeans >= 50 && _water >= 100 && _milk >= 100) {
      print('   Капучино');
    } else {
      print('   Капучино (не хватает ресурсов)');
    }
    if (_coffeeBeans >= 50 && _water >= 100 && _milk >= 200) {
      print('  Латте');
    } else {
      print('   Латте (не хватает ресурсов)');
    }
    print('═' * 40);
  }
}