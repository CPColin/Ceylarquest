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
    postLand,
    preRoll
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
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testFuelStationable;
    
    assertTrue(node is FuelStationable, "Node must be FuelStationable for this test.");
    
    value game = testGame.with {
        phase = preRoll;
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    
    assertFalse(game.placedFuelStations.contains(node), "Fuel station was unexpectedly present.");
    
    assertInvalidMove(purchaseFuel(game, 1),
        "Attempt to purchase fuel with no fuel station present should have failed.");
}

test
shared void purchaseFuelNoMoney() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value game = testGame.with {
        phase = preRoll;
        playerCashes = { player -> 0 };
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    value playerCash = game.playerCash(player);
    value playerFuel = game.playerFuel(player);
    
    assertEquals(playerCash, 0, "Player has money, but shouldn't.");
    assertEquals(playerFuel, 0, "Player's fuel tank is not empty.");
    assertTrue(fuelFee(game, player, node) > 0, "Fuel needs to cost something for this test.");
    
    assertInvalidMove(purchaseFuel(game, 1),
        "Purchase with insufficient funds should have failed.");
}

test
shared void purchaseFuelNotFuelSalable() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testNotFuelSalableOrStationable;
    
    assertFalse(node is FuelSalable, "Node can't be FuelSalable for this test.");
    
    value game = testGame.with {
        phase = preRoll;
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    
    assertInvalidMove(purchaseFuel(game, 1),
        "Purchasing fuel when node isn't FuelSalable should have failed.");
}

"Attempts to purchase two units of fuel when the player has only enough cash to purchase one unit."
test
shared void purchaseFuelSomeMoney() {
    value player = testGame.currentPlayer;
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
    
    assertInvalidMove(purchaseFuel(game, 2),
        "Purchase with insufficient funds should have failed.");
}

test
shared void purchaseFuelSuccess() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value fuelUnitFee = fuelFee(testGame, player, node);
    value fuel = 1;
    
    assertTrue(fuelUnitFee > 0, "Fuel needs to cost something for this test.");
    
    value game = testGame.with {
        phase = preRoll;
        playerCashes = { player -> fuelUnitFee * fuel };
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    value playerCash = game.playerCash(player);
    value playerFuel = game.playerFuel(player);
    
    assertEquals(playerCash, fuelUnitFee * fuel, "Player has wrong amount of money.");
    assertEquals(playerFuel, 0, "Player's fuel tank is not empty.");
    
    value result = purchaseFuel(game, fuel);
    
    if (is Game result) {
        assertEquals(result.playerCash(player), playerCash - fuelUnitFee,
            "Player's cash didn't change by expected amount.");
        assertEquals(result.playerFuel(player), playerFuel + fuel,
            "Player's fuel didn't change by the expected amount.");
    }
    else {
        fail(result.message);
    }
}

test
shared void purchaseFuelWithFullTank() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value game = testGame.with {
        phase = preRoll;
        playerCashes = { player -> runtime.maxIntegerValue };
        playerLocations = { player -> node };
    };
    value playerCash = game.playerCash(player);
    value playerFuel = game.playerFuel(player);
    
    assertEquals(playerFuel, game.rules.maximumFuel, "Player's fuel tank is not full.");
    assertTrue(playerCash >= fuelFee(game, player, node) * game.rules.maximumFuel,
        "Player does not have enough cash for this test.");
    
    assertInvalidMove(purchaseFuel(game, game.rules.maximumFuel),
        "Purchase with full tank should have failed.");
}

test
shared void purchaseFuelWrongPhase() {
    wrongPhaseTest((game) => purchaseFuel(game, 1), preRoll, postLand);
}
