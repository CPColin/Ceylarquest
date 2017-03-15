import ceylon.test {
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Node
}
import com.crappycomic.ceylarquest.model.logic {
    canPlaceFuelStation
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    testPlayers
}

test
shared void canPlaceFuelStationAlreadyPlaced() {
    value player = testGame.currentPlayer;
    value node = testNodes<FuelStationable>().first;
    value game = testGame.with {
        owners = { node -> player };
        placedFuelStations = { node };
        playerFuelStationCounts = { player -> 1 };
    };
    
    assertFalse(canPlaceFuelStation(game, node),
        "Player should not be allowed to place a fuel station where one is already placed.");
}

test
shared void canPlaceFuelStationNoFuelStationsRemaining() {
    value player = testGame.currentPlayer;
    value node = testNodes<FuelStationable>().first;
    value game = testGame.with {
        owners = { node -> player };
        playerFuelStationCounts = { player -> 0 };
    };
    
    assertFalse(canPlaceFuelStation(game, node),
        "Player should not be allowed to place a fuel station with none remaining.");
}

test
shared void canPlaceFuelStationNotFuelStationable() {
    value player = testGame.currentPlayer;
    value node = testNodes<Node, FuelStationable>().first;
    
    assertFalse(node is FuelStationable, "Node should not be FuelStationable for this test.");
    
    value game = testGame.with {
        owners = { node -> player };
        playerFuelStationCounts = { player -> 1 };
    };
    
    assertFalse(canPlaceFuelStation(game, node),
        "Player should be not allowed to place a fuel station on non-FuelStationable node.");
}

test
shared void canPlaceFuelStationTest() {
    value player = testGame.currentPlayer;
    value node = testNodes<FuelStationable>().first;
    value game = testGame.with {
        owners = { node -> player };
        playerFuelStationCounts = { player -> 1 };
    };
    
    assertTrue(canPlaceFuelStation(game, node),
        "Player should be allowed to place a fuel station.");
}

test
shared void canPlaceFuelStationWrongOwner() {
    value [player, owner] = testPlayers;
    value node = testNodes<FuelStationable>().first;
    value game = testGame.with {
        currentPlayer = player;
        owners = { node -> owner };
        playerFuelStationCounts = { player -> 1 };
    };
    
    assertFalse(canPlaceFuelStation(game, node),
        "Player should not be allowed to place a fuel station on node owned by somebody else.");
}
