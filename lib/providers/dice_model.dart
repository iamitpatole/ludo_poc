import 'dart:math';
import 'package:flutter/material.dart';

class DiceModel with ChangeNotifier {
  int diceOne = 1;
  int diceTwo = 1;
  int diceThree = 1;
  int diceFour = 1;

  int get diceOneCount => diceOne;
  int get diceTwoCount => diceTwo;
  int get diceThreeCount => diceThree;
  int get diceFourCount => diceFour;

  void generateDiceOne() {
    diceOne = Random().nextInt(6) + 1;
    notifyListeners();
  }
  void generateDiceTwo() {
    diceTwo = Random().nextInt(6) + 1;
    notifyListeners();
  }
  void generateDiceThree() {
    diceThree = Random().nextInt(6) + 1;
    notifyListeners();
  }
  void generateDiceFour() {
    diceFour = Random().nextInt(6) + 1;
    notifyListeners();
  }
}