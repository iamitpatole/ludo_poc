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

  @override
  Widget build(BuildContext context) {
    bool? freeTurn = FreeTurn.freeTurnMap[token.userId]?.getFreeTurn;
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
          bool? diceRoll = FreeTurn.freeTurnMap[token.userId]?.diceRoll;
          if(freeTurn == true && diceRoll == true) {
            gameState.moveToken(token, detectTokenDiceNumber(token, dice));
          } else {
            showDialog(context: context, builder: (_) {
              return const AlertDialog(title: Text('Its Not Your Turn'),);
            });
          }
        },
        child: Icon(
            Icons.cruelty_free_sharp,
            color: _getcolor(),
            size: 28.0,
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

  Color _getcolor() {
    switch (token.type) {
      case TokenType.green:
        return Colors.green.shade900;
      case TokenType.yellow:
        return Colors.yellow.shade900;
      case TokenType.blue:
        return Colors.blue.shade900;
      case TokenType.red:
        return Colors.red.shade900;
    }
  }
}
