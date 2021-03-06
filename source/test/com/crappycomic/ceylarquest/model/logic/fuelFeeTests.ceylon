import ceylon.test {
    assertEquals,
    assertTrue,
    assumeTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelSalable,
    FuelStationable,
    Ownable,
    nobody
}
import com.crappycomic.ceylarquest.model.logic {
    fuelAvailable,
    fuelFee
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    testPlayers
}

"Verifies the [[fuel fee|fuelFee]] is non-zero when a different player owns the node."
test
shared void fuelFeeDifferentOwner() {
    value [player, owner] = testPlayers;
    value node = testNodes<Ownable&FuelSalable, FuelStationable>().first;
    value game = testGame.with {
        owners = { node -> owner };
    };
    
    assertTrue(fuelAvailable(game, node), "Fuel needs to be available for this test.");
    assertEquals(game.owner(node), owner, "Owner doesn't own the test node.");
    
    assertTrue(fuelFee(game, player, node) > 0,
        "Fuel should not be free on node owned by somebody else.");
}

"Verifies the [[fuel fee|fuelFee]] matches the first possible value when the node is not
 [[Ownable]]."
test
shared void fuelFeeNotOwnable() {
    value node = testGame.board.nodes.keys
        .narrow<FuelSalable>()
        .filter((node) => !node is Ownable).first;
    
    assumeTrue(node exists);
    
    assert (exists node);
    
    assertTrue(fuelAvailable(testGame, node), "Fuel needs to be available for this test.");
    
    assertEquals(fuelFee(testGame, nobody, node), node.fuels[0],
        "Non-Ownable node should always use first fuel fee.");
    assertEquals(fuelFee(testGame, testGame.currentPlayer, node), node.fuels[0],
        "Non-Ownable node should always use first fuel fee.");
}

"Verifies the [[fuel fee|fuelFee]] is zero when the current player owns the node."
test
shared void fuelFeeSameOwner() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable&FuelSalable, FuelStationable>().first;
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
    value node = testNodes<FuelSalable, FuelStationable>().first;
    value game = testGame;
    
    assertTrue(fuelAvailable(game, node), "Fuel needs to be available for this test.");
    
    assertEquals(fuelFee(game, game.currentPlayer, node), node.fuels.first,
        "Unowned fuel fee didn't match.");
}
