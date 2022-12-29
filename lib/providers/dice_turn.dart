
import 'package:flutter/cupertino.dart';

class DiceTurn with ChangeNotifier {

 late int userId = 123;
 
 void updateDiceTurn(String userId) {
    userId = userId;
    notifyListeners();
 }

}