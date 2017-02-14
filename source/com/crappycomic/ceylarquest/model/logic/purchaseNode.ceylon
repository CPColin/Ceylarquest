import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Node,
    Ownable,
    Result,
    incorrectPhase,
    postLand
}

"Alters the state of the given [[game]] to have the current player purchase the given [[node]]."
shared Result purchaseNode(Game game, Node node = game.playerLocation(game.currentPlayer)) {
    if (game.phase != postLand) {
        return incorrectPhase;
    }
    
    if (!canPurchaseNode(game, node)) {
        return InvalidMove("``node.name`` may not be purchased.");
    }
    
    assert (is Ownable node);
    
    value player = game.currentPlayer;
    value playerCash = game.playerCash(player);
    value nodePrice = package.nodePrice(game, node);
    
    return game.with {
        owners = { node -> player };
        playerCashes = { player -> playerCash - nodePrice };
    };
}
