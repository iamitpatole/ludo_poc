
import 'package:ludo_poc/models/user_status.dart';

class FreeTurn {
  static var freeTurnMap = {
    123: UserStatus(false, false, 0),
    789: UserStatus(false, false, 0),
    456: UserStatus(false, false, 0),
    678: UserStatus(false, false, 0),
  };

  static void updateUserStatus(int userId, bool freeTurn, bool diceRoll) {
    freeTurnMap[userId] = UserStatus(freeTurn, diceRoll, 0);
  }
}
