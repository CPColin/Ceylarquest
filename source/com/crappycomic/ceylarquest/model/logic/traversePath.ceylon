import com.crappycomic.ceylarquest.model {
    ActionTrigger,
    Game,
    InvalidMove,
    Path,
    Player,
    Result,
    Well,
    incorrectPhase,
    preRoll
}

shared Result traversePath(variable Game game, Player player, Path path) {
    if (game.phase != preRoll) {
        return incorrectPhase;
    }
    
    value node = path.last;
    
    if (is Well node) {
        return InvalidMove("It is not possible to end a path on ``node.name``.");
    }
    
    if (is ActionTrigger node) {
        if (path.size > 1) {
            game = node.action.perform(game, player);
        }
    }
    
    value playerCashes = game.board.passesStart(path)
    then { player -> game.playerCash(player) + game.rules.passStartCash }
    else null;
    
    return game.with {
        playerCashes = playerCashes;
        playerLocations = { player -> node };
    };
}
