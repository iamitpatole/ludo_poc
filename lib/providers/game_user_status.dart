import '../models/user_status.dart';
import '../utility/firestoredb.dart';

class GameUserStatus {

  static Map<int, UserStatus> userStatusMap  = {
    // 123: UserStatus(false, false, 0),
    // 789: UserStatus(false, false, 0),
    // 456: UserStatus(false, false, 0),
    // 678: UserStatus(false, false, 0),
  };

  static Future<void> updateUserStatus(int userId, bool freeTurn, bool diceRoll) async {
    FireStoreDB.collectionReference.doc('matchid123').update({userId.toString(): {
      "freeTurn": freeTurn,
      "diceRoll": diceRoll,
      "score": 0
    }});
    //freeTurnMap[userId] = UserStatus(freeTurn, diceRoll, 0);
  }

  static updateInitialStatusOfUser(List<int> userIds) {
    for (var element in userIds) {
      userStatusMap[element] = UserStatus(false, false, -0);
      FireStoreDB.collectionReference.doc('matchid123').update({
        element.toString(): {"freeTurn": false, "diceRoll": false, "score": 0}
      });
    }
  }

  static void updateUserStatusMap(Map<dynamic, dynamic> userStatusM) {
    userStatusM.forEach((k,v) => {
        userStatusMap[int.parse(k)] =  UserStatus.fromJson(v),
    }); 
  }

}
