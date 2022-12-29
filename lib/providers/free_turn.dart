
class FreeTurn {
  static var freeTurnMap = {123: false, 789: false, 456: false, 678: false};

  static void updateFreeTurn(int userId, bool turn) {
    freeTurnMap[userId] = turn;
  }
}
