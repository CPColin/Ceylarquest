import com.crappycomic.ceylarquest.model {
    Game
}

"Returns `true` if the state of the given [[game]] has the current player in a \"low-fuel\" state.
 That is, the player's remaining fuel is low enough that it's possible a roll of the dice could
 completely drain the tank."
shared Boolean lowFuel(Game game) {
    return game.playerFuel(game.currentPlayer) <= maximumFuelPerRoll(game);
}
