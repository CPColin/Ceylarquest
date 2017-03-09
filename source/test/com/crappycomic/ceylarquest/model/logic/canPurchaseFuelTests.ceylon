import ceylon.test {
    assertFalse,
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
    fuelTankSpace
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes
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
    assertTrue(fuelTankSpace(canPurchaseFuelGame, canPurchaseFuelPlayer) > 0,
        "Test game was not set up properly.");
    assertTrue(canPurchaseFuel(canPurchaseFuelGame), "Test game was not set up properly.");
}

Game canPurchaseFuelGame = testGame.with {
    playerFuels = { canPurchaseFuelPlayer -> 0 };
    playerLocations = { canPurchaseFuelPlayer -> canPurchaseFuelNode };
};

Node canPurchaseFuelNode = testNodes<FuelSalable, FuelStationable>().first;

Player canPurchaseFuelPlayer = testGame.currentPlayer;
