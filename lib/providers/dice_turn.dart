
import 'package:flutter/cupertino.dart';

class DiceTurn with ChangeNotifier {

 late int userId = 0;
 
 void updateDiceTurn(String userId) {
    userId = userId;
    notifyListeners();
 }

}