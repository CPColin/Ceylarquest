import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    fuelFee,
    maximumFuel,
    purchaseFuel,
    testPlayers
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

/* TODO:
 purchase fuel from an owned node that doesn't need a fuel station
 purchase fuel from an owned node that has a fuel station
   same with owner having multiple properties in the group
 purchase fuel from node owned by same player
 purchase fuel from unowned node
 attempt purchase when node can't ever sell fuel
 attempt when node has no fuel station
 attempt to overfill tank
 */

test
shared void purchaseFuelNoMoney() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testFuelSalable;
    value game = testGame.with {
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

"Attempts to purchase two units of fuel when the player has only enough cash to purchase one unit."
test
shared void purchaseFuelSomeMoney() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testFuelSalable;
    value fuelUnitFee = fuelFee(testGame, player, node);
    
    assertTrue(fuelUnitFee > 0, "Fuel needs to cost something for this test.");
    
    value game = testGame.with {
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
    value node = tropicHopBoard.testFuelSalable;
    value game = testGame.with {
        playerCashes = { player -> runtime.maxIntegerValue };
        playerFuels = { player -> maximumFuel };
    };
    value playerCash = game.playerCash(player);
    value playerFuel = game.playerFuel(player);
    
    assertTrue(playerCash >= fuelFee(game, player, node) * maximumFuel,
        "Player does not have enough cash for this test.");
    assertEquals(playerFuel, maximumFuel, "Player's fuel tank is not full.");
    
    value result = purchaseFuel(game, player, maximumFuel);
    
    if (is Game result) {
        assertEquals(game.playerCash(player), playerCash, "Player's cash changed.");
        assertEquals(game.playerFuel(player), playerFuel, "Player's fuel changed.");
    }
    else {
        fail("Purchase with full tank should have failed silently: ``result.message``");
    }
}