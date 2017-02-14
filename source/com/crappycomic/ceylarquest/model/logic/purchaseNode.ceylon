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

"Alters the state of the given [[game]] so the given [[player]] has purchased the given [[node]]."
shared Result purchaseNode(Game game, Player player = game.currentPlayer,
        Node node = game.playerLocation(player)) {
    if (game.phase != postLand) {
        return incorrectPhase;
    }
    
    if (!canPurchaseNode(game, player, node)) {
        return InvalidMove("``node.name`` may not be purchased.");
    }
    
    assert (is Ownable node);
    
    value playerCash = game.playerCash(player);
    value nodePrice = package.nodePrice(game, node);
    
    return game.with {
        owners = { node -> player };
        playerCashes = { player -> playerCash - nodePrice };
    };
}
