import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    canPlaceFuelStation,
    placeFuelStation
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

test
shared void placeFuelStationTest() {
    value node = tropicHopBoard.testFuelStationable;
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
    value node = tropicHopBoard.testOwnablePort;
    
    wrongPhaseTest((game) => placeFuelStation(game, node), preRoll, postLand);
}
