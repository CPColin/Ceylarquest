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
    purchaseFuelStation
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

test
shared void purchaseFuelStationInsufficientFunds() {
    value player = testGame.currentPlayer;
    value game = testGame.with {
        phase = preRoll;
        playerCashes = { player -> 0 };
    };
    
    assertEquals(game.playerCash(player), 0, "Player cash didn't initialie to zero.");
    
    assertInvalidMove(purchaseFuelStation(game),
        "Player was able to purchase fuel station with no money.");
}

test
shared void purchaseFuelStationNoneRemain() {
    value player = testGame.currentPlayer;
    value game = testGame.with {
        phase = preRoll;
        playerFuelStationCounts = {
            player -> testGame.playerFuelStationCount(player) + testGame.fuelStationsRemaining
        };
    };
    
    assertEquals(game.fuelStationsRemaining, 0, "Fuel stations remaining isn't zero.");
    
    assertInvalidMove(purchaseFuelStation(game),
        "Purchasing a fuel station when none remained should have failed.");
}

test
shared void purchaseFuelStationSuccess() {
    value player = testGame.currentPlayer;
    value game = testGame.with {
        phase = preRoll;
    };
    value fuelStationsRemaining = game.fuelStationsRemaining;
    value playerCash = game.playerCash(player);
    value playerFuelStationCount = game.playerFuelStationCount(player);
    
    assertTrue(fuelStationsRemaining > 0,
        "At least one fuel station needs to be remaining at the start of this test.");
    
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
