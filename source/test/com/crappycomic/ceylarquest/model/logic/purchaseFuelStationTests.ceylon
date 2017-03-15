import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Administration,
    Game,
    postLand,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    canPurchaseFuelStation,
    purchaseFuelStation
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    wrongPhaseTest
}

test
shared void purchaseFuelStationTest() {
    value player = testGame.currentPlayer;
    value node = testNodes<Administration>().first;
    value game = testGame.with {
        phase = preRoll;
        playerLocations = { player -> node };
    };
    value fuelStationsRemaining = game.fuelStationsRemaining;
    value playerCash = game.playerCash(player);
    value playerFuelStationCount = game.playerFuelStationCount(player);
    
    assertTrue(canPurchaseFuelStation(game), "The test game was not set up properly.");
    
    value result = purchaseFuelStation(game);
    
    if (is Game result) {
        assertEquals(result.fuelStationsRemaining, fuelStationsRemaining - 1,
            "Fuel stations remaining didn't decrease.");
        assertEquals(result.playerCash(player), playerCash - game.rules.fuelStationPrice,
            "Player's cash didn't decrease.");
        assertEquals(result.playerFuelStationCount(player), playerFuelStationCount + 1,
            "Player's fuel station count didn't increase.");
    }
    else {
        fail(result.message);
    }
}

test
shared void purchaseFuelStationWrongPhase() {
    wrongPhaseTest((game) => purchaseFuelStation(game), preRoll, postLand);
}
