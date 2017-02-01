import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    test
}

import com.crappycomic.ceylarquest.model {
    defaultFuelStationPrice
}
import com.crappycomic.ceylarquest.model.logic {
    nodePrice
}
import com.crappycomic.tropichop {
    tropicHopBoard
}
import test.com.crappycomic.ceylarquest.model {
    testGame
}

test
shared void testNodePrice() {
    value node = tropicHopBoard.testFuelStationable;
    
    assertFalse(testGame.placedFuelStations.contains(node), "Node already has a fuel station.");
    assertEquals(nodePrice(testGame, node), node.price, "Price without fuel station is wrong.");
    
    value game = testGame.with {
        placedFuelStations = { node };
    };
    
    assertTrue(game.placedFuelStations.contains(node), "Node didn't gain a fuel station.");
    assertEquals(nodePrice(game, node), node.price + defaultFuelStationPrice,
        "Price with fuel station is wrong.");
}
