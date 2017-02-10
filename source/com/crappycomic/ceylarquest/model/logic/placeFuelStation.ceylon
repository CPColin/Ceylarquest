import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    InvalidMove,
    Node,
    Player,
    Result,
    incorrectPhase,
    preRoll,
    postLand
}

"Alters the state of the given [[game]] to have the given [[player]] place a fuel station on the
 given [[node]]."
shared Result placeFuelStation(Game game, Player player, Node node) {
    if (game.phase != preRoll && game.phase != postLand) {
        return incorrectPhase;
    }
    
    if (!is FuelStationable node) {
        return InvalidMove("``node.name`` may not have a fuel station.");
    }
    
    if (game.placedFuelStation(node)) {
        return InvalidMove("``node.name`` already has a fuel station.");
    }
    
    value playerFuelStationCount = game.playerFuelStationCount(player);
    value playerName => game.playerName(player);
    
    if (playerFuelStationCount < 1) {
        return InvalidMove("``playerName`` does not have a fuel station to place.");
    }
    
    value owner = game.owner(node);
    
    if (owner != player) {
        return InvalidMove(
            "``playerName`` doesn't own ``node.name`` and can't place a fuel station on it.");
    }
    
    return game.with {
        playerFuelStationCounts = { player -> playerFuelStationCount - 1 };
        placedFuelStations = { node };
    };
}
