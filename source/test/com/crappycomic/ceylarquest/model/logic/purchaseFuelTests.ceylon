import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelSalable,
    FuelStationable,
    Game,
    incorrectPhase,
    postRoll,
    preRoll,
    testPlayers
}
import com.crappycomic.ceylarquest.model.logic {
    fuelFee,
    purchaseFuel
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

test
suppressWarnings("redundantNarrowing") // Making sure our test data has the right type.
shared void purchaseFuelNoFuelStation() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testFuelStationable;
    
    assertTrue(node is FuelStationable, "Node must be FuelStationable for this test.");
    
    value game = testGame.with {
        phase = preRoll;
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    
    assertFalse(game.placedFuelStations.contains(node), "Fuel station was unexpectedly present.");
    
    value result = purchaseFuel(game, player, 1);
    
    if (is Game result) {
        fail("Attempt to purchase fuel with no fuel station present should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

test
shared void purchaseFuelNoMoney() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value game = testGame.with {
        phase = preRoll;
        playerCashes = { player -> 0 };
        playerFuels = { player -> 0 };
    };
    value playerCash = game.playerCash(player);
    value playerFuel = game.playerFuel(player);
    
    assertEquals(playerCash, 0, "Player has money, but shouldn't.");
    assertEquals(playerFuel, 0, "Player's fuel tank is not empty.");
    assertTrue(fuelFee(game, player, node) > 0, "Fuel needs to cost something for this test.");
    
    value result = purchaseFuel(game, player, 1);
    
    if (is Game result) {
        assertEquals(game.playerCash(player), playerCash, "Player's cash changed.");
        assertEquals(game.playerFuel(player), playerFuel, "Player's fuel changed.");
    }
    else {
        fail("Purchase with insufficient funds should have failed silently: ``result.message``");
    }
}

test
shared void purchaseFuelNotFuelSalable() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testNotFuelSalableOrStationable;
    
    assertFalse(node is FuelSalable, "Node can't be FuelSalable for this test.");
    
    value game = testGame.with {
        phase = preRoll;
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    value result = purchaseFuel(game, player, 1);
    
    if (is Game result) {
        fail("Purchasing fuel when node isn't FuelSalable should have failed.");
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}

"Attempts to purchase two units of fuel when the player has only enough cash to purchase one unit."
test
shared void purchaseFuelSomeMoney() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value fuelUnitFee = fuelFee(testGame, player, node);
    
    assertTrue(fuelUnitFee > 0, "Fuel needs to cost something for this test.");
    
    value game = testGame.with {
        phase = preRoll;
        playerCashes = { player -> fuelUnitFee };
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    value playerCash = game.playerCash(player);
    value playerFuel = game.playerFuel(player);
    
    assertEquals(playerCash, fuelUnitFee, "Player has wrong amount of money.");
    assertEquals(playerFuel, 0, "Player's fuel tank is not empty.");
    
    value result = purchaseFuel(game, player, 2);
    
    if (is Game result) {
        assertTrue(result.playerCash(player) < playerCash, "Player's cash did not decrease.");
        assertEquals(result.playerFuel(player), 1,
            "Player's fuel did not change by expected amount.");
    }
    else {
        fail("Purchase with insufficient funds should have failed silently: ``result.message``");
    }
}

test
shared void purchaseFuelWithFullTank() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value game = testGame.with {
        phase = preRoll;
        playerCashes = { player -> runtime.maxIntegerValue };
    };
    value playerCash = game.playerCash(player);
    value playerFuel = game.playerFuel(player);
    
    assertEquals(playerFuel, game.rules.maximumFuel, "Player's fuel tank is not full.");
    assertTrue(playerCash >= fuelFee(game, player, node) * game.rules.maximumFuel,
        "Player does not have enough cash for this test.");
    
    value result = purchaseFuel(game, player, game.rules.maximumFuel);
    
    if (is Game result) {
        assertEquals(game.playerCash(player), playerCash, "Player's cash changed.");
        assertEquals(game.playerFuel(player), playerFuel, "Player's fuel changed.");
    }
    else {
        fail("Purchase with full tank should have failed silently: ``result.message``");
    }
}

test
shared void purchaseFuelWrongPhase() {
    value player = testPlayers.first.key;
    
    wrongPhaseTest((game) => purchaseFuel(game, player, 1), preRoll, postRoll);
}
