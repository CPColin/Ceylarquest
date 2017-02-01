import com.crappycomic.ceylarquest.model {
    FuelSalable,
    FuelStationable,
    Game,
    InvalidMove,
    Ownable,
    Player,
    Result,
    incorrectPhase,
    postRoll,
    preRoll
}

// TODO: should all these bad cases continue to fail silently or return InvalidMove?
shared Result purchaseFuel(Game game, Player player, Integer fuel) {
    if (game.phase != preRoll && game.phase != postRoll) {
        return incorrectPhase;
    }
    
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
