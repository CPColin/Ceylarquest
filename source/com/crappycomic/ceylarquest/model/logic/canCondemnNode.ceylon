import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    unowned
}

"Returns `true` if the state of the given [[game]] allows the current player to condemn the node at
 the player's current location. That is, the player is low on fuel, but the node is owned by
 somebody else, is [[FuelStationable]], and does not have a fuel station on it."
shared Boolean canCondemnNode(Game game) {
    value player = game.currentPlayer;
    value node = game.playerLocation(player);
    value owner = game.owner(node);
    
    return lowFuel(game)
        && owner != unowned
        && owner != player
        && node is FuelStationable
        && !game.placedFuelStation(node);
}
