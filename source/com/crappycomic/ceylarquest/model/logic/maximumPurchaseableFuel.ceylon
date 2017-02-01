import com.crappycomic.ceylarquest.model {
    FuelSalable,
    Game,
    Player,
    maximumFuel
}

"Returns the maximum number of units of fuel that can be purchased by the given [[player]] at the
 given [[node]], given the current state of the [[game]], taking into account both the space in the
 player's fuel tank and the amount of cash the player has."
// TODO: needs tests
shared Integer maximumPurchaseableFuel(Game game, Player player, FuelSalable node) {
    value fuelTankSpace = maximumFuel - game.playerFuel(player);
    value unitCost = fuelFee(game, player, node);
    
    return if (unitCost == 0) then fuelTankSpace else game.playerCash(player) / unitCost;
}
