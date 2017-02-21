import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Ownable,
    Result,
    incorrectPhase,
    postLand
}

"Alters the state of the given [[game]] to have the current player purchase the node that player is
 currently on."
shared Result purchaseNode(Game game) {
    if (game.phase != postLand) {
        return incorrectPhase;
    }
    
    value player = game.currentPlayer;
    value node = game.playerLocation(player);
    
    if (!canPurchaseNode(game, node)) {
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
