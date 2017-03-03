import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Result
}

"Updates the state of the given [[game]] to remove a fuel station from the
 [[selling player|sellingPlayer]] and add the cash earned by selling it."
shared Result sellFuelStation(Game game) {
    value player = sellingPlayer(game);
    
    if (!canSellFuelStation(game)) {
        return InvalidMove("``game.playerName(player)`` may not sell a fuel station.");
    }
    
    return game.with {
        playerCashes = { player -> game.playerCash(player) + game.rules.fuelStationPrice };
        playerFuelStationCounts = { player -> game.playerFuelStationCount(player) - 1 };
    };
}
