import ceylon.test {
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    Node,
    unowned
}
import com.crappycomic.ceylarquest.model.logic {
    canCondemnNode
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    testPlayers
}

test
shared void canCondemnNodeFuelStationPlaced() {
    value game = canCondemnNodeGame.with {
        placedFuelStations = { canCondemnNodeNode };
    };
    
    assertFalse(canCondemnNode(game), "Placed fuel station should protect node from condemnation.");
}

test
shared void canCondemnNodeInsufficientFunds() {
    value game = canCondemnNodeGame.with {
        playerCashes = { canCondemnNodeGame.currentPlayer -> 0 };
    };
    
    assertFalse(canCondemnNode(game), "Insufficient funds should prevent condemnation.");
}

test
shared void canCondemnNodeNotFuelStationable() {
    value game = canCondemnNodeGame.with {
        playerLocations
            = { canCondemnNodeGame.currentPlayer -> testNodes<Node, FuelStationable>().first };
    };
    
    assertFalse(canCondemnNode(game),
        "Should not be able to condemn node that is not FuelStationable.");
}

test
shared void canCondemnNodeNotLowFuel() {
    value game = canCondemnNodeGame.with {
        playerFuels = { canCondemnNodeGame.currentPlayer -> runtime.maxIntegerValue };
    };
    
    assertFalse(canCondemnNode(game),
        "Should not be able to condemn node with an overflowing fuel tank.");
}

test
shared void canCondemnNodeTest() {
    assertTrue(canCondemnNode(canCondemnNodeGame),
        "The assert in the initializer should have failed already!");
}

test
shared void canCondemnNodeUnowned() {
    value game = canCondemnNodeGame.with {
        owners = { canCondemnNodeNode -> unowned };
    };
    
    assertFalse(canCondemnNode(game), "Should not be able to condemn unowned node.");
}

test
shared void canCondemnNodeWrongOwner() {
    value game = canCondemnNodeGame.with {
        owners = { canCondemnNodeNode -> canCondemnNodeGame.currentPlayer };
    };
    
    assertFalse(canCondemnNode(game), "Should not be able to condemn node owned by same player.");
}

Game canCondemnNodeGame {
    value [player, owner] = testPlayers;
    value game = testGame.with {
        currentPlayer = player;
        owners = { canCondemnNodeNode -> owner };
        playerFuels = { player -> 0 };
        playerLocations = { player -> canCondemnNodeNode };
    };
    
    assertTrue(canCondemnNode(game), "Test game was not set up properly.");
    
    return game;
}

Node canCondemnNodeNode = testNodes<FuelStationable>().first;
