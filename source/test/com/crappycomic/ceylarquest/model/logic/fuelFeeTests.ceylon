import ceylon.test {
    assertEquals,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    testPlayers
}
import com.crappycomic.ceylarquest.model.logic {
    fuelAvailable,
    fuelFee
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame
}

"Verifies the [[fuel fee|fuelFee]] is non-zero when a different player owns the node."
test
shared void fuelFeeDifferentOwner() {
    value player = testPlayers.first.key;
    value owner = testPlayers.last.key;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value game = testGame.with {
        owners = { node -> owner };
    };
    
    assertTrue(fuelAvailable(game, node), "Fuel needs to be available for this test.");
    assertEquals(game.owner(node), owner, "Owner doesn't own the test node.");
    
    assertTrue(fuelFee(game, player, node) > 0,
        "Fuel should not be free on node owned by somebody else.");
}

"Verifies the [[fuel fee|fuelFee]] is zero when the current player owns the node."
test
shared void fuelFeeSameOwner() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value game = testGame.with {
        owners = { node -> player };
    };
    
    assertTrue(fuelAvailable(game, node), "Fuel needs to be available for this test.");
    assertEquals(game.owner(node), player, "Player doesn't own the test node.");
    
    assertEquals(fuelFee(game, player, node), 0, "Fuel should be free on self-owned node.");
}

"Verifies the [[fuel fee|fuelFee]] matches the lowest possible fee when nobody owns the node."
test
shared void fuelFeeUnowned() {
    value player = testPlayers.first.key;
    value node = tropicHopBoard.testFuelSalableNotStationable;
    value game = testGame;
    
    assertTrue(fuelAvailable(game, node), "Fuel needs to be available for this test.");
    
    assertEquals(fuelFee(game, player, node), node.fuels.first, "Unowned fuel fee didn't match.");
}
