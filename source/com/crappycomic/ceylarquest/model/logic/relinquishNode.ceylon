import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Node,
    Ownable,
    Player,
    Result,
    unowned
}

"Relinquishes ownership of the given [[node]], with [[optional compensation|compensateOwner]] to the
 given [[player]], who must be the current owner of the node."
shared Result relinquishNode(Game game, Player player, Node node, Boolean compensateOwner) {
    if (!is Ownable node) {
        return InvalidMove("``node.name`` may not be purchased or relinquished.");
    }
    
    value owner = game.owner(node);
    
    if (owner != player) {
        return InvalidMove("``game.playerName(player)`` does not own ``node.name``.");
    }
    
    value playerCash = game.playerCash(player);
    value nodePrice = package.nodePrice(game, node);
    value playerCashes = compensateOwner then { player -> playerCash + nodePrice } else null;
    
    return game.with {
        owners = { node -> unowned };
        playerCashes = playerCashes;
    };
}
