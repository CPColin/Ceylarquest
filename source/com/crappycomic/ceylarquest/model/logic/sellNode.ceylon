import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Ownable,
    Player,
    Result,
    unowned
}

"Updates the state of the given [[game]] to have the given [[player]] sell the given [[node]] and
 receive [[compensation|nodePrice]] for it."
shared Result sellNode(Game game, Player player, Ownable node) {
    if (!canSellNode(game, player, node)) {
        return InvalidMove("``game.playerName(player)`` may not sell ``node.name``.");
    }
    
    return game.with {
        owners = { node -> unowned };
        playerCashes = { player -> game.playerCash(player) + nodePrice(game, node) };
    };
}
