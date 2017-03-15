import ceylon.test {
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    Administration,
    preRoll
}
import com.crappycomic.ceylarquest.model.logic {
    canSell,
    canSellFuelStation
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes
}

test
shared void canSellFuelStationNoneToSell() {
    value player = testGame.currentPlayer;
    value node = testNodes<Administration>().first;
    value game = testGame.with {
        phase = preRoll;
        playerFuelStationCounts = { player -> 0 };
        playerLocations = { player -> node };
    };
    
    assertTrue(canSell(game), "The test game was not set up properly.");
    
    assertFalse(canSellFuelStation(game),
        "Player can't sell fuel station when none are on-hand.");
}

test shared void canSellFuelStationTest() {
    value player = testGame.currentPlayer;
    value node = testNodes<Administration>().first;
    value game = testGame.with {
        phase = preRoll;
        playerLocations = { player -> node };
    };
    
    assertTrue(canSell(game), "The test game was not set up properly.");
    
    assertTrue(canSellFuelStation(game), "Should be able to sell a fuel station.");
}
