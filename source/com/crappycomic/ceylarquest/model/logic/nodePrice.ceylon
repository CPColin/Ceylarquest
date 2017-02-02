import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    Ownable
}

"Returns the price of the given node, adding the price of a fuel station, if present."
shared Integer nodePrice(Game game, Ownable node) {
    if (node is FuelStationable && game.placedFuelStation(node)) {
        return game.rules.fuelStationPrice + node.price;
    }
    else {
        return node.price;
    }
}
