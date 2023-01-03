class UserStatus
{
   bool freeTurn;
   bool diceRoll;
   int score;
  
  UserStatus(this.freeTurn,this.diceRoll,this.score);

  updateFreeTurn(bool freeTurn) {
     freeTurn = freeTurn;
  }

  updateRollDice(bool diceRoll) {
     diceRoll = diceRoll;
  }

  bool get getFreeTurn {
    return freeTurn;
  }

  bool get getDiceRoll {
    return diceRoll;
  }
 
}