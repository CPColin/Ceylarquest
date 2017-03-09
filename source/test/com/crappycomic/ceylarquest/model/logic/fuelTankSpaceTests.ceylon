import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.ceylarquest.model.logic {
    fuelTankSpace
}

import test.com.crappycomic.ceylarquest.model {
    testGame
}

test
shared void fuelTankSpaceEmpty() {
    value player = testGame.currentPlayer;
    value game = testGame.with {
        playerFuels = { player -> 0 };
    };
    
    assertEquals(fuelTankSpace(game, player), testGame.rules.maximumFuel,
        "Empty fuel tank should have maximum space.");
}

test
shared void fuelTankSpaceFull() {
    value player = testGame.currentPlayer;
    value game = testGame.with {
        playerFuels = { player -> testGame.rules.maximumFuel };
    };
    
    assertEquals(fuelTankSpace(game, player), 0, "Full fuel tank should have no space.");
}

test
shared void fuelTankSpacePartial() {
    value player = testGame.currentPlayer;
    value expectedSpace = 20;
    value game = testGame.with {
        playerFuels = { player -> testGame.rules.maximumFuel - expectedSpace };
    };
    
    assertEquals(fuelTankSpace(game, player), expectedSpace);
}
