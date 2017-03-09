import com.crappycomic.ceylarquest.model {
    Game
}

"Returns `true` if fuel can be purchased by the current player at the player's current location."
shared Boolean canPurchaseFuel(Game game)
    => let (player = game.currentPlayer, node = game.playerLocation(player))
        fuelAvailable(game, node) && fuelTankSpace(game, player) > 0;
