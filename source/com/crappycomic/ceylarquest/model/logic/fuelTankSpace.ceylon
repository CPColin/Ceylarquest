import com.crappycomic.ceylarquest.model {
    Game,
    Player
}

"Returns the amount of empty space in the given [[player]]'s fuel tank."
shared Integer fuelTankSpace(Game game, Player player)
    => game.rules.maximumFuel - game.playerFuel(player);
