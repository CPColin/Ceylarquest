import ceylon.test {
    assertEquals,
    assertFalse,
    assertNotEquals,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelSalable,
    FuelStationable,
    Game,
    Node,
    Player
}
import com.crappycomic.ceylarquest.model.logic {
    canPurchaseFuel,
    fuelAvailable,
    fuelFee,
    fuelTankSpace,
    maximumPurchaseableFuel
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes
}

test
shared void canPurchaseFuelNoCashOwned() {
    value game = canPurchaseFuelGame.with {
        owners = { canPurchaseFuelNode -> canPurchaseFuelPlayer };
        playerCashes = { canPurchaseFuelPlayer -> 0 };
    };
    
    assertEquals(fuelFee(game, canPurchaseFuelPlayer, canPurchaseFuelNode), 0,
        "Test game was not set up properly.");
    
    assertTrue(canPurchaseFuel(game),
        "Should be able to purchase fuel with no cash when node is owned.");
}

test
shared void canPurchaseFuelNoCashUnowned() {
    value game = canPurchaseFuelGame.with {
        playerCashes = { canPurchaseFuelPlayer -> 0 };
    };
    
    assertNotEquals(fuelFee(game, canPurchaseFuelPlayer, canPurchaseFuelNode), 0,
        "Test game was not set up properly.");
    
    assertFalse(canPurchaseFuel(game), "Should not be able to purchase fuel with no cash.");
}

test
shared void canPurchaseFuelNoTankSpace() {
    value game = canPurchaseFuelGame.with {
        playerFuels = { canPurchaseFuelPlayer -> canPurchaseFuelGame.rules.maximumFuel };
    };
    
    assertFalse(fuelTankSpace(game, canPurchaseFuelPlayer) > 0,
        "Test game was not set up properly.");
    
    assertFalse(canPurchaseFuel(game),
        "Should not be able to purchase fuel when tank is full.");
}

test
shared void canPurchaseFuelNotAvailable() {
    value node = testNodes<Node, FuelSalable>().first;
    value game = canPurchaseFuelGame.with {
        playerLocations = { canPurchaseFuelPlayer -> node };
    };
    
    assertFalse(fuelAvailable(game, node), "Test game was not set up properly.");
    
    assertFalse(canPurchaseFuel(game),
        "Should not be able to purchase fuel when on a non-FuelSalable node.");
}

test
shared void canPurchaseFuelTest() {
    assertTrue(fuelAvailable(canPurchaseFuelGame, canPurchaseFuelNode),
        "Test game was not set up properly.");
    assertTrue(
        maximumPurchaseableFuel(canPurchaseFuelGame, canPurchaseFuelPlayer,
            canPurchaseFuelNode) > 0,
        "Test game was not set up properly.");
    assertTrue(canPurchaseFuel(canPurchaseFuelGame), "Test game was not set up properly.");
}

Game canPurchaseFuelGame = testGame.with {
    playerFuels = { canPurchaseFuelPlayer -> 0 };
    playerLocations = { canPurchaseFuelPlayer -> canPurchaseFuelNode };
};

FuelSalable canPurchaseFuelNode = testNodes<FuelSalable, FuelStationable>().first;

Player canPurchaseFuelPlayer = testGame.currentPlayer;
