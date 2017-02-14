import ceylon.test {
    assertEquals,
    assertFalse,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    Player,
    postLand
}
import com.crappycomic.ceylarquest.model.logic {
    purchaseNode
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

import test.com.crappycomic.ceylarquest.model {
    testGame,
    wrongPhaseTest
}

test
shared void purchaseNodeTest() {
    value node = tropicHopBoard.testOwnablePort;
    value game = testGame.with {
        phase = postLand;
    };
    value player = game.currentPlayer;
    value playerCash = game.playerCash(player);
    
    assertFalse(game.owner(node) is Player, "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, node);
    
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
    value node = tropicHopBoard.testOwnablePort;
    
    wrongPhaseTest((game) => purchaseNode(game, node), postLand);
}
