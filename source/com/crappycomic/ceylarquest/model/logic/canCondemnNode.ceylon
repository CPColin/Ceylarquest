import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    Ownable,
    nobody
}

"Returns `true` if the state of the given [[game]] allows the current player to condemn the node at
 the player's current location. That is, the player is low on fuel, the node is owned by somebody
 else, it is [[FuelStationable]], it does not have a fuel station on it and the player
 can afford to buy it from its owner."
shared Boolean canCondemnNode(Game game) {
    value player = game.currentPlayer;
    value node = game.playerLocation(player);
    value owner = game.owner(node);
    
    if (!is Ownable&FuelStationable node) {
        return false;
    }
    
    return lowFuel(game)
        && owner != nobody
        && owner != player
        && !game.placedFuelStation(node)
        && game.playerCash(player) >= nodePrice(game, node);
}
