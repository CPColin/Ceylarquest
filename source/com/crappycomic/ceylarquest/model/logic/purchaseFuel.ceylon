import com.crappycomic.ceylarquest.model {
    FuelSalable,
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
    
    if (!fuelAvailable(game, node)) {
        return InvalidMove("Fuel is not available for purchase at ``node.name``.");
    }
    
    assert (is FuelSalable node);
    
    value unitCost = fuelFee(game, player, node);
    value clampedFuel = largest(0, smallest(maximumPurchaseableFuel(game, player, node), fuel));
    
    if (clampedFuel == 0) {
        return game;
    }
    
    value owner = if (is Ownable node) then game.owner(node) else null;
    {<Player -> Integer>*}? playerCashes;
    
    if (unitCost > 0) {
        value totalCost = unitCost * clampedFuel;
        
        // The second conditional should be enough, but using it alone is triggering this error:
        // Ceylon backend error: incompatible types: com.crappycomic.ceylarquest.model.Unowned
        // cannot be converted to com.crappycomic.ceylarquest.model.unowned_
        if (exists owner, is Player owner) {
            playerCashes = {
                player -> game.playerCash(player) - totalCost,
                owner -> game.playerCash(owner) + totalCost
            };
        }
        else {
            playerCashes = {
                player -> game.playerCash(player) - totalCost
            };
        }
    }
    else {
        playerCashes = null;
    }
    
    return game.with {
        playerCashes = playerCashes;
        playerFuels = { player -> game.playerFuel(player) + clampedFuel };
    };
}
