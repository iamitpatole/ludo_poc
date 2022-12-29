import 'package:flutter/material.dart';
import 'package:ludo_poc/providers/free_turn.dart';
import 'package:provider/provider.dart';

import '../models/token_type.dart';
import '../providers/dice_model.dart';
import '../providers/game_state.dart';

class Tokenp extends StatelessWidget {
  final Token token;
  final List<double> dimentions;
  //Function(Token) callBack;
  const Tokenp(this.token, this.dimentions, {super.key});

  Color _getcolor() {
    switch (token.type) {
      case TokenType.green:
        return Colors.green;
      case TokenType.yellow:
        return Colors.yellow.shade900;
      case TokenType.blue:
        return Colors.blue.shade600;
      case TokenType.red:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final dice = Provider.of<DiceModel>(context, listen: false);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: dimentions[0],
      top: dimentions[1],
      width: dimentions[2],
      height: dimentions[3],
      child: GestureDetector(
        onTap: () {
          print(FreeTurn.freeTurnMap[token.userId]);
          if(FreeTurn.freeTurnMap[token.userId]!) {
            gameState.moveToken(token, detectTokenDiceNumber(token, dice));
          } else {
            showDialog(context: context, builder: (_) {
              return const AlertDialog(title: Text('Its Not Your Turn'),);
            });
          }
        },
        child: Card(
          elevation: 5,
          child: Icon(
            Icons.cruelty_free_sharp,
            color: _getcolor(),
            size: 25.0,
          ),
        ),
      ),
    );
  }

  int detectTokenDiceNumber(Token token, DiceModel dice) {
      if(token.type.name == 'red') {
        return dice.diceOneCount;
      }
      if(token.type.name == 'green') {
        return dice.diceFourCount;
      }
      if(token.type.name == 'yellow') {
        return dice.diceThreeCount;
      }
      if(token.type.name == 'blue') {
        return dice.diceTwoCount;
      }
      return 0;
  }
}
