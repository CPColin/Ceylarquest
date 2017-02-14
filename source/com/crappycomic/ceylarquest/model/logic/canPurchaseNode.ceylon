import com.crappycomic.ceylarquest.model {
    Game,
    Node,
    Ownable,
    Player
}

// TODO: target appropriate purchaseNode tests at this function
shared Boolean canPurchaseNode(Game game, Player player = game.currentPlayer,
        Node node = game.playerLocation(player)) {
    if (!is Ownable node) {
        return false;
    }
    
    if (game.owner(node) is Player) {
        return false;
    }
    
    value playerCash = game.playerCash(player);
    value nodePrice = package.nodePrice(game, node);
    
    if (playerCash < nodePrice) {
        return false;
    }
    
    return true;
}
