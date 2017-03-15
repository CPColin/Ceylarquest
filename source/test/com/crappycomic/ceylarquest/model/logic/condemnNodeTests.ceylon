import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    FuelStationable,
    Game,
    Ownable,
    PreLand
}
import com.crappycomic.ceylarquest.model.logic {
    canCondemnNode,
    condemnNode,
    nodePrice
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    testPlayers,
    wrongPhaseTest
}

test
shared void condemnNodeTest() {
    value [player, owner] = testPlayers;
    value node = testNodes<Ownable&FuelStationable>().first;
    value game = testGame.with {
        currentPlayer = player;
        owners = { node -> owner };
        phase = PreLand(true);
        playerFuels = { player -> 0 };
        playerLocations = { player -> node };
    };
    value playerCash = game.playerCash(player);
    value ownerCash = game.playerCash(owner);
    
    assertTrue(canCondemnNode(game), "Test game was not set up properly.");
    
    value result = condemnNode(game);
    
    if (is Game result) {
        assertEquals(result.owner(node), player, "Player is not the new owner of the node.");
        assertEquals(result.playerCash(player), playerCash - nodePrice(result, node),
            "Player cash did not change by expected amount.");
        assertEquals(result.playerCash(owner), ownerCash + nodePrice(result, node),
            "Owner cash did not change by expected amount.");
    }
    else {
        fail(result.message);
    }
}

test
shared void condemnNodeWrongPhase() {
    wrongPhaseTest((game) => condemnNode(game), PreLand(true));
}
