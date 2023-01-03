
import 'package:flutter/material.dart';

import '../models/position.dart';
import '../models/token_type.dart';
import '../utility/path.dart';
import 'free_turn.dart';

class GameState with ChangeNotifier {
  List<Token> gameTokens = [];
  List<Position> starPositions = [];
  List<Position> greenInitital = [];
  List<Position> yellowInitital = [];
  List<Position> blueInitital = [];
  List<Position> redInitital = [];
  var tokenIntialized = false;
  var assignableUserIds = <int>[0,0,0,0];
  GameState() {
    gameTokens = [
      //Green Tokens home
      // Token(TokenType.green, const Position(2, 2), TokenState.initial, 0  , 0),
      // Token(TokenType.green, const Position(2, 3), TokenState.initial, 1 , 1),
      // Token(TokenType.green, const Position(3, 2), TokenState.initial,2  , 2),
      // Token(TokenType.green, const Position(3, 3), TokenState.initial,3  ,3),
      // //Yellow Token
      // Token(TokenType.yellow, const Position(2, 11), TokenState.initial, 4 ,4),
      // Token(TokenType.yellow, const Position(2, 12), TokenState.initial,5 ,5),
      // Token(TokenType.yellow, const Position(3, 11), TokenState.initial,6 ,6),
      // Token(TokenType.yellow, const Position(3, 12), TokenState.initial, 7 ,7),
      // // Blue Token
      // Token(TokenType.blue, const Position(11, 11), TokenState.initial,08 ,8),
      // Token(TokenType.blue, const Position(11, 12), TokenState.initial,09 ,9),
      // Token(TokenType.blue, const Position(12, 11), TokenState.initial,10 ,10),
      // Token(TokenType.blue, const Position(12, 12), TokenState.initial,11 ,11),
      // // Red Token
      // Token(TokenType.red, const Position(11, 2), TokenState.initial,12 ,12),
      // Token(TokenType.red, const Position(11, 3), TokenState.initial,13 ,13),
      // Token(TokenType.red, const Position(12, 2), TokenState.initial,14 ,14),
      // Token(TokenType.red, const Position(12, 3), TokenState.initial,15 ,15),
    ];
    starPositions = [
      const Position(6, 1),
      const Position(2, 6),
      const Position(1, 8),
      const Position(6, 12),
      const Position(8, 13),
      const Position(12, 8),
      const Position(13, 6),
      const Position(8, 2)
    ];
  }
  setAssinableUserId(var assignableUserIdss) {
      assignableUserIds = assignableUserIdss;
      if(!tokenIntialized) {
        // Red Token
        gameTokens.add(Token(TokenType.red, const Position(11, 2), TokenState.initial,assignableUserIds[0] ,12));
        gameTokens.add(Token(TokenType.red, const Position(11, 3), TokenState.initial,assignableUserIds[0] ,13));
        gameTokens.add(Token(TokenType.red, const Position(12, 2), TokenState.initial,assignableUserIds[0],14));
        gameTokens.add(Token(TokenType.red, const Position(12, 3), TokenState.initial,assignableUserIds[0],15));
        //green tokens
        gameTokens.add(Token(TokenType.green, const Position(2, 2), TokenState.initial,assignableUserIds[1]  , 33));
        gameTokens.add(Token(TokenType.green, const Position(2, 3), TokenState.initial, assignableUserIds[1], 1));
        gameTokens.add(Token(TokenType.green, const Position(3, 2), TokenState.initial,assignableUserIds[1], 2));
        gameTokens.add(Token(TokenType.green, const Position(3, 3), TokenState.initial,assignableUserIds[1],3));
        //Yellow Token
        gameTokens.add(Token(TokenType.yellow, const Position(2, 11), TokenState.initial,assignableUserIds[2],4));
        gameTokens.add(Token(TokenType.yellow, const Position(2, 12), TokenState.initial,assignableUserIds[2],5));
        gameTokens.add(Token(TokenType.yellow, const Position(3, 11), TokenState.initial,assignableUserIds[2],6));
        gameTokens.add(Token(TokenType.yellow, const Position(3, 12), TokenState.initial,assignableUserIds[2],7));
        // Blue Token
        gameTokens.add(Token(TokenType.blue, const Position(11, 11), TokenState.initial,assignableUserIds[3],8));
        gameTokens.add(Token(TokenType.blue, const Position(11, 12), TokenState.initial,assignableUserIds[3],9));
        gameTokens.add(Token(TokenType.blue, const Position(12, 11), TokenState.initial,assignableUserIds[3],10));
        gameTokens.add(Token(TokenType.blue, const Position(12, 12), TokenState.initial,assignableUserIds[3],11));
        tokenIntialized = true;
      } 
    }

  moveToken(Token token, int steps) {
    Position destination;
    int pathPosition;
     Token existingToken = gameTokens.where((t) => t.id == token.id).first;
    if (token.tokenState == TokenState.home) return;
    //if (token.tokenState == TokenState.initial && steps != 6) return;
    if (token.tokenState == TokenState.initial && steps != 0) {
      destination = _getPosition(token.type, steps);
      pathPosition = steps;
      
      _updateInitalPositions(token);
      var cutToken = _updateBoardState(existingToken, token, destination, steps);
      existingToken.positionInPath = 0;      
      int duration = 0;  

      for (int i = 1; i <= steps; i++) {
        duration = duration + 200;
        Future.delayed(Duration(milliseconds: duration), () {
          int stepLoc = token.positionInPath + 1;
          existingToken.tokenPosition =_getPosition(token.type, stepLoc);
          existingToken.positionInPath = stepLoc;
          token.positionInPath = stepLoc;
          notifyListeners();
        });
      }
      if (cutToken != null) {
        _cutOutToken(cutToken, duration);
      }
      validateFreeTurn(steps, token, cutToken);
    } else if (token.tokenState != TokenState.initial) {
      int step = token.positionInPath + steps;
      if (step > 56) return;
      destination = _getPosition(token.type, step);
      pathPosition = step;
      var cutToken = _updateBoardState(existingToken, token, destination, pathPosition);
      int duration = 0;
      for (int i = 1; i <= steps; i++) {
        duration = duration + 200;
        Future.delayed(Duration(milliseconds: duration), () {
          int stepLoc = token.positionInPath + 1;
          existingToken.tokenPosition =_getPosition(token.type, stepLoc);
          existingToken.positionInPath = stepLoc;
          token.positionInPath = stepLoc;
          notifyListeners();
        });
      }
      if (cutToken != null) {
        _cutOutToken(cutToken, duration);
      }
       validateFreeTurn(steps, token, cutToken);
    }
  }

  validateFreeTurn(int steps, Token token, var cutToken) {
    if (steps == 6) {
      FreeTurn.updateUserStatus(token.userId, true, false);
     } else {
      updateNextTurn(token);
    }
    if (cutToken != null) {
      FreeTurn.updateUserStatus(token.userId, true, false);
    } else if (steps != 6) {
      updateNextTurn(token);
    }
  }

  void updateNextTurn(Token token) {
    FreeTurn.updateUserStatus(token.userId, false, false);
    int userIdIndex = assignableUserIds.indexOf(token.userId);
    if(userIdIndex < 3) {
      FreeTurn.updateUserStatus(assignableUserIds[userIdIndex+1], true, false);
    } else {
      FreeTurn.updateUserStatus(assignableUserIds[0], true, false);
    }
  }

  _cutOutToken(Token cutToken, int duration) {
    int cutSteps = cutToken.positionInPath;
    for (int i = 1; i <= cutSteps; i++) {
      duration = duration + 100;
      Future.delayed(Duration(milliseconds: duration), () {
        int stepLoc = cutToken.positionInPath - 1;
        cutToken.tokenPosition = _getPosition(cutToken.type, stepLoc);
        cutToken.positionInPath = stepLoc;
        cutToken.positionInPath = stepLoc;
        notifyListeners();
      });
    }
    Future.delayed(Duration(milliseconds: duration), () {
      _cutToken(cutToken);
      notifyListeners();
    });
  }

  Token? _updateBoardState(Token existingToken, 
      Token token, Position destination, int pathPosition) {
    Token? cutToken;
    //when the destination is on any star
    if (starPositions.contains(destination)) {
      existingToken.tokenState = TokenState.safe;
      return null;
    }
    List<Token> tokenAtDestination = gameTokens.where((tkn) {
      if (tkn.tokenPosition == destination) {
        return true;
      }
      return false;
    }).toList();
    //if no one at the destination
    if (tokenAtDestination.isEmpty) {
      existingToken.tokenState = TokenState.normal;
      return null;
    }
    //check for same color at destination
    List<Token> tokenAtDestinationSameType = tokenAtDestination.where((tkn) {
      if (tkn.type == token.type) {
        return true;
      }
      return false;
    }).toList();
    if (tokenAtDestinationSameType.length == tokenAtDestination.length) {
      for (Token tkn in tokenAtDestinationSameType) {
        tkn.tokenState = TokenState.safeinpair;
      }
      existingToken.tokenState = TokenState.safeinpair;
      return null;
    }
    if (tokenAtDestinationSameType.length < tokenAtDestination.length) {
      for (Token tkn in tokenAtDestination) {
        if (tkn.type != token.type && tkn.tokenState != TokenState.safeinpair) {
          //cut an unsafe token
          //_cutToken(tkn);
          cutToken = tkn;
        } else if (tkn.type == token.type) {
          tkn.tokenState = TokenState.safeinpair;
        }
      }
      //place token
      existingToken.tokenState = tokenAtDestinationSameType.isNotEmpty
          ? TokenState.safeinpair
          : TokenState.normal;
      return cutToken;
    }
    return null;
  }

  _updateInitalPositions(Token token) {
    switch (token.type) {
      case TokenType.green:
        {
          greenInitital.add(token.tokenPosition);
        }
        break;
      case TokenType.yellow:
        {
          yellowInitital.add(token.tokenPosition);
        }
        break;
      case TokenType.blue:
        {
          blueInitital.add(token.tokenPosition);
        }
        break;
      case TokenType.red:
        {
          redInitital.add(token.tokenPosition);
        }
        break;
    }
  }

  _cutToken(Token token) {
    switch (token.type) {
      case TokenType.green:
        {
          token.tokenState = TokenState.initial;
          token.tokenPosition = greenInitital.first;
          greenInitital.removeAt(0);
        }
        break;
      case TokenType.yellow:
        {
          token.tokenState = TokenState.initial;
          token.tokenPosition = yellowInitital.first;
          yellowInitital.removeAt(0);
        }
        break;
      case TokenType.blue:
        {
          token.tokenState = TokenState.initial;
          token.tokenPosition = blueInitital.first;
          blueInitital.removeAt(0);
        }
        break;
      case TokenType.red:
        {
          token.tokenState = TokenState.initial;
          token.tokenPosition = redInitital.first;
          redInitital.removeAt(0);
        }
        break;
    }
  }

  Position _getPosition(TokenType type, step) {
    Position destination;
    switch (type) {
      case TokenType.green:
        {
          List<int> node = Path.greenPath[step];
          destination = Position(node[0], node[1]);
        }
        break;
      case TokenType.yellow:
        {
          List<int> node = Path.yellowPath[step];
          destination = Position(node[0], node[1]);
        }
        break;
      case TokenType.blue:
        {
          List<int> node = Path.bluePath[step];
          destination = Position(node[0], node[1]);
        }
        break;
      case TokenType.red:
        {
          List<int> node = Path.redPath[step];
          destination = Position(node[0], node[1]);
        }
        break;
    }
    return destination;
  }
}
