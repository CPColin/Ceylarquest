import com.crappycomic.ceylarquest.model {
    FuelSalable,
    Game,
    InvalidMove,
    Node,
    Ownable,
    Player,
    Result,
    incorrectPhase,
    postLand,
    preRoll
}

"Alters the state of the given [[game]] so the given [[player]] has purchased the given amount of
 [[fuel]] at the given [[node]]."
shared Result purchaseFuel(Game game, Player player, Node node, Integer fuel) {
    if (game.phase != preRoll && game.phase != postLand) {
        return incorrectPhase;
    }
    
    if (!fuelAvailable(game, node)) {
        return InvalidMove("Fuel is not available for purchase at ``node.name``.");
    }
    
    assert (is FuelSalable node);
    
    if (fuel <= 0) {
        return InvalidMove("Fuel to purchase must be greater than zero.");
    }
    else if (fuel > maximumPurchaseableFuel(game, player, node)) {
        return InvalidMove("Fuel to purchase may not exceed what player can afford.");
    }
    
    value unitCost = fuelFee(game, player, node);
    value owner = if (is Ownable node) then game.owner(node) else null;
    {<Player -> Integer>*}? playerCashes;
    
    if (unitCost > 0) {
        value totalCost = unitCost * fuel;
        
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
        playerFuels = { player -> game.playerFuel(player) + fuel };
    };
}
