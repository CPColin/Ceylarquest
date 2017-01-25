shared class InvalidMove(shared String message) {}

shared alias Result => Game|InvalidMove;

// TODO: mutators for Game objects
// TODO: state checks

// TODO: add tests
shared Result placeFuelStation(Game game, Player player, Node node) {
    if (!is FuelStationable node) {
        return InvalidMove("``node.name`` may not have a fuel station.");
    }
    
    value placedFuelStations = game.placedFuelStations;
    
    if (placedFuelStations.contains(node)) {
        return InvalidMove("``node.name`` already has a fuel station.");
    }
    
    value playerFuelStationCounts  = game.playerFuelStationCounts;
    value playerFuelStationCount = game.playerFuelStationCount(player);
    value playerName => game.playerName(player);
    
    if (playerFuelStationCount < 1) {
        // TODO: use proper name for stations
        return InvalidMove("``playerName`` does not have a fuel station to place.");
    }
    
    value owner = game.ownedNodes.get(node);
    
    if (!exists owner) {
        return InvalidMove(
            "``node.name`` isn't owned by anybody and can't have a fuel station placed on it.");
    }
    else if (owner != player) {
        return InvalidMove(
            "``playerName`` doesn't own ``node.name`` and can't place a fuel station on it.");
    }
    
    return game.with {
        playerFuelStationCounts
            = { player -> playerFuelStationCount - 1, *playerFuelStationCounts};
        placedFuelStations = { node, *placedFuelStations };
    };
}

// TODO: docs
shared Result purchaseNode(Game game, Player player, Node node) {
    if (!is Ownable node) {
        return InvalidMove("``node.name`` may not be purchased.");
    }
    
    value ownedNodes = game.ownedNodes;
    
    if (ownedNodes.defines(node)) {
        return InvalidMove("``node.name`` is already owned.");
    }
    
    value playerCashes = game.playerCashes;
    value playerCash = game.playerCash(player);
    value nodePrice = node.price;
    
    if (playerCash < nodePrice) {
        return InvalidMove(
            "``game.playerName(player)`` cannot afford to purchase ``node.name``.");
    }
    
    return game.with {
        ownedNodes = { node -> player, *ownedNodes };
        playerCashes = { player -> playerCash - nodePrice, *playerCashes };
    };
}
