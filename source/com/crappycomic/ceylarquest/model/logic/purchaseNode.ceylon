import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Node,
    Ownable,
    Player,
    Result,
    incorrectPhase,
    postLand
}

shared Result purchaseNode(Game game, Player player, Node node) {
    if (game.phase != postLand) {
        return incorrectPhase;
    }
    
    if (!is Ownable node) {
        return InvalidMove("``node.name`` may not be purchased.");
    }
    
    if (game.owner(node) is Player) {
        return InvalidMove("``node.name`` is already owned.");
    }
    
    value playerCash = game.playerCash(player);
    value nodePrice = package.nodePrice(game, node);
    
    if (playerCash < nodePrice) {
        return InvalidMove(
            "``game.playerName(player)`` cannot afford to purchase ``node.name``.");
    }
    
    return game.with {
        owners = { node -> player };
        playerCashes = { player -> playerCash - nodePrice };
    };
}
