import com.crappycomic.ceylarquest.model {
    ActionTrigger,
    Game,
    InvalidMove,
    Path,
    Player,
    Result,
    Well,
    incorrectPhase,
    preLand,
    preRoll
}

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
    
    // TODO: you maybe shouldn't trigger actions while bypassing
    if (is ActionTrigger node) {
        if (path.size > 1) {
            game = node.action(game, player);
        }
    }
    
    value playerCashes = game.board.passesStart(path)
        then { player -> game.playerCash(player) + game.rules.passStartCash };
    value playerFuels = fuel > 0
        then { player -> game.playerFuel(player) - fuel };
    
    return game.with {
        phase = preLand;
        playerCashes = playerCashes;
        playerFuels = playerFuels;
        playerLocations = { player -> node };
    };
}
