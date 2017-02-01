import com.crappycomic.ceylarquest.model {
    Game,
    Node,
    Ownable,
    Player
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
