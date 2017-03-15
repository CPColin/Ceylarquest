import com.crappycomic.ceylarquest.model {
    Administration,
    Game
}

"Returns `true` if, considering the state of the given [[game]] and its [[rules|Game.rules]], the
 current player can purchase a fuel station. That is, the player has enough cash to afford one, at
 least one is available to be purchases, and the rules allow one to be purchased at the player's
 current location."
shared Boolean canPurchaseFuelStation(Game game) {
    return let (player = game.currentPlayer)
        game.playerCash(player) >= game.rules.fuelStationPrice
            && game.fuelStationsRemaining > 0
            && game.playerLocation(player) is Administration;
}
