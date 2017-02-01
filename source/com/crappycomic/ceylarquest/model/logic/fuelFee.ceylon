import com.crappycomic.ceylarquest.model {
    FuelSalable,
    Game,
    Ownable,
    Player
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
