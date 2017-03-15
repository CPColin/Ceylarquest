import com.crappycomic.ceylarquest.model {
    Game,
    Ownable
}

"Returns `true` if, considering the state of the given [[game]], the
 [[selling player|sellingPlayer]] can sell the given [[node]]. If no node is given, this function
 returns `true` if the player has _any_ node that can be sold."
shared Boolean canSellNode(Game game, Ownable? node = null) {
    value player = sellingPlayer(game);
    
    if (exists node) {
        if (game.owner(node) != player) {
            return false;
        }
    }
    else {
        if (!game.owners.items.contains(player)) {
            return false;
        }
    }
    
    return canSell(game);
}
