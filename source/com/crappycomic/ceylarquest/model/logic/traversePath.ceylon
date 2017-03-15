import com.crappycomic.ceylarquest.model {
    ChoosingAllowedMove,
    Game,
    InvalidMove,
    Path,
    PreLand,
    Result,
    Well,
    incorrectPhase
}

"Alters the state of the given [[game]] to have the current player traverse the given [[path]],
 using the given amount of fuel specified in the current phase."
shared Result traversePath(variable Game game, Path path) {
    value phase = game.phase;
    
    if (!is ChoosingAllowedMove phase) {
        return incorrectPhase;
    }
    
    if (!phase.paths.contains(path)) {
        return InvalidMove("Current phase does not contain requested path.");
    }
    
    value node = path.last;
    
    if (is Well node) {
        return InvalidMove("It is not possible to end a path on ``node.name``.");
    }
    
    value player = game.currentPlayer;
    value fuel = phase.fuel;
    
    if (fuel > game.playerFuel(player)) {
        return InvalidMove("Required fuel use is more than the player has left.");
    }
    
    value playerCashes = passesStart(game.board, path)
        then { player -> game.playerCash(player) + game.rules.passStartCash };
    value playerFuels = fuel > 0
        then { player -> game.playerFuel(player) - fuel };
    
    return game.with {
        phase = PreLand(path.size > 1);
        playerCashes = playerCashes;
        playerFuels = playerFuels;
        playerLocations = { player -> node };
    };
}
