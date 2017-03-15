import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Ownable
}
import com.crappycomic.ceylarquest.model.logic {
    nodePrice
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes
}

test
shared void testNodePrice() {
    value node = testNodes<Ownable&FuelStationable>().first;
    
    assertFalse(testGame.placedFuelStations.contains(node), "Node already has a fuel station.");
    assertEquals(nodePrice(testGame, node), node.price, "Price without fuel station is wrong.");
    
    value game = testGame.with {
        placedFuelStations = { node };
    };
    
    assertTrue(game.placedFuelStations.contains(node), "Node didn't gain a fuel station.");
    assertEquals(nodePrice(game, node), node.price + game.rules.fuelStationPrice,
        "Price with fuel station is wrong.");
}
