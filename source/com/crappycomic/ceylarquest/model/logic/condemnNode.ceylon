import com.crappycomic.ceylarquest.model {
    Game,
    InvalidMove,
    Ownable,
    Player,
    PreLand,
    Result,
    incorrectPhase
}

"Updates the state of the given [[game]] to have the current player comdemn the node at the player's
 current location and take it over due to negligence in not providing fuel to a needy ship."
shared Result condemnNode(Game game) {
    if (!game.phase is PreLand) {
        return incorrectPhase;
    }
    
    value player = game.currentPlayer;
    value node = game.playerLocation(player);
    
    if (!canCondemnNode(game)) {
        return InvalidMove("``game.playerName(player)`` cannot condemn ``node.name``.");
    }
    
    value owner = game.owner(node);
    
    assert (is Player owner, is Ownable node);
    
    return let (nodePrice = package.nodePrice(game, node))
        game.with {
            owners = { node -> player };
            playerCashes = {
                player -> game.playerCash(player) - nodePrice,
                owner -> game.playerCash(owner) + nodePrice
            };
        };
}
