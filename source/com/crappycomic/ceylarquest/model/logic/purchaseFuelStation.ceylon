import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Result,
    incorrectPhase,
    postLand,
    preRoll
}

"Alters the state of the given [[game]] so the current player has purchased a fuel station."
shared Result purchaseFuelStation(Game game) {
    if (game.phase != preRoll && game.phase != postLand) {
        return incorrectPhase;
    }
    
    if (game.fuelStationsRemaining <= 0) {
        return InvalidMove("No fuel stations remain for purchase.");
    }
    
    value player = game.currentPlayer;
    
    if (game.playerCash(player) < game.rules.fuelStationPrice) {
        return InvalidMove("``game.playerName(player)`` cannot afford to purchase a fuel station.");
    }
    
    return game.with {
        playerCashes = { player -> game.playerCash(player) - game.rules.fuelStationPrice };
        playerFuelStationCounts = { player -> game.playerFuelStationCount(player) + 1 };
    };
}
