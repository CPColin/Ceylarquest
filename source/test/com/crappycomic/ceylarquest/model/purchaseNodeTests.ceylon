import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    fail,
    test
}

import com.crappycomic.ceylarquest.model {
    Game,
    Player,
    purchaseNode,
    testPlayers
}
import com.crappycomic.tropichop {
    tropicHopBoard
}

test
shared void testPurchaseOwnedNode() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = testGame.with {
        owners = { node -> player };
    };
    
    assertTrue(game.owner(node) is Player, "Node is unexpectedly not owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        fail("Purchase of node that was already owned should have failed.");
    }
}

test
shared void testPurchaseUnownableNode() {
    value node = tropicHopBoard.testUnownablePort;
    value player = testPlayers.first.key;
    value game = testGame;
    
    assertFalse(game.owner(node) is Player, "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        fail("Purchase of node that was not able to be owned should have failed.");
    }
}

test
shared void testPurchaseUnownedNode() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = testGame;
    value playerCash = game.playerCash(player);
    
    assertFalse(game.owner(node) is Player, "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        value owner = result.owners.get(node);
        
        assertTrue(owner exists);
        
        if (exists owner) {
            assertTrue(owner == player);
        }
        
        assertEquals(result.playerCash(player), playerCash - node.price,
            "Player's cash didn't decrease by the price of the node: ``node.price``.");
    }
    else {
        fail(result.message);
    }
}

test
shared void testPurchaseWithInsufficientFunds() {
    value node = tropicHopBoard.testOwnablePort;
    value player = testPlayers.first.key;
    value game = testGame.with {
        playerCashes = { player -> 0 };
    };
    
    assertFalse(game.owner(node) is Player, "Node is unexpectedly owned.");
    
    value result = purchaseNode(game, player, node);
    
    if (is Game result) {
        fail("Purchase of node with insufficient funds should have failed.");
    }
}
