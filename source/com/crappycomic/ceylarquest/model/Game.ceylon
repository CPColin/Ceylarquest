import ceylon.random {
    randomize
}

// TODO: RuleSet class
Integer defaultFuelStationsRemaining = 46;

Integer defaultInitialFuelStations = 3;

Integer defaultPlayerCash = 1995;

Integer defaultPlayerFuelStationCount = 3;

shared Integer maximumFuel = 25;

shared abstract class Unowned() of unowned {}

shared object unowned extends Unowned() {}

shared alias Owner => Player|Unowned;

shared class Game {
    // So we can either create State classes that encapsulate stuff, like
    // NodeState would track the owner and the presence of a fuel station,
    // PlayerState would track current position, cash, fuel, etc.,
    // or the game encapsulates all the state directly
    
    shared List<Player> activePlayers;
    
    shared Board board;
    
    shared {Debt*} debts;
    
    shared Integer fuelStationsRemaining;
    
    shared Map<Ownable, Owner> owners;
    
    shared Phase phase;
    
    shared Set<FuelStationable> placedFuelStations;
    
    shared Map<Player, Integer> playerCashes;
    
    shared Map<Player, Integer> playerFuels;
    
    shared Map<Player, Integer> playerFuelStationCounts;
    
    Map<Player, Node> playerLocations;
    
    Map<Player, String> playerNames;
    
    shared new(Board board, {<Player -> String>*} playerNames,
            {Player*}? activePlayers = null,
            {Debt*}? debts = null,
            Integer? fuelStationsRemaining = null,
            {<Node -> Owner>*}? owners = null,
            Phase? phase = null,
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
        
        if (exists debts) {
            this.debts = debts.filter((debt)
                => this.activePlayers.contains(debt.creditor)
                    && this.activePlayers.contains(debt.debtor)
                    && debt.amount > 0);
        }
        else {
            this.debts = {};
        }
        
        if (exists fuelStationsRemaining) {
            this.fuelStationsRemaining = largest(fuelStationsRemaining, 0);
        }
        else {
            this.fuelStationsRemaining
                = defaultFuelStationsRemaining - defaultInitialFuelStations * this.playerNames.size;
        }
        
        if (exists owners) {
            this.owners = map {
                owners
                    .filter((_ -> owner) => owner is Unowned || this.activePlayers.contains(owner))
                    .filter((node -> _) => node is Ownable)
                    .map((node -> owner) {
                        assert(is Ownable node);
                        
                        return (node -> owner);
                    });
            };
        }
        else {
            this.owners = emptyMap;
        }
        
        this.phase = phase else preRoll;
        
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
    
    shared Owner owner(Node node) => owners.getOrDefault(node, unowned);
    
    shared Integer playerCash(Player player)
        => playerCashes.getOrDefault(player, defaultPlayerCash);
    
    shared Integer playerFuel(Player player) => playerFuels.getOrDefault(player, maximumFuel);
    
    shared Integer playerFuelStationCount(Player player)
        => playerFuelStationCounts.getOrDefault(player, defaultPlayerFuelStationCount);
    
    shared Node playerLocation(Player player) => playerLocations.getOrDefault(player, board.start);
    
    suppressWarnings("expressionTypeNothing") // Shouldn't happen in normal operation.
    shared String playerName(Player player) => playerNames.get(player) else nothing;
    
    "Returns a copy of this object that includes the given changes."
    shared Game with(
            {Debt*}? debts = null,
            Integer? fuelStationsRemaining = null,
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
            fuelStationsRemaining = fuelStationsRemaining else this.fuelStationsRemaining;
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
