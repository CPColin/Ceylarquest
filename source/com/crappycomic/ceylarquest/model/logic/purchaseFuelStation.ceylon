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
    
    value player = game.currentPlayer;
    
    if (!canPurchaseFuelStation(game)) {
        return InvalidMove("``game.playerName(player)`` may not purchase a fuel station.");
    }
    
    return game.with {
        playerCashes = { player -> game.playerCash(player) - game.rules.fuelStationPrice };
        playerFuelStationCounts = { player -> game.playerFuelStationCount(player) + 1 };
    };
}
