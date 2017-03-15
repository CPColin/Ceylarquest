import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Administration,
    Game,
    Ownable,
    nobody,
    postLand
}
import com.crappycomic.ceylarquest.model.logic {
    canSellNode,
    nodePrice,
    sellNode
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes
}

test
shared void sellNodeTest() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        owners = { node -> player };
        phase = postLand;
        playerLocations = { player -> testNodes<Administration>().first };
    };
    value playerCash = game.playerCash(player);
    
    assertTrue(canSellNode(game, node), "The test game was not set up properly.");
    
    value result = sellNode(game, node);
    
    if (is Game result) {
        assertEquals(result.owner(node), nobody, "Node should have become unowned.");
        assertEquals(result.playerCash(player), playerCash + nodePrice(game, node),
            "Player's cash did not change by expected amount.");
    }
    else {
        fail(result.message);
    }
}
