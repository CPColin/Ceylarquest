import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    Node
}

"Returns `true` if, considering the given [[game]], the current player may place a fuel station on
 the given [[node]]. That is, the node is [[FuelStationable]], does not already have a fuel station
 on it, and is owned by the player. Additionally, the player has a fuel station available to place."
shared Boolean canPlaceFuelStation(Game game, Node node) {
    return let (player = game.currentPlayer)
        node is FuelStationable
            && !game.placedFuelStation(node)
            && game.owner(node) == player
            && game.playerFuelStationCount(player) >= 1;
}
