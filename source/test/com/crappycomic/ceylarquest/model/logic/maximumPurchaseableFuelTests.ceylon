import ceylon.test {
    assertEquals,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model.logic {
    fuelFee,
    maximumPurchaseableFuel
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame
}

test
shared void maximumPurchaseableFuelLimitedCash() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value unitCost = fuelFee(testGame, player, node);
    
    assertTrue(unitCost > 0, "Fuel must cost something for this test.");
    
    for (fuel in 0..testGame.rules.maximumFuel) {
        value game = testGame.with {
            playerCashes = { player -> fuel * unitCost };
            playerFuels = { player -> 0 };
        };
        
        assertEquals(maximumPurchaseableFuel(game, player, node), fuel,
            "Unexpected maximum purchaseable fuel with limited cash.");
    }
}

test
shared void maximumPurchaseableFuelLimitedTank() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value unitCost = fuelFee(testGame, player, node);
    
    assertTrue(unitCost > 0, "Fuel must cost something for this test.");
    
    for (fuel in 0..testGame.rules.maximumFuel) {
        value game = testGame.with {
            playerCashes = { player -> runtime.maxIntegerValue };
            playerFuels = { player -> fuel };
        };
        
        assertEquals(maximumPurchaseableFuel(game, player, node), testGame.rules.maximumFuel - fuel,
            "Unexpected maximum purchaseable fuel with limited tank space.");
    }
}

test
shared void maximumPurchaseableFuelNoCost() {
    value player = testGame.currentPlayer;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value game1 = testGame.with {
        owners = { node -> player };
    };
    value unitCost = fuelFee(game1, player, node);
    
    assertEquals(unitCost, 0, "Fuel must be free for this test.");
    
    for (fuel in 0..testGame.rules.maximumFuel) {
        value game2 = game1.with {
            playerCashes = { player -> runtime.maxIntegerValue };
            playerFuels = { player -> fuel };
        };
        
        assertEquals(maximumPurchaseableFuel(game2, player, node), testGame.rules.maximumFuel - fuel,
            "Unexpected maximum free fuel with limited tank space.");
    }
}
