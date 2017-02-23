import com.crappycomic.ceylarquest.model {
    Game,
    Result,
    incorrectPhase,
    postLand,
    preRoll
}

"Updates the state of the given [[game]] to advance to the [[next player|Game.nextPlayer]] and set
 the [[phase|Game.phase]] to [[preRoll]]"
shared Result endTurn(Game game) {
    if (game.phase != postLand) {
        return incorrectPhase;
    }
    
    return game.with {
        currentPlayer = game.nextPlayer;
        phase = preRoll;
    };
}
