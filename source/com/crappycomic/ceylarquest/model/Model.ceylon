shared class InvalidMove(shared String message) {}

shared alias Result => Game|InvalidMove;

// TODO: mutators for Game objects
// TODO: state checks

shared Integer defaultFuelStationPrice = 500;

"Returns the index that should be used when calculating [[rent|Ownable.rents]] and
 [[fuel|FuelSalable.fuels]] fees. The index corresponds to the number of properties in the given
 [[group|deedGroup]] that are owned by the given [[player]], minus one. It does not make sense to
 check the fee index for a deed group where no node is owned. (Thus, it also does not make sense to
 check the fee index associated with a node that is not owned.)"
shared Integer feeIndex(Game game, Player player, DeedGroup deedGroup) {
    return game.owners.count((node -> owner)
        => node.deedGroup == deedGroup && owner == player) - 1;
}

"Returns `true` if fuel is available at the given [[node]]."
shared Boolean fuelAvailable(Game game, Node node) {
    return node is FuelSalable
            && (game.placedFuelStations.contains(node) || !(node is FuelStationable));
}

"Returns the fee that must be paid in order for the given [[player]] to purchase fuel at the given
 [[node]]. This method assumes [[fuel is available|fuelAvailable]] at the given node."
shared Integer fuelFee(Game game, Player player, FuelSalable node) {
    if (is Ownable node) {
        value owner = game.owner(node);
        
        if (owner == player) {
            return 0;
        }
        else if (is Player owner) {
            value fuelFee = node.fuels[feeIndex(game, owner, node.deedGroup)];
            
            assert (exists fuelFee);
            
            return fuelFee;
        }
    }
    
    // Unowned nodes always use the lowest available price.
    return node.fuels[0];
}

"Returns the maximum number of units of fuel that can be purchased by the given [[player]] at the
 given [[node]], given the current state of the [[game]], taking into account both the space in the
 player's fuel tank and the amount of cash the player has."
shared Integer maximumPurchaseableFuel(Game game, Player player, FuelSalable node) {
    value fuelTankSpace = maximumFuel - game.playerFuel(player);
    value unitCost = fuelFee(game, player, node);
    
    return if (unitCost == 0) then fuelTankSpace else game.playerCash(player) / unitCost;
}

"Returns the price of the given node, adding the price of a fuel station, if present."
shared Integer nodePrice(Game game, Ownable node) {
    if (node is FuelStationable && game.placedFuelStations.contains(node)) {
        return defaultFuelStationPrice + node.price;
    }
    else {
        return node.price;
    }
}

shared Result placeFuelStation(Game game, Player player, Node node) {
    if (!is FuelStationable node) {
        return InvalidMove("``node.name`` may not have a fuel station.");
    }
    
    value placedFuelStations = game.placedFuelStations;
    
    if (placedFuelStations.contains(node)) {
        return InvalidMove("``node.name`` already has a fuel station.");
    }
    
    value playerFuelStationCount = game.playerFuelStationCount(player);
    value playerName => game.playerName(player);
    
    if (playerFuelStationCount < 1) {
        // TODO: use a name for stations appropriate for the current game?
        // or forget it because the UI has to be evaded do see these errors?
        return InvalidMove("``playerName`` does not have a fuel station to place.");
    }
    
    value owner = game.owner(node);
    
    if (owner != player) {
        return InvalidMove(
            "``playerName`` doesn't own ``node.name`` and can't place a fuel station on it.");
    }
    
    return game.with {
        playerFuelStationCounts = { player -> playerFuelStationCount - 1 };
        placedFuelStations = { node };
    };
}

// TODO: should all these bad cases continue to fail silently or return InvalidMove?
shared Result purchaseFuel(Game game, Player player, Integer fuel) {
    value node = game.playerLocation(player);
    
    if (!is FuelSalable node) {
        return InvalidMove("Fuel is not available for purchase at ``node.name``.");
    }
    
    if (node is FuelStationable && !game.placedFuelStations.contains(node)) {
        return InvalidMove("No fuel station is present on ``node.name``.");
    }
    
    value unitCost = fuelFee(game, player, node);
    value clampedFuel = largest(0, smallest(maximumPurchaseableFuel(game, player, node), fuel));
    
    if (clampedFuel == 0) {
        return game;
    }
    
    value owner = if (is Ownable node) then game.owner(node) else null;
    // TODO: Is there a better way to build up this parameter?
    variable {<Player -> Integer>*} playerCashes = game.playerCashes;
    
    if (unitCost > 0) {
        value totalCost = unitCost * clampedFuel;
        
        playerCashes = playerCashes.follow(player -> game.playerCash(player) - totalCost);
        
        if (is Player owner) {
            playerCashes = playerCashes.follow(owner -> game.playerCash(owner) + totalCost);
        }
    }
    
    return game.with {
        playerCashes = playerCashes;
        playerFuels = { player -> game.playerFuel(player) + clampedFuel };
    };
}

shared Result purchaseFuelStation(Game game, Player player) {
    if (game.fuelStationsRemaining <= 0) {
        return InvalidMove("No fuel stations remain for purchase.");
    }
    
    if (game.playerCash(player) < defaultFuelStationPrice) {
        return InvalidMove("``game.playerName(player)`` cannot afford to purchase a fuel station.");
    }
    
    return game.with {
        fuelStationsRemaining = game.fuelStationsRemaining - 1;
        playerCashes = { player -> game.playerCash(player) - defaultFuelStationPrice };
        playerFuelStationCounts = { player -> game.playerFuelStationCount(player) + 1 };
    };
}

// TODO: docs
shared Result purchaseNode(Game game, Player player, Node node) {
    if (!is Ownable node) {
        return InvalidMove("``node.name`` may not be purchased.");
    }
    
    if (game.owner(node) is Player) {
        return InvalidMove("``node.name`` is already owned.");
    }
    
    value playerCash = game.playerCash(player);
    value nodePrice = package.nodePrice(game, node);
    
    if (playerCash < nodePrice) {
        return InvalidMove(
            "``game.playerName(player)`` cannot afford to purchase ``node.name``.");
    }
    
    return game.with {
        owners = { node -> player };
        playerCashes = { player -> playerCash - nodePrice };
    };
}

"Relinquishes ownership of the given [[node]], with [[optional compensation|compensateOwner]] to the
 given [[player]], who must be the current owner of the node."
shared Result relinquishNode(Game game, Player player, Node node, Boolean compensateOwner) {
    if (!is Ownable node) {
        return InvalidMove("``node.name`` may not be purchased or relinquished.");
    }
    
    value owner = game.owner(node);
    
    if (owner != player) {
        return InvalidMove("``game.playerName(player)`` does not own ``node.name``.");
    }
    
    value playerCash = game.playerCash(player);
    value nodePrice = package.nodePrice(game, node);
    value playerCashes = if (compensateOwner) then { player -> playerCash + nodePrice } else null;
    
    return game.with {
        owners = { node -> unowned };
        playerCashes = playerCashes;
    };
}

"Returns the fee that must be paid in order for the given [[player]] to land at the given [[node]]."
shared Integer rentFee(Game game, Player player, Node node) {
    if (is Ownable node) {
        value owner = game.owner(node);
        
        if (owner == player) {
            return 0;
        }
        else if (is Player owner) {
            value rent = node.rents[feeIndex(game, owner, node.deedGroup)];
            
            assert (exists rent);
            
            return rent;
        }
    }
    
    return 0;
}
