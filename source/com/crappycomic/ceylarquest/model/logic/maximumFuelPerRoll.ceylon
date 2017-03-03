import com.crappycomic.ceylarquest.model {
    Game
}

"Returns the greatest amount of fuel that can be consumed by a single roll.
 
 For efficiency's sake, the only check performed is on the maximum roll. If the maximum roll causes
 a card to be drawn, this method returns one less than the maximum roll. Otherwise, it returns the
 maximum roll itself."
shared Integer maximumFuelPerRoll(Game game) {
    value cardRollType = game.rules.cardRollType;
    value maximumRoll = [game.rules.diePips].repeat(game.rules.dieCount);
    value totalRoll = Integer.sum(maximumRoll);
    
    if (cardRollType(maximumRoll)) {
        return totalRoll - 1;
    }
    else {
        return totalRoll;
    }
}