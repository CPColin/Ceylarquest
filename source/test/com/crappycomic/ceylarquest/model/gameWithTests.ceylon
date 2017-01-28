import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    Ownable,
    Player,
    testPlayers,
    unowned
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

// These tests aim to make sure Game.with makes only the changes that are passed to it, without
// affecting other players or and nodes.

test
shared void gameWithFuelStationsRemaining() {
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        fuelStationsRemaining = 1;
    };
    
    assertEquals(gameStart.fuelStationsRemaining, 1,
        "Fuel stations remaining didn't initialize right.");
    
    value gameEnd = gameStart.with {
        fuelStationsRemaining = 0;
    };
    
    assertEquals(gameEnd.fuelStationsRemaining, 0,
        "Fuel stations remaining didn't update right.");
}

test
shared void gameWithOwnersDecreasing() {
    value nodes = tropicHopBoard.nodes.keys.narrow<Ownable>();
    value node1 = nodes.first;
    value node2 = nodes.last;
    value player = testPlayers.first.key;
    
    assert(exists node1, exists node2);
    
    assertFalse(node1 == node2, "This test needs two different Ownable nodes.");
    
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        owners = { node1 -> player, node2 -> player };
    };
    
    assertEquals(gameStart.owner(node1), player, "First node isn't owned by the test player.");
    assertEquals(gameStart.owner(node2), player, "Second node isn't owned by the test player.");
    
    value gameEnd = gameStart.with {
        owners = { node1 -> unowned };
    };
    
    assertFalse(gameEnd.owner(node1) is Player, "First node is still owned.");
    assertTrue(gameEnd.owner(node2) is Player, "Second node should still be owned.");
}

test
shared void gameWithOwnersIncreasing() {
    value nodes = tropicHopBoard.nodes.keys.narrow<Ownable>();
    value node1 = nodes.first;
    value node2 = nodes.last;
    value player = testPlayers.first.key;
    
    assert(exists node1, exists node2);
    
    assertFalse(node1 == node2, "This test needs two different Ownable nodes.");
    
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        owners = { node1 -> player };
    };
    
    assertEquals(gameStart.owner(node1), player, "First node isn't owned by the test player.");
    assertEquals(gameStart.owner(node2), unowned, "Second node is owned by somebody.");
    
    value gameEnd = gameStart.with {
        owners = { node2 -> player };
    };
    
    assertTrue(gameEnd.owner(node1) is Player, "First node should still be owned.");
    assertTrue(gameEnd.owner(node2) is Player, "Second node should now be owned.");
}


test
shared void gameWithPlacedFuelStations() {
    value nodes = tropicHopBoard.nodes.keys.narrow<FuelStationable>();
    value node1 = nodes.first;
    value node2 = nodes.last;
    
    assert(exists node1, exists node2);
    
    assertFalse(node1 == node2, "This test needs two different FuelStationable nodes.");
    
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        placedFuelStations = { node1 };
    };
    value gameEnd = gameStart.with {
        placedFuelStations = { node2 };
    };
    
    assertTrue(
        gameEnd.placedFuelStations.contains(node1)
            && gameEnd.placedFuelStations.contains(node2),
        "Need to end up with fuel stations on both nodes.");
}

test
shared void gameWithPlayerCashes() {
    value player = testPlayers.first.key;
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        playerCashes = { for (player -> _ in testPlayers) player -> 1 };
    };
    value gameEnd = gameStart.with {
        playerCashes = { player -> 0 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerCash, "cash", player, 0);
}

test
shared void gameWithPlayerFuels() {
    value player = testPlayers.first.key;
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        playerFuels = { for (player -> _ in testPlayers) player -> 1 };
    };
    value gameEnd = gameStart.with {
        playerFuels = { player -> 0 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerFuel, "fuel", player, 0);
}

test
shared void gameWithPlayerFuelStationCounts() {
    value player = testPlayers.first.key;
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        playerFuelStationCounts = { for (player -> _ in testPlayers) player -> 1 };
    };
    value gameEnd = gameStart.with {
        playerFuelStationCounts = { player -> 0 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerFuelStationCount, "fuel station count", player, 0);
}

test
shared void gameWithPlayerLocations() {
    value player = testPlayers.first.key;
    value node1 = tropicHopBoard.testOwnablePort;
    value node2 = tropicHopBoard.testNotFuelStationable;
    value gameStart = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        playerLocations = { for (player -> _ in testPlayers) player -> node1 };
    };
    value gameEnd = gameStart.with {
        playerLocations = { player -> node2 };
    };
    
    checkPlayers(gameStart, gameEnd, Game.playerLocation, "location", player, node2);
}

void checkPlayers<Value>(Game gameStart, Game gameEnd, Value(Player)(Game) attribute,
        String attributeName, Player targetPlayer, Value targetValue) {
    for (player -> _ in testPlayers) {
        if (player == targetPlayer) {
            assertEquals(attribute(gameEnd)(player), targetValue,
                "Target player has incorrect ``attributeName``.");
        }
        else {
            assertEquals(attribute(gameEnd)(player), attribute(gameStart)(player),
                "Non-target player's ``attributeName`` changed.");
        }
    }
}