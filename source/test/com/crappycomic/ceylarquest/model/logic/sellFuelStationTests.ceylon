import ceylon.test {
    assertTrue,
    fail,
    test,
    assertEquals
}

import com.crappycomic.ceylarquest.model {
    Administration,
    Game,
    SettlingDebts,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    canSellFuelStation,
    sellFuelStation
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    wrongPhaseTest
}

test
shared void sellFuelStationTest() {
    value player = testGame.currentPlayer;
    value node = testNodes<Administration>().first;
    value game = testGame.with {
        phase = postLand;
        playerLocations = { player -> node };
    };
    value playerCash = game.playerCash(player);
    value playerFuelStationCount = game.playerFuelStationCount(player);
    
    assertTrue(canSellFuelStation(game, player), "The test game was not set up properly.");
    
    value result = sellFuelStation(game, player);
    
    if (is Game result) {
        assertEquals(result.playerCash(player), playerCash + result.rules.fuelStationPrice,
            "Player's cash did not change by the expected amount.");
        assertEquals(result.playerFuelStationCount(player), playerFuelStationCount - 1,
            "Player's fuel station count did not change by the expected amount.");
    }
    else {
        fail(result.message);
    }
}

test
shared void sellFuelStationWrongPhase() {
    wrongPhaseTest((game) => sellFuelStation(game), SettlingDebts({}, postLand), preRoll, postLand);
}
