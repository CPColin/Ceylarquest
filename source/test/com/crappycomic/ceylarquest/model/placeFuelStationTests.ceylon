import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    Player,
    placeFuelStation,
    testPlayers
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

test
shared void testPlaceFuelStationAlreadyPlaced() {
    value node = tropicHopBoard.testFuelStationable;
    value player = testPlayers.first.key;
    value game = testGame.with {
        owners = { node -> player };
        placedFuelStations = { node };
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    assertTrue(game.placedFuelStations.contains(node), "Node didn't start with a fuel station.");
    
    value result = placeFuelStation(game, player, node);
    
    if (is Game result) {
        fail("Placing fuel station where one was already placed should have failed.");
    }
    else {
        print(result.message);
    }
}

test
shared void testPlaceFuelStationInsufficient() {
    value node = tropicHopBoard.testFuelStationable;
    value player = testPlayers.first.key;
    value game = testGame.with {
        owners = { node -> player };
        playerFuelStationCounts = { player -> 0 };
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    assertEquals(game.playerFuelStationCount(player), 0,
        "Player should have started with zero fuel stations.");
    
    value result = placeFuelStation(game, player, node);
    
    if (is Game result) {
        fail("Player had no fuel stations and should not have been able to place one.");
    }
    else {
        print(result.message);
    }
}

test
shared void testPlaceFuelStationInvalidNode() {
    value node = tropicHopBoard.testNotFuelStationable;
    value player = testPlayers.first.key;
    value game = testGame.with {
        owners = { node -> player };
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    
    value result = placeFuelStation(game, player, node);
    
    if (is Game result) {
        fail("Placing fuel station on non-FuelStationable node should have failed.");
    }
    else {
        print(result.message);
    }
}

test
shared void testPlaceFuelStationSuccess() {
    value node = tropicHopBoard.testFuelStationable;
    value player = testPlayers.first.key;
    value game = testGame.with {
        owners = { node -> player };
    };
    value fuelStationCount = game.playerFuelStationCount(player);
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    
    value result = placeFuelStation(game, player, node);
    
    if (is Game result) {
        assertEquals(result.playerFuelStationCount(player), fuelStationCount - 1,
            "Player's fuel station count didn't decrease.");
        assertTrue(result.placedFuelStations.contains(node),
            "Node does not have a fuel station on it.");
    }
    else {
        fail(result.message);
    }
}

test
shared void testPlaceFuelStationUnowned() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = testGame;
    
    assertFalse(game.owner(node) is Player, "Node is unexpectedly owned.");
    
    value result = placeFuelStation(game, player, node);
    
    if (is Game result) {
        fail("Placing fuel station on unowned node should have failed.");
    }
    else {
        print(result.message);
    }
}

test
shared void testPlaceFuelStationWrongOwner() {
    value node = tropicHopBoard.testOwnablePort;
    value player1 = testPlayers.first.key;
    value player2 = testPlayers.last.key;
    value game = testGame.with {
        owners = { node -> player2 };
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    
    value result = placeFuelStation(game, player1, node);
    
    if (is Game result) {
        fail("Placing fuel station on node owned by somebody else should have failed.");
    }
    else {
        print(result.message);
    }
}
