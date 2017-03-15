import com.crappycomic.ceylarquest.model {
    Game,
    Player
}

"Returns the total worth of the given [[player]], based on properties and assets owned."
shared Integer totalWorth(Game game, Player player) {
    return game.playerCash(player)
        + game.playerFuelStationCount(player) * game.rules.fuelStationPrice
        + Integer.sum({
            for (node -> owner in game.owners)
                if (owner == player)
                    nodePrice(game, node)
        });
}
