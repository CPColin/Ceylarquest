import com.crappycomic.ceylarquest.model {
    Game
}

"Returns `true` if the state of the given [[game]] allows the [[selling player|sellingPlayer]] to
 sell a fuel station."
shared Boolean canSellFuelStation(Game game) {
    value player = sellingPlayer(game);
    
    if (game.playerFuelStationCount(player) <= 0) {
        return false;
    }
    
    return canSell(game);
}
