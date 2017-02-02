import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    Ownable,
    defaultFuelStationPrice
}

"Returns the price of the given node, adding the price of a fuel station, if present."
shared Integer nodePrice(Game game, Ownable node) {
    if (node is FuelStationable && game.placedFuelStation(node)) {
        return defaultFuelStationPrice + node.price;
    }
    else {
        return node.price;
    }
}
