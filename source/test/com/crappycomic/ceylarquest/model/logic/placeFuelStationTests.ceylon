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
    incorrectPhase,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    placeFuelStation
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testPlayers,
    wrongPhaseTest
}

test
shared void placeFuelStationAlreadyPlaced() {
    value node = tropicHopBoard.testFuelStationable;
    value player = testGame.currentPlayer;
    value game = testGame.with {
        owners = { node -> player };
        phase = preRoll;
        placedFuelStations = { node };
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    assertTrue(game.placedFuelStations.contains(node), "Node didn't start with a fuel station.");
    
    value result = placeFuelStation(game, player, node);
    
    if (is Game result) {
        fail("Placing fuel station where one was already placed should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void placeFuelStationInsufficient() {
    value node = tropicHopBoard.testFuelStationable;
    value player = testGame.currentPlayer;
    value game = testGame.with {
        owners = { node -> player };
        phase = preRoll;
        playerFuelStationCounts = { player -> 0 };
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    assertEquals(game.playerFuelStationCount(player), 0,
        "Player should have started with zero fuel stations.");
    
    value result = placeFuelStation(game, player, node);
    
    if (is Game result) {
        fail("Player had no fuel stations and should not have been able to place one.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void placeFuelStationInvalidNode() {
    value node = tropicHopBoard.testNotFuelSalableOrStationable;
    value player = testGame.currentPlayer;
    value game = testGame.with {
        owners = { node -> player };
        phase = preRoll;
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    
    value result = placeFuelStation(game, player, node);
    
    if (is Game result) {
        fail("Placing fuel station on non-FuelStationable node should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void placeFuelStationSuccess() {
    value node = tropicHopBoard.testFuelStationable;
    value player = testGame.currentPlayer;
    value game = testGame.with {
        owners = { node -> player };
        phase = preRoll;
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
shared void placeFuelStationUnowned() {
    value node = tropicHopBoard.testOwnablePort;
    value game = testGame.with {
        phase = preRoll;
    };
    
    assertFalse(game.owner(node) is Player, "Node is unexpectedly owned.");
    
    value result = placeFuelStation(game, game.currentPlayer, node);
    
    if (is Game result) {
        fail("Placing fuel station on unowned node should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void placeFuelStationWrongOwner() {
    value node = tropicHopBoard.testOwnablePort;
    value [player1, player2] = testPlayers;
    value game = testGame.with {
        owners = { node -> player2 };
        phase = preRoll;
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    
    value result = placeFuelStation(game, player1, node);
    
    if (is Game result) {
        fail("Placing fuel station on node owned by somebody else should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void placeFuelStationWrongPhase() {
    value node = tropicHopBoard.testOwnablePort;
    
    wrongPhaseTest((game) => placeFuelStation(game, game.currentPlayer, node), preRoll, postLand);
}
