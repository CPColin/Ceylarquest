import ceylon.collection {
    ArrayList,
    HashMap,
    HashSet,
    MutableList,
    MutableMap,
    MutableSet
}
import ceylon.random {
    randomize
}

shared serializable class Game {
    // So we can either create State classes that encapsulate stuff, like
    // NodeState would track the owner and the presence of a fuel station,
    // PlayerState would track current position, cash, fuel, etc.,
    // or the game encapsulates all the state directly
    
    MutableList<Player> activePlayers;
    
    Board board;
    
    MutableMap<Ownable, Player> ownedNodes = HashMap<Ownable, Player>();
    
    MutableSet<FuelStationable> placedFuelStations = HashSet<FuelStationable>();
    
    MutableMap<Player, Integer> playerCash = HashMap<Player, Integer>();
    
    MutableMap<Player, Integer> playerFuel = HashMap<Player, Integer>();
    
    MutableMap<Player, Integer> playerFuelStations = HashMap<Player, Integer>();
    
    MutableMap<Player, Node> playerLocations = HashMap<Player, Node>();
    
    Map<Player, String> playerNames;
    
    shared new(Board board, Map<Player, String> playerNames) {
        this.board = board;
        this.playerNames = playerNames;
        
        activePlayers = ArrayList<Player> { elements = randomize(playerNames.keys); };
    }
    
    "Returns the index that should be used when calculating
     [[rent|Ownable.rents]] and [[fuel|FuelSalable.fuels]] fees. The index
     corresponds to the number of properties in the given [[group|deedGroup]]
     that are owned by the given [[player]], minus one."
    shared Integer feeIndex(Player player, DeedGroup deedGroup) {
        return ownedNodes.count((Ownable node -> Player owner)
            => node.deedGroup == deedGroup && owner == player) - 1;
    }
    
    "Returns `true` if fuel is available at the given [[node]]."
    shared Boolean fuelAvailable(Node node) {
        return node is FuelSalable
                && (placedFuelStations.contains(node) || !(node is FuelStationable));
    }
    
    "Returns the fee that must be paid in order for the given [[player]] to
     purchase fuel at the given [[node]]. This method assumes
     [[fuel is available|fuelAvailable]] at the given node."
    shared Integer fuelFee(FuelSalable node, Player player) {
        if (is Ownable node) {
            value owner = this.owner(node);
            
            if (exists owner) {
                if (owner == player) {
                    return 0;
                }
                else {
                    value fuelFee = node.fuels[feeIndex(player, node.deedGroup)];
                    
                    assert (exists fuelFee);
                    
                    return fuelFee;
                }
            }
        }
        
        // Unowned nodes always use the lowest available price.
        return node.fuels[0];
    }
    
    shared Player? owner(Node node) => ownedNodes.get(node);
    
    shared Node playerLocation(Player player) => playerLocations.getOrDefault(player, board.start);
    
    shared String playerName(Player player) => playerNames.get(player) else nothing;
    
    shared Integer rentFee(Node node, Player player) {
        if (is Ownable node) {
            value owner = this.owner(node);
            
            if (exists owner) {
                if (owner == player) {
                    return 0;
                }
                else {
                    value rent = node.rents[feeIndex(player, node.deedGroup)];
                    
                    assert (exists rent);
                    
                    return rent;
                }
            }
        }
        
        return 0;
    }
    
    // TODO: serialize to and from JSON
}
