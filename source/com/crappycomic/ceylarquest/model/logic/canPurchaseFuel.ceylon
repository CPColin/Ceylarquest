import com.crappycomic.ceylarquest.model {
    FuelSalable,
    Game
}

"Returns `true` if fuel can be purchased by the current player at the player's current location."
shared Boolean canPurchaseFuel(Game game) {
    value player = game.currentPlayer;
    value node = game.playerLocation(player);
    
    if (is FuelSalable node) {
        return fuelAvailable(game, node)
            && maximumPurchaseableFuel(game, player, node) > 0;
    }
    else {
        return false;
    }
}
