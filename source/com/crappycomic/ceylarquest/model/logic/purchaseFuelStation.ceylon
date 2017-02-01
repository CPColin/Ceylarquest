import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Player,
    Result,
    defaultFuelStationPrice,
    incorrectPhase,
    postRoll,
    preRoll
}

shared Result purchaseFuelStation(Game game, Player player) {
    if (game.phase != preRoll && game.phase != postRoll) {
        return incorrectPhase;
    }
    
    if (game.fuelStationsRemaining <= 0) {
        return InvalidMove("No fuel stations remain for purchase.");
    }
    
    if (game.playerCash(player) < defaultFuelStationPrice) {
        return InvalidMove("``game.playerName(player)`` cannot afford to purchase a fuel station.");
    }
    
    return game.with {
        playerCashes = { player -> game.playerCash(player) - defaultFuelStationPrice };
        playerFuelStationCounts = { player -> game.playerFuelStationCount(player) + 1 };
    };
}
