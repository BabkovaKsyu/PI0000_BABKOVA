import 'dart:io';
import 'coffee_machine.dart';

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