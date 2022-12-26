
import 'package:flutter/cupertino.dart';

import '../models/token_type.dart';

class DiceTurn with ChangeNotifier {

 TokenType? turn;
 
 void updateDiceTurn(TokenType tokenType) {
    turn = tokenType;
    notifyListeners();
 }

}