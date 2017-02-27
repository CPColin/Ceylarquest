import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Administration,
    Ownable
}
import com.crappycomic.ceylarquest.model.logic {
    canPurchaseFuelStation
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes
}

test
shared void canPurchaseFuelStationInsufficientFunds() {
    value player = testGame.currentPlayer;
    value node = testNodes<Administration>().first;
    value game = testGame.with {
        playerCashes = { player -> 0 };
        playerLocations = { player -> node };
    };
    
    assertTrue(game.fuelStationsRemaining > 0,
        "This test requires at least one fuel station to be available.");
    
    assertFalse(canPurchaseFuelStation(game),
        "Insufficient cash should have prevented player from purchasing a fuel station.");
}

test
shared void canPurchaseFuelStationNoneRemain() {
    value player = testGame.currentPlayer;
    value node = testNodes<Administration>().first;
    value game = testGame.with {
        playerFuelStationCounts = {
            player -> testGame.playerFuelStationCount(player) + testGame.fuelStationsRemaining
        };
        playerLocations = { player -> node };
    };
    
    assertEquals(game.fuelStationsRemaining, 0,
        "This test requires zero fuel stations to be available.");
    
    assertFalse(canPurchaseFuelStation(game),
        "Purchasing a fuel station when none remained should have failed.");
}

test
shared void canPurchaseFuelStationTest() {
    value player = testGame.currentPlayer;
    value node = testNodes<Administration>().first;
    value game = testGame.with {
        playerCashes = { player -> runtime.maxIntegerValue };
        playerLocations = { player -> node };
    };
    
    assertTrue(game.fuelStationsRemaining > 0,
        "This test requires at least one fuel station to be available.");
    
    assertTrue(canPurchaseFuelStation(game), "Purchasing a fuel station should have succeeded.");
}

test
shared void canPurchaseFuelStationWrongNode() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable, Administration>().first;
    value game = testGame.with {
        playerCashes = { player -> runtime.maxIntegerValue };
        playerLocations = { player -> node };
    };
    
    assertTrue(game.fuelStationsRemaining > 0,
        "This test requires at least one fuel station to be available.");
    
    assertFalse(canPurchaseFuelStation(game),
        "Purchasing a fuel station on a non-Administration node should have failed.");
}
