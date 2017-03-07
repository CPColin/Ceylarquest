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
    "The players who have not yet been knocked out of the game."
    shared Set<Player> activePlayers;
    
    "All the players in the game, in the order they'll take turns."
    shared [Player+] allPlayers;
    
    shared Board board;
    
    shared Player currentPlayer;
    
    shared Map<Ownable, Owner> owners;
    
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
    
    "General-use constructor."
    shared new(
            Board board,
            {<Player -> String>*} playerNames,
            {Player*}? activePlayers,
            {Player*}? allPlayers,
            Player? currentPlayer,
            {<Node -> Owner>*}? owners,
            Phase? phase,
            {Node*}? placedFuelStations,
            {<Player -> Integer>*}? playerCashes,
            {<Player -> Integer>*}? playerFuels,
            {<Player -> Integer>*}? playerFuelStationCounts,
            {<Player -> Node>*}? playerLocations,
            Rules? rules) {
        this.board = board;
        this.playerNames = map(playerNames);
        
        Player[] allPlayersSequence;
        
        if (exists allPlayers) {
            allPlayersSequence = allPlayers.sequence();
        }
        else {
            allPlayersSequence = randomize(this.playerNames.keys).sequence();
        }
        
        assert (nonempty allPlayersSequence);
        
        this.allPlayers = allPlayersSequence;
        
        if (exists activePlayers) {
            this.activePlayers = set(activePlayers);
        }
        else {
            this.activePlayers = set(this.allPlayers);
        }
        
        assert (this.allPlayers.containsEvery(this.activePlayers));
        
        if (exists currentPlayer) {
            this.currentPlayer = this.activePlayers.contains(currentPlayer)
                then currentPlayer
                else this.allPlayers.first;
        }
        else {
            this.currentPlayer = this.activePlayers.first else this.allPlayers.first;
        }
        
        if (exists owners) {
            this.owners = map {
                for (node -> owner in owners)
                    if (owner is Unowned || this.activePlayers.contains(owner))
                        if (is Ownable node, board.nodes.defines(node))
                            node -> owner
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
    
    "Special constructor with default values, for use in unit tests."
    shared new test(
            Board board,
            {<Player -> String>*} playerNames,
            {Player*}? activePlayers = null,
            {Player*}? allPlayers = null,
            Player? currentPlayer = null,
            {<Node -> Owner>*}? owners = null,
            Phase? phase = null,
            {Node*}? placedFuelStations = null,
            {<Player -> Integer>*}? playerCashes = null,
            {<Player -> Integer>*}? playerFuels = null,
            {<Player -> Integer>*}? playerFuelStationCounts = null,
            {<Player -> Node>*}? playerLocations = null,
            Rules? rules = null)
        extends Game(
            board,
            playerNames,
            activePlayers,
            allPlayers,
            currentPlayer,
            owners,
            phase,
            placedFuelStations,
            playerCashes,
            playerFuels,
            playerFuelStationCounts,
            playerLocations,
            rules) {}
    
    shared Integer fuelStationsRemaining {
        return rules.totalFuelStationCount
            - placedFuelStations.size
            - sum { 0, *{ for (player in activePlayers) playerFuelStationCount(player) } };
    }
    
    shared Player nextPlayer {
        if (activePlayers.empty) {
            // This should never happen, but fail safely, if it somehow does.
            return currentPlayer;
        }
        
        // Also asserted in the constructor.
        assert (allPlayers.containsEvery(activePlayers));
        
        value currentPlayerIndex
            = allPlayers.firstIndexWhere((player) => player == currentPlayer) else 0;
        
        value nextPlayer = allPlayers
            .cycled
            .skip(currentPlayerIndex + 1)
            .find((player) => activePlayers.contains(player));
        
        return nextPlayer else currentPlayer;
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
            Player? currentPlayer = null,
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
            allPlayers = this.allPlayers;
            rules = this.rules;
            
            currentPlayer = currentPlayer else this.currentPlayer;
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
    
    "Returns a copy of this object with the given [[player]] removed from the set of
     [[active players|activePlayers]]."
    shared Game without(Player player) {
        value activePlayers = this.activePlayers ~ set { player };
        Phase phase;
        
        if (activePlayers.size <= 1) {
            phase = gameOver;
        }
        else if (player == currentPlayer) {
            phase = preRoll;
        }
        else {
            phase = this.phase;
        }
        
        return Game {
            allPlayers = this.allPlayers;
            board = this.board;
            owners = this.owners;
            placedFuelStations = this.placedFuelStations;
            playerCashes = this.playerCashes;
            playerFuels = this.playerFuels;
            playerFuelStationCounts = this.playerFuelStationCounts;
            playerLocations = this.playerLocations;
            playerNames = this.playerNames;
            rules = this.rules;
            
            activePlayers = activePlayers;
            currentPlayer = this.currentPlayer == player then nextPlayer else this.currentPlayer;
            phase = phase;
        };
    }
}
