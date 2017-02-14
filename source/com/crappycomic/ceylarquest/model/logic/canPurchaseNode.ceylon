import com.crappycomic.ceylarquest.model {
    Game,
    Node,
    Ownable,
    unowned
}

"Returns `true` if, considering the state of the given [[game]], the current player can purchase the
 given [[node]]. That is, the node is [[Ownable]], is not currently owned, and costs no more than
 the amount of cash the player has."
shared Boolean canPurchaseNode(Game game, Node node = game.playerLocation(game.currentPlayer)) {
    if (!is Ownable node) {
        return false;
    }
    
    return game.owner(node) == unowned
        && game.playerCash(game.currentPlayer) >= nodePrice(game, node);
}
