import com.crappycomic.ceylarquest.model {
    Game,
    Player
}

"Returns `true` if the state of the given [[game]] allows the given [[player]] to sell a fuel
 station."
shared Boolean canSellFuelStation(Game game, Player player = game.currentPlayer) {
    if (game.playerFuelStationCount(player) <= 0) {
        return false;
    }
    
    return canSell(game, player);
}
