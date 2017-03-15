import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    Ownable,
    postLand
}
import com.crappycomic.ceylarquest.model.logic {
    canPurchaseNode,
    purchaseNode
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    testNodes,
    wrongPhaseTest
}

test
shared void purchaseNodeTest() {
    value player = testGame.currentPlayer;
    value node = testNodes<Ownable>().first;
    value game = testGame.with {
        phase = postLand;
        playerLocations = { player -> node };
    };
    value playerCash = game.playerCash(player);
    
    assertTrue(canPurchaseNode(game), "The test game was not set up properly.");
    
    value result = purchaseNode(game);
    
    if (is Game result) {
        value owner = result.owner(node);
        
        assertEquals(owner, player, "Node is owned by the wrong player.");
        
        assertEquals(result.playerCash(player), playerCash - node.price,
            "Player's cash didn't decrease by the price of the node: ``node.price``.");
    }
    else {
        fail(result.message);
    }
}

test
shared void purchaseNodeWrongPhase() {
    wrongPhaseTest((game) => purchaseNode(game), postLand);
}
