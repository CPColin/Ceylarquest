import ceylon.random {
    randomize
}

// TODO: RuleSet class
Integer defaultFuelStationsRemaining = 46;

Integer defaultInitialFuelStations = 3;

Integer defaultPlayerCash = 1995;

Integer defaultPlayerFuelStationCount = 3;

shared Integer maximumFuel = 25;

// TODO: should be immutable and BoardOverlay should not hold a copy
shared class Game {
    // So we can either create State classes that encapsulate stuff, like
    // NodeState would track the owner and the presence of a fuel station,
    // PlayerState would track current position, cash, fuel, etc.,
    // or the game encapsulates all the state directly
    
    shared List<Player> activePlayers;
    
    shared Board board;
    
    shared Integer fuelStationsRemaining;
    
    shared Map<Ownable, Player> ownedNodes;
    
    shared Set<FuelStationable> placedFuelStations;
    
    shared Map<Player, Integer> playerCashes;
    
    shared Map<Player, Integer> playerFuels;
    
    shared Map<Player, Integer> playerFuelStationCounts;
    
    Map<Player, Node> playerLocations;
    
    Map<Player, String> playerNames;
    
    shared new(Board board, {<Player -> String>*} playerNames,
            {Player*}? activePlayers = null,
            Integer? fuelStationsRemaining = null,
            {<Node -> Player>*}? ownedNodes = null,
            {Node*}? placedFuelStations = null,
            {<Player -> Integer>*}? playerCashes = null,
            {<Player -> Integer>*}? playerFuels = null,
            {<Player -> Integer>*}? playerFuelStationCounts = null,
            {<Player -> Node>*}? playerLocations = null) {
        this.board = board;
        this.playerNames = map(playerNames);
        
        if (exists activePlayers) {
            this.activePlayers
                = randomize(activePlayers.filter((player) => this.playerNames.defines(player)));
        }
        else {
            this.activePlayers = randomize(this.playerNames.keys);
        }
        
        if (exists fuelStationsRemaining) {
            this.fuelStationsRemaining = largest(fuelStationsRemaining, 0);
        }
        else {
            this.fuelStationsRemaining
                = defaultFuelStationsRemaining - defaultInitialFuelStations * this.playerNames.size;
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
        
        if (exists playerFuels) {
            this.playerFuels = map {
                playerFuels.filter((player -> fuel)
                    => this.activePlayers.contains(player) && fuel >= 0);
            };
        }
        else {
            this.playerFuels = emptyMap;
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
        
        if (exists playerLocations) {
            this.playerLocations = map {
                playerLocations.filter((player -> _) => this.activePlayers.contains(player));
            };
        }
        else {
            this.playerLocations = emptyMap;
        }
    }
    
    shared Player? owner(Node node) => ownedNodes.get(node);
    
    shared Integer playerCash(Player player)
        => playerCashes.getOrDefault(player, defaultPlayerCash);
    
    shared Integer playerFuel(Player player) => playerFuels.getOrDefault(player, maximumFuel);
    
    shared Integer playerFuelStationCount(Player player)
        => playerFuelStationCounts.getOrDefault(player, defaultPlayerFuelStationCount);
    
    shared Node playerLocation(Player player) => playerLocations.getOrDefault(player, board.start);
    
    shared String playerName(Player player) => playerNames.get(player) else nothing;
    
    "Returns a copy of this object that includes the given changes."
    shared Game with(
            Integer? fuelStationsRemaining = null,
            {<Node -> Player>*}? ownedNodes = null,
            {Node*}? placedFuelStations = null,
            {<Player -> Integer>*}? playerCashes = null,
            {<Player -> Integer>*}? playerFuelStationCounts = null,
            {<Player -> Integer>*}? playerFuels = null,
            {<Player -> Node>*}? playerLocations = null) {
        return Game {
            board = this.board;
            playerNames = this.playerNames;
            activePlayers = this.activePlayers;
            fuelStationsRemaining = fuelStationsRemaining else this.fuelStationsRemaining;
            ownedNodes = ownedNodes else this.ownedNodes;
            placedFuelStations = placedFuelStations else this.placedFuelStations;
            playerCashes = playerCashes else this.playerCashes;
            playerFuels = playerFuels else this.playerFuels;
            playerFuelStationCounts = playerFuelStationCounts else this.playerFuelStationCounts;
            playerLocations = playerLocations else this.playerLocations;
        };
    }
    
    // TODO: shared Game without(Player player) {}
}
