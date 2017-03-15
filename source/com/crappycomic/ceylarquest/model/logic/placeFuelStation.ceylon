import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Node,
    Result,
    incorrectPhase,
    postLand,
    preRoll
}

"Alters the state of the given [[game]] to have the current player place a fuel station on the given
 [[node]]."
shared Result placeFuelStation(Game game, Node? node) {
    if (!exists node) {
        return game;
    }
    
    if (game.phase != preRoll && game.phase != postLand) {
        return incorrectPhase;
    }
    
    value player = game.currentPlayer;
    
    if (!canPlaceFuelStation(game, node)) {
        return InvalidMove(
            "``game.playerName(player)`` may not place a fuel station on ``node.name``.");
    }
    
    return game.with {
        playerFuelStationCounts = { player -> game.playerFuelStationCount(player) - 1 };
        placedFuelStations = { node };
    };
}
