import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    canPlaceFuelStation,
    placeFuelStation
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    wrongPhaseTest
}

test
shared void placeFuelStationTestNoNode() {
    value result = placeFuelStation(testGame, null);
    
    assertTrue(result === testGame, "Placing fuel station on a null node should be a no-op.");
}

test
shared void placeFuelStationTest() {
    value node = testNodes<FuelStationable>().first;
    value player = testGame.currentPlayer;
    value game = testGame.with {
        owners = { node -> player };
        phase = preRoll;
    };
    value fuelStationCount = game.playerFuelStationCount(player);
    
    assertTrue(canPlaceFuelStation(game, node), "Initial game state is incorrect for this test.");
    
    value result = placeFuelStation(game, node);
    
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
shared void placeFuelStationWrongPhase() {
    value node = testNodes<FuelStationable>().first;
    
    wrongPhaseTest((game) => placeFuelStation(game, node), preRoll, postLand);
}
