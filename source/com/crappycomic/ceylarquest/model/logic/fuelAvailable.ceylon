import com.crappycomic.ceylarquest.model {
    FuelSalable,
    FuelStationable,
    Game,
    Node
}

"Returns `true` if fuel is available at the given [[node]]."
shared Boolean fuelAvailable(Game game, Node node) {
    return node is FuelSalable
            && (game.placedFuelStation(node) || !(node is FuelStationable));
}
