import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    placeFuelStation,
    testPlayers
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

test
shared void testPlaceFuelStationSuccess() {
    value node = tropicHopBoard.testFuelStationable;
    value player = testPlayers.first.key;
    value game = Game {
        board = tropicHopBoard;
        playerNames = testPlayers;
        ownedNodes = {node -> player};
    };
    value fuelStationCount = game.playerFuelStationCount(player);
    
    assertTrue(game.ownedNodes.defines(node), "Node is unexpectedly not owned.");
    
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
