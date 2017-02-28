import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Player,
    Result
}

"Updates the state of the given [[game]] to remove a fuel station from the given [[player]] and add
 the cash earned by selling it."
shared Result sellFuelStation(Game game, Player player = game.currentPlayer) {
    if (!canSellFuelStation(game, player)) {
        return InvalidMove("``game.playerName(player)`` may not sell a fuel station.");
    }
    
    return game.with {
        playerCashes = { player -> game.playerCash(player) + game.rules.fuelStationPrice };
        playerFuelStationCounts = { player -> game.playerFuelStationCount(player) - 1 };
    };
}
