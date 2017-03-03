import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Ownable,
    Result,
    unowned
}

"Updates the state of the given [[game]] to have the [[selling player|sellingPlayer]] sell the given
 [[node]] and receive [[compensation|nodePrice]] for it."
shared Result sellNode(Game game, Ownable node) {
    value player = sellingPlayer(game);
    
    if (!canSellNode(game, node)) {
        return InvalidMove("``game.playerName(player)`` may not sell ``node.name``.");
    }
    
    return game.with {
        owners = { node -> unowned };
        playerCashes = { player -> game.playerCash(player) + nodePrice(game, node) };
    };
}
