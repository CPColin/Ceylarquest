import ceylon.collection {
    HashMap
}
import ceylon.random {
    randomize
}

// TODO: RuleSet class
Integer defaultPlayerCash = 1995;

Integer defaultPlayerFuelStationCount = 3;

// TODO: should be immutable and BoardOverlay should not hold a copy
shared class Game {
    // So we can either create State classes that encapsulate stuff, like
    // NodeState would track the owner and the presence of a fuel station,
    // PlayerState would track current position, cash, fuel, etc.,
    // or the game encapsulates all the state directly
    
    shared List<Player> activePlayers;
    
    shared Board board;
    
    shared Map<Ownable, Player> ownedNodes;
    
    shared Set<FuelStationable> placedFuelStations;
    
    shared Map<Player, Integer> playerCashes;
    
    shared Map<Player, Integer> playerFuels = HashMap<Player, Integer>();
    
    shared Map<Player, Integer> playerFuelStationCounts;
    
    Map<Player, Node> playerLocations;
    
    Map<Player, String> playerNames;
    
    shared new(Board board, {<Player -> String>*} playerNames, {Player*}? activePlayers = null,
            {<Player -> Node>*}? playerLocations = null,
            {<Node -> Player>*}? ownedNodes = null, {Node*}? placedFuelStations = null,
            {<Player -> Integer>*}? playerCashes = null,
            {<Player -> Integer>*}? playerFuelStationCounts = null) {
        this.board = board;
        this.playerNames = map(playerNames);
        
        if (exists activePlayers) {
            this.activePlayers
                = randomize(activePlayers.filter((player) => this.playerNames.defines(player)));
        }
        else {
            this.activePlayers = randomize(this.playerNames.keys);
        }
        
        if (exists playerLocations) {
            this.playerLocations = map {
                playerLocations.filter((player -> _) => this.activePlayers.contains(player));
            };
        }
        else {
            this.playerLocations = emptyMap;
        }
        
        if (exists ownedNodes) {
            this.ownedNodes = map {
                ownedNodes.filter((_ -> player) => this.activePlayers.contains(player))
                    .filter((node -> _) => node is Ownable)
                    .map((node -> player) {
                        assert(is Ownable node);
                        
                        return (node -> player);
                    });
            };
        }
        else {
            this.ownedNodes = emptyMap;
        }
        
        if (exists placedFuelStations) {
            this.placedFuelStations = set(placedFuelStations.narrow<FuelStationable>());
        }
        else {
            this.placedFuelStations = emptySet;
        }
        
        if (exists playerCashes) {
            this.playerCashes = map {
                playerCashes.filter((player -> cash)
                    => this.activePlayers.contains(player) && cash >= 0);
            };
        }
        else {
            this.playerCashes = emptyMap;
        }
        
        if (exists playerFuelStationCounts) {
            this.playerFuelStationCounts = map {
                playerFuelStationCounts.filter((player -> fuelStationCount)
                    => this.activePlayers.contains(player) && fuelStationCount >= 0);
            };
        }
        else {
            this.playerFuelStationCounts = emptyMap;
        }
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
    
    shared Integer playerCash(Player player)
        => playerCashes.getOrDefault(player, defaultPlayerCash);
    
    shared Integer playerFuelStationCount(Player player)
        => playerFuelStationCounts.getOrDefault(player, defaultPlayerFuelStationCount);
    
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
    
    "Returns a copy of this object that includes the given changes."
    shared Game with({<Node -> Player>*}? ownedNodes = null,
            {<Player -> Integer>*}? playerFuelStationCounts = null,
            {Node*}? placedFuelStations = null,
            {<Player -> Integer>*}? playerCashes = null) {
        return Game(this.board,
            this.playerNames,
            this.activePlayers,
            this.playerLocations,
            ownedNodes else this.ownedNodes,
            placedFuelStations else this.placedFuelStations,
            playerCashes else this.playerCashes,
            playerFuelStationCounts else this.playerFuelStationCounts);
    }
}
