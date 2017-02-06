import ceylon.random {
    randomize
}

"Encapsulates the validated, immutable state of a game. This class does not concern itself with
 enforcing game logic beyond the minimal checks necessary to prevent instances from representing
 obviously invalid states. For example, this class verifies that no player has negative fuel, but
 makes no checks for, say, players who have thousands of units of fuel.
 
 The code in [[package com.crappycomic.ceylarquest.model.logic]] handles game logic.
 
 Since instances of this class are immutable, use [[Game.with]] to create new instances that include
 requested updates."
shared class Game {
    shared List<Player> activePlayers;
    
    shared Board board;
    
    shared {Debt*} debts;
    
    shared Map<Node, Owner> owners;
    
    shared Phase phase;
    
    shared Set<FuelStationable> placedFuelStations;
    
    Map<Player, Integer> playerCashes;
    
    Map<Player, Integer> playerFuels;
    
    Map<Player, Integer> playerFuelStationCounts;
    
    Map<Player, Node> playerLocations;
    
    Map<Player, String> playerNames;
    
    "The rules by which we will play this game, which may differ from the default rules contained in
     the [[board]]."
    shared Rules rules;
    
    shared new(Board board, {<Player -> String>*} playerNames,
            {Player*}? activePlayers = null,
            {Debt*}? debts = null,
            {<Node -> Owner>*}? owners = null,
            Phase? phase = null,
            {Node*}? placedFuelStations = null,
            {<Player -> Integer>*}? playerCashes = null,
            {<Player -> Integer>*}? playerFuels = null,
            {<Player -> Integer>*}? playerFuelStationCounts = null,
            {<Player -> Node>*}? playerLocations = null,
            Rules? rules = null) {
        this.board = board;
        this.playerNames = map(playerNames);
        
        if (exists activePlayers) {
            this.activePlayers
                = randomize(activePlayers.filter((player) => this.playerNames.defines(player)));
        }
        else {
            this.activePlayers = randomize(this.playerNames.keys);
        }
        
        if (exists debts) {
            this.debts = debts.filter((debt)
                => this.activePlayers.contains(debt.creditor)
                    && this.activePlayers.contains(debt.debtor)
                    && debt.amount > 0);
        }
        else {
            this.debts = {};
        }
        
        if (exists owners) {
            this.owners = map {
                owners
                    .filter((_ -> owner) => owner is Unowned || this.activePlayers.contains(owner))
                    .filter((node -> _) => node is Ownable && board.nodes.defines(node));
            };
        }
        else {
            this.owners = emptyMap;
        }
        
        this.phase = phase else preRoll;
        
        if (exists placedFuelStations) {
            this.placedFuelStations = set {
                placedFuelStations
                    .filter((node) => board.nodes.defines(node))
                    .narrow<FuelStationable>();
            };
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
                playerLocations.filter((player -> node)
                    => this.activePlayers.contains(player)
                        && !node is Well
                        && board.nodes.defines(node));
            };
        }
        else {
            this.playerLocations = emptyMap;
        }
        
        if (exists rules) {
            this.rules = rules;
        }
        else {
            this.rules = board.defaultRules;
        }
    }
    
    shared Integer fuelStationsRemaining {
        return rules.totalFuelStationCount
            - placedFuelStations.size
            - sum { 0, *{ for (player in activePlayers) playerFuelStationCount(player) } };
    }
    
    shared Owner owner(Node node) => owners.getOrDefault(node, unowned);
    
    shared Boolean placedFuelStation(Node node) => placedFuelStations.contains(node);
    
    shared Integer playerCash(Player player)
        => playerCashes.getOrDefault(player, rules.initialCash);
    
    shared Integer playerFuel(Player player)
        => playerFuels.getOrDefault(player, rules.maximumFuel);
    
    shared Integer playerFuelStationCount(Player player)
        => playerFuelStationCounts.getOrDefault(player, rules.initialFuelStationCount);
    
    shared Node playerLocation(Player player) => playerLocations.getOrDefault(player, board.start);
    
    suppressWarnings("expressionTypeNothing") // Shouldn't happen in normal operation.
    shared String playerName(Player player) => playerNames.get(player) else nothing;
    
    "Returns a copy of this object that includes the given changes."
    shared Game with(
            {Debt*}? debts = null,
            {<Node -> Owner>*}? owners = null,
            Phase? phase = null,
            {Node*}? placedFuelStations = null,
            {<Player -> Integer>*}? playerCashes = null,
            {<Player -> Integer>*}? playerFuels = null,
            {<Player -> Integer>*}? playerFuelStationCounts = null,
            {<Player -> Node>*}? playerLocations = null) {
        return Game {
            board = this.board;
            playerNames = this.playerNames;
            activePlayers = this.activePlayers;
            
            debts = debts?.chain(this.debts) else this.debts;
            owners = owners?.chain(this.owners) else this.owners;
            phase = phase else this.phase;
            placedFuelStations = placedFuelStations?.chain(this.placedFuelStations)
                else this.placedFuelStations;
            playerCashes = playerCashes?.chain(this.playerCashes) else this.playerCashes;
            playerFuels = playerFuels?.chain(this.playerFuels) else this.playerFuels;
            playerFuelStationCounts = playerFuelStationCounts?.chain(this.playerFuelStationCounts)
                else this.playerFuelStationCounts;
            playerLocations = playerLocations?.chain(this.playerLocations)
                else this.playerLocations;
        };
    }
    
    // TODO: shared Game without(Player player) {}
}
