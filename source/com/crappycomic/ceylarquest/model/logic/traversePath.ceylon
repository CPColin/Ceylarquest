import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Path,
    Player,
    PreLand,
    Result,
    Well,
    incorrectPhase,
    preRoll
}

"Alters the state of the given [[game]] to have the given [[player]] traverse the given [[path]],
 using the given amount of [[fuel]]."
shared Result traversePath(variable Game game, Player player, Path path, Integer fuel) {
    if (game.phase != preRoll) {
        return incorrectPhase;
    }
    
    value node = path.last;
    
    if (is Well node) {
        return InvalidMove("It is not possible to end a path on ``node.name``.");
    }
    
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
